Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1101 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965181AbbBCHO6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 02:14:58 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/19] iwlwifi: pcie: prepare the enablement of 31 TFD queues
Date: Tue,  3 Feb 2015 09:14:27 +0200
Message-Id: <1422947678-16917-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150203_081502_992667_D5852AF9)
In-Reply-To: <1422947482.30742.8.camel@egrumbacBox>
References: <1422947482.30742.8.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some devices have 31 TFD queues. Don't enable it yet since
there are still issues with it, but at least prepare the
code for it. There was a bug in the read pointer assignment,
fix that. Also, move the inline functions to iwl-scd.h which
is the right place.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-prph.h   | 26 ++------------------
 drivers/net/wireless/iwlwifi/iwl-scd.h    | 41 +++++++++++++++++++++++++------
 drivers/net/wireless/iwlwifi/pcie/trans.c |  1 +
 drivers/net/wireless/iwlwifi/pcie/tx.c    |  4 +++
 4 files changed, 40 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index b21fcf0..6221e4d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -252,6 +252,7 @@
 #define SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK		(0x0000007F)
 #define SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS	(16)
 #define SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK	(0x007F0000)
+#define SCD_GP_CTRL_ENABLE_31_QUEUES		BIT(0)
 
 /* Context Data */
 #define SCD_CONTEXT_MEM_LOWER_BOUND	(SCD_MEM_LOWER_BOUND + 0x600)
@@ -285,32 +286,9 @@
 #define SCD_CHAINEXT_EN		(SCD_BASE + 0x244)
 #define SCD_AGGR_SEL		(SCD_BASE + 0x248)
 #define SCD_INTERRUPT_MASK	(SCD_BASE + 0x108)
+#define SCD_GP_CTRL		(SCD_BASE + 0x1a8)
 #define SCD_EN_CTRL		(SCD_BASE + 0x254)
 
-static inline unsigned int SCD_QUEUE_WRPTR(unsigned int chnl)
-{
-	if (chnl < 20)
-		return SCD_BASE + 0x18 + chnl * 4;
-	WARN_ON_ONCE(chnl >= 32);
-	return SCD_BASE + 0x284 + (chnl - 20) * 4;
-}
-
-static inline unsigned int SCD_QUEUE_RDPTR(unsigned int chnl)
-{
-	if (chnl < 20)
-		return SCD_BASE + 0x68 + chnl * 4;
-	WARN_ON_ONCE(chnl >= 32);
-	return SCD_BASE + 0x2B4 + (chnl - 20) * 4;
-}
-
-static inline unsigned int SCD_QUEUE_STATUS_BITS(unsigned int chnl)
-{
-	if (chnl < 20)
-		return SCD_BASE + 0x10c + chnl * 4;
-	WARN_ON_ONCE(chnl >= 32);
-	return SCD_BASE + 0x384 + (chnl - 20) * 4;
-}
-
 /*********************** END TX SCHEDULER *************************************/
 
 /* Oscillator clock */
diff --git a/drivers/net/wireless/iwlwifi/iwl-scd.h b/drivers/net/wireless/iwlwifi/iwl-scd.h
index 6c622b2..f2353eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scd.h
+++ b/drivers/net/wireless/iwlwifi/iwl-scd.h
@@ -69,14 +69,6 @@
 #include "iwl-prph.h"
 
 
-static inline void iwl_scd_txq_set_inactive(struct iwl_trans *trans,
-					    u16 txq_id)
-{
-	iwl_write_prph(trans, SCD_QUEUE_STATUS_BITS(txq_id),
-		       (0 << SCD_QUEUE_STTS_REG_POS_ACTIVE)|
-		       (1 << SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
-}
-
 static inline void iwl_scd_txq_set_chain(struct iwl_trans *trans,
 					 u16 txq_id)
 {
@@ -115,4 +107,37 @@ static inline void iwl_scd_enable_set_active(struct iwl_trans *trans,
 {
 	iwl_write_prph(trans, SCD_EN_CTRL, value);
 }
+
+static inline unsigned int SCD_QUEUE_WRPTR(unsigned int chnl)
+{
+	if (chnl < 20)
+		return SCD_BASE + 0x18 + chnl * 4;
+	WARN_ON_ONCE(chnl >= 32);
+	return SCD_BASE + 0x284 + (chnl - 20) * 4;
+}
+
+static inline unsigned int SCD_QUEUE_RDPTR(unsigned int chnl)
+{
+	if (chnl < 20)
+		return SCD_BASE + 0x68 + chnl * 4;
+	WARN_ON_ONCE(chnl >= 32);
+	return SCD_BASE + 0x2B4 + chnl * 4;
+}
+
+static inline unsigned int SCD_QUEUE_STATUS_BITS(unsigned int chnl)
+{
+	if (chnl < 20)
+		return SCD_BASE + 0x10c + chnl * 4;
+	WARN_ON_ONCE(chnl >= 32);
+	return SCD_BASE + 0x334 + chnl * 4;
+}
+
+static inline void iwl_scd_txq_set_inactive(struct iwl_trans *trans,
+					    u16 txq_id)
+{
+	iwl_write_prph(trans, SCD_QUEUE_STATUS_BITS(txq_id),
+		       (0 << SCD_QUEUE_STTS_REG_POS_ACTIVE)|
+		       (1 << SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
+}
+
 #endif
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 1ff8767..eb0ffc1 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -75,6 +75,7 @@
 #include "iwl-trans.h"
 #include "iwl-csr.h"
 #include "iwl-prph.h"
+#include "iwl-scd.h"
 #include "iwl-agn-hw.h"
 #include "iwl-fw-error-dump.h"
 #include "internal.h"
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 6c7bfe8..0a94083 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -892,6 +892,10 @@ int iwl_pcie_tx_init(struct iwl_trans *trans)
 		}
 	}
 
+	if (trans->cfg->base_params->num_of_queues > 20)
+		iwl_set_bits_prph(trans, SCD_GP_CTRL,
+				  SCD_GP_CTRL_ENABLE_31_QUEUES);
+
 	return 0;
 error:
 	/*Upon error, free only if we allocated something */
-- 
1.9.1

