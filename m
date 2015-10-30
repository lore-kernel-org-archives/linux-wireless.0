Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:56688 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030341AbbJ3JpS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 05:45:18 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 09/17] staging: wilc1000: wilc_wlan_stop: add argument struct net_device
Date: Fri, 30 Oct 2015 18:47:15 +0900
Message-ID: <1446198443-6623-9-git-send-email-glen.lee@atmel.com> (sfid-20151030_104522_494909_E0641B27)
In-Reply-To: <1446198443-6623-1-git-send-email-glen.lee@atmel.com>
References: <1446198443-6623-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new argument struct net_device and pass dev to the functions.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 4 ++--
 drivers/staging/wilc1000/wilc_wlan.c  | 2 +-
 drivers/staging/wilc1000/wilc_wlan.h  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 6ffa2a1..1019a19 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -935,7 +935,7 @@ void wilc1000_wlan_deinit(struct net_device *dev)
 		PRINT_D(INIT_DBG, "Deinitializing IRQ\n");
 		deinit_irq(dev);
 
-		wilc_wlan_stop();
+		wilc_wlan_stop(dev);
 
 		PRINT_D(INIT_DBG, "Deinitializing WILC Wlan\n");
 		wilc_wlan_cleanup(dev);
@@ -1176,7 +1176,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 		return 0; /*success*/
 
 _fail_fw_start_:
-		wilc_wlan_stop();
+		wilc_wlan_stop(dev);
 
 _fail_irq_enable_:
 #if (defined WILC_SDIO) && (!defined WILC_SDIO_IRQ_GPIO)
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index c8ce1f6..d4eef3d 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1598,7 +1598,7 @@ void wilc_wlan_global_reset(void)
 	p->hif_func.hif_write_reg(WILC_GLB_RESET_0, 0x0);
 	release_bus(RELEASE_ONLY);
 }
-int wilc_wlan_stop(void)
+int wilc_wlan_stop(struct net_device *dev)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 	u32 reg = 0;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 519f352..fa66783 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -297,7 +297,7 @@ typedef struct {
 
 int wilc_wlan_firmware_download(const u8 *buffer, u32 buffer_size);
 int wilc_wlan_start(void);
-int wilc_wlan_stop(void);
+int wilc_wlan_stop(struct net_device *dev);
 int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			      u32 buffer_size, wilc_tx_complete_func_t func);
 int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount);
-- 
1.9.1

