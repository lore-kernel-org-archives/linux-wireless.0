Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:53483 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934360AbbKTHx2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2015 02:53:28 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 3/6] staging: wilc1000: wilc_wlan.c: remove hif_func of wilc_wlan_dev_t
Date: Fri, 20 Nov 2015 16:56:33 +0900
Message-ID: <1448006196-28555-3-git-send-email-glen.lee@atmel.com> (sfid-20151120_085333_274212_A855F481)
In-Reply-To: <1448006196-28555-1-git-send-email-glen.lee@atmel.com>
References: <1448006196-28555-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hif_func of wilc_wlan_dev_t is duplicate because we have same struct
wilc_hif_func ops of struct wilc which is available in wilc_wlan.c.
Rename ops of struct wilc with hif_func and remove hif_func of wilc_wlan_dev_t,
and use wilc->hif_func instead of g_wlan.hif_func in all functions.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         |  18 +--
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |   2 +-
 drivers/staging/wilc1000/wilc_wlan.c          | 161 ++++++++++++--------------
 3 files changed, 87 insertions(+), 94 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 73954f4..7ccc9b0 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -749,9 +749,9 @@ void wilc1000_wlan_deinit(struct net_device *dev)
 
 		PRINT_D(INIT_DBG, "Disabling IRQ\n");
 		if (!wl->dev_irq_num &&
-		    wl->ops->disable_interrupt) {
+		    wl->hif_func->disable_interrupt) {
 			mutex_lock(&wl->hif_cs);
-			wl->ops->disable_interrupt(wl);
+			wl->hif_func->disable_interrupt(wl);
 			mutex_unlock(&wl->hif_cs);
 		}
 		if (&wl->txq_event)
@@ -769,12 +769,12 @@ void wilc1000_wlan_deinit(struct net_device *dev)
 		wilc_wlan_cleanup(dev);
 #if defined(PLAT_ALLWINNER_A20) || defined(PLAT_ALLWINNER_A23) || defined(PLAT_ALLWINNER_A31)
 		if (!wl->dev_irq_num &&
-		    wl->ops->disable_interrupt) {
+		    wl->hif_func->disable_interrupt) {
 
 			PRINT_D(INIT_DBG, "Disabling IRQ 2\n");
 
 			mutex_lock(&wl->hif_cs);
-			wl->ops->disable_interrupt(wl);
+			wl->hif_func->disable_interrupt(wl);
 			mutex_unlock(&wl->hif_cs);
 		}
 #endif
@@ -910,8 +910,8 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 		}
 
 		if (!wl->dev_irq_num &&
-		    wl->ops->enable_interrupt &&
-		    wl->ops->enable_interrupt(wl)) {
+		    wl->hif_func->enable_interrupt &&
+		    wl->hif_func->enable_interrupt(wl)) {
 			PRINT_ER("couldn't initialize IRQ\n");
 			ret = -EIO;
 			goto _fail_irq_init_;
@@ -963,8 +963,8 @@ _fail_fw_start_:
 
 _fail_irq_enable_:
 		if (!wl->dev_irq_num &&
-		    wl->ops->disable_interrupt)
-			wl->ops->disable_interrupt(wl);
+		    wl->hif_func->disable_interrupt)
+			wl->hif_func->disable_interrupt(wl);
 _fail_irq_init_:
 		if (wl->dev_irq_num)
 			deinit_irq(dev);
@@ -1437,7 +1437,7 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 	*wilc = wl;
 	wl->io_type = io_type;
 	wl->gpio = gpio;
