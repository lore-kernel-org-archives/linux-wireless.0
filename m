Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60670 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751125AbdFBJ75 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 05:59:57 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Jun 2017 12:35:16 +0300
Message-Id: <20170602093516.16369-11-luca@coelho.fi> (sfid-20170602_120001_294422_0CE22D1B)
In-Reply-To: <20170602093516.16369-1-luca@coelho.fi>
References: <20170602093516.16369-1-luca@coelho.fi>
Subject: [PATCH 10/10] iwlwifi: fix host command memory leaks
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Sending host command with CMD_WANT_SKB flag demands the release of the
response buffer with iwl_free_resp function.
The patch adds the memory release in all the relevant places

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 9fb46a6f47cf..9c9bfbbabdf1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -906,7 +906,7 @@ int iwl_trans_pcie_dyn_txq_alloc(struct iwl_trans *trans,
 
 	if (WARN_ON(iwl_rx_packet_payload_len(hcmd.resp_pkt) != sizeof(*rsp))) {
 		ret = -EINVAL;
-		goto error;
+		goto error_free_resp;
 	}
 
 	rsp = (void *)hcmd.resp_pkt->data;
@@ -915,13 +915,13 @@ int iwl_trans_pcie_dyn_txq_alloc(struct iwl_trans *trans,
 	if (qid > ARRAY_SIZE(trans_pcie->txq)) {
 		WARN_ONCE(1, "queue index %d unsupported", qid);
 		ret = -EIO;
-		goto error;
+		goto error_free_resp;
 	}
 
 	if (test_and_set_bit(qid, trans_pcie->queue_used)) {
 		WARN_ONCE(1, "queue %d already used", qid);
 		ret = -EIO;
-		goto error;
+		goto error_free_resp;
 	}
 
 	txq->id = qid;
@@ -934,8 +934,11 @@ int iwl_trans_pcie_dyn_txq_alloc(struct iwl_trans *trans,
 			   (txq->write_ptr) | (qid << 16));
 	IWL_DEBUG_TX_QUEUES(trans, "Activate queue %d\n", qid);
 
+	iwl_free_resp(&hcmd);
 	return qid;
 
+error_free_resp:
+	iwl_free_resp(&hcmd);
 error:
 	iwl_pcie_gen2_txq_free_memory(trans, txq);
 	return ret;
-- 
2.11.0
