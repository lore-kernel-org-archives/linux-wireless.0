Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:53947 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbbLUUwo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:52:44 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 43/45] iwlwifi: remove unused parameter from grab_nic_access
Date: Mon, 21 Dec 2015 22:50:44 +0200
Message-Id: <1450731046-2796-43-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_220101_144336_83899CFF)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All the callers used silent = false.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/main.c   |  4 ++--
 drivers/net/wireless/intel/iwlwifi/dvm/tt.c     |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c     | 14 ++++++-------
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h  |  7 +++----
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c |  4 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 27 +++++++++++--------------
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c    |  2 +-
 7 files changed, 28 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index 94bc66a..f62c2d7 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -429,7 +429,7 @@ static void iwl_print_cont_event_trace(struct iwl_priv *priv, u32 base,
 		ptr = base + (4 * sizeof(u32)) + (start_idx * 3 * sizeof(u32));
 
 	/* Make sure device is powered up for SRAM reads */
-	if (!iwl_trans_grab_nic_access(priv->trans, false, &reg_flags))
+	if (!iwl_trans_grab_nic_access(priv->trans, &reg_flags))
 		return;
 
 	/* Set starting address; reads will auto-increment */
@@ -1731,7 +1731,7 @@ static int iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 	ptr = base + EVENT_START_OFFSET + (start_idx * event_size);
 
 	/* Make sure device is powered up for SRAM reads */
-	if (!iwl_trans_grab_nic_access(trans, false, &reg_flags))
+	if (!iwl_trans_grab_nic_access(trans, &reg_flags))
 		return pos;
 
 	/* Set starting address; reads will auto-increment */
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/tt.c b/drivers/net/wireless/intel/iwlwifi/dvm/tt.c
index 7decfc5..5b73492 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/tt.c
@@ -184,7 +184,7 @@ static void iwl_tt_check_exit_ct_kill(unsigned long data)
 			priv->thermal_throttle.ct_kill_toggle = true;
 		}
 		iwl_read32(priv->trans, CSR_UCODE_DRV_GP1);
