Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48383 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab3ACOpy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 09:45:54 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/12] iwlwifi: virtualize iwl_{grab,release}_nic_access
Date: Thu,  3 Jan 2013 15:46:10 +0100
Message-Id: <1357224376-27803-6-git-send-email-johannes@sipsolutions.net> (sfid-20130103_154601_415075_A4CCCB5E)
In-Reply-To: <1357224376-27803-1-git-send-email-johannes@sipsolutions.net>
References: <1357224324.9741.20.camel@jlt4.sipsolutions.net>
 <1357224376-27803-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since different transports have different ways to wake the
up the NIC, we need to virtualize it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |   4 +-
 drivers/net/wireless/iwlwifi/dvm/main.c     |   8 +-
 drivers/net/wireless/iwlwifi/dvm/tt.c       |   4 +-
 drivers/net/wireless/iwlwifi/iwl-io.c       | 114 ++++++----------------------
 drivers/net/wireless/iwlwifi/iwl-io.h       |   6 +-
 drivers/net/wireless/iwlwifi/iwl-test.c     |   8 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h    |  15 ++++
 drivers/net/wireless/iwlwifi/pcie/trans.c   |  64 ++++++++++++++++
 8 files changed, 115 insertions(+), 108 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 3163e0f..8965a98 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -459,11 +459,11 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 	base = priv->device_pointers.error_event_table;
 	if (iwlagn_hw_valid_rtc_data_addr(base)) {
 		spin_lock_irqsave(&priv->trans->reg_lock, flags);
-		ret = iwl_grab_nic_access_silent(priv->trans);
+		ret = iwl_trans_grab_nic_access(priv->trans, true);
 		if (likely(ret == 0)) {
 			iwl_write32(priv->trans, HBUS_TARG_MEM_RADDR, base);
 			status = iwl_read32(priv->trans, HBUS_TARG_MEM_RDAT);
-			iwl_release_nic_access(priv->trans);
+			iwl_trans_release_nic_access(priv->trans);
 		}
 		spin_unlock_irqrestore(&priv->trans->reg_lock, flags);
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index faa0593..c4caedd 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -354,7 +354,7 @@ static void iwl_print_cont_event_trace(struct iwl_priv *priv, u32 base,
 
 	/* Make sure device is powered up for SRAM reads */
 	spin_lock_irqsave(&priv->trans->reg_lock, reg_flags);
-	if (unlikely(!iwl_grab_nic_access(priv->trans))) {
+	if (unlikely(!iwl_trans_grab_nic_access(priv->trans, false))) {
 		spin_unlock_irqrestore(&priv->trans->reg_lock, reg_flags);
 		return;
 	}
@@ -388,7 +388,7 @@ static void iwl_print_cont_event_trace(struct iwl_priv *priv, u32 base,
 		}
 	}
 	/* Allow device to power down */
-	iwl_release_nic_access(priv->trans);
+	iwl_trans_release_nic_access(priv->trans);
 	spin_unlock_irqrestore(&priv->trans->reg_lock, reg_flags);
 }
 
@@ -1717,7 +1717,7 @@ static int iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 
 	/* Make sure device is powered up for SRAM reads */
 	spin_lock_irqsave(&trans->reg_lock, reg_flags);
-	if (unlikely(!iwl_grab_nic_access(trans)))
+	if (unlikely(!iwl_trans_grab_nic_access(trans, false)))
 		goto out_unlock;
 
 	/* Set starting address; reads will auto-increment */
@@ -1756,7 +1756,7 @@ static int iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 	}
 
 	/* Allow device to power down */
-	iwl_release_nic_access(trans);
+	iwl_trans_release_nic_access(trans);
 out_unlock:
 	spin_unlock_irqrestore(&trans->reg_lock, reg_flags);
 	return pos;
diff --git a/drivers/net/wireless/iwlwifi/dvm/tt.c b/drivers/net/wireless/iwlwifi/dvm/tt.c
index eb86443..a8ae513 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tt.c
@@ -186,8 +186,8 @@ static void iwl_tt_check_exit_ct_kill(unsigned long data)
 		}
 		iwl_read32(priv->trans, CSR_UCODE_DRV_GP1);
 		spin_lock_irqsave(&priv->trans->reg_lock, flags);
