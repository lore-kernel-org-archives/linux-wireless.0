Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38351 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbaEGTx7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 15:53:59 -0400
Received: by mail-wg0-f44.google.com with SMTP id a1so1480896wgh.3
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 12:53:58 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/23] iwlwifi: pcie: use bool for iwl_pcie_txq_build_tfd() argument
Date: Wed,  7 May 2014 22:52:53 +0300
Message-Id: <1399492380-12050-16-git-send-email-egrumbach@gmail.com> (sfid-20140507_215410_975179_4CC6D3D0)
In-Reply-To: <536A8EE3.2050906@gmail.com>
References: <536A8EE3.2050906@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The 'reset' argument is clearly a boolean, so use bool instead
of u8 with 0/1 values.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/tx.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index dde6031..16ebc4a 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -452,7 +452,7 @@ static void iwl_pcie_txq_free_tfd(struct iwl_trans *trans, struct iwl_txq *txq)
 }
 
 static int iwl_pcie_txq_build_tfd(struct iwl_trans *trans, struct iwl_txq *txq,
-				  dma_addr_t addr, u16 len, u8 reset)
+				  dma_addr_t addr, u16 len, bool reset)
 {
 	struct iwl_queue *q;
 	struct iwl_tfd *tfd, *tfd_tmp;
@@ -1363,7 +1363,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 	memcpy(&txq->scratchbufs[q->write_ptr], &out_cmd->hdr, scratch_size);
 	iwl_pcie_txq_build_tfd(trans, txq,
 			       iwl_pcie_get_scratchbuf_dma(txq, q->write_ptr),
-			       scratch_size, 1);
+			       scratch_size, true);
 
 	/* map first command fragment, if any remains */
 	if (copy_size > scratch_size) {
@@ -1379,7 +1379,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 		}
 
 		iwl_pcie_txq_build_tfd(trans, txq, phys_addr,
-				       copy_size - scratch_size, 0);
+				       copy_size - scratch_size, false);
 	}
 
 	/* map the remaining (adjusted) nocopy/dup fragments */
@@ -1402,7 +1402,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 			goto out;
 		}
 
-		iwl_pcie_txq_build_tfd(trans, txq, phys_addr, cmdlen[i], 0);
+		iwl_pcie_txq_build_tfd(trans, txq, phys_addr, cmdlen[i], false);
 	}
 
 	out_meta->flags = cmd->flags;
@@ -1740,7 +1740,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	memcpy(&txq->scratchbufs[q->write_ptr], &dev_cmd->hdr,
 	       IWL_HCMD_SCRATCHBUF_SIZE);
 	iwl_pcie_txq_build_tfd(trans, txq, tb0_phys,
-			       IWL_HCMD_SCRATCHBUF_SIZE, 1);
+			       IWL_HCMD_SCRATCHBUF_SIZE, true);
 
 	/* there must be data left over for TB1 or this code must be changed */
 	BUILD_BUG_ON(sizeof(struct iwl_tx_cmd) < IWL_HCMD_SCRATCHBUF_SIZE);
@@ -1750,7 +1750,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	tb1_phys = dma_map_single(trans->dev, tb1_addr, tb1_len, DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(trans->dev, tb1_phys)))
 		goto out_err;
-	iwl_pcie_txq_build_tfd(trans, txq, tb1_phys, tb1_len, 0);
+	iwl_pcie_txq_build_tfd(trans, txq, tb1_phys, tb1_len, false);
 
 	/*
 	 * Set up TFD's third entry to point directly to remainder
@@ -1766,7 +1766,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 					   &txq->tfds[q->write_ptr]);
 			goto out_err;
 		}
-		iwl_pcie_txq_build_tfd(trans, txq, tb2_phys, tb2_len, 0);
+		iwl_pcie_txq_build_tfd(trans, txq, tb2_phys, tb2_len, false);
 	}
 
 	/* Set up entry for this TFD in Tx byte-count array */
-- 
1.8.3.2

