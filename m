Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25713 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660AbbDBGl4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:41:56 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/31] iwlwifi: mvm: allow to configure the timeout for the Tx queues
Date: Thu,  2 Apr 2015 09:41:03 +0300
Message-Id: <1427956879-11725-15-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_090420_077829_2846D55C)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes we will want to configure the timeouts for the
Tx queues based on the vif type. Allow to do that using the
trigger mechanism.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h |  3 ++
 drivers/net/wireless/iwlwifi/iwl-fw-file.h       | 23 +++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c      |  5 ++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h           |  4 ++-
 drivers/net/wireless/iwlwifi/mvm/ops.c           |  3 +-
 drivers/net/wireless/iwlwifi/mvm/sta.c           | 10 +++---
 drivers/net/wireless/iwlwifi/mvm/utils.c         | 44 ++++++++++++++++++++++++
 7 files changed, 80 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
index 37b38a5..46cbae8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
@@ -250,6 +250,8 @@ iwl_fw_error_next_data(struct iwl_fw_error_dump_data *data)
  * @FW_DBG_TRIGGER_STATS: trigger log collection upon statistics threshold.
  * @FW_DBG_TRIGGER_RSSI: trigger log collection when the rssi of the beacon
  *	goes below a threshold.
+ * @FW_DBG_TRIGGER_TXQ_TIMERS: configures the timers for the Tx queue hang
+ *	detection.
  */
 enum iwl_fw_dbg_trigger {
 	FW_DBG_TRIGGER_INVALID = 0,
@@ -261,6 +263,7 @@ enum iwl_fw_dbg_trigger {
 	FW_DB_TRIGGER_RESERVED,
 	FW_DBG_TRIGGER_STATS,
 	FW_DBG_TRIGGER_RSSI,
+	FW_DBG_TRIGGER_TXQ_TIMERS,
 
 	/* must be last */
 	FW_DBG_TRIGGER_MAX,
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 60f3f86..0cfc66d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -579,6 +579,29 @@ struct iwl_fw_dbg_trigger_low_rssi {
 } __packed;
 
 /**
+ * struct iwl_fw_dbg_trigger_txq_timer - configures the Tx queue's timer
+ * @command_queue: timeout for the command queue in ms
+ * @bss: timeout for the queues of a BSS (except for TDLS queues) in ms
+ * @softap: timeout for the queues of a softAP in ms
+ * @p2p_go: timeout for the queues of a P2P GO in ms
+ * @p2p_client: timeout for the queues of a P2P client in ms
+ * @p2p_device: timeout for the queues of a P2P device in ms
+ * @ibss: timeout for the queues of an IBSS in ms
+ * @tdls: timeout for the queues of a TDLS station in ms
+ */
+struct iwl_fw_dbg_trigger_txq_timer {
+	__le32 command_queue;
+	__le32 bss;
+	__le32 softap;
+	__le32 p2p_go;
+	__le32 p2p_client;
+	__le32 p2p_device;
+	__le32 ibss;
+	__le32 tdls;
+	__le32 reserved[4];
+} __packed;
+
+/**
  * struct iwl_fw_dbg_conf_tlv - a TLV that describes a debug configuration.
  * @id: conf id
  * @usniffer: should the uSniffer image be used
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 581b3b8..09f0124 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -470,9 +470,8 @@ exit_fail:
 
 int iwl_mvm_mac_ctxt_init(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
-	unsigned int wdg_timeout = iwlmvm_mod_params.tfd_q_hang_detect ?
-					mvm->cfg->base_params->wd_timeout :
-					IWL_WATCHDOG_DISABLED;
+	unsigned int wdg_timeout =
+		iwl_mvm_get_wd_timeout(mvm, vif, false, false);
 	u32 ac;
 	int ret;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 91c74d4..3513f27 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1480,7 +1480,9 @@ void iwl_mvm_free_fw_dump_desc(struct iwl_mvm *mvm);
 int iwl_mvm_fw_dbg_collect_trig(struct iwl_mvm *mvm,
 				struct iwl_fw_dbg_trigger_tlv *trigger,
 				const char *str, size_t len);
-
+unsigned int iwl_mvm_get_wd_timeout(struct iwl_mvm *mvm,
+				    struct ieee80211_vif *vif,
+				    bool tdls, bool cmd_q);
 static inline bool
 iwl_fw_dbg_trigger_vif_match(struct iwl_fw_dbg_trigger_tlv *trig,
 			     struct ieee80211_vif *vif)
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 91361be..388886c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -488,8 +488,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 	/* Set a short watchdog for the command queue */
 	trans_cfg.cmd_q_wdg_timeout =
-		iwlmvm_mod_params.tfd_q_hang_detect ? IWL_DEF_WD_TIMEOUT :
-						      IWL_WATCHDOG_DISABLED;
+		iwl_mvm_get_wd_timeout(mvm, NULL, false, true);
 
 	snprintf(mvm->hw->wiphy->fw_version,
 		 sizeof(mvm->hw->wiphy->fw_version),
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 9bf512b..231e7dd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -209,9 +209,8 @@ static int iwl_mvm_tdls_sta_init(struct iwl_mvm *mvm,
 {
 	unsigned long used_hw_queues;
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
-	unsigned int wdg_timeout = iwlmvm_mod_params.tfd_q_hang_detect ?
-					mvm->cfg->base_params->wd_timeout :
-					IWL_WATCHDOG_DISABLED;
+	unsigned int wdg_timeout =
+		iwl_mvm_get_wd_timeout(mvm, NULL, true, false);
 	u32 ac;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -981,9 +980,8 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 {
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_tid_data *tid_data = &mvmsta->tid_data[tid];
-	unsigned int wdg_timeout = iwlmvm_mod_params.tfd_q_hang_detect ?
-					mvm->cfg->base_params->wd_timeout :
-					IWL_WATCHDOG_DISABLED;
+	unsigned int wdg_timeout =
+		iwl_mvm_get_wd_timeout(mvm, vif, sta->tdls, false);
 	int queue, fifo, ret;
 	u16 ssn;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index 435faee..593a810 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -921,3 +921,47 @@ struct ieee80211_vif *iwl_mvm_get_bss_vif(struct iwl_mvm *mvm)
 
 	return bss_iter_data.vif;
 }
+
+unsigned int iwl_mvm_get_wd_timeout(struct iwl_mvm *mvm,
+				    struct ieee80211_vif *vif,
+				    bool tdls, bool cmd_q)
+{
+	struct iwl_fw_dbg_trigger_tlv *trigger;
+	struct iwl_fw_dbg_trigger_txq_timer *txq_timer;
+	unsigned int default_timeout =
+		cmd_q ? IWL_DEF_WD_TIMEOUT : mvm->cfg->base_params->wd_timeout;
+
+	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_TXQ_TIMERS))
+		return iwlmvm_mod_params.tfd_q_hang_detect ?
+			default_timeout : IWL_WATCHDOG_DISABLED;
+
+	trigger = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_TXQ_TIMERS);
+	txq_timer = (void *)trigger->data;
+
+	if (tdls)
+		return le32_to_cpu(txq_timer->tdls);
+
+	if (cmd_q)
+		return le32_to_cpu(txq_timer->command_queue);
+
+	if (WARN_ON(!vif))
+		return default_timeout;
+
+	switch (ieee80211_vif_type_p2p(vif)) {
+	case NL80211_IFTYPE_ADHOC:
+		return le32_to_cpu(txq_timer->ibss);
+	case NL80211_IFTYPE_STATION:
+		return le32_to_cpu(txq_timer->bss);
+	case NL80211_IFTYPE_AP:
+		return le32_to_cpu(txq_timer->softap);
+	case NL80211_IFTYPE_P2P_CLIENT:
+		return le32_to_cpu(txq_timer->p2p_client);
+	case NL80211_IFTYPE_P2P_GO:
+		return le32_to_cpu(txq_timer->p2p_go);
+	case NL80211_IFTYPE_P2P_DEVICE:
+		return le32_to_cpu(txq_timer->p2p_device);
+	default:
+		WARN_ON(1);
+		return mvm->cfg->base_params->wd_timeout;
+	}
+}
-- 
1.9.1

