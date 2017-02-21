Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34277 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753744AbdBUQQ1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 11:16:27 -0500
Received: by mail-lf0-f65.google.com with SMTP id h67so3752329lfg.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2017 08:16:26 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v4 14/21] ath10k: htt: RX ring config HL support
Date: Tue, 21 Feb 2017 17:15:34 +0100
Message-Id: <1487693741-10042-15-git-send-email-erik.stromdahl@gmail.com> (sfid-20170221_172342_329379_FA66F24E)
In-Reply-To: <1487693741-10042-1-git-send-email-erik.stromdahl@gmail.com>
References: <1487693741-10042-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Special HTT RX ring config message used by high latency
devices.

The main difference between HL and LL is that HL devices
do not use shared memory between device and host and thus,
no host paddr's are added to the RX config message.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htt.c    |  5 +++-
 drivers/net/wireless/ath/ath10k/htt.h    |  1 +
 drivers/net/wireless/ath/ath10k/htt_tx.c | 51 ++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.c b/drivers/net/wireless/ath/ath10k/htt.c
index cd160b1..29ed4af 100644
--- a/drivers/net/wireless/ath/ath10k/htt.c
+++ b/drivers/net/wireless/ath/ath10k/htt.c
@@ -258,7 +258,10 @@ int ath10k_htt_setup(struct ath10k_htt *htt)
 	if (status)
 		return status;
 
-	status = ath10k_htt_send_rx_ring_cfg_ll(htt);
+	if (ar->is_high_latency)
+		status = ath10k_htt_send_rx_ring_cfg_hl(htt);
+	else
+		status = ath10k_htt_send_rx_ring_cfg_ll(htt);
 	if (status) {
 		ath10k_warn(ar, "failed to setup rx ring: %d\n",
 			    status);
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 90c2f72..bdee2e7 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1797,6 +1797,7 @@ int ath10k_htt_h2t_ver_req_msg(struct ath10k_htt *htt);
 int ath10k_htt_h2t_stats_req(struct ath10k_htt *htt, u8 mask, u64 cookie);
 int ath10k_htt_send_frag_desc_bank_cfg(struct ath10k_htt *htt);
 int ath10k_htt_send_rx_ring_cfg_ll(struct ath10k_htt *htt);
+int ath10k_htt_send_rx_ring_cfg_hl(struct ath10k_htt *htt);
 int ath10k_htt_h2t_aggr_cfg_msg(struct ath10k_htt *htt,
 				u8 max_subfrms_ampdu,
 				u8 max_subfrms_amsdu);
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 86b427f..ca899e1 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -692,6 +692,57 @@ int ath10k_htt_send_rx_ring_cfg_ll(struct ath10k_htt *htt)
 	return 0;
 }
 
+int ath10k_htt_send_rx_ring_cfg_hl(struct ath10k_htt *htt)
+{
+	struct ath10k *ar = htt->ar;
+	struct sk_buff *skb;
+	struct htt_cmd *cmd;
+	struct htt_rx_ring_setup_ring *ring;
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
+	len = sizeof(cmd->hdr) + sizeof(cmd->rx_setup.hdr)
+	    + (sizeof(*ring) * num_rx_ring);
+	skb = ath10k_htc_alloc_skb(ar, len);
+	if (!skb)
+		return -ENOMEM;
+
+	skb_put(skb, len);
+
+	cmd = (struct htt_cmd *)skb->data;
+	ring = &cmd->rx_setup.rings[0];
+
+	cmd->hdr.msg_type = HTT_H2T_MSG_TYPE_RX_RING_CFG;
+	cmd->rx_setup.hdr.num_rings = 1;
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
-- 
2.7.4
