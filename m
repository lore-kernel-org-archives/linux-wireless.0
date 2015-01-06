Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:43680 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbbAFNjV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 08:39:21 -0500
Received: by mail-qg0-f42.google.com with SMTP id q108so16937647qgd.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2015 05:39:20 -0800 (PST)
From: Ido Yariv <ido@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	Ido Yariv <idox.yariv@intel.com>,
	Christopher Chavez <chrischavez@gmx.us>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH] mac80211: Re-fix accounting of the tailroom-needed counter
Date: Tue,  6 Jan 2015 08:39:02 -0500
Message-Id: <1420551542-21981-1-git-send-email-ido@wizery.com> (sfid-20150106_143924_606391_BE5D8807)
In-Reply-To: <54AACA29.3060709@lwfinger.net>
References: <54AACA29.3060709@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When hw acceleration is enabled, the GENERATE_IV or PUT_IV_SPACE flags
only require headroom space. Therefore, the tailroom-needed counter can
safely be decremented for most drivers.

The older incarnation of this patch (ca34e3b5) assumed that the above
holds true for all drivers. As reported by Christopher Chavez and
researched by Christian Lamparter and Larry Finger, this isn't a valid
assumption for p54 and cw1200.

Drivers that still require tailroom for ICV/MIC even when HW encryption
is enabled can use IEEE80211_KEY_FLAG_RESERVE_TAILROOM to indicate it.

Signed-off-by: Ido Yariv <idox.yariv@intel.com>
Cc: Christopher Chavez <chrischavez@gmx.us>
Cc: Christian Lamparter <chunkeey@googlemail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/net/wireless/cw1200/sta.c |  3 ++-
 drivers/net/wireless/p54/main.c   |  2 ++
 include/net/mac80211.h            | 11 +++++++++--
 net/mac80211/key.c                |  9 +++------
 4 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/cw1200/sta.c b/drivers/net/wireless/cw1200/sta.c
index 5b84664..b96524c 100644
--- a/drivers/net/wireless/cw1200/sta.c
+++ b/drivers/net/wireless/cw1200/sta.c
@@ -708,7 +708,8 @@ int cw1200_set_key(struct ieee80211_hw *dev, enum set_key_cmd cmd,
 		if (sta)
 			peer_addr = sta->addr;
 
-		key->flags |= IEEE80211_KEY_FLAG_PUT_IV_SPACE;
+		key->flags |= IEEE80211_KEY_FLAG_PUT_IV_SPACE |
+			      IEEE80211_KEY_FLAG_RESERVE_TAILROOM;
 
 		switch (key->cipher) {
 		case WLAN_CIPHER_SUITE_WEP40:
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 97aeff0..13a30c4 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -575,6 +575,8 @@ static int p54_set_key(struct ieee80211_hw *dev, enum set_key_cmd cmd,
 			key->hw_key_idx = 0xff;
 			goto out_unlock;
 		}
+
+		key->flags |= IEEE80211_KEY_FLAG_RESERVE_TAILROOM;
 	} else {
 		slot = key->hw_key_idx;
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a9de1da..e6a8015 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1227,7 +1227,8 @@ struct ieee80211_vif *wdev_to_ieee80211_vif(struct wireless_dev *wdev);
  *
  * @IEEE80211_KEY_FLAG_GENERATE_IV: This flag should be set by the
  *	driver to indicate that it requires IV generation for this
- *	particular key.
+ *	particular key. Setting this flag does not necessarily mean that SKBs
+ *	will have sufficient tailroom for ICV or MIC.
  * @IEEE80211_KEY_FLAG_GENERATE_MMIC: This flag should be set by
  *	the driver for a TKIP key if it requires Michael MIC
  *	generation in software.
@@ -1239,7 +1240,9 @@ struct ieee80211_vif *wdev_to_ieee80211_vif(struct wireless_dev *wdev);
  * @IEEE80211_KEY_FLAG_PUT_IV_SPACE: This flag should be set by the driver
  *	if space should be prepared for the IV, but the IV
  *	itself should not be generated. Do not set together with
- *	@IEEE80211_KEY_FLAG_GENERATE_IV on the same key.
+ *	@IEEE80211_KEY_FLAG_GENERATE_IV on the same key. Setting this flag does
+ *	not necessarily mean that SKBs will have sufficient tailroom for ICV or
+ *	MIC.
  * @IEEE80211_KEY_FLAG_RX_MGMT: This key will be used to decrypt received
  *	management frames. The flag can help drivers that have a hardware
  *	crypto implementation that doesn't deal with management frames
@@ -1250,6 +1253,9 @@ struct ieee80211_vif *wdev_to_ieee80211_vif(struct wireless_dev *wdev);
  * @IEEE80211_KEY_FLAG_GENERATE_IV_MGMT: This flag should be set by the
  *	driver for a CCMP key to indicate that is requires IV generation
  *	only for managment frames (MFP).
+ * @IEEE80211_KEY_FLAG_RESERVE_TAILROOM: This flag should be set by the
+ *	driver for a key to indicate that sufficient tailroom must always
+ *	be reserved for ICV or MIC, even when HW encryption is enabled.
  */
 enum ieee80211_key_flags {
 	IEEE80211_KEY_FLAG_GENERATE_IV_MGMT	= BIT(0),
@@ -1259,6 +1265,7 @@ enum ieee80211_key_flags {
 	IEEE80211_KEY_FLAG_SW_MGMT_TX		= BIT(4),
 	IEEE80211_KEY_FLAG_PUT_IV_SPACE		= BIT(5),
 	IEEE80211_KEY_FLAG_RX_MGMT		= BIT(6),
+	IEEE80211_KEY_FLAG_RESERVE_TAILROOM	= BIT(7),
 };
 
 /**
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index bb8e697..88614c7 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -132,8 +132,7 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
 
 		if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
-		      (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) ||
-		      (key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)))
+		      (key->conf.flags & IEEE80211_KEY_FLAG_RESERVE_TAILROOM)))
 			sdata->crypto_tx_tailroom_needed_cnt--;
 
 		WARN_ON((key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE) &&
@@ -182,8 +181,7 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 	sdata = key->sdata;
 
 	if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
-	      (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) ||
-	      (key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)))
+	      (key->conf.flags & IEEE80211_KEY_FLAG_RESERVE_TAILROOM)))
 		increment_tailroom_need_count(sdata);
 
 	ret = drv_set_key(key->local, DISABLE_KEY, sdata,
@@ -880,8 +878,7 @@ void ieee80211_remove_key(struct ieee80211_key_conf *keyconf)
 		key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
 
 		if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
-		      (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) ||
-		      (key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)))
+		      (key->conf.flags & IEEE80211_KEY_FLAG_RESERVE_TAILROOM)))
 			increment_tailroom_need_count(key->sdata);
 	}
 
-- 
2.1.0

