Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35540 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbbIND0F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 23:26:05 -0400
Received: by pacfv12 with SMTP id fv12so132614207pac.2
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2015 20:26:05 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 29/31] staging: wilc1000: rename WILC_WFI_frame_register
Date: Mon, 14 Sep 2015 12:24:29 +0900
Message-Id: <1442201071-16155-29-git-send-email-chaehyun.lim@gmail.com> (sfid-20150914_054654_321079_1A36FE16)
In-Reply-To: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_frame_register with mgmt_frame_register to
avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: remove "wilc_" prefix

 drivers/staging/wilc1000/linux_wlan.c             | 12 ++++++------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 10 +++++-----
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 63f44f8..5576e1c 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1618,8 +1618,8 @@ int mac_init_fn(struct net_device *ndev)
 	return 0;
 }
 
-void    WILC_WFI_frame_register(struct wiphy *wiphy, struct net_device *dev,
-				u16 frame_type, bool reg);
+void mgmt_frame_register(struct wiphy *wiphy, struct net_device *dev,
+			 u16 frame_type, bool reg);
 
 /* This fn is called, when this device is setup using ifconfig */
 int mac_open(struct net_device *ndev)
@@ -1677,10 +1677,10 @@ int mac_open(struct net_device *ndev)
 		goto _err_;
 	}
 
-	WILC_WFI_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy, nic->wilc_netdev,
-				nic->g_struct_frame_reg[0].frame_type, nic->g_struct_frame_reg[0].reg);
-	WILC_WFI_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy, nic->wilc_netdev,
-				nic->g_struct_frame_reg[1].frame_type, nic->g_struct_frame_reg[1].reg);
+	mgmt_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy, nic->wilc_netdev,
+			    nic->g_struct_frame_reg[0].frame_type, nic->g_struct_frame_reg[0].reg);
+	mgmt_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy, nic->wilc_netdev,
+			    nic->g_struct_frame_reg[1].frame_type, nic->g_struct_frame_reg[1].reg);
 	netif_wake_queue(ndev);
 	g_linux_wlan->open_ifcs++;
 	nic->mac_opened = 1;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 068e648..f2ffef8 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2679,7 +2679,7 @@ int mgmt_tx_cancel_wait(struct wiphy *wiphy,
 }
 
 /**
- *  @brief      WILC_WFI_frame_register
+ *  @brief      mgmt_frame_register
  *  @details Notify driver that a management frame type was
  *              registered. Note that this callback may not sleep, and cannot run
  *                      concurrently with itself.
@@ -2689,9 +2689,9 @@ int mgmt_tx_cancel_wait(struct wiphy *wiphy,
  *  @date	01 JUL 2012
  *  @version
  */
-void    WILC_WFI_frame_register(struct wiphy *wiphy,
-				struct wireless_dev *wdev,
-				u16 frame_type, bool reg)
+void mgmt_frame_register(struct wiphy *wiphy,
+			 struct wireless_dev *wdev,
+			 u16 frame_type, bool reg)
 {
 
 	struct WILC_WFI_priv *priv;
@@ -3591,7 +3591,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.cancel_remain_on_channel = cancel_remain_on_channel,
 	.mgmt_tx_cancel_wait = mgmt_tx_cancel_wait,
 	.mgmt_tx = mgmt_tx,
-	.mgmt_frame_register = WILC_WFI_frame_register,
+	.mgmt_frame_register = mgmt_frame_register,
 	.set_power_mgmt = WILC_WFI_set_power_mgmt,
 	.set_cqm_rssi_config = WILC_WFI_set_cqm_rssi_config,
 #endif
-- 
2.5.1

