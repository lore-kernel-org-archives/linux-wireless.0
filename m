Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35968 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751557AbdF1UPO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 16:15:14 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Jun 2017 23:13:16 +0300
Message-Id: <20170628201330.9432-18-luca@coelho.fi> (sfid-20170628_221555_076191_E75CD59B)
In-Reply-To: <20170628201330.9432-1-luca@coelho.fi>
References: <20170628201330.9432-1-luca@coelho.fi>
Subject: [PATCH 17/31] iwlwifi: pcie: improve "invalid queue" warning
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Print out both queue IDs to be able to see what went wrong.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index cd109740632d..6544facc2e0c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1129,8 +1129,12 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 		if (pkt->len_n_flags == cpu_to_le32(FH_RSCSR_FRAME_INVALID))
 			break;
 
-		WARN_ON((le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_RXQ_MASK) >>
-			FH_RSCSR_RXQ_POS != rxq->id);
+		WARN((le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_RXQ_MASK) >>
+			FH_RSCSR_RXQ_POS != rxq->id,
+		     "frame on invalid queue - is on %d and indicates %d\n",
+		     rxq->id,
+		     (le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_RXQ_MASK) >>
+			FH_RSCSR_RXQ_POS);
 
 		IWL_DEBUG_RX(trans,
 			     "cmd at offset %d: %s (%.2x.%2x, seq 0x%x)\n",
-- 
2.11.0
