Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48385 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab3ACOpy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 09:45:54 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/12] iwlwifi: virtualize SRAM access
Date: Thu,  3 Jan 2013 15:46:11 +0100
Message-Id: <1357224376-27803-7-git-send-email-johannes@sipsolutions.net> (sfid-20130103_154937_003454_DE875DB7)
In-Reply-To: <1357224376-27803-1-git-send-email-johannes@sipsolutions.net>
References: <1357224324.9741.20.camel@jlt4.sipsolutions.net>
 <1357224376-27803-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Different transports implement the access to the SRAM in
different ways. Virtualize it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/debugfs.c  |  4 +--
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |  2 +-
 drivers/net/wireless/iwlwifi/dvm/main.c     | 13 +++----
 drivers/net/wireless/iwlwifi/iwl-io.c       | 56 -----------------------------
 drivers/net/wireless/iwlwifi/iwl-io.h       | 15 --------
 drivers/net/wireless/iwlwifi/iwl-test.c     |  7 ++--
 drivers/net/wireless/iwlwifi/iwl-trans.h    | 43 +++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/pcie/trans.c   | 41 +++++++++++++++++++++
 drivers/net/wireless/iwlwifi/pcie/tx.c      | 26 +++++++-------
 9 files changed, 109 insertions(+), 98 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
index 5b9533e..72c74af 100644
--- a/drivers/net/wireless/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
@@ -157,7 +157,7 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 	sram = priv->dbgfs_sram_offset & ~0x3;
 
 	/* read the first u32 from sram */
-	val = iwl_read_targ_mem(priv->trans, sram);
+	val = iwl_trans_read_mem32(priv->trans, sram);
 
 	for (; len; len--) {
 		/* put the address at the start of every line */
@@ -176,7 +176,7 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 		if (++offset == 4) {
 			sram += 4;
 			offset = 0;
-			val = iwl_read_targ_mem(priv->trans, sram);
+			val = iwl_trans_read_mem32(priv->trans, sram);
 		}
 
 		/* put in extra spaces and split lines for human readability */
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 8965a98..9c1f055 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -479,7 +479,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 			}
 
 			if (priv->wowlan_sram)
