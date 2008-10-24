Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:55132 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751375AbYJXGso (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 02:48:44 -0400
From: Reinette Chatre <reinette.chatre@linux.intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/10] iwlwifi: run through spell checker
Date: Thu, 23 Oct 2008 23:48:56 -0700
Message-Id: <1224830938-1577-9-git-send-email-reinette.chatre@linux.intel.com> (sfid-20081024_084857_426640_6A5C56D3)
In-Reply-To: <1224830938-1577-8-git-send-email-reinette.chatre@linux.intel.com>
References: <>
 <1224830938-1577-1-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-2-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-3-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-4-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-5-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-6-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-7-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-8-git-send-email-reinette.chatre@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

Simple run through spell checker

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-commands.h |    6 ++--
 drivers/net/wireless/iwlwifi/iwl-3945-io.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h       |   12 ++++----
 drivers/net/wireless/iwlwifi/iwl-4965.c          |   10 ++++----
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c          |   10 ++++----
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c        |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h      |   28 +++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-core.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h         |    7 ++---
 drivers/net/wireless/iwlwifi/iwl-dev.h           |    4 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-io.h            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-led.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.c         |   18 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-prph.h          |    6 ++--
 drivers/net/wireless/iwlwifi/iwl-rfkill.c        |    8 +++---
 drivers/net/wireless/iwlwifi/iwl-rx.c            |    8 +++---
 drivers/net/wireless/iwlwifi/iwl-scan.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c           |    6 ++--
 drivers/net/wireless/iwlwifi/iwl-tx.c            |    4 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c      |   28 +++++++++++-----------
 26 files changed, 91 insertions(+), 92 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
