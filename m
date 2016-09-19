Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:55942 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1760357AbcISHbV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 03:31:21 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Sep 2016 10:30:15 +0300
Message-Id: <20160919073028.22065-12-luca@coelho.fi> (sfid-20160919_093136_561513_7B27E0E3)
In-Reply-To: <1474270071.5664.89.camel@coelho.fi>
References: <1474270071.5664.89.camel@coelho.fi>
Subject: [PATCH 12/25] iwlwifi: pcie: log full command sequence
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Log group as well. Remove 0x prefix to match TX logging.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 0b5b331..78cb6d2 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1108,13 +1108,14 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 			FH_RSCSR_RXQ_POS != rxq->id);
 
 		IWL_DEBUG_RX(trans,
-			     "cmd at offset %d: %s (0x%.2x, seq 0x%x)\n",
+			     "cmd at offset %d: %s (%.2x.%2x, seq 0x%x)\n",
 			     rxcb._offset,
 			     iwl_get_cmd_string(trans,
 						iwl_cmd_id(pkt->hdr.cmd,
 							   pkt->hdr.group_id,
 							   0)),
-			     pkt->hdr.cmd, le16_to_cpu(pkt->hdr.sequence));
+			     pkt->hdr.group_id, pkt->hdr.cmd,
+			     le16_to_cpu(pkt->hdr.sequence));
 
 		len = iwl_rx_packet_len(pkt);
 		len += sizeof(u32); /* account for status word */
-- 
2.9.3
