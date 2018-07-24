Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:42741 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388424AbeGXIt6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 04:49:58 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, Gidon Studinski <gidons@codeaurora.org>
Subject: [PATCH v2 05/19] wil6210: fix RX checksum report to network stack
Date: Tue, 24 Jul 2018 10:44:26 +0300
Message-Id: <1532418280-5849-6-git-send-email-merez@codeaurora.org> (sfid-20180724_094511_546019_D03A81D8)
In-Reply-To: <1532418280-5849-1-git-send-email-merez@codeaurora.org>
References: <1532418280-5849-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the driver sets CHECKSUM_UNNECESSARY only in case the HW
doesn't report checksum error.
As ip_summed value is not initialized it is not clear what
the driver will report to the network stack in case of HW checksum
error or in case HW doesn't calculate checksum.
Initialize ip_summed to CHECKSUM_NONE to guarantee checksum
calculation by the network stack in the above cases.

Signed-off-by: Gidon Studinski <gidons@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c   | 5 +++--
 drivers/net/wireless/ath/wil6210/txrx.c      | 8 ++++++++
 drivers/net/wireless/ath/wil6210/txrx_edma.c | 8 ++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h   | 1 +
 4 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 4356b32..f2eab39 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1736,10 +1736,11 @@ static int wil_sta_debugfs_show(struct seq_file *s, void *data)
 				   p->stats.rx_large_frame,
 				   p->stats.rx_replay);
 			seq_printf(s,
-				   "mic error %lu, key error %lu, amsdu error %lu\n",
+				   "mic error %lu, key error %lu, amsdu error %lu, csum error %lu\n",
 				   p->stats.rx_mic_error,
 				   p->stats.rx_key_error,
-				   p->stats.rx_amsdu_error);
+				   p->stats.rx_amsdu_error,
+				   p->stats.rx_csum_err);
 
 			seq_puts(s, "Rx/MCS:");
 			for (mcs = 0; mcs < ARRAY_SIZE(p->stats.rx_per_mcs);
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 6707af6..6a7943e 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -281,6 +281,12 @@ static int wil_vring_alloc_skb(struct wil6210_priv *wil, struct wil_ring *vring,
 	skb_reserve(skb, headroom);
 	skb_put(skb, sz);
 
+	/**
+	 * Make sure that the network stack calculates checksum for packets
+	 * which failed the HW checksum calculation
+	 */
+	skb->ip_summed = CHECKSUM_NONE;
+
 	pa = dma_map_single(dev, skb->data, skb->len, DMA_FROM_DEVICE);
 	if (unlikely(dma_mapping_error(dev, pa))) {
 		kfree_skb(skb);
@@ -569,6 +575,8 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 		 * mis-calculates TCP checksum - if it should be 0x0,
 		 * it writes 0xffff in violation of RFC 1624
 		 */
+		else
+			stats->rx_csum_err++;
 	}
 
 	if (snaplen) {
diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index 2ea9767..9ef2b66 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -182,6 +182,12 @@ static int wil_ring_alloc_skb_edma(struct wil6210_priv *wil,
 
 	skb_put(skb, sz);
 
+	/**
+	 * Make sure that the network stack calculates checksum for packets
+	 * which failed the HW checksum calculation
+	 */
+	skb->ip_summed = CHECKSUM_NONE;
+
 	pa = dma_map_single(dev, skb->data, skb->len, DMA_FROM_DEVICE);
 	if (unlikely(dma_mapping_error(dev, pa))) {
 		kfree_skb(skb);
@@ -847,6 +853,8 @@ static int wil_rx_error_check_edma(struct wil6210_priv *wil,
 	 * mis-calculates TCP checksum - if it should be 0x0,
 	 * it writes 0xffff in violation of RFC 1624
 	 */
+	else
+		stats->rx_csum_err++;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 1a7a1ad..b06cba5 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -565,6 +565,7 @@ struct wil_net_stats {
 	unsigned long	rx_mic_error;
 	unsigned long	rx_key_error; /* eDMA specific */
 	unsigned long	rx_amsdu_error; /* eDMA specific */
+	unsigned long	rx_csum_err;
 	u16 last_mcs_rx;
 	u64 rx_per_mcs[WIL_MCS_MAX + 1];
 };
-- 
1.9.1