-		if (iwl_trans_grab_nic_access(priv->trans, false, &flags))
+		if (iwl_trans_grab_nic_access(priv->trans, &flags))
 			iwl_trans_release_nic_access(priv->trans, &flags);
 
 		/* Reschedule the ct_kill timer to occur in
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
index 07ad5c8..32c8f84 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
@@ -82,7 +82,7 @@ u32 iwl_read_direct32(struct iwl_trans *trans, u32 reg)
 {
 	u32 value = 0x5a5a5a5a;
 	unsigned long flags;
-	if (iwl_trans_grab_nic_access(trans, false, &flags)) {
+	if (iwl_trans_grab_nic_access(trans, &flags)) {
 		value = iwl_read32(trans, reg);
 		iwl_trans_release_nic_access(trans, &flags);
 	}
@@ -95,7 +95,7 @@ void iwl_write_direct32(struct iwl_trans *trans, u32 reg, u32 value)
 {
 	unsigned long flags;
 
-	if (iwl_trans_grab_nic_access(trans, false, &flags)) {
+	if (iwl_trans_grab_nic_access(trans, &flags)) {
 		iwl_write32(trans, reg, value);
 		iwl_trans_release_nic_access(trans, &flags);
 	}
@@ -138,7 +138,7 @@ u32 iwl_read_prph(struct iwl_trans *trans, u32 ofs)
 	unsigned long flags;
 	u32 val = 0x5a5a5a5a;
 
-	if (iwl_trans_grab_nic_access(trans, false, &flags)) {
+	if (iwl_trans_grab_nic_access(trans, &flags)) {
 		val = iwl_read_prph_no_grab(trans, ofs);
 		iwl_trans_release_nic_access(trans, &flags);
 	}
@@ -150,7 +150,7 @@ void iwl_write_prph(struct iwl_trans *trans, u32 ofs, u32 val)
 {
 	unsigned long flags;
 
-	if (iwl_trans_grab_nic_access(trans, false, &flags)) {
+	if (iwl_trans_grab_nic_access(trans, &flags)) {
 		iwl_write_prph_no_grab(trans, ofs, val);
 		iwl_trans_release_nic_access(trans, &flags);
 	}
@@ -176,7 +176,7 @@ void iwl_set_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
 {
 	unsigned long flags;
 
-	if (iwl_trans_grab_nic_access(trans, false, &flags)) {
+	if (iwl_trans_grab_nic_access(trans, &flags)) {
 		iwl_write_prph_no_grab(trans, ofs,
 				       iwl_read_prph_no_grab(trans, ofs) |
 				       mask);
@@ -190,7 +190,7 @@ void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 ofs,
 {
 	unsigned long flags;
 
-	if (iwl_trans_grab_nic_access(trans, false, &flags)) {
+	if (iwl_trans_grab_nic_access(trans, &flags)) {
 		iwl_write_prph_no_grab(trans, ofs,
 				       (iwl_read_prph_no_grab(trans, ofs) &
 					mask) | bits);
@@ -204,7 +204,7 @@ void iwl_clear_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
 	unsigned long flags;
 	u32 val;
 
-	if (iwl_trans_grab_nic_access(trans, false, &flags)) {
+	if (iwl_trans_grab_nic_access(trans, &flags)) {
 		val = iwl_read_prph_no_grab(trans, ofs);
 		iwl_write_prph_no_grab(trans, ofs, (val & ~mask));
 		iwl_trans_release_nic_access(trans, &flags);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 43a4874..290d538 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -652,8 +652,7 @@ struct iwl_trans_ops {
 	void (*configure)(struct iwl_trans *trans,
 			  const struct iwl_trans_config *trans_cfg);
 	void (*set_pmi)(struct iwl_trans *trans, bool state);
-	bool (*grab_nic_access)(struct iwl_trans *trans, bool silent,
-				unsigned long *flags);
+	bool (*grab_nic_access)(struct iwl_trans *trans, unsigned long *flags);
 	void (*release_nic_access)(struct iwl_trans *trans,
 				   unsigned long *flags);
 	void (*set_bits_mask)(struct iwl_trans *trans, u32 reg, u32 mask,
@@ -1170,9 +1169,9 @@ iwl_trans_set_bits_mask(struct iwl_trans *trans, u32 reg, u32 mask, u32 value)
 	trans->ops->set_bits_mask(trans, reg, mask, value);
 }
 
-#define iwl_trans_grab_nic_access(trans, silent, flags)	\
+#define iwl_trans_grab_nic_access(trans, flags)	\
 	__cond_lock(nic_access,				\
-		    likely((trans)->ops->grab_nic_access(trans, silent, flags)))
+		    likely((trans)->ops->grab_nic_access(trans, flags)))
 
 static inline void __releases(nic_access)
 iwl_trans_release_nic_access(struct iwl_trans *trans, unsigned long *flags)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index 29d54ec..f406c76 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -122,7 +122,7 @@ static void iwl_mvm_dump_fifos(struct iwl_mvm *mvm,
 	unsigned long flags;
 	int i, j;
 
-	if (!iwl_trans_grab_nic_access(mvm->trans, false, &flags))
+	if (!iwl_trans_grab_nic_access(mvm->trans, &flags))
 		return;
 
 	/* Pull RXF data from all RXFs */
