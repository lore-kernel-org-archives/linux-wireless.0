Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:7737 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751483AbYJXGsn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 02:48:43 -0400
From: Reinette Chatre <reinette.chatre@linux.intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/10] iwlwifi: refactor tx byte count table usage
Date: Thu, 23 Oct 2008 23:48:55 -0700
Message-Id: <1224830938-1577-8-git-send-email-reinette.chatre@linux.intel.com> (sfid-20081024_084856_478177_56DA23D8)
In-Reply-To: <1224830938-1577-7-git-send-email-reinette.chatre@linux.intel.com>
References: <>
 <1224830938-1577-1-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-2-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-3-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-4-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-5-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-6-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-7-git-send-email-reinette.chatre@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch drops unreadable usage of IWL_SET/GET_BITS16 in byte count
tables handling
This patch also cleans a bit the byte count table code and adds
WARN_ON traps on invalid values

This patch is pure cleanup, no functional changes.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h |   38 ++---------
 drivers/net/wireless/iwlwifi/iwl-4965.c    |   21 +++---
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h |   29 ++++----
 drivers/net/wireless/iwlwifi/iwl-5000.c    |   52 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-fh.h      |    5 ++
 drivers/net/wireless/iwlwifi/iwl-helpers.h |  102 ----------------------------
 6 files changed, 62 insertions(+), 185 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index b66dd09..f3f41a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -111,7 +111,6 @@
 #define PCI_CFG_CMD_REG_INT_DIS_MSK	0x04
 #define PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT         (0x80000000)
 
-#define TFD_QUEUE_SIZE_MAX      (256)
 
 #define IWL_NUM_SCAN_RATES         (2)
 
