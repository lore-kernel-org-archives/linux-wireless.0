Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:35082 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502AbaICT46 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:56:58 -0400
Received: by mail-we0-f173.google.com with SMTP id t60so9227069wes.18
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:56:57 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 19/36] iwlwifi: consolidate hw scheduler configuration code
Date: Wed,  3 Sep 2014 22:56:07 +0300
Message-Id: <1409774184-24665-19-git-send-email-egrumbach@gmail.com> (sfid-20140903_220114_595420_B72808E3)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

Configuring the hw scheduler during queue enablement is done by
writing the appropriate values to the scheduler peripherals, and
it is essentially the same for all buses.

Whenever writing is done via the standard iwl_write_prph, we can
avoid duplicating the code for each bus. Those operations are
queue deactivation, RA/TID mapping, chain-building settings,
enabling/disabling aggregations and activating/deactivating the
TX FIFOs.

Consolidate this code using static inlines in a new header file.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-scd.h | 112 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/pcie/tx.c |  39 +++---------
 2 files changed, 121 insertions(+), 30 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-scd.h

diff --git a/drivers/net/wireless/iwlwifi/iwl-scd.h b/drivers/net/wireless/iwlwifi/iwl-scd.h
new file mode 100644
index 0000000..5f099d4
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-scd.h
@@ -0,0 +1,112 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2014 Intel Mobile Communications GmbH
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called COPYING.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2014 Intel Mobile Communications GmbH
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+
+#ifndef __iwl_scd_h__
+#define __iwl_scd_h__
+
+#include "iwl-trans.h"
+#include "iwl-io.h"
+#include "iwl-prph.h"
+
+
+static inline void iwl_scd_txq_set_inactive(struct iwl_trans *trans,
+					    u16 txq_id)
+{
+	iwl_write_prph(trans, SCD_QUEUE_STATUS_BITS(txq_id),
+		       (0 << SCD_QUEUE_STTS_REG_POS_ACTIVE)|
+		       (1 << SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
+}
+
+static inline void iwl_scd_txq_set_chain(struct iwl_trans *trans,
+					 u16 txq_id)
+{
+	iwl_set_bits_prph(trans, SCD_QUEUECHAIN_SEL, BIT(txq_id));
+}
+
+static inline void iwl_scd_txq_enable_agg(struct iwl_trans *trans,
+					  u16 txq_id)
+{
+	iwl_set_bits_prph(trans, SCD_AGGR_SEL, BIT(txq_id));
+}
+
+static inline void iwl_scd_txq_disable_agg(struct iwl_trans *trans,
+					   u16 txq_id)
+{
+	iwl_clear_bits_prph(trans, SCD_AGGR_SEL, BIT(txq_id));
+}
+
+static inline void iwl_scd_disable_agg(struct iwl_trans *trans)
+{
+	iwl_set_bits_prph(trans, SCD_AGGR_SEL, 0);
+}
+
+static inline void iwl_scd_activate_fifos(struct iwl_trans *trans)
+{
+	iwl_write_prph(trans, SCD_TXFACT, IWL_MASK(0, 7));
+}
+
+static inline void iwl_scd_deactivate_fifos(struct iwl_trans *trans)
+{
+	iwl_write_prph(trans, SCD_TXFACT, 0);
+}
+#endif
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 6acccb1..84c3a01 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -34,6 +34,7 @@
 #include "iwl-csr.h"
 #include "iwl-prph.h"
 #include "iwl-io.h"
+#include "iwl-scd.h"
 #include "iwl-op-mode.h"
 #include "internal.h"
 /* FIXME: need to abstract out TX command (once we know what it looks like) */
@@ -644,17 +645,6 @@ static void iwl_pcie_txq_free(struct iwl_trans *trans, int txq_id)
 	memset(txq, 0, sizeof(*txq));
 }
 
-/*
- * Activate/Deactivate Tx DMA/FIFO channels according tx fifos mask
- */
-static void iwl_pcie_txq_set_sched(struct iwl_trans *trans, u32 mask)
-{
-	struct iwl_trans_pcie __maybe_unused *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	iwl_write_prph(trans, SCD_TXFACT, mask);
-}
-
 void iwl_pcie_tx_start(struct iwl_trans *trans, u32 scd_base_addr)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
@@ -692,7 +682,7 @@ void iwl_pcie_tx_start(struct iwl_trans *trans, u32 scd_base_addr)
 				trans_pcie->cmd_fifo);
 
 	/* Activate all Tx DMA/FIFO channels */
