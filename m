Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35592 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab1KILfp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 06:35:45 -0500
From: Raja Mani <rmani@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Fix call trace while starting IBSS mode
Date: Wed, 9 Nov 2011 17:02:23 +0530
Message-ID: <1320838343-5708-1-git-send-email-rmani@qca.qualcomm.com> (sfid-20111109_123555_975762_CDF460FC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the connect event is received from the target in IBSS mode,
cfg80211_ibss_joined() is called without informing BSS info to
cfg80211 layer which internally hits the below WARN_ON message.

WARNING: at net/wireless/ibss.c:33 __cfg80211_ibss_joined+0x153/0x180 [cfg80211]()
[..]
[ 4916.845878] Call Trace:
[ 4916.845889]  [<c10427d2>] warn_slowpath_common+0x72/0xa0
[ 4916.845905]  [<f8bccc63>] ? __cfg80211_ibss_joined+0x153/0x180 [cfg80211]
[ 4916.845918]  [<f8bccc63>] ? __cfg80211_ibss_joined+0x153/0x180 [cfg80211]
[ 4916.845923]  [<c1042822>] warn_slowpath_null+0x22/0x30
[ 4916.845934]  [<f8bccc63>] __cfg80211_ibss_joined+0x153/0x180 [cfg80211]
[ 4916.845941]  [<c1025108>] ? default_spin_lock_flags+0x8/0x10
[ 4916.845952]  [<f8bb7fcd>] cfg80211_process_rdev_events+0x19d/0x220 [cfg80211]
[ 4916.845962]  [<f8bb669b>] cfg80211_event_work+0x2b/0x50 [cfg80211]
[ 4916.845968]  [<c105aae6>] process_one_work+0x116/0x3c0
[ 4916.845977]  [<f8bb6670>] ? cfg80211_get_dev_from_info+0x40/0x40 [cfg80211]
[ 4916.845982]  [<c105cdf0>] worker_thread+0x140/0x3b0
[ 4916.845986]  [<c105ccb0>] ? manage_workers+0x1f0/0x1f0
[ 4916.845991]  [<c1060c64>] kthread+0x74/0x80
[ 4916.845995]  [<c1060bf0>] ? kthread_worker_fn+0x160/0x160
[ 4916.846001]  [<c14e7bbe>] kernel_thread_helper+0x6/0x10
[ 4916.846005] ---[ end trace 769254924e409367 ]---

This patch make sures that BSS info is delivered via cfg80211_inform_bss()
to cfg80211 in advance before intimating IBSS status to cfg80211.

In addition to this, one debug message is also added to know
ad-hoc mode status (creator/joiner).

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   38 +++++++++++++++++----------
 1 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 603dbda..6da5c9e 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -561,17 +561,28 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
-static int ath6kl_add_bss_if_needed(struct ath6kl_vif *vif, const u8 *bssid,
+static int ath6kl_add_bss_if_needed(struct ath6kl_vif *vif,
+				    enum network_type nw_type,
+				    const u8 *bssid,
 				    struct ieee80211_channel *chan,
 				    const u8 *beacon_ie, size_t beacon_ie_len)
 {
 	struct ath6kl *ar = vif->ar;
 	struct cfg80211_bss *bss;
+	u16 cap_mask, cap_val;
 	u8 *ie;
 
+	if (nw_type & ADHOC_NETWORK) {
+		cap_mask = WLAN_CAPABILITY_IBSS;
+		cap_val = WLAN_CAPABILITY_IBSS;
+	} else {
+		cap_mask = WLAN_CAPABILITY_ESS;
+		cap_val = WLAN_CAPABILITY_ESS;
+	}
+
 	bss = cfg80211_get_bss(ar->wiphy, chan, bssid,
-			       vif->ssid, vif->ssid_len, WLAN_CAPABILITY_ESS,
-			       WLAN_CAPABILITY_ESS);
+			       vif->ssid, vif->ssid_len,
+			       cap_mask, cap_val);
 	if (bss == NULL) {
 		/*
 		 * Since cfg80211 may not yet know about the BSS,
@@ -589,13 +600,12 @@ static int ath6kl_add_bss_if_needed(struct ath6kl_vif *vif, const u8 *bssid,
 		memcpy(ie + 2, vif->ssid, vif->ssid_len);
 		memcpy(ie + 2 + vif->ssid_len, beacon_ie, beacon_ie_len);
 		bss = cfg80211_inform_bss(ar->wiphy, chan,
-					  bssid, 0, WLAN_CAPABILITY_ESS, 100,
+					  bssid, 0, cap_val, 100,
 					  ie, 2 + vif->ssid_len + beacon_ie_len,
 					  0, GFP_KERNEL);
 		if (bss)
-			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "added dummy bss for "
-				   "%pM prior to indicating connect/roamed "
-				   "event\n", bssid);
+			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "added bss %pM to "
+				   "cfg80211\n", bssid);
 		kfree(ie);
 	} else
 		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "cfg80211 already has a bss "
@@ -658,16 +668,16 @@ void ath6kl_cfg80211_connect_event(struct ath6kl_vif *vif, u16 channel,
 
 	chan = ieee80211_get_channel(ar->wiphy, (int) channel);
 
-
-	if (nw_type & ADHOC_NETWORK) {
-		cfg80211_ibss_joined(vif->ndev, bssid, GFP_KERNEL);
+	if (ath6kl_add_bss_if_needed(vif, nw_type, bssid, chan, assoc_info,
+				     beacon_ie_len) < 0) {
+		ath6kl_err("could not add cfg80211 bss entry\n");
 		return;
 	}
 
-	if (ath6kl_add_bss_if_needed(vif, bssid, chan, assoc_info,
-				     beacon_ie_len) < 0) {
-		ath6kl_err("could not add cfg80211 bss entry for "
-			   "connect/roamed notification\n");
+	if (nw_type & ADHOC_NETWORK) {
+		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "ad-hoc %s selected\n",
+			   nw_type & ADHOC_CREATOR ? "creator" : "joiner");
+		cfg80211_ibss_joined(vif->ndev, bssid, GFP_KERNEL);
 		return;
 	}
 
-- 
1.7.0.4