-				_iwl_read_targ_mem_dwords(
+				iwl_trans_read_mem(
 				      priv->trans, 0x800000,
 				      priv->wowlan_sram,
 				      img->sec[IWL_UCODE_SECTION_DATA].len / 4);
diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index c4caedd..517d7ae 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -408,7 +408,8 @@ static void iwl_continuous_event_trace(struct iwl_priv *priv)
 
 	base = priv->device_pointers.log_event_table;
 	if (iwlagn_hw_valid_rtc_data_addr(base)) {
-		iwl_read_targ_mem_bytes(priv->trans, base, &read, sizeof(read));
+		iwl_trans_read_mem_bytes(priv->trans, base,
+					 &read, sizeof(read));
 		capacity = read.capacity;
 		mode = read.mode;
 		num_wraps = read.wrap_counter;
@@ -1627,7 +1628,7 @@ static void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	}
 
 	/*TODO: Update dbgfs with ISR error stats obtained below */
-	iwl_read_targ_mem_bytes(trans, base, &table, sizeof(table));
+	iwl_trans_read_mem_bytes(trans, base, &table, sizeof(table));
 
 	if (ERROR_START_OFFSET <= table.valid * ERROR_ELEM_SIZE) {
 		IWL_ERR(trans, "Start IWL Error Log Dump:\n");
@@ -1835,10 +1836,10 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 	}
 
 	/* event log header */
-	capacity = iwl_read_targ_mem(trans, base);
-	mode = iwl_read_targ_mem(trans, base + (1 * sizeof(u32)));
-	num_wraps = iwl_read_targ_mem(trans, base + (2 * sizeof(u32)));
-	next_entry = iwl_read_targ_mem(trans, base + (3 * sizeof(u32)));
+	capacity = iwl_trans_read_mem32(trans, base);
+	mode = iwl_trans_read_mem32(trans, base + (1 * sizeof(u32)));
+	num_wraps = iwl_trans_read_mem32(trans, base + (2 * sizeof(u32)));
+	next_entry = iwl_trans_read_mem32(trans, base + (3 * sizeof(u32)));
 
 	if (capacity > logsize) {
 		IWL_ERR(priv, "Log capacity %d is bogus, limit to %d "
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index cb36fed..2bd84ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -226,59 +226,3 @@ void iwl_clear_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
 EXPORT_SYMBOL_GPL(iwl_clear_bits_prph);
-
-void _iwl_read_targ_mem_dwords(struct iwl_trans *trans, u32 addr,
-			       void *buf, int dwords)
-{
-	unsigned long flags;
-	int offs;
-	u32 *vals = buf;
-
-	spin_lock_irqsave(&trans->reg_lock, flags);
-	if (likely(iwl_trans_grab_nic_access(trans, false))) {
-		iwl_write32(trans, HBUS_TARG_MEM_RADDR, addr);
-		for (offs = 0; offs < dwords; offs++)
-			vals[offs] = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
-		iwl_trans_release_nic_access(trans);
-	}
-	spin_unlock_irqrestore(&trans->reg_lock, flags);
-}
-EXPORT_SYMBOL_GPL(_iwl_read_targ_mem_dwords);
-
-u32 iwl_read_targ_mem(struct iwl_trans *trans, u32 addr)
-{
-	u32 value;
-
-	_iwl_read_targ_mem_dwords(trans, addr, &value, 1);
-
-	return value;
-}
-EXPORT_SYMBOL_GPL(iwl_read_targ_mem);
-
-int _iwl_write_targ_mem_dwords(struct iwl_trans *trans, u32 addr,
-			       const void *buf, int dwords)
-{
-	unsigned long flags;
-	int offs, result = 0;
-	const u32 *vals = buf;
-
-	spin_lock_irqsave(&trans->reg_lock, flags);
-	if (likely(iwl_trans_grab_nic_access(trans, false))) {
-		iwl_write32(trans, HBUS_TARG_MEM_WADDR, addr);
-		for (offs = 0; offs < dwords; offs++)
-			iwl_write32(trans, HBUS_TARG_MEM_WDAT, vals[offs]);
-		iwl_trans_release_nic_access(trans);
-	} else {
-		result = -EBUSY;
-	}
-	spin_unlock_irqrestore(&trans->reg_lock, flags);
-
-	return result;
-}
-EXPORT_SYMBOL_GPL(_iwl_write_targ_mem_dwords);
-
-int iwl_write_targ_mem(struct iwl_trans *trans, u32 addr, u32 val)
-{
-	return _iwl_write_targ_mem_dwords(trans, addr, &val, 1);
-}
-EXPORT_SYMBOL_GPL(iwl_write_targ_mem);
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 40eb0a1..dc47806 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -74,19 +74,4 @@ void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 ofs,
 			    u32 bits, u32 mask);
 void iwl_clear_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask);
 
-void _iwl_read_targ_mem_dwords(struct iwl_trans *trans, u32 addr,
-			       void *buf, int dwords);
-
-#define iwl_read_targ_mem_bytes(trans, addr, buf, bufsize)	\
-	do {							\
-		BUILD_BUG_ON((bufsize) % sizeof(u32));		\
-		_iwl_read_targ_mem_dwords(trans, addr, buf,	\
-					  (bufsize) / sizeof(u32));\
-	} while (0)
-
-int _iwl_write_targ_mem_dwords(struct iwl_trans *trans, u32 addr,
-			       const void *buf, int dwords);
-
-u32 iwl_read_targ_mem(struct iwl_trans *trans, u32 addr);
-int iwl_write_targ_mem(struct iwl_trans *trans, u32 addr, u32 val);
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-test.c b/drivers/net/wireless/iwlwifi/iwl-test.c
index 08c1cfe..f8d8df8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-test.c
+++ b/drivers/net/wireless/iwlwifi/iwl-test.c
@@ -476,9 +476,8 @@ static int iwl_test_indirect_read(struct iwl_test *tst, u32 addr, u32 size)
 			iwl_trans_release_nic_access(trans);
 			spin_unlock_irqrestore(&trans->reg_lock, flags);
 	} else { /* target memory (SRAM) */
-		_iwl_read_targ_mem_dwords(trans, addr,
-					  tst->mem.addr,
-					  tst->mem.size / 4);
+		iwl_trans_read_mem(trans, addr, tst->mem.addr,
+				   tst->mem.size / 4);
 	}
 
 	tst->mem.nchunks =
