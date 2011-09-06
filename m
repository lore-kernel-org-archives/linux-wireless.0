Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26704 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644Ab1IFRPH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 13:15:07 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/10] iwlagn: clean up of transport layer
Date: Tue,  6 Sep 2011 09:31:19 -0700
Message-Id: <1315326685-22213-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110906_191518_577238_B7963054)
In-Reply-To: <1315326685-22213-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1315326685-22213-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Move a few declarations needed by the transport layer to iwl-shared.h
Move iwl_cmd_meta, iwl_tx_queue and friends to the internal transport
header file.
Move iwl_device_cmd iwl_host_cmd and friends to iwl-trans.h since
these structs are used in the API to the transport layer.
Move get_cmd_string to the upper layer with a declaration in
iwl-shared.h.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.h         |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn.h            |    2 -
 drivers/net/wireless/iwlwifi/iwl-core.c           |    4 +-
 drivers/net/wireless/iwlwifi/iwl-core.h           |   22 ---
 drivers/net/wireless/iwlwifi/iwl-dev.h            |  162 ---------------------
 drivers/net/wireless/iwlwifi/iwl-helpers.h        |   23 ---
 drivers/net/wireless/iwlwifi/iwl-rx.c             |   81 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-shared.h         |   43 ++++++
 drivers/net/wireless/iwlwifi/iwl-sv-open.c        |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |   92 ++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c  |    6 +-
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c  |   92 +-----------
 drivers/net/wireless/iwlwifi/iwl-trans.c          |   11 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   66 ++++++++-
 15 files changed, 299 insertions(+), 309 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 1af2767..ea4895a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -456,7 +456,7 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	else
 		ctx->staging.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 