-		if (likely(iwl_grab_nic_access(priv->trans)))
-			iwl_release_nic_access(priv->trans);
+		if (likely(iwl_trans_grab_nic_access(priv->trans, false)))
+			iwl_trans_release_nic_access(priv->trans);
 		spin_unlock_irqrestore(&priv->trans->reg_lock, flags);
 
 		/* Reschedule the ct_kill timer to occur in
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index cdaff95..cb36fed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -35,12 +35,12 @@
 
 #define IWL_POLL_INTERVAL 10	/* microseconds */
 
-static inline void __iwl_set_bit(struct iwl_trans *trans, u32 reg, u32 mask)
+void __iwl_set_bit(struct iwl_trans *trans, u32 reg, u32 mask)
 {
 	iwl_write32(trans, reg, iwl_read32(trans, reg) | mask);
 }
 
-static inline void __iwl_clear_bit(struct iwl_trans *trans, u32 reg, u32 mask)
+void __iwl_clear_bit(struct iwl_trans *trans, u32 reg, u32 mask)
 {
 	iwl_write32(trans, reg, iwl_read32(trans, reg) & ~mask);
 }
@@ -99,86 +99,15 @@ int iwl_poll_bit(struct iwl_trans *trans, u32 addr,
 }
 EXPORT_SYMBOL_GPL(iwl_poll_bit);
 