@@ -522,7 +521,7 @@ static int iwl_test_indirect_write(struct iwl_test *tst, u32 addr,
 						       *(u32 *)(buf+i));
 			}
 	} else if (iwl_test_valid_hw_addr(tst, addr)) {
-		_iwl_write_targ_mem_dwords(trans, addr, buf, size / 4);
+		iwl_trans_write_mem(trans, addr, buf, size / 4);
 	} else {
 		return -EINVAL;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 1d1f5d0..7584d55 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -390,6 +390,8 @@ struct iwl_trans;
  * @read32: read a u32 register at offset ofs from the BAR
  * @read_prph: read a DWORD from a periphery register
  * @write_prph: write a DWORD to a periphery register
+ * @read_mem: read device's SRAM in DWORD
+ * @write_mem: write device's SRAM in DWORD
  * @configure: configure parameters required by the transport layer from
  *	the op_mode. May be called several times before start_fw, can't be
  *	called after that.
@@ -430,6 +432,10 @@ struct iwl_trans_ops {
 	u32 (*read32)(struct iwl_trans *trans, u32 ofs);
 	u32 (*read_prph)(struct iwl_trans *trans, u32 ofs);
 	void (*write_prph)(struct iwl_trans *trans, u32 ofs, u32 val);
+	int (*read_mem)(struct iwl_trans *trans, u32 addr,
+			void *buf, int dwords);
+	int (*write_mem)(struct iwl_trans *trans, u32 addr,
+			 void *buf, int dwords);
 	void (*configure)(struct iwl_trans *trans,
 			  const struct iwl_trans_config *trans_cfg);
 	void (*set_pmi)(struct iwl_trans *trans, bool state);
@@ -645,7 +651,7 @@ static inline int iwl_trans_wait_tx_queue_empty(struct iwl_trans *trans)
 }
 
 static inline int iwl_trans_dbgfs_register(struct iwl_trans *trans,
-					    struct dentry *dir)
+					   struct dentry *dir)
 {
 	return trans->ops->dbgfs_register(trans, dir);
 }
@@ -688,6 +694,41 @@ static inline void iwl_trans_write_prph(struct iwl_trans *trans, u32 ofs,
 	return trans->ops->write_prph(trans, ofs, val);
 }
 
+static inline int iwl_trans_read_mem(struct iwl_trans *trans, u32 addr,
+				     void *buf, int dwords)
+{
+	return trans->ops->read_mem(trans, addr, buf, dwords);
+}
+
+#define iwl_trans_read_mem_bytes(trans, addr, buf, bufsize)		      \
+	do {								      \
+		if (__builtin_constant_p(bufsize))			      \
+			BUILD_BUG_ON((bufsize) % sizeof(u32));		      \
+		iwl_trans_read_mem(trans, addr, buf, (bufsize) / sizeof(u32));\
+	} while (0)
+
+static inline u32 iwl_trans_read_mem32(struct iwl_trans *trans, u32 addr)
+{
+	u32 value;
+
+	if (WARN_ON(iwl_trans_read_mem(trans, addr, &value, 1)))
+		return 0xa5a5a5a5;
+
+	return value;
+}
+
+static inline int iwl_trans_write_mem(struct iwl_trans *trans, u32 addr,
+				      void *buf, int dwords)
+{
+	return trans->ops->write_mem(trans, addr, buf, dwords);
+}
+
+static inline u32 iwl_trans_write_mem32(struct iwl_trans *trans, u32 addr,
+					u32 val)
+{
+	return iwl_trans_write_mem(trans, addr, &val, 1);
+}
+
 static inline void iwl_trans_set_pmi(struct iwl_trans *trans, bool state)
 {
 	trans->ops->set_pmi(trans, state);
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 80b05d8..3a40607 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -820,6 +820,45 @@ static void iwl_trans_pcie_release_nic_access(struct iwl_trans *trans)
 	mmiowb();
 }
 
