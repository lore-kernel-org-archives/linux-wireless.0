Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34834 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751186AbdFYLMH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Jun 2017 07:12:07 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 25 Jun 2017 14:11:33 +0300
Message-Id: <20170625111158.1792-2-luca@coelho.fi> (sfid-20170625_131216_565089_072C6D2C)
In-Reply-To: <20170625111158.1792-1-luca@coelho.fi>
References: <20170625111158.1792-1-luca@coelho.fi>
Subject: [PATCH 01/26] iwlwifi: simplify data tracepoint
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to calculate the data_len outside of the tracepoint,
since it's always skb->len - hdr_len, which are both available inside.
Simplify the callers and move the calculation in.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace-data.h | 11 ++++++-----
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c      |  3 +--
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c           |  3 +--
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-data.h b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-data.h
index d80312b46f16..a80e4202cd03 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-data.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-data.h
@@ -35,19 +35,20 @@
 
 TRACE_EVENT(iwlwifi_dev_tx_data,
 	TP_PROTO(const struct device *dev,
-		 struct sk_buff *skb,
-		 u8 hdr_len, size_t data_len),
-	TP_ARGS(dev, skb, hdr_len, data_len),
+		 struct sk_buff *skb, u8 hdr_len),
+	TP_ARGS(dev, skb, hdr_len),
 	TP_STRUCT__entry(
 		DEV_ENTRY
 
-		__dynamic_array(u8, data, iwl_trace_data(skb) ? data_len : 0)
+		__dynamic_array(u8, data,
+				iwl_trace_data(skb) ? skb->len - hdr_len : 0)
 	),
 	TP_fast_assign(
 		DEV_ASSIGN;
 		if (iwl_trace_data(skb))
 			skb_copy_bits(skb, hdr_len,
-				      __get_dynamic_array(data), data_len);
+				      __get_dynamic_array(data),
+				      skb->len - hdr_len);
 	),
 	TP_printk("[%s] TX frame data", __get_str(dev))
 );
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 464a435a4440..a0b237b58b3d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -469,8 +469,7 @@ struct iwl_tfh_tfd *iwl_pcie_gen2_build_tfd(struct iwl_trans *trans,
 	trace_iwlwifi_dev_tx(trans->dev, skb, tfd, sizeof(*tfd), &dev_cmd->hdr,
 			     IWL_FIRST_TB_SIZE + tb1_len,
 			     skb->data + hdr_len, tb2_len);
-	trace_iwlwifi_dev_tx_data(trans->dev, skb, hdr_len,
-				  skb->len - hdr_len);
+	trace_iwlwifi_dev_tx_data(trans->dev, skb, hdr_len);
 
 	return tfd;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 0a6e36a8a0bf..98cccaeeecdd 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1979,8 +1979,7 @@ static int iwl_fill_data_tbs(struct iwl_trans *trans, struct sk_buff *skb,
 			     trans_pcie->tfd_size,
 			     &dev_cmd->hdr, IWL_FIRST_TB_SIZE + tb1_len,
 			     skb->data + hdr_len, tb2_len);
-	trace_iwlwifi_dev_tx_data(trans->dev, skb,
-				  hdr_len, skb->len - hdr_len);
+	trace_iwlwifi_dev_tx_data(trans->dev, skb, hdr_len);
 	return 0;
 }
 
-- 
2.11.0