@@ -815,8 +814,6 @@ enum {
  * up to 7 DMA channels (FIFOs).  Each Tx queue is supported by a circular array
  * in DRAM containing 256 Transmit Frame Descriptors (TFDs).
  */
-#define IWL49_MAX_WIN_SIZE	64
-#define IWL49_QUEUE_SIZE	256
 #define IWL49_NUM_FIFOS 	7
 #define IWL49_CMD_FIFO_NUM	4
 #define IWL49_NUM_QUEUES	16
@@ -882,26 +879,7 @@ struct iwl_tfd {
 
 
 /**
- * struct iwl4965_queue_byte_cnt_entry
- *
- * Byte Count Table Entry
- *
- * Bit fields:
- * 15-12: reserved
- * 11- 0: total to-be-transmitted byte count of frame (does not include command)
- */
-struct iwl4965_queue_byte_cnt_entry {
-	__le16 val;
-	/* __le16 byte_cnt:12; */
-#define IWL_byte_cnt_POS 0
-#define IWL_byte_cnt_LEN 12
-#define IWL_byte_cnt_SYM val
-	/* __le16 rsvd:4; */
-} __attribute__ ((packed));
-
-
-/**
- * struct iwl4965_sched_queue_byte_cnt_tbl
+ * struct iwl4965_schedq_bc_tbl
  *
  * Byte Count table
  *
@@ -915,15 +893,12 @@ struct iwl4965_queue_byte_cnt_entry {
  * count table for the chosen Tx queue.  If the TFD index is 0-63, the driver
  * must duplicate the byte count entry in corresponding index 256-319.
  *
- * "dont_care" padding puts each byte count table on a 1024-byte boundary;
+ * padding puts each byte count table on a 1024-byte boundary;
  * 4965 assumes tables are separated by 1024 bytes.
  */
-struct iwl4965_sched_queue_byte_cnt_tbl {
-	struct iwl4965_queue_byte_cnt_entry tfd_offset[IWL49_QUEUE_SIZE +
-						       IWL49_MAX_WIN_SIZE];
-	u8 dont_care[1024 -
-		     (IWL49_QUEUE_SIZE + IWL49_MAX_WIN_SIZE) *
-		     sizeof(__le16)];
+struct iwl4965_schedq_bc_tbl {
+	__le16 tfd_offset[TFD_QUEUE_BC_SIZE];
+	u8 pad[1024 - (TFD_QUEUE_BC_SIZE) * sizeof(__le16)];
 } __attribute__ ((packed));
 
 
@@ -951,8 +926,7 @@ struct iwl4965_sched_queue_byte_cnt_tbl {
  * 31- 0:  Not used
  */
 struct iwl4965_shared {
-	struct iwl4965_sched_queue_byte_cnt_tbl
-	 queues_byte_cnt_tbls[IWL49_NUM_QUEUES];
+	struct iwl4965_schedq_bc_tbl queues_bc_tbls[IWL49_NUM_QUEUES];
 	__le32 rb_closed;
 
 	/* __le32 rb_closed_stts_rb_num:12; */
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index aad32a3..1f22140 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -716,7 +716,7 @@ static int iwl4965_alive_notify(struct iwl_priv *priv)
 	/* Tel 4965 where to find Tx byte count tables */
 	iwl_write_prph(priv, IWL49_SCD_DRAM_BASE_ADDR,
 		(priv->shared_phys +
-		 offsetof(struct iwl4965_shared, queues_byte_cnt_tbls)) >> 10);
+		 offsetof(struct iwl4965_shared, queues_bc_tbls)) >> 10);
 
 	/* Disable chain mode for all queues */
 	iwl_write_prph(priv, IWL49_SCD_QUEUECHAIN_SEL, 0);
@@ -1668,21 +1668,22 @@ static void iwl4965_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 					    struct iwl_tx_queue *txq,
 					    u16 byte_cnt)
 {
-	int len;
-	int txq_id = txq->q.id;
 	struct iwl4965_shared *shared_data = priv->shared_virt;
+	int txq_id = txq->q.id;
+	int write_ptr = txq->q.write_ptr;
+	int len = byte_cnt + IWL_TX_CRC_SIZE + IWL_TX_DELIMITER_SIZE;
+	__le16 bc_ent;
 
-	len = byte_cnt + IWL_TX_CRC_SIZE + IWL_TX_DELIMITER_SIZE;
+	WARN_ON(len > 0xFFF || write_ptr >= TFD_QUEUE_SIZE_MAX);
 
+	bc_ent = cpu_to_le16(len & 0xFFF);
 	/* Set up byte count within first 256 entries */
-	IWL_SET_BITS16(shared_data->queues_byte_cnt_tbls[txq_id].
-		       tfd_offset[txq->q.write_ptr], byte_cnt, len);
+	shared_data->queues_bc_tbls[txq_id].tfd_offset[write_ptr] = bc_ent;
 
 	/* If within first 64 entries, duplicate at end */
-	if (txq->q.write_ptr < IWL49_MAX_WIN_SIZE)
-		IWL_SET_BITS16(shared_data->queues_byte_cnt_tbls[txq_id].
-			tfd_offset[IWL49_QUEUE_SIZE + txq->q.write_ptr],
-			byte_cnt, len);
+	if (write_ptr < TFD_QUEUE_SIZE_BC_DUP)
+		shared_data->queues_bc_tbls[txq_id].
+			tfd_offset[TFD_QUEUE_SIZE_MAX + write_ptr] = bc_ent;
 }
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
index fa06443..49ede54 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
@@ -76,30 +76,31 @@
 /* EERPROM */
 #define IWL_5000_EEPROM_IMG_SIZE			2048
 
-
-#define IWL50_MAX_WIN_SIZE                64
-#define IWL50_QUEUE_SIZE                 256
 #define IWL50_CMD_FIFO_NUM                 7
 #define IWL50_NUM_QUEUES                  20
 #define IWL50_NUM_AMPDU_QUEUES		  10
 #define IWL50_FIRST_AMPDU_QUEUE		  10
 
-#define IWL_sta_id_POS 12
-#define IWL_sta_id_LEN 4
-#define IWL_sta_id_SYM val
-
 /* Fixed (non-configurable) rx data from phy */
 
-/* Base physical address of iwl5000_shared is provided to SCD_DRAM_BASE_ADDR
- * and &iwl5000_shared.val0 is provided to FH_RSCSR_CHNL0_STTS_WPTR_REG */
-struct iwl5000_sched_queue_byte_cnt_tbl {
-	struct iwl4965_queue_byte_cnt_entry tfd_offset[IWL50_QUEUE_SIZE +
-						       IWL50_MAX_WIN_SIZE];
+/**
+ * struct iwl5000_schedq_bc_tbl scheduler byte count table
+ * 	base physical address of iwl5000_shared
+ * 	is provided to SCD_DRAM_BASE_ADDR
+ * @tfd_offset  0-12 - tx command byte count
+ *	       12-16 - station index
+ */
+struct iwl5000_schedq_bc_tbl {
+	__le16 tfd_offset[TFD_QUEUE_BC_SIZE];
 } __attribute__ ((packed));
 
+/**
+ * struct iwl5000_shared
+ * @rb_closed
+ * 	address is provided to FH_RSCSR_CHNL0_STTS_WPTR_REG
+ */
 struct iwl5000_shared {
-	struct iwl5000_sched_queue_byte_cnt_tbl
-	 queues_byte_cnt_tbls[IWL50_NUM_QUEUES];
+	struct iwl5000_schedq_bc_tbl queues_bc_tbls[IWL50_NUM_QUEUES];
 	__le32 rb_closed;
 
 	/* __le32 rb_closed_stts_rb_num:12; */
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 8952733..16d1773 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -723,7 +723,7 @@ static int iwl5000_alive_notify(struct iwl_priv *priv)
 
 	iwl_write_prph(priv, IWL50_SCD_DRAM_BASE_ADDR,
 		(priv->shared_phys +
-		 offsetof(struct iwl5000_shared, queues_byte_cnt_tbls)) >> 10);
+		 offsetof(struct iwl5000_shared, queues_bc_tbls)) >> 10);
 	iwl_write_prph(priv, IWL50_SCD_QUEUECHAIN_SEL,
 		IWL50_SCD_QUEUECHAIN_SEL_ALL(
 			priv->hw_params.max_txq_num));
@@ -891,15 +891,17 @@ static void iwl5000_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 					    u16 byte_cnt)
 {
 	struct iwl5000_shared *shared_data = priv->shared_virt;
+	int write_ptr = txq->q.write_ptr;
 	int txq_id = txq->q.id;
 	u8 sec_ctl = 0;
-	u8 sta = 0;
-	int len;
+	u8 sta_id = 0;
+	u16 len = byte_cnt + IWL_TX_CRC_SIZE + IWL_TX_DELIMITER_SIZE;
+	__le16 bc_ent;
 
-	len = byte_cnt + IWL_TX_CRC_SIZE + IWL_TX_DELIMITER_SIZE;
+	WARN_ON(len > 0xFFF || write_ptr >= TFD_QUEUE_SIZE_MAX);
 
 	if (txq_id != IWL_CMD_QUEUE_NUM) {
-		sta = txq->cmd[txq->q.write_ptr]->cmd.tx.sta_id;
+		sta_id = txq->cmd[txq->q.write_ptr]->cmd.tx.sta_id;
 		sec_ctl = txq->cmd[txq->q.write_ptr]->cmd.tx.sec_ctl;
 
 		switch (sec_ctl & TX_CMD_SEC_MSK) {
@@ -915,40 +917,36 @@ static void iwl5000_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 		}
 	}
 
-	IWL_SET_BITS16(shared_data->queues_byte_cnt_tbls[txq_id].
-		       tfd_offset[txq->q.write_ptr], byte_cnt, len);
+	bc_ent = cpu_to_le16((len & 0xFFF) | (sta_id << 12));
 
-	IWL_SET_BITS16(shared_data->queues_byte_cnt_tbls[txq_id].
-		       tfd_offset[txq->q.write_ptr], sta_id, sta);
+	shared_data->queues_bc_tbls[txq_id].tfd_offset[write_ptr] = bc_ent;
 
-	if (txq->q.write_ptr < IWL50_MAX_WIN_SIZE) {
-		IWL_SET_BITS16(shared_data->queues_byte_cnt_tbls[txq_id].
-			tfd_offset[IWL50_QUEUE_SIZE + txq->q.write_ptr],
-			byte_cnt, len);
-		IWL_SET_BITS16(shared_data->queues_byte_cnt_tbls[txq_id].
-			tfd_offset[IWL50_QUEUE_SIZE + txq->q.write_ptr],
-			sta_id, sta);
-	}
+	if (txq->q.write_ptr < TFD_QUEUE_SIZE_BC_DUP)
+		shared_data->queues_bc_tbls[txq_id].
+			tfd_offset[TFD_QUEUE_SIZE_MAX + write_ptr] = bc_ent;
 }
 
 static void iwl5000_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
 					   struct iwl_tx_queue *txq)
 {
-	int txq_id = txq->q.id;
 	struct iwl5000_shared *shared_data = priv->shared_virt;
-	u8 sta = 0;
+	int txq_id = txq->q.id;
+	int read_ptr = txq->q.read_ptr;
+	u8 sta_id = 0;
+	__le16 bc_ent;
+
+	WARN_ON(read_ptr >= TFD_QUEUE_SIZE_MAX);
 
 	if (txq_id != IWL_CMD_QUEUE_NUM)
-		sta = txq->cmd[txq->q.read_ptr]->cmd.tx.sta_id;
+		sta_id = txq->cmd[read_ptr]->cmd.tx.sta_id;
 
-	shared_data->queues_byte_cnt_tbls[txq_id].tfd_offset[txq->q.read_ptr].
-					val = cpu_to_le16(1 | (sta << 12));
+	bc_ent =  cpu_to_le16(1 | (sta_id << 12));
+	shared_data->queues_bc_tbls[txq_id].
+			tfd_offset[read_ptr] = bc_ent;
 
-	if (txq->q.write_ptr < IWL50_MAX_WIN_SIZE) {
-		shared_data->queues_byte_cnt_tbls[txq_id].
-			tfd_offset[IWL50_QUEUE_SIZE + txq->q.read_ptr].
-				val = cpu_to_le16(1 | (sta << 12));
-	}
+	if (txq->q.write_ptr < TFD_QUEUE_SIZE_BC_DUP)
+		shared_data->queues_bc_tbls[txq_id].
+			tfd_offset[TFD_QUEUE_SIZE_MAX + read_ptr] =  bc_ent;
 }
 
 static int iwl5000_tx_queue_set_q2ratid(struct iwl_priv *priv, u16 ra_tid,
diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index 8c48d88..f2688d5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -393,4 +393,9 @@
 /* TCSR: tx_config register values */
 #define FH_RSCSR_FRAME_SIZE_MSK	(0x00003FFF)	/* bits 0-13 */
 
+#define TFD_QUEUE_SIZE_MAX      (256)
+#define TFD_QUEUE_SIZE_BC_DUP	(64)
+#define TFD_QUEUE_BC_SIZE	(TFD_QUEUE_SIZE_MAX + TFD_QUEUE_SIZE_BC_DUP)
+
+
 #endif /* !__iwl_fh_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index 029d19c..4f0fa21 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -32,108 +32,6 @@
 
 #include <linux/ctype.h>
 
-/*
- * The structures defined by the hardware/uCode interface
- * have bit-wise operations.  For each bit-field there is
- * a data symbol in the structure, the start bit position
- * and the length of the bit-field.
- *
- * iwl_get_bits and iwl_set_bits will return or set the
- * appropriate bits on a 32-bit value.
- *
- * IWL_GET_BITS and IWL_SET_BITS use symbol expansion to
- * expand out to the appropriate call to iwl_get_bits
- * and iwl_set_bits without having to reference all of the
- * numerical constants and defines provided in the hardware
- * definition
- */
-
-/**
- * iwl_get_bits - Extract a hardware bit-field value
- * @src: source hardware value (__le32)
- * @pos: bit-position (0-based) of first bit of value
- * @len: length of bit-field
- *
- * iwl_get_bits will return the bit-field in cpu endian ordering.
- *
- * NOTE:  If used from IWL_GET_BITS then pos and len are compile-constants and
- *        will collapse to minimal code by the compiler.
- */
-static inline u32 iwl_get_bits(__le32 src, u8 pos, u8 len)
-{
-	u32 tmp = le32_to_cpu(src);
-
-	tmp >>= pos;
-	tmp &= (1UL << len) - 1;
-	return tmp;
-}
-
-/**
- * iwl_set_bits - Set a hardware bit-field value
- * @dst: Address of __le32 hardware value
- * @pos: bit-position (0-based) of first bit of value
- * @len: length of bit-field
- * @val: cpu endian value to encode into the bit-field
- *
- * iwl_set_bits will encode val into dst, masked to be len bits long at bit
- * position pos.
- *
- * NOTE:  If used IWL_SET_BITS pos and len will be compile-constants and
- *        will collapse to minimal code by the compiler.
- */
-static inline void iwl_set_bits(__le32 *dst, u8 pos, u8 len, int val)
-{
-	u32 tmp = le32_to_cpu(*dst);
-
-	tmp &= ~(((1UL << len) - 1) << pos);
-	tmp |= (val & ((1UL << len) - 1)) << pos;
-	*dst = cpu_to_le32(tmp);
-}
-
-static inline void iwl_set_bits16(__le16 *dst, u8 pos, u8 len, int val)
-{
-	u16 tmp = le16_to_cpu(*dst);
-
-	tmp &= ~((1UL << (pos + len)) - (1UL << pos));
-	tmp |= (val & ((1UL << len) - 1)) << pos;
-	*dst = cpu_to_le16(tmp);
-}
-
-/*
- * The bit-field definitions in iwl-xxxx-hw.h are in the form of:
- *
- * struct example {
- *         __le32 val1;
- * #define IWL_name_POS 8
- * #define IWL_name_LEN 4
- * #define IWL_name_SYM val1
- * };
- *
- * The IWL_SET_BITS and IWL_GET_BITS macros are provided to allow the driver
- * to call:
- *
- * struct example bar;
- * u32 val = IWL_GET_BITS(bar, name);
- * val = val * 2;
- * IWL_SET_BITS(bar, name, val);
- *
- * All cpu / host ordering, masking, and shifts are performed by the macros
- * and iwl_{get,set}_bits.
- *
- */
-#define IWL_SET_BITS(s, sym, v) \
-	iwl_set_bits(&(s).IWL_ ## sym ## _SYM, IWL_ ## sym ## _POS, \
-		     IWL_ ## sym ## _LEN, (v))
-
-#define IWL_SET_BITS16(s, sym, v) \
-	iwl_set_bits16(&(s).IWL_ ## sym ## _SYM, IWL_ ## sym ## _POS, \
-		       IWL_ ## sym ## _LEN, (v))
-
-#define IWL_GET_BITS(s, sym) \
-	iwl_get_bits((s).IWL_ ## sym ## _SYM, IWL_ ## sym ## _POS, \
-		      IWL_ ## sym ## _LEN)
-
-
 #define KELVIN_TO_CELSIUS(x) ((x)-273)
 #define CELSIUS_TO_KELVIN(x) ((x)+273)
 #define IWL_MASK(lo, hi) ((1 << (hi)) | ((1 << (hi)) - (1 << (lo))))
-- 
1.5.4.3