@@ -359,7 +359,7 @@ static u32 iwl_dump_prph(struct iwl_trans *trans,
 	unsigned long flags;
 	u32 prph_len = 0, i;
 
-	if (!iwl_trans_grab_nic_access(trans, false, &flags))
+	if (!iwl_trans_grab_nic_access(trans, &flags))
 		return 0;
 
 	for (i = 0; i < ARRAY_SIZE(iwl_prph_dump_addr); i++) {
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index e804190..d44e7af 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1505,8 +1505,8 @@ static void iwl_trans_pcie_set_pmi(struct iwl_trans *trans, bool state)
 		clear_bit(STATUS_TPOWER_PMI, &trans->status);
 }
 
-static bool iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans, bool silent,
-						unsigned long *flags)
+static bool iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans,
+					   unsigned long *flags)
 {
 	int ret;
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
@@ -1547,14 +1547,11 @@ static bool iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans, bool silent,
 			    CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 15000);
 	if (unlikely(ret < 0)) {
 		iwl_write32(trans, CSR_RESET, CSR_RESET_REG_FLAG_FORCE_NMI);
-		if (!silent) {
-			u32 val = iwl_read32(trans, CSR_GP_CNTRL);
-			WARN_ONCE(1,
-				  "Timeout waiting for hardware access (CSR_GP_CNTRL 0x%08x)\n",
-				  val);
-			spin_unlock_irqrestore(&trans_pcie->reg_lock, *flags);
-			return false;
-		}
+		WARN_ONCE(1,
+			  "Timeout waiting for hardware access (CSR_GP_CNTRL 0x%08x)\n",
+			  iwl_read32(trans, CSR_GP_CNTRL));
+		spin_unlock_irqrestore(&trans_pcie->reg_lock, *flags);
+		return false;
 	}
 
 out:
@@ -1602,7 +1599,7 @@ static int iwl_trans_pcie_read_mem(struct iwl_trans *trans, u32 addr,
 	int offs, ret = 0;
 	u32 *vals = buf;
 
-	if (iwl_trans_grab_nic_access(trans, false, &flags)) {
+	if (iwl_trans_grab_nic_access(trans, &flags)) {
 		iwl_write32(trans, HBUS_TARG_MEM_RADDR, addr);
 		for (offs = 0; offs < dwords; offs++)
 			vals[offs] = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
@@ -1620,7 +1617,7 @@ static int iwl_trans_pcie_write_mem(struct iwl_trans *trans, u32 addr,
 	int offs, ret = 0;
 	const u32 *vals = buf;
 
-	if (iwl_trans_grab_nic_access(trans, false, &flags)) {
+	if (iwl_trans_grab_nic_access(trans, &flags)) {
 		iwl_write32(trans, HBUS_TARG_MEM_WADDR, addr);
 		for (offs = 0; offs < dwords; offs++)
 			iwl_write32(trans, HBUS_TARG_MEM_WDAT,
@@ -2246,7 +2243,7 @@ static u32 iwl_trans_pcie_fh_regs_dump(struct iwl_trans *trans,
 	__le32 *val;
 	int i;
 
-	if (!iwl_trans_grab_nic_access(trans, false, &flags))
+	if (!iwl_trans_grab_nic_access(trans, &flags))
 		return 0;
 
 	(*data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_FH_REGS);
@@ -2273,7 +2270,7 @@ iwl_trans_pci_dump_marbh_monitor(struct iwl_trans *trans,
 	unsigned long flags;
 	u32 i;
 
-	if (!iwl_trans_grab_nic_access(trans, false, &flags))
+	if (!iwl_trans_grab_nic_access(trans, &flags))
 		return 0;
 
 	iwl_write_prph_no_grab(trans, MON_DMARB_RD_CTL_ADDR, 0x1);
@@ -2658,7 +2655,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 			goto out_pci_disable_msi;
 		}
 
-		if (iwl_trans_grab_nic_access(trans, false, &flags)) {
+		if (iwl_trans_grab_nic_access(trans, &flags)) {
 			u32 hw_step;
 
 			hw_step = iwl_read_prph_no_grab(trans, WFPM_CTRL_REG);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index a85ae10..5262028 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -770,7 +770,7 @@ static void iwl_pcie_tx_stop_fh(struct iwl_trans *trans)
 
 	spin_lock(&trans_pcie->irq_lock);
 
-	if (!iwl_trans_grab_nic_access(trans, false, &flags))
+	if (!iwl_trans_grab_nic_access(trans, &flags))
 		goto out;
 
 	/* Stop each Tx DMA channel */
-- 
2.5.0

