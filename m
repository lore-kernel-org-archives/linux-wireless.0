Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:36412 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031140AbbKFCKu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:10:50 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 04/73] staging: wilc1000: wilc_wlan.c: remove over-commenting
Date: Fri, 6 Nov 2015 11:12:25 +0900
Message-ID: <1446776014-28094-4-git-send-email-glen.lee@atmel.com> (sfid-20151106_031054_217541_1D68BE54)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

There are over-commenting in the wilc_wlan.c file and most of them
are not helpful to explain what the code does and generate 80 ending
line over warnings. So, all of comments are removed in this patch and the
comments will later be added if necessary with the preferred Linux style.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 330 +++--------------------------------
 1 file changed, 27 insertions(+), 303 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 0e5535e..7aaad0f 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1,21 +1,7 @@
-/* ////////////////////////////////////////////////////////////////////////// */
-/*  */
-/* Copyright (c) Atmel Corporation.  All rights reserved. */
-/*  */
-/* Module Name:  wilc_wlan.c */
-/*  */
-/*  */
-/* //////////////////////////////////////////////////////////////////////////// */
-
 #include "wilc_wlan_if.h"
 #include "wilc_wfi_netdevice.h"
 #include "wilc_wlan_cfg.h"
 
-/********************************************
- *
- *      Global
- *
- ********************************************/
 extern wilc_hif_func_t hif_sdio;
 extern wilc_hif_func_t hif_spi;
 u32 wilc_get_chipid(u8 update);
