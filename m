Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:20869 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965211AbbJ3DJD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 23:09:03 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 14/17] staging: wilc1000: acquire_bus: add new argument struct wilc
Date: Fri, 30 Oct 2015 12:10:39 +0900
Message-ID: <1446174642-28570-14-git-send-email-glen.lee@atmel.com> (sfid-20151030_040927_567194_11518309)
In-Reply-To: <1446174642-28570-1-git-send-email-glen.lee@atmel.com>
References: <1446174642-28570-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds struct wilc and use it instead of g_linux_wlan, pass dev
to the functions as well.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 47 ++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 894466f..a61dbea 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -109,10 +109,10 @@ static CHIP_PS_STATE_T genuChipPSstate = CHIP_WAKEDUP;
 /*acquire_bus() and release_bus() are made static inline functions*/
 /*as a temporary workaround to fix a problem of receiving*/
 /*unknown interrupt from FW*/
-static inline void acquire_bus(BUS_ACQUIRE_T acquire)
+static inline void acquire_bus(struct wilc *wilc, BUS_ACQUIRE_T acquire)
 {
 
-	mutex_lock(&g_linux_wlan->hif_cs);
+	mutex_lock(&wilc->hif_cs);
 	#ifndef WILC_OPTIMIZE_SLEEP_INT
 	if (genuChipPSstate != CHIP_WAKEDUP)
 	#endif
@@ -812,11 +812,16 @@ static inline void chip_wakeup(void)
 #endif
 void chip_sleep_manually(struct net_device *dev, u32 u32SleepTime)
 {
+	perInterface_wlan_t *nic = netdev_priv(dev);
+	struct wilc *wilc;
+
+	wilc = nic->wilc;
+
 	if (genuChipPSstate != CHIP_WAKEDUP) {
 		/* chip is already sleeping. Do nothing */
 		return;
 	}
-	acquire_bus(ACQUIRE_ONLY);
+	acquire_bus(wilc, ACQUIRE_ONLY);
 
 #ifdef WILC_OPTIMIZE_SLEEP_INT
 	chip_allow_sleep();
@@ -921,7 +926,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 			PRINT_D(TX_DBG, "Mark the last entry in VMM table - number of previous entries = %d\n", i);
 			vmm_table[i] = 0x0;     /* mark the last element to 0 */
 		}
-		acquire_bus(ACQUIRE_AND_WAKEUP);
+		acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 		counter = 0;
 		do {
 
@@ -951,7 +956,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 				PRINT_WRN(GENERIC_DBG, "[wilc txq]: warn, vmm table not clear yet, wait...\n");
 				release_bus(RELEASE_ALLOW_SLEEP);
 				usleep_range(3000, 3000);
-				acquire_bus(ACQUIRE_AND_WAKEUP);
+				acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 			}
 		} while (!p->quit);
 
@@ -999,7 +1004,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 				} else {
 					release_bus(RELEASE_ALLOW_SLEEP);
 					usleep_range(3000, 3000);
-					acquire_bus(ACQUIRE_AND_WAKEUP);
+					acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 					PRINT_WRN(GENERIC_DBG, "Can't get VMM entery - reg = %2x\n", reg);
 				}
 			} while (--timeout);
@@ -1102,7 +1107,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 		/**
 		 *      lock the bus
 		 **/
-		acquire_bus(ACQUIRE_AND_WAKEUP);
+		acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 
 		ret = p->hif_func.hif_clear_int_ext(ENABLE_TX_VMM);
 		if (!ret) {
@@ -1385,7 +1390,7 @@ void wilc_handle_isr(void *wilc)
 {
 	u32 int_status;
 
-	acquire_bus(ACQUIRE_AND_WAKEUP);
+	acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 	g_wlan.hif_func.hif_read_int(&int_status);
 
 	if (int_status & PLL_INT_EXT)
@@ -1423,6 +1428,10 @@ int wilc_wlan_firmware_download(struct net_device *dev, const u8 *buffer,
 	u32 addr, size, size2, blksz;
 	u8 *dma_buffer;
 	int ret = 0;
+	perInterface_wlan_t *nic = netdev_priv(dev);
+	struct wilc *wilc;
+
+	wilc = nic->wilc;
 
 	blksz = BIT(12);
 	/* Allocate a DMA coherent  buffer. */
@@ -1447,7 +1456,7 @@ int wilc_wlan_firmware_download(struct net_device *dev, const u8 *buffer,
 		addr = BYTE_SWAP(addr);
 		size = BYTE_SWAP(size);
 #endif
-		acquire_bus(ACQUIRE_ONLY);
+		acquire_bus(wilc, ACQUIRE_ONLY);
 		offset += 8;
 		while (((int)size) && (offset < buffer_size)) {
 			if (size <= blksz)
@@ -1495,6 +1504,10 @@ int wilc_wlan_start(struct net_device *dev)
 	u32 reg = 0;
 	int ret;
 	u32 chipid;
+	perInterface_wlan_t *nic = netdev_priv(dev);
+	struct wilc *wilc;
+
+	wilc = nic->wilc;
 
 	/**
 	 *      Set the host interface
@@ -1505,7 +1518,7 @@ int wilc_wlan_start(struct net_device *dev)
 	} else if (p->io_func.io_type == HIF_SPI) {
 		reg = 1;
 	}
-	acquire_bus(ACQUIRE_ONLY);
+	acquire_bus(wilc, ACQUIRE_ONLY);
 	ret = p->hif_func.hif_write_reg(WILC_VMM_CORE_CFG, reg);
 	if (!ret) {
 		wilc_debug(N_ERR, "[wilc start]: fail write reg vmm_core_cfg...\n");
@@ -1596,10 +1609,14 @@ int wilc_wlan_stop(struct net_device *dev)
 	u32 reg = 0;
 	int ret;
 	u8 timeout = 10;
+	perInterface_wlan_t *nic = netdev_priv(dev);
+	struct wilc *wilc;
+
+	wilc = nic->wilc;
 	/**
 	 *      TODO: stop the firmware, need a re-download
 	 **/
-	acquire_bus(ACQUIRE_AND_WAKEUP);
+	acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 
 	ret = p->hif_func.hif_read_reg(WILC_GLB_RESET_0, &reg);
 	if (!ret) {
@@ -1703,7 +1720,7 @@ void wilc_wlan_cleanup(struct net_device *dev)
 	#endif
 	kfree(p->tx_buffer);
 
-	acquire_bus(ACQUIRE_AND_WAKEUP);
+	acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 
 
 	ret = p->hif_func.hif_read_reg(WILC_GP_REG_0, &reg);
@@ -1875,8 +1892,12 @@ u32 init_chip(struct net_device *dev)
 {
 	u32 chipid;
 	u32 reg, ret = 0;
+	perInterface_wlan_t *nic = netdev_priv(dev);
+	struct wilc *wilc;
+
+	wilc = nic->wilc;
 
-	acquire_bus(ACQUIRE_ONLY);
+	acquire_bus(wilc, ACQUIRE_ONLY);
 
 	chipid = wilc_get_chipid(true);
 
-- 
1.9.1