-	iwl_print_rx_config_cmd(priv, ctx);
+	iwl_print_rx_config_cmd(priv, ctx->ctxid);
 	ret = iwl_check_rxon_cmd(priv, ctx);
 	if (ret) {
 		IWL_ERR(priv, "Invalid RXON configuration. Not committing.\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.h b/drivers/net/wireless/iwlwifi/iwl-agn-tt.h
index d118ed2..7282a23 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.h
@@ -117,7 +117,6 @@ struct iwl_tt_mgmt {
 u8 iwl_tt_current_power_mode(struct iwl_priv *priv);
 bool iwl_tt_is_low_power_state(struct iwl_priv *priv);
 bool iwl_ht_enabled(struct iwl_priv *priv);
-bool iwl_check_for_ct_kill(struct iwl_priv *priv);
 enum iwl_antenna_ok iwl_tx_ant_restriction(struct iwl_priv *priv);
 enum iwl_antenna_ok iwl_rx_ant_restriction(struct iwl_priv *priv);
 void iwl_tt_enter_ct_kill(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index a7b4948..4bc1f46 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -98,7 +98,6 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 				 enum iwlagn_ucode_type ucode_type);
 
 /* lib */
-int iwlagn_hw_valid_rtc_data_addr(u32 addr);
 int iwlagn_send_tx_power(struct iwl_priv *priv);
 void iwlagn_temperature(struct iwl_priv *priv);
 u16 iwlagn_eeprom_calib_version(struct iwl_priv *priv);
@@ -109,7 +108,6 @@ int iwlagn_send_beacon_cmd(struct iwl_priv *priv);
 /* rx */
 int iwlagn_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band);
 void iwl_setup_rx_handlers(struct iwl_priv *priv);
-void iwl_rx_dispatch(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
 
 
 /* tx */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 416695a..0f16edc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -817,9 +817,9 @@ void iwl_chswitch_done(struct iwl_priv *priv, bool is_success)
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-void iwl_print_rx_config_cmd(struct iwl_priv *priv,
-			     struct iwl_rxon_context *ctx)
+void iwl_print_rx_config_cmd(struct iwl_priv *priv, u8 ctxid)
 {
+	struct iwl_rxon_context *ctx = &priv->contexts[ctxid];
 	struct iwl_rxon_cmd *rxon = &ctx->staging;
 
 	IWL_DEBUG_RADIO(priv, "RX CONFIG:\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 2ea8a2e..56b554c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -73,8 +73,6 @@ struct iwl_cmd;
 
 #define TIME_UNIT		1024
 
-#define IWL_CMD(x) case x: return #x
-
 struct iwl_lib_ops {
 	/* set hw dependent parameters */
 	int (*set_hw_params)(struct iwl_priv *priv);
@@ -271,7 +269,6 @@ int iwl_mac_change_interface(struct ieee80211_hw *hw,
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 int iwl_alloc_traffic_mem(struct iwl_priv *priv);
 void iwl_free_traffic_mem(struct iwl_priv *priv);
-void iwl_reset_traffic_log(struct iwl_priv *priv);
 void iwl_dbg_log_tx_data_frame(struct iwl_priv *priv,
 				u16 length, struct ieee80211_hdr *header);
 void iwl_dbg_log_rx_data_frame(struct iwl_priv *priv,
@@ -360,7 +357,6 @@ int __must_check iwl_scan_initiate(struct iwl_priv *priv,
  *   S e n d i n g     H o s t     C o m m a n d s   *
  *****************************************************/
 
-const char *get_cmd_string(u8 cmd);
 void iwl_bg_watchdog(unsigned long data);
 u32 iwl_usecs_to_beacons(struct iwl_priv *priv, u32 usec, u32 beacon_interval);
 __le32 iwl_add_beacon_time(struct iwl_priv *priv, u32 base,
@@ -368,19 +364,6 @@ __le32 iwl_add_beacon_time(struct iwl_priv *priv, u32 base,
 
 
 /*****************************************************
-*  Error Handling Debugging
-******************************************************/
-#ifdef CONFIG_IWLWIFI_DEBUG
-void iwl_print_rx_config_cmd(struct iwl_priv *priv,
-			     struct iwl_rxon_context *ctx);
-#else
-static inline void iwl_print_rx_config_cmd(struct iwl_priv *priv,
-					   struct iwl_rxon_context *ctx)
-{
-}
-#endif
-
-/*****************************************************
 *  GEOS
 ******************************************************/
 int iwl_init_geos(struct iwl_priv *priv);
@@ -389,8 +372,6 @@ void iwl_free_geos(struct iwl_priv *priv);
 extern void iwl_send_bt_config(struct iwl_priv *priv);
 extern int iwl_send_statistics_request(struct iwl_priv *priv,
 				       u8 flags, bool clear);
-void iwl_apm_stop(struct iwl_priv *priv);
-int iwl_apm_init(struct iwl_priv *priv);
 
 int iwl_send_rxon_timing(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
 
@@ -408,7 +389,4 @@ static inline bool iwl_advanced_bt_coexist(struct iwl_priv *priv)
 
 extern bool bt_siso_mode;
 
-
-void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand);
-
 #endif /* __iwl_core_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 8ae79e9..bbda672 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -32,7 +32,6 @@
 #define __iwl_dev_h__
 
 #include <linux/interrupt.h>
-#include <linux/pci.h> /* for struct pci_device_id */
 #include <linux/kernel.h>
 #include <linux/wait.h>
 #include <linux/leds.h>
@@ -89,100 +88,6 @@ struct iwl_tx_queue;
 #define	DEFAULT_SHORT_RETRY_LIMIT 7U
 #define	DEFAULT_LONG_RETRY_LIMIT  4U
 
-/* defined below */
-struct iwl_device_cmd;
-
-struct iwl_cmd_meta {
-	/* only for SYNC commands, iff the reply skb is wanted */
-	struct iwl_host_cmd *source;
-	/*
-	 * only for ASYNC commands
-	 * (which is somewhat stupid -- look at iwl-sta.c for instance
-	 * which duplicates a bunch of code because the callback isn't
-	 * invoked for SYNC commands, if it were and its result passed
-	 * through it would be simpler...)
-	 */
-	void (*callback)(struct iwl_shared *shrd,
-			 struct iwl_device_cmd *cmd,
-			 struct iwl_rx_packet *pkt);
-
-	u32 flags;
-
-	DEFINE_DMA_UNMAP_ADDR(mapping);
-	DEFINE_DMA_UNMAP_LEN(len);
-};
-
-/*
- * Generic queue structure
- *
- * Contains common data for Rx and Tx queues.
- *
- * Note the difference between n_bd and n_window: the hardware
- * always assumes 256 descriptors, so n_bd is always 256 (unless
- * there might be HW changes in the future). For the normal TX
- * queues, n_window, which is the size of the software queue data
- * is also 256; however, for the command queue, n_window is only
- * 32 since we don't need so many commands pending. Since the HW
- * still uses 256 BDs for DMA though, n_bd stays 256. As a result,
- * the software buffers (in the variables @meta, @txb in struct
- * iwl_tx_queue) only have 32 entries, while the HW buffers (@tfds
- * in the same struct) have 256.
- * This means that we end up with the following:
- *  HW entries: | 0 | ... | N * 32 | ... | N * 32 + 31 | ... | 255 |
- *  SW entries:           | 0      | ... | 31          |
- * where N is a number between 0 and 7. This means that the SW
- * data is a window overlayed over the HW queue.
- */
-struct iwl_queue {
-	int n_bd;              /* number of BDs in this queue */
-	int write_ptr;       /* 1-st empty entry (index) host_w*/
-	int read_ptr;         /* last used entry (index) host_r*/
-	/* use for monitoring and recovering the stuck queue */
-	dma_addr_t dma_addr;   /* physical addr for BD's */
-	int n_window;	       /* safe queue window */
-	u32 id;
-	int low_mark;	       /* low watermark, resume queue if free
-				* space more than this */
-	int high_mark;         /* high watermark, stop queue if free
-				* space less than this */
-};
-
-/**
- * struct iwl_tx_queue - Tx Queue for DMA
- * @q: generic Rx/Tx queue descriptor
- * @bd: base of circular buffer of TFDs
- * @cmd: array of command/TX buffer pointers
- * @meta: array of meta data for each command/tx buffer
- * @dma_addr_cmd: physical address of cmd/tx buffer array
- * @txb: array of per-TFD driver data
- * @time_stamp: time (in jiffies) of last read_ptr change
- * @need_update: indicates need to update read/write index
- * @sched_retry: indicates queue is high-throughput aggregation (HT AGG) enabled
- * @sta_id: valid if sched_retry is set
- * @tid: valid if sched_retry is set
- *
- * A Tx queue consists of circular buffer of BDs (a.k.a. TFDs, transmit frame
- * descriptors) and required locking structures.
- */
-#define TFD_TX_CMD_SLOTS 256
-#define TFD_CMD_SLOTS 32
-
-struct iwl_tx_queue {
-	struct iwl_queue q;
-	struct iwl_tfd *tfds;
-	struct iwl_device_cmd **cmd;
-	struct iwl_cmd_meta *meta;
-	struct sk_buff **skbs;
-	unsigned long time_stamp;
-	u8 need_update;
-	u8 sched_retry;
-	u8 active;
-	u8 swq_id;
-
-	u16 sta_id;
-	u16 tid;
-};
-
 #define IWL_NUM_SCAN_RATES         (2)
 
 /*
@@ -249,70 +154,6 @@ struct iwl_channel_info {
 #define IEEE80211_HLEN                  (IEEE80211_4ADDR_LEN)
 #define IEEE80211_FRAME_LEN             (IEEE80211_DATA_LEN + IEEE80211_HLEN)
 
-
-#define SEQ_TO_SN(seq) (((seq) & IEEE80211_SCTL_SEQ) >> 4)
-#define SN_TO_SEQ(ssn) (((ssn) << 4) & IEEE80211_SCTL_SEQ)
-#define MAX_SN ((IEEE80211_SCTL_SEQ) >> 4)
-
-enum {
-	CMD_SYNC = 0,
-	CMD_ASYNC = BIT(0),
-	CMD_WANT_SKB = BIT(1),
-	CMD_ON_DEMAND = BIT(2),
-};
-
-#define DEF_CMD_PAYLOAD_SIZE 320
-
-/**
- * struct iwl_device_cmd
- *
- * For allocation of the command and tx queues, this establishes the overall
- * size of the largest command we send to uCode, except for commands that
- * aren't fully copied and use other TFD space.
- */
-struct iwl_device_cmd {
-	struct iwl_cmd_header hdr;	/* uCode API */
-	union {
-		u32 flags;
-		u8 val8;
-		u16 val16;
-		u32 val32;
-		struct iwl_tx_cmd tx;
-		struct iwl6000_channel_switch_cmd chswitch;
-		u8 payload[DEF_CMD_PAYLOAD_SIZE];
-	} __packed cmd;
-} __packed;
-
-#define TFD_MAX_PAYLOAD_SIZE (sizeof(struct iwl_device_cmd))
-
-#define IWL_MAX_CMD_TFDS	2
-
-enum iwl_hcmd_dataflag {
-	IWL_HCMD_DFL_NOCOPY	= BIT(0),
-};
-
-/**
- * struct iwl_host_cmd - Host command to the uCode
- * @data: array of chunks that composes the data of the host command
- * @reply_page: pointer to the page that holds the response to the host command
- * @callback:
- * @flags: can be CMD_* note CMD_WANT_SKB is incompatible withe CMD_ASYNC
- * @len: array of the lenths of the chunks in data
- * @dataflags:
- * @id: id of the host command
- */
-struct iwl_host_cmd {
-	const void *data[IWL_MAX_CMD_TFDS];
-	unsigned long reply_page;
-	void (*callback)(struct iwl_shared *shrd,
-			 struct iwl_device_cmd *cmd,
-			 struct iwl_rx_packet *pkt);
-	u32 flags;
-	u16 len[IWL_MAX_CMD_TFDS];
-	u8 dataflags[IWL_MAX_CMD_TFDS];
-	u8 id;
-};
-
 #define SUP_RATE_11A_MAX_NUM_CHANNELS  8
 #define SUP_RATE_11B_MAX_NUM_CHANNELS  4
 #define SUP_RATE_11G_MAX_NUM_CHANNELS  12
@@ -580,9 +421,6 @@ extern const u8 iwl_bcast_addr[ETH_ALEN];
 #define IWL_OPERATION_MODE_MIXED    2
 #define IWL_OPERATION_MODE_20MHZ    3
 
-#define IWL_TX_CRC_SIZE 4
-#define IWL_TX_DELIMITER_SIZE 4
-
 #define TX_POWER_IWL_ILLEGAL_VOLTAGE -10000
 
 /* Sensitivity and chain noise calibration */
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index d3feac9..968fc66 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -35,35 +35,12 @@
 
 #include "iwl-io.h"
 
-#define IWL_MASK(lo, hi) ((1 << (hi)) | ((1 << (hi)) - (1 << (lo))))
-
-
 static inline struct ieee80211_conf *ieee80211_get_hw_conf(
 	struct ieee80211_hw *hw)
 {
 	return &hw->conf;
 }
 
-/**
- * iwl_queue_inc_wrap - increment queue index, wrap back to beginning
- * @index -- current index
- * @n_bd -- total number of entries in queue (must be power of 2)
- */
-static inline int iwl_queue_inc_wrap(int index, int n_bd)
-{
-	return ++index & (n_bd - 1);
-}
-
-/**
- * iwl_queue_dec_wrap - decrement queue index, wrap back to end
- * @index -- current index
- * @n_bd -- total number of entries in queue (must be power of 2)
- */
-static inline int iwl_queue_dec_wrap(int index, int n_bd)
-{
-	return --index & (n_bd - 1);
-}
-
 static inline void iwl_enable_rfkill_int(struct iwl_priv *priv)
 {
 	IWL_DEBUG_ISR(priv, "Enabling rfkill interrupt\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index ee8fabd..c7e6a74 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -42,6 +42,87 @@
 #include "iwl-agn.h"
 #include "iwl-shared.h"
 
+const char *get_cmd_string(u8 cmd)
+{
+	switch (cmd) {
+		IWL_CMD(REPLY_ALIVE);
+		IWL_CMD(REPLY_ERROR);
+		IWL_CMD(REPLY_RXON);
+		IWL_CMD(REPLY_RXON_ASSOC);
+		IWL_CMD(REPLY_QOS_PARAM);
+		IWL_CMD(REPLY_RXON_TIMING);
+		IWL_CMD(REPLY_ADD_STA);
+		IWL_CMD(REPLY_REMOVE_STA);
+		IWL_CMD(REPLY_REMOVE_ALL_STA);
+		IWL_CMD(REPLY_TXFIFO_FLUSH);
+		IWL_CMD(REPLY_WEPKEY);
+		IWL_CMD(REPLY_TX);
+		IWL_CMD(REPLY_LEDS_CMD);
+		IWL_CMD(REPLY_TX_LINK_QUALITY_CMD);
+		IWL_CMD(COEX_PRIORITY_TABLE_CMD);
+		IWL_CMD(COEX_MEDIUM_NOTIFICATION);
+		IWL_CMD(COEX_EVENT_CMD);
+		IWL_CMD(REPLY_QUIET_CMD);
+		IWL_CMD(REPLY_CHANNEL_SWITCH);
+		IWL_CMD(CHANNEL_SWITCH_NOTIFICATION);
+		IWL_CMD(REPLY_SPECTRUM_MEASUREMENT_CMD);
+		IWL_CMD(SPECTRUM_MEASURE_NOTIFICATION);
+		IWL_CMD(POWER_TABLE_CMD);
+		IWL_CMD(PM_SLEEP_NOTIFICATION);
+		IWL_CMD(PM_DEBUG_STATISTIC_NOTIFIC);
+		IWL_CMD(REPLY_SCAN_CMD);
+		IWL_CMD(REPLY_SCAN_ABORT_CMD);
+		IWL_CMD(SCAN_START_NOTIFICATION);
+		IWL_CMD(SCAN_RESULTS_NOTIFICATION);
+		IWL_CMD(SCAN_COMPLETE_NOTIFICATION);
+		IWL_CMD(BEACON_NOTIFICATION);
+		IWL_CMD(REPLY_TX_BEACON);
+		IWL_CMD(WHO_IS_AWAKE_NOTIFICATION);
+		IWL_CMD(QUIET_NOTIFICATION);
+		IWL_CMD(REPLY_TX_PWR_TABLE_CMD);
+		IWL_CMD(MEASURE_ABORT_NOTIFICATION);
+		IWL_CMD(REPLY_BT_CONFIG);
+		IWL_CMD(REPLY_STATISTICS_CMD);
+		IWL_CMD(STATISTICS_NOTIFICATION);
+		IWL_CMD(REPLY_CARD_STATE_CMD);
+		IWL_CMD(CARD_STATE_NOTIFICATION);
+		IWL_CMD(MISSED_BEACONS_NOTIFICATION);
+		IWL_CMD(REPLY_CT_KILL_CONFIG_CMD);
+		IWL_CMD(SENSITIVITY_CMD);
+		IWL_CMD(REPLY_PHY_CALIBRATION_CMD);
+		IWL_CMD(REPLY_RX_PHY_CMD);
+		IWL_CMD(REPLY_RX_MPDU_CMD);
+		IWL_CMD(REPLY_RX);
+		IWL_CMD(REPLY_COMPRESSED_BA);
+		IWL_CMD(CALIBRATION_CFG_CMD);
+		IWL_CMD(CALIBRATION_RES_NOTIFICATION);
+		IWL_CMD(CALIBRATION_COMPLETE_NOTIFICATION);
+		IWL_CMD(REPLY_TX_POWER_DBM_CMD);
+		IWL_CMD(TEMPERATURE_NOTIFICATION);
+		IWL_CMD(TX_ANT_CONFIGURATION_CMD);
+		IWL_CMD(REPLY_BT_COEX_PROFILE_NOTIF);
+		IWL_CMD(REPLY_BT_COEX_PRIO_TABLE);
+		IWL_CMD(REPLY_BT_COEX_PROT_ENV);
+		IWL_CMD(REPLY_WIPAN_PARAMS);
+		IWL_CMD(REPLY_WIPAN_RXON);
+		IWL_CMD(REPLY_WIPAN_RXON_TIMING);
+		IWL_CMD(REPLY_WIPAN_RXON_ASSOC);
+		IWL_CMD(REPLY_WIPAN_QOS_PARAM);
+		IWL_CMD(REPLY_WIPAN_WEPKEY);
+		IWL_CMD(REPLY_WIPAN_P2P_CHANNEL_SWITCH);
+		IWL_CMD(REPLY_WIPAN_NOA_NOTIFICATION);
+		IWL_CMD(REPLY_WIPAN_DEACTIVATION_COMPLETE);
+		IWL_CMD(REPLY_WOWLAN_PATTERNS);
+		IWL_CMD(REPLY_WOWLAN_WAKEUP_FILTER);
+		IWL_CMD(REPLY_WOWLAN_TSC_RSC_PARAMS);
+		IWL_CMD(REPLY_WOWLAN_TKIP_PARAMS);
+		IWL_CMD(REPLY_WOWLAN_KEK_KCK_MATERIAL);
+		IWL_CMD(REPLY_WOWLAN_GET_STATUS);
+	default:
+		return "UNKNOWN";
+
+	}
+}
 
 /******************************************************************************
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 9790d7e..73ea5e7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -67,6 +67,7 @@
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
 #include <linux/gfp.h>
+#include <linux/mm.h> /* for page_address */
 #include <net/mac80211.h>
 
 #include "iwl-commands.h"
@@ -287,6 +288,26 @@ static inline void iwl_free_pages(struct iwl_shared *shrd, unsigned long page)
 	free_pages(page, shrd->hw_params.rx_page_order);
 }
 
+/**
+ * iwl_queue_inc_wrap - increment queue index, wrap back to beginning
+ * @index -- current index
+ * @n_bd -- total number of entries in queue (must be power of 2)
+ */
+static inline int iwl_queue_inc_wrap(int index, int n_bd)
+{
+	return ++index & (n_bd - 1);
+}
+
+/**
+ * iwl_queue_dec_wrap - decrement queue index, wrap back to end
+ * @index -- current index
+ * @n_bd -- total number of entries in queue (must be power of 2)
+ */
+static inline int iwl_queue_dec_wrap(int index, int n_bd)
+{
+	return --index & (n_bd - 1);
+}
+
 struct iwl_rx_mem_buffer {
 	dma_addr_t page_dma;
 	struct page *page;
@@ -357,6 +378,8 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 		struct iwl_cfg *cfg);
 void __devexit iwl_remove(struct iwl_priv * priv);
 
+void iwl_rx_dispatch(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
+int iwlagn_hw_valid_rtc_data_addr(u32 addr);
 void iwl_start_tx_ba_trans_ready(struct iwl_priv *priv,
 				 enum iwl_rxon_context_id ctx,
 				 u8 sta_id, u8 tid);
@@ -364,6 +387,26 @@ void iwl_stop_tx_ba_trans_ready(struct iwl_priv *priv,
 				enum iwl_rxon_context_id ctx,
 				u8 sta_id, u8 tid);
 void iwl_set_hw_rfkill_state(struct iwl_priv *priv, bool state);
+void iwl_apm_stop(struct iwl_priv *priv);
+int iwl_apm_init(struct iwl_priv *priv);
+void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand);
+const char *get_cmd_string(u8 cmd);
+bool iwl_check_for_ct_kill(struct iwl_priv *priv);
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+void iwl_reset_traffic_log(struct iwl_priv *priv);
+#endif /* CONFIG_IWLWIFI_DEBUGFS */
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+void iwl_print_rx_config_cmd(struct iwl_priv *priv, u8 ctxid);
+#else
+static inline void iwl_print_rx_config_cmd(struct iwl_priv *priv, u8 ctxid);
+{
+}
+#endif
+
+#define IWL_CMD(x) case x: return #x
+#define IWL_MASK(lo, hi) ((1 << (hi)) | ((1 << (hi)) - (1 << (lo))))
 
 /*****************************************************
 * DRIVER STATUS FUNCTIONS
diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index 848fc18..3335d31 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -63,6 +63,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/dma-mapping.h>
 #include <net/net_namespace.h>
 #include <linux/netdevice.h>
 #include <net/cfg80211.h>
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index f76526e..c5720cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -32,6 +32,7 @@
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/skbuff.h>
+#include <linux/pci.h>
 
 #include "iwl-fh.h"
 #include "iwl-csr.h"
@@ -114,6 +115,97 @@ struct iwl_dma_ptr {
  */
 #define IWL_IPAN_MCAST_QUEUE		8
 
+struct iwl_cmd_meta {
+	/* only for SYNC commands, iff the reply skb is wanted */
+	struct iwl_host_cmd *source;
+	/*
+	 * only for ASYNC commands
+	 * (which is somewhat stupid -- look at iwl-sta.c for instance
+	 * which duplicates a bunch of code because the callback isn't
+	 * invoked for SYNC commands, if it were and its result passed
+	 * through it would be simpler...)
+	 */
+	void (*callback)(struct iwl_shared *shrd,
+			 struct iwl_device_cmd *cmd,
+			 struct iwl_rx_packet *pkt);
+
+	u32 flags;
+
+	DEFINE_DMA_UNMAP_ADDR(mapping);
+	DEFINE_DMA_UNMAP_LEN(len);
+};
+
+/*
+ * Generic queue structure
+ *
+ * Contains common data for Rx and Tx queues.
+ *
+ * Note the difference between n_bd and n_window: the hardware
+ * always assumes 256 descriptors, so n_bd is always 256 (unless
+ * there might be HW changes in the future). For the normal TX
+ * queues, n_window, which is the size of the software queue data
+ * is also 256; however, for the command queue, n_window is only
+ * 32 since we don't need so many commands pending. Since the HW
+ * still uses 256 BDs for DMA though, n_bd stays 256. As a result,
+ * the software buffers (in the variables @meta, @txb in struct
+ * iwl_tx_queue) only have 32 entries, while the HW buffers (@tfds
+ * in the same struct) have 256.
+ * This means that we end up with the following:
+ *  HW entries: | 0 | ... | N * 32 | ... | N * 32 + 31 | ... | 255 |
+ *  SW entries:           | 0      | ... | 31          |
+ * where N is a number between 0 and 7. This means that the SW
+ * data is a window overlayed over the HW queue.
+ */
+struct iwl_queue {
+	int n_bd;              /* number of BDs in this queue */
+	int write_ptr;       /* 1-st empty entry (index) host_w*/
+	int read_ptr;         /* last used entry (index) host_r*/
+	/* use for monitoring and recovering the stuck queue */
+	dma_addr_t dma_addr;   /* physical addr for BD's */
+	int n_window;	       /* safe queue window */
+	u32 id;
+	int low_mark;	       /* low watermark, resume queue if free
+				* space more than this */
+	int high_mark;         /* high watermark, stop queue if free
+				* space less than this */
+};
+
+/**
+ * struct iwl_tx_queue - Tx Queue for DMA
+ * @q: generic Rx/Tx queue descriptor
+ * @bd: base of circular buffer of TFDs
+ * @cmd: array of command/TX buffer pointers
+ * @meta: array of meta data for each command/tx buffer
+ * @dma_addr_cmd: physical address of cmd/tx buffer array
+ * @txb: array of per-TFD driver data
+ * @time_stamp: time (in jiffies) of last read_ptr change
+ * @need_update: indicates need to update read/write index
+ * @sched_retry: indicates queue is high-throughput aggregation (HT AGG) enabled
+ * @sta_id: valid if sched_retry is set
+ * @tid: valid if sched_retry is set
+ *
+ * A Tx queue consists of circular buffer of BDs (a.k.a. TFDs, transmit frame
+ * descriptors) and required locking structures.
+ */
+#define TFD_TX_CMD_SLOTS 256
+#define TFD_CMD_SLOTS 32
+
+struct iwl_tx_queue {
+	struct iwl_queue q;
+	struct iwl_tfd *tfds;
+	struct iwl_device_cmd **cmd;
+	struct iwl_cmd_meta *meta;
+	struct sk_buff **skbs;
+	unsigned long time_stamp;
+	u8 need_update;
+	u8 sched_retry;
+	u8 active;
+	u8 swq_id;
+
+	u16 sta_id;
+	u16 tid;
+};
+
 /**
  * struct iwl_trans_pcie - PCIe transport specific data
  * @rxq: all the RX queue data
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
index e22cc6d..f7b5750 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
@@ -30,8 +30,7 @@
 #include <linux/wait.h>
 #include <linux/gfp.h>
 
-#include "iwl-dev.h"
-#include "iwl-agn.h"
+/*TODO: Remove include to iwl-core.h*/
 #include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-helpers.h"
@@ -660,8 +659,7 @@ static void iwl_irq_handle_error(struct iwl_trans *trans)
 	iwl_dump_nic_event_log(trans, false, NULL, false);
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (iwl_get_debug_level(trans->shrd) & IWL_DL_FW_ERRORS)
-		iwl_print_rx_config_cmd(priv,
-					&priv->contexts[IWL_RXON_CTX_BSS]);
+		iwl_print_rx_config_cmd(priv(trans), IWL_RXON_CTX_BSS);
 #endif
 
 	iwlagn_fw_error(priv, false);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index 3e71107..b669516 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -30,13 +30,19 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 
-#include "iwl-agn.h"
+/* TODO: remove include to iwl-dev.h */
 #include "iwl-dev.h"
-#include "iwl-core.h"
+#include "iwl-debug.h"
+#include "iwl-csr.h"
+#include "iwl-prph.h"
 #include "iwl-io.h"
+#include "iwl-agn-hw.h"
 #include "iwl-helpers.h"
 #include "iwl-trans-int-pcie.h"
 
+#define IWL_TX_CRC_SIZE 4
+#define IWL_TX_DELIMITER_SIZE 4
+
 /**
  * iwl_trans_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
  */
@@ -945,88 +951,6 @@ void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_mem_buffer *rxb)
 	spin_unlock_irqrestore(&trans->hcmd_lock, flags);
 }
 
-const char *get_cmd_string(u8 cmd)
-{
-	switch (cmd) {
-		IWL_CMD(REPLY_ALIVE);
-		IWL_CMD(REPLY_ERROR);
-		IWL_CMD(REPLY_RXON);
-		IWL_CMD(REPLY_RXON_ASSOC);
-		IWL_CMD(REPLY_QOS_PARAM);
-		IWL_CMD(REPLY_RXON_TIMING);
-		IWL_CMD(REPLY_ADD_STA);
-		IWL_CMD(REPLY_REMOVE_STA);
-		IWL_CMD(REPLY_REMOVE_ALL_STA);
-		IWL_CMD(REPLY_TXFIFO_FLUSH);
-		IWL_CMD(REPLY_WEPKEY);
-		IWL_CMD(REPLY_TX);
-		IWL_CMD(REPLY_LEDS_CMD);
-		IWL_CMD(REPLY_TX_LINK_QUALITY_CMD);
-		IWL_CMD(COEX_PRIORITY_TABLE_CMD);
-		IWL_CMD(COEX_MEDIUM_NOTIFICATION);
-		IWL_CMD(COEX_EVENT_CMD);
-		IWL_CMD(REPLY_QUIET_CMD);
-		IWL_CMD(REPLY_CHANNEL_SWITCH);
-		IWL_CMD(CHANNEL_SWITCH_NOTIFICATION);
-		IWL_CMD(REPLY_SPECTRUM_MEASUREMENT_CMD);
-		IWL_CMD(SPECTRUM_MEASURE_NOTIFICATION);
-		IWL_CMD(POWER_TABLE_CMD);
-		IWL_CMD(PM_SLEEP_NOTIFICATION);
-		IWL_CMD(PM_DEBUG_STATISTIC_NOTIFIC);
-		IWL_CMD(REPLY_SCAN_CMD);
-		IWL_CMD(REPLY_SCAN_ABORT_CMD);
-		IWL_CMD(SCAN_START_NOTIFICATION);
-		IWL_CMD(SCAN_RESULTS_NOTIFICATION);
-		IWL_CMD(SCAN_COMPLETE_NOTIFICATION);
-		IWL_CMD(BEACON_NOTIFICATION);
-		IWL_CMD(REPLY_TX_BEACON);
-		IWL_CMD(WHO_IS_AWAKE_NOTIFICATION);
-		IWL_CMD(QUIET_NOTIFICATION);
-		IWL_CMD(REPLY_TX_PWR_TABLE_CMD);
-		IWL_CMD(MEASURE_ABORT_NOTIFICATION);
-		IWL_CMD(REPLY_BT_CONFIG);
-		IWL_CMD(REPLY_STATISTICS_CMD);
-		IWL_CMD(STATISTICS_NOTIFICATION);
-		IWL_CMD(REPLY_CARD_STATE_CMD);
-		IWL_CMD(CARD_STATE_NOTIFICATION);
-		IWL_CMD(MISSED_BEACONS_NOTIFICATION);
-		IWL_CMD(REPLY_CT_KILL_CONFIG_CMD);
-		IWL_CMD(SENSITIVITY_CMD);
-		IWL_CMD(REPLY_PHY_CALIBRATION_CMD);
-		IWL_CMD(REPLY_RX_PHY_CMD);
-		IWL_CMD(REPLY_RX_MPDU_CMD);
-		IWL_CMD(REPLY_RX);
-		IWL_CMD(REPLY_COMPRESSED_BA);
-		IWL_CMD(CALIBRATION_CFG_CMD);
-		IWL_CMD(CALIBRATION_RES_NOTIFICATION);
-		IWL_CMD(CALIBRATION_COMPLETE_NOTIFICATION);
-		IWL_CMD(REPLY_TX_POWER_DBM_CMD);
-		IWL_CMD(TEMPERATURE_NOTIFICATION);
-		IWL_CMD(TX_ANT_CONFIGURATION_CMD);
-		IWL_CMD(REPLY_BT_COEX_PROFILE_NOTIF);
-		IWL_CMD(REPLY_BT_COEX_PRIO_TABLE);
-		IWL_CMD(REPLY_BT_COEX_PROT_ENV);
-		IWL_CMD(REPLY_WIPAN_PARAMS);
-		IWL_CMD(REPLY_WIPAN_RXON);
-		IWL_CMD(REPLY_WIPAN_RXON_TIMING);
-		IWL_CMD(REPLY_WIPAN_RXON_ASSOC);
-		IWL_CMD(REPLY_WIPAN_QOS_PARAM);
-		IWL_CMD(REPLY_WIPAN_WEPKEY);
-		IWL_CMD(REPLY_WIPAN_P2P_CHANNEL_SWITCH);
-		IWL_CMD(REPLY_WIPAN_NOA_NOTIFICATION);
-		IWL_CMD(REPLY_WIPAN_DEACTIVATION_COMPLETE);
-		IWL_CMD(REPLY_WOWLAN_PATTERNS);
-		IWL_CMD(REPLY_WOWLAN_WAKEUP_FILTER);
-		IWL_CMD(REPLY_WOWLAN_TSC_RSC_PARAMS);
-		IWL_CMD(REPLY_WOWLAN_TKIP_PARAMS);
-		IWL_CMD(REPLY_WOWLAN_KEK_KCK_MATERIAL);
-		IWL_CMD(REPLY_WOWLAN_GET_STATUS);
-	default:
-		return "UNKNOWN";
-
-	}
-}
-
 #define HOST_COMPLETE_TIMEOUT (2 * HZ)
 
 static void iwl_generic_cmd_callback(struct iwl_shared *shrd,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 44e2f91..3948d31 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -65,14 +65,15 @@
 #include <linux/bitops.h>
 #include <linux/gfp.h>
 
-#include "iwl-dev.h"
 #include "iwl-trans.h"
-#include "iwl-core.h"
-#include "iwl-helpers.h"
 #include "iwl-trans-int-pcie.h"
-/*TODO remove uneeded includes when the transport layer tx_free will be here */
-#include "iwl-agn.h"
+#include "iwl-csr.h"
+#include "iwl-prph.h"
 #include "iwl-shared.h"
+#include "iwl-eeprom.h"
+
+/* TODO: the transport layer should not include this */
+#include "iwl-core.h"
 
 static int iwl_trans_rx_alloc(struct iwl_trans *trans)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 7a2daa8..71a6fb0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -73,10 +73,70 @@
  * layer */
 
 struct iwl_priv;
-struct iwl_rxon_context;
-struct iwl_host_cmd;
 struct iwl_shared;
-struct iwl_device_cmd;
+
+#define SEQ_TO_SN(seq) (((seq) & IEEE80211_SCTL_SEQ) >> 4)
+#define SN_TO_SEQ(ssn) (((ssn) << 4) & IEEE80211_SCTL_SEQ)
+#define MAX_SN ((IEEE80211_SCTL_SEQ) >> 4)
+
+enum {
+	CMD_SYNC = 0,
+	CMD_ASYNC = BIT(0),
+	CMD_WANT_SKB = BIT(1),
+	CMD_ON_DEMAND = BIT(2),
+};
+
+#define DEF_CMD_PAYLOAD_SIZE 320
+
+/**
+ * struct iwl_device_cmd
+ *
+ * For allocation of the command and tx queues, this establishes the overall
+ * size of the largest command we send to uCode, except for commands that
+ * aren't fully copied and use other TFD space.
+ */
+struct iwl_device_cmd {
+	struct iwl_cmd_header hdr;	/* uCode API */
+	union {
+		u32 flags;
+		u8 val8;
+		u16 val16;
+		u32 val32;
+		struct iwl_tx_cmd tx;
+		struct iwl6000_channel_switch_cmd chswitch;
+		u8 payload[DEF_CMD_PAYLOAD_SIZE];
+	} __packed cmd;
+} __packed;
+
+#define TFD_MAX_PAYLOAD_SIZE (sizeof(struct iwl_device_cmd))
+
+#define IWL_MAX_CMD_TFDS	2
+
+enum iwl_hcmd_dataflag {
+	IWL_HCMD_DFL_NOCOPY	= BIT(0),
+};
+
+/**
+ * struct iwl_host_cmd - Host command to the uCode
+ * @data: array of chunks that composes the data of the host command
+ * @reply_page: pointer to the page that holds the response to the host command
+ * @callback:
+ * @flags: can be CMD_* note CMD_WANT_SKB is incompatible withe CMD_ASYNC
+ * @len: array of the lenths of the chunks in data
+ * @dataflags:
+ * @id: id of the host command
+ */
+struct iwl_host_cmd {
+	const void *data[IWL_MAX_CMD_TFDS];
+	unsigned long reply_page;
+	void (*callback)(struct iwl_shared *shrd,
+			 struct iwl_device_cmd *cmd,
+			 struct iwl_rx_packet *pkt);
+	u32 flags;
+	u16 len[IWL_MAX_CMD_TFDS];
+	u8 dataflags[IWL_MAX_CMD_TFDS];
+	u8 id;
+};
 
 /**
  * struct iwl_trans_ops - transport specific operations
-- 
1.7.0.4

