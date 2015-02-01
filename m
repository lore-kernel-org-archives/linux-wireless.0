Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:25275 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbbBAIzf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Feb 2015 03:55:35 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 2/6] wil6210: avoid Tx descriptor double write
Date: Sun,  1 Feb 2015 10:55:12 +0200
Message-Id: <1422780916-8577-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150201_095546_882790_CB81B72A)
In-Reply-To: <1422780916-8577-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1422780916-8577-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Non-cacheable Tx descriptor for the last fragment of
multi-fragment frame used to be written back twice.

Refactor code to always write non-cacheable descriptor
only once

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 24c4b9a..e37cab1 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -981,8 +981,6 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 
 	vring->ctx[i].nr_frags = nr_frags;
 	wil_tx_desc_set_nr_frags(d, nr_frags);
-	if (nr_frags)
-		*_d = *d;
 
 	/* middle segments */
 	for (; f < nr_frags; f++) {
@@ -990,6 +988,7 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 				&skb_shinfo(skb)->frags[f];
 		int len = skb_frag_size(frag);
 
+		*_d = *d;
 		i = (swhead + f + 1) % vring->size;
 		_d = &vring->va[i].tx;
 		pa = skb_frag_dma_map(dev, frag, 0, skb_frag_size(frag),
@@ -1003,7 +1002,6 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 		 * it will succeed here too
 		 */
 		wil_tx_desc_offload_cksum_set(wil, d, skb);
-		*_d = *d;
 	}
 	/* for the last seg only */
 	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_CMD_EOP_POS);
-- 
2.1.0

