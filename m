Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:1352 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970AbbGGQvI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2015 12:51:08 -0400
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] ath10k: update tx path to support QCA99X0
Date: Tue, 7 Jul 2015 09:47:54 -0700
Message-ID: <1436287676-25767-2-git-send-email-poh@qca.qualcomm.com> (sfid-20150707_185114_648264_E5BB7B22)
In-Reply-To: <1436287676-25767-1-git-send-email-poh@qca.qualcomm.com>
References: <1436287676-25767-1-git-send-email-poh@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since QCA99X0 uses fragmentation descriptor differently from
other ones on tx path, we need to handle it separately.

QCA99X0 is using 48 bits for address and 16 bits for length
out of 2 dword and each values have to be programmed by frag
desc base addr + msdu id, so that hardware can retrieve
corresponding frag data.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt.h    | 13 +++++++++++--
 drivers/net/wireless/ath/ath10k/htt_tx.c | 29 +++++++++++++++++++++--------
 2 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 8bdf1e7..e31cd74 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -83,8 +83,17 @@ struct htt_ver_req {
  * around the mask + shift defs.
  */
 struct htt_data_tx_desc_frag {
-	__le32 paddr;
-	__le32 len;
+	union {
+		struct double_word_addr {
+			__le32 paddr;
+			__le32 len;
+		} __packed dword_addr;
+		struct triple_word_addr {
+			__le32 paddr_lo;
+			__le16 paddr_hi;
+			__le16 len_16;
+		} __packed tword_addr;
+	} __packed;
 } __packed;
 
 struct htt_msdu_ext_desc {
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 148d5b6..2b4fdf6 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -63,7 +63,8 @@ int ath10k_htt_tx_alloc_msdu_id(struct ath10k_htt *htt, struct sk_buff *skb)
 
 	lockdep_assert_held(&htt->tx_lock);
 
-	ret = idr_alloc(&htt->pending_tx, skb, 0, 0x10000, GFP_ATOMIC);
+	ret = idr_alloc(&htt->pending_tx, skb, 0,
+			htt->max_num_pending_tx, GFP_ATOMIC);
 
 	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt tx alloc msdu_id %d\n", ret);
 
@@ -259,6 +260,7 @@ int ath10k_htt_send_frag_desc_bank_cfg(struct ath10k_htt *htt)
 	cmd->frag_desc_bank_cfg.desc_size = sizeof(struct htt_msdu_ext_desc);
 	cmd->frag_desc_bank_cfg.bank_base_addrs[0] =
 				__cpu_to_le32(htt->frag_desc.paddr);
+	cmd->frag_desc_bank_cfg.bank_id[0].bank_min_id = 0;
 	cmd->frag_desc_bank_cfg.bank_id[0].bank_max_id =
 				__cpu_to_le16(htt->max_num_pending_tx - 1);
 
@@ -537,16 +539,27 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 		flags0 |= HTT_DATA_TX_DESC_FLAGS0_MAC_HDR_PRESENT;
 		/* pass through */
 	case ATH10K_HW_TXRX_ETHERNET:
-		frags = skb_cb->htt.txbuf->frags;
+		if (ar->hw_params.continuous_frag_desc) {
+			frags = (struct htt_data_tx_desc_frag *)
+				&htt->frag_desc.vaddr[msdu_id].frags;
+			frags[0].tword_addr.paddr_lo = __cpu_to_le32(skb_cb->paddr);
+			frags[0].tword_addr.paddr_hi = 0;
+			frags[0].tword_addr.len_16 = __cpu_to_le32(msdu->len);
+			frags[1].tword_addr.paddr_lo = 0;
+			frags[1].tword_addr.paddr_hi = 0;
 
-		frags[0].paddr = __cpu_to_le32(skb_cb->paddr);
-		frags[0].len = __cpu_to_le32(msdu->len);
-		frags[1].paddr = 0;
-		frags[1].len = 0;
+			frags_paddr =  htt->frag_desc.paddr +
+				(sizeof(struct htt_msdu_ext_desc) * msdu_id);
+		} else {
+			frags = skb_cb->htt.txbuf->frags;
+			frags[0].dword_addr.paddr = __cpu_to_le32(skb_cb->paddr);
+			frags[0].dword_addr.len = __cpu_to_le32(msdu->len);
+			frags[1].dword_addr.paddr = 0;
+			frags[1].dword_addr.len = 0;
 
+			frags_paddr = skb_cb->htt.txbuf_paddr;
+		}
 		flags0 |= SM(skb_cb->txmode, HTT_DATA_TX_DESC_FLAGS0_PKT_TYPE);
-
-		frags_paddr = skb_cb->htt.txbuf_paddr;
 		break;
 	case ATH10K_HW_TXRX_MGMT:
 		flags0 |= SM(ATH10K_HW_TXRX_MGMT,
-- 
1.9.1