-int iwl_grab_nic_access_silent(struct iwl_trans *trans)
-{
-	int ret;
-
-	lockdep_assert_held(&trans->reg_lock);
-
-	/* this bit wakes up the NIC */
-	__iwl_set_bit(trans, CSR_GP_CNTRL,
-		      CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-
-	/*
-	 * These bits say the device is running, and should keep running for
-	 * at least a short while (at least as long as MAC_ACCESS_REQ stays 1),
-	 * but they do not indicate that embedded SRAM is restored yet;
-	 * 3945 and 4965 have volatile SRAM, and must save/restore contents
-	 * to/from host DRAM when sleeping/waking for power-saving.
-	 * Each direction takes approximately 1/4 millisecond; with this
-	 * overhead, it's a good idea to grab and hold MAC_ACCESS_REQUEST if a
-	 * series of register accesses are expected (e.g. reading Event Log),
-	 * to keep device from sleeping.
-	 *
-	 * CSR_UCODE_DRV_GP1 register bit MAC_SLEEP == 0 indicates that
-	 * SRAM is okay/restored.  We don't check that here because this call
-	 * is just for hardware register access; but GP1 MAC_SLEEP check is a
-	 * good idea before accessing 3945/4965 SRAM (e.g. reading Event Log).
-	 *
-	 * 5000 series and later (including 1000 series) have non-volatile SRAM,
-	 * and do not save/restore SRAM when power cycling.
-	 */
-	ret = iwl_poll_bit(trans, CSR_GP_CNTRL,
-			   CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN,
-			   (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
-			    CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 15000);
-	if (ret < 0) {
-		iwl_write32(trans, CSR_RESET, CSR_RESET_REG_FLAG_FORCE_NMI);
-		return -EIO;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(iwl_grab_nic_access_silent);
-
-bool iwl_grab_nic_access(struct iwl_trans *trans)
-{
-	int ret = iwl_grab_nic_access_silent(trans);
-	if (unlikely(ret)) {
-		u32 val = iwl_read32(trans, CSR_GP_CNTRL);
-		WARN_ONCE(1, "Timeout waiting for hardware access "
-			     "(CSR_GP_CNTRL 0x%08x)\n", val);
-		return false;
-	}
-
-	return true;
-}
-EXPORT_SYMBOL_GPL(iwl_grab_nic_access);
-
-void iwl_release_nic_access(struct iwl_trans *trans)
-{
-	lockdep_assert_held(&trans->reg_lock);
-	__iwl_clear_bit(trans, CSR_GP_CNTRL,
-			CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-	/*
-	 * Above we read the CSR_GP_CNTRL register, which will flush
-	 * any previous writes, but we need the write that clears the
-	 * MAC_ACCESS_REQ bit to be performed before any other writes
-	 * scheduled on different CPUs (after we drop reg_lock).
-	 */
-	mmiowb();
-}
-EXPORT_SYMBOL_GPL(iwl_release_nic_access);
-
 u32 iwl_read_direct32(struct iwl_trans *trans, u32 reg)
 {
 	u32 value;
 	unsigned long flags;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
-	iwl_grab_nic_access(trans);
+	iwl_trans_grab_nic_access(trans, false);
 	value = iwl_read32(trans, reg);
-	iwl_release_nic_access(trans);
+	iwl_trans_release_nic_access(trans);
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 
 	return value;
@@ -190,9 +119,9 @@ void iwl_write_direct32(struct iwl_trans *trans, u32 reg, u32 value)
 	unsigned long flags;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
-	if (likely(iwl_grab_nic_access(trans))) {
+	if (likely(iwl_trans_grab_nic_access(trans, false))) {
 		iwl_write32(trans, reg, value);
-		iwl_release_nic_access(trans);
+		iwl_trans_release_nic_access(trans);
 	}
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
@@ -233,9 +162,9 @@ u32 iwl_read_prph(struct iwl_trans *trans, u32 ofs)
 	u32 val;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
-	iwl_grab_nic_access(trans);
+	iwl_trans_grab_nic_access(trans, false);
 	val = __iwl_read_prph(trans, ofs);
-	iwl_release_nic_access(trans);
+	iwl_trans_release_nic_access(trans);
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 	return val;
 }
@@ -246,9 +175,9 @@ void iwl_write_prph(struct iwl_trans *trans, u32 ofs, u32 val)
 	unsigned long flags;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
-	if (likely(iwl_grab_nic_access(trans))) {
+	if (likely(iwl_trans_grab_nic_access(trans, false))) {
 		__iwl_write_prph(trans, ofs, val);
-		iwl_release_nic_access(trans);
+		iwl_trans_release_nic_access(trans);
 	}
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
@@ -259,10 +188,10 @@ void iwl_set_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
 	unsigned long flags;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
-	if (likely(iwl_grab_nic_access(trans))) {
+	if (likely(iwl_trans_grab_nic_access(trans, false))) {
 		__iwl_write_prph(trans, ofs,
 				 __iwl_read_prph(trans, ofs) | mask);
-		iwl_release_nic_access(trans);
+		iwl_trans_release_nic_access(trans);
 	}
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
@@ -274,10 +203,10 @@ void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 ofs,
 	unsigned long flags;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
-	if (likely(iwl_grab_nic_access(trans))) {
+	if (likely(iwl_trans_grab_nic_access(trans, false))) {
 		__iwl_write_prph(trans, ofs,
 				 (__iwl_read_prph(trans, ofs) & mask) | bits);
-		iwl_release_nic_access(trans);
+		iwl_trans_release_nic_access(trans);
 	}
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
@@ -289,10 +218,10 @@ void iwl_clear_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
 	u32 val;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
-	if (likely(iwl_grab_nic_access(trans))) {
+	if (likely(iwl_trans_grab_nic_access(trans, false))) {
 		val = __iwl_read_prph(trans, ofs);
 		__iwl_write_prph(trans, ofs, (val & ~mask));
-		iwl_release_nic_access(trans);
+		iwl_trans_release_nic_access(trans);
 	}
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
@@ -306,11 +235,11 @@ void _iwl_read_targ_mem_dwords(struct iwl_trans *trans, u32 addr,
 	u32 *vals = buf;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
-	if (likely(iwl_grab_nic_access(trans))) {
+	if (likely(iwl_trans_grab_nic_access(trans, false))) {
 		iwl_write32(trans, HBUS_TARG_MEM_RADDR, addr);
 		for (offs = 0; offs < dwords; offs++)
 			vals[offs] = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
-		iwl_release_nic_access(trans);
+		iwl_trans_release_nic_access(trans);
 	}
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
@@ -334,13 +263,14 @@ int _iwl_write_targ_mem_dwords(struct iwl_trans *trans, u32 addr,
 	const u32 *vals = buf;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
-	if (likely(iwl_grab_nic_access(trans))) {
+	if (likely(iwl_trans_grab_nic_access(trans, false))) {
 		iwl_write32(trans, HBUS_TARG_MEM_WADDR, addr);
 		for (offs = 0; offs < dwords; offs++)
 			iwl_write32(trans, HBUS_TARG_MEM_WDAT, vals[offs]);
-		iwl_release_nic_access(trans);
-	} else
+		iwl_trans_release_nic_access(trans);
+	} else {
 		result = -EBUSY;
+	}
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 
 	return result;
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 48dc753..40eb0a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -53,6 +53,8 @@ static inline u32 iwl_read32(struct iwl_trans *trans, u32 ofs)
 
 void iwl_set_bit(struct iwl_trans *trans, u32 reg, u32 mask);
 void iwl_clear_bit(struct iwl_trans *trans, u32 reg, u32 mask);
+void __iwl_set_bit(struct iwl_trans *trans, u32 reg, u32 mask);
+void __iwl_clear_bit(struct iwl_trans *trans, u32 reg, u32 mask);
 
 void iwl_set_bits_mask(struct iwl_trans *trans, u32 reg, u32 mask, u32 value);
 
@@ -61,10 +63,6 @@ int iwl_poll_bit(struct iwl_trans *trans, u32 addr,
 int iwl_poll_direct_bit(struct iwl_trans *trans, u32 addr, u32 mask,
 			int timeout);
 
-int iwl_grab_nic_access_silent(struct iwl_trans *trans);
-bool iwl_grab_nic_access(struct iwl_trans *trans);
-void iwl_release_nic_access(struct iwl_trans *trans);
-
 u32 iwl_read_direct32(struct iwl_trans *trans, u32 reg);
 void iwl_write_direct32(struct iwl_trans *trans, u32 reg, u32 value);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-test.c b/drivers/net/wireless/iwlwifi/iwl-test.c
index 81e8c71..08c1cfe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-test.c
+++ b/drivers/net/wireless/iwlwifi/iwl-test.c
@@ -467,13 +467,13 @@ static int iwl_test_indirect_read(struct iwl_test *tst, u32 addr, u32 size)
 	if (IWL_ABS_PRPH_START <= addr &&
 	    addr < IWL_ABS_PRPH_START + PRPH_END) {
 			spin_lock_irqsave(&trans->reg_lock, flags);
-			iwl_grab_nic_access(trans);
+			iwl_trans_grab_nic_access(trans, false);
 			iwl_write32(trans, HBUS_TARG_PRPH_RADDR,
 				    addr | (3 << 24));
 			for (i = 0; i < size; i += 4)
 				*(u32 *)(tst->mem.addr + i) =
 					iwl_read32(trans, HBUS_TARG_PRPH_RDAT);
-			iwl_release_nic_access(trans);
+			iwl_trans_release_nic_access(trans);
 			spin_unlock_irqrestore(&trans->reg_lock, flags);
 	} else { /* target memory (SRAM) */
 		_iwl_read_targ_mem_dwords(trans, addr,
@@ -505,12 +505,12 @@ static int iwl_test_indirect_write(struct iwl_test *tst, u32 addr,
 			if (size < 4) {
 				memcpy(&val, buf, size);
 				spin_lock_irqsave(&trans->reg_lock, flags);
-				iwl_grab_nic_access(trans);
+				iwl_trans_grab_nic_access(trans, false);
 				iwl_write32(trans, HBUS_TARG_PRPH_WADDR,
 					    (addr & 0x0000FFFF) |
 					    ((size - 1) << 24));
 				iwl_write32(trans, HBUS_TARG_PRPH_WDAT, val);
-				iwl_release_nic_access(trans);
+				iwl_trans_release_nic_access(trans);
 				/* needed after consecutive writes w/o read */
 				mmiowb();
 				spin_unlock_irqrestore(&trans->reg_lock, flags);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 16a82b5..1d1f5d0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -394,6 +394,8 @@ struct iwl_trans;
  *	the op_mode. May be called several times before start_fw, can't be
  *	called after that.
  * @set_pmi: set the power pmi state
+ * @grab_nic_access: wake the NIC to be able to access non-HBUS regs
+ * @release_nic_access: let the NIC go to sleep
  */
 struct iwl_trans_ops {
 
@@ -431,6 +433,8 @@ struct iwl_trans_ops {
 	void (*configure)(struct iwl_trans *trans,
 			  const struct iwl_trans_config *trans_cfg);
 	void (*set_pmi)(struct iwl_trans *trans, bool state);
+	bool (*grab_nic_access)(struct iwl_trans *trans, bool silent);
+	void (*release_nic_access)(struct iwl_trans *trans);
 };
 
 /**
@@ -689,6 +693,17 @@ static inline void iwl_trans_set_pmi(struct iwl_trans *trans, bool state)
 	trans->ops->set_pmi(trans, state);
 }
 
+static inline bool iwl_trans_grab_nic_access(struct iwl_trans *trans,
+					     bool silent)
+{
+	return trans->ops->grab_nic_access(trans, silent);
+}
+
+static inline void iwl_trans_release_nic_access(struct iwl_trans *trans)
+{
+	trans->ops->release_nic_access(trans);
+}
+
 /*****************************************************
 * driver (transport) register/unregister functions
 ******************************************************/
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index e67e179..80b05d8 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -759,6 +759,68 @@ static int iwl_trans_pcie_resume(struct iwl_trans *trans)
 }
 #endif /* CONFIG_PM_SLEEP */
 
+static bool iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans, bool silent)
+{
+	int ret;
+
+	lockdep_assert_held(&trans->reg_lock);
+
+	/* this bit wakes up the NIC */
+	__iwl_set_bit(trans, CSR_GP_CNTRL,
+		      CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+
+	/*
+	 * These bits say the device is running, and should keep running for
+	 * at least a short while (at least as long as MAC_ACCESS_REQ stays 1),
+	 * but they do not indicate that embedded SRAM is restored yet;
+	 * 3945 and 4965 have volatile SRAM, and must save/restore contents
+	 * to/from host DRAM when sleeping/waking for power-saving.
+	 * Each direction takes approximately 1/4 millisecond; with this
+	 * overhead, it's a good idea to grab and hold MAC_ACCESS_REQUEST if a
+	 * series of register accesses are expected (e.g. reading Event Log),
+	 * to keep device from sleeping.
+	 *
+	 * CSR_UCODE_DRV_GP1 register bit MAC_SLEEP == 0 indicates that
+	 * SRAM is okay/restored.  We don't check that here because this call
+	 * is just for hardware register access; but GP1 MAC_SLEEP check is a
+	 * good idea before accessing 3945/4965 SRAM (e.g. reading Event Log).
+	 *
+	 * 5000 series and later (including 1000 series) have non-volatile SRAM,
+	 * and do not save/restore SRAM when power cycling.
+	 */
+	ret = iwl_poll_bit(trans, CSR_GP_CNTRL,
+			   CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN,
+			   (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
+			    CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 15000);
+	if (unlikely(ret < 0)) {
+		iwl_write32(trans, CSR_RESET, CSR_RESET_REG_FLAG_FORCE_NMI);
+		if (!silent) {
+			u32 val = iwl_read32(trans, CSR_GP_CNTRL);
+			WARN_ONCE(1,
+				  "Timeout waiting for hardware access (CSR_GP_CNTRL 0x%08x)\n",
+				  val);
+			return false;
+		}
+	}
+
+	return true;
+}
+
+static void iwl_trans_pcie_release_nic_access(struct iwl_trans *trans)
+{
+	lockdep_assert_held(&trans->reg_lock);
+	__iwl_clear_bit(trans, CSR_GP_CNTRL,
+			CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+	/*
+	 * Above we read the CSR_GP_CNTRL register, which will flush
+	 * any previous writes, but we need the write that clears the
+	 * MAC_ACCESS_REQ bit to be performed before any other writes
+	 * scheduled on different CPUs (after we drop reg_lock).
+	 */
+	mmiowb();
+}
+
+
 #define IWL_FLUSH_WAIT_MS	2000
 
 static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans)
@@ -1238,6 +1300,8 @@ static const struct iwl_trans_ops trans_ops_pcie = {
 	.write_prph = iwl_trans_pcie_write_prph,
 	.configure = iwl_trans_pcie_configure,
 	.set_pmi = iwl_trans_pcie_set_pmi,
+	.grab_nic_access = iwl_trans_pcie_grab_nic_access,
+	.release_nic_access = iwl_trans_pcie_release_nic_access
 };
 
 struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
-- 
1.8.0

