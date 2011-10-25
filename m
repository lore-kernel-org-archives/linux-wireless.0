Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2786 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933413Ab1JYOFl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 10:05:41 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 13/31] ath6kl: Move disconnect timer to vif structure
Date: Tue, 25 Oct 2011 19:34:08 +0530
Message-ID: <1319551466-29070-14-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_160544_157582_8C1B1100)
In-Reply-To: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    9 ++++-----
 drivers/net/wireless/ath/ath6kl/core.h     |    2 +-
 drivers/net/wireless/ath/ath6kl/main.c     |    4 ++--
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 5959c84..d55c396 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -479,7 +479,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	if ((!(ar->connect_ctrl_flags & CONNECT_DO_WPA_OFFLOAD)) &&
 	    ((vif->auth_mode == WPA_PSK_AUTH)
 	     || (vif->auth_mode == WPA2_PSK_AUTH))) {
-		mod_timer(&ar->disconnect_timer,
+		mod_timer(&vif->disconnect_timer,
 			  jiffies + msecs_to_jiffies(DISCON_TIMER_INTVAL));
 	}
 
@@ -897,7 +897,7 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 	if (((vif->auth_mode == WPA_PSK_AUTH)
 	     || (vif->auth_mode == WPA2_PSK_AUTH))
 	    && (key_usage & GROUP_USAGE))
-		del_timer(&ar->disconnect_timer);
+		del_timer(&vif->disconnect_timer);
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
 		   "%s: index %d, key_len %d, key_type 0x%x, key_usage 0x%x, seq_len %d\n",
@@ -2061,16 +2061,15 @@ int ath6kl_register_ieee80211_hw(struct ath6kl *ar)
 
 static int ath6kl_init_if_data(struct ath6kl_vif *vif)
 {
-	struct ath6kl *ar = vif->ar;
-
 	vif->aggr_cntxt = aggr_init(vif->ndev);
 	if (!vif->aggr_cntxt) {
 		ath6kl_err("failed to initialize aggr\n");
 		return -ENOMEM;
 	}
 
-	setup_timer(&ar->disconnect_timer, disconnect_timer_handler,
+	setup_timer(&vif->disconnect_timer, disconnect_timer_handler,
 		    (unsigned long) vif->ndev);
+	set_bit(WMM_ENABLED, &vif->flags);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index f15dd6d..5403116 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -416,6 +416,7 @@ struct ath6kl_vif {
 	struct ath6kl_wep_key wep_key_list[WMI_MAX_KEY_INDEX + 1];
 	struct ath6kl_key keys[WMI_MAX_KEY_INDEX + 1];
 	struct aggr_info *aggr_cntxt;
+	struct timer_list disconnect_timer;
 };
 
 /* Flag info */
@@ -477,7 +478,6 @@ struct ath6kl {
 	struct wmi_ap_mode_stat ap_stats;
 	u8 ap_country_code[3];
 	struct list_head amsdu_rx_buffer_queue;
-	struct timer_list disconnect_timer;
 	u8 rx_meta_ver;
 	struct wireless_dev *wdev;
 	struct cfg80211_scan_request *scan_req;
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 0bdb73c..d292e17 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -445,7 +445,7 @@ void ath6kl_stop_endpoint(struct net_device *dev, bool keep_profile,
 		if (!keep_profile)
 			ath6kl_init_profile_info(ar);
 
-		del_timer(&ar->disconnect_timer);
+		del_timer(&vif->disconnect_timer);
 
 		clear_bit(WMI_READY, &ar->flag);
 		ath6kl_wmi_shutdown(ar->wmi);
@@ -1396,7 +1396,7 @@ void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason, u8 *bssid,
 
 	aggr_reset_state(vif->aggr_cntxt);
 
-	del_timer(&ar->disconnect_timer);
+	del_timer(&vif->disconnect_timer);
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CONNECT,
 		   "disconnect reason is %d\n", reason);
-- 
1.7.0.4

