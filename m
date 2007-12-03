Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52318 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961AbXLCLol (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 06:44:41 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ben Cahill <ben.m.cahill@intel.com>
Subject: [PATCH 07/34] iwlwifi: clean up and clarify some comments after 3945/4965 split
Date: Mon,  3 Dec 2007 13:43:19 +0200
Message-Id: <11966822291143-git-send-email-tomas.winkler@intel.com> (sfid-20071203_114449_950335_91217083)
In-Reply-To: <11966822293340-git-send-email-tomas.winkler@intel.com>
References: <11966822261109-git-send-email-tomas.winkler@intel.com>
 <11966822291406-git-send-email-tomas.winkler@intel.com>
 <1196682229843-git-send-email-tomas.winkler@intel.com>
 <11966822293932-git-send-email-tomas.winkler@intel.com>
 <11966822291956-git-send-email-tomas.winkler@intel.com>
 <119668222978-git-send-email-tomas.winkler@intel.com>
 <11966822293340-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Clean up and clarify some comments after 3945/4965 split.

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.h  |   11 ++-
 drivers/net/wireless/iwlwifi/iwl-4965-rs.h  |    5 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  126 ++++++++-------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |  163 ++++++++++++---------------
 4 files changed, 132 insertions(+), 173 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.h b/drivers/net/wireless/iwlwifi/iwl-3945-rs.h
index 075f7de..e21a5ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.h
@@ -28,8 +28,8 @@
 #define __iwl_3945_rs_h__
 
 struct iwl3945_rate_info {
-	u8 plcp;
-	u8 ieee;
+	u8 plcp;		/* uCode API:  IWL_RATE_6M_PLCP, etc. */
+	u8 ieee;		/* MAC header:  IWL_RATE_6M_IEEE, etc. */
 	u8 prev_ieee;		/* previous rate in IEEE speeds */
 	u8 next_ieee;		/* next rate in IEEE speeds */
 	u8 prev_rs;		/* previous rate used in rs algo */
@@ -38,9 +38,12 @@ struct iwl3945_rate_info {
 	u8 next_rs_tgg;		/* next rate used in TGG rs algo */
         u8 table_rs_index;	/* index in rate scale table cmd */
         u8 prev_table_rs;	/* prev in rate table cmd */
-
 };
 
+/*
+ * These serve as indexes into
+ * struct iwl3945_rate_info iwl3945_rates[IWL_RATE_COUNT];
+ */
 enum {
 	IWL_RATE_1M_INDEX = 0,
 	IWL_RATE_2M_INDEX,
@@ -96,6 +99,7 @@ enum {
 #define	IWL_RATE_5M_MASK   (1<<IWL_RATE_5M_INDEX)
 #define	IWL_RATE_11M_MASK  (1<<IWL_RATE_11M_INDEX)
 
+/* 3945 uCode API values for (legacy) bit rates, both OFDM and CCK */
 enum {
 	IWL_RATE_6M_PLCP = 13,
 	IWL_RATE_9M_PLCP = 15,
@@ -111,6 +115,7 @@ enum {
 	IWL_RATE_11M_PLCP = 110,
 };
 
+/* MAC header values for bit rates */
 enum {
 	IWL_RATE_6M_IEEE = 12,
 	IWL_RATE_9M_IEEE = 18,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.h b/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
index 86f62d8..0c9552b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
@@ -42,7 +42,10 @@ struct iwl4965_rate_info {
 	u8 next_rs_tgg;  /* next rate used in TGG rs algo */
 };
 
-/* For driver (not uCode API) */
+/*
+ * These serve as indexes into
+ * struct iwl4965_rate_info iwl4965_rates[IWL_RATE_COUNT];
+ */
 enum {
 	IWL_RATE_1M_INDEX = 0,
 	IWL_RATE_2M_INDEX,
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 415dbc9..775f9a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -27,16 +27,6 @@
  *
  *****************************************************************************/
 
-/*
- * NOTE:  This file (iwl-base.c) is used to build to multiple hardware targets
- * by defining IWL to either 3945 or 4965.  The Makefile used when building
- * the base targets will create base-3945.o and base-4965.o
- *
- * The eventual goal is to move as many of the #if IWL / #endif blocks out of
- * this file and into the hardware specific implementation files (iwl-XXXX.c)
- * and leave only the common (non #ifdef sprinkled) code in this file
- */
-
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/version.h>
@@ -75,9 +65,9 @@ static int iwl3945_tx_queue_update_write_ptr(struct iwl3945_priv *priv,
 /* module parameters */
 static int iwl3945_param_disable_hw_scan;
 static int iwl3945_param_debug;
-static int iwl3945_param_disable;      /* def: enable radio */
-static int iwl3945_param_antenna;      /* def: 0 = both antennas (use diversity) */
-int iwl3945_param_hwcrypto;     /* def: using software encryption */
+static int iwl3945_param_disable;  /* def: enable radio */
+static int iwl3945_param_antenna;  /* def: 0 = both antennas (use diversity) */
+int iwl3945_param_hwcrypto;        /* def: using software encryption */
 static int iwl3945_param_qos_enable = 1;
 int iwl3945_param_queues_num = IWL_MAX_NUM_QUEUES;
 
@@ -396,11 +386,7 @@ void iwl3945_tx_queue_free(struct iwl3945_priv *priv, struct iwl3945_tx_queue *t
 const u8 iwl3945_broadcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
 /*************** STATION TABLE MANAGEMENT ****
- *
- * NOTE:  This needs to be overhauled to better synchronize between
- * how the iwl-4965.c is using iwl3945_hw_find_station vs. iwl-3945.c
- *
- * mac80211 should also be examined to determine if sta_info is duplicating
+ * mac80211 should be examined to determine if sta_info is duplicating
  * the functionality provided here
  */
 
@@ -956,12 +942,12 @@ static int iwl3945_check_rxon_cmd(struct iwl3945_rxon_cmd *rxon)
 }
 
 /**
- * iwl3945_full_rxon_required - determine if RXON_ASSOC can be used in RXON commit
+ * iwl3945_full_rxon_required - check if full RXON (vs RXON_ASSOC) cmd is needed
  * @priv: staging_rxon is compared to active_rxon
  *
- * If the RXON structure is changing sufficient to require a new
- * tune or to clear and reset the RXON_FILTER_ASSOC_MSK then return 1
- * to indicate a new tune is required.
+ * If the RXON structure is changing enough to require a new tune,
+ * or is clearing the RXON_FILTER_ASSOC_MSK, then return 1 to indicate that
+ * a new tune (full RXON command, rather than RXON_ASSOC cmd) is required.
  */
 static int iwl3945_full_rxon_required(struct iwl3945_priv *priv)
 {
@@ -1235,7 +1221,7 @@ static int iwl3945_card_state_sync_callback(struct iwl3945_priv *priv,
 /*
  * CARD_STATE_CMD
  *
- * Use: Sets the internal card state to enable, disable, or halt
+ * Use: Sets the device's internal card state to enable, disable, or halt
  *
  * When in the 'enable' state the card operates as normal.
  * When in the 'disable' state, the card enters into a low power mode.
@@ -1589,14 +1575,9 @@ int iwl3945_eeprom_init(struct iwl3945_priv *priv)
 /**
  * iwl3945_report_frame - dump frame to syslog during debug sessions
  *
- * hack this function to show different aspects of received frames,
+ * You may hack this function to show different aspects of received frames,
  * including selective frame dumps.
  * group100 parameter selects whether to show 1 out of 100 good frames.
- *
- * TODO:  ieee80211_hdr stuff is common to 3945 and 4965, so frame type
- *        info output is okay, but some of this stuff (e.g. iwl3945_rx_frame_stats)
- *        is 3945-specific and gives bad output for 4965.  Need to split the
- *        functionality, keep common stuff here.
  */
 void iwl3945_report_frame(struct iwl3945_priv *priv,
 		      struct iwl3945_rx_packet *pkt,
@@ -3775,13 +3756,10 @@ static void iwl3945_setup_rx_handlers(struct iwl3945_priv *priv)
 	    iwl3945_rx_pm_debug_statistics_notif;
 	priv->rx_handlers[BEACON_NOTIFICATION] = iwl3945_rx_beacon_notif;
 
-	/* NOTE:  iwl3945_rx_statistics is different based on whether
-	 * the build is for the 3945 or the 4965.  See the
-	 * corresponding implementation in iwl-XXXX.c
-	 *
-	 * The same handler is used for both the REPLY to a
-	 * discrete statistics request from the host as well as
-	 * for the periodic statistics notification from the uCode
+	/*
+	 * The same handler is used for both the REPLY to a discrete
+	 * statistics request from the host as well as for the periodic
+	 * statistics notifications (after received beacons) from the uCode.
 	 */
 	priv->rx_handlers[REPLY_STATISTICS_CMD] = iwl3945_hw_rx_statistics;
 	priv->rx_handlers[STATISTICS_NOTIFICATION] = iwl3945_hw_rx_statistics;
@@ -3795,7 +3773,7 @@ static void iwl3945_setup_rx_handlers(struct iwl3945_priv *priv)
 	priv->rx_handlers[CARD_STATE_NOTIFICATION] = iwl3945_rx_card_state_notif;
 	priv->rx_handlers[REPLY_TX] = iwl3945_rx_reply_tx;
 
-	/* Setup hardware specific Rx handlers */
+	/* Set up hardware specific Rx handlers */
 	iwl3945_hw_rx_handler_setup(priv);
 }
 
@@ -3867,10 +3845,10 @@ static void iwl3945_tx_cmd_complete(struct iwl3945_priv *priv,
  * The queue is empty (no good data) if WRITE = READ - 1, and is full if
  * WRITE = READ.
  *
- * During initialization the host sets up the READ queue position to the first
+ * During initialization, the host sets up the READ queue position to the first
  * INDEX position, and WRITE to the last (READ - 1 wrapped)
  *
- * When the firmware places a packet in a buffer it will advance the READ index
+ * When the firmware places a packet in a buffer, it will advance the READ index
  * and fire the RX interrupt.  The driver can then query the READ index and
  * process as many packets as possible, moving the WRITE index forward as it
  * resets the Rx queue buffers with new memory.
@@ -3892,16 +3870,16 @@ static void iwl3945_tx_cmd_complete(struct iwl3945_priv *priv,
  *
  * Driver sequence:
  *
- * iwl3945_rx_queue_alloc()       Allocates rx_free
- * iwl3945_rx_replenish()         Replenishes rx_free list from rx_used, and calls
+ * iwl3945_rx_queue_alloc()   Allocates rx_free
+ * iwl3945_rx_replenish()     Replenishes rx_free list from rx_used, and calls
  *                            iwl3945_rx_queue_restock
- * iwl3945_rx_queue_restock()     Moves available buffers from rx_free into Rx
+ * iwl3945_rx_queue_restock() Moves available buffers from rx_free into Rx
  *                            queue, updates firmware pointers, and updates
  *                            the WRITE index.  If insufficient rx_free buffers
  *                            are available, schedules iwl3945_rx_replenish
  *
  * -- enable interrupts --
- * ISR - iwl3945_rx()             Detach iwl3945_rx_mem_buffers from pool up to the
+ * ISR - iwl3945_rx()         Detach iwl3945_rx_mem_buffers from pool up to the
  *                            READ INDEX, detaching the SKB from the pool.
  *                            Moves the packet buffer from queue to rx_used.
  *                            Calls iwl3945_rx_queue_restock to refill any empty
@@ -3927,12 +3905,6 @@ static int iwl3945_rx_queue_space(const struct iwl3945_rx_queue *q)
 
 /**
  * iwl3945_rx_queue_update_write_ptr - Update the write pointer for the RX queue
- *
- * NOTE: This function has 3945 and 4965 specific code sections
- * but is declared in base due to the majority of the
- * implementation being the same (only a numeric constant is
- * different)
- *
  */
 int iwl3945_rx_queue_update_write_ptr(struct iwl3945_priv *priv, struct iwl3945_rx_queue *q)
 {
@@ -3973,9 +3945,7 @@ int iwl3945_rx_queue_update_write_ptr(struct iwl3945_priv *priv, struct iwl3945_
 }
 
 /**
- * iwl3945_dma_addr2rbd_ptr - convert a DMA address to a uCode read buffer pointer.
- *
- * NOTE: This function has 3945 and 4965 specific code paths in it.
+ * iwl3945_dma_addr2rbd_ptr - convert a DMA address to a uCode read buffer ptr
  */
 static inline __le32 iwl3945_dma_addr2rbd_ptr(struct iwl3945_priv *priv,
 					  dma_addr_t dma_addr)
@@ -3986,9 +3956,9 @@ static inline __le32 iwl3945_dma_addr2rbd_ptr(struct iwl3945_priv *priv,
 /**
  * iwl3945_rx_queue_restock - refill RX queue from pre-allocated pool
  *
- * If there are slots in the RX queue that  need to be restocked,
+ * If there are slots in the RX queue that need to be restocked,
  * and we have free pre-allocated buffers, fill the ranks as much
- * as we can pulling from rx_free.
+ * as we can, pulling from rx_free.
  *
  * This moves the 'write' index forward to catch up with 'processed', and
  * also updates the memory address in the firmware to reference the new
@@ -4080,7 +4050,7 @@ void iwl3945_rx_replenish(void *data)
 }
 
 /* Assumes that the skb field of the buffers in 'pool' is kept accurate.
- * If an SKB has been detached, the POOL needs to have it's SKB set to NULL
+ * If an SKB has been detached, the POOL needs to have its SKB set to NULL
  * This free routine walks the list of POOL entries and if SKB is set to
  * non NULL it is unmapped and freed
  */
@@ -4232,7 +4202,7 @@ int iwl3945_calc_sig_qual(int rssi_dbm, int noise_dbm)
 }
 
 /**
- * iwl3945_rx_handle - Main entry function for receiving responses from the uCode
+ * iwl3945_rx_handle - Main entry function for receiving responses from uCode
  *
  * Uses the priv->rx_handlers callback function array to invoke
  * the appropriate handlers, including command responses,
@@ -4257,7 +4227,7 @@ static void iwl3945_rx_handle(struct iwl3945_priv *priv)
 	while (i != r) {
 		rxb = rxq->queue[i];
 
-		/* If an RXB doesn't have a queue slot associated with it
+		/* If an RXB doesn't have a Rx queue slot associated with it,
 		 * then a bug has been introduced in the queue refilling
 		 * routines -- catch it here */
 		BUG_ON(rxb == NULL);
@@ -4296,8 +4266,8 @@ static void iwl3945_rx_handle(struct iwl3945_priv *priv)
 		}
 
 		if (reclaim) {
-			/* Invoke any callbacks, transfer the skb to caller,
-			 * and fire off the (possibly) blocking iwl3945_send_cmd()
+			/* Invoke any callbacks, transfer the skb to caller, and
+			 * fire off the (possibly) blocking iwl3945_send_cmd()
 			 * as we reclaim the driver command queue */
 			if (rxb && rxb->skb)
 				iwl3945_tx_cmd_complete(priv, rxb);
@@ -4671,7 +4641,8 @@ static void iwl3945_irq_tasklet(struct iwl3945_priv *priv)
 
 #ifdef CONFIG_IWL3945_DEBUG
 	if (iwl3945_debug_level & IWL_DL_ISR) {
-		inta_mask = iwl3945_read32(priv, CSR_INT_MASK); /* just for debug */
+		/* just for debug */
+		inta_mask = iwl3945_read32(priv, CSR_INT_MASK);
 		IWL_DEBUG_ISR("inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
 			      inta, inta_mask, inta_fh);
 	}
@@ -4899,11 +4870,11 @@ static const u8 iwl3945_eeprom_band_1[14] = {
 };
 
 /* 5.2 GHz bands */
-static const u8 iwl3945_eeprom_band_2[] = {
+static const u8 iwl3945_eeprom_band_2[] = {	/* 4915-5080MHz */
 	183, 184, 185, 187, 188, 189, 192, 196, 7, 8, 11, 12, 16
 };
 
-static const u8 iwl3945_eeprom_band_3[] = {	/* 5205-5320MHz */
+static const u8 iwl3945_eeprom_band_3[] = {	/* 5170-5320MHz */
 	34, 36, 38, 40, 42, 44, 46, 48, 52, 56, 60, 64
 };
 
@@ -4927,7 +4898,7 @@ static void iwl3945_init_band_reference(const struct iwl3945_priv *priv, int ban
 		*eeprom_ch_info = priv->eeprom.band_1_channels;
 		*eeprom_ch_index = iwl3945_eeprom_band_1;
 		break;
-	case 2:		/* 5.2GHz band */
+	case 2:		/* 4.9GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(iwl3945_eeprom_band_2);
 		*eeprom_ch_info = priv->eeprom.band_2_channels;
 		*eeprom_ch_index = iwl3945_eeprom_band_2;
@@ -4937,12 +4908,12 @@ static void iwl3945_init_band_reference(const struct iwl3945_priv *priv, int ban
 		*eeprom_ch_info = priv->eeprom.band_3_channels;
 		*eeprom_ch_index = iwl3945_eeprom_band_3;
 		break;
-	case 4:		/* 5.2GHz band */
+	case 4:		/* 5.5GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(iwl3945_eeprom_band_4);
 		*eeprom_ch_info = priv->eeprom.band_4_channels;
 		*eeprom_ch_index = iwl3945_eeprom_band_4;
 		break;
-	case 5:		/* 5.2GHz band */
+	case 5:		/* 5.7GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(iwl3945_eeprom_band_5);
 		*eeprom_ch_info = priv->eeprom.band_5_channels;
 		*eeprom_ch_index = iwl3945_eeprom_band_5;
@@ -5205,7 +5176,7 @@ static int iwl3945_get_channels_for_scan(struct iwl3945_priv *priv, int phymode,
 		scan_ch->active_dwell = cpu_to_le16(active_dwell);
 		scan_ch->passive_dwell = cpu_to_le16(passive_dwell);
 
-		/* Set power levels to defaults */
+		/* Set txpower levels to defaults */
 		scan_ch->tpc.dsp_atten = 110;
 		/* scan_pwr_info->tpc.dsp_atten; */
 
@@ -5215,8 +5186,8 @@ static int iwl3945_get_channels_for_scan(struct iwl3945_priv *priv, int phymode,
 		else {
 			scan_ch->tpc.tx_gain = ((1 << 5) | (5 << 3));
 			/* NOTE: if we were doing 6Mb OFDM for scans we'd use
-			 * power level
-			 scan_ch->tpc.tx_gain = ((1<<5) | (2 << 3)) | 3;
+			 * power level:
+			 * scan_ch->tpc.tx_gain = ((1<<5) | (2 << 3)) | 3;
 			 */
 		}
 
@@ -5600,8 +5571,9 @@ static int iwl3945_verify_ucode(struct iwl3945_priv *priv)
 
 	IWL_ERROR("NO VALID UCODE IMAGE IN INSTRUCTION SRAM!!\n");
 
-	/* Show first several data entries in instruction SRAM.
-	 * Selection of bootstrap image is arbitrary. */
+	/* Since nothing seems to match, show first several data entries in
+	 * instruction SRAM, so maybe visual inspection will give a clue.
+	 * Selection of bootstrap image (vs. other images) is arbitrary. */
 	image = (__le32 *)priv->ucode_boot.v_addr;
 	len = priv->ucode_boot.len;
 	rc = iwl3945_verify_inst_full(priv, image, len);
@@ -5693,7 +5665,7 @@ static int iwl3945_load_bsm(struct iwl3945_priv *priv)
 		return -EINVAL;
 
 	/* Tell bootstrap uCode where to find the "Initialize" uCode
-	 *   in host DRAM ... bits 31:0 for 3945, bits 35:4 for 4965.
+	 *   in host DRAM ... host DRAM physical address bits 31:0 for 3945.
 	 * NOTE:  iwl3945_initialize_alive_start() will replace these values,
 	 *        after the "initialize" uCode has run, to point to
 	 *        runtime/protocol instructions and backup data cache. */
@@ -6018,12 +5990,8 @@ static int iwl3945_set_ucode_ptrs(struct iwl3945_priv *priv)
  *
  * Called after REPLY_ALIVE notification received from "initialize" uCode.
  *
- * The 4965 "initialize" ALIVE reply contains calibration data for:
- *   Voltage, temperature, and MIMO tx gain correction, now stored in priv
- *   (3945 does not contain this data).
- *
  * Tell "initialize" uCode to go ahead and load the runtime uCode.
-*/
+ */
 static void iwl3945_init_alive_start(struct iwl3945_priv *priv)
 {
 	/* Check alive response for "valid" sign from uCode */
@@ -6118,7 +6086,7 @@ static void iwl3945_alive_start(struct iwl3945_priv *priv)
 	} else
 		set_bit(STATUS_RF_KILL_HW, &priv->status);
 
-	/* After the ALIVE response, we can process host commands */
+	/* After the ALIVE response, we can send commands to 3945 uCode */
 	set_bit(STATUS_ALIVE, &priv->status);
 
 	/* Clear out the uCode error bit if it is set */
@@ -6174,7 +6142,7 @@ static void iwl3945_alive_start(struct iwl3945_priv *priv)
 		memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
 	}
 
-	/* Configure BT coexistence */
+	/* Configure Bluetooth device coexistence support */
 	iwl3945_send_bt_config(priv);
 
 	/* Configure the adapter for unassociated operation */
@@ -6357,7 +6325,7 @@ static int __iwl3945_up(struct iwl3945_priv *priv)
 		/* start card; "initialize" will load runtime ucode */
 		iwl3945_nic_start(priv);
 
-		/* MAC Address location in EEPROM same for 3945/4965 */
+		/* MAC Address location in EEPROM is same for 3945/4965 */
 		get_eeprom_mac(priv, priv->mac_addr);
 		IWL_DEBUG_INFO("MAC address: %s\n",
 			       print_mac(mac, priv->mac_addr));
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 0bd4f59..64282e5 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -27,16 +27,6 @@
  *
  *****************************************************************************/
 
-/*
- * NOTE:  This file (iwl-base.c) is used to build to multiple hardware targets
- * by defining IWL to either 3945 or 4965.  The Makefile used when building
- * the base targets will create base-3945.o and base-4965.o
- *
- * The eventual goal is to move as many of the #if IWL / #endif blocks out of
- * this file and into the hardware specific implementation files (iwl-XXXX.c)
- * and leave only the common (non #ifdef sprinkled) code in this file
- */
-
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/version.h>
@@ -75,9 +65,9 @@ static int iwl4965_tx_queue_update_write_ptr(struct iwl4965_priv *priv,
 /* module parameters */
 static int iwl4965_param_disable_hw_scan;
 static int iwl4965_param_debug;
-static int iwl4965_param_disable;      /* def: enable radio */
-static int iwl4965_param_antenna;      /* def: 0 = both antennas (use diversity) */
-int iwl4965_param_hwcrypto;     /* def: using software encryption */
+static int iwl4965_param_disable;  /* def: enable radio */
+static int iwl4965_param_antenna;  /* def: 0 = both antennas (use diversity) */
+int iwl4965_param_hwcrypto;        /* def: using software encryption */
 static int iwl4965_param_qos_enable = 1;
 int iwl4965_param_queues_num = IWL_MAX_NUM_QUEUES;
 int iwl4965_param_amsdu_size_8K; /* def: enable 8K amsdu size */
@@ -396,11 +386,7 @@ void iwl4965_tx_queue_free(struct iwl4965_priv *priv, struct iwl4965_tx_queue *t
 const u8 iwl4965_broadcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
 /*************** STATION TABLE MANAGEMENT ****
- *
- * NOTE:  This needs to be overhauled to better synchronize between
- * how the iwl-4965.c is using iwl4965_hw_find_station vs. iwl-3945.c
- *
- * mac80211 should also be examined to determine if sta_info is duplicating
+ * mac80211 should be examined to determine if sta_info is duplicating
  * the functionality provided here
  */
 
@@ -484,8 +470,8 @@ u8 iwl4965_add_station_flags(struct iwl4965_priv *priv, const u8 *addr,
 		}
 
 
-	/* These two conditions has the same outcome but keep them separate
-	  since they have different meaning */
+	/* These two conditions have the same outcome, but keep them separate
+	  since they have different meanings */
 	if (unlikely(index == IWL_INVALID_STATION)) {
 		spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
 		return index;
@@ -846,8 +832,8 @@ int iwl4965_send_statistics_request(struct iwl4965_priv *priv)
  * iwl4965_rxon_add_station - add station into station table.
  *
  * there is only one AP station with id= IWL_AP_ID
- * NOTE: mutex must be held before calling the this fnction
-*/
+ * NOTE: mutex must be held before calling this fnction
+ */
 static int iwl4965_rxon_add_station(struct iwl4965_priv *priv,
 				const u8 *addr, int is_ap)
 {
@@ -882,7 +868,8 @@ static int iwl4965_rxon_add_station(struct iwl4965_priv *priv,
  * NOTE:  Does not commit to the hardware; it sets appropriate bit fields
  * in the staging RXON flag structure based on the phymode
  */
-static int iwl4965_set_rxon_channel(struct iwl4965_priv *priv, u8 phymode, u16 channel)
+static int iwl4965_set_rxon_channel(struct iwl4965_priv *priv, u8 phymode,
+				 u16 channel)
 {
 	if (!iwl4965_get_channel_info(priv, phymode, channel)) {
 		IWL_DEBUG_INFO("Could not set channel to %d [%d]\n",
@@ -981,12 +968,12 @@ static int iwl4965_check_rxon_cmd(struct iwl4965_rxon_cmd *rxon)
 }
 
 /**
- * iwl4965_full_rxon_required - determine if RXON_ASSOC can be used in RXON commit
+ * iwl4965_full_rxon_required - check if full RXON (vs RXON_ASSOC) cmd is needed
  * @priv: staging_rxon is compared to active_rxon
  *
- * If the RXON structure is changing sufficient to require a new
- * tune or to clear and reset the RXON_FILTER_ASSOC_MSK then return 1
- * to indicate a new tune is required.
+ * If the RXON structure is changing enough to require a new tune,
+ * or is clearing the RXON_FILTER_ASSOC_MSK, then return 1 to indicate that
+ * a new tune (full RXON command, rather than RXON_ASSOC cmd) is required.
  */
 static int iwl4965_full_rxon_required(struct iwl4965_priv *priv)
 {
@@ -1283,7 +1270,7 @@ static int iwl4965_card_state_sync_callback(struct iwl4965_priv *priv,
 /*
  * CARD_STATE_CMD
  *
- * Use: Sets the internal card state to enable, disable, or halt
+ * Use: Sets the device's internal card state to enable, disable, or halt
  *
  * When in the 'enable' state the card operates as normal.
  * When in the 'disable' state, the card enters into a low power mode.
@@ -1659,14 +1646,12 @@ done:
 /**
  * iwl4965_report_frame - dump frame to syslog during debug sessions
  *
- * hack this function to show different aspects of received frames,
+ * You may hack this function to show different aspects of received frames,
  * including selective frame dumps.
  * group100 parameter selects whether to show 1 out of 100 good frames.
  *
- * TODO:  ieee80211_hdr stuff is common to 3945 and 4965, so frame type
- *        info output is okay, but some of this stuff (e.g. iwl4965_rx_frame_stats)
- *        is 3945-specific and gives bad output for 4965.  Need to split the
- *        functionality, keep common stuff here.
+ * TODO:  This was originally written for 3945, need to audit for
+ *        proper operation with 4965.
  */
 void iwl4965_report_frame(struct iwl4965_priv *priv,
 		      struct iwl4965_rx_packet *pkt,
@@ -2758,7 +2743,8 @@ static void iwl4965_build_tx_cmd_basic(struct iwl4965_priv *priv,
 	cmd->cmd.tx.next_frame_len = 0;
 }
 
-static int iwl4965_get_sta_id(struct iwl4965_priv *priv, struct ieee80211_hdr *hdr)
+static int iwl4965_get_sta_id(struct iwl4965_priv *priv,
+				struct ieee80211_hdr *hdr)
 {
 	int sta_id;
 	u16 fc = le16_to_cpu(hdr->frame_control);
@@ -4121,13 +4107,10 @@ static void iwl4965_setup_rx_handlers(struct iwl4965_priv *priv)
 	    iwl4965_rx_pm_debug_statistics_notif;
 	priv->rx_handlers[BEACON_NOTIFICATION] = iwl4965_rx_beacon_notif;
 
-	/* NOTE:  iwl4965_rx_statistics is different based on whether
-	 * the build is for the 3945 or the 4965.  See the
-	 * corresponding implementation in iwl-XXXX.c
-	 *
-	 * The same handler is used for both the REPLY to a
-	 * discrete statistics request from the host as well as
-	 * for the periodic statistics notification from the uCode
+	/*
+	 * The same handler is used for both the REPLY to a discrete
+	 * statistics request from the host as well as for the periodic
+	 * statistics notifications (after received beacons) from the uCode.
 	 */
 	priv->rx_handlers[REPLY_STATISTICS_CMD] = iwl4965_hw_rx_statistics;
 	priv->rx_handlers[STATISTICS_NOTIFICATION] = iwl4965_hw_rx_statistics;
@@ -4141,7 +4124,7 @@ static void iwl4965_setup_rx_handlers(struct iwl4965_priv *priv)
 	priv->rx_handlers[CARD_STATE_NOTIFICATION] = iwl4965_rx_card_state_notif;
 	priv->rx_handlers[REPLY_TX] = iwl4965_rx_reply_tx;
 
-	/* Setup hardware specific Rx handlers */
+	/* Set up hardware specific Rx handlers */
 	iwl4965_hw_rx_handler_setup(priv);
 }
 
@@ -4195,9 +4178,11 @@ static void iwl4965_tx_cmd_complete(struct iwl4965_priv *priv,
 /*
  * Rx theory of operation
  *
- * The host allocates 32 DMA target addresses and passes the host address
- * to the firmware at register IWL_RFDS_TABLE_LOWER + N * RFD_SIZE where N is
- * 0 to 31
+ * Driver allocates a circular buffer of Receive Buffer Descriptors (RBDs),
+ * each of which point to Receive Buffers to be filled by 4965.  These get
+ * used not only for Rx frames, but for any command response or notification
+ * from the 4965.  The driver and 4965 manage the Rx buffers by means
+ * of indexes into the circular buffer.
  *
  * Rx Queue Indexes
  * The host/firmware share two index registers for managing the Rx buffers.
@@ -4213,10 +4198,10 @@ static void iwl4965_tx_cmd_complete(struct iwl4965_priv *priv,
  * The queue is empty (no good data) if WRITE = READ - 1, and is full if
  * WRITE = READ.
  *
- * During initialization the host sets up the READ queue position to the first
+ * During initialization, the host sets up the READ queue position to the first
  * INDEX position, and WRITE to the last (READ - 1 wrapped)
  *
- * When the firmware places a packet in a buffer it will advance the READ index
+ * When the firmware places a packet in a buffer, it will advance the READ index
  * and fire the RX interrupt.  The driver can then query the READ index and
  * process as many packets as possible, moving the WRITE index forward as it
  * resets the Rx queue buffers with new memory.
@@ -4238,16 +4223,16 @@ static void iwl4965_tx_cmd_complete(struct iwl4965_priv *priv,
  *
  * Driver sequence:
  *
- * iwl4965_rx_queue_alloc()       Allocates rx_free
- * iwl4965_rx_replenish()         Replenishes rx_free list from rx_used, and calls
+ * iwl4965_rx_queue_alloc()   Allocates rx_free
+ * iwl4965_rx_replenish()     Replenishes rx_free list from rx_used, and calls
  *                            iwl4965_rx_queue_restock
- * iwl4965_rx_queue_restock()     Moves available buffers from rx_free into Rx
+ * iwl4965_rx_queue_restock() Moves available buffers from rx_free into Rx
  *                            queue, updates firmware pointers, and updates
  *                            the WRITE index.  If insufficient rx_free buffers
  *                            are available, schedules iwl4965_rx_replenish
  *
  * -- enable interrupts --
- * ISR - iwl4965_rx()             Detach iwl4965_rx_mem_buffers from pool up to the
+ * ISR - iwl4965_rx()         Detach iwl4965_rx_mem_buffers from pool up to the
  *                            READ INDEX, detaching the SKB from the pool.
  *                            Moves the packet buffer from queue to rx_used.
  *                            Calls iwl4965_rx_queue_restock to refill any empty
@@ -4273,12 +4258,6 @@ static int iwl4965_rx_queue_space(const struct iwl4965_rx_queue *q)
 
 /**
  * iwl4965_rx_queue_update_write_ptr - Update the write pointer for the RX queue
- *
- * NOTE: This function has 3945 and 4965 specific code sections
- * but is declared in base due to the majority of the
- * implementation being the same (only a numeric constant is
- * different)
- *
  */
 int iwl4965_rx_queue_update_write_ptr(struct iwl4965_priv *priv, struct iwl4965_rx_queue *q)
 {
@@ -4319,9 +4298,7 @@ int iwl4965_rx_queue_update_write_ptr(struct iwl4965_priv *priv, struct iwl4965_
 }
 
 /**
- * iwl4965_dma_addr2rbd_ptr - convert a DMA address to a uCode read buffer pointer.
- *
- * NOTE: This function has 3945 and 4965 specific code paths in it.
+ * iwl4965_dma_addr2rbd_ptr - convert a DMA address to a uCode read buffer ptr
  */
 static inline __le32 iwl4965_dma_addr2rbd_ptr(struct iwl4965_priv *priv,
 					  dma_addr_t dma_addr)
@@ -4333,9 +4310,9 @@ static inline __le32 iwl4965_dma_addr2rbd_ptr(struct iwl4965_priv *priv,
 /**
  * iwl4965_rx_queue_restock - refill RX queue from pre-allocated pool
  *
- * If there are slots in the RX queue that  need to be restocked,
+ * If there are slots in the RX queue that need to be restocked,
  * and we have free pre-allocated buffers, fill the ranks as much
- * as we can pulling from rx_free.
+ * as we can, pulling from rx_free.
  *
  * This moves the 'write' index forward to catch up with 'processed', and
  * also updates the memory address in the firmware to reference the new
@@ -4428,7 +4405,7 @@ void iwl4965_rx_replenish(void *data)
 }
 
 /* Assumes that the skb field of the buffers in 'pool' is kept accurate.
- * If an SKB has been detached, the POOL needs to have it's SKB set to NULL
+ * If an SKB has been detached, the POOL needs to have its SKB set to NULL
  * This free routine walks the list of POOL entries and if SKB is set to
  * non NULL it is unmapped and freed
  */
@@ -4582,7 +4559,7 @@ int iwl4965_calc_sig_qual(int rssi_dbm, int noise_dbm)
 }
 
 /**
- * iwl4965_rx_handle - Main entry function for receiving responses from the uCode
+ * iwl4965_rx_handle - Main entry function for receiving responses from uCode
  *
  * Uses the priv->rx_handlers callback function array to invoke
  * the appropriate handlers, including command responses,
@@ -4607,7 +4584,7 @@ static void iwl4965_rx_handle(struct iwl4965_priv *priv)
 	while (i != r) {
 		rxb = rxq->queue[i];
 
-		/* If an RXB doesn't have a queue slot associated with it
+		/* If an RXB doesn't have a Rx queue slot associated with it,
 		 * then a bug has been introduced in the queue refilling
 		 * routines -- catch it here */
 		BUG_ON(rxb == NULL);
@@ -4649,8 +4626,8 @@ static void iwl4965_rx_handle(struct iwl4965_priv *priv)
 		}
 
 		if (reclaim) {
-			/* Invoke any callbacks, transfer the skb to caller,
-			 * and fire off the (possibly) blocking iwl4965_send_cmd()
+			/* Invoke any callbacks, transfer the skb to caller, and
+			 * fire off the (possibly) blocking iwl4965_send_cmd()
 			 * as we reclaim the driver command queue */
 			if (rxb && rxb->skb)
 				iwl4965_tx_cmd_complete(priv, rxb);
@@ -5017,7 +4994,8 @@ static void iwl4965_irq_tasklet(struct iwl4965_priv *priv)
 
 #ifdef CONFIG_IWL4965_DEBUG
 	if (iwl4965_debug_level & IWL_DL_ISR) {
-		inta_mask = iwl4965_read32(priv, CSR_INT_MASK); /* just for debug */
+		/* just for debug */
+		inta_mask = iwl4965_read32(priv, CSR_INT_MASK);
 		IWL_DEBUG_ISR("inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
 			      inta, inta_mask, inta_fh);
 	}
@@ -5062,7 +5040,7 @@ static void iwl4965_irq_tasklet(struct iwl4965_priv *priv)
 	/* Safely ignore these bits for debug checks below */
 	inta &= ~(CSR_INT_BIT_MAC_CLK_ACTV | CSR_INT_BIT_ALIVE);
 
-	/* HW RF KILL switch toggled (4965 only) */
+	/* HW RF KILL switch toggled */
 	if (inta & CSR_INT_BIT_RF_KILL) {
 		int hw_rf_kill = 0;
 		if (!(iwl4965_read32(priv, CSR_GP_CNTRL) &
@@ -5083,7 +5061,7 @@ static void iwl4965_irq_tasklet(struct iwl4965_priv *priv)
 		handled |= CSR_INT_BIT_RF_KILL;
 	}
 
-	/* Chip got too hot and stopped itself (4965 only) */
+	/* Chip got too hot and stopped itself */
 	if (inta & CSR_INT_BIT_CT_KILL) {
 		IWL_ERROR("Microcode CT kill error detected.\n");
 		handled |= CSR_INT_BIT_CT_KILL;
@@ -5238,11 +5216,11 @@ static const u8 iwl4965_eeprom_band_1[14] = {
 };
 
 /* 5.2 GHz bands */
-static const u8 iwl4965_eeprom_band_2[] = {
+static const u8 iwl4965_eeprom_band_2[] = {	/* 4915-5080MHz */
 	183, 184, 185, 187, 188, 189, 192, 196, 7, 8, 11, 12, 16
 };
 
-static const u8 iwl4965_eeprom_band_3[] = {	/* 5205-5320MHz */
+static const u8 iwl4965_eeprom_band_3[] = {	/* 5170-5320MHz */
 	34, 36, 38, 40, 42, 44, 46, 48, 52, 56, 60, 64
 };
 
@@ -5262,7 +5240,8 @@ static u8 iwl4965_eeprom_band_7[] = {       /* 5.2 FAT channel */
 	36, 44, 52, 60, 100, 108, 116, 124, 132, 149, 157
 };
 
-static void iwl4965_init_band_reference(const struct iwl4965_priv *priv, int band,
+static void iwl4965_init_band_reference(const struct iwl4965_priv *priv,
+				    int band,
 				    int *eeprom_ch_count,
 				    const struct iwl4965_eeprom_channel
 				    **eeprom_ch_info,
@@ -5274,7 +5253,7 @@ static void iwl4965_init_band_reference(const struct iwl4965_priv *priv, int ban
 		*eeprom_ch_info = priv->eeprom.band_1_channels;
 		*eeprom_ch_index = iwl4965_eeprom_band_1;
 		break;
-	case 2:		/* 5.2GHz band */
+	case 2:		/* 4.9GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(iwl4965_eeprom_band_2);
 		*eeprom_ch_info = priv->eeprom.band_2_channels;
 		*eeprom_ch_index = iwl4965_eeprom_band_2;
@@ -5284,22 +5263,22 @@ static void iwl4965_init_band_reference(const struct iwl4965_priv *priv, int ban
 		*eeprom_ch_info = priv->eeprom.band_3_channels;
 		*eeprom_ch_index = iwl4965_eeprom_band_3;
 		break;
-	case 4:		/* 5.2GHz band */
+	case 4:		/* 5.5GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(iwl4965_eeprom_band_4);
 		*eeprom_ch_info = priv->eeprom.band_4_channels;
 		*eeprom_ch_index = iwl4965_eeprom_band_4;
 		break;
-	case 5:		/* 5.2GHz band */
+	case 5:		/* 5.7GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(iwl4965_eeprom_band_5);
 		*eeprom_ch_info = priv->eeprom.band_5_channels;
 		*eeprom_ch_index = iwl4965_eeprom_band_5;
 		break;
-	case 6:
+	case 6:		/* 2.4GHz FAT channels */
 		*eeprom_ch_count = ARRAY_SIZE(iwl4965_eeprom_band_6);
 		*eeprom_ch_info = priv->eeprom.band_24_channels;
 		*eeprom_ch_index = iwl4965_eeprom_band_6;
 		break;
-	case 7:
+	case 7:		/* 5 GHz FAT channels */
 		*eeprom_ch_count = ARRAY_SIZE(iwl4965_eeprom_band_7);
 		*eeprom_ch_info = priv->eeprom.band_52_channels;
 		*eeprom_ch_index = iwl4965_eeprom_band_7;
@@ -5568,7 +5547,8 @@ static int iwl4965_get_channels_for_scan(struct iwl4965_priv *priv, int phymode,
 
 		scan_ch->channel = channels[i].chan;
 
-		ch_info = iwl4965_get_channel_info(priv, phymode, scan_ch->channel);
+		ch_info = iwl4965_get_channel_info(priv, phymode,
+					 scan_ch->channel);
 		if (!is_channel_valid(ch_info)) {
 			IWL_DEBUG_SCAN("Channel %d is INVALID for this SKU.\n",
 				       scan_ch->channel);
@@ -5590,7 +5570,7 @@ static int iwl4965_get_channels_for_scan(struct iwl4965_priv *priv, int phymode,
 		scan_ch->active_dwell = cpu_to_le16(active_dwell);
 		scan_ch->passive_dwell = cpu_to_le16(passive_dwell);
 
-		/* Set power levels to defaults */
+		/* Set txpower levels to defaults */
 		scan_ch->tpc.dsp_atten = 110;
 		/* scan_pwr_info->tpc.dsp_atten; */
 
@@ -5600,8 +5580,8 @@ static int iwl4965_get_channels_for_scan(struct iwl4965_priv *priv, int phymode,
 		else {
 			scan_ch->tpc.tx_gain = ((1 << 5) | (5 << 3));
 			/* NOTE: if we were doing 6Mb OFDM for scans we'd use
-			 * power level
-			 scan_ch->tpc.tx_gain = ((1<<5) | (2 << 3)) | 3;
+			 * power level:
+			 * scan_ch->tpc.tx_gain = ((1<<5) | (2 << 3)) | 3;
 			 */
 		}
 
@@ -5868,7 +5848,8 @@ static void iwl4965_dealloc_ucode_pci(struct iwl4965_priv *priv)
  * iwl4965_verify_inst_full - verify runtime uCode image in card vs. host,
  *     looking at all data.
  */
-static int iwl4965_verify_inst_full(struct iwl4965_priv *priv, __le32 * image, u32 len)
+static int iwl4965_verify_inst_full(struct iwl4965_priv *priv, __le32 *image,
+				 u32 len)
 {
 	u32 val;
 	u32 save_len = len;
@@ -5993,8 +5974,9 @@ static int iwl4965_verify_ucode(struct iwl4965_priv *priv)
 
 	IWL_ERROR("NO VALID UCODE IMAGE IN INSTRUCTION SRAM!!\n");
 
-	/* Show first several data entries in instruction SRAM.
-	 * Selection of bootstrap image is arbitrary. */
+	/* Since nothing seems to match, show first several data entries in
+	 * instruction SRAM, so maybe visual inspection will give a clue.
+	 * Selection of bootstrap image (vs. other images) is arbitrary. */
 	image = (__le32 *)priv->ucode_boot.v_addr;
 	len = priv->ucode_boot.len;
 	rc = iwl4965_verify_inst_full(priv, image, len);
@@ -6086,7 +6068,7 @@ static int iwl4965_load_bsm(struct iwl4965_priv *priv)
 		return -EINVAL;
 
 	/* Tell bootstrap uCode where to find the "Initialize" uCode
-	 *   in host DRAM ... bits 31:0 for 3945, bits 35:4 for 4965.
+	 *   in host DRAM ... host DRAM physical address bits 35:4 for 4965.
 	 * NOTE:  iwl4965_initialize_alive_start() will replace these values,
 	 *        after the "initialize" uCode has run, to point to
 	 *        runtime/protocol instructions and backup data cache. */
@@ -6496,7 +6478,7 @@ static void iwl4965_alive_start(struct iwl4965_priv *priv)
 		goto restart;
 	}
 
-	/* After the ALIVE response, we can process host commands */
+	/* After the ALIVE response, we can send host commands to 4965 uCode */
 	set_bit(STATUS_ALIVE, &priv->status);
 
 	/* Clear out the uCode error bit if it is set */
@@ -6552,7 +6534,7 @@ static void iwl4965_alive_start(struct iwl4965_priv *priv)
 		memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
 	}
 
-	/* Configure BT coexistence */
+	/* Configure Bluetooth device coexistence support */
 	iwl4965_send_bt_config(priv);
 
 	/* Configure the adapter for unassociated operation */
@@ -6634,7 +6616,8 @@ static void __iwl4965_down(struct iwl4965_priv *priv)
 				STATUS_FW_ERROR;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	iwl4965_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+	iwl4965_clear_bit(priv, CSR_GP_CNTRL,
+			 CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	iwl4965_hw_txq_ctx_stop(priv);
@@ -6747,7 +6730,7 @@ static int __iwl4965_up(struct iwl4965_priv *priv)
 		/* start card; "initialize" will load runtime ucode */
 		iwl4965_nic_start(priv);
 
-		/* MAC Address location in EEPROM same for 3945/4965 */
+		/* MAC Address location in EEPROM is same for 3945/4965 */
 		get_eeprom_mac(priv, priv->mac_addr);
 		IWL_DEBUG_INFO("MAC address: %s\n",
 			       print_mac(mac, priv->mac_addr));
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