-	iwl_pcie_txq_set_sched(trans, IWL_MASK(0, 7));
+	iwl_scd_activate_fifos(trans);
 
 	/* Enable DMA channel */
 	for (chan = 0; chan < FH_TCSR_CHNL_NUM; chan++)
@@ -745,7 +735,7 @@ int iwl_pcie_tx_stop(struct iwl_trans *trans)
 	/* Turn off all Tx DMA fifos */
 	spin_lock(&trans_pcie->irq_lock);
 
-	iwl_pcie_txq_set_sched(trans, 0);
+	iwl_scd_deactivate_fifos(trans);
 
 	/* Stop each Tx DMA channel, and wait for it to be idle */
 	for (ch = 0; ch < FH_TCSR_CHNL_NUM; ch++) {
@@ -886,7 +876,7 @@ int iwl_pcie_tx_init(struct iwl_trans *trans)
 	spin_lock(&trans_pcie->irq_lock);
 
 	/* Turn off all Tx DMA fifos */
-	iwl_write_prph(trans, SCD_TXFACT, 0);
+	iwl_scd_deactivate_fifos(trans);
 
 	/* Tell NIC where to find the "keep warm" buffer */
 	iwl_write_direct32(trans, FH_KW_MEM_ADDR_REG,
@@ -1072,17 +1062,6 @@ static int iwl_pcie_txq_set_ratid_map(struct iwl_trans *trans, u16 ra_tid,
 	return 0;
 }
 
-static inline void iwl_pcie_txq_set_inactive(struct iwl_trans *trans,
-					     u16 txq_id)
-{
-	/* Simply stop the queue, but don't change any configuration;
-	 * the SCD_ACT_EN bit is the write-enable mask for the ACTIVE bit. */
-	iwl_write_prph(trans,
-		SCD_QUEUE_STATUS_BITS(txq_id),
-		(0 << SCD_QUEUE_STTS_REG_POS_ACTIVE)|
-		(1 << SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
-}
-
 /* Receiver address (actually, Rx station's index into station table),
  * combined with Traffic ID (QOS priority), in format used by Tx Scheduler */
 #define BUILD_RAxTID(sta_id, tid)	(((sta_id) << 4) + (tid))
@@ -1096,11 +1075,11 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, int fifo,
 		WARN_ONCE(1, "queue %d already used - expect issues", txq_id);
 
 	/* Stop this Tx queue before configuring it */
-	iwl_pcie_txq_set_inactive(trans, txq_id);
+	iwl_scd_txq_set_inactive(trans, txq_id);
 
 	/* Set this queue as a chain-building queue unless it is CMD queue */
 	if (txq_id != trans_pcie->cmd_queue)
-		iwl_set_bits_prph(trans, SCD_QUEUECHAIN_SEL, BIT(txq_id));
+		iwl_scd_txq_set_chain(trans, txq_id);
 
 	/* If this queue is mapped to a certain station: it is an AGG queue */
 	if (sta_id >= 0) {
@@ -1110,7 +1089,7 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, int fifo,
 		iwl_pcie_txq_set_ratid_map(trans, ra_tid, txq_id);
 
 		/* enable aggregations for the queue */
-		iwl_set_bits_prph(trans, SCD_AGGR_SEL, BIT(txq_id));
+		iwl_scd_txq_enable_agg(trans, txq_id);
 		trans_pcie->txq[txq_id].ampdu = true;
 	} else {
 		/*
@@ -1118,7 +1097,7 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, int fifo,
 		 * ra_tid mapping configuration irrelevant since it is now a
 		 * non-AGG queue.
 		 */
-		iwl_clear_bits_prph(trans, SCD_AGGR_SEL, BIT(txq_id));
+		iwl_scd_txq_disable_agg(trans, txq_id);
 
 		ssn = trans_pcie->txq[txq_id].q.read_ptr;
 	}
@@ -1172,7 +1151,7 @@ void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id)
 		return;
 	}
 
-	iwl_pcie_txq_set_inactive(trans, txq_id);
+	iwl_scd_txq_set_inactive(trans, txq_id);
 
 	iwl_trans_write_mem(trans, stts_addr, (void *)zero_val,
 			    ARRAY_SIZE(zero_val));
-- 
1.9.1

