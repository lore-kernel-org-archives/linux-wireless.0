Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36625 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781AbbIHP5X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 11:57:23 -0400
Received: by padhk3 with SMTP id hk3so42543358pad.3
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 08:57:22 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 28/30] staging: wilc1000: rename WILC_WFI_frame_register
Date: Wed,  9 Sep 2015 00:56:05 +0900
Message-Id: <1441727767-26026-28-git-send-email-chaehyun.lim@gmail.com> (sfid-20150908_180200_156210_6F5562B8)
In-Reply-To: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_frame_register with
wilc_cfg80211_mgmt_frame_register to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 6 +++---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index b9459a5..9c9ad65 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1752,7 +1752,7 @@ int mac_init_fn(struct net_device *ndev)
 }
 #endif
 
-void    WILC_WFI_frame_register(struct wiphy *wiphy, struct net_device *dev,
+void    wilc_cfg80211_mgmt_frame_register(struct wiphy *wiphy, struct net_device *dev,
 				u16 frame_type, bool reg);
 
 /* This fn is called, when this device is setup using ifconfig */
@@ -1814,9 +1814,9 @@ int mac_open(struct net_device *ndev)
 		goto _err_;
 	}
 
-	WILC_WFI_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy, nic->wilc_netdev,
+	wilc_cfg80211_mgmt_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy, nic->wilc_netdev,
 				nic->g_struct_frame_reg[0].frame_type, nic->g_struct_frame_reg[0].reg);
-	WILC_WFI_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy, nic->wilc_netdev,
+	wilc_cfg80211_mgmt_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy, nic->wilc_netdev,
 				nic->g_struct_frame_reg[1].frame_type, nic->g_struct_frame_reg[1].reg);
 	netif_wake_queue(ndev);
 	g_linux_wlan->open_ifcs++;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 5f56f8b..55ca2db 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2678,7 +2678,7 @@ int   wilc_cfg80211_mgmt_tx_cancel_wait(struct wiphy *wiphy,
 }
 
 /**
- *  @brief      WILC_WFI_frame_register
+ *  @brief      wilc_cfg80211_mgmt_frame_register
  *  @details Notify driver that a management frame type was
  *              registered. Note that this callback may not sleep, and cannot run
  *                      concurrently with itself.
@@ -2688,7 +2688,7 @@ int   wilc_cfg80211_mgmt_tx_cancel_wait(struct wiphy *wiphy,
  *  @date	01 JUL 2012
  *  @version
  */
-void    WILC_WFI_frame_register(struct wiphy *wiphy,
+void    wilc_cfg80211_mgmt_frame_register(struct wiphy *wiphy,
 				struct wireless_dev *wdev,
 				u16 frame_type, bool reg)
 {
@@ -3638,7 +3638,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.cancel_remain_on_channel = wilc_cfg80211_cancel_remain_on_channel,
 	.mgmt_tx_cancel_wait = wilc_cfg80211_mgmt_tx_cancel_wait,
 	.mgmt_tx = wilc_cfg80211_mgmt_tx,
-	.mgmt_frame_register = WILC_WFI_frame_register,
+	.mgmt_frame_register = wilc_cfg80211_mgmt_frame_register,
 	.set_power_mgmt = WILC_WFI_set_power_mgmt,
 	.set_cqm_rssi_config = WILC_WFI_set_cqm_rssi_config,
 #endif
-- 
2.5.1

