Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38702 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934536Ab1IOTcG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:06 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/27] iwlagn: add documentation to the transport layer
Date: Thu, 15 Sep 2011 11:46:34 -0700
Message-Id: <1316112414-6341-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_213308_179326_78778ADB)
In-Reply-To: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

and do a few clean up fixes on the way

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h |  117 +++++++++++++++++++++--------
 drivers/net/wireless/iwlwifi/iwl-trans.c  |    4 +-
 3 files changed, 91 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index ba5c514..459b82b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -901,7 +901,7 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 			   ba_resp->scd_ssn);
 
 	/* Mark that the expected block-ack response arrived */
-	agg->wait_for_ba = 0;
+	agg->wait_for_ba = false;
 
 	/* Sanity check values reported by uCode */
 	if (ba_resp->txed_2_done > ba_resp->txed) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 36872f0..810b3e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -72,8 +72,27 @@
 
 #include "iwl-commands.h"
 
-/*This files includes all the types / functions that are exported by the
- * upper layer to the bus and transport layer */
+/**
+ * DOC: shared area - role and goal
+ *
+ * The shared area contains all the data exported by the upper layer to the
+ * other layers. Since the bus and transport layer shouldn't dereference
+ * iwl_priv, all the data needed by the upper layer and the transport / bus
+ * layer must be here.
+ * The shared area also holds pointer to all the other layers. This allows a
+ * layer to call a function from another layer.
+ *
+ * NOTE: All the layers hold a pointer to the shared area which must be shrd.
+ *	A few macros assume that (_m)->shrd points to the shared area no matter
+ *	what _m is.
+ *
+ * gets notifications about enumeration, suspend, resume.
+ * For the moment, the bus layer is not a linux kernel module as itself, and
+ * the module_init function of the driver must call the bus specific
+ * registration functions. These functions are listed at the end of this file.
+ * For the moment, there is only one implementation of this interface: PCI-e.
+ * This implementation is iwl-pci.c
+ */
 
 struct iwl_cfg;
 struct iwl_bus;
@@ -90,6 +109,9 @@ extern struct iwl_mod_params iwlagn_mod_params;
 
 /**
  * struct iwl_mod_params
+ *
+ * Holds the module parameters
+ *
  * @sw_crypto: using hardware encryption, default = 0
  * @num_of_queues: number of tx queue, HW dependent
  * @disable_11n: 11n capabilities enabled, default = 0
@@ -134,20 +156,25 @@ struct iwl_mod_params {
 
 /**
  * struct iwl_hw_params
+ *
+ * Holds the module parameters
+ *
  * @max_txq_num: Max # Tx queues supported
  * @num_ampdu_queues: num of ampdu queues
- * @tx/rx_chains_num: Number of TX/RX chains
- * @valid_tx/rx_ant: usable antennas
- * @max_stations:
- * @ht40_channel: is 40MHz width possible in band 2.4
+ * @tx_chains_num: Number of TX chains
+ * @rx_chains_num: Number of RX chains
+ * @valid_tx_ant: usable antennas for TX
+ * @valid_rx_ant: usable antennas for RX
+ * @max_stations: the maximal number of stations
+ * @ht40_channel: is 40MHz width possible: BIT(IEEE80211_BAND_XXX)
  * @beacon_time_tsf_bits: number of valid tsf bits for beacon time
- * @sku:
+ * @sku: sku read from EEPROM
  * @rx_page_order: Rx buffer page order
- * @rx_wrt_ptr_reg: FH{39}_RSCSR_CHNL0_WPTR
- * BIT(IEEE80211_BAND_5GHZ) BIT(IEEE80211_BAND_5GHZ)
- * @sw_crypto: 0 for hw, 1 for sw
- * @max_xxx_size: for ucode uses
- * @ct_kill_threshold: temperature threshold
+ * @max_inst_size: for ucode use
+ * @max_data_size: for ucode use
+ * @ct_kill_threshold: temperature threshold - in hw dependent unit
+ * @ct_kill_exit_threshold: when to reeable the device - in hw dependent unit
+ *	relevant for 1000, 6000 and up
  * @wd_timeout: TX queues watchdog timeout
  * @calib_init_cfg: setup initial calibrations for the hw
  * @calib_rt_cfg: setup runtime calibrations for the hw
@@ -168,9 +195,8 @@ struct iwl_hw_params {
 	u32 rx_page_order;
 	u32 max_inst_size;
 	u32 max_data_size;
-	u32 ct_kill_threshold; /* value in hw-dependent units */
-	u32 ct_kill_exit_threshold; /* value in hw-dependent units */
-				    /* for 1000, 6000 series and up */
+	u32 ct_kill_threshold;
+	u32 ct_kill_exit_threshold;
 	unsigned int wd_timeout;
 
 	u32 calib_init_cfg;
