Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58230 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161471Ab2COU2O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 16:28:14 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 26/26] iwlwifi: split POWER_PMI status bit
Date: Thu, 15 Mar 2012 13:27:06 -0700
Message-Id: <1331843226-29860-27-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120315_212834_277170_F5D8D408)
In-Reply-To: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

Move the POWER_PMI to the op_mode where it is changed.  The trans needs
to check it frequently, so shadow the status in the trans and update it
in trans when it infrequently changes.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h           |    9 +++++++++
 drivers/net/wireless/iwlwifi/iwl-debugfs.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.c         |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-scan.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    5 ++++-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    4 +++-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c    |   11 +++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans.h         |    7 +++++++
 9 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 22ff87f..fae15c0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -856,7 +856,7 @@ static u8 iwl_count_chain_bitmap(u32 chain_bitmap)
 void iwlagn_set_rxon_chain(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 {
 	bool is_single = is_single_rx_stream(priv);
-	bool is_cam = !test_bit(STATUS_POWER_PMI, &priv->shrd->status);
+	bool is_cam = !test_bit(STATUS_POWER_PMI, &priv->status);
 	u8 idle_rx_cnt, active_rx_cnt, valid_rx_cnt;
 	u32 active_chains;
 	u16 rx_chain;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index cddd9ed..5100162 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -392,6 +392,15 @@ static inline int iwl_is_ready_rf(struct iwl_priv *priv)
 	return iwl_is_ready(priv);
 }
 
+static inline void iwl_dvm_set_pmi(struct iwl_priv *priv, bool state)
+{
+	if (state)
+		set_bit(STATUS_POWER_PMI, &priv->status);
+	else
+		clear_bit(STATUS_POWER_PMI, &priv->status);
+	iwl_trans_set_pmi(trans(priv), state);
+}
+
 #ifdef CONFIG_IWLWIFI_DEBUG
 #define IWL_DEBUG_QUIET_RFKILL(m, fmt, args...)	\
 do {									\
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 03fc27d..417fc37 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -555,7 +555,7 @@ static ssize_t iwl_dbgfs_status_read(struct file *file,
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_SCAN_HW:\t\t %d\n",
 		test_bit(STATUS_SCAN_HW, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_POWER_PMI:\t %d\n",
-		test_bit(STATUS_POWER_PMI, &priv->shrd->status));
+		test_bit(STATUS_POWER_PMI, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_FW_ERROR:\t %d\n",
 		test_bit(STATUS_FW_ERROR, &priv->status));
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 958d9d0..7bc7a82 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -403,12 +403,12 @@ int iwl_power_set_mode(struct iwl_priv *priv, struct iwl_powertable_cmd *cmd,
 	}
 
 	if (cmd->flags & IWL_POWER_DRIVER_ALLOW_SLEEP_MSK)
-		set_bit(STATUS_POWER_PMI, &priv->shrd->status);
+		iwl_dvm_set_pmi(priv, true);
 
 	ret = iwl_set_power(priv, cmd);
 	if (!ret) {
 		if (!(cmd->flags & IWL_POWER_DRIVER_ALLOW_SLEEP_MSK))
-			clear_bit(STATUS_POWER_PMI, &priv->shrd->status);
+			iwl_dvm_set_pmi(priv, false);
 
 		if (update_chains)
 			iwl_update_chain_flags(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 56becf2..dcf5b12 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -850,7 +850,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	 * In power save mode while associated use one chain,
 	 * otherwise use all chains
 	 */
-	if (test_bit(STATUS_POWER_PMI, &priv->shrd->status) &&
+	if (test_bit(STATUS_POWER_PMI, &priv->status) &&
 	    !(priv->hw->conf.flags & IEEE80211_CONF_IDLE)) {
 		/* rx_ant has been set to all valid chains previously */
 		active_chains = rx_ant &
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index a070f51..ab0f3fc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -146,8 +146,11 @@ void iwl_rx_queue_update_write_ptr(struct iwl_trans *trans,
 		q->write_actual = (q->write & ~0x7);
 		iwl_write32(trans, FH_RSCSR_CHNL0_WPTR, q->write_actual);
 	} else {
+		struct iwl_trans_pcie *trans_pcie =
+			IWL_TRANS_GET_PCIE_TRANS(trans);
+
 		/* If power-saving is in use, make sure device is awake */
-		if (test_bit(STATUS_POWER_PMI, &trans->shrd->status)) {
+		if (test_bit(STATUS_POWER_PMI, &trans_pcie->status)) {
 			reg = iwl_read32(trans, CSR_UCODE_DRV_GP1);
 
 			if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 61b0fba..4684e23 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -104,8 +104,10 @@ void iwl_txq_update_write_ptr(struct iwl_trans *trans, struct iwl_tx_queue *txq)
 		iwl_write32(trans, HBUS_TARG_WRPTR,
 			    txq->q.write_ptr | (txq_id << 8));
 	} else {
+		struct iwl_trans_pcie *trans_pcie =
+			IWL_TRANS_GET_PCIE_TRANS(trans);
 		/* if we're trying to save power */
-		if (test_bit(STATUS_POWER_PMI, &trans->shrd->status)) {
+		if (test_bit(STATUS_POWER_PMI, &trans_pcie->status)) {
 			/* wake up nic if it's powered down ...
 			 * uCode will wake up, and interrupt us again, so next
 			 * time we'll skip this part. */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index b0b7107..52e218b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1518,6 +1518,16 @@ static void iwl_trans_pcie_free(struct iwl_trans *trans)
 	kfree(trans);
 }
 
+static void iwl_trans_pcie_set_pmi(struct iwl_trans *trans, bool state)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	if (state)
+		set_bit(STATUS_POWER_PMI, &trans_pcie->status);
+	else
+		clear_bit(STATUS_POWER_PMI, &trans_pcie->status);
+}
+
 #ifdef CONFIG_PM_SLEEP
 static int iwl_trans_pcie_suspend(struct iwl_trans *trans)
 {
@@ -2038,6 +2048,7 @@ const struct iwl_trans_ops trans_ops_pcie = {
 	.write32 = iwl_trans_pcie_write32,
 	.read32 = iwl_trans_pcie_read32,
 	.configure = iwl_trans_pcie_configure,
+	.set_pmi = iwl_trans_pcie_set_pmi,
 };
 
 struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 2785308..66c54c1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -364,6 +364,7 @@ struct iwl_trans_config {
  * @configure: configure parameters required by the transport layer from
  *	the op_mode. May be called several times before start_fw, can't be
  *	called after that.
+ * @set_pmi: set the power pmi state
  */
 struct iwl_trans_ops {
 
@@ -400,6 +401,7 @@ struct iwl_trans_ops {
 	u32 (*read32)(struct iwl_trans *trans, u32 ofs);
 	void (*configure)(struct iwl_trans *trans,
 			  const struct iwl_trans_config *trans_cfg);
+	void (*set_pmi)(struct iwl_trans *trans, bool state);
 };
 
 /**
@@ -611,6 +613,11 @@ static inline u32 iwl_trans_read32(struct iwl_trans *trans, u32 ofs)
 	return trans->ops->read32(trans, ofs);
 }
 
+static inline void iwl_trans_set_pmi(struct iwl_trans *trans, bool state)
+{
+	trans->ops->set_pmi(trans, state);
+}
+
 /*****************************************************
 * Transport layers implementations + their allocation function
 ******************************************************/
-- 
1.7.0.4

