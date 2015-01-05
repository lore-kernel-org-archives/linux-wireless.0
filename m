Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53308 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550AbbAEJcA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2015 04:32:00 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ido Yariv <idox.yariv@intel.com>,
	Christopher Chavez <chrischavez@gmx.us>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] Revert "mac80211: Fix accounting of the tailroom-needed counter"
Date: Mon,  5 Jan 2015 10:31:55 +0100
Message-Id: <1420450315-8750-1-git-send-email-johannes@sipsolutions.net> (sfid-20150105_103232_506966_BC1A450F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This reverts commit ca34e3b5c808385b175650605faa29e71e91991b.

It turns out that the p54 and cw2100 drivers assume that there's
tailroom even when they don't say they really need it. However,
there's currently no way for them to explicitly say they do need
it, so for now revert this.

Cc: stable@vger.kernel.org
Fixes: ca34e3b5c808 ("mac80211: Fix accounting of the tailroom-needed counter")
Reported-by: Christopher Chavez <chrischavez@gmx.us>
Bisected-by: Larry Finger <Larry.Finger@lwfinger.net>
Debugged-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |  7 ++-----
 net/mac80211/key.c     | 12 +++++++++---
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 58d719ddaa60..29c7be8808d5 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1270,8 +1270,7 @@ struct ieee80211_vif *wdev_to_ieee80211_vif(struct wireless_dev *wdev);
  *
  * @IEEE80211_KEY_FLAG_GENERATE_IV: This flag should be set by the
  *	driver to indicate that it requires IV generation for this
- *	particular key. Setting this flag does not necessarily mean that SKBs
- *	will have sufficient tailroom for ICV or MIC.
+ *	particular key.
  * @IEEE80211_KEY_FLAG_GENERATE_MMIC: This flag should be set by
  *	the driver for a TKIP key if it requires Michael MIC
  *	generation in software.
@@ -1283,9 +1282,7 @@ struct ieee80211_vif *wdev_to_ieee80211_vif(struct wireless_dev *wdev);
  * @IEEE80211_KEY_FLAG_PUT_IV_SPACE: This flag should be set by the driver
  *	if space should be prepared for the IV, but the IV
  *	itself should not be generated. Do not set together with
- *	@IEEE80211_KEY_FLAG_GENERATE_IV on the same key. Setting this flag does
- *	not necessarily mean that SKBs will have sufficient tailroom for ICV or
- *	MIC.
+ *	@IEEE80211_KEY_FLAG_GENERATE_IV on the same key.
  * @IEEE80211_KEY_FLAG_RX_MGMT: This key will be used to decrypt received
  *	management frames. The flag can help drivers that have a hardware
  *	crypto implementation that doesn't deal with management frames
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 0bb7038121ac..bd4e46ec32bd 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -140,7 +140,9 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 	if (!ret) {
 		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
 
-		if (!(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC))
+		if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
+		      (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) ||
+		      (key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)))
 			sdata->crypto_tx_tailroom_needed_cnt--;
 
 		WARN_ON((key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE) &&
@@ -188,7 +190,9 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 	sta = key->sta;
 	sdata = key->sdata;
 
-	if (!(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC))
+	if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
+	      (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) ||
+	      (key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)))
 		increment_tailroom_need_count(sdata);
 
 	ret = drv_set_key(key->local, DISABLE_KEY, sdata,
@@ -884,7 +888,9 @@ void ieee80211_remove_key(struct ieee80211_key_conf *keyconf)
 	if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
 		key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
 
-		if (!(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC))
+		if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
+		      (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) ||
+		      (key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)))
 			increment_tailroom_need_count(key->sdata);
 	}
 
-- 
2.1.1

