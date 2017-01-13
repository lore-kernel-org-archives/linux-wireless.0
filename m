Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:36264 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751315AbdAMVfb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:35:31 -0500
Received: by mail-lf0-f65.google.com with SMTP id h65so7043352lfi.3
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jan 2017 13:35:31 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC 09/10] ath10k: htt: High latency TX support
Date: Fri, 13 Jan 2017 22:35:08 +0100
Message-Id: <1484343309-6327-10-git-send-email-erik.stromdahl@gmail.com> (sfid-20170113_223542_519235_9BCDEE1D)
In-Reply-To: <1484343309-6327-1-git-send-email-erik.stromdahl@gmail.com>
References: <1484343309-6327-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add HTT TX function for HL interfaces.
Intended for SDIO and USB.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htt.h    |  9 ++--
 drivers/net/wireless/ath/ath10k/htt_tx.c | 72 +++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/mac.c    |  5 ++-
 3 files changed, 80 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index dd9e582..d40b3a0 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1826,9 +1826,12 @@ int ath10k_htt_tx_mgmt_inc_pending(struct ath10k_htt *htt, bool is_mgmt,
 int ath10k_htt_tx_alloc_msdu_id(struct ath10k_htt *htt, struct sk_buff *skb);
 void ath10k_htt_tx_free_msdu_id(struct ath10k_htt *htt, u16 msdu_id);
 int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *);
-int ath10k_htt_tx(struct ath10k_htt *htt,
-		  enum ath10k_hw_txrx_mode txmode,
-		  struct sk_buff *msdu);
+int ath10k_htt_tx_ll(struct ath10k_htt *htt,
+		     enum ath10k_hw_txrx_mode txmode,
+		     struct sk_buff *msdu);
+int ath10k_htt_tx_hl(struct ath10k_htt *htt,
+		     enum ath10k_hw_txrx_mode txmode,
+		     struct sk_buff *msdu);
 void ath10k_htt_rx_pktlog_completion_handler(struct ath10k *ar,
 					     struct sk_buff *skb);
 int ath10k_htt_txrx_compl_task(struct ath10k *ar, int budget);
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 505d3ed..e64c249 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -945,8 +945,76 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	return res;
 }
 
-int ath10k_htt_tx(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txmode,
-		  struct sk_buff *msdu)
+#define HTT_TX_HL_NEEDED_HEADROOM \
+	(unsigned int)(sizeof(struct htt_cmd_hdr) + \
+	sizeof(struct htt_data_tx_desc) + \
+	sizeof(struct ath10k_htc_hdr))
+
+int ath10k_htt_tx_hl(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txmode,
+		     struct sk_buff *msdu)
+{
+	struct ath10k *ar = htt->ar;
+	int res, data_len;
+	struct htt_cmd_hdr *cmd_hdr;
+	struct htt_data_tx_desc *tx_desc;
+	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(msdu);
+	u8 flags0;
+	u16 flags1 = 0;
+
+	data_len = msdu->len;
+	flags0 = SM(txmode, HTT_DATA_TX_DESC_FLAGS0_PKT_TYPE);
+
+	if (skb_cb->flags & ATH10K_SKB_F_NO_HWCRYPT)
+		flags0 |= HTT_DATA_TX_DESC_FLAGS0_NO_ENCRYPT;
+
+	if (msdu->ip_summed == CHECKSUM_PARTIAL &&
+	    !test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags)) {
+		flags1 |= HTT_DATA_TX_DESC_FLAGS1_CKSUM_L3_OFFLOAD;
+		flags1 |= HTT_DATA_TX_DESC_FLAGS1_CKSUM_L4_OFFLOAD;
+	}
+
+	/* Prepend the HTT header and TX desc struct to the data message
+	 * and realloc the skb if it does not have enough headroom.
+	 */
+	if (skb_headroom(msdu) < HTT_TX_HL_NEEDED_HEADROOM) {
+		struct sk_buff *tmp_skb = msdu;
+
+		ath10k_dbg(htt->ar, ATH10K_DBG_HTT,
+			   "Not enough headroom in skb. Current headroom: %u, needed: %u. Reallocating...\n",
+			   skb_headroom(msdu), HTT_TX_HL_NEEDED_HEADROOM);
+		msdu = skb_realloc_headroom(msdu, HTT_TX_HL_NEEDED_HEADROOM);
+		kfree_skb(tmp_skb);
+		if (!msdu) {
+			ath10k_warn(htt->ar, "htt hl tx: Unable to realloc skb!\n");
+			res = -ENOMEM;
+			goto out;
+		}
+	}
+
+	skb_push(msdu, sizeof(*cmd_hdr));
+	skb_push(msdu, sizeof(*tx_desc));
+	cmd_hdr = (struct htt_cmd_hdr *)msdu->data;
+	tx_desc = (struct htt_data_tx_desc *)(msdu->data + sizeof(*cmd_hdr));
+
+	cmd_hdr->msg_type = HTT_H2T_MSG_TYPE_TX_FRM;
+	tx_desc->flags0 = flags0;
+	tx_desc->flags1 = __cpu_to_le16(flags1);
+	tx_desc->len = __cpu_to_le16(data_len);
+	tx_desc->id = 0;
+	tx_desc->frags_paddr = 0; /* always zero */
+	/* Initialize peer_id to INVALID_PEER because this is NOT
+	 * Reinjection path
+	 */
+	tx_desc->peerid = __cpu_to_le16(HTT_INVALID_PEERID);
+
+	res = ath10k_htc_send(&htt->ar->htc, htt->eid, msdu);
+
+out:
+	return res;
+}
+
+int ath10k_htt_tx_ll(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txmode,
+		     struct sk_buff *msdu)
 {
 	struct ath10k *ar = htt->ar;
 	struct device *dev = ar->dev;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 28bf199..477e170 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3531,7 +3531,10 @@ static int ath10k_mac_tx_submit(struct ath10k *ar,
 
 	switch (txpath) {
 	case ATH10K_MAC_TX_HTT:
-		ret = ath10k_htt_tx(htt, txmode, skb);
+		if (ar->is_high_latency)
+			ret = ath10k_htt_tx_hl(htt, txmode, skb);
+		else
+			ret = ath10k_htt_tx_ll(htt, txmode, skb);
 		break;
 	case ATH10K_MAC_TX_HTT_MGMT:
 		ret = ath10k_htt_mgmt_tx(htt, skb);
-- 
2.7.4
