Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45728 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726990AbeHaOFT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 10:05:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 31 Aug 2018 12:56:14 +0300
Message-Id: <20180831095614.14099-17-luca@coelho.fi> (sfid-20180831_115839_381248_029D6FE2)
In-Reply-To: <20180831095614.14099-1-luca@coelho.fi>
References: <20180831095614.14099-1-luca@coelho.fi>
Subject: [PATCH 16/16] iwlwifi: pcie: gen2: pull adding frags to helper routine
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Move the skb fragment loop into a helper routine to be able
to reuse it later.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 51 ++++++++++++-------
 1 file changed, 32 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index a33fb335849e..943891a9d3e7 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -416,6 +416,35 @@ iwl_tfh_tfd *iwl_pcie_gen2_build_tx_amsdu(struct iwl_trans *trans,
 	return NULL;
 }
 
+static int iwl_pcie_gen2_tx_add_frags(struct iwl_trans *trans,
+				      struct sk_buff *skb,
+				      struct iwl_tfh_tfd *tfd,
+				      struct iwl_cmd_meta *out_meta)
+{
+	int i;
+
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
+		dma_addr_t tb_phys;
+		int tb_idx;
+
+		if (!skb_frag_size(frag))
+			continue;
+
+		tb_phys = skb_frag_dma_map(trans->dev, frag, 0,
+					   skb_frag_size(frag), DMA_TO_DEVICE);
+
+		if (unlikely(dma_mapping_error(trans->dev, tb_phys)))
+			return -ENOMEM;
+		tb_idx = iwl_pcie_gen2_set_tb(trans, tfd, tb_phys,
+					      skb_frag_size(frag));
+
+		out_meta->tbs |= BIT(tb_idx);
+	}
+
+	return 0;
+}
+
 static struct
 iwl_tfh_tfd *iwl_pcie_gen2_build_tx(struct iwl_trans *trans,
 				    struct iwl_txq *txq,
@@ -428,7 +457,7 @@ iwl_tfh_tfd *iwl_pcie_gen2_build_tx(struct iwl_trans *trans,
 	int idx = iwl_pcie_get_cmd_index(txq, txq->write_ptr);
 	struct iwl_tfh_tfd *tfd = iwl_pcie_get_tfd(trans, txq, idx);
 	dma_addr_t tb_phys;
-	int i, len, tb1_len, tb2_len;
+	int len, tb1_len, tb2_len;
 	void *tb1_addr;
 
 	tb_phys = iwl_pcie_get_first_tb_dma(txq, idx);
@@ -467,24 +496,8 @@ iwl_tfh_tfd *iwl_pcie_gen2_build_tx(struct iwl_trans *trans,
 		iwl_pcie_gen2_set_tb(trans, tfd, tb_phys, tb2_len);
 	}
 
-	/* set up the remaining entries to point to the data */
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
-		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-		int tb_idx;
-
-		if (!skb_frag_size(frag))
-			continue;
-
-		tb_phys = skb_frag_dma_map(trans->dev, frag, 0,
-					   skb_frag_size(frag), DMA_TO_DEVICE);
-
-		if (unlikely(dma_mapping_error(trans->dev, tb_phys)))
-			goto out_err;
-		tb_idx = iwl_pcie_gen2_set_tb(trans, tfd, tb_phys,
-					      skb_frag_size(frag));
-
-		out_meta->tbs |= BIT(tb_idx);
-	}
+	if (iwl_pcie_gen2_tx_add_frags(trans, skb, tfd, out_meta))
+		goto out_err;
 
 	trace_iwlwifi_dev_tx(trans->dev, skb, tfd, sizeof(*tfd), &dev_cmd->hdr,
 			     IWL_FIRST_TB_SIZE + tb1_len, hdr_len);
-- 
2.18.0
