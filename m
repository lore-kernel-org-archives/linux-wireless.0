Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35930 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751580AbdF1UOk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 16:14:40 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Jun 2017 23:13:18 +0300
Message-Id: <20170628201330.9432-20-luca@coelho.fi> (sfid-20170628_221455_559124_251646AA)
In-Reply-To: <20170628201330.9432-1-luca@coelho.fi>
References: <20170628201330.9432-1-luca@coelho.fi>
Subject: [PATCH 19/31] iwlwifi: pcie: improve debug in iwl_pcie_rx_handle_rb()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Print the queue for the existing debug message and add a new
debug message indicating where the RB ended.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 6544facc2e0c..1618a59a8a2f 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1126,8 +1126,12 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 
 		pkt = rxb_addr(&rxcb);
 
-		if (pkt->len_n_flags == cpu_to_le32(FH_RSCSR_FRAME_INVALID))
+		if (pkt->len_n_flags == cpu_to_le32(FH_RSCSR_FRAME_INVALID)) {
+			IWL_DEBUG_RX(trans,
+				     "Q %d: RB end marker at offset %d\n",
+				     rxq->id, offset);
 			break;
+		}
 
 		WARN((le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_RXQ_MASK) >>
 			FH_RSCSR_RXQ_POS != rxq->id,
@@ -1137,8 +1141,8 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 			FH_RSCSR_RXQ_POS);
 
 		IWL_DEBUG_RX(trans,
-			     "cmd at offset %d: %s (%.2x.%2x, seq 0x%x)\n",
-			     rxcb._offset,
+			     "Q %d: cmd at offset %d: %s (%.2x.%2x, seq 0x%x)\n",
+			     rxq->id, offset,
 			     iwl_get_cmd_string(trans,
 						iwl_cmd_id(pkt->hdr.cmd,
 							   pkt->hdr.group_id,
-- 
2.11.0
