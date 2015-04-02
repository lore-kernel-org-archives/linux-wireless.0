Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64527 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbbDBGl2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:41:28 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/31] iwlwifi: pcie: add rx packet sequence number to dbg print
Date: Thu,  2 Apr 2015 09:40:51 +0300
Message-Id: <1427956879-11725-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_084131_261528_021DBE8B)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

For each RX packet until this patch there only was a debug
print of the HCMD and the offset. This adds also the
sequence number of the packet for easier matching between
what was sent, what came back / was received, and what
got stuck somewhere and was never responded by the FW.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 7b7e2f2..7ff69c6 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -600,9 +600,11 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 		if (pkt->len_n_flags == cpu_to_le32(FH_RSCSR_FRAME_INVALID))
 			break;
 
-		IWL_DEBUG_RX(trans, "cmd at offset %d: %s (0x%.2x)\n",
-			rxcb._offset, get_cmd_string(trans_pcie, pkt->hdr.cmd),
-			pkt->hdr.cmd);
+		IWL_DEBUG_RX(trans,
+			     "cmd at offset %d: %s (0x%.2x, seq 0x%x)\n",
+			     rxcb._offset,
+			     get_cmd_string(trans_pcie, pkt->hdr.cmd),
+			     pkt->hdr.cmd, le16_to_cpu(pkt->hdr.sequence));
 
 		len = iwl_rx_packet_len(pkt);
 		len += sizeof(u32); /* account for status word */
-- 
1.9.1

