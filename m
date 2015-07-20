Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22265 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbbGTMNl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2015 08:13:41 -0400
From: y@vger.kernel.org
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>
Subject: [PATCH] Ath10k: Add TCP/UDP Checksum offload support for QCA99x0
Date: Mon, 20 Jul 2015 17:42:59 +0530
Message-ID: <1437394379-30539-1-git-send-email-y> (sfid-20150720_141345_171210_4E432979)
In-Reply-To: <n>
References: <n>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>

The patch adds support to offload TCP/UDP checksum
calculations for QCA99x0.

Signed-off-by: Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>
---
This patch has dependency with peter oh's htt tx/rx patch set for
QCA99X0 chipset.

 drivers/net/wireless/ath/ath10k/htt.h    |   17 ++++++++++++++++-
 drivers/net/wireless/ath/ath10k/htt_tx.c |    4 ++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index e31cd74..551f64b 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -97,10 +97,25 @@ struct htt_data_tx_desc_frag {
 } __packed;
 
 struct htt_msdu_ext_desc {
-	__le32 tso_flag[4];
+	__le32 tso_flag[3];
+	__le16 ip_identification;
+	u8 flags;
+	u8 reserved;
 	struct htt_data_tx_desc_frag frags[6];
 };
 
+#define	HTT_MSDU_EXT_DESC_FLAG_IPV4_CSUM_ENABLE		BIT(0)
+#define	HTT_MSDU_EXT_DESC_FLAG_UDP_IPV4_CSUM_ENABLE	BIT(1)
+#define	HTT_MSDU_EXT_DESC_FLAG_UDP_IPV6_CSUM_ENABLE	BIT(2)
+#define	HTT_MSDU_EXT_DESC_FLAG_TCP_IPV4_CSUM_ENABLE	BIT(3)
+#define	HTT_MSDU_EXT_DESC_FLAG_TCP_IPV6_CSUM_ENABLE	BIT(4)
+
+#define HTT_MSDU_CHECKSUM_ENABLE (HTT_MSDU_EXT_DESC_FLAG_IPV4_CSUM_ENABLE \
+				 | HTT_MSDU_EXT_DESC_FLAG_UDP_IPV4_CSUM_ENABLE \
+				 | HTT_MSDU_EXT_DESC_FLAG_UDP_IPV6_CSUM_ENABLE \
+				 | HTT_MSDU_EXT_DESC_FLAG_TCP_IPV4_CSUM_ENABLE \
+				 | HTT_MSDU_EXT_DESC_FLAG_TCP_IPV6_CSUM_ENABLE)
+
 enum htt_data_tx_desc_flags0 {
 	HTT_DATA_TX_DESC_FLAGS0_MAC_HDR_PRESENT = 1 << 0,
 	HTT_DATA_TX_DESC_FLAGS0_NO_AGGR         = 1 << 1,
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index c49ecff..1b34c13 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -496,6 +496,7 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	u16 msdu_id, flags1 = 0;
 	dma_addr_t paddr = 0;
 	u32 frags_paddr = 0;
+	struct htt_msdu_ext_desc *ext_desc = NULL;
 
 	res = ath10k_htt_tx_inc_pending(htt);
 	if (res)
@@ -542,6 +543,7 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 		if (ar->hw_params.continuous_frag_desc) {
 			frags = (struct htt_data_tx_desc_frag *)
 				&htt->frag_desc.vaddr[msdu_id].frags;
+			ext_desc = &htt->frag_desc.vaddr[msdu_id];
 			frags[0].tword_addr.paddr_lo =
 				__cpu_to_le32(skb_cb->paddr);
 			frags[0].tword_addr.paddr_hi = 0;
@@ -603,6 +605,8 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	if (msdu->ip_summed == CHECKSUM_PARTIAL) {
 		flags1 |= HTT_DATA_TX_DESC_FLAGS1_CKSUM_L3_OFFLOAD;
 		flags1 |= HTT_DATA_TX_DESC_FLAGS1_CKSUM_L4_OFFLOAD;
+		if (ar->hw_params.continuous_frag_desc)
+			ext_desc->flags |= HTT_MSDU_CHECKSUM_ENABLE;
 	}
 
 	/* Prevent firmware from sending up tx inspection requests. There's
-- 
1.7.9.5

