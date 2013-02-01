Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58541 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab3BAK1R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2013 05:27:17 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Lilach Edelstein <lilach.edelstein@intel.com>
Subject: [PATCH 3/3] iwlwifi: move register access lock into transport
Date: Fri,  1 Feb 2013 11:27:36 +0100
Message-Id: <1359714456-15427-3-git-send-email-johannes@sipsolutions.net> (sfid-20130201_112722_213960_5FBF0756)
In-Reply-To: <1359714456-15427-1-git-send-email-johannes@sipsolutions.net>
References: <1359714456-15427-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lilach Edelstein <lilach.edelstein@intel.com>

Move the reg_lock that protects HW register access
into the transport implementation. Locking is no
longer exposed, but handled internally in grab and
release NIC access. This simplifies the users.

Signed-off-by: Lilach Edelstein <lilach.edelstein@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c  |  6 ++--
 drivers/net/wireless/iwlwifi/dvm/main.c      | 17 +++-------
 drivers/net/wireless/iwlwifi/dvm/tt.c        |  6 ++--
 drivers/net/wireless/iwlwifi/iwl-io.c        | 43 +++++++++----------------
 drivers/net/wireless/iwlwifi/iwl-test.c      | 17 +++-------
 drivers/net/wireless/iwlwifi/iwl-trans.h     | 23 ++++++++------
 drivers/net/wireless/iwlwifi/pcie/internal.h |  4 +++
 drivers/net/wireless/iwlwifi/pcie/trans.c    | 47 ++++++++++++++++++----------
 8 files changed, 75 insertions(+), 88 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index b551812..c2f03ec 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -459,14 +459,12 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 
 	base = priv->device_pointers.error_event_table;
 	if (iwlagn_hw_valid_rtc_data_addr(base)) {
-		spin_lock_irqsave(&priv->trans->reg_lock, flags);
-		if (iwl_trans_grab_nic_access(priv->trans, true)) {
+		if (iwl_trans_grab_nic_access(priv->trans, true, &flags)) {
 			iwl_write32(priv->trans, HBUS_TARG_MEM_RADDR, base);
 			status = iwl_read32(priv->trans, HBUS_TARG_MEM_RDAT);
-			iwl_trans_release_nic_access(priv->trans);
+			iwl_trans_release_nic_access(priv->trans, &flags);
 			ret = 0;
 		}
-		spin_unlock_irqrestore(&priv->trans->reg_lock, flags);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 		if (ret == 0) {
diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index f5f9164..b9e3517 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -353,11 +353,8 @@ static void iwl_print_cont_event_trace(struct iwl_priv *priv, u32 base,
 		ptr = base + (4 * sizeof(u32)) + (start_idx * 3 * sizeof(u32));
 
 	/* Make sure device is powered up for SRAM reads */
-	spin_lock_irqsave(&priv->trans->reg_lock, reg_flags);
-	if (!iwl_trans_grab_nic_access(priv->trans, false)) {
-		spin_unlock_irqrestore(&priv->trans->reg_lock, reg_flags);
+	if (!iwl_trans_grab_nic_access(priv->trans, false, &reg_flags))
 		return;
-	}
 
 	/* Set starting address; reads will auto-increment */
 	iwl_write32(priv->trans, HBUS_TARG_MEM_RADDR, ptr);
@@ -388,8 +385,7 @@ static void iwl_print_cont_event_trace(struct iwl_priv *priv, u32 base,
 		}
 	}
 	/* Allow device to power down */
-	iwl_trans_release_nic_access(priv->trans);
-	spin_unlock_irqrestore(&priv->trans->reg_lock, reg_flags);
+	iwl_trans_release_nic_access(priv->trans, &reg_flags);
 }
 
 static void iwl_continuous_event_trace(struct iwl_priv *priv)
@@ -1717,9 +1713,8 @@ static int iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 	ptr = base + EVENT_START_OFFSET + (start_idx * event_size);
 
 	/* Make sure device is powered up for SRAM reads */
-	spin_lock_irqsave(&trans->reg_lock, reg_flags);
-	if (!iwl_trans_grab_nic_access(trans, false))
-		goto out_unlock;
+	if (!iwl_trans_grab_nic_access(trans, false, &reg_flags))
+		return pos;
 
 	/* Set starting address; reads will auto-increment */
 	iwl_write32(trans, HBUS_TARG_MEM_RADDR, ptr);
@@ -1757,9 +1752,7 @@ static int iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 	}
 
 	/* Allow device to power down */
-	iwl_trans_release_nic_access(trans);
-out_unlock:
-	spin_unlock_irqrestore(&trans->reg_lock, reg_flags);
+	iwl_trans_release_nic_access(trans, &reg_flags);
 	return pos;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/tt.c b/drivers/net/wireless/iwlwifi/dvm/tt.c
index 617fca3..67e2e13 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tt.c
@@ -185,10 +185,8 @@ static void iwl_tt_check_exit_ct_kill(unsigned long data)
 			priv->thermal_throttle.ct_kill_toggle = true;
 		}
 		iwl_read32(priv->trans, CSR_UCODE_DRV_GP1);
