Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:64722 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbbCOOAo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 10:00:44 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 1/7] wil6210: optimize index manipulation in wil_vring_reap_rx
Date: Sun, 15 Mar 2015 16:00:16 +0200
Message-Id: <1426428024-4538-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150315_150053_842923_9A7101A1)
In-Reply-To: <1426428024-4538-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1426428024-4538-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use temporal variable for often used vring->swhead;
and use proper index in debug printing - vring->swhead
used before was modified in wil_vring_advance_head
and then increased value was used in debug print

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 689081c..3feb86c4 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -369,6 +369,7 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	u16 dmalen;
 	u8 ftype;
 	int cid;
+	int i = (int)vring->swhead;
 	struct wil_net_stats *stats;
 
 	BUILD_BUG_ON(sizeof(struct vring_rx_desc) > sizeof(skb->cb));
@@ -376,24 +377,28 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	if (unlikely(wil_vring_is_empty(vring)))
 		return NULL;
 
-	_d = &vring->va[vring->swhead].rx;
+	_d = &vring->va[i].rx;
 	if (unlikely(!(_d->dma.status & RX_DMA_STATUS_DU))) {
 		/* it is not error, we just reached end of Rx done area */
 		return NULL;
 	}
 
-	skb = vring->ctx[vring->swhead].skb;
+	skb = vring->ctx[i].skb;
+	vring->ctx[i].skb = NULL;
+	wil_vring_advance_head(vring, 1);
+	if (!skb) {
+		wil_err(wil, "No Rx skb at [%d]\n", i);
+		return NULL;
+	}
 	d = wil_skb_rxdesc(skb);
 	*d = *_d;
 	pa = wil_desc_addr(&d->dma.addr);
-	vring->ctx[vring->swhead].skb = NULL;
-	wil_vring_advance_head(vring, 1);
 
 	dma_unmap_single(dev, pa, sz, DMA_FROM_DEVICE);
 	dmalen = le16_to_cpu(d->dma.length);
 
-	trace_wil6210_rx(vring->swhead, d);
-	wil_dbg_txrx(wil, "Rx[%3d] : %d bytes\n", vring->swhead, dmalen);
+	trace_wil6210_rx(i, d);
+	wil_dbg_txrx(wil, "Rx[%3d] : %d bytes\n", i, dmalen);
 	wil_hex_dump_txrx("Rx ", DUMP_PREFIX_NONE, 32, 4,
 			  (const void *)d, sizeof(*d), false);
 
-- 
2.1.0

