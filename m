Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:7398 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527Ab1GAPxF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 11:53:05 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/11] iwlagn: scd memory boundary
Date: Fri,  1 Jul 2011 08:20:02 -0700
Message-Id: <1309533605-25774-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110701_175318_069038_253A8B0D)
In-Reply-To: <1309533605-25774-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1309533605-25774-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Assign memory boundary for SCD context, tx status and translation table

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    8 +++++---
 drivers/net/wireless/iwlwifi/iwl-prph.h      |   19 ++++++++++++++-----
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index de8277e..2043c8b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -386,11 +386,13 @@ static int iwlagn_alive_notify(struct iwl_priv *priv)
 	spin_lock_irqsave(&priv->lock, flags);
 
 	priv->scd_base_addr = iwl_read_prph(priv, IWLAGN_SCD_SRAM_BASE_ADDR);
-	a = priv->scd_base_addr + IWLAGN_SCD_CONTEXT_DATA_OFFSET;
-	for (; a < priv->scd_base_addr + IWLAGN_SCD_TX_STTS_BITMAP_OFFSET;
+	a = priv->scd_base_addr + IWLAGN_SCD_CONTEXT_MEM_LOWER_BOUND;
+	/* reset conext data memory */
+	for (; a < priv->scd_base_addr + IWLAGN_SCD_CONTEXT_MEM_UPPER_BOUND;
 		a += 4)
 		iwl_write_targ_mem(priv, a, 0);
-	for (; a < priv->scd_base_addr + IWLAGN_SCD_TRANSLATE_TBL_OFFSET;
+	/* reset tx status memory */
+	for (; a < priv->scd_base_addr + IWLAGN_SCD_TX_STTS_MEM_UPPER_BOUND;
 		a += 4)
 		iwl_write_targ_mem(priv, a, 0);
 	for (; a < priv->scd_base_addr +
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index f00d188..1cc0ed1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -168,6 +168,7 @@
  * the scheduler (especially for queue #4/#9, the command queue, otherwise
  * the driver can't issue commands!):
  */
+#define SCD_MEM_LOWER_BOUND		(0x0000)
 
 /**
  * Max Tx window size is the max number of contiguous TFDs that the scheduler
@@ -197,15 +198,23 @@
 #define IWLAGN_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS	(16)
 #define IWLAGN_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK	(0x007F0000)
 
-#define IWLAGN_SCD_CONTEXT_DATA_OFFSET		(0x600)
-#define IWLAGN_SCD_TX_STTS_BITMAP_OFFSET		(0x7B1)
-#define IWLAGN_SCD_TRANSLATE_TBL_OFFSET		(0x7E0)
+/* Context Data */
+#define IWLAGN_SCD_CONTEXT_MEM_LOWER_BOUND	(SCD_MEM_LOWER_BOUND + 0x600)
+#define IWLAGN_SCD_CONTEXT_MEM_UPPER_BOUND	(SCD_MEM_LOWER_BOUND + 0x6A0)
+
+/* Tx status */
+#define IWLAGN_SCD_TX_STTS_MEM_LOWER_BOUND	(SCD_MEM_LOWER_BOUND + 0x6A0)
+#define IWLAGN_SCD_TX_STTS_MEM_UPPER_BOUND	(SCD_MEM_LOWER_BOUND + 0x7E0)
+
+/* Translation Data */
+#define IWLAGN_SCD_TRANS_TBL_MEM_LOWER_BOUND	(SCD_MEM_LOWER_BOUND + 0x7E0)
+#define IWLAGN_SCD_TRANS_TBL_MEM_UPPER_BOUND	(SCD_MEM_LOWER_BOUND + 0x808)
 
 #define IWLAGN_SCD_CONTEXT_QUEUE_OFFSET(x)\
-	(IWLAGN_SCD_CONTEXT_DATA_OFFSET + ((x) * 8))
+	(IWLAGN_SCD_CONTEXT_MEM_LOWER_BOUND + ((x) * 8))
 
 #define IWLAGN_SCD_TRANSLATE_TBL_OFFSET_QUEUE(x) \
-	((IWLAGN_SCD_TRANSLATE_TBL_OFFSET + ((x) * 2)) & 0xfffc)
+	((IWLAGN_SCD_TRANS_TBL_MEM_LOWER_BOUND + ((x) * 2)) & 0xfffc)
 
 #define IWLAGN_SCD_QUEUECHAIN_SEL_ALL(priv)	\
 	(((1<<(priv)->hw_params.max_txq_num) - 1) &\
-- 
1.7.0.4

