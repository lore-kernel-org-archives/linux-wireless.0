Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21167 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab1LBJdY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 04:33:24 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl: Inform bss information to cfg80211 before connect event
Date: Fri, 2 Dec 2011 15:06:59 +0530
Message-ID: <1322818619-29265-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111202_103331_016459_C5F21A26)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is already done but only when bss entry is not availabe
or aged out. Not updating the bss information when that bss
is available creates a case where there is a bss entry when
checked in ath6kl_cfg80211_connect_event() but it got aged out
by the time cfg80211 checks for the bss entry in __cfg80211_roamed().
This results in the following warning and the failure to notify
roaming event to application. To fix this, update the bss information
for which a romaing event is received. Also renamed ath6kl_add_bss_if_needed()
to ath6kl_inform_bss().

[158645.538384] WARNING: at net/wireless/sme.c:586
__cfg80211_roamed+0xc2/0x1b1()
[158645.538810] Call Trace:
[158645.538838]  [<c1033527>] warn_slowpath_common+0x65/0x7a
[158645.538917]  [<c14cfacf>] ? __cfg80211_roamed+0xc2/0x1b1
[158645.538946]  [<c103354b>] warn_slowpath_null+0xf/0x13
[158645.539055]  [<c14cfacf>] __cfg80211_roamed+0xc2/0x1b1
[158645.539086]  [<c14beb5b>] cfg80211_process_rdev_events+0x153/0x1cc
[158645.539166]  [<c14bd57b>] cfg80211_event_work+0x26/0x36
[158645.539195]  [<c10482ae>] process_one_work+0x219/0x38b
[158645.539273]  [<c14bd555>] ? wiphy_new+0x419/0x419
[158645.539301]  [<c10486cb>] worker_thread+0xf6/0x1bf
[158645.539379]  [<c10485d5>] ? rescuer_thread+0x1b5/0x1b5
[158645.539407]  [<c104b3e2>] kthread+0x62/0x67
[158645.539484]  [<c104b380>] ? __init_kthread_worker+0x42/0x42
[158645.539514]  [<c151309a>] kernel_thread_helper+0x6/0xd

Reported-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   67 ++++++++++++---------------
 1 files changed, 30 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index aa93527..fcd9b28 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -568,11 +568,11 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
-static int ath6kl_add_bss_if_needed(struct ath6kl_vif *vif,
-				    enum network_type nw_type,
-				    const u8 *bssid,
-				    struct ieee80211_channel *chan,
-				    const u8 *beacon_ie, size_t beacon_ie_len)
+static int ath6kl_inform_bss(struct ath6kl_vif *vif,
+			     enum network_type nw_type,
+			     const u8 *bssid,
+			     struct ieee80211_channel *chan,
+			     const u8 *beacon_ie, size_t beacon_ie_len)
 {
 	struct ath6kl *ar = vif->ar;
 	struct cfg80211_bss *bss;
@@ -587,36 +587,29 @@ static int ath6kl_add_bss_if_needed(struct ath6kl_vif *vif,
 		cap_val = WLAN_CAPABILITY_ESS;
 	}
 
-	bss = cfg80211_get_bss(ar->wiphy, chan, bssid,
-			       vif->ssid, vif->ssid_len,
-			       cap_mask, cap_val);
-	if (bss == NULL) {
-		/*
-		 * Since cfg80211 may not yet know about the BSS,
-		 * generate a partial entry until the first BSS info
-		 * event becomes available.
-		 *
-		 * Prepend SSID element since it is not included in the Beacon
-		 * IEs from the target.
-		 */
-		ie = kmalloc(2 + vif->ssid_len + beacon_ie_len, GFP_KERNEL);
-		if (ie == NULL)
-			return -ENOMEM;
-		ie[0] = WLAN_EID_SSID;
-		ie[1] = vif->ssid_len;
-		memcpy(ie + 2, vif->ssid, vif->ssid_len);
-		memcpy(ie + 2 + vif->ssid_len, beacon_ie, beacon_ie_len);
-		bss = cfg80211_inform_bss(ar->wiphy, chan,
-					  bssid, 0, cap_val, 100,
-					  ie, 2 + vif->ssid_len + beacon_ie_len,
-					  0, GFP_KERNEL);
-		if (bss)
-			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "added bss %pM to "
-				   "cfg80211\n", bssid);
-		kfree(ie);
-	} else
-		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "cfg80211 already has a bss "
-			   "entry\n");
+	/*
+	 * Since cfg80211 may not yet know about the BSS,
+	 * generate a partial entry until the first BSS info
+	 * event becomes available.
+	 *
+	 * Prepend SSID element since it is not included in the Beacon
+	 * IEs from the target.
+	 */
+	ie = kmalloc(2 + vif->ssid_len + beacon_ie_len, GFP_KERNEL);
+	if (ie == NULL)
+		return -ENOMEM;
+	ie[0] = WLAN_EID_SSID;
+	ie[1] = vif->ssid_len;
+	memcpy(ie + 2, vif->ssid, vif->ssid_len);
+	memcpy(ie + 2 + vif->ssid_len, beacon_ie, beacon_ie_len);
+	bss = cfg80211_inform_bss(ar->wiphy, chan,
+			bssid, 0, cap_val, 100,
+			ie, 2 + vif->ssid_len + beacon_ie_len,
+			0, GFP_KERNEL);
+	if (bss)
+		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
+			   "added/updated bss %pM to cfg80211\n", bssid);
+	kfree(ie);
 
 	if (bss == NULL)
 		return -ENOMEM;
@@ -675,8 +668,8 @@ void ath6kl_cfg80211_connect_event(struct ath6kl_vif *vif, u16 channel,
 
 	chan = ieee80211_get_channel(ar->wiphy, (int) channel);
 
-	if (ath6kl_add_bss_if_needed(vif, nw_type, bssid, chan, assoc_info,
-				     beacon_ie_len) < 0) {
+	if (ath6kl_inform_bss(vif, nw_type, bssid, chan, assoc_info,
+			      beacon_ie_len) < 0) {
 		ath6kl_err("could not add cfg80211 bss entry\n");
 		return;
 	}
-- 
1.7.0.4

