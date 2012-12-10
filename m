Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42218 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab2LJVs7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 16:48:59 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/10] iwlwifi: move prph handling into the transport
Date: Mon, 10 Dec 2012 22:49:13 +0100
Message-Id: <1355176158-24675-5-git-send-email-johannes@sipsolutions.net> (sfid-20121210_224911_829442_D49177CC)
In-Reply-To: <1355176158-24675-1-git-send-email-johannes@sipsolutions.net>
References: <1355176087.8083.17.camel@jlt4.sipsolutions.net>
 <1355176158-24675-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

New transports may handle it internally for better performance.
Also move the tracing inside PRPH access which will make the
output more readable:

iwlwifi_dev_ioread_prph32: Read 0x0 from SCD_AGGR_SEL (32-bit)

instead of the corresponding accesses to HBUS_TARG_PRPH_*.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-devtrace.h | 34 ++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-io.c       | 40 ++++++++++++++---------------
 drivers/net/wireless/iwlwifi/iwl-io.h       | 10 ++++----
 drivers/net/wireless/iwlwifi/iwl-trans.h    | 15 +++++++++++
 drivers/net/wireless/iwlwifi/pcie/trans.c   | 16 ++++++++++++
 5 files changed, 90 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
index b3fde5f..dc7e26b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
@@ -133,6 +133,40 @@ TRACE_EVENT(iwlwifi_dev_iowrite32,
 		  __get_str(dev), __entry->offs, __entry->val)
 );
 
+TRACE_EVENT(iwlwifi_dev_iowrite_prph32,
+	TP_PROTO(const struct device *dev, u32 offs, u32 val),
+	TP_ARGS(dev, offs, val),
+	TP_STRUCT__entry(
+		DEV_ENTRY
+		__field(u32, offs)
+		__field(u32, val)
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+		__entry->offs = offs;
+		__entry->val = val;
+	),
+	TP_printk("[%s] write PRPH[%#x] = %#x)",
+		  __get_str(dev), __entry->offs, __entry->val)
+);
+
+TRACE_EVENT(iwlwifi_dev_ioread_prph32,
+	TP_PROTO(const struct device *dev, u32 offs, u32 val),
+	TP_ARGS(dev, offs, val),
+	TP_STRUCT__entry(
+		DEV_ENTRY
+		__field(u32, offs)
+		__field(u32, val)
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+		__entry->offs = offs;
+		__entry->val = val;
+	),
+	TP_printk("[%s] read PRPH[%#x] = %#x",
+		  __get_str(dev), __entry->offs, __entry->val)
+);
+
 TRACE_EVENT(iwlwifi_dev_irq,
 	TP_PROTO(const struct device *dev),
 	TP_ARGS(dev),
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index 54c41b4..cdaff95 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -214,84 +214,84 @@ int iwl_poll_direct_bit(struct iwl_trans *trans, u32 addr, u32 mask,
 }
 EXPORT_SYMBOL_GPL(iwl_poll_direct_bit);
 
-static inline u32 __iwl_read_prph(struct iwl_trans *trans, u32 reg)
+static inline u32 __iwl_read_prph(struct iwl_trans *trans, u32 ofs)
 {
-	iwl_write32(trans, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
-	return iwl_read32(trans, HBUS_TARG_PRPH_RDAT);
+	u32 val = iwl_trans_read_prph(trans, ofs);
+	trace_iwlwifi_dev_ioread_prph32(trans->dev, ofs, val);
+	return val;
 }
 
-static inline void __iwl_write_prph(struct iwl_trans *trans, u32 addr, u32 val)
+static inline void __iwl_write_prph(struct iwl_trans *trans, u32 ofs, u32 val)
 {
-	iwl_write32(trans, HBUS_TARG_PRPH_WADDR,
-		    ((addr & 0x0000FFFF) | (3 << 24)));
-	iwl_write32(trans, HBUS_TARG_PRPH_WDAT, val);
+	trace_iwlwifi_dev_iowrite_prph32(trans->dev, ofs, val);
+	iwl_trans_write_prph(trans, ofs, val);
 }
 
-u32 iwl_read_prph(struct iwl_trans *trans, u32 reg)
+u32 iwl_read_prph(struct iwl_trans *trans, u32 ofs)
 {
 	unsigned long flags;
 	u32 val;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
 	iwl_grab_nic_access(trans);
-	val = __iwl_read_prph(trans, reg);
+	val = __iwl_read_prph(trans, ofs);
 	iwl_release_nic_access(trans);
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 	return val;
 }
 EXPORT_SYMBOL_GPL(iwl_read_prph);
 
-void iwl_write_prph(struct iwl_trans *trans, u32 addr, u32 val)
+void iwl_write_prph(struct iwl_trans *trans, u32 ofs, u32 val)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
 	if (likely(iwl_grab_nic_access(trans))) {
-		__iwl_write_prph(trans, addr, val);
+		__iwl_write_prph(trans, ofs, val);
 		iwl_release_nic_access(trans);
 	}
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
 EXPORT_SYMBOL_GPL(iwl_write_prph);
 
-void iwl_set_bits_prph(struct iwl_trans *trans, u32 reg, u32 mask)
+void iwl_set_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
 	if (likely(iwl_grab_nic_access(trans))) {
-		__iwl_write_prph(trans, reg,
-				 __iwl_read_prph(trans, reg) | mask);
+		__iwl_write_prph(trans, ofs,
+				 __iwl_read_prph(trans, ofs) | mask);
 		iwl_release_nic_access(trans);
 	}
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
 EXPORT_SYMBOL_GPL(iwl_set_bits_prph);
 
-void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 reg,
+void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 ofs,
 			    u32 bits, u32 mask)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
 	if (likely(iwl_grab_nic_access(trans))) {
-		__iwl_write_prph(trans, reg,
-				 (__iwl_read_prph(trans, reg) & mask) | bits);
+		__iwl_write_prph(trans, ofs,
+				 (__iwl_read_prph(trans, ofs) & mask) | bits);
 		iwl_release_nic_access(trans);
 	}
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
 EXPORT_SYMBOL_GPL(iwl_set_bits_mask_prph);
 
-void iwl_clear_bits_prph(struct iwl_trans *trans, u32 reg, u32 mask)
+void iwl_clear_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
 {
 	unsigned long flags;
 	u32 val;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
 	if (likely(iwl_grab_nic_access(trans))) {
-		val = __iwl_read_prph(trans, reg);
-		__iwl_write_prph(trans, reg, (val & ~mask));
+		val = __iwl_read_prph(trans, ofs);
+		__iwl_write_prph(trans, ofs, (val & ~mask));
 		iwl_release_nic_access(trans);
 	}
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index e1aa69f..48dc753 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -69,12 +69,12 @@ u32 iwl_read_direct32(struct iwl_trans *trans, u32 reg);
 void iwl_write_direct32(struct iwl_trans *trans, u32 reg, u32 value);
 
 
-u32 iwl_read_prph(struct iwl_trans *trans, u32 reg);
-void iwl_write_prph(struct iwl_trans *trans, u32 addr, u32 val);
-void iwl_set_bits_prph(struct iwl_trans *trans, u32 reg, u32 mask);
-void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 reg,
+u32 iwl_read_prph(struct iwl_trans *trans, u32 ofs);
+void iwl_write_prph(struct iwl_trans *trans, u32 ofs, u32 val);
+void iwl_set_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask);
+void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 ofs,
 			    u32 bits, u32 mask);