+static int iwl_trans_pcie_read_mem(struct iwl_trans *trans, u32 addr,
+				   void *buf, int dwords)
+{
+	unsigned long flags;
+	int offs, ret = 0;
+	u32 *vals = buf;
+
+	spin_lock_irqsave(&trans->reg_lock, flags);
+	if (likely(iwl_trans_grab_nic_access(trans, false))) {
+		iwl_write32(trans, HBUS_TARG_MEM_RADDR, addr);
+		for (offs = 0; offs < dwords; offs++)
+			vals[offs] = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
+		iwl_trans_release_nic_access(trans);
+	} else {
+		ret = -EBUSY;
+	}
+	spin_unlock_irqrestore(&trans->reg_lock, flags);
+	return ret;
+}
+
+static int iwl_trans_pcie_write_mem(struct iwl_trans *trans, u32 addr,
+				    void *buf, int dwords)
+{
+	unsigned long flags;
+	int offs, ret = 0;
+	u32 *vals = buf;
+
+	spin_lock_irqsave(&trans->reg_lock, flags);
+	if (likely(iwl_trans_grab_nic_access(trans, false))) {
+		iwl_write32(trans, HBUS_TARG_MEM_WADDR, addr);
+		for (offs = 0; offs < dwords; offs++)
+			iwl_write32(trans, HBUS_TARG_MEM_WDAT, vals[offs]);
+		iwl_trans_release_nic_access(trans);
+	} else {
+		ret = -EBUSY;
+	}
+	spin_unlock_irqrestore(&trans->reg_lock, flags);
+	return ret;
+}
 
 #define IWL_FLUSH_WAIT_MS	2000
 
