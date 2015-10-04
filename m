Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24814 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbJDHXr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 03:23:47 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 02/10] wil6210: Add proper handling for invalid frames on Rx
Date: Sun,  4 Oct 2015 10:23:19 +0300
Message-Id: <1443943407-6663-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20151004_092351_228840_DBCD22F9)
In-Reply-To: <1443943407-6663-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1443943407-6663-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Rx, when invalid frame is received and dropped,
reaping of next frames from Rx ring is stopped.

This stops NAPI polling and re-enables the Rx interrupt.

However, in cases where no more frames received,
interrupt will not be triggered and rest of Rx frames
will not be processed.

Skip bad frames and continue to reap Rx packets when
such frames are encountered, and add statistics for
such frames for debug.

Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c |  6 ++++++
 drivers/net/wireless/ath/wil6210/txrx.c    | 20 +++++++++++++-------
 drivers/net/wireless/ath/wil6210/wil6210.h |  3 +++
 3 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index d1a1e16..97bc186 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1373,6 +1373,12 @@ __acquires(&p->tid_rx_lock) __releases(&p->tid_rx_lock)
 				}
 			}
 			spin_unlock_bh(&p->tid_rx_lock);
+			seq_printf(s,
+				   "Rx invalid frame: non-data %lu, short %lu, large %lu\n",
+				   p->stats.rx_non_data_frame,
+				   p->stats.rx_short_frame,
+				   p->stats.rx_large_frame);
+
 			seq_puts(s, "Rx/MCS:");
 			for (mcs = 0; mcs < ARRAY_SIZE(p->stats.rx_per_mcs);
 			     mcs++)
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 6229110..8ba271f 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -379,14 +379,16 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	u16 dmalen;
 	u8 ftype;
 	int cid;
-	int i = (int)vring->swhead;
+	int i;
 	struct wil_net_stats *stats;
 
 	BUILD_BUG_ON(sizeof(struct vring_rx_desc) > sizeof(skb->cb));
 
+again:
 	if (unlikely(wil_vring_is_empty(vring)))
 		return NULL;
 
+	i = (int)vring->swhead;
 	_d = &vring->va[i].rx;
 	if (unlikely(!(_d->dma.status & RX_DMA_STATUS_DU))) {
 		/* it is not error, we just reached end of Rx done area */
@@ -398,7 +400,7 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	wil_vring_advance_head(vring, 1);
 	if (!skb) {
 		wil_err(wil, "No Rx skb at [%d]\n", i);
-		return NULL;
+		goto again;
 	}
 	d = wil_skb_rxdesc(skb);
 	*d = *_d;
@@ -412,10 +414,14 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	wil_hex_dump_txrx("Rx ", DUMP_PREFIX_NONE, 32, 4,
 			  (const void *)d, sizeof(*d), false);
 
+	cid = wil_rxdesc_cid(d);
+	stats = &wil->sta[cid].stats;
+
 	if (unlikely(dmalen > sz)) {
 		wil_err(wil, "Rx size too large: %d bytes!\n", dmalen);
+		stats->rx_large_frame++;
 		kfree_skb(skb);
-		return NULL;
+		goto again;
 	}
 	skb_trim(skb, dmalen);
 
@@ -424,8 +430,6 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	wil_hex_dump_txrx("Rx ", DUMP_PREFIX_OFFSET, 16, 1,
 			  skb->data, skb_headlen(skb), false);
 
-	cid = wil_rxdesc_cid(d);
-	stats = &wil->sta[cid].stats;
 	stats->last_mcs_rx = wil_rxdesc_mcs(d);
 	if (stats->last_mcs_rx < ARRAY_SIZE(stats->rx_per_mcs))
 		stats->rx_per_mcs[stats->last_mcs_rx]++;
@@ -446,15 +450,17 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	if (unlikely(ftype != IEEE80211_FTYPE_DATA)) {
 		wil_dbg_txrx(wil, "Non-data frame ftype 0x%08x\n", ftype);
 		/* TODO: process it */
+		stats->rx_non_data_frame++;
 		kfree_skb(skb);
-		return NULL;
+		goto again;
 	}
 
 	if (unlikely(skb->len < ETH_HLEN + snaplen)) {
 		wil_err(wil, "Short frame, len = %d\n", skb->len);
 		/* TODO: process it (i.e. BAR) */
+		stats->rx_short_frame++;
 		kfree_skb(skb);
-		return NULL;
+		goto again;
 	}
 
 	/* L4 IDENT is on when HW calculated checksum, check status
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index dd4ea92..e405bef 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -465,6 +465,9 @@ struct wil_net_stats {
 	unsigned long	tx_bytes;
 	unsigned long	tx_errors;
 	unsigned long	rx_dropped;
+	unsigned long	rx_non_data_frame;
+	unsigned long	rx_short_frame;
+	unsigned long	rx_large_frame;
 	u16 last_mcs_rx;
 	u64 rx_per_mcs[WIL_MCS_MAX + 1];
 };
-- 
2.1.4

