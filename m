Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33161 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbbITGwF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 02:52:05 -0400
Received: by pacex6 with SMTP id ex6so87540098pac.0
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2015 23:52:04 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 09/18] staging: wilc1000: rename WILC_WFI_frame_register
Date: Sun, 20 Sep 2015 15:51:16 +0900
Message-Id: <1442731885-4344-9-git-send-email-chaehyun.lim@gmail.com> (sfid-20150920_085218_576659_3FFBBC66)
In-Reply-To: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_frame_register with
wilc_mgmt_frame_register to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 8 ++++----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 9 ++++-----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h | 4 ++--
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index fd5cfd3..d7c28f3 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1461,10 +1461,10 @@ int mac_open(struct net_device *ndev)
 		goto _err_;
 	}
 
-	WILC_WFI_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy, nic->wilc_netdev->ieee80211_ptr,
-				nic->g_struct_frame_reg[0].frame_type, nic->g_struct_frame_reg[0].reg);
-	WILC_WFI_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy, nic->wilc_netdev->ieee80211_ptr,
-				nic->g_struct_frame_reg[1].frame_type, nic->g_struct_frame_reg[1].reg);
+	wilc_mgmt_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy, nic->wilc_netdev->ieee80211_ptr,
+				 nic->g_struct_frame_reg[0].frame_type, nic->g_struct_frame_reg[0].reg);
+	wilc_mgmt_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy, nic->wilc_netdev->ieee80211_ptr,
+				 nic->g_struct_frame_reg[1].frame_type, nic->g_struct_frame_reg[1].reg);
 	netif_wake_queue(ndev);
 	g_linux_wlan->open_ifcs++;
 	nic->mac_opened = 1;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index bf9d9ee..c8e286d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2541,7 +2541,7 @@ int mgmt_tx_cancel_wait(struct wiphy *wiphy,
 }
 
 /**
- *  @brief      WILC_WFI_frame_register
+ *  @brief      wilc_mgmt_frame_register
  *  @details Notify driver that a management frame type was
  *              registered. Note that this callback may not sleep, and cannot run
  *                      concurrently with itself.
@@ -2551,9 +2551,8 @@ int mgmt_tx_cancel_wait(struct wiphy *wiphy,
  *  @date	01 JUL 2012
  *  @version
  */
-void    WILC_WFI_frame_register(struct wiphy *wiphy,
-				struct wireless_dev *wdev,
-				u16 frame_type, bool reg)
+void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
+			      u16 frame_type, bool reg)
 {
 
 	struct wilc_priv *priv;
@@ -3416,7 +3415,7 @@ static struct cfg80211_ops wilc_cfg80211_ops = {
 	.cancel_remain_on_channel = cancel_remain_on_channel,
 	.mgmt_tx_cancel_wait = mgmt_tx_cancel_wait,
 	.mgmt_tx = mgmt_tx,
-	.mgmt_frame_register = WILC_WFI_frame_register,
+	.mgmt_frame_register = wilc_mgmt_frame_register,
 	.set_power_mgmt = WILC_WFI_set_power_mgmt,
 	.set_cqm_rssi_config = WILC_WFI_set_cqm_rssi_config,
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index 0bd23b4..4730128 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -100,8 +100,8 @@ int WILC_WFI_InitHostInt(struct net_device *net);
 void WILC_WFI_monitor_rx(u8 *buff, u32 size);
 int WILC_WFI_deinit_mon_interface(void);
 struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_device *real_dev);
-void WILC_WFI_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
-			     u16 frame_type, bool reg);
+void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
+			      u16 frame_type, bool reg);
 
 #define TCP_ACK_FILTER_LINK_SPEED_THRESH	54
 #define DEFAULT_LINK_SPEED			72
-- 
2.5.1