-		spin_lock_irqsave(&priv->trans->reg_lock, flags);
-		if (iwl_trans_grab_nic_access(priv->trans, false))
-			iwl_trans_release_nic_access(priv->trans);
-		spin_unlock_irqrestore(&priv->trans->reg_lock, flags);
+		if (iwl_trans_grab_nic_access(priv->trans, false, &flags))
+			iwl_trans_release_nic_access(priv->trans, &flags);
 
 		/* Reschedule the ct_kill timer to occur in
 		 * CT_KILL_EXIT_DURATION seconds to ensure we get a
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index 7ef4738..276410d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -55,13 +55,10 @@ u32 iwl_read_direct32(struct iwl_trans *trans, u32 reg)
 {
 	u32 value = 0x5a5a5a5a;
 	unsigned long flags;
-
-	spin_lock_irqsave(&trans->reg_lock, flags);
-	if (iwl_trans_grab_nic_access(trans, false)) {
+	if (iwl_trans_grab_nic_access(trans, false, &flags)) {
 		value = iwl_read32(trans, reg);
-		iwl_trans_release_nic_access(trans);
+		iwl_trans_release_nic_access(trans, &flags);
 	}
-	spin_unlock_irqrestore(&trans->reg_lock, flags);
 
 	return value;
 }
@@ -71,12 +68,10 @@ void iwl_write_direct32(struct iwl_trans *trans, u32 reg, u32 value)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&trans->reg_lock, flags);
-	if (iwl_trans_grab_nic_access(trans, false)) {
+	if (iwl_trans_grab_nic_access(trans, false, &flags)) {
 		iwl_write32(trans, reg, value);
-		iwl_trans_release_nic_access(trans);
+		iwl_trans_release_nic_access(trans, &flags);
 	}
-	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
 EXPORT_SYMBOL_GPL(iwl_write_direct32);
 
@@ -114,12 +109,10 @@ u32 iwl_read_prph(struct iwl_trans *trans, u32 ofs)
 	unsigned long flags;
 	u32 val = 0x5a5a5a5a;
 
-	spin_lock_irqsave(&trans->reg_lock, flags);
-	if (iwl_trans_grab_nic_access(trans, false)) {
+	if (iwl_trans_grab_nic_access(trans, false, &flags)) {
 		val = __iwl_read_prph(trans, ofs);
-		iwl_trans_release_nic_access(trans);
+		iwl_trans_release_nic_access(trans, &flags);
 	}
-	spin_unlock_irqrestore(&trans->reg_lock, flags);
 	return val;
 }
 EXPORT_SYMBOL_GPL(iwl_read_prph);
@@ -128,12 +121,10 @@ void iwl_write_prph(struct iwl_trans *trans, u32 ofs, u32 val)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&trans->reg_lock, flags);
-	if (iwl_trans_grab_nic_access(trans, false)) {
+	if (iwl_trans_grab_nic_access(trans, false, &flags)) {
 		__iwl_write_prph(trans, ofs, val);
-		iwl_trans_release_nic_access(trans);
+		iwl_trans_release_nic_access(trans, &flags);
 	}
-	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
 EXPORT_SYMBOL_GPL(iwl_write_prph);
 
@@ -141,13 +132,11 @@ void iwl_set_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&trans->reg_lock, flags);
-	if (iwl_trans_grab_nic_access(trans, false)) {
+	if (iwl_trans_grab_nic_access(trans, false, &flags)) {
 		__iwl_write_prph(trans, ofs,
 				 __iwl_read_prph(trans, ofs) | mask);
-		iwl_trans_release_nic_access(trans);
+		iwl_trans_release_nic_access(trans, &flags);
 	}
-	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
 EXPORT_SYMBOL_GPL(iwl_set_bits_prph);
 
@@ -156,13 +145,11 @@ void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 ofs,
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&trans->reg_lock, flags);
-	if (iwl_trans_grab_nic_access(trans, false)) {
+	if (iwl_trans_grab_nic_access(trans, false, &flags)) {
 		__iwl_write_prph(trans, ofs,
 				 (__iwl_read_prph(trans, ofs) & mask) | bits);
-		iwl_trans_release_nic_access(trans);
+		iwl_trans_release_nic_access(trans, &flags);
 	}
-	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
 EXPORT_SYMBOL_GPL(iwl_set_bits_mask_prph);
 
@@ -171,12 +158,10 @@ void iwl_clear_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
 	unsigned long flags;
 	u32 val;
 
-	spin_lock_irqsave(&trans->reg_lock, flags);
-	if (iwl_trans_grab_nic_access(trans, false)) {
+	if (iwl_trans_grab_nic_access(trans, false, &flags)) {
 		val = __iwl_read_prph(trans, ofs);
 		__iwl_write_prph(trans, ofs, (val & ~mask));
-		iwl_trans_release_nic_access(trans);
+		iwl_trans_release_nic_access(trans, &flags);
 	}
-	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
 EXPORT_SYMBOL_GPL(iwl_clear_bits_prph);
diff --git a/drivers/net/wireless/iwlwifi/iwl-test.c b/drivers/net/wireless/iwlwifi/iwl-test.c
index d06fc55..ce0c67b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-test.c
+++ b/drivers/net/wireless/iwlwifi/iwl-test.c
@@ -466,9 +466,7 @@ static int iwl_test_indirect_read(struct iwl_test *tst, u32 addr, u32 size)
 	/* Hard-coded periphery absolute address */
 	if (IWL_ABS_PRPH_START <= addr &&
 	    addr < IWL_ABS_PRPH_START + PRPH_END) {
-			spin_lock_irqsave(&trans->reg_lock, flags);
-			if (!iwl_trans_grab_nic_access(trans, false)) {
-				spin_unlock_irqrestore(&trans->reg_lock, flags);
+			if (!iwl_trans_grab_nic_access(trans, false, &flags)) {
 				return -EIO;
 			}
 			iwl_write32(trans, HBUS_TARG_PRPH_RADDR,
@@ -476,8 +474,7 @@ static int iwl_test_indirect_read(struct iwl_test *tst, u32 addr, u32 size)
 			for (i = 0; i < size; i += 4)
 				*(u32 *)(tst->mem.addr + i) =
 					iwl_read32(trans, HBUS_TARG_PRPH_RDAT);
-			iwl_trans_release_nic_access(trans);
-			spin_unlock_irqrestore(&trans->reg_lock, flags);
+			iwl_trans_release_nic_access(trans, &flags);
 	} else { /* target memory (SRAM) */
 		iwl_trans_read_mem(trans, addr, tst->mem.addr,
 				   tst->mem.size / 4);
@@ -506,19 +503,13 @@ static int iwl_test_indirect_write(struct iwl_test *tst, u32 addr,
 		/* Periphery writes can be 1-3 bytes long, or DWORDs */
 		if (size < 4) {
 			memcpy(&val, buf, size);
-			spin_lock_irqsave(&trans->reg_lock, flags);
-			if (!iwl_trans_grab_nic_access(trans, false)) {
-				spin_unlock_irqrestore(&trans->reg_lock, flags);
+			if (!iwl_trans_grab_nic_access(trans, false, &flags))
 					return -EIO;
-			}
 			iwl_write32(trans, HBUS_TARG_PRPH_WADDR,
 				    (addr & 0x0000FFFF) |
 				    ((size - 1) << 24));
 			iwl_write32(trans, HBUS_TARG_PRPH_WDAT, val);
-			iwl_trans_release_nic_access(trans);
-			/* needed after consecutive writes w/o read */
-			mmiowb();
-			spin_unlock_irqrestore(&trans->reg_lock, flags);
+			iwl_trans_release_nic_access(trans, &flags);
 		} else {
 			if (size % 4)
 				return -EINVAL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index c2b7e85..0a3d4df 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -416,8 +416,11 @@ struct iwl_trans;
  *	the op_mode. May be called several times before start_fw, can't be
  *	called after that.
  * @set_pmi: set the power pmi state
- * @grab_nic_access: wake the NIC to be able to access non-HBUS regs
- * @release_nic_access: let the NIC go to sleep
+ * @grab_nic_access: wake the NIC to be able to access non-HBUS regs.
+ *	Sleeping is not allowed between grab_nic_access and
+ *	release_nic_access.
+ * @release_nic_access: let the NIC go to sleep. The "flags" parameter
+ *	must be the same one that was sent before to the grab_nic_access.
  * @set_bits_mask - set SRAM register according to value and mask.
  */
 struct iwl_trans_ops {
@@ -461,8 +464,10 @@ struct iwl_trans_ops {
 	void (*configure)(struct iwl_trans *trans,
 			  const struct iwl_trans_config *trans_cfg);
 	void (*set_pmi)(struct iwl_trans *trans, bool state);
-	bool (*grab_nic_access)(struct iwl_trans *trans, bool silent);
-	void (*release_nic_access)(struct iwl_trans *trans);
+	bool (*grab_nic_access)(struct iwl_trans *trans, bool silent,
+				unsigned long *flags);
+	void (*release_nic_access)(struct iwl_trans *trans,
+				   unsigned long *flags);
 	void (*set_bits_mask)(struct iwl_trans *trans, u32 reg, u32 mask,
 			      u32 value);
 };
@@ -484,7 +489,6 @@ enum iwl_trans_state {
  * @ops - pointer to iwl_trans_ops
  * @op_mode - pointer to the op_mode
  * @cfg - pointer to the configuration
- * @reg_lock - protect hw register access
  * @dev - pointer to struct device * that represents the device
  * @hw_id: a u32 with the ID of the device / subdevice.
  *	Set during transport allocation.
@@ -505,7 +509,6 @@ struct iwl_trans {
 	struct iwl_op_mode *op_mode;
 	const struct iwl_cfg *cfg;
 	enum iwl_trans_state state;
-	spinlock_t reg_lock;
 
 	struct device *dev;
 	u32 hw_rev;
@@ -771,14 +774,14 @@ iwl_trans_set_bits_mask(struct iwl_trans *trans, u32 reg, u32 mask, u32 value)
 	trans->ops->set_bits_mask(trans, reg, mask, value);
 }
 
-#define iwl_trans_grab_nic_access(trans, silent)	\
+#define iwl_trans_grab_nic_access(trans, silent, flags)	\
 	__cond_lock(nic_access,				\
-		    likely((trans)->ops->grab_nic_access(trans, silent)))
+		    likely((trans)->ops->grab_nic_access(trans, silent, flags)))
 
 static inline void __releases(nic_access)
-iwl_trans_release_nic_access(struct iwl_trans *trans)
+iwl_trans_release_nic_access(struct iwl_trans *trans, unsigned long *flags)
 {
-	trans->ops->release_nic_access(trans);
+	trans->ops->release_nic_access(trans, flags);
 	__release(nic_access);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 21395fa..5f6bb4e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -235,6 +235,7 @@ struct iwl_txq {
  * @bc_table_dword: true if the BC table expects DWORD (as opposed to bytes)
  * @rx_page_order: page order for receive buffer size
  * @wd_timeout: queue watchdog timeout (jiffies)
+ * @reg_lock: protect hw register access
  */
 struct iwl_trans_pcie {
 	struct iwl_rxq rxq;
@@ -283,6 +284,9 @@ struct iwl_trans_pcie {
 
 	/* queue watchdog */
 	unsigned long wd_timeout;
+
+	/*protect hw register */
+	spinlock_t reg_lock;
 };
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 8692494..56d4f72 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -806,11 +806,12 @@ static int iwl_trans_pcie_resume(struct iwl_trans *trans)
 }
 #endif /* CONFIG_PM_SLEEP */
 
-static bool iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans, bool silent)
+static bool iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans, bool silent,
+						unsigned long *flags)
 {
 	int ret;
-
-	lockdep_assert_held(&trans->reg_lock);
+	struct iwl_trans_pcie *pcie_trans = IWL_TRANS_GET_PCIE_TRANS(trans);
+	spin_lock_irqsave(&pcie_trans->reg_lock, *flags);
 
 	/* this bit wakes up the NIC */
 	__iwl_trans_pcie_set_bit(trans, CSR_GP_CNTRL,
@@ -846,16 +847,32 @@ static bool iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans, bool silent)
 			WARN_ONCE(1,
 				  "Timeout waiting for hardware access (CSR_GP_CNTRL 0x%08x)\n",
 				  val);
+			spin_unlock_irqrestore(&pcie_trans->reg_lock, *flags);
 			return false;
 		}
 	}
 
+	/*
+	 * Fool sparse by faking we release the lock - sparse will
+	 * track nic_access anyway.
+	 */
+	__release(&pcie_trans->reg_lock);
 	return true;
 }
 
-static void iwl_trans_pcie_release_nic_access(struct iwl_trans *trans)
+static void iwl_trans_pcie_release_nic_access(struct iwl_trans *trans,
+					      unsigned long *flags)
 {
-	lockdep_assert_held(&trans->reg_lock);
+	struct iwl_trans_pcie *pcie_trans = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	lockdep_assert_held(&pcie_trans->reg_lock);
+
+	/*
+	 * Fool sparse by faking we acquiring the lock - sparse will
+	 * track nic_access anyway.
+	 */
+	__acquire(&pcie_trans->reg_lock);
+
 	__iwl_trans_pcie_clear_bit(trans, CSR_GP_CNTRL,
 				   CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 	/*
@@ -865,6 +882,7 @@ static void iwl_trans_pcie_release_nic_access(struct iwl_trans *trans)
 	 * scheduled on different CPUs (after we drop reg_lock).
 	 */
 	mmiowb();
+	spin_unlock_irqrestore(&pcie_trans->reg_lock, *flags);
 }
 
 static int iwl_trans_pcie_read_mem(struct iwl_trans *trans, u32 addr,
@@ -874,16 +892,14 @@ static int iwl_trans_pcie_read_mem(struct iwl_trans *trans, u32 addr,
 	int offs, ret = 0;
 	u32 *vals = buf;
 
-	spin_lock_irqsave(&trans->reg_lock, flags);
-	if (iwl_trans_grab_nic_access(trans, false)) {
+	if (iwl_trans_grab_nic_access(trans, false, &flags)) {
 		iwl_write32(trans, HBUS_TARG_MEM_RADDR, addr);
 		for (offs = 0; offs < dwords; offs++)
 			vals[offs] = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
-		iwl_trans_release_nic_access(trans);
+		iwl_trans_release_nic_access(trans, &flags);
 	} else {
 		ret = -EBUSY;
 	}
-	spin_unlock_irqrestore(&trans->reg_lock, flags);
 	return ret;
 }
 
@@ -894,17 +910,15 @@ static int iwl_trans_pcie_write_mem(struct iwl_trans *trans, u32 addr,
 	int offs, ret = 0;
 	u32 *vals = buf;
 
-	spin_lock_irqsave(&trans->reg_lock, flags);
-	if (iwl_trans_grab_nic_access(trans, false)) {
+	if (iwl_trans_grab_nic_access(trans, false, &flags)) {
 		iwl_write32(trans, HBUS_TARG_MEM_WADDR, addr);
 		for (offs = 0; offs < dwords; offs++)
 			iwl_write32(trans, HBUS_TARG_MEM_WDAT,
 				    vals ? vals[offs] : 0);
-		iwl_trans_release_nic_access(trans);
+		iwl_trans_release_nic_access(trans, &flags);
 	} else {
 		ret = -EBUSY;
 	}
-	spin_unlock_irqrestore(&trans->reg_lock, flags);
 	return ret;
 }
 
@@ -982,11 +996,12 @@ static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans)
 static void iwl_trans_pcie_set_bits_mask(struct iwl_trans *trans, u32 reg,
 					 u32 mask, u32 value)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	unsigned long flags;
 
-	spin_lock_irqsave(&trans->reg_lock, flags);
+	spin_lock_irqsave(&trans_pcie->reg_lock, flags);
 	__iwl_trans_pcie_set_bits_mask(trans, reg, mask, value);
-	spin_unlock_irqrestore(&trans->reg_lock, flags);
+	spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);
 }
 
 static const char *get_fh_string(int cmd)
@@ -1467,6 +1482,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	trans->cfg = cfg;
 	trans_pcie->trans = trans;
 	spin_lock_init(&trans_pcie->irq_lock);
+	spin_lock_init(&trans_pcie->reg_lock);
 	init_waitqueue_head(&trans_pcie->ucode_write_waitq);
 
 	/* W/A - seems to solve weird behavior. We need to remove this if we
@@ -1533,7 +1549,6 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 
 	/* Initialize the wait queue for commands */
 	init_waitqueue_head(&trans_pcie->wait_command_queue);
-	spin_lock_init(&trans->reg_lock);
 
 	snprintf(trans->dev_cmd_pool_name, sizeof(trans->dev_cmd_pool_name),
 		 "iwl_cmd_pool:%s", dev_name(trans->dev));
-- 
1.8.0

