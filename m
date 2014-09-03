Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61879 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbaICT5K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:57:10 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so9030417wgh.15
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:57:09 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 27/36] iwlwifi: trans: configure the scheduler enable register
Date: Wed,  3 Sep 2014 22:56:15 +0300
Message-Id: <1409774184-24665-27-git-send-email-egrumbach@gmail.com> (sfid-20140903_215752_506570_FBA1791B)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

Currently the firmware is handling this, but that is wrong as it then
needs to assume a certain command queue, therefore this should be in
the driver; add it here so it can be removed from the firmware in the
future.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-prph.h | 1 +
 drivers/net/wireless/iwlwifi/iwl-scd.h  | 6 ++++++
 drivers/net/wireless/iwlwifi/pcie/tx.c  | 8 ++++++++
 3 files changed, 15 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 47033a3..9e15273 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -281,6 +281,7 @@
 #define SCD_CHAINEXT_EN		(SCD_BASE + 0x244)
 #define SCD_AGGR_SEL		(SCD_BASE + 0x248)
 #define SCD_INTERRUPT_MASK	(SCD_BASE + 0x108)
+#define SCD_EN_CTRL		(SCD_BASE + 0x254)
 
 static inline unsigned int SCD_QUEUE_WRPTR(unsigned int chnl)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-scd.h b/drivers/net/wireless/iwlwifi/iwl-scd.h
index 5f099d4..6c622b2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scd.h
+++ b/drivers/net/wireless/iwlwifi/iwl-scd.h
@@ -109,4 +109,10 @@ static inline void iwl_scd_deactivate_fifos(struct iwl_trans *trans)
 {
 	iwl_write_prph(trans, SCD_TXFACT, 0);
 }
+
+static inline void iwl_scd_enable_set_active(struct iwl_trans *trans,
+					     u32 value)
+{
+	iwl_write_prph(trans, SCD_EN_CTRL, value);
+}
 #endif
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index a24c1df..9fdfed8 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1078,6 +1078,10 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, u16 ssn,
 	if (cfg) {
 		fifo = cfg->fifo;
 
+		/* Disable the scheduler prior configuring the cmd queue */
+		if (txq_id == trans_pcie->cmd_queue)
+			iwl_scd_enable_set_active(trans, 0);
+
 		/* Stop this Tx queue before configuring it */
 		iwl_scd_txq_set_inactive(trans, txq_id);
 
@@ -1135,6 +1139,10 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, u16 ssn,
 			       (cfg->fifo << SCD_QUEUE_STTS_REG_POS_TXF) |
 			       (1 << SCD_QUEUE_STTS_REG_POS_WSL) |
 			       SCD_QUEUE_STTS_REG_MSK);
+
+		/* enable the scheduler for this queue (only) */
+		if (txq_id == trans_pcie->cmd_queue)
+			iwl_scd_enable_set_active(trans, BIT(txq_id));
 	}
 
 	trans_pcie->txq[txq_id].active = true;
-- 
1.9.1

