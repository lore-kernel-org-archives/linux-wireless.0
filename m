Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21534 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203Ab3GKPED (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 11:04:03 -0400
Cc: Kirshenbaum Erez <erezk@wilocity.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 5/5] wil6210: fix subtle race in wil_tx_vring
Date: Thu, 11 Jul 2013 18:03:41 +0300
Message-ID: <1373555021-11763-6-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130711_170411_775146_FDADEE4B)
In-Reply-To: <1373555021-11763-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1373555021-11763-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Finish all SW context modifications prior to notifying hardware

It used to be race condition: if HW finish Tx and issue Tx completion IRQ very fast,
prior to SW context update in wil_tx_vring, Tx completion will mis-handle descriptor, as
SW part will have no skb pointer stored.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 44cdd2a..2a9d56a 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -712,6 +712,12 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_CMD_DMA_IT_POS);
 	*_d = *d;
 
+	/* hold reference to skb
+	 * to prevent skb release before accounting
+	 * in case of immediate "tx done"
+	 */
+	vring->ctx[i].skb = skb_get(skb);
+
 	wil_hex_dump_txrx("Tx ", DUMP_PREFIX_NONE, 32, 4,
 			  (const void *)d, sizeof(*d), false);
 
@@ -720,11 +726,6 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	wil_dbg_txrx(wil, "Tx swhead %d -> %d\n", swhead, vring->swhead);
 	trace_wil6210_tx(vring_index, swhead, skb->len, nr_frags);
 	iowrite32(vring->swhead, wil->csr + HOSTADDR(vring->hwtail));
-	/* hold reference to skb
-	 * to prevent skb release before accounting
-	 * in case of immediate "tx done"
-	 */
-	vring->ctx[i].skb = skb_get(skb);
 
 	return 0;
  dma_error:
-- 
1.8.1.2

