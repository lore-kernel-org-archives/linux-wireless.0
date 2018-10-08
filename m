Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA803C64EB8
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:17:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0ACA2087C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:17:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0ACA2087C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbeJHP2P (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 11:28:15 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:56294 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726451AbeJHP2P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 11:28:15 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g9QjW-0003w6-PZ; Mon, 08 Oct 2018 11:17:43 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  8 Oct 2018 11:17:20 +0300
Message-Id: <20181008081735.3401-4-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181008081735.3401-1-luca@coelho.fi>
References: <20181008081735.3401-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 03/18] iwlwifi: trace: change trace to trace one TB at a time
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Split TX tracing to be per TB. This is needed now that
AMSDUs can be sent and skb can be larger than trace
limit.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../intel/iwlwifi/iwl-devtrace-data.h         | 30 ++++---------------
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 18 ++++++-----
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  | 29 ++++++++++--------
 3 files changed, 34 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-data.h b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-data.h
index 2cc6c019d0e1..420e6d745f77 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-data.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-data.h
@@ -30,38 +30,20 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM iwlwifi_data
 
-TRACE_EVENT(iwlwifi_dev_tx_data,
-	TP_PROTO(const struct device *dev,
-		 struct sk_buff *skb, u8 hdr_len),
-	TP_ARGS(dev, skb, hdr_len),
+TRACE_EVENT(iwlwifi_dev_tx_tb,
+	TP_PROTO(const struct device *dev, struct sk_buff *skb,
+		 u8 *data_src, size_t data_len),
+	TP_ARGS(dev, skb, data_src, data_len),
 	TP_STRUCT__entry(
 		DEV_ENTRY
 
 		__dynamic_array(u8, data,
-				iwl_trace_data(skb) ? skb->len - hdr_len : 0)
+				iwl_trace_data(skb) ? data_len : 0)
 	),
 	TP_fast_assign(
 		DEV_ASSIGN;
 		if (iwl_trace_data(skb))
-			skb_copy_bits(skb, hdr_len,
-				      __get_dynamic_array(data),
-				      skb->len - hdr_len);
-	),
-	TP_printk("[%s] TX frame data", __get_str(dev))
-);
-
-TRACE_EVENT(iwlwifi_dev_tx_tso_chunk,
-	TP_PROTO(const struct device *dev,
-		 u8 *data_src, size_t data_len),
-	TP_ARGS(dev, data_src, data_len),
-	TP_STRUCT__entry(
-		DEV_ENTRY
-
-		__dynamic_array(u8, data, data_len)
-	),
-	TP_fast_assign(
-		DEV_ASSIGN;
-		memcpy(__get_dynamic_array(data), data_src, data_len);
+			memcpy(__get_dynamic_array(data), data_src, data_len);
 	),
 	TP_printk("[%s] TX frame data", __get_str(dev))
 );
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 09cdc15f7645..e880f69eac26 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -330,7 +330,7 @@ static int iwl_pcie_gen2_build_amsdu(struct iwl_trans *trans,
 			goto out_err;
 		}
 		iwl_pcie_gen2_set_tb(trans, tfd, tb_phys, tb_len);
-		trace_iwlwifi_dev_tx_tso_chunk(trans->dev, start_hdr, tb_len);
+		trace_iwlwifi_dev_tx_tb(trans->dev, skb, start_hdr, tb_len);
 		/* add this subframe's headers' length to the tx_cmd */
 		le16_add_cpu(&tx_cmd->len, hdr_page->pos - subf_hdrs_start);
 
@@ -347,8 +347,8 @@ static int iwl_pcie_gen2_build_amsdu(struct iwl_trans *trans,
 				goto out_err;
 			}
 			iwl_pcie_gen2_set_tb(trans, tfd, tb_phys, tb_len);
-			trace_iwlwifi_dev_tx_tso_chunk(trans->dev, tso.data,
-						       tb_len);
+			trace_iwlwifi_dev_tx_tb(trans->dev, skb, tso.data,
+						tb_len);
 
 			data_left -= tb_len;
 			tso_build_data(skb, &tso, tb_len);