@@ -24,42 +10,20 @@ u32 wilc_get_chipid(u8 update);
 
 typedef struct {
 	int quit;
-
-	/**
-	 *      input interface functions
-	 **/
 	wilc_wlan_io_func_t io_func;
-
-	/**
-	 *      host interface functions
-	 **/
 	wilc_hif_func_t hif_func;
-
-	/**
-	 *      configuration interface functions
-	 **/
 	int cfg_frame_in_use;
 	wilc_cfg_frame_t cfg_frame;
 	u32 cfg_frame_offset;
 	int cfg_seq_no;
 
-	/**
-	 *      RX buffer
-	 **/
 	#ifdef MEMORY_STATIC
 	u8 *rx_buffer;
 	u32 rx_buffer_offset;
 	#endif
-	/**
-	 *      TX buffer
-	 **/
 	u8 *tx_buffer;
 	u32 tx_buffer_offset;
 
-	/**
-	 *      TX queue
-	 **/
-
 	unsigned long txq_spinlock_flags;
 
 	struct txq_entry_t *txq_head;
@@ -67,9 +31,6 @@ typedef struct {
 	int txq_entries;
 	int txq_exit;
 
-	/**
-	 *      RX queue
-	 **/
 	struct rxq_entry_t *rxq_head;
 	struct rxq_entry_t *rxq_tail;
 	int rxq_entries;
@@ -82,12 +43,6 @@ static wilc_wlan_dev_t g_wlan;
 
 static inline void chip_allow_sleep(void);
 static inline void chip_wakeup(void);
-/********************************************
- *
- *      Debug
- *
- ********************************************/
-
 static u32 dbgflag = N_INIT | N_ERR | N_INTR | N_TXQ | N_RXQ;
 
 static void wilc_debug(u32 flag, char *fmt, ...)
@@ -106,9 +61,6 @@ static void wilc_debug(u32 flag, char *fmt, ...)
 
 static CHIP_PS_STATE_T genuChipPSstate = CHIP_WAKEDUP;
 
-/*acquire_bus() and release_bus() are made static inline functions*/
-/*as a temporary workaround to fix a problem of receiving*/
-/*unknown interrupt from FW*/
 static inline void acquire_bus(BUS_ACQUIRE_T acquire)
 {
 
@@ -130,11 +82,6 @@ static inline void release_bus(BUS_RELEASE_T release)
 	#endif
 	mutex_unlock(&g_linux_wlan->hif_cs);
 }
-/********************************************
- *
- *      Queue
- *
- ********************************************/
 
 static void wilc_wlan_txq_remove(struct txq_entry_t *tqe)
 {
@@ -219,9 +166,6 @@ static void wilc_wlan_txq_add_to_tail(struct net_device *dev,
 
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 
-	/**
-	 *      wake up TX queue
-	 **/
 	PRINT_D(TX_DBG, "Wake the txq_handling\n");
 
 	up(&wilc->txq_event);
@@ -253,11 +197,6 @@ static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
 
 	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
 	up(&g_linux_wlan->txq_add_to_head_cs);
-
-
-	/**
-	 *      wake up TX queue
-	 **/
 	up(&g_linux_wlan->txq_event);
 	PRINT_D(TX_DBG, "Wake up the txq_handler\n");
 
@@ -281,7 +220,7 @@ typedef struct {
 	u32 ack_num;
 	u32 Session_index;
 	struct txq_entry_t  *txqe;
-} Pending_Acks_info_t /*Ack_info_t*/;
+} Pending_Acks_info_t;
 
 
 
@@ -373,7 +312,7 @@ static inline int tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 
 	eth_hdr_ptr = &buffer[0];
 	h_proto = ntohs(*((unsigned short *)&eth_hdr_ptr[12]));
-	if (h_proto == 0x0800) { /* IP */
+	if (h_proto == 0x0800) {
 		u8 *ip_hdr_ptr;
 		u8 protocol;
 
@@ -389,7 +328,7 @@ static inline int tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 			IHL = (ip_hdr_ptr[0] & 0xf) << 2;
 			Total_Length = (((u32)ip_hdr_ptr[2]) << 8) + ((u32)ip_hdr_ptr[3]);
 			Data_offset = (((u32)tcp_hdr_ptr[12] & 0xf0) >> 2);
-			if (Total_Length == (IHL + Data_offset)) { /*we want to recognize the clear Acks(packet only carry Ack infos not with data) so data size must be equal zero*/
+			if (Total_Length == (IHL + Data_offset)) {
 				u32 seq_no, Ack_no;
 
 				seq_no	= (((u32)tcp_hdr_ptr[4]) << 24) + (((u32)tcp_hdr_ptr[5]) << 16) + (((u32)tcp_hdr_ptr[6]) << 8) + ((u32)tcp_hdr_ptr[7]);
@@ -443,7 +382,7 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 			if (tqe) {
 				wilc_wlan_txq_remove(tqe);
 				Statisitcs_DroppedAcks++;
-				tqe->status = 1;                                /* mark the packet send */
+				tqe->status = 1;
 				if (tqe->tx_complete_func)
 					tqe->tx_complete_func(tqe->priv, tqe->status);
 				kfree(tqe);
@@ -463,7 +402,6 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 	spin_unlock_irqrestore(&wilc->txq_spinlock, p->txq_spinlock_flags);
 
 	while (Dropped > 0) {
-		/*consume the semaphore count of the removed packet*/
 		linux_wlan_lock_timeout(&wilc->txq_event, 1);
 		Dropped--;
 	}
@@ -510,9 +448,6 @@ static int wilc_wlan_txq_add_cfg_pkt(u8 *buffer, u32 buffer_size)
 #ifdef TCP_ACK_FILTER
 	tqe->tcp_PendingAck_index = NOT_TCP_ACK;
 #endif
-	/**
-	 *      Configuration packet always at the front
-	 **/
 	PRINT_D(TX_DBG, "Adding the config packet at the Queue tail\n");
 
 	if (wilc_wlan_txq_add_to_head(tqe))
@@ -546,7 +481,6 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 		tcp_process(dev, tqe);
 #endif
 	wilc_wlan_txq_add_to_tail(dev, tqe);
-	/*return number of itemes in the queue*/
 	return p->txq_entries;
 }
 
@@ -651,22 +585,12 @@ static struct rxq_entry_t *wilc_wlan_rxq_remove(struct wilc *wilc)
 	return NULL;
 }
 
-
-/********************************************
- *
- *      Power Save handle functions
- *
- ********************************************/
-
-
-
 #ifdef WILC_OPTIMIZE_SLEEP_INT
 
 static inline void chip_allow_sleep(void)
 {
 	u32 reg = 0;
 
-	/* Clear bit 1 */
 	g_wlan.hif_func.hif_read_reg(0xf0, &reg);
 
 	g_wlan.hif_func.hif_write_reg(0xf0, reg & ~BIT(0));
@@ -680,17 +604,11 @@ static inline void chip_wakeup(void)
 	if ((g_wlan.io_func.io_type & 0x1) == HIF_SPI) {
 		do {
 			g_wlan.hif_func.hif_read_reg(1, &reg);
-			/* Set bit 1 */
 			g_wlan.hif_func.hif_write_reg(1, reg | BIT(1));
-
-			/* Clear bit 1*/
 			g_wlan.hif_func.hif_write_reg(1, reg & ~BIT(1));
 
 			do {
-				/* Wait for the chip to stabilize*/
 				usleep_range(2 * 1000, 2 * 1000);
-				/* Make sure chip is awake. This is an extra step that can be removed */
-				/* later to avoid the bus access overhead */
 				if ((wilc_get_chipid(true) == 0))
 					wilc_debug(N_ERR, "Couldn't read chip id. Wake up failed\n");
 
@@ -700,30 +618,19 @@ static inline void chip_wakeup(void)
 	} else if ((g_wlan.io_func.io_type & 0x1) == HIF_SDIO)	 {
 		g_wlan.hif_func.hif_read_reg(0xf0, &reg);
 		do {
-			/* Set bit 1 */
 			g_wlan.hif_func.hif_write_reg(0xf0, reg | BIT(0));
-
-			/* Check the clock status */
 			g_wlan.hif_func.hif_read_reg(0xf1, &clk_status_reg);
 
-			/* in case of clocks off, wait 2ms, and check it again. */
-			/* if still off, wait for another 2ms, for a total wait of 6ms. */
-			/* If still off, redo the wake up sequence */
 			while (((clk_status_reg & 0x1) == 0) && (((++trials) % 3) == 0)) {
-				/* Wait for the chip to stabilize*/
 				usleep_range(2 * 1000, 2 * 1000);
 
-				/* Make sure chip is awake. This is an extra step that can be removed */
-				/* later to avoid the bus access overhead */
 				g_wlan.hif_func.hif_read_reg(0xf1, &clk_status_reg);
 
 				if ((clk_status_reg & 0x1) == 0)
 					wilc_debug(N_ERR, "clocks still OFF. Wake up failed\n");
 
 			}
-			/* in case of failure, Reset the wakeup bit to introduce a new edge on the next loop */
 			if ((clk_status_reg & 0x1) == 0) {
-				/* Reset bit 0 */
 				g_wlan.hif_func.hif_write_reg(0xf0, reg &
 							      (~BIT(0)));
 			}
@@ -737,7 +644,6 @@ static inline void chip_wakeup(void)
 		g_wlan.hif_func.hif_write_reg(0x1C0C, reg);
 
 		if (wilc_get_chipid(false) >= 0x1002b0) {
-			/* Enable PALDO back right after wakeup */
 			u32 val32;
 
 			g_wlan.hif_func.hif_read_reg(0x1e1c, &val32);
@@ -759,28 +665,19 @@ static inline void chip_wakeup(void)
 	do {
 		if ((g_wlan.io_func.io_type & 0x1) == HIF_SPI) {
 			g_wlan.hif_func.hif_read_reg(1, &reg);
-			/* Make sure bit 1 is 0 before we start. */
 			g_wlan.hif_func.hif_write_reg(1, reg & ~BIT(1));
-			/* Set bit 1 */
 			g_wlan.hif_func.hif_write_reg(1, reg | BIT(1));
-			/* Clear bit 1*/
 			g_wlan.hif_func.hif_write_reg(1, reg  & ~BIT(1));
 		} else if ((g_wlan.io_func.io_type & 0x1) == HIF_SDIO)	 {
-			/* Make sure bit 0 is 0 before we start. */
 			g_wlan.hif_func.hif_read_reg(0xf0, &reg);
 			g_wlan.hif_func.hif_write_reg(0xf0, reg & ~BIT(0));
-			/* Set bit 1 */
 			g_wlan.hif_func.hif_write_reg(0xf0, reg | BIT(0));
-			/* Clear bit 1 */
 			g_wlan.hif_func.hif_write_reg(0xf0, reg  & ~BIT(0));
 		}
 
 		do {
-			/* Wait for the chip to stabilize*/
 			mdelay(3);
 
-			/* Make sure chip is awake. This is an extra step that can be removed */
-			/* later to avoid the bus access overhead */
 			if ((wilc_get_chipid(true) == 0))
 				wilc_debug(N_ERR, "Couldn't read chip id. Wake up failed\n");
 
@@ -794,7 +691,6 @@ static inline void chip_wakeup(void)
 		g_wlan.hif_func.hif_write_reg(0x1C0C, reg);
 
 		if (wilc_get_chipid(false) >= 0x1002b0) {
-			/* Enable PALDO back right after wakeup */
 			u32 val32;
 
 			g_wlan.hif_func.hif_read_reg(0x1e1c, &val32);
@@ -811,17 +707,13 @@ static inline void chip_wakeup(void)
 #endif
 void chip_sleep_manually(u32 u32SleepTime)
 {
-	if (genuChipPSstate != CHIP_WAKEDUP) {
-		/* chip is already sleeping. Do nothing */
+	if (genuChipPSstate != CHIP_WAKEDUP)
 		return;
-	}
 	acquire_bus(ACQUIRE_ONLY);
 
 #ifdef WILC_OPTIMIZE_SLEEP_INT
 	chip_allow_sleep();
 #endif
-
-	/* Trigger the manual sleep interrupt */
 	g_wlan.hif_func.hif_write_reg(0x10a8, 1);
 
 	genuChipPSstate = CHIP_SLEEPING_MANUAL;
@@ -829,12 +721,6 @@ void chip_sleep_manually(u32 u32SleepTime)
 
 }
 
-
-/********************************************
- *
- *      Tx, Rx queue handle functions
- *
- ********************************************/
 int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
@@ -865,15 +751,12 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 #ifdef	TCP_ACK_FILTER
 		wilc_wlan_txq_filter_dup_tcp_ack(dev);
 #endif
-		/**
-		 *      build the vmm list
-		 **/
 		PRINT_D(TX_DBG, "Getting the head of the TxQ\n");
 		tqe = wilc_wlan_txq_get_first(wilc);
 		i = 0;
 		sum = 0;
 		do {
-			if ((tqe != NULL) && (i < (WILC_VMM_TBL_SIZE - 1)) /* reserve last entry to 0 */) {
+			if ((tqe != NULL) && (i < (WILC_VMM_TBL_SIZE - 1))) {
 
 				if (tqe->type == WILC_CFG_PKT)
 					vmm_sz = ETH_CONFIG_PKT_HDR_OFFSET;
@@ -886,14 +769,14 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 
 				vmm_sz += tqe->buffer_size;
 				PRINT_D(TX_DBG, "VMM Size before alignment = %d\n", vmm_sz);
-				if (vmm_sz & 0x3) {                                                                                                     /* has to be word aligned */
+				if (vmm_sz & 0x3)
 					vmm_sz = (vmm_sz + 4) & ~0x3;
-				}
+
 				if ((sum + vmm_sz) > LINUX_TX_SIZE)
 					break;
 
 				PRINT_D(TX_DBG, "VMM Size AFTER alignment = %d\n", vmm_sz);
-				vmm_table[i] = vmm_sz / 4;                                                                                /* table take the word size */
+				vmm_table[i] = vmm_sz / 4;
 				PRINT_D(TX_DBG, "VMMTable entry size = %d\n", vmm_table[i]);
 
 				if (tqe->type == WILC_CFG_PKT) {
@@ -913,12 +796,12 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 			}
 		} while (1);
 
-		if (i == 0) {           /* nothing in the queue */
+		if (i == 0) {
 			PRINT_D(TX_DBG, "Nothing in TX-Q\n");
 			break;
 		} else {
 			PRINT_D(TX_DBG, "Mark the last entry in VMM table - number of previous entries = %d\n", i);
-			vmm_table[i] = 0x0;     /* mark the last element to 0 */
+			vmm_table[i] = 0x0;
 		}
 		acquire_bus(ACQUIRE_AND_WAKEUP);
 		counter = 0;
@@ -931,9 +814,6 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 			}
 
 			if ((reg & 0x1) == 0) {
-				/**
-				 *      write to vmm table
-				 **/
 				PRINT_D(TX_DBG, "Writing VMM table ... with Size = %d\n", ((i + 1) * 4));
 				break;
 			} else {
@@ -944,9 +824,6 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 					ret = p->hif_func.hif_write_reg(WILC_HOST_TX_CTRL, 0);
 					break;
 				}
-				/**
-				 *      wait for vmm table is ready
-				 **/
 				PRINT_WRN(GENERIC_DBG, "[wilc txq]: warn, vmm table not clear yet, wait...\n");
 				release_bus(RELEASE_ALLOW_SLEEP);
 				usleep_range(3000, 3000);
@@ -959,30 +836,18 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 
 		timeout = 200;
 		do {
-
-			/**
-			 * write to vmm table
-			 **/
 			ret = p->hif_func.hif_block_tx(WILC_VMM_TBL_RX_SHADOW_BASE, (u8 *)vmm_table, ((i + 1) * 4));
 			if (!ret) {
 				wilc_debug(N_ERR, "ERR block TX of VMM table.\n");
 				break;
 			}
 
-
-			/**
-			 * interrupt firmware
-			 **/
 			ret = p->hif_func.hif_write_reg(WILC_HOST_VMM_CTL, 0x2);
 			if (!ret) {
 				wilc_debug(N_ERR, "[wilc txq]: fail can't write reg host_vmm_ctl..\n");
 				break;
 			}
 
-			/**
-			 *      wait for confirm...
-			 **/
-
 			do {
 				ret = p->hif_func.hif_read_reg(WILC_HOST_VMM_CTL, &reg);
 				if (!ret) {
@@ -990,9 +855,6 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 					break;
 				}
 				if ((reg >> 2) & 0x1) {
-					/**
-					 *      Get the entries
-					 **/
 					entries = ((reg >> 3) & 0x3f);
 					break;
 				} else {
@@ -1013,7 +875,6 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 			if (entries == 0) {
 				PRINT_WRN(GENERIC_DBG, "[wilc txq]: no more buffer in the chip (reg: %08x), retry later [[ %d, %x ]]\n", reg, i, vmm_table[i - 1]);
 
-				/* undo the transaction. */
 				ret = p->hif_func.hif_read_reg(WILC_HOST_TX_CTRL, &reg);
 				if (!ret) {
 					wilc_debug(N_ERR, "[wilc txq]: fail can't read reg WILC_HOST_TX_CTRL..\n");
@@ -1039,13 +900,8 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 			goto _end_;
 		}
 
-		/* since copying data into txb takes some time, then
-		 * allow the bus lock to be released let the RX task go. */
 		release_bus(RELEASE_ALLOW_SLEEP);
 
-		/**
-		 *      Copy data to the TX buffer
-		 **/
 		offset = 0;
 		i = 0;
 		do {
@@ -1056,7 +912,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 #ifdef BIG_ENDIAN
 				vmm_table[i] = BYTE_SWAP(vmm_table[i]);
 #endif
-				vmm_sz = (vmm_table[i] & 0x3ff);        /* in word unit */
+				vmm_sz = (vmm_table[i] & 0x3ff);
 				vmm_sz *= 4;
 				header = (tqe->type << 31) | (tqe->buffer_size << 15) | vmm_sz;
 				if (tqe->type == WILC_MGMT_PKT)
@@ -1075,7 +931,6 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 					char *pBSSID = ((struct tx_complete_data *)(tqe->priv))->pBssid;
 
 					buffer_offset = ETH_ETHERNET_HDR_OFFSET;
-					/* copy the bssid at the sart of the buffer */
 					memcpy(&txb[offset + 4], pBSSID, 6);
 				}
 				else {
@@ -1085,7 +940,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 				memcpy(&txb[offset + buffer_offset], tqe->buffer, tqe->buffer_size);
 				offset += vmm_sz;
 				i++;
-				tqe->status = 1;                                /* mark the packet send */
+				tqe->status = 1;
 				if (tqe->tx_complete_func)
 					tqe->tx_complete_func(tqe->priv, tqe->status);
 				#ifdef TCP_ACK_FILTER
@@ -1098,9 +953,6 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 			}
 		} while (--entries);
 
-		/**
-		 *      lock the bus
-		 **/
 		acquire_bus(ACQUIRE_AND_WAKEUP);
 
 		ret = p->hif_func.hif_clear_int_ext(ENABLE_TX_VMM);
@@ -1109,9 +961,6 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 			goto _end_;
 		}
 
-		/**
-		 *      transfer
-		 **/
 		ret = p->hif_func.hif_block_tx_ext(0, txb, offset);
 		if (!ret) {
 			wilc_debug(N_ERR, "[wilc txq]: fail can't block tx ext...\n");
@@ -1128,7 +977,6 @@ _end_:
 
 	p->txq_exit = 1;
 	PRINT_D(TX_DBG, "THREAD: Exiting txq\n");
-	/* return tx[]q count */
 	*pu32TxqCount = p->txq_entries;
 	return ret;
 }
@@ -1193,7 +1041,6 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 
 
 			if (pkt_offset & IS_MANAGMEMENT) {
-				/* reset mgmt indicator bit, to use pkt_offeset in furthur calculations */
 				pkt_offset &= ~(IS_MANAGMEMENT | IS_MANAGMEMENT_CALLBACK | IS_MGMT_STATUS_SUCCES);
 
 				WILC_WFI_mgmt_rx(wilc, &buffer[offset + HOST_HDR_OFFSET], pkt_len);
@@ -1216,16 +1063,10 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 
 					wilc_wlan_cfg_indicate_rx(&buffer[pkt_offset + offset], pkt_len, &rsp);
 					if (rsp.type == WILC_CFG_RSP) {
-						/**
-						 *      wake up the waiting task...
-						 **/
 						PRINT_D(RX_DBG, "p->cfg_seq_no = %d - rsp.seq_no = %d\n", p->cfg_seq_no, rsp.seq_no);
 						if (p->cfg_seq_no == rsp.seq_no)
 							up(&wilc->cfg_event);
 					} else if (rsp.type == WILC_CFG_RSP_STATUS) {
-						/**
-						 *      Call back to indicate status...
-						 **/
 						linux_wlan_mac_indicate(wilc, WILC_MAC_INDICATE_STATUS);
 
 					} else if (rsp.type == WILC_CFG_RSP_SCAN) {
@@ -1253,11 +1094,6 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 	PRINT_D(RX_DBG, "THREAD: Exiting RX thread\n");
 }
 
-/********************************************
- *
- *      Fast DMA Isr
- *
- ********************************************/
 static void wilc_unknown_isr_ext(void)
 {
 	g_wlan.hif_func.hif_clear_int_ext(0);
@@ -1269,10 +1105,8 @@ static void wilc_pllupdate_isr_ext(u32 int_stats)
 
 	g_wlan.hif_func.hif_clear_int_ext(PLL_INT_CLR);
 
-	/* Waiting for PLL */
 	mdelay(WILC_PLL_TO);
 
-	/* poll till read a valid data */
 	while (!(ISWILC1000(wilc_get_chipid(true)) && --trials)) {
 		PRINT_D(TX_DBG, "PLL update retrying\n");
 		mdelay(1);
@@ -1299,17 +1133,11 @@ static void wilc_wlan_handle_isr_ext(struct wilc *wilc, u32 int_status)
 	int ret = 0;
 	struct rxq_entry_t *rqe;
 
-
-	/**
-	 *      Get the rx size
-	 **/
-
 	size = ((int_status & 0x7fff) << 2);
 
 	while (!size && retries < 10) {
 		u32 time = 0;
-		/*looping more secure*/
-		/*zero size make a crashe because the dma will not happen and that will block the firmware*/
+
 		wilc_debug(N_ERR, "RX Size equal zero ... Trying to read it again for %d time\n", time++);
 		p->hif_func.hif_read_size(&size);
 		size = ((size & 0x7fff) << 2);
@@ -1337,16 +1165,7 @@ static void wilc_wlan_handle_isr_ext(struct wilc *wilc, u32 int_status)
 			goto _end_;
 		}
 #endif
-
-		/**
-		 *      clear the chip's interrupt	 after getting size some register getting corrupted after clear the interrupt
-		 **/
 		p->hif_func.hif_clear_int_ext(DATA_INT_CLR | ENABLE_RX_VMM);
-
-
-		/**
-		 * start transfer
-		 **/
 		ret = p->hif_func.hif_block_rx_ext(0, buffer, size);
 
 		if (!ret) {
@@ -1361,9 +1180,6 @@ _end_:
 			offset += size;
 			p->rx_buffer_offset = offset;
 #endif
-			/**
-			 *      add to rx queue
-			 **/
 			rqe = kmalloc(sizeof(struct rxq_entry_t), GFP_KERNEL);
 			if (rqe != NULL) {
 				rqe->buffer = buffer;
@@ -1393,7 +1209,6 @@ void wilc_handle_isr(void *wilc)
 	if (int_status & DATA_INT_EXT) {
 		wilc_wlan_handle_isr_ext(wilc, int_status);
 	#ifndef WILC_OPTIMIZE_SLEEP_INT
-		/* Chip is up and talking*/
 		genuChipPSstate = CHIP_WAKEDUP;
 	#endif
 	}
@@ -1409,11 +1224,6 @@ void wilc_handle_isr(void *wilc)
 	release_bus(RELEASE_ALLOW_SLEEP);
 }
 
-/********************************************
- *
- *      Firmware download
- *
- ********************************************/
 int wilc_wlan_firmware_download(const u8 *buffer, u32 buffer_size)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
@@ -1423,20 +1233,16 @@ int wilc_wlan_firmware_download(const u8 *buffer, u32 buffer_size)
 	int ret = 0;
 
 	blksz = BIT(12);
-	/* Allocate a DMA coherent  buffer. */
 
 	dma_buffer = kmalloc(blksz, GFP_KERNEL);
 	if (dma_buffer == NULL) {
-		/*EIO	5*/
 		ret = -5;
 		PRINT_ER("Can't allocate buffer for firmware download IO error\n ");
 		goto _fail_1;
 	}
 
 	PRINT_D(INIT_DBG, "Downloading firmware size = %d ...\n", buffer_size);
-	/**
-	 *      load the firmware
-	 **/
+
 	offset = 0;
 	do {
 		memcpy(&addr, &buffer[offset], 4);
@@ -1452,7 +1258,7 @@ int wilc_wlan_firmware_download(const u8 *buffer, u32 buffer_size)
 				size2 = size;
 			else
 				size2 = blksz;
-			/* Copy firmware into a DMA coherent buffer */
+
 			memcpy(dma_buffer, &buffer[offset], size2);
 			ret = p->hif_func.hif_block_tx(addr, dma_buffer, size2);
 			if (!ret)
@@ -1465,7 +1271,6 @@ int wilc_wlan_firmware_download(const u8 *buffer, u32 buffer_size)
 		release_bus(RELEASE_ONLY);
 
 		if (!ret) {
-			/*EIO	5*/
 			ret = -5;
 			PRINT_ER("Can't download firmware IO error\n ");
 			goto _fail_;
@@ -1482,11 +1287,6 @@ _fail_1:
 	return (ret < 0) ? ret : 0;
 }
 
-/********************************************
- *
- *      Common
- *
- ********************************************/
 int wilc_wlan_start(void)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
@@ -1494,12 +1294,9 @@ int wilc_wlan_start(void)
 	int ret;
 	u32 chipid;
 
-	/**
-	 *      Set the host interface
-	 **/
 	if (p->io_func.io_type == HIF_SDIO) {
 		reg = 0;
-		reg |= BIT(3); /* bug 4456 and 4557 */
+		reg |= BIT(3);
 	} else if (p->io_func.io_type == HIF_SPI) {
 		reg = 1;
 	}
@@ -1508,7 +1305,6 @@ int wilc_wlan_start(void)
 	if (!ret) {
 		wilc_debug(N_ERR, "[wilc start]: fail write reg vmm_core_cfg...\n");
 		release_bus(RELEASE_ONLY);
-		/* EIO  5*/
 		ret = -5;
 		return ret;
 	}
@@ -1533,14 +1329,9 @@ int wilc_wlan_start(void)
 #endif
 
 	reg |= WILC_HAVE_LEGACY_RF_SETTINGS;
-
-
-/*Set oscillator frequency*/
 #ifdef XTAL_24
 	reg |= WILC_HAVE_XTAL_24;
 #endif
-
-/*Enable/Disable GPIO configuration for FW logs*/
 #ifdef DISABLE_WILC_UART
 	reg |= WILC_HAVE_DISABLE_WILC_UART;
 #endif
@@ -1549,30 +1340,20 @@ int wilc_wlan_start(void)
 	if (!ret) {
 		wilc_debug(N_ERR, "[wilc start]: fail write WILC_GP_REG_1 ...\n");
 		release_bus(RELEASE_ONLY);
-		/* EIO  5*/
 		ret = -5;
 		return ret;
 	}
 
-	/**
-	 *      Bus related
-	 **/
 	p->hif_func.hif_sync_ext(NUM_INT_EXT);
 
 	ret = p->hif_func.hif_read_reg(0x1000, &chipid);
 	if (!ret) {
 		wilc_debug(N_ERR, "[wilc start]: fail read reg 0x1000 ...\n");
 		release_bus(RELEASE_ONLY);
-		/* EIO  5*/
 		ret = -5;
 		return ret;
 	}
 
-	/**
-	 *      Go...
-	 **/
-
-
 	p->hif_func.hif_read_reg(WILC_GLB_RESET_0, &reg);
 	if ((reg & BIT(10)) == BIT(10)) {
 		reg &= ~BIT(10);
@@ -1603,9 +1384,6 @@ int wilc_wlan_stop(void)
 	u32 reg = 0;
 	int ret;
 	u8 timeout = 10;
-	/**
-	 *      TODO: stop the firmware, need a re-download
-	 **/
 	acquire_bus(ACQUIRE_AND_WAKEUP);
 
 	ret = p->hif_func.hif_read_reg(WILC_GLB_RESET_0, &reg);
@@ -1635,7 +1413,7 @@ int wilc_wlan_stop(void)
 			return ret;
 		}
 		PRINT_D(GENERIC_DBG, "Read RESET Reg %x : Retry%d\n", reg, timeout);
-		/*Workaround to ensure that the chip is actually reset*/
+
 		if ((reg & BIT(10))) {
 			PRINT_D(GENERIC_DBG, "Bit 10 not reset : Retry %d\n", timeout);
 			reg &= ~BIT(10);
@@ -1700,10 +1478,6 @@ void wilc_wlan_cleanup(struct net_device *dev)
 		kfree(rqe);
 	} while (1);
 
-	/**
-	 *      clean up buffer
-	 **/
-
 	#ifdef MEMORY_STATIC
 	kfree(p->rx_buffer);
 	p->rx_buffer = NULL;
@@ -1725,9 +1499,6 @@ void wilc_wlan_cleanup(struct net_device *dev)
 		release_bus(RELEASE_ALLOW_SLEEP);
 	}
 	release_bus(RELEASE_ALLOW_SLEEP);
-	/**
-	 *      io clean up
-	 **/
 	p->hif_func.hif_deinit(NULL);
 
 }
@@ -1740,16 +1511,12 @@ static int wilc_wlan_cfg_commit(int type, u32 drvHandler)
 	int seq_no = p->cfg_seq_no % 256;
 	int driver_handler = (u32)drvHandler;
 
-
-	/**
-	 *      Set up header
-	 **/
-	if (type == WILC_CFG_SET) {             /* Set */
+	if (type == WILC_CFG_SET) {
 		cfg->wid_header[0] = 'W';
-	} else {                                        /* Query */
+	} else {
 		cfg->wid_header[0] = 'Q';
 	}
-	cfg->wid_header[1] = seq_no;    /* sequence number */
+	cfg->wid_header[1] = seq_no;
 	cfg->wid_header[2] = (u8)total_len;
 	cfg->wid_header[3] = (u8)(total_len >> 8);
 	cfg->wid_header[4] = (u8)driver_handler;
@@ -1758,10 +1525,6 @@ static int wilc_wlan_cfg_commit(int type, u32 drvHandler)
 	cfg->wid_header[7] = (u8)(driver_handler >> 24);
 	p->cfg_seq_no = seq_no;
 
-	/**
-	 *      Add to TX queue
-	 **/
-
 	if (!wilc_wlan_txq_add_cfg_pkt(&cfg->wid_header[0], total_len))
 		return -1;
 
@@ -1859,15 +1622,11 @@ int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size)
 
 void wilc_bus_set_max_speed(void)
 {
-
-	/* Increase bus speed to max possible.  */
 	g_wlan.hif_func.hif_set_max_bus_speed();
 }
 
 void wilc_bus_set_default_speed(void)
 {
-
-	/* Restore bus speed to default.  */
 	g_wlan.hif_func.hif_set_default_bus_speed();
 }
 u32 init_chip(struct net_device *dev)
@@ -1882,11 +1641,6 @@ u32 init_chip(struct net_device *dev)
 
 
 	if ((chipid & 0xfff) != 0xa0) {
-		/**
-		 * Avoid booting from boot ROM. Make sure that Drive IRQN [SDIO platform]
-		 * or SD_DAT3 [SPI platform] to ?1?
-		 **/
-		/* Set cortus reset register to register control. */
 		ret = g_wlan.hif_func.hif_read_reg(0x1118, &reg);
 		if (!ret) {
 			wilc_debug(N_ERR, "[wilc start]: fail read reg 0x1118 ...\n");
@@ -1898,10 +1652,6 @@ u32 init_chip(struct net_device *dev)
 			wilc_debug(N_ERR, "[wilc start]: fail write reg 0x1118 ...\n");
 			return ret;
 		}
-		/**
-		 * Write branch intruction to IRAM (0x71 trap) at location 0xFFFF0000
-		 * (Cortus map) or C0000 (AHB map).
-		 **/
 		ret = g_wlan.hif_func.hif_write_reg(0xc0000, 0x71);
 		if (!ret) {
 			wilc_debug(N_ERR, "[wilc start]: fail write reg 0xc0000 ...\n");
@@ -1918,8 +1668,6 @@ u32 init_chip(struct net_device *dev)
 u32 wilc_get_chipid(u8 update)
 {
 	static u32 chipid;
-	/* SDIO can't read into global variables */
-	/* Use this variable as a temp, then copy to the global */
 	u32 tempchipid = 0;
 	u32 rfrevid;
 
@@ -1931,15 +1679,15 @@ u32 wilc_get_chipid(u8 update)
 			goto _fail_;
 		}
 		if (tempchipid == 0x1002a0) {
-			if (rfrevid == 0x1) { /* 1002A0 */
-			} else { /* if (rfrevid == 0x2) */   /* 1002A1 */
+			if (rfrevid == 0x1) {
+			} else {
 				tempchipid = 0x1002a1;
 			}
 		} else if (tempchipid == 0x1002b0) {
-			if (rfrevid == 3) { /* 1002B0 */
-			} else if (rfrevid == 4) { /* 1002B1 */
+			if (rfrevid == 3) {
+			} else if (rfrevid == 4) {
 				tempchipid = 0x1002b1;
-			} else { /* if(rfrevid == 5) */   /* 1002B2 */
+			} else {
 				tempchipid = 0x1002b2;
 			}
 		} else {
@@ -1959,69 +1707,47 @@ int wilc_wlan_init(struct net_device *dev, wilc_wlan_inp_t *inp)
 	PRINT_D(INIT_DBG, "Initializing WILC_Wlan ...\n");
 
 	memset((void *)&g_wlan, 0, sizeof(wilc_wlan_dev_t));
-
-	/**
-	 *      store the input
-	 **/
 	memcpy((void *)&g_wlan.io_func, (void *)&inp->io_func, sizeof(wilc_wlan_io_func_t));
-	/***
-	 *      host interface init
-	 **/
+
 	if ((inp->io_func.io_type & 0x1) == HIF_SDIO) {
 		if (!hif_sdio.hif_init(inp, wilc_debug)) {
-			/* EIO	5 */
 			ret = -5;
 			goto _fail_;
 		}
 		memcpy((void *)&g_wlan.hif_func, &hif_sdio, sizeof(wilc_hif_func_t));
 	} else {
 		if ((inp->io_func.io_type & 0x1) == HIF_SPI) {
-			/**
-			 *      TODO:
-			 **/
 			if (!hif_spi.hif_init(inp, wilc_debug)) {
-				/* EIO	5 */
 				ret = -5;
 				goto _fail_;
 			}
 			memcpy((void *)&g_wlan.hif_func, &hif_spi, sizeof(wilc_hif_func_t));
 		} else {
-			/* EIO	5 */
 			ret = -5;
 			goto _fail_;
 		}
 	}
 
-	/***
-	 *      mac interface init
-	 **/
 	if (!wilc_wlan_cfg_init(wilc_debug)) {
-		/* ENOBUFS	105 */
 		ret = -105;
 		goto _fail_;
 	}
 
-	/**
-	 *      alloc tx, rx buffer
-	 **/
 	if (g_wlan.tx_buffer == NULL)
 		g_wlan.tx_buffer = kmalloc(LINUX_TX_SIZE, GFP_KERNEL);
 	PRINT_D(TX_DBG, "g_wlan.tx_buffer = %p\n", g_wlan.tx_buffer);
 
 	if (g_wlan.tx_buffer == NULL) {
-		/* ENOBUFS	105 */
 		ret = -105;
 		PRINT_ER("Can't allocate Tx Buffer");
 		goto _fail_;
 	}
 
-/* rx_buffer is not used unless we activate USE_MEM STATIC which is not applicable, allocating such memory is useless*/
 #if defined (MEMORY_STATIC)
 	if (g_wlan.rx_buffer == NULL)
 		g_wlan.rx_buffer = kmalloc(LINUX_RX_SIZE, GFP_KERNEL);
 	PRINT_D(TX_DBG, "g_wlan.rx_buffer =%p\n", g_wlan.rx_buffer);
 	if (g_wlan.rx_buffer == NULL) {
-		/* ENOBUFS	105 */
 		ret = -105;
 		PRINT_ER("Can't allocate Rx Buffer");
 		goto _fail_;
@@ -2029,7 +1755,6 @@ int wilc_wlan_init(struct net_device *dev, wilc_wlan_inp_t *inp)
 #endif
 
 	if (!init_chip(dev)) {
-		/* EIO	5 */
 		ret = -5;
 		goto _fail_;
 	}
@@ -2062,7 +1787,6 @@ u16 set_machw_change_vir_if(struct net_device *dev, bool bValue)
 	nic = netdev_priv(dev);
 	wilc = nic->wilc;
 
-	/*Reset WILC_CHANGING_VIR_IF register to allow adding futrue keys to CE H/W*/
 	mutex_lock(&wilc->hif_cs);
 	ret = (&g_wlan)->hif_func.hif_read_reg(WILC_CHANGING_VIR_IF, &reg);
 	if (!ret)
-- 
1.9.1

