Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34020 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbbITGwU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 02:52:20 -0400
Received: by padhy16 with SMTP id hy16so87437275pad.1
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2015 23:52:19 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 14/18] staging: wilc1000: remove useless #if 1
Date: Sun, 20 Sep 2015 15:51:21 +0900
Message-Id: <1442731885-4344-14-git-send-email-chaehyun.lim@gmail.com> (sfid-20150920_091654_542622_35436140)
In-Reply-To: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes #if 1, which is encapsulated some codes.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ----
 drivers/staging/wilc1000/wilc_wlan.c              | 2 --
 drivers/staging/wilc1000/wilc_wlan_cfg.c          | 2 --
 3 files changed, 8 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 04d64a8..34df5da 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2947,7 +2947,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Downloading P2P_CONCURRENCY_FIRMWARE\n");
 
 
-		#if 1
 		nic->iftype = GO_MODE;
 
 		/* ensure that the message Q is empty */
@@ -2987,7 +2986,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				g_key_gtk_params.key[1],
 				g_key_gtk_params.key[2],
 				g_key_gtk_params.cipher);
-			#if 1
 			add_key(g_linux_wlan->strInterfaceInfo[0].wilc_netdev->ieee80211_ptr->wiphy,
 				g_linux_wlan->strInterfaceInfo[0].wilc_netdev,
 				g_add_ptk_key_params.key_idx,
@@ -3001,9 +2999,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				g_add_gtk_key_params.pairwise,
 				g_add_gtk_key_params.mac_addr,
 				(struct key_params *)(&g_key_gtk_params));
-			#endif
 		}
-		#endif
 
 		if (g_linux_wlan->wilc1000_initialized)	{
 			for (i = 0; i < num_reg_frame; i++) {
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index ba502f1..0a930ec 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1675,7 +1675,6 @@ static int wilc_wlan_stop(void)
 		}
 
 	} while (timeout);
-#if 1
 	reg = ((1 << 0) | (1 << 1) | (1 << 2) | (1 << 3) | (1 << 8) | (1 << 9) | (1 << 26) | (1 << 29) | (1 << 30) | (1 << 31)); /**/
 	/**/
 	p->hif_func.hif_write_reg(WILC_GLB_RESET_0, reg);                                 /**/
@@ -1683,7 +1682,6 @@ static int wilc_wlan_stop(void)
 	/**/
 	ret = p->hif_func.hif_write_reg(WILC_GLB_RESET_0, reg);                                 /**/
 /******************************************************************************/
-#endif
 
 	release_bus(RELEASE_ALLOW_SLEEP);
 
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index ce16775..73a1508 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -534,13 +534,11 @@ static int wilc_wlan_cfg_indicate_rx(u8 *frame, int size, wilc_cfg_rsp_t *rsp)
 		GnrlAsyncInfoReceived(frame - 4, size + 4);
 		break;
 
-#if 1
 	case 'N':
 		NetworkInfoReceived(frame - 4, size + 4);
 		rsp->type = 0;
 		break;
 
-#endif
 	case 'S':
 		PRINT_INFO(RX_DBG, "Scan Notification Received\n");
 		host_int_ScanCompleteReceived(frame - 4, size + 4);
-- 
2.5.1