@@ -438,6 +438,9 @@ static int iwl_pcie_gen2_tx_add_frags(struct iwl_trans *trans,
 			return -ENOMEM;
 		tb_idx = iwl_pcie_gen2_set_tb(trans, tfd, tb_phys,
 					      skb_frag_size(frag));
+		trace_iwlwifi_dev_tx_tb(trans->dev, skb,
+					skb_frag_address(frag),
+					skb_frag_size(frag));
 		if (tb_idx < 0)
 			return tb_idx;
 
@@ -490,6 +493,8 @@ iwl_tfh_tfd *iwl_pcie_gen2_build_tx(struct iwl_trans *trans,
 	if (unlikely(dma_mapping_error(trans->dev, tb_phys)))
 		goto out_err;
 	iwl_pcie_gen2_set_tb(trans, tfd, tb_phys, tb1_len);
+	trace_iwlwifi_dev_tx(trans->dev, skb, tfd, sizeof(*tfd), &dev_cmd->hdr,
+			     IWL_FIRST_TB_SIZE + tb1_len, hdr_len);
 
 	/* set up TFD's third entry to point to remainder of skb's head */
 	tb2_len = skb_headlen(skb) - hdr_len;
@@ -500,15 +505,14 @@ iwl_tfh_tfd *iwl_pcie_gen2_build_tx(struct iwl_trans *trans,
 		if (unlikely(dma_mapping_error(trans->dev, tb_phys)))
 			goto out_err;
 		iwl_pcie_gen2_set_tb(trans, tfd, tb_phys, tb2_len);
+		trace_iwlwifi_dev_tx_tb(trans->dev, skb,
+					skb->data + hdr_len,
+					tb2_len);
 	}
 
 	if (iwl_pcie_gen2_tx_add_frags(trans, skb, tfd, out_meta))
 		goto out_err;
 
-	trace_iwlwifi_dev_tx(trans->dev, skb, tfd, sizeof(*tfd), &dev_cmd->hdr,
-			     IWL_FIRST_TB_SIZE + tb1_len, hdr_len);
-	trace_iwlwifi_dev_tx_data(trans->dev, skb, hdr_len);
-
 	return tfd;
 
 out_err:
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index f227b91098c9..87b7225fe289 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1994,6 +1994,9 @@ static int iwl_fill_data_tbs(struct iwl_trans *trans, struct sk_buff *skb,
 						    head_tb_len, DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(trans->dev, tb_phys)))
 			return -EINVAL;
+		trace_iwlwifi_dev_tx_tb(trans->dev, skb,
+					skb->data + hdr_len,
+					head_tb_len);
 		iwl_pcie_txq_build_tfd(trans, txq, tb_phys, head_tb_len, false);
 	}
 
@@ -2011,6 +2014,9 @@ static int iwl_fill_data_tbs(struct iwl_trans *trans, struct sk_buff *skb,
 
 		if (unlikely(dma_mapping_error(trans->dev, tb_phys)))
 			return -EINVAL;
+		trace_iwlwifi_dev_tx_tb(trans->dev, skb,
+					skb_frag_address(frag),
+					skb_frag_size(frag));
 		tb_idx = iwl_pcie_txq_build_tfd(trans, txq, tb_phys,
 						skb_frag_size(frag), false);
 		if (tb_idx < 0)
@@ -2190,8 +2196,8 @@ static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 		}
 		iwl_pcie_txq_build_tfd(trans, txq, hdr_tb_phys,
 				       hdr_tb_len, false);
-		trace_iwlwifi_dev_tx_tso_chunk(trans->dev, start_hdr,
-					       hdr_tb_len);
+		trace_iwlwifi_dev_tx_tb(trans->dev, skb, start_hdr,
+					hdr_tb_len);
 		/* add this subframe's headers' length to the tx_cmd */
 		le16_add_cpu(&tx_cmd->len, hdr_page->pos - subf_hdrs_start);
 
@@ -2216,8 +2222,8 @@ static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 
 			iwl_pcie_txq_build_tfd(trans, txq, tb_phys,
 					       size, false);
-			trace_iwlwifi_dev_tx_tso_chunk(trans->dev, tso.data,
-						       size);
+			trace_iwlwifi_dev_tx_tb(trans->dev, skb, tso.data,
+						size);
 
 			data_left -= size;
 			tso_build_data(skb, &tso, size);
@@ -2398,6 +2404,13 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		goto out_err;
 	iwl_pcie_txq_build_tfd(trans, txq, tb1_phys, tb1_len, false);
 
+	trace_iwlwifi_dev_tx(trans->dev, skb,
+			     iwl_pcie_get_tfd(trans, txq,
+					      txq->write_ptr),
+			     trans_pcie->tfd_size,
+			     &dev_cmd->hdr, IWL_FIRST_TB_SIZE + tb1_len,
+			     hdr_len);
+
 	/*
 	 * If gso_size wasn't set, don't give the frame "amsdu treatment"
 	 * (adding subframes, etc.).
@@ -2421,14 +2434,6 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 						       out_meta)))
 				goto out_err;
 		}
-
-		trace_iwlwifi_dev_tx(trans->dev, skb,
-				     iwl_pcie_get_tfd(trans, txq,
-						      txq->write_ptr),
-				     trans_pcie->tfd_size,
-				     &dev_cmd->hdr, IWL_FIRST_TB_SIZE + tb1_len,
-				     hdr_len);
-		trace_iwlwifi_dev_tx_data(trans->dev, skb, hdr_len);
 	}
 
 	/* building the A-MSDU might have changed this data, so memcpy it now */
-- 
2.19.0

