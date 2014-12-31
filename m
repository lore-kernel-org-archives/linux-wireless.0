Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:37538 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaLaKTn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2014 05:19:43 -0500
Received: by mail-wi0-f171.google.com with SMTP id bs8so25268898wib.16
        for <linux-wireless@vger.kernel.org>; Wed, 31 Dec 2014 02:19:42 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	chrischavez@gmx.us, pizza@shaftnet.org, johannes@sipsolutions.net
Subject: [PATCH 3.17 1/3] mac80211: add feature flag to enable resizing of outgoing frames for encryption
Date: Wed, 31 Dec 2014 11:19:39 +0100
Message-ID: <2051417.66dkbc7KnO@debian64> (sfid-20141231_112049_159376_52BCF595)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The  patch  "mac80211: Fix accounting of the tailroom-needed counter"
reduced the overhead associated with unnecessary resizing of outgoing
frames. Unfortunately this change  broke the assumption that there is
always enough tailroom for the MIC. This in turn caused p54* to panic
when it tried to prepare  outgoing frames for hardware-offloaded CCMP
connections.

Cc: stable@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>
Bugzilla: <https://bugzilla.kernel.org/show_bug.cgi?id=90331>
Reported-by: Christopher Chavez <chrischavez@gmx.us>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 include/net/mac80211.h | 13 ++++++++++---
 net/mac80211/key.c     |  9 ++++++---
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 58d719d..c04ac04 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1270,8 +1270,11 @@ struct ieee80211_vif *wdev_to_ieee80211_vif(struct wireless_dev *wdev);
  *
  * @IEEE80211_KEY_FLAG_GENERATE_IV: This flag should be set by the
  *	driver to indicate that it requires IV generation for this
- *	particular key. Setting this flag does not necessarily mean that SKBs
- *	will have sufficient tailroom for ICV or MIC.
+ *	particular key. Setting this flag does not mean that SKBs will
+ *	have sufficient tailroom for ICV or MIC. If additional tailroom
+ *	tailroom needs to be reserved for the ICV or MIC, the driver
+ *	should also set the hardware feature flag:
+ *      %IEEE80211_HW_TAILROOM_CRYPTO.
  * @IEEE80211_KEY_FLAG_GENERATE_MMIC: This flag should be set by
  *	the driver for a TKIP key if it requires Michael MIC
  *	generation in software.
@@ -1583,6 +1586,10 @@ struct ieee80211_tx_control {
  * @IEEE80211_HW_MFP_CAPABLE:
  *	Hardware supports management frame protection (MFP, IEEE 802.11w).
  *
+ * @IEEE80211_HW_TAILROOM_CRYPTO: The driver would like to have sufficient
+ *	tailroom for ICV or MIC for outgoing frames in order to perform
+ *	hardware encryption without any additional resizing overhead.
+ *
  * @IEEE80211_HW_SUPPORTS_UAPSD:
  *	Hardware supports Unscheduled Automatic Power Save Delivery
  *	(U-APSD) in managed mode. The mode is configured with
@@ -1673,7 +1680,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_MFP_CAPABLE			= 1<<13,
 	IEEE80211_HW_WANT_MONITOR_VIF			= 1<<14,
 	IEEE80211_HW_NO_AUTO_VIF			= 1<<15,
-	/* free slot */
+	IEEE80211_HW_TAILROOM_CRYPTO			= 1<<16,
 	IEEE80211_HW_SUPPORTS_UAPSD			= 1<<17,
 	IEEE80211_HW_REPORTS_TX_ACK_STATUS		= 1<<18,
 	IEEE80211_HW_CONNECTION_MONITOR			= 1<<19,
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 0bb7038..c3e9a9a 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -140,7 +140,8 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 	if (!ret) {
 		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
 
-		if (!(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC))
+		if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
+		      (key->local->hw.flags & IEEE80211_HW_TAILROOM_CRYPTO)))
 			sdata->crypto_tx_tailroom_needed_cnt--;
 
 		WARN_ON((key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE) &&
@@ -188,7 +189,8 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 	sta = key->sta;
 	sdata = key->sdata;
 
-	if (!(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC))
+	if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
+	      (key->local->hw.flags & IEEE80211_HW_TAILROOM_CRYPTO)))
 		increment_tailroom_need_count(sdata);
 
 	ret = drv_set_key(key->local, DISABLE_KEY, sdata,
@@ -884,7 +886,8 @@ void ieee80211_remove_key(struct ieee80211_key_conf *keyconf)
 	if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
 		key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
 
-		if (!(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC))
+		if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
+		      (key->local->hw.flags & IEEE80211_HW_TAILROOM_CRYPTO)))
 			increment_tailroom_need_count(key->sdata);
 	}
 
-- 
2.1.4