-void iwl_clear_bits_prph(struct iwl_trans *trans, u32 reg, u32 mask);
+void iwl_clear_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask);
 
 void _iwl_read_targ_mem_dwords(struct iwl_trans *trans, u32 addr,
 			       void *buf, int dwords);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 98072c2..b76532e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -385,6 +385,8 @@ struct iwl_trans;
  * @write8: write a u8 to a register at offset ofs from the BAR
  * @write32: write a u32 to a register at offset ofs from the BAR
  * @read32: read a u32 register at offset ofs from the BAR
+ * @read_prph: read a DWORD from a periphery register
+ * @write_prph: write a DWORD to a periphery register
  * @configure: configure parameters required by the transport layer from
  *	the op_mode. May be called several times before start_fw, can't be
  *	called after that.
@@ -420,6 +422,8 @@ struct iwl_trans_ops {
 	void (*write8)(struct iwl_trans *trans, u32 ofs, u8 val);
 	void (*write32)(struct iwl_trans *trans, u32 ofs, u32 val);
 	u32 (*read32)(struct iwl_trans *trans, u32 ofs);
+	u32 (*read_prph)(struct iwl_trans *trans, u32 ofs);
+	void (*write_prph)(struct iwl_trans *trans, u32 ofs, u32 val);
 	void (*configure)(struct iwl_trans *trans,
 			  const struct iwl_trans_config *trans_cfg);
 	void (*set_pmi)(struct iwl_trans *trans, bool state);
@@ -664,6 +668,17 @@ static inline u32 iwl_trans_read32(struct iwl_trans *trans, u32 ofs)
 	return trans->ops->read32(trans, ofs);
 }
 
+static inline u32 iwl_trans_read_prph(struct iwl_trans *trans, u32 ofs)
+{
+	return trans->ops->read_prph(trans, ofs);
+}
+
+static inline void iwl_trans_write_prph(struct iwl_trans *trans, u32 ofs,
+					u32 val)
+{
+	return trans->ops->write_prph(trans, ofs, val);
+}
+
 static inline void iwl_trans_set_pmi(struct iwl_trans *trans, bool state)
 {
 	trans->ops->set_pmi(trans, state);
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 9f317b0..09d2ed1 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -668,6 +668,20 @@ static u32 iwl_trans_pcie_read32(struct iwl_trans *trans, u32 ofs)
 	return readl(IWL_TRANS_GET_PCIE_TRANS(trans)->hw_base + ofs);
 }
 
+static u32 iwl_trans_pcie_read_prph(struct iwl_trans *trans, u32 reg)
+{
+	iwl_trans_pcie_write32(trans, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
+	return iwl_trans_pcie_read32(trans, HBUS_TARG_PRPH_RDAT);
+}
+
+static void iwl_trans_pcie_write_prph(struct iwl_trans *trans, u32 addr,
+				      u32 val)
+{
+	iwl_trans_pcie_write32(trans, HBUS_TARG_PRPH_WADDR,
+			       ((addr & 0x0000FFFF) | (3 << 24)));
+	iwl_trans_pcie_write32(trans, HBUS_TARG_PRPH_WDAT, val);
+}
+
 static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 				     const struct iwl_trans_config *trans_cfg)
 {
@@ -1223,6 +1237,8 @@ static const struct iwl_trans_ops trans_ops_pcie = {
 	.write8 = iwl_trans_pcie_write8,
 	.write32 = iwl_trans_pcie_write32,
 	.read32 = iwl_trans_pcie_read32,
+	.read_prph = iwl_trans_pcie_read_prph,
+	.write_prph = iwl_trans_pcie_write_prph,
 	.configure = iwl_trans_pcie_configure,
 	.set_pmi = iwl_trans_pcie_set_pmi,
 };
-- 
1.8.0

