Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:50773 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbbGWXdI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2015 19:33:08 -0400
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath10k: initialize msdu ext. descriptor before use
Date: Thu, 23 Jul 2015 16:32:06 -0700
Message-ID: <1437694326-31977-1-git-send-email-poh@qca.qualcomm.com> (sfid-20150724_013312_165079_D563CDAC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initial QCA99X0 support has a known issue with TCP Tx throughput.
All other path such as UDP Tx/Rx and TCP Rx meet their expectation
(> 900Mbps), but TCP Tx marked as low as 5Mbps when single pair is
used on iperf.

The root cause is turned out because TSO flag is not initialized
properly so that firmware configures TSO in wrong way.
TSO flags in msdu extension descriptor is required to be reset
to indicate firmware there is no TSO is enabled, otherwise it
could act as TSO is enabled which causes huge throughput drop.

In fact, it's enough by resetting TSO flags only to prevent the
unexpected behavior, but initializing whole msdu ext. descriptor
will help to clear uncertainty of firmware could bring on as it
constantly updated.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index c49ecff..1c61c17 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -540,14 +540,14 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 		/* pass through */
 	case ATH10K_HW_TXRX_ETHERNET:
 		if (ar->hw_params.continuous_frag_desc) {
+			memset(&htt->frag_desc.vaddr[msdu_id], 0,
+			       sizeof(struct htt_msdu_ext_desc));
 			frags = (struct htt_data_tx_desc_frag *)
 				&htt->frag_desc.vaddr[msdu_id].frags;
 			frags[0].tword_addr.paddr_lo =
 				__cpu_to_le32(skb_cb->paddr);
 			frags[0].tword_addr.paddr_hi = 0;
 			frags[0].tword_addr.len_16 = __cpu_to_le16(msdu->len);
-			frags[1].tword_addr.paddr_lo = 0;
-			frags[1].tword_addr.paddr_hi = 0;
 
 			frags_paddr =  htt->frag_desc.paddr +
 				(sizeof(struct htt_msdu_ext_desc) * msdu_id);
-- 
1.9.1