@@ -179,28 +205,59 @@ struct iwl_hw_params {
 };
 
 /**
- * struct iwl_ht_agg - aggregation status while waiting for block-ack
- * @txq_id: Tx queue used for Tx attempt
- * @wait_for_ba: Expect block-ack before next Tx reply
- * @rate_n_flags: Rate at which Tx was attempted
+ * enum iwl_agg_state
+ *
+ * The state machine of the BA agreement establishment / tear down.
+ * These states relate to a specific RA / TID.
  *
- * If REPLY_TX indicates that aggregation was attempted, driver must wait
- * for block ack (REPLY_COMPRESSED_BA).  This struct stores tx reply info
- * until block ack arrives.
+ * @IWL_AGG_OFF: aggregation is not used
+ * @IWL_AGG_ON: aggregation session is up
+ * @IWL_EMPTYING_HW_QUEUE_ADDBA: establishing a BA session - waiting for the
+ *	HW queue to be empty from packets for this RA /TID.
+ * @IWL_EMPTYING_HW_QUEUE_DELBA: tearing down a BA session - waiting for the
+ *	HW queue to be empty from packets for this RA /TID.
+ */
+enum iwl_agg_state {
+	IWL_AGG_OFF = 0,
+	IWL_AGG_ON,
+	IWL_EMPTYING_HW_QUEUE_ADDBA,
+	IWL_EMPTYING_HW_QUEUE_DELBA,
+};
+
+/**
+ * struct iwl_ht_agg - aggregation state machine
+
+ * This structs holds the states for the BA agreement establishment and tear
+ * down. It also holds the state during the BA session itself. This struct is
+ * duplicated for each RA / TID.
+
+ * @rate_n_flags: Rate at which Tx was attempted. Holds the data between the
+ *	Tx response (REPLY_TX), and the block ack notification
+ *	(REPLY_COMPRESSED_BA).
+ * @state: state of the BA agreement establishment / tear down.
+ * @txq_id: Tx queue used by the BA session - used by the transport layer.
+ *	Needed by the upper layer for debugfs only.
+ * @wait_for_ba: Expect block-ack before next Tx reply
  */
 struct iwl_ht_agg {
-	u16 txq_id;
-	u16 wait_for_ba;
 	u32 rate_n_flags;
-#define IWL_AGG_OFF 0
-#define IWL_AGG_ON 1
-#define IWL_EMPTYING_HW_QUEUE_ADDBA 2
-#define IWL_EMPTYING_HW_QUEUE_DELBA 3
-	u8 state;
+	enum iwl_agg_state state;
+	u16 txq_id;
+	bool wait_for_ba;
 };
 
+/**
+ * struct iwl_tid_data - one for each RA / TID
+
+ * This structs holds the states for each RA / TID.
+
+ * @seq_number: the next WiFi sequence number to use
+ * @tfds_in_queue: number of packets sent to the HW queues.
+ *	Exported for debugfs only
+ * @agg: aggregation state machine
+ */
 struct iwl_tid_data {
-	u16 seq_number; /* agn only */
+	u16 seq_number;
 	u16 tfds_in_queue;
 	struct iwl_ht_agg agg;
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 209dd7e..d4f6281 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -1300,6 +1300,8 @@ static int iwlagn_txq_check_empty(struct iwl_trans *trans,
 						    sta_id, tid);
 		}
 		break;
+	default:
+		break;
 	}
 
 	return 0;
@@ -1326,10 +1328,10 @@ static void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_tx_queue *txq = &trans_pcie->txq[txq_id];
+	enum iwl_agg_state agg_state;
 	/* n_bd is usually 256 => n_bd - 1 = 0xff */
 	int tfd_num = ssn & (txq->q.n_bd - 1);
 	int freed = 0;
-	u8 agg_state;
 	bool cond;
 
 	txq->time_stamp = jiffies;
-- 
1.7.0.4

