Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24108 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbaL3OTw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:19:52 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/33] iwlwifi: pcie: add basic reference accounting
Date: Tue, 30 Dec 2014 16:18:50 +0200
Message-Id: <1419949148-24046-15-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_154347_429577_03A45873)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Implement the ref/unref trans ops and track both tx and
host command queues (and hold references while they
are not empty).

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c       |  5 ++++
 drivers/net/wireless/iwlwifi/iwl-modparams.h |  2 ++
 drivers/net/wireless/iwlwifi/pcie/internal.h |  8 ++++++
 drivers/net/wireless/iwlwifi/pcie/trans.c    | 39 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/pcie/tx.c       | 34 ++++++++++++++++++++----
 5 files changed, 83 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index afa63f7..0381dc4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -1362,6 +1362,7 @@ struct iwl_mod_params iwlwifi_mod_params = {
 	.bt_coex_active = true,
 	.power_level = IWL_POWER_INDEX_1,
 	.wd_disable = true,
+	.d0i3_disable = true,
 #ifndef CONFIG_IWLWIFI_UAPSD
 	.uapsd_disable = true,
 #endif /* CONFIG_IWLWIFI_UAPSD */
@@ -1478,6 +1479,10 @@ MODULE_PARM_DESC(wd_disable,
 module_param_named(nvm_file, iwlwifi_mod_params.nvm_file, charp, S_IRUGO);
 MODULE_PARM_DESC(nvm_file, "NVM file name");
 
+module_param_named(d0i3_disable, iwlwifi_mod_params.d0i3_disable,
+		   bool, S_IRUGO);
+MODULE_PARM_DESC(d0i3_disable, "disable d0i3 functionality (default: Y)");
+
 module_param_named(uapsd_disable, iwlwifi_mod_params.uapsd_disable,
 		   bool, S_IRUGO);
 #ifdef CONFIG_IWLWIFI_UAPSD
diff --git a/drivers/net/wireless/iwlwifi/iwl-modparams.h b/drivers/net/wireless/iwlwifi/iwl-modparams.h
index 71507cf..2a8cf4b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/iwlwifi/iwl-modparams.h
@@ -103,6 +103,7 @@ enum iwl_disable_11n {
  * @power_level: power level, default = 1
  * @debug_level: levels are IWL_DL_*
  * @ant_coupling: antenna coupling in dB, default = 0
+ * @d0i3_disable: disable d0i3, default = 1,
  * @fw_monitor: allow to use firmware monitor
  */
 struct iwl_mod_params {
@@ -121,6 +122,7 @@ struct iwl_mod_params {
 	int ant_coupling;
 	char *nvm_file;
 	bool uapsd_disable;
+	bool d0i3_disable;
 	bool fw_monitor;
 };
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 1aea6b6..e5652d8 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -318,6 +318,11 @@ struct iwl_trans_pcie {
 	/*protect hw register */
 	spinlock_t reg_lock;
 	bool cmd_in_flight;
+	bool ref_cmd_in_flight;
+
+	/* protect ref counter */
+	spinlock_t ref_lock;
+	u32 ref_count;
 
 	dma_addr_t fw_mon_phys;
 	struct page *fw_mon_page;
@@ -381,6 +386,9 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 			    struct sk_buff_head *skbs);
 void iwl_trans_pcie_tx_reset(struct iwl_trans *trans);
 
+void iwl_trans_pcie_ref(struct iwl_trans *trans);
+void iwl_trans_pcie_unref(struct iwl_trans *trans);
+
 static inline u16 iwl_pcie_tfd_tb_get_len(struct iwl_tfd *tfd, u8 idx)
 {
 	struct iwl_tfd_tb *tb = &tfd->tbs[idx];
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 4b42de3..fbdbec8 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -931,6 +931,7 @@ static int iwl_pcie_load_given_ucode_8000b(struct iwl_trans *trans,
 static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 				   const struct fw_img *fw, bool run_in_rfkill)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int ret;
 	bool hw_rfkill;
 
@@ -960,6 +961,9 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 		return ret;
 	}
 
+	/* init ref_count to 1 (should be cleared when ucode is loaded) */
+	trans_pcie->ref_count = 1;
+
 	/* make sure rfkill handshake bits are cleared */
 	iwl_write32(trans, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
 	iwl_write32(trans, CSR_UCODE_DRV_GP1_CLR,
@@ -1550,6 +1554,38 @@ static void iwl_trans_pcie_set_bits_mask(struct iwl_trans *trans, u32 reg,
 	spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);
 }
 
+void iwl_trans_pcie_ref(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	unsigned long flags;
+
+	if (iwlwifi_mod_params.d0i3_disable)
+		return;
+
+	spin_lock_irqsave(&trans_pcie->ref_lock, flags);
+	IWL_DEBUG_RPM(trans, "ref_counter: %d\n", trans_pcie->ref_count);
+	trans_pcie->ref_count++;
+	spin_unlock_irqrestore(&trans_pcie->ref_lock, flags);
+}
+
+void iwl_trans_pcie_unref(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	unsigned long flags;
+
+	if (iwlwifi_mod_params.d0i3_disable)
+		return;
+
+	spin_lock_irqsave(&trans_pcie->ref_lock, flags);
+	IWL_DEBUG_RPM(trans, "ref_counter: %d\n", trans_pcie->ref_count);
+	if (WARN_ON_ONCE(trans_pcie->ref_count == 0)) {
+		spin_unlock_irqrestore(&trans_pcie->ref_lock, flags);
+		return;
+	}
+	trans_pcie->ref_count--;
+	spin_unlock_irqrestore(&trans_pcie->ref_lock, flags);
+}
+
 static const char *get_csr_string(int cmd)
 {
 #define IWL_CMD(x) case x: return #x
@@ -2274,6 +2310,9 @@ static const struct iwl_trans_ops trans_ops_pcie = {
 	.release_nic_access = iwl_trans_pcie_release_nic_access,
 	.set_bits_mask = iwl_trans_pcie_set_bits_mask,
 
+	.ref = iwl_trans_pcie_ref,
+	.unref = iwl_trans_pcie_unref,
+
 	.dump_data = iwl_trans_pcie_dump_data,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 8a6c7a0..c1c4c7502 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -985,17 +985,31 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 
 	if (iwl_queue_space(&txq->q) > txq->q.low_mark)
 		iwl_wake_queue(trans, txq);
+
+	if (q->read_ptr == q->write_ptr) {
+		IWL_DEBUG_RPM(trans, "Q %d - last tx reclaimed\n", q->id);
+		iwl_trans_pcie_unref(trans);
+	}
+
 out:
 	spin_unlock_bh(&txq->lock);
 }
 
-static int iwl_pcie_set_cmd_in_flight(struct iwl_trans *trans)
+static int iwl_pcie_set_cmd_in_flight(struct iwl_trans *trans,
+				      const struct iwl_host_cmd *cmd)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int ret;
 
 	lockdep_assert_held(&trans_pcie->reg_lock);
 
+	if (!(cmd->flags & CMD_SEND_IN_IDLE) &&
+	    !trans_pcie->ref_cmd_in_flight) {
+		trans_pcie->ref_cmd_in_flight = true;
+		IWL_DEBUG_RPM(trans, "set ref_cmd_in_flight - ref\n");
+		iwl_trans_pcie_ref(trans);
+	}
+
 	if (trans_pcie->cmd_in_flight)
 		return 0;
 
@@ -1036,6 +1050,12 @@ static int iwl_pcie_clear_cmd_in_flight(struct iwl_trans *trans)
 
 	lockdep_assert_held(&trans_pcie->reg_lock);
 
+	if (trans_pcie->ref_cmd_in_flight) {
+		trans_pcie->ref_cmd_in_flight = false;
+		IWL_DEBUG_RPM(trans, "clear ref_cmd_in_flight - unref\n");
+		iwl_trans_pcie_unref(trans);
+	}
+
 	if (WARN_ON(!trans_pcie->cmd_in_flight))
 		return 0;
 
@@ -1473,7 +1493,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 		mod_timer(&txq->stuck_timer, jiffies + trans_pcie->wd_timeout);
 
 	spin_lock_irqsave(&trans_pcie->reg_lock, flags);
-	ret = iwl_pcie_set_cmd_in_flight(trans);
+	ret = iwl_pcie_set_cmd_in_flight(trans, cmd);
 	if (ret < 0) {
 		idx = ret;
 		spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);
@@ -1819,9 +1839,13 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	wait_write_ptr = ieee80211_has_morefrags(fc);
 
 	/* start timer if queue currently empty */
-	if (txq->need_update && q->read_ptr == q->write_ptr &&
-	    trans_pcie->wd_timeout)
-		mod_timer(&txq->stuck_timer, jiffies + trans_pcie->wd_timeout);
+	if (q->read_ptr == q->write_ptr) {
+		if (txq->need_update && trans_pcie->wd_timeout)
+			mod_timer(&txq->stuck_timer,
+				  jiffies + trans_pcie->wd_timeout);
+		IWL_DEBUG_RPM(trans, "Q: %d first tx - take ref\n", q->id);
+		iwl_trans_pcie_ref(trans);
+	}
 
 	/* Tell device the write index *just past* this latest filled TFD */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr);
-- 
1.9.1