index 817ece7..8772d9d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
@@ -121,7 +121,7 @@ enum {
 	REPLY_TX_PWR_TABLE_CMD = 0x97,
 	MEASURE_ABORT_NOTIFICATION = 0x99,	/* not used */
 
-	/* Bluetooth device coexistance config command */
+	/* Bluetooth device coexistence config command */
 	REPLY_BT_CONFIG = 0x9b,
 
 	/* Statistics */
@@ -158,7 +158,7 @@ struct iwl3945_cmd_header {
 	u8 cmd;		/* Command ID:  REPLY_RXON, etc. */
 	u8 flags;	/* IWL_CMD_* */
 	/*
-	 * The driver sets up the sequence number to values of its chosing.
+	 * The driver sets up the sequence number to values of its choosing.
 	 * uCode does not use this value, but passes it back to the driver
 	 * when sending the response to each driver-originated command, so
 	 * the driver can match the response to the command.  Since the values
@@ -991,7 +991,7 @@ struct iwl3945_rate_scaling_cmd {
  *
  * 3945 and 4965 support hardware handshake with Bluetooth device on
  * same platform.  Bluetooth device alerts wireless device when it will Tx;
- * wireless device can delay or kill its own Tx to accomodate.
+ * wireless device can delay or kill its own Tx to accommodate.
  */
 struct iwl3945_bt_cmd {
 	u8 flags;
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-io.h b/drivers/net/wireless/iwlwifi/iwl-3945-io.h
index b3fe48d..1daa3f0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-io.h
@@ -53,7 +53,7 @@
  * _iwl3945_read32.)
  *
  * These declarations are *extremely* useful in quickly isolating code deltas
- * which result in misconfiguring of the hardware I/O.  In combination with
+ * which result in misconfiguration of the hardware I/O.  In combination with
  * git-bisect and the IO debug level you can quickly determine the specific
  * commit which breaks the IO sequence to the hardware.
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 6235bb9..fb5d295 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -200,7 +200,7 @@ static int iwl3945_hwrate_to_plcp_idx(u8 plcp)
  * priv->eeprom  is used to determine if antenna AUX/MAIN are reversed
  * priv->antenna specifies the antenna diversity mode:
  *
- * IWL_ANTENNA_DIVERISTY - NIC selects best antenna by itself
+ * IWL_ANTENNA_DIVERSITY - NIC selects best antenna by itself
  * IWL_ANTENNA_MAIN      - Force MAIN antenna
  * IWL_ANTENNA_AUX       - Force AUX antenna
  */
@@ -1883,7 +1883,7 @@ static int iwl3945_hw_reg_comp_txpower_temp(struct iwl3945_priv *priv)
 		ref_temp = (s16)priv->eeprom.groups[ch_info->group_index].
 		    temperature;
 
-		/* get power index adjustment based on curr and factory
+		/* get power index adjustment based on current and factory
 		 * temps */
 		delta_index = iwl3945_hw_reg_adjust_power_by_temp(temperature,
 							      ref_temp);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index f3f41a6..9da7c7b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -71,7 +71,7 @@
 
 #include "iwl-fh.h"
 
-/* EERPROM */
+/* EEPROM */
 #define IWL4965_EEPROM_IMG_SIZE			1024
 
 /*
@@ -286,13 +286,13 @@ static inline int iwl4965_hw_valid_rtc_data_addr(u32 addr)
  *     that target txpower.
  *
  *
- * 3)  Determine (EEPROM) calibration subband for the target channel, by
- *     comparing against first and last channels in each subband
+ * 3)  Determine (EEPROM) calibration sub band for the target channel, by
+ *     comparing against first and last channels in each sub band
  *     (see struct iwl4965_eeprom_calib_subband_info).
  *
  *
  * 4)  Linearly interpolate (EEPROM) factory calibration measurement sets,
- *     referencing the 2 factory-measured (sample) channels within the subband.
+ *     referencing the 2 factory-measured (sample) channels within the sub band.
  *
  *     Interpolation is based on difference between target channel's frequency
  *     and the sample channels' frequencies.  Since channel numbers are based
@@ -300,7 +300,7 @@ static inline int iwl4965_hw_valid_rtc_data_addr(u32 addr)
  *     to interpolating based on channel number differences.
  *
  *     Note that the sample channels may or may not be the channels at the
- *     edges of the subband.  The target channel may be "outside" of the
+ *     edges of the sub band.  The target channel may be "outside" of the
  *     span of the sampled channels.
  *
  *     Driver may choose the pair (for 2 Tx chains) of measurements (see
@@ -344,7 +344,7 @@ static inline int iwl4965_hw_valid_rtc_data_addr(u32 addr)
  *     "4965 temperature calculation".
  *
  *     If current temperature is higher than factory temperature, driver must
- *     increase gain (lower gain table index), and vice versa.
+ *     increase gain (lower gain table index), and vice verse.
  *
  *     Temperature affects gain differently for different channels:
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 1f22140..0953a9c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -246,7 +246,7 @@ static int iwl4965_set_ucode_ptrs(struct iwl_priv *priv)
 	iwl_write_prph(priv, BSM_DRAM_DATA_BYTECOUNT_REG,
 				 priv->ucode_data.len);
 
-	/* Inst bytecount must be last to set up, bit 31 signals uCode
+	/* Inst byte count must be last to set up, bit 31 signals uCode
 	 *   that all new ptr/size info is in place */
 	iwl_write_prph(priv, BSM_DRAM_INST_BYTECOUNT_REG,
 				 priv->ucode_code.len | BSM_DRAM_INST_LOAD);
@@ -324,7 +324,7 @@ static u16 iwl4965_eeprom_calib_version(struct iwl_priv *priv)
 }
 
 /*
- * Activate/Deactivat Tx DMA/FIFO channels according tx fifos mask
+ * Activate/Deactivate Tx DMA/FIFO channels according tx fifos mask
  * must be called under priv->lock and mac access
  */
 static void iwl4965_txq_set_sched(struct iwl_priv *priv, u32 mask)
@@ -396,7 +396,7 @@ static void iwl4965_nic_config(struct iwl_priv *priv)
 
 	/* L1 is enabled by BIOS */
 	if ((link & PCI_CFG_LINK_CTRL_VAL_L1_EN) == PCI_CFG_LINK_CTRL_VAL_L1_EN)
-		/* diable L0S disabled L1A enabled */
+		/* disable L0S disabled L1A enabled */
 		iwl_set_bit(priv, CSR_GIO_REG, CSR_GIO_REG_VAL_L0S_ENABLED);
 	else
 		/* L0S enabled L1A disabled */
@@ -625,7 +625,7 @@ static void iwl4965_bg_txpower_work(struct work_struct *work)
 
 	mutex_lock(&priv->mutex);
 
-	/* Regardless of if we are assocaited, we must reconfigure the
+	/* Regardless of if we are associated, we must reconfigure the
 	 * TX power since frames can be sent on non-radar channels while
 	 * not associated */
 	iwl4965_send_tx_power(priv);
@@ -2019,7 +2019,7 @@ static inline u32 iwl4965_get_scd_ssn(struct iwl4965_tx_resp *tx_resp)
 }
 
 /**
- * iwl4965_tx_status_reply_tx - Handle Tx rspnse for frames in aggregation queue
+ * iwl4965_tx_status_reply_tx - Handle Tx response for frames in aggregation queue
  */
 static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 				      struct iwl_ht_agg *agg,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
index 49ede54..12c7404 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
@@ -73,7 +73,7 @@
 #define IWL50_RTC_INST_SIZE (IWL50_RTC_INST_UPPER_BOUND - RTC_INST_LOWER_BOUND)
 #define IWL50_RTC_DATA_SIZE (IWL50_RTC_DATA_UPPER_BOUND - RTC_DATA_LOWER_BOUND)
 
-/* EERPROM */
+/* EEPROM */
 #define IWL_5000_EEPROM_IMG_SIZE			2048
 
 #define IWL50_CMD_FIFO_NUM                 7
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 16d1773..c46b206 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -94,7 +94,7 @@ static int iwl5000_apm_init(struct iwl_priv *priv)
 	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
 		    CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX);
 
-	/* Set FH wait treshold to maximum (HW error during stress W/A) */
+	/* Set FH wait threshold to maximum (HW error during stress W/A) */
 	iwl_set_bit(priv, CSR_DBG_HPET_MEM_REG, CSR_DBG_HPET_MEM_REG_VAL);
 
 	/* enable HAP INTA to move device L1a -> L0s */
