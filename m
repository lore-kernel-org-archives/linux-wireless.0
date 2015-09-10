Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33835 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbbIJTQJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 15:16:09 -0400
Received: by padhy16 with SMTP id hy16so50974133pad.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 12:16:09 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 29/31] staging: wilc1000: rename WILC_WFI_frame_register
Date: Fri, 11 Sep 2015 04:14:28 +0900
Message-Id: <1441912470-3371-29-git-send-email-chaehyun.lim@gmail.com> (sfid-20150910_211853_698948_11E42C0D)
In-Reply-To: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441912470-3371-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_frame_register with
wilc_mgmt_frame_register to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: to make function name simple

 drivers/staging/wilc1000/linux_wlan.c             |  8 ++++----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 10 +++++-----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 335335a..637f661 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1719,8 +1719,8 @@ int mac_init_fn(struct net_device *ndev)
 	return 0;
 }
 
-void    WILC_WFI_frame_register(struct wiphy *wiphy, struct net_device *dev,
-				u16 frame_type, bool reg);
+void wilc_mgmt_frame_register(struct wiphy *wiphy, struct net_device *dev,
+			      u16 frame_type, bool reg);
 
 /* This fn is called, when this device is setup using ifconfig */
 int mac_open(struct net_device *ndev)
@@ -1778,9 +1778,9 @@ int mac_open(struct net_device *ndev)
 		goto _err_;
 	}
 
-	WILC_WFI_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy, nic->wilc_netdev,
+	wilc_mgmt_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy, nic->wilc_netdev,
 				nic->g_struct_frame_reg[0].frame_type, nic->g_struct_frame_reg[0].reg);
-	WILC_WFI_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy, nic->wilc_netdev,
+	wilc_mgmt_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy, nic->wilc_netdev,
 				nic->g_struct_frame_reg[1].frame_type, nic->g_struct_frame_reg[1].reg);
 	netif_wake_queue(ndev);
 	g_linux_wlan->open_ifcs++;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index dc935cb..2ecaeec 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2679,7 +2679,7 @@ int   wilc_mgmt_tx_cancel_wait(struct wiphy *wiphy,
 }
 
 /**
- *  @brief      WILC_WFI_frame_register
+ *  @brief      wilc_mgmt_frame_register
  *  @details Notify driver that a management frame type was
  *              registered. Note that this callback may not sleep, and cannot run
  *                      concurrently with itself.
@@ -2689,9 +2689,9 @@ int   wilc_mgmt_tx_cancel_wait(struct wiphy *wiphy,
  *  @date	01 JUL 2012
  *  @version
  */
-void    WILC_WFI_frame_register(struct wiphy *wiphy,
-				struct wireless_dev *wdev,
-				u16 frame_type, bool reg)
+void wilc_mgmt_frame_register(struct wiphy *wiphy,
+			      struct wireless_dev *wdev,
+			      u16 frame_type, bool reg)
 {
 
 	struct WILC_WFI_priv *priv;
@@ -3591,7 +3591,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.cancel_remain_on_channel = wilc_cancel_remain_on_channel,
 	.mgmt_tx_cancel_wait = wilc_mgmt_tx_cancel_wait,
 	.mgmt_tx = wilc_mgmt_tx,
-	.mgmt_frame_register = WILC_WFI_frame_register,
+	.mgmt_frame_register = wilc_mgmt_frame_register,
 	.set_power_mgmt = WILC_WFI_set_power_mgmt,
 	.set_cqm_rssi_config = WILC_WFI_set_cqm_rssi_config,
 #endif
-- 
2.5.1

