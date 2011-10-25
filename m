Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6757 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab1JYKNJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 06:13:09 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <nataraja@qca.qualcomm.com>,
	<athiruve@qca.qualcomm.com>
Subject: [PATCH 13/34] ath6kl: Move disconnect timer to vif structure
Date: Tue, 25 Oct 2011 15:40:09 +0530
Message-ID: <1319537430-12459-14-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_122050_085648_93D81512)
In-Reply-To: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    6 +++---
 drivers/net/wireless/ath/ath6kl/core.h     |    2 +-
 drivers/net/wireless/ath/ath6kl/main.c     |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 1e33e79..dacad7a 100644
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
@@ -2069,7 +2069,7 @@ static int ath6kl_init_if_data(struct ath6kl *ar, struct net_device *ndev)
 		return -ENOMEM;
 	}
 
-	setup_timer(&ar->disconnect_timer, disconnect_timer_handler,
+	setup_timer(&vif->disconnect_timer, disconnect_timer_handler,
 		    (unsigned long) ndev);
 	set_bit(WMM_ENABLED, &vif->flags);
 
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index cef4251..c2e0269 100644
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
index 48a7e57..6dbced0 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -445,7 +445,7 @@ void ath6kl_stop_endpoint(struct net_device *dev, bool keep_profile,
 		if (!keep_profile)
 			ath6kl_init_profile_info(ar);
 
-		del_timer(&ar->disconnect_timer);
+		del_timer(&vif->disconnect_timer);
 
 		clear_bit(WMI_READY, &ar->flag);
 		ath6kl_wmi_shutdown(ar->wmi);
@@ -1115,7 +1115,7 @@ void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason, u8 *bssid,
 
 	aggr_reset_state(vif->aggr_cntxt);
 
-	del_timer(&ar->disconnect_timer);
+	del_timer(&vif->disconnect_timer);
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "disconnect reason is %d\n", reason);
 
-- 
1.7.0.4

