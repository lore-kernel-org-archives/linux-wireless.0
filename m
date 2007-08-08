Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759015AbXHHHht (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:37:49 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 19/28] iwlwifi: make iwl_get_bits inline function from macro
Date: Wed,  8 Aug 2007 15:33:36 +0800
Message-Id: <1186558470949-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11865584683474-git-send-email-yi.zhu@intel.com>
References: <11865584251026-git-send-email-yi.zhu@intel.com>
 <11865584292234-git-send-email-yi.zhu@intel.com>
 <1186558432932-git-send-email-yi.zhu@intel.com>
 <11865584342308-git-send-email-yi.zhu@intel.com>
 <11865584363863-git-send-email-yi.zhu@intel.com>
 <11865584392893-git-send-email-yi.zhu@intel.com>
 <11865584413292-git-send-email-yi.zhu@intel.com>
 <1186558443548-git-send-email-yi.zhu@intel.com>
 <11865584452614-git-send-email-yi.zhu@intel.com>
 <11865584473732-git-send-email-yi.zhu@intel.com>
 <11865584503648-git-send-email-yi.zhu@intel.com>
 <11865584521358-git-send-email-yi.zhu@intel.com>
 <11865584543903-git-send-email-yi.zhu@intel.com>
 <11865584562811-git-send-email-yi.zhu@intel.com>
 <11865584583336-git-send-email-yi.zhu@intel.com>
 <11865584603865-git-send-email-yi.zhu@intel.com>
 <11865584631842-git-send-email-yi.zhu@intel.com>
 <11865584661209-git-send-email-yi.zhu@intel.com>
 <11865584683474-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make iwl_get_bits and iwl_set_bits inline functions from the original
macro implementation. Add IWL_SET_BITS16 for 16-bits value setting.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-4965.c    |    6 ++--
 drivers/net/wireless/iwl-helpers.h |   53 +++++++++++++++++++++---------------
 2 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index de5b541..258879c 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -2815,11 +2815,11 @@ int iwl4965_tx_queue_update_wr_ptr(struct iwl_priv *priv,
 
 	len = byte_cnt + IWL_TX_CRC_SIZE + IWL_TX_DELIMITER_SIZE;
 
-	IWL_SET_BITS(shared_data->queues_byte_cnt_tbls[txq_id].
-		     tfd_offset[txq->q.first_empty], byte_cnt, len);
+	IWL_SET_BITS16(shared_data->queues_byte_cnt_tbls[txq_id].
+		       tfd_offset[txq->q.first_empty], byte_cnt, len);
 
 	if (txq->q.first_empty < IWL4965_MAX_WIN_SIZE)
-		IWL_SET_BITS(shared_data->queues_byte_cnt_tbls[txq_id].
+		IWL_SET_BITS16(shared_data->queues_byte_cnt_tbls[txq_id].
 			tfd_offset[IWL4965_QUEUE_SIZE + txq->q.first_empty],
 			byte_cnt, len);
 
diff --git a/drivers/net/wireless/iwl-helpers.h b/drivers/net/wireless/iwl-helpers.h
index c0ea48e..6281e3d 100644
--- a/drivers/net/wireless/iwl-helpers.h
+++ b/drivers/net/wireless/iwl-helpers.h
@@ -59,13 +59,14 @@
  * NOTE:  If used from IWL_GET_BITS then pos and len are compile-constants and
  *        will collapse to minimal code by the compiler.
  */
-#define iwl_get_bits(src, pos, len)   \
-({                                    \
-	u32 __tmp = le32_to_cpu(src); \
-	__tmp >>= pos;                \
-	__tmp &= (1UL << len) - 1;    \
-	__tmp;                        \
-})
+static inline u32 iwl_get_bits(__le32 src, u8 pos, u8 len)
+{
+	u32 tmp = le32_to_cpu(src);
+
+	tmp >>= pos;
+	tmp &= (1UL << len) - 1;
+	return tmp;
+}
 
 /**
  * iwl_set_bits - Set a hardware bit-field value
@@ -80,13 +81,23 @@
  * NOTE:  If used IWL_SET_BITS pos and len will be compile-constants and
  *        will collapse to minimal code by the compiler.
  */
-#define iwl_set_bits(dst, pos, len, val)                 \
-({                                                       \
-	u32 __tmp = le32_to_cpu(*dst);                   \
-	__tmp &= ~((1ULL << (pos+len)) - (1 << pos));    \
-	__tmp |= (val & ((1UL << len) - 1)) << pos;      \
-	*dst = cpu_to_le32(__tmp);                       \
-})
+static inline void iwl_set_bits(__le32 *dst, u8 pos, u8 len, int val)
+{
+	u32 tmp = le32_to_cpu(*dst);
+
+	tmp &= ~((1UL << (pos + len)) - (1UL << pos));
+	tmp |= (val & ((1UL << len) - 1)) << pos;
+	*dst = cpu_to_le32(tmp);
+}
+
+static inline void iwl_set_bits16(__le16 *dst, u8 pos, u8 len, int val)
+{
+	u32 tmp = le16_to_cpu(*dst);
+
+	tmp &= ~((1UL << (pos + len)) - (1UL << pos));
+	tmp |= (val & ((1UL << len) - 1)) << pos;
+	*dst = cpu_to_le16(tmp);
+}
 
 /*
  * The bit-field definitions in iwl-xxxx-hw.h are in the form of:
@@ -110,18 +121,16 @@
  * and iwl_{get,set}_bits.
  *
  */
-#define _IWL_SET_BITS(s, d, o, l, v) \
-	iwl_set_bits(&s.d, o, l, v)
-
 #define IWL_SET_BITS(s, sym, v) \
-	_IWL_SET_BITS((s), IWL_ ## sym ## _SYM, IWL_ ## sym ## _POS, \
-		      IWL_ ## sym ## _LEN, (v))
+	iwl_set_bits(&(s).IWL_ ## sym ## _SYM, IWL_ ## sym ## _POS, \
+		     IWL_ ## sym ## _LEN, (v))
 
-#define _IWL_GET_BITS(s, v, o, l) \
-	iwl_get_bits(s.v, o, l)
+#define IWL_SET_BITS16(s, sym, v) \
+	iwl_set_bits16(&(s).IWL_ ## sym ## _SYM, IWL_ ## sym ## _POS, \
+		       IWL_ ## sym ## _LEN, (v))
 
 #define IWL_GET_BITS(s, sym) \
-	_IWL_GET_BITS((s), IWL_ ## sym ## _SYM, IWL_ ## sym ## _POS, \
+	iwl_get_bits((s).IWL_ ## sym ## _SYM, IWL_ ## sym ## _POS, \
 		      IWL_ ## sym ## _LEN)
 
 /* Debug and printf string expansion helpers for printing bitfields */
-- 
1.5.2
