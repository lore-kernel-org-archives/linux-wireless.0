Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18835 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbcEPTYK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2016 15:24:10 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 1/6] wil6210: fix race conditions between TX send and completion
Date: Mon, 16 May 2016 22:23:30 +0300
Message-Id: <1463426615-15523-2-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160516_212414_631651_B3BF37F4)
In-Reply-To: <1463426615-15523-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1463426615-15523-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are 2 possible race conditions, both are solved by addition of
memory barrier:
1. wil_tx_complete reads the swhead to determine if the vring is
empty. In case the swhead was updated before the descriptor update
was performed in __wil_tx_vring/__wil_tx_vring_tso, the completion
loop will not end and as the DU bit may still be set from a previous
run, this skb can be handled as completed before it was sent, which
will lead to double free of the same SKB.
2. __wil_tx_vring/__wil_tx_vring_tso calculate the number of available
descriptors according to the swtail. In case the swtail is updated
before memset of ctx to zero is completed, we can handle this
descriptor while later on ctx is zeroed.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index a4e4379..fa6ea24 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -1551,6 +1551,13 @@ static int __wil_tx_vring_tso(struct wil6210_priv *wil, struct vring *vring,
 			     vring_index, used, used + descs_used);
 	}
 
+	/* Make sure to advance the head only after descriptor update is done.
+	 * This will prevent a race condition where the completion thread
+	 * will see the DU bit set from previous run and will handle the
+	 * skb before it was completed.
+	 */
+	wmb();
+
 	/* advance swhead */
 	wil_vring_advance_head(vring, descs_used);
 	wil_dbg_txrx(wil, "TSO: Tx swhead %d -> %d\n", swhead, vring->swhead);
@@ -1691,6 +1698,13 @@ static int __wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 			     vring_index, used, used + nr_frags + 1);
 	}
 
+	/* Make sure to advance the head only after descriptor update is done.
+	 * This will prevent a race condition where the completion thread
+	 * will see the DU bit set from previous run and will handle the
+	 * skb before it was completed.
+	 */
+	wmb();
+
 	/* advance swhead */
 	wil_vring_advance_head(vring, nr_frags + 1);
 	wil_dbg_txrx(wil, "Tx[%2d] swhead %d -> %d\n", vring_index, swhead,
@@ -1914,6 +1928,12 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 				wil_consume_skb(skb, d->dma.error == 0);
 			}
 			memset(ctx, 0, sizeof(*ctx));
+			/* Make sure the ctx is zeroed before updating the tail
+			 * to prevent a case where wil_tx_vring will see
+			 * this descriptor as used and handle it before ctx zero
+			 * is completed.
+			 */
+			wmb();
 			/* There is no need to touch HW descriptor:
 			 * - ststus bit TX_DMA_STATUS_DU is set by design,
 			 *   so hardware will not try to process this desc.,
-- 
1.8.5.2