@@ -134,7 +134,7 @@ static int iwl5000_apm_init(struct iwl_priv *priv)
 	return ret;
 }
 
-/* FIXME: this is indentical to 4965 */
+/* FIXME: this is identical to 4965 */
 static void iwl5000_apm_stop(struct iwl_priv *priv)
 {
 	unsigned long flags;
@@ -219,7 +219,7 @@ static void iwl5000_nic_config(struct iwl_priv *priv)
 
 	/* L1 is enabled by BIOS */
 	if ((link & PCI_CFG_LINK_CTRL_VAL_L1_EN) == PCI_CFG_LINK_CTRL_VAL_L1_EN)
-		/* diable L0S disabled L1A enabled */
+		/* disable L0S disabled L1A enabled */
 		iwl_set_bit(priv, CSR_GIO_REG, CSR_GIO_REG_VAL_L0S_ENABLED);
 	else
 		/* L0S enabled L1A disabled */
@@ -1093,7 +1093,7 @@ static u16 iwl5000_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
 
 
 /*
- * Activate/Deactivat Tx DMA/FIFO channels according tx fifos mask
+ * Activate/Deactivate Tx DMA/FIFO channels according tx fifos mask
  * must be called under priv->lock and mac access
  */
 static void iwl5000_txq_set_sched(struct iwl_priv *priv, u32 mask)
@@ -1311,7 +1311,7 @@ static void iwl5000_rx_reply_tx(struct iwl_priv *priv,
 		IWL_ERROR("TODO:  Implement Tx ABORT REQUIRED!!!\n");
 }
 
-/* Currently 5000 is the supperset of everything */
+/* Currently 5000 is the superset of everything */
 static u16 iwl5000_get_hcmd_size(u8 cmd_id, u16 len)
 {
 	return len;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index ecfd55f..4ba3163 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -188,7 +188,7 @@ static void rs_dbgfs_set_mcs(struct iwl_lq_sta *lq_sta,
  * 1, 2, 5.5, 11, 6, 9, 12, 18, 24, 36, 48, 54, 60 MBits
  * "G" is the only table that supports CCK (the first 4 rates).
  */
-/*FIXME:RS:need to spearate tables for MIMO2/MIMO3*/
+/*FIXME:RS:need to separate tables for MIMO2/MIMO3*/
 static s32 expected_tpt_A[IWL_RATE_COUNT] = {
 	0, 0, 0, 0, 40, 57, 72, 98, 121, 154, 177, 186, 186
 };
@@ -2259,7 +2259,7 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 		     lq_sta->active_mimo2_rate,
 		     lq_sta->active_mimo3_rate);
 
-	/* These values will be overriden later */
+	/* These values will be overridden later */
 	lq_sta->lq.general_params.single_stream_ant_msk = ANT_A;
 	lq_sta->lq.general_params.dual_stream_ant_msk = ANT_AB;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index bac91f1..ccfafcf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -229,7 +229,7 @@ enum {
 #define IWL_MIMO2_SWITCH_SISO_C         4
 #define IWL_MIMO2_SWITCH_GI             5
 
-/*FIXME:RS:add posible acctions for MIMO3*/
+/*FIXME:RS:add possible actions for MIMO3*/
 
 #define IWL_ACTION_LIMIT		3	/* # possible actions */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ef3aadd..9980c38 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1488,7 +1488,7 @@ static void iwl4965_enable_interrupts(struct iwl_priv *priv)
 /* call this function to flush any scheduled tasklet */
 static inline void iwl_synchronize_irq(struct iwl_priv *priv)
 {
-	/* wait to make sure we flush pedding tasklet*/
+	/* wait to make sure we flush pending tasklet*/
 	synchronize_irq(priv->pci_dev->irq);
 	tasklet_kill(&priv->irq_tasklet);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 56964ee..5ab74fc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -134,7 +134,7 @@ enum {
 	REPLY_TX_POWER_DBM_CMD = 0x98,
 	MEASURE_ABORT_NOTIFICATION = 0x99,	/* not used */
 
-	/* Bluetooth device coexistance config command */
+	/* Bluetooth device coexistence config command */
 	REPLY_BT_CONFIG = 0x9b,
 
 	/* Statistics */
@@ -185,7 +185,7 @@ struct iwl_cmd_header {
 	u8 cmd;		/* Command ID:  REPLY_RXON, etc. */
 	u8 flags;	/* 0:5 reserved, 6 abort, 7 internal */
 	/*
-	 * The driver sets up the sequence number to values of its chosing.
+	 * The driver sets up the sequence number to values of its choosing.
 	 * uCode does not use this value, but passes it back to the driver
 	 * when sending the response to each driver-originated command, so
 	 * the driver can match the response to the command.  Since the values
@@ -347,7 +347,7 @@ struct iwl4965_tx_power_db {
 } __attribute__ ((packed));
 
 /**
- * Commad REPLY_TX_POWER_DBM_CMD = 0x98
+ * Command REPLY_TX_POWER_DBM_CMD = 0x98
  * struct iwl5000_tx_power_dbm_cmd
  */
 #define IWL50_TX_POWER_AUTO 0x7f
@@ -383,7 +383,7 @@ struct iwl5000_tx_power_dbm_cmd {
  * calculating txpower settings:
  *
  * 1)  Power supply voltage indication.  The voltage sensor outputs higher
- *     values for lower voltage, and vice versa.
+ *     values for lower voltage, and vice verse.
  *
  * 2)  Temperature measurement parameters, for each of two channel widths
  *     (20 MHz and 40 MHz) supported by the radios.  Temperature sensing
@@ -622,7 +622,7 @@ struct iwl4965_rxon_cmd {
 	u8 ofdm_ht_dual_stream_basic_rates;
 } __attribute__ ((packed));
 
-/* 5000 HW just extend this cmmand */
+/* 5000 HW just extend this command */
 struct iwl_rxon_cmd {
 	u8 node_addr[6];
 	__le16 reserved1;
@@ -1113,7 +1113,7 @@ struct iwl4965_rx_non_cfg_phy {
 #define IWL50_OFDM_RSSI_C_BIT_POS 0
 
 struct iwl5000_non_cfg_phy {
-	__le32 non_cfg_phy[IWL50_RX_RES_PHY_CNT];  /* upto 8 phy entries */
+	__le32 non_cfg_phy[IWL50_RX_RES_PHY_CNT];  /* up to 8 phy entries */
 } __attribute__ ((packed));
 
 
@@ -1169,7 +1169,7 @@ struct iwl4965_rx_mpdu_res_start {
 
 /* REPLY_TX Tx flags field */
 
-/* 1: Use RTS/CTS protocol or CTS-to-self if spec alows it
+/* 1: Use RTS/CTS protocol or CTS-to-self if spec allows it
  * before this frame. if CTS-to-self required check
  * RXON_FLG_SELF_CTS_EN status. */
 #define TX_CMD_FLG_RTS_CTS_MSK __constant_cpu_to_le32(1 << 0)
@@ -1529,7 +1529,7 @@ struct iwl4965_tx_resp {
 
 /*
  * definitions for initial rate index field
- * bits [3:0] inital rate index
+ * bits [3:0] initial rate index
  * bits [6:4] rate table color, used for the initial rate
  * bit-7 invalid rate indication
  *   i.e. rate was not chosen from rate table
@@ -1768,7 +1768,7 @@ struct iwl_link_qual_agg_params {
  * match the modulation characteristics of the history set.
  *
  * When using block-ack (aggregation), all frames are transmitted at the same
- * rate, since there is no per-attempt acknowledgement from the destination
+ * rate, since there is no per-attempt acknowledgment from the destination
  * station.  The Tx response struct iwl_tx_resp indicates the Tx rate in
  * rate_n_flags field.  After receiving a block-ack, the driver can update
  * history for the entire block all at once.
@@ -1907,7 +1907,7 @@ struct iwl_link_quality_cmd {
  *
  * 3945 and 4965 support hardware handshake with Bluetooth device on
  * same platform.  Bluetooth device alerts wireless device when it will Tx;
- * wireless device can delay or kill its own Tx to accomodate.
+ * wireless device can delay or kill its own Tx to accommodate.
  */
 struct iwl4965_bt_cmd {
 	u8 flags;
@@ -2069,7 +2069,7 @@ struct iwl4965_spectrum_notification {
  *              '11' Illegal set
  *
  * NOTE: if sleep_interval[SLEEP_INTRVL_TABLE_SIZE-1] > DTIM period then
- * ucode assume sleep over DTIM is allowed and we don't need to wakeup
+ * ucode assume sleep over DTIM is allowed and we don't need to wake up
  * for every DTIM.
  */
 #define IWL_POWER_VEC_SIZE 5
@@ -3017,11 +3017,11 @@ struct iwl_wimax_coex_event_entry {
 
 /* COEX flag masks */
 
-/* Staion table is valid */
+/* Station table is valid */
 #define COEX_FLAGS_STA_TABLE_VALID_MSK      (0x1)
-/* UnMask wakeup src at unassociated sleep */
+/* UnMask wake up src at unassociated sleep */
 #define COEX_FLAGS_UNASSOC_WA_UNMASK_MSK    (0x4)
-/* UnMask wakeup src at associated sleep */
+/* UnMask wake up src at associated sleep */
 #define COEX_FLAGS_ASSOC_WA_UNMASK_MSK      (0x8)
 /* Enable CoEx feature. */
 #define COEX_FLAGS_COEX_ENABLE_MSK          (0x80)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index a3f97a0..a4e8048 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -747,7 +747,7 @@ static int iwl_get_idle_rx_chain_count(struct iwl_priv *priv, int active_cnt)
 		break;
 	case WLAN_HT_CAP_SM_PS_INVALID:
 	default:
-		IWL_ERROR("invalide mimo ps mode %d\n",
+		IWL_ERROR("invalid mimo ps mode %d\n",
 			   priv->current_ht_config.sm_ps);
 		WARN_ON(1);
 		idle_cnt = -1;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index fb95c6a..10f07f6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -100,7 +100,7 @@ struct iwl_hcmd_utils_ops {
 };
 
 struct iwl_lib_ops {
-	/* set hw dependant perameters */
+	/* set hw dependent parameters */
 	int (*set_hw_params)(struct iwl_priv *priv);
 	/* ucode shared memory */
 	int (*alloc_shared_mem)(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 2b48a4c..84b7772 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -101,13 +101,12 @@ static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
  *
  * To add your debug level to the list of levels seen when you perform
  *
- * % cat /proc/net/iwl/debug_level
+ * % cat /sys/class/net/wlanX/device/debug_level
  *
  * you simply need to add your entry to the iwl_debug_levels array.
  *
- * If you do not see debug_level in /proc/net/iwl then you do not have
- * CONFIG_IWLWIFI_DEBUG defined in your kernel configuration
- *
+ * If you do not see debug_level in  /sys/class/net/wlanX/device/debug_level
+ * then you do not have CONFIG_IWLWIFI_DEBUG defined in your kernel config file
  */
 
 #define IWL_DL_INFO		(1 << 0)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f546b7e..b58fcde 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -518,7 +518,7 @@ struct iwl_sensitivity_ranges {
  * @sw_crypto: 0 for hw, 1 for sw
  * @max_xxx_size: for ucode uses
  * @ct_kill_threshold: temperature threshold
- * @calib_init_cfg: setup initial claibrations for the hw
+ * @calib_init_cfg: setup initial calibrations for the hw
  * @struct iwl_sensitivity_ranges: range of sensitivity values
  */
 struct iwl_hw_params {
@@ -911,7 +911,7 @@ struct iwl_priv {
 
 	unsigned long status;
 
-	int last_rx_rssi;	/* From Rx packet statisitics */
+	int last_rx_rssi;	/* From Rx packet statistics */
 	int last_rx_noise;	/* From beacon statistics */
 
 	/* counts mgmt, ctl, and data packets */
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 5160b4b..792a3c1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -291,7 +291,7 @@ int iwl_eeprom_check_version(struct iwl_priv *priv)
 
 	return 0;
 err:
-	IWL_ERROR("Unsuported EEPROM VER=0x%x < 0x%x CALIB=0x%x < 0x%x\n",
+	IWL_ERROR("Unsupported EEPROM VER=0x%x < 0x%x CALIB=0x%x < 0x%x\n",
 		  eeprom_ver, priv->cfg->eeprom_ver,
 		  calib_ver,  priv->cfg->eeprom_calib_ver);
 	return -EINVAL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 9740fcc..40e0050 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -55,7 +55,7 @@
  * _iwl_read32.)
  *
  * These declarations are *extremely* useful in quickly isolating code deltas
- * which result in misconfiguring of the hardware I/O.  In combination with
+ * which result in misconfiguration of the hardware I/O.  In combination with
  * git-bisect and the IO debug level you can quickly determine the specific
  * commit which breaks the IO sequence to the hardware.
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 4eee1b1..ffb428a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -278,7 +278,7 @@ static int iwl_get_blink_rate(struct iwl_priv *priv)
 	/* FIXME: + priv->rx_stats[2].bytes; */
 	s64 tpt = current_tpt - priv->led_tpt;
 
-	if (tpt < 0) /* wrapparound */
+	if (tpt < 0) /* wraparound */
 		tpt = -tpt;
 
 	IWL_DEBUG_LED("tpt %lld current_tpt %llu\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 60a03d2..07a5f60 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -80,7 +80,7 @@
 #define IWL_REDUCED_POWER_TEMPERATURE	95
 
 /* default power management (not Tx power) table values */
-/* for tim  0-10 */
+/* for TIM  0-10 */
 static struct iwl_power_vec_entry range_0[IWL_POWER_MAX] = {
 	{{NOSLP, SLP_TOUT(0), SLP_TOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
 	{{SLP, SLP_TOUT(200), SLP_TOUT(500), SLP_VEC(1, 2, 2, 2, 0xFF)}, 0},
@@ -91,7 +91,7 @@ static struct iwl_power_vec_entry range_0[IWL_POWER_MAX] = {
 };
 
 
-/* for tim = 3-10 */
+/* for TIM = 3-10 */
 static struct iwl_power_vec_entry range_1[IWL_POWER_MAX] = {
 	{{NOSLP, SLP_TOUT(0), SLP_TOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
 	{{SLP, SLP_TOUT(200), SLP_TOUT(500), SLP_VEC(1, 2, 3, 4, 4)}, 0},
@@ -101,7 +101,7 @@ static struct iwl_power_vec_entry range_1[IWL_POWER_MAX] = {
 	{{SLP, SLP_TOUT(25), SLP_TOUT(25), SLP_VEC(2, 4, 7, 10, 10)}, 2}
 };
 
-/* for tim > 11 */
+/* for TIM > 11 */
 static struct iwl_power_vec_entry range_2[IWL_POWER_MAX] = {
 	{{NOSLP, SLP_TOUT(0), SLP_TOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
 	{{SLP, SLP_TOUT(200), SLP_TOUT(500), SLP_VEC(1, 2, 3, 4, 0xFF)}, 0},
@@ -183,7 +183,7 @@ static int iwl_power_init_handle(struct iwl_priv *priv)
 	return 0;
 }
 
-/* adjust power command according to dtim period and power level*/
+/* adjust power command according to DTIM period and power level*/
 static int iwl_update_power_command(struct iwl_priv *priv,
 				    struct iwl_powertable_cmd *cmd,
 				    u16 mode)
@@ -325,7 +325,7 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 EXPORT_SYMBOL(iwl_power_update_mode);
 
 /* Allow other iwl code to disable/enable power management active
- * this will be usefull for rate scale to disable PM during heavy
+ * this will be useful for rate scale to disable PM during heavy
  * Tx/Rx activities
  */
 int iwl_power_disable_management(struct iwl_priv *priv, u32 ms)
@@ -352,8 +352,8 @@ int iwl_power_disable_management(struct iwl_priv *priv, u32 ms)
 EXPORT_SYMBOL(iwl_power_disable_management);
 
 /* Allow other iwl code to disable/enable power management active
- * this will be usefull for rate scale to disable PM during hight
- * valume activities
+ * this will be useful for rate scale to disable PM during high
+ * volume activities
  */
 int iwl_power_enable_management(struct iwl_priv *priv)
 {
@@ -391,7 +391,7 @@ int iwl_power_set_system_mode(struct iwl_priv *priv, u16 mode)
 }
 EXPORT_SYMBOL(iwl_power_set_system_mode);
 
-/* initilize to default */
+/* initialize to default */
 void iwl_power_initialize(struct iwl_priv *priv)
 {
 
@@ -443,7 +443,7 @@ static void iwl_bg_set_power_save(struct work_struct *work)
 
 	mutex_lock(&priv->mutex);
 
-	/* on starting association we disable power managment
+	/* on starting association we disable power management
 	 * until association, if association failed then this
 	 * timer will expire and enable PM again.
 	 */
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index ee5afd4..b0ffb89 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -158,9 +158,9 @@
  *
  * 4)  Point (via BSM_DRAM_*) to the "runtime" uCode data and instruction
  *     images in host DRAM.  The last register loaded must be the instruction
- *     bytecount register ("1" in MSbit tells initialization uCode to load
+ *     byte count register ("1" in MSbit tells initialization uCode to load
  *     the runtime uCode):
- *     BSM_DRAM_INST_BYTECOUNT_REG = bytecount | BSM_DRAM_INST_LOAD
+ *     BSM_DRAM_INST_BYTECOUNT_REG = byte count | BSM_DRAM_INST_LOAD
  *
  * 5)  Wait for "alive" notification, then issue normal runtime commands.
  *
@@ -244,7 +244,7 @@
 /**
  * Tx Scheduler
  *
- * The Tx Scheduler selects the next frame to be transmitted, chosing TFDs
+ * The Tx Scheduler selects the next frame to be transmitted, choosing TFDs
  * (Transmit Frame Descriptors) from up to 16 circular Tx queues resident in
  * host DRAM.  It steers each frame's Tx command (which contains the frame
  * data) into one of up to 7 prioritized Tx DMA FIFO channels within the
diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
index 5d64229..618841a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
@@ -64,7 +64,7 @@ static int iwl_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
 		iwl_radio_kill_sw_disable_radio(priv);
 		break;
 	default:
-		IWL_WARNING("we recieved unexpected RFKILL state %d\n", state);
+		IWL_WARNING("we received unexpected RFKILL state %d\n", state);
 		break;
 	}
 out_unlock:
@@ -83,7 +83,7 @@ int iwl_rfkill_init(struct iwl_priv *priv)
 	IWL_DEBUG_RF_KILL("Initializing RFKILL.\n");
 	priv->rfkill = rfkill_allocate(device, RFKILL_TYPE_WLAN);
 	if (!priv->rfkill) {
-		IWL_ERROR("Unable to allocate rfkill device.\n");
+		IWL_ERROR("Unable to allocate RFKILL device.\n");
 		ret = -ENOMEM;
 		goto error;
 	}
@@ -99,7 +99,7 @@ int iwl_rfkill_init(struct iwl_priv *priv)
 
 	ret = rfkill_register(priv->rfkill);
 	if (ret) {
-		IWL_ERROR("Unable to register rfkill: %d\n", ret);
+		IWL_ERROR("Unable to register RFKILL: %d\n", ret);
 		goto free_rfkill;
 	}
 
@@ -127,7 +127,7 @@ void iwl_rfkill_unregister(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_rfkill_unregister);
 
-/* set rf-kill to the right state. */
+/* set RFKILL to the right state. */
 void iwl_rfkill_set_hw_state(struct iwl_priv *priv)
 {
 	if (!priv->rfkill)
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 7cde9d7..b86f958 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -407,7 +407,7 @@ int iwl_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 			   (priv->shared_phys + priv->rb_closed_offset) >> 4);
 
 	/* Enable Rx DMA
-	 * FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY is set becuase of HW bug in
+	 * FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY is set because of HW bug in
 	 *      the credit mechanism in 5000 HW RX FIFO
 	 * Direct rx interrupts to hosts
 	 * Rx buffer size 4 or 8k
@@ -1149,7 +1149,7 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 		priv->last_rx_noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
 
 	/* Set "1" to report good data frames in groups of 100 */
-	/* FIXME: need to optimze the call: */
+	/* FIXME: need to optimize the call: */
 	iwl_dbg_report_frame(priv, pkt, header, 1);
 
 	IWL_DEBUG_STATS_LIMIT("Rssi %d, noise %d, qual %d, TSF %llu\n",
@@ -1160,12 +1160,12 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 	 * "antenna number"
 	 *
 	 * It seems that the antenna field in the phy flags value
-	 * is actually a bitfield. This is undefined by radiotap,
+	 * is actually a bit field. This is undefined by radiotap,
 	 * it wants an actual antenna number but I always get "7"
 	 * for most legacy frames I receive indicating that the
 	 * same frame was received on all three RX chains.
 	 *
-	 * I think this field should be removed in favour of a
+	 * I think this field should be removed in favor of a
 	 * new 802.11n radiotap field "RX chains" that is defined
 	 * as a bitmask.
 	 */
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 8e262d9..4ecbe6c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -693,7 +693,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 		goto done;
 	}
 
-	/* Make sure the scan wasn't cancelled before this queued work
+	/* Make sure the scan wasn't canceled before this queued work
 	 * was given the chance to run... */
 	if (!test_bit(STATUS_SCANNING, &priv->status))
 		goto done;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 49299d3..88928ef 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -700,7 +700,7 @@ static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
 	/* else, we are overriding an existing key => no need to allocated room
 	 * in uCode. */
 
-	/* This copy is acutally not needed: we get the key with each TX */
+	/* This copy is actually not needed: we get the key with each TX */
 	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key, 16);
 
 	memcpy(priv->stations[sta_id].sta.key.key, keyconf->key, 16);
@@ -795,7 +795,7 @@ static void iwl_dump_lq_cmd(struct iwl_priv *priv,
 {
 	int i;
 	IWL_DEBUG_RATE("lq station id 0x%x\n", lq->sta_id);
-	IWL_DEBUG_RATE("lq dta 0x%X 0x%X\n",
+	IWL_DEBUG_RATE("lq ant 0x%X 0x%X\n",
 		       lq->general_params.single_stream_ant_msk,
 		       lq->general_params.dual_stream_ant_msk);
 
@@ -897,7 +897,7 @@ static void iwl_sta_init_lq(struct iwl_priv *priv, const u8 *addr, int is_ap)
  * iwl_rxon_add_station - add station into station table.
  *
  * there is only one AP station with id= IWL_AP_ID
- * NOTE: mutex must be held before calling this fnction
+ * NOTE: mutex must be held before calling this function
  */
 int iwl_rxon_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index ca08793..3649360 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -524,7 +524,7 @@ EXPORT_SYMBOL(iwl_hw_txq_ctx_free);
 
 /**
  * iwl_txq_ctx_reset - Reset TX queue context
- * Destroys all DMA structures and initialise them again
+ * Destroys all DMA structures and initialize them again
  *
  * @param priv
  * @return error code
@@ -764,7 +764,7 @@ static void iwl_tx_cmd_build_hwcrypto(struct iwl_priv *priv,
 		memcpy(tx_cmd->key, keyconf->key, keyconf->keylen);
 		if (info->flags & IEEE80211_TX_CTL_AMPDU)
 			tx_cmd->tx_flags |= TX_CMD_FLG_AGG_CCMP_MSK;
-		IWL_DEBUG_TX("tx_cmd with aes hwcrypto\n");
+		IWL_DEBUG_TX("tx_cmd with AES hwcrypto\n");
 		break;
 
 	case ALG_TKIP:
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 235fe3b..2870b61 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1846,7 +1846,7 @@ static void iwl3945_activate_qos(struct iwl3945_priv *priv, u8 force)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	if (force || iwl3945_is_associated(priv)) {
-		IWL_DEBUG_QOS("send QoS cmd with Qos active %d \n",
+		IWL_DEBUG_QOS("send QoS cmd with QoS active %d \n",
 			      priv->qos_data.qos_active);
 
 		iwl3945_send_qos_params_command(priv,
@@ -1870,7 +1870,7 @@ static void iwl3945_activate_qos(struct iwl3945_priv *priv, u8 force)
 
 
 /* default power management (not Tx power) table values */
-/* for tim  0-10 */
+/* for TIM  0-10 */
 static struct iwl3945_power_vec_entry range_0[IWL_POWER_AC] = {
 	{{NOSLP, SLP_TIMEOUT(0), SLP_TIMEOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
 	{{SLP, SLP_TIMEOUT(200), SLP_TIMEOUT(500), SLP_VEC(1, 2, 3, 4, 4)}, 0},
@@ -1880,7 +1880,7 @@ static struct iwl3945_power_vec_entry range_0[IWL_POWER_AC] = {
 	{{SLP, SLP_TIMEOUT(25), SLP_TIMEOUT(25), SLP_VEC(4, 7, 10, 10, 10)}, 1}
 };
 
-/* for tim > 10 */
+/* for TIM > 10 */
 static struct iwl3945_power_vec_entry range_1[IWL_POWER_AC] = {
 	{{NOSLP, SLP_TIMEOUT(0), SLP_TIMEOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
 	{{SLP, SLP_TIMEOUT(200), SLP_TIMEOUT(500),
@@ -2323,7 +2323,7 @@ static int iwl3945_set_mode(struct iwl3945_priv *priv, int mode)
 
 	iwl3945_clear_stations_table(priv);
 
-	/* dont commit rxon if rf-kill is on*/
+	/* don't commit rxon if rf-kill is on*/
 	if (!iwl3945_is_ready_rf(priv))
 		return -EAGAIN;
 
@@ -2352,7 +2352,7 @@ static void iwl3945_build_tx_cmd_hwcrypto(struct iwl3945_priv *priv,
 	case ALG_CCMP:
 		cmd->cmd.tx.sec_ctl = TX_CMD_SEC_CCM;
 		memcpy(cmd->cmd.tx.key, keyinfo->key, keyinfo->keylen);
-		IWL_DEBUG_TX("tx_cmd with aes hwcrypto\n");
+		IWL_DEBUG_TX("tx_cmd with AES hwcrypto\n");
 		break;
 
 	case ALG_TKIP:
@@ -4051,7 +4051,7 @@ static void iwl3945_enable_interrupts(struct iwl3945_priv *priv)
 /* call this function to flush any scheduled tasklet */
 static inline void iwl_synchronize_irq(struct iwl3945_priv *priv)
 {
-	/* wait to make sure we flush pedding tasklet*/
+	/* wait to make sure we flush pending tasklet*/
 	synchronize_irq(priv->pci_dev->irq);
 	tasklet_kill(&priv->irq_tasklet);
 }
@@ -5608,7 +5608,7 @@ static int iwl3945_set_ucode_ptrs(struct iwl3945_priv *priv)
 	iwl3945_write_prph(priv, BSM_DRAM_DATA_BYTECOUNT_REG,
 				 priv->ucode_data.len);
 
-	/* Inst bytecount must be last to set up, bit 31 signals uCode
+	/* Inst byte count must be last to set up, bit 31 signals uCode
 	 *   that all new ptr/size info is in place */
 	iwl3945_write_prph(priv, BSM_DRAM_INST_BYTECOUNT_REG,
 				 priv->ucode_code.len | BSM_DRAM_INST_LOAD);
@@ -5700,7 +5700,7 @@ static void iwl3945_alive_start(struct iwl3945_priv *priv)
 
 	rc = iwl3945_grab_nic_access(priv);
 	if (rc) {
-		IWL_WARNING("Can not read rfkill status from adapter\n");
+		IWL_WARNING("Can not read RFKILL status from adapter\n");
 		return;
 	}
 
@@ -5710,7 +5710,7 @@ static void iwl3945_alive_start(struct iwl3945_priv *priv)
 
 	if (rfkill & 0x1) {
 		clear_bit(STATUS_RF_KILL_HW, &priv->status);
-		/* if rfkill is not on, then wait for thermal
+		/* if RFKILL is not on, then wait for thermal
 		 * sensor in adapter to kick in */
 		while (iwl3945_hw_get_temperature(priv) == 0) {
 			thermal_spin++;
@@ -5904,7 +5904,7 @@ static int __iwl3945_up(struct iwl3945_priv *priv)
 	}
 
 	if (!priv->ucode_data_backup.v_addr || !priv->ucode_data.v_addr) {
-		IWL_ERROR("ucode not available for device bringup\n");
+		IWL_ERROR("ucode not available for device bring up\n");
 		return -EIO;
 	}
 
@@ -6113,7 +6113,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 		goto done;
 	}
 
-	/* Make sure the scan wasn't cancelled before this queued work
+	/* Make sure the scan wasn't canceled before this queued work
 	 * was given the chance to run... */
 	if (!test_bit(STATUS_SCANNING, &priv->status))
 		goto done;
@@ -7782,7 +7782,7 @@ static DEVICE_ATTR(dump_events, S_IWUSR, NULL, dump_event_log);
 
 /*****************************************************************************
  *
- * driver setup and teardown
+ * driver setup and tear down
  *
  *****************************************************************************/
 
@@ -8212,7 +8212,7 @@ static int iwl3945_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return 0;
 
-	IWL_DEBUG_RF_KILL("we recieved soft RFKILL set to state %d\n", state);
+	IWL_DEBUG_RF_KILL("we received soft RFKILL set to state %d\n", state);
 	mutex_lock(&priv->mutex);
 
 	switch (state) {
@@ -8227,7 +8227,7 @@ static int iwl3945_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
 		iwl3945_radio_kill_sw(priv, 1);
 		break;
 	default:
-		IWL_WARNING("we recieved unexpected RFKILL state %d\n", state);
+		IWL_WARNING("we received unexpected RFKILL state %d\n", state);
 		break;
 	}
 out_unlock:
-- 
1.5.4.3

