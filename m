Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47934 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726609AbeIIO0L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 10:26:11 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun,  9 Sep 2018 12:36:42 +0300
Message-Id: <20180909093656.10194-3-luca@coelho.fi> (sfid-20180909_113708_829524_4E84D414)
In-Reply-To: <20180909093656.10194-1-luca@coelho.fi>
References: <20180909093656.10194-1-luca@coelho.fi>
Subject: [PATCH 02/16] iwlwifi: pcie: tx: unify TFD unmapping
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When anything fails, we unmap the whole TFD in three different
places scattered throughout the code. Unify this to a single
place.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c | 28 +++++---------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 5091cd567b63..2742c41c88b3 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1994,11 +1994,8 @@ static int iwl_fill_data_tbs(struct iwl_trans *trans, struct sk_buff *skb,
 		dma_addr_t tb2_phys = dma_map_single(trans->dev,
 						     skb->data + hdr_len,
 						     tb2_len, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(trans->dev, tb2_phys))) {
-			iwl_pcie_tfd_unmap(trans, out_meta, txq,
-					   txq->write_ptr);
+		if (unlikely(dma_mapping_error(trans->dev, tb2_phys)))
 			return -EINVAL;
-		}
 		iwl_pcie_txq_build_tfd(trans, txq, tb2_phys, tb2_len, false);
 	}
 
@@ -2014,11 +2011,8 @@ static int iwl_fill_data_tbs(struct iwl_trans *trans, struct sk_buff *skb,
 		tb_phys = skb_frag_dma_map(trans->dev, frag, 0,
 					   skb_frag_size(frag), DMA_TO_DEVICE);
 
-		if (unlikely(dma_mapping_error(trans->dev, tb_phys))) {
-			iwl_pcie_tfd_unmap(trans, out_meta, txq,
-					   txq->write_ptr);
+		if (unlikely(dma_mapping_error(trans->dev, tb_phys)))
 			return -EINVAL;
-		}
 		tb_idx = iwl_pcie_txq_build_tfd(trans, txq, tb_phys,
 						skb_frag_size(frag), false);
 
@@ -2091,7 +2085,6 @@ static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 	u8 *start_hdr;
 	struct iwl_tso_hdr_page *hdr_page;
 	struct page **page_ptr;
-	int ret;
 	struct tso_t tso;
 
 	/* if the packet is protected, then it must be CCMP or GCMP */
@@ -2177,10 +2170,8 @@ static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 		if (trans_pcie->sw_csum_tx) {
 			csum_skb = alloc_skb(data_left + tcp_hdrlen(skb),
 					     GFP_ATOMIC);
-			if (!csum_skb) {
-				ret = -ENOMEM;
-				goto out_unmap;
-			}
+			if (!csum_skb)
+				return -ENOMEM;
 
 			iwl_compute_pseudo_hdr_csum(iph, tcph,
 						    skb->protocol ==
@@ -2201,8 +2192,7 @@ static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 					     hdr_tb_len, DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(trans->dev, hdr_tb_phys))) {
 			dev_kfree_skb(csum_skb);
-			ret = -EINVAL;
-			goto out_unmap;
+			return -EINVAL;
 		}
 		iwl_pcie_txq_build_tfd(trans, txq, hdr_tb_phys,
 				       hdr_tb_len, false);
@@ -2227,8 +2217,7 @@ static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 						 size, DMA_TO_DEVICE);
 			if (unlikely(dma_mapping_error(trans->dev, tb_phys))) {
 				dev_kfree_skb(csum_skb);
-				ret = -EINVAL;
-				goto out_unmap;
+				return -EINVAL;
 			}
 
 			iwl_pcie_txq_build_tfd(trans, txq, tb_phys,
@@ -2262,10 +2251,6 @@ static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 	skb_push(skb, hdr_len + iv_len);
 
 	return 0;
-
-out_unmap:
-	iwl_pcie_tfd_unmap(trans, out_meta, txq, txq->write_ptr);
-	return ret;
 }
 #else /* CONFIG_INET */
 static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
@@ -2477,6 +2462,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	spin_unlock(&txq->lock);
 	return 0;
 out_err:
+	iwl_pcie_tfd_unmap(trans, out_meta, txq, txq->write_ptr);
 	spin_unlock(&txq->lock);
 	return -1;
 }
-- 
2.18.0