@@ -1298,6 +1337,8 @@ static const struct iwl_trans_ops trans_ops_pcie = {
 	.read32 = iwl_trans_pcie_read32,
 	.read_prph = iwl_trans_pcie_read_prph,
 	.write_prph = iwl_trans_pcie_write_prph,
+	.read_mem = iwl_trans_pcie_read_mem,
+	.write_mem = iwl_trans_pcie_write_mem,
 	.configure = iwl_trans_pcie_configure,
 	.set_pmi = iwl_trans_pcie_set_pmi,
 	.grab_nic_access = iwl_trans_pcie_grab_nic_access,
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 7af8f0b..d25fc8a 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -160,7 +160,7 @@ static void iwl_pcie_txq_stuck_timer(unsigned long data)
 	IWL_ERR(trans, "Current SW read_ptr %d write_ptr %d\n",
 		txq->q.read_ptr, txq->q.write_ptr);
 
-	iwl_read_targ_mem_bytes(trans, scd_sram_addr, buf, sizeof(buf));
+	iwl_trans_read_mem_bytes(trans, scd_sram_addr, buf, sizeof(buf));
 
 	iwl_print_hex_error(trans, buf, sizeof(buf));
 
@@ -173,9 +173,9 @@ static void iwl_pcie_txq_stuck_timer(unsigned long data)
 		u8 fifo = (status >> SCD_QUEUE_STTS_REG_POS_TXF) & 0x7;
 		bool active = !!(status & BIT(SCD_QUEUE_STTS_REG_POS_ACTIVE));
 		u32 tbl_dw =
-			iwl_read_targ_mem(trans,
-					  trans_pcie->scd_base_addr +
-					  SCD_TRANS_TBL_OFFSET_QUEUE(i));
+			iwl_trans_read_mem32(trans,
+					     trans_pcie->scd_base_addr +
+					     SCD_TRANS_TBL_OFFSET_QUEUE(i));
 
 		if (i & 0x1)
 			tbl_dw = (tbl_dw & 0xFFFF0000) >> 16;
@@ -659,16 +659,16 @@ void iwl_pcie_tx_start(struct iwl_trans *trans, u32 scd_base_addr)
 	/* reset conext data memory */
 	for (; a < trans_pcie->scd_base_addr + SCD_CONTEXT_MEM_UPPER_BOUND;
 		a += 4)
-		iwl_write_targ_mem(trans, a, 0);
+		iwl_trans_write_mem32(trans, a, 0);
 	/* reset tx status memory */
 	for (; a < trans_pcie->scd_base_addr + SCD_TX_STTS_MEM_UPPER_BOUND;
 		a += 4)
-		iwl_write_targ_mem(trans, a, 0);
+		iwl_trans_write_mem32(trans, a, 0);
 	for (; a < trans_pcie->scd_base_addr +
 	       SCD_TRANS_TBL_OFFSET_QUEUE(
 				trans->cfg->base_params->num_of_queues);
 	       a += 4)
-		iwl_write_targ_mem(trans, a, 0);
+		iwl_trans_write_mem32(trans, a, 0);
 
 	iwl_write_prph(trans, SCD_DRAM_BASE_ADDR,
 		       trans_pcie->scd_bc_tbls.dma >> 10);
@@ -1005,14 +1005,14 @@ static int iwl_pcie_txq_set_ratid_map(struct iwl_trans *trans, u16 ra_tid,
 	tbl_dw_addr = trans_pcie->scd_base_addr +
 			SCD_TRANS_TBL_OFFSET_QUEUE(txq_id);
 
-	tbl_dw = iwl_read_targ_mem(trans, tbl_dw_addr);
+	tbl_dw = iwl_trans_read_mem32(trans, tbl_dw_addr);
 
 	if (txq_id & 0x1)
 		tbl_dw = (scd_q2ratid << 16) | (tbl_dw & 0x0000FFFF);
 	else
 		tbl_dw = scd_q2ratid | (tbl_dw & 0xFFFF0000);
 
-	iwl_write_targ_mem(trans, tbl_dw_addr, tbl_dw);
+	iwl_trans_write_mem32(trans, tbl_dw_addr, tbl_dw);
 
 	return 0;
 }
@@ -1071,9 +1071,9 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, int fifo,
 	iwl_write_prph(trans, SCD_QUEUE_RDPTR(txq_id), ssn);
 
 	/* Set up Tx window size and frame limit for this queue */
-	iwl_write_targ_mem(trans, trans_pcie->scd_base_addr +
+	iwl_trans_write_mem32(trans, trans_pcie->scd_base_addr +
 			SCD_CONTEXT_QUEUE_OFFSET(txq_id), 0);
-	iwl_write_targ_mem(trans, trans_pcie->scd_base_addr +
+	iwl_trans_write_mem32(trans, trans_pcie->scd_base_addr +
 			SCD_CONTEXT_QUEUE_OFFSET(txq_id) + sizeof(u32),
 			((frame_limit << SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
 				SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
@@ -1104,8 +1104,8 @@ void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id)
 
 	iwl_pcie_txq_set_inactive(trans, txq_id);
 
-	_iwl_write_targ_mem_dwords(trans, stts_addr,
-				   zero_val, ARRAY_SIZE(zero_val));
+	iwl_trans_write_mem(trans, stts_addr, (void *)zero_val,
+			    ARRAY_SIZE(zero_val));
 
 	iwl_pcie_txq_unmap(trans, txq_id);
 
-- 
1.8.0

