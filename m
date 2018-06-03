Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:36852 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751159AbeFCSWS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 Jun 2018 14:22:18 -0400
Received: by mail-lf0-f67.google.com with SMTP id u4-v6so21785117lff.3
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jun 2018 11:22:17 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v5 09/12] ath10k: htt: RX ring config HL support
Date: Sun,  3 Jun 2018 20:20:26 +0200
Message-Id: <20180603182029.8914-10-erik.stromdahl@gmail.com> (sfid-20180603_202222_761319_47DF59DC)
In-Reply-To: <20180603182029.8914-1-erik.stromdahl@gmail.com>
References: <20180603182029.8914-1-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Special HTT RX ring config message used by high latency
devices.

The main difference between HL and LL is that HL devices
do not use shared memory between device and host and thus,
no host paddr's are added to the RX config message.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htt_tx.c | 52 ++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 7c7e434fcde5..740e8740844e 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -934,6 +934,57 @@ static int ath10k_htt_send_rx_ring_cfg_64(struct ath10k_htt *htt)
 	return 0;
 }
 
+static int ath10k_htt_send_rx_ring_cfg_hl(struct ath10k_htt *htt)
+{
+	struct ath10k *ar = htt->ar;
+	struct sk_buff *skb;
+	struct htt_cmd *cmd;
+	struct htt_rx_ring_setup_ring32 *ring;
+	const int num_rx_ring = 1;
+	u16 flags;
+	int len;
+	int ret;
+
+	/*
+	 * the HW expects the buffer to be an integral number of 4-byte
+	 * "words"
+	 */
+	BUILD_BUG_ON(!IS_ALIGNED(HTT_RX_BUF_SIZE, 4));
+	BUILD_BUG_ON((HTT_RX_BUF_SIZE & HTT_MAX_CACHE_LINE_SIZE_MASK) != 0);
+
+	len = sizeof(cmd->hdr) + sizeof(cmd->rx_setup_32.hdr)
+	    + (sizeof(*ring) * num_rx_ring);
+	skb = ath10k_htc_alloc_skb(ar, len);
+	if (!skb)
+		return -ENOMEM;
+
+	skb_put(skb, len);
+
+	cmd = (struct htt_cmd *)skb->data;
+	ring = &cmd->rx_setup_32.rings[0];
+
+	cmd->hdr.msg_type = HTT_H2T_MSG_TYPE_RX_RING_CFG;
+	cmd->rx_setup_32.hdr.num_rings = 1;
+
+	flags = 0;
+	flags |= HTT_RX_RING_FLAGS_MSDU_PAYLOAD;
+	flags |= HTT_RX_RING_FLAGS_UNICAST_RX;
+	flags |= HTT_RX_RING_FLAGS_MULTICAST_RX;
+
+	memset(ring, 0, sizeof(*ring));
+	ring->rx_ring_len = __cpu_to_le16(HTT_RX_RING_SIZE_MIN);
+	ring->rx_ring_bufsize = __cpu_to_le16(HTT_RX_BUF_SIZE);
+	ring->flags = __cpu_to_le16(flags);
+
+	ret = ath10k_htc_send(&htt->ar->htc, htt->eid, skb);
+	if (ret) {
+		dev_kfree_skb_any(skb);
+		return ret;
+	}
+
+	return 0;
+}
+
 int ath10k_htt_h2t_aggr_cfg_msg(struct ath10k_htt *htt,
 				u8 max_subfrms_ampdu,
 				u8 max_subfrms_amsdu)
@@ -1569,6 +1620,7 @@ static const struct ath10k_htt_tx_ops htt_tx_ops_64 = {
 };
 
 static const struct ath10k_htt_tx_ops htt_tx_ops_hl = {
+	.htt_send_rx_ring_cfg = ath10k_htt_send_rx_ring_cfg_hl,
 	.htt_send_frag_desc_bank_cfg = ath10k_htt_send_frag_desc_bank_cfg_32,
 };
 
-- 
2.17.0
