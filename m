Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:36545 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbbKRF7m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 00:59:42 -0500
Received: by lbblt2 with SMTP id lt2so18431292lbb.3
        for <linux-wireless@vger.kernel.org>; Tue, 17 Nov 2015 21:59:40 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 9/9] ath10k: store msdu_id instead of txbuf pointers
Date: Wed, 18 Nov 2015 06:59:23 +0100
Message-Id: <1447826363-16818-10-git-send-email-michal.kazior@tieto.com> (sfid-20151118_065949_593671_0E10745B)
In-Reply-To: <1447826363-16818-1-git-send-email-michal.kazior@tieto.com>
References: <87mvuj585b.fsf@kamboji.qca.qualcomm.com>
 <1447826363-16818-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Txbuf is no longer a DMA pool and can be easily
tracked with a mere msdu_id. This saves 10 bytes
on 64bit systems and 6 bytes on 32bit systems of
precious sk_buff control buffer.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h   |  6 +---
 drivers/net/wireless/ath/ath10k/htt_tx.c | 55 ++++++++++++++++----------------
 2 files changed, 28 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 75dee79ec206..ec19260bf5d1 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -93,12 +93,8 @@ struct ath10k_skb_cb {
 	dma_addr_t paddr;
 	u8 flags;
 	u8 eid;
+	u16 msdu_id;
 	struct ieee80211_vif *vif;
-
-	struct {
-		struct ath10k_htt_txbuf *txbuf;
-		u32 txbuf_paddr;
-	} __packed htt;
 } __packed;
 
 struct ath10k_skb_rxcb {
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 23e047b0aca3..5274f5bb0b45 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -539,8 +539,6 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	memcpy(cmd->mgmt_tx.hdr, msdu->data,
 	       min_t(int, msdu->len, HTT_MGMT_FRM_HDR_DOWNLOAD_LEN));
 
-	skb_cb->htt.txbuf = NULL;
-
 	res = ath10k_htc_send(&htt->ar->htc, htt->eid, txdesc);
 	if (res)
 		goto err_unmap_msdu;
@@ -570,6 +568,7 @@ int ath10k_htt_tx(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txmode,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(msdu);
 	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(msdu);
 	struct ath10k_hif_sg_item sg_items[2];
+	struct ath10k_htt_txbuf *txbuf;
 	struct htt_data_tx_desc_frag *frags;
 	bool is_eth = (txmode == ATH10K_HW_TXRX_ETHERNET);
 	u8 vdev_id = ath10k_htt_tx_get_vdev_id(ar, msdu);
@@ -580,6 +579,7 @@ int ath10k_htt_tx(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txmode,
 	u16 msdu_id, flags1 = 0;
 	u16 freq = 0;
 	u32 frags_paddr = 0;
+	u32 txbuf_paddr;
 	struct htt_msdu_ext_desc *ext_desc = NULL;
 	bool limit_mgmt_desc = false;
 	bool is_probe_resp = false;
@@ -607,9 +607,9 @@ int ath10k_htt_tx(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txmode,
 	prefetch_len = min(htt->prefetch_len, msdu->len);
 	prefetch_len = roundup(prefetch_len, 4);
 
-	skb_cb->htt.txbuf = &htt->txbuf.vaddr[msdu_id];
-	skb_cb->htt.txbuf_paddr = htt->txbuf.paddr +
-		(sizeof(struct ath10k_htt_txbuf) * msdu_id);
+	txbuf = &htt->txbuf.vaddr[msdu_id];
+	txbuf_paddr = htt->txbuf.paddr +
+		      (sizeof(struct ath10k_htt_txbuf) * msdu_id);
 
 	if ((ieee80211_is_action(hdr->frame_control) ||
 	     ieee80211_is_deauth(hdr->frame_control) ||
@@ -653,14 +653,14 @@ int ath10k_htt_tx(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txmode,
 			frags_paddr =  htt->frag_desc.paddr +
 				(sizeof(struct htt_msdu_ext_desc) * msdu_id);
 		} else {
-			frags = skb_cb->htt.txbuf->frags;
+			frags = txbuf->frags;
 			frags[0].dword_addr.paddr =
 				__cpu_to_le32(skb_cb->paddr);
 			frags[0].dword_addr.len = __cpu_to_le32(msdu->len);
 			frags[1].dword_addr.paddr = 0;
 			frags[1].dword_addr.len = 0;
 
-			frags_paddr = skb_cb->htt.txbuf_paddr;
+			frags_paddr = txbuf_paddr;
 		}
 		flags0 |= SM(txmode, HTT_DATA_TX_DESC_FLAGS0_PKT_TYPE);
 		break;
@@ -689,12 +689,11 @@ int ath10k_htt_tx(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txmode,
 	 * avoid extra memory allocations, compress data structures and thus
 	 * improve performance. */
 
-	skb_cb->htt.txbuf->htc_hdr.eid = htt->eid;
-	skb_cb->htt.txbuf->htc_hdr.len = __cpu_to_le16(
-			sizeof(skb_cb->htt.txbuf->cmd_hdr) +
-			sizeof(skb_cb->htt.txbuf->cmd_tx) +
-			prefetch_len);
-	skb_cb->htt.txbuf->htc_hdr.flags = 0;
+	txbuf->htc_hdr.eid = htt->eid;
+	txbuf->htc_hdr.len = __cpu_to_le16(sizeof(txbuf->cmd_hdr) +
+					   sizeof(txbuf->cmd_tx) +
+					   prefetch_len);
+	txbuf->htc_hdr.flags = 0;
 
 	if (skb_cb->flags & ATH10K_SKB_F_NO_HWCRYPT)
 		flags0 |= HTT_DATA_TX_DESC_FLAGS0_NO_ENCRYPT;
@@ -715,19 +714,19 @@ int ath10k_htt_tx(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txmode,
 	 */
 	flags1 |= HTT_DATA_TX_DESC_FLAGS1_POSTPONED;
 
-	skb_cb->htt.txbuf->cmd_hdr.msg_type = HTT_H2T_MSG_TYPE_TX_FRM;
-	skb_cb->htt.txbuf->cmd_tx.flags0 = flags0;
-	skb_cb->htt.txbuf->cmd_tx.flags1 = __cpu_to_le16(flags1);
-	skb_cb->htt.txbuf->cmd_tx.len = __cpu_to_le16(msdu->len);
-	skb_cb->htt.txbuf->cmd_tx.id = __cpu_to_le16(msdu_id);
-	skb_cb->htt.txbuf->cmd_tx.frags_paddr = __cpu_to_le32(frags_paddr);
+	txbuf->cmd_hdr.msg_type = HTT_H2T_MSG_TYPE_TX_FRM;
+	txbuf->cmd_tx.flags0 = flags0;
+	txbuf->cmd_tx.flags1 = __cpu_to_le16(flags1);
+	txbuf->cmd_tx.len = __cpu_to_le16(msdu->len);
+	txbuf->cmd_tx.id = __cpu_to_le16(msdu_id);
+	txbuf->cmd_tx.frags_paddr = __cpu_to_le32(frags_paddr);
 	if (ath10k_mac_tx_frm_has_freq(ar)) {
-		skb_cb->htt.txbuf->cmd_tx.offchan_tx.peerid =
+		txbuf->cmd_tx.offchan_tx.peerid =
 				__cpu_to_le16(HTT_INVALID_PEERID);
-		skb_cb->htt.txbuf->cmd_tx.offchan_tx.freq =
+		txbuf->cmd_tx.offchan_tx.freq =
 				__cpu_to_le16(freq);
 	} else {
-		skb_cb->htt.txbuf->cmd_tx.peerid =
+		txbuf->cmd_tx.peerid =
 				__cpu_to_le32(HTT_INVALID_PEERID);
 	}
 
@@ -743,12 +742,12 @@ int ath10k_htt_tx(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txmode,
 
 	sg_items[0].transfer_id = 0;
 	sg_items[0].transfer_context = NULL;
-	sg_items[0].vaddr = &skb_cb->htt.txbuf->htc_hdr;
-	sg_items[0].paddr = skb_cb->htt.txbuf_paddr +
-			    sizeof(skb_cb->htt.txbuf->frags);
-	sg_items[0].len = sizeof(skb_cb->htt.txbuf->htc_hdr) +
-			  sizeof(skb_cb->htt.txbuf->cmd_hdr) +
-			  sizeof(skb_cb->htt.txbuf->cmd_tx);
+	sg_items[0].vaddr = &txbuf->htc_hdr;
+	sg_items[0].paddr = txbuf_paddr +
+			    sizeof(txbuf->frags);
+	sg_items[0].len = sizeof(txbuf->htc_hdr) +
+			  sizeof(txbuf->cmd_hdr) +
+			  sizeof(txbuf->cmd_tx);
 
 	sg_items[1].transfer_id = 0;
 	sg_items[1].transfer_context = NULL;
-- 
2.1.4