-	wl->ops = ops;
+	wl->hif_func = ops;
 
 	register_inetaddr_notifier(&g_dev_notifier);
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 212d607..b593b64 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -156,7 +156,7 @@ struct wilc_vif {
 };
 
 struct wilc {
-	const struct wilc_hif_func *ops;
+	const struct wilc_hif_func *hif_func;
 	int io_type;
 	int mac_status;
 	int gpio;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index a74a95e..b9bedc8 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -6,7 +6,6 @@
 typedef struct {
 	int quit;
 	int io_type;
-	struct wilc_hif_func hif_func;
 	int cfg_frame_in_use;
 	struct wilc_cfg_frame cfg_frame;
 	u32 cfg_frame_offset;
@@ -564,9 +563,9 @@ static inline void chip_allow_sleep(struct wilc *wilc)
 {
 	u32 reg = 0;
 
-	g_wlan.hif_func.hif_read_reg(wilc, 0xf0, &reg);
+	wilc->hif_func->hif_read_reg(wilc, 0xf0, &reg);
 
-	g_wlan.hif_func.hif_write_reg(wilc, 0xf0, reg & ~BIT(0));
+	wilc->hif_func->hif_write_reg(wilc, 0xf0, reg & ~BIT(0));
 }
 
 static inline void chip_wakeup(struct wilc *wilc)
@@ -576,9 +575,9 @@ static inline void chip_wakeup(struct wilc *wilc)
 
 	if ((g_wlan.io_type & 0x1) == HIF_SPI) {
 		do {
-			g_wlan.hif_func.hif_read_reg(wilc, 1, &reg);
-			g_wlan.hif_func.hif_write_reg(wilc, 1, reg | BIT(1));
-			g_wlan.hif_func.hif_write_reg(wilc, 1, reg & ~BIT(1));
+			wilc->hif_func->hif_read_reg(wilc, 1, &reg);
+			wilc->hif_func->hif_write_reg(wilc, 1, reg | BIT(1));
+			wilc->hif_func->hif_write_reg(wilc, 1, reg & ~BIT(1));
 
 			do {
 				usleep_range(2 * 1000, 2 * 1000);
@@ -589,44 +588,44 @@ static inline void chip_wakeup(struct wilc *wilc)
 
 		} while (wilc_get_chipid(wilc, true) == 0);
 	} else if ((g_wlan.io_type & 0x1) == HIF_SDIO)	 {
-		g_wlan.hif_func.hif_read_reg(wilc, 0xf0, &reg);
+		wilc->hif_func->hif_read_reg(wilc, 0xf0, &reg);
 		do {
-			g_wlan.hif_func.hif_write_reg(wilc, 0xf0,
+			wilc->hif_func->hif_write_reg(wilc, 0xf0,
 						      reg | BIT(0));
-			g_wlan.hif_func.hif_read_reg(wilc, 0xf1,
+			wilc->hif_func->hif_read_reg(wilc, 0xf1,
 						     &clk_status_reg);
 
 			while (((clk_status_reg & 0x1) == 0) && (((++trials) % 3) == 0)) {
 				usleep_range(2 * 1000, 2 * 1000);
 
-				g_wlan.hif_func.hif_read_reg(wilc, 0xf1,
+				wilc->hif_func->hif_read_reg(wilc, 0xf1,
 							     &clk_status_reg);
 
 				if ((clk_status_reg & 0x1) == 0)
 					wilc_debug(N_ERR, "clocks still OFF. Wake up failed\n");
 			}
 			if ((clk_status_reg & 0x1) == 0) {
-				g_wlan.hif_func.hif_write_reg(wilc, 0xf0,
+				wilc->hif_func->hif_write_reg(wilc, 0xf0,
 							      reg & (~BIT(0)));
 			}
 		} while ((clk_status_reg & 0x1) == 0);
 	}
 
 	if (chip_ps_state == CHIP_SLEEPING_MANUAL) {
-		g_wlan.hif_func.hif_read_reg(wilc, 0x1C0C, &reg);
+		wilc->hif_func->hif_read_reg(wilc, 0x1C0C, &reg);
 		reg &= ~BIT(0);
-		g_wlan.hif_func.hif_write_reg(wilc, 0x1C0C, reg);
+		wilc->hif_func->hif_write_reg(wilc, 0x1C0C, reg);
 
 		if (wilc_get_chipid(wilc, false) >= 0x1002b0) {
 			u32 val32;
 
-			g_wlan.hif_func.hif_read_reg(wilc, 0x1e1c, &val32);
+			wilc->hif_func->hif_read_reg(wilc, 0x1e1c, &val32);
 			val32 |= BIT(6);
-			g_wlan.hif_func.hif_write_reg(wilc, 0x1e1c, val32);
+			wilc->hif_func->hif_write_reg(wilc, 0x1e1c, val32);
 
-			g_wlan.hif_func.hif_read_reg(wilc, 0x1e9c, &val32);
+			wilc->hif_func->hif_read_reg(wilc, 0x1e9c, &val32);
 			val32 |= BIT(6);
-			g_wlan.hif_func.hif_write_reg(wilc, 0x1e9c, val32);
+			wilc->hif_func->hif_write_reg(wilc, 0x1e9c, val32);
 		}
 	}
 	chip_ps_state = CHIP_WAKEDUP;
@@ -638,17 +637,17 @@ static inline void chip_wakeup(struct wilc *wilc)
 
 	do {
 		if ((g_wlan.io_type & 0x1) == HIF_SPI) {
-			g_wlan.hif_func.hif_read_reg(wilc, 1, &reg);
-			g_wlan.hif_func.hif_write_reg(wilc, 1, reg & ~BIT(1));
-			g_wlan.hif_func.hif_write_reg(wilc, 1, reg | BIT(1));
-			g_wlan.hif_func.hif_write_reg(wilc, 1, reg  & ~BIT(1));
+			wilc->hif_func->hif_read_reg(wilc, 1, &reg);
+			wilc->hif_func->hif_write_reg(wilc, 1, reg & ~BIT(1));
+			wilc->hif_func->hif_write_reg(wilc, 1, reg | BIT(1));
+			wilc->hif_func->hif_write_reg(wilc, 1, reg  & ~BIT(1));
 		} else if ((g_wlan.io_type & 0x1) == HIF_SDIO)	 {
-			g_wlan.hif_func.hif_read_reg(wilc, 0xf0, &reg);
-			g_wlan.hif_func.hif_write_reg(wilc, 0xf0,
+			wilc->hif_func->hif_read_reg(wilc, 0xf0, &reg);
+			wilc->hif_func->hif_write_reg(wilc, 0xf0,
 						      reg & ~BIT(0));
-			g_wlan.hif_func.hif_write_reg(wilc, 0xf0,
+			wilc->hif_func->hif_write_reg(wilc, 0xf0,
 						      reg | BIT(0));
-			g_wlan.hif_func.hif_write_reg(wilc, 0xf0,
+			wilc->hif_func->hif_write_reg(wilc, 0xf0,
 						      reg  & ~BIT(0));
 		}
 
@@ -663,20 +662,20 @@ static inline void chip_wakeup(struct wilc *wilc)
 	} while (wilc_get_chipid(wilc, true) == 0);
 
 	if (chip_ps_state == CHIP_SLEEPING_MANUAL) {
-		g_wlan.hif_func.hif_read_reg(wilc, 0x1C0C, &reg);
+		wilc->hif_func->hif_read_reg(wilc, 0x1C0C, &reg);
 		reg &= ~BIT(0);
-		g_wlan.hif_func.hif_write_reg(wilc, 0x1C0C, reg);
+		wilc->hif_func->hif_write_reg(wilc, 0x1C0C, reg);
 
 		if (wilc_get_chipid(wilc, false) >= 0x1002b0) {
 			u32 val32;
 
-			g_wlan.hif_func.hif_read_reg(wilc, 0x1e1c, &val32);
+			wilc->hif_func->hif_read_reg(wilc, 0x1e1c, &val32);
 			val32 |= BIT(6);
-			g_wlan.hif_func.hif_write_reg(wilc, 0x1e1c, val32);
+			wilc->hif_func->hif_write_reg(wilc, 0x1e1c, val32);
 
-			g_wlan.hif_func.hif_read_reg(wilc, 0x1e9c, &val32);
+			wilc->hif_func->hif_read_reg(wilc, 0x1e9c, &val32);
 			val32 |= BIT(6);
-			g_wlan.hif_func.hif_write_reg(wilc, 0x1e9c, val32);
+			wilc->hif_func->hif_write_reg(wilc, 0x1e9c, val32);
 		}
 	}
 	chip_ps_state = CHIP_WAKEDUP;
@@ -691,7 +690,7 @@ void wilc_chip_sleep_manually(struct wilc *wilc)
 #ifdef WILC_OPTIMIZE_SLEEP_INT
 	chip_allow_sleep(wilc);
 #endif
-	g_wlan.hif_func.hif_write_reg(wilc, 0x10a8, 1);
+	wilc->hif_func->hif_write_reg(wilc, 0x10a8, 1);
 
 	chip_ps_state = CHIP_SLEEPING_MANUAL;
 	release_bus(wilc, RELEASE_ONLY);
@@ -780,7 +779,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 		acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 		counter = 0;
 		do {
-			ret = p->hif_func.hif_read_reg(wilc, WILC_HOST_TX_CTRL,
+			ret = wilc->hif_func->hif_read_reg(wilc, WILC_HOST_TX_CTRL,
 						       &reg);
 			if (!ret) {
 				wilc_debug(N_ERR, "[wilc txq]: fail can't read reg vmm_tbl_entry..\n");
@@ -795,7 +794,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 				if (counter > 200) {
 					counter = 0;
 					PRINT_D(TX_DBG, "Looping in tx ctrl , forcce quit\n");
-					ret = p->hif_func.hif_write_reg(wilc, WILC_HOST_TX_CTRL, 0);
+					ret = wilc->hif_func->hif_write_reg(wilc, WILC_HOST_TX_CTRL, 0);
 					break;
 				}
 				PRINT_WRN(GENERIC_DBG, "[wilc txq]: warn, vmm table not clear yet, wait...\n");
@@ -810,13 +809,13 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 
 		timeout = 200;
 		do {
-			ret = p->hif_func.hif_block_tx(wilc, WILC_VMM_TBL_RX_SHADOW_BASE, (u8 *)vmm_table, ((i + 1) * 4));
+			ret = wilc->hif_func->hif_block_tx(wilc, WILC_VMM_TBL_RX_SHADOW_BASE, (u8 *)vmm_table, ((i + 1) * 4));
 			if (!ret) {
 				wilc_debug(N_ERR, "ERR block TX of VMM table.\n");
 				break;
 			}
 
-			ret = p->hif_func.hif_write_reg(wilc, WILC_HOST_VMM_CTL,
+			ret = wilc->hif_func->hif_write_reg(wilc, WILC_HOST_VMM_CTL,
 							0x2);
 			if (!ret) {
 				wilc_debug(N_ERR, "[wilc txq]: fail can't write reg host_vmm_ctl..\n");
@@ -824,7 +823,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 			}
 
 			do {
-				ret = p->hif_func.hif_read_reg(wilc, WILC_HOST_VMM_CTL, &reg);
+				ret = wilc->hif_func->hif_read_reg(wilc, WILC_HOST_VMM_CTL, &reg);
 				if (!ret) {
 					wilc_debug(N_ERR, "[wilc txq]: fail can't read reg host_vmm_ctl..\n");
 					break;
@@ -840,7 +839,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 				}
 			} while (--timeout);
 			if (timeout <= 0) {
-				ret = p->hif_func.hif_write_reg(wilc, WILC_HOST_VMM_CTL, 0x0);
+				ret = wilc->hif_func->hif_write_reg(wilc, WILC_HOST_VMM_CTL, 0x0);
 				break;
 			}
 
@@ -850,13 +849,13 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 			if (entries == 0) {
 				PRINT_WRN(GENERIC_DBG, "[wilc txq]: no more buffer in the chip (reg: %08x), retry later [[ %d, %x ]]\n", reg, i, vmm_table[i - 1]);
 
-				ret = p->hif_func.hif_read_reg(wilc, WILC_HOST_TX_CTRL, &reg);
+				ret = wilc->hif_func->hif_read_reg(wilc, WILC_HOST_TX_CTRL, &reg);
 				if (!ret) {
 					wilc_debug(N_ERR, "[wilc txq]: fail can't read reg WILC_HOST_TX_CTRL..\n");
 					break;
 				}
 				reg &= ~BIT(0);
-				ret = p->hif_func.hif_write_reg(wilc, WILC_HOST_TX_CTRL, reg);
+				ret = wilc->hif_func->hif_write_reg(wilc, WILC_HOST_TX_CTRL, reg);
 				if (!ret) {
 					wilc_debug(N_ERR, "[wilc txq]: fail can't write reg WILC_HOST_TX_CTRL..\n");
 					break;
@@ -928,13 +927,13 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 
 		acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 
-		ret = p->hif_func.hif_clear_int_ext(wilc, ENABLE_TX_VMM);
+		ret = wilc->hif_func->hif_clear_int_ext(wilc, ENABLE_TX_VMM);
 		if (!ret) {
 			wilc_debug(N_ERR, "[wilc txq]: fail can't start tx VMM ...\n");
 			goto _end_;
 		}
 
-		ret = p->hif_func.hif_block_tx_ext(wilc, 0, txb, offset);
+		ret = wilc->hif_func->hif_block_tx_ext(wilc, 0, txb, offset);
 		if (!ret) {
 			wilc_debug(N_ERR, "[wilc txq]: fail can't block tx ext...\n");
 			goto _end_;
@@ -1053,14 +1052,14 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 
 static void wilc_unknown_isr_ext(struct wilc *wilc)
 {
-	g_wlan.hif_func.hif_clear_int_ext(wilc, 0);
+	wilc->hif_func->hif_clear_int_ext(wilc, 0);
 }
 
 static void wilc_pllupdate_isr_ext(struct wilc *wilc, u32 int_stats)
 {
 	int trials = 10;
 
-	g_wlan.hif_func.hif_clear_int_ext(wilc, PLL_INT_CLR);
+	wilc->hif_func->hif_clear_int_ext(wilc, PLL_INT_CLR);
 
 	if (g_wlan.io_type == HIF_SDIO)
 		mdelay(WILC_PLL_TO_SDIO);
@@ -1075,7 +1074,7 @@ static void wilc_pllupdate_isr_ext(struct wilc *wilc, u32 int_stats)
 
 static void wilc_sleeptimer_isr_ext(struct wilc *wilc, u32 int_stats1)
 {
-	g_wlan.hif_func.hif_clear_int_ext(wilc, SLEEP_INT_CLR);
+	wilc->hif_func->hif_clear_int_ext(wilc, SLEEP_INT_CLR);
 #ifndef WILC_OPTIMIZE_SLEEP_INT
 	chip_ps_state = CHIP_SLEEPING_AUTO;
 #endif
@@ -1097,7 +1096,7 @@ static void wilc_wlan_handle_isr_ext(struct wilc *wilc, u32 int_status)
 		u32 time = 0;
 
 		wilc_debug(N_ERR, "RX Size equal zero ... Trying to read it again for %d time\n", time++);
-		p->hif_func.hif_read_size(wilc, &size);
+		wilc->hif_func->hif_read_size(wilc, &size);
 		size = ((size & 0x7fff) << 2);
 		retries++;
 	}
@@ -1113,9 +1112,9 @@ static void wilc_wlan_handle_isr_ext(struct wilc *wilc, u32 int_status)
 			goto _end_;
 		}
 
-		p->hif_func.hif_clear_int_ext(wilc,
+		wilc->hif_func->hif_clear_int_ext(wilc,
 					      DATA_INT_CLR | ENABLE_RX_VMM);
-		ret = p->hif_func.hif_block_rx_ext(wilc, 0, buffer, size);
+		ret = wilc->hif_func->hif_block_rx_ext(wilc, 0, buffer, size);
 
 		if (!ret) {
 			wilc_debug(N_ERR, "[wilc isr]: fail block rx...\n");
@@ -1142,7 +1141,7 @@ void wilc_handle_isr(struct wilc *wilc)
 	u32 int_status;
 
 	acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
-	g_wlan.hif_func.hif_read_int(wilc, &int_status);
+	wilc->hif_func->hif_read_int(wilc, &int_status);
 
 	if (int_status & PLL_INT_EXT)
 		wilc_pllupdate_isr_ext(wilc, int_status);
@@ -1165,7 +1164,6 @@ EXPORT_SYMBOL_GPL(wilc_handle_isr);
 
 int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer, u32 buffer_size)
 {
-	wilc_wlan_dev_t *p = &g_wlan;
 	u32 offset;
 	u32 addr, size, size2, blksz;
 	u8 *dma_buffer;
@@ -1197,7 +1195,7 @@ int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer, u32 buffer_
 				size2 = blksz;
 
 			memcpy(dma_buffer, &buffer[offset], size2);
-			ret = p->hif_func.hif_block_tx(wilc, addr, dma_buffer,
+			ret = wilc->hif_func->hif_block_tx(wilc, addr, dma_buffer,
 						       size2);
 			if (!ret)
 				break;
@@ -1239,7 +1237,7 @@ int wilc_wlan_start(struct wilc *wilc)
 		reg = 1;
 	}
 	acquire_bus(wilc, ACQUIRE_ONLY);
-	ret = p->hif_func.hif_write_reg(wilc, WILC_VMM_CORE_CFG, reg);
+	ret = wilc->hif_func->hif_write_reg(wilc, WILC_VMM_CORE_CFG, reg);
 	if (!ret) {
 		wilc_debug(N_ERR, "[wilc start]: fail write reg vmm_core_cfg...\n");
 		release_bus(wilc, RELEASE_ONLY);
@@ -1273,7 +1271,7 @@ int wilc_wlan_start(struct wilc *wilc)
 	reg |= WILC_HAVE_DISABLE_WILC_UART;
 #endif
 
-	ret = p->hif_func.hif_write_reg(wilc, WILC_GP_REG_1, reg);
+	ret = wilc->hif_func->hif_write_reg(wilc, WILC_GP_REG_1, reg);
 	if (!ret) {
 		wilc_debug(N_ERR, "[wilc start]: fail write WILC_GP_REG_1 ...\n");
 		release_bus(wilc, RELEASE_ONLY);
@@ -1281,9 +1279,9 @@ int wilc_wlan_start(struct wilc *wilc)
 		return ret;
 	}
 
-	p->hif_func.hif_sync_ext(wilc, NUM_INT_EXT);
+	wilc->hif_func->hif_sync_ext(wilc, NUM_INT_EXT);
 
-	ret = p->hif_func.hif_read_reg(wilc, 0x1000, &chipid);
+	ret = wilc->hif_func->hif_read_reg(wilc, 0x1000, &chipid);
 	if (!ret) {
 		wilc_debug(N_ERR, "[wilc start]: fail read reg 0x1000 ...\n");
 		release_bus(wilc, RELEASE_ONLY);
@@ -1291,16 +1289,16 @@ int wilc_wlan_start(struct wilc *wilc)
 		return ret;
 	}
 
-	p->hif_func.hif_read_reg(wilc, WILC_GLB_RESET_0, &reg);
+	wilc->hif_func->hif_read_reg(wilc, WILC_GLB_RESET_0, &reg);
 	if ((reg & BIT(10)) == BIT(10)) {
 		reg &= ~BIT(10);
-		p->hif_func.hif_write_reg(wilc, WILC_GLB_RESET_0, reg);
-		p->hif_func.hif_read_reg(wilc, WILC_GLB_RESET_0, &reg);
+		wilc->hif_func->hif_write_reg(wilc, WILC_GLB_RESET_0, reg);
+		wilc->hif_func->hif_read_reg(wilc, WILC_GLB_RESET_0, &reg);
 	}
 
 	reg |= BIT(10);
-	ret = p->hif_func.hif_write_reg(wilc, WILC_GLB_RESET_0, reg);
-	p->hif_func.hif_read_reg(wilc, WILC_GLB_RESET_0, &reg);
+	ret = wilc->hif_func->hif_write_reg(wilc, WILC_GLB_RESET_0, reg);
+	wilc->hif_func->hif_read_reg(wilc, WILC_GLB_RESET_0, &reg);
 	release_bus(wilc, RELEASE_ONLY);
 
 	return (ret < 0) ? ret : 0;
@@ -1308,22 +1306,18 @@ int wilc_wlan_start(struct wilc *wilc)
 
 void wilc_wlan_global_reset(struct wilc *wilc)
 {
-
-	wilc_wlan_dev_t *p = &g_wlan;
-
 	acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
-	p->hif_func.hif_write_reg(wilc, WILC_GLB_RESET_0, 0x0);
+	wilc->hif_func->hif_write_reg(wilc, WILC_GLB_RESET_0, 0x0);
 	release_bus(wilc, RELEASE_ONLY);
 }
 int wilc_wlan_stop(struct wilc *wilc)
 {
-	wilc_wlan_dev_t *p = &g_wlan;
 	u32 reg = 0;
 	int ret;
 	u8 timeout = 10;
 	acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 
-	ret = p->hif_func.hif_read_reg(wilc, WILC_GLB_RESET_0, &reg);
+	ret = wilc->hif_func->hif_read_reg(wilc, WILC_GLB_RESET_0, &reg);
 	if (!ret) {
 		PRINT_ER("Error while reading reg\n");
 		release_bus(wilc, RELEASE_ALLOW_SLEEP);
@@ -1331,7 +1325,7 @@ int wilc_wlan_stop(struct wilc *wilc)
 	}
 
 	reg &= ~BIT(10);
-	ret = p->hif_func.hif_write_reg(wilc, WILC_GLB_RESET_0, reg);
+	ret = wilc->hif_func->hif_write_reg(wilc, WILC_GLB_RESET_0, reg);
 	if (!ret) {
 		PRINT_ER("Error while writing reg\n");
 		release_bus(wilc, RELEASE_ALLOW_SLEEP);
@@ -1339,7 +1333,7 @@ int wilc_wlan_stop(struct wilc *wilc)
 	}
 
 	do {
-		ret = p->hif_func.hif_read_reg(wilc, WILC_GLB_RESET_0, &reg);
+		ret = wilc->hif_func->hif_read_reg(wilc, WILC_GLB_RESET_0, &reg);
 		if (!ret) {
 			PRINT_ER("Error while reading reg\n");
 			release_bus(wilc, RELEASE_ALLOW_SLEEP);
@@ -1352,13 +1346,13 @@ int wilc_wlan_stop(struct wilc *wilc)
 			PRINT_D(GENERIC_DBG, "Bit 10 not reset : Retry %d\n",
 				timeout);
 			reg &= ~BIT(10);
-			ret = p->hif_func.hif_write_reg(wilc, WILC_GLB_RESET_0,
+			ret = wilc->hif_func->hif_write_reg(wilc, WILC_GLB_RESET_0,
 							reg);
 			timeout--;
 		} else {
 			PRINT_D(GENERIC_DBG, "Bit 10 reset after : Retry %d\n",
 				timeout);
-			ret = p->hif_func.hif_read_reg(wilc, WILC_GLB_RESET_0,
+			ret = wilc->hif_func->hif_read_reg(wilc, WILC_GLB_RESET_0,
 						       &reg);
 			if (!ret) {
 				PRINT_ER("Error while reading reg\n");
@@ -1374,10 +1368,10 @@ int wilc_wlan_stop(struct wilc *wilc)
 	reg = (BIT(0) | BIT(1) | BIT(2) | BIT(3) | BIT(8) | BIT(9) | BIT(26) |
 	       BIT(29) | BIT(30) | BIT(31));
 
-	p->hif_func.hif_write_reg(wilc, WILC_GLB_RESET_0, reg);
+	wilc->hif_func->hif_write_reg(wilc, WILC_GLB_RESET_0, reg);
 	reg = (u32)~BIT(10);
 
-	ret = p->hif_func.hif_write_reg(wilc, WILC_GLB_RESET_0, reg);
+	ret = wilc->hif_func->hif_write_reg(wilc, WILC_GLB_RESET_0, reg);
 
 	release_bus(wilc, RELEASE_ALLOW_SLEEP);
 
@@ -1420,20 +1414,20 @@ void wilc_wlan_cleanup(struct net_device *dev)
 
 	acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 
-	ret = p->hif_func.hif_read_reg(wilc, WILC_GP_REG_0, &reg);
+	ret = wilc->hif_func->hif_read_reg(wilc, WILC_GP_REG_0, &reg);
 	if (!ret) {
 		PRINT_ER("Error while reading reg\n");
 		release_bus(wilc, RELEASE_ALLOW_SLEEP);
 	}
 	PRINT_ER("Writing ABORT reg\n");
-	ret = p->hif_func.hif_write_reg(wilc, WILC_GP_REG_0,
+	ret = wilc->hif_func->hif_write_reg(wilc, WILC_GP_REG_0,
 					(reg | ABORT_INT));
 	if (!ret) {
 		PRINT_ER("Error while writing reg\n");
 		release_bus(wilc, RELEASE_ALLOW_SLEEP);
 	}
 	release_bus(wilc, RELEASE_ALLOW_SLEEP);
-	p->hif_func.hif_deinit(NULL);
+	wilc->hif_func->hif_deinit(NULL);
 }
 
 static int wilc_wlan_cfg_commit(struct wilc *wilc, int type, u32 drv_handler)
@@ -1566,18 +1560,18 @@ static u32 init_chip(struct net_device *dev)
 	chipid = wilc_get_chipid(wilc, true);
 
 	if ((chipid & 0xfff) != 0xa0) {
-		ret = g_wlan.hif_func.hif_read_reg(wilc, 0x1118, &reg);
+		ret = wilc->hif_func->hif_read_reg(wilc, 0x1118, &reg);
 		if (!ret) {
 			wilc_debug(N_ERR, "[wilc start]: fail read reg 0x1118 ...\n");
 			return ret;
 		}
 		reg |= BIT(0);
-		ret = g_wlan.hif_func.hif_write_reg(wilc, 0x1118, reg);
+		ret = wilc->hif_func->hif_write_reg(wilc, 0x1118, reg);
 		if (!ret) {
 			wilc_debug(N_ERR, "[wilc start]: fail write reg 0x1118 ...\n");
 			return ret;
 		}
-		ret = g_wlan.hif_func.hif_write_reg(wilc, 0xc0000, 0x71);
+		ret = wilc->hif_func->hif_write_reg(wilc, 0xc0000, 0x71);
 		if (!ret) {
 			wilc_debug(N_ERR, "[wilc start]: fail write reg 0xc0000 ...\n");
 			return ret;
@@ -1596,8 +1590,8 @@ u32 wilc_get_chipid(struct wilc *wilc, u8 update)
 	u32 rfrevid;
 
 	if (chipid == 0 || update != 0) {
-		g_wlan.hif_func.hif_read_reg(wilc, 0x1000, &tempchipid);
-		g_wlan.hif_func.hif_read_reg(wilc, 0x13f4, &rfrevid);
+		wilc->hif_func->hif_read_reg(wilc, 0x1000, &tempchipid);
+		wilc->hif_func->hif_read_reg(wilc, 0x13f4, &rfrevid);
 		if (!ISWILC1000(tempchipid)) {
 			chipid = 0;
 			goto _fail_;
@@ -1634,8 +1628,7 @@ int wilc_wlan_init(struct net_device *dev)
 
 	memset((void *)&g_wlan, 0, sizeof(wilc_wlan_dev_t));
 	g_wlan.io_type = wilc->io_type;
-	g_wlan.hif_func = *wilc->ops;
-	if (!g_wlan.hif_func.hif_init(wilc, wilc_debug)) {
+	if (!wilc->hif_func->hif_init(wilc, wilc_debug)) {
 		ret = -EIO;
 		goto _fail_;
 	}
@@ -1695,7 +1688,7 @@ u16 wilc_set_machw_change_vir_if(struct net_device *dev, bool value)
 	wilc = nic->wilc;
 
 	mutex_lock(&wilc->hif_cs);
-	ret = (&g_wlan)->hif_func.hif_read_reg(wilc, WILC_CHANGING_VIR_IF,
+	ret = wilc->hif_func->hif_read_reg(wilc, WILC_CHANGING_VIR_IF,
 					       &reg);
 	if (!ret)
 		PRINT_ER("Error while Reading reg WILC_CHANGING_VIR_IF\n");
@@ -1705,7 +1698,7 @@ u16 wilc_set_machw_change_vir_if(struct net_device *dev, bool value)
 	else
 		reg &= ~BIT(31);
 
-	ret = (&g_wlan)->hif_func.hif_write_reg(wilc, WILC_CHANGING_VIR_IF,
+	ret = wilc->hif_func->hif_write_reg(wilc, WILC_CHANGING_VIR_IF,
 						reg);
 
 	if (!ret)
-- 
1.9.1

