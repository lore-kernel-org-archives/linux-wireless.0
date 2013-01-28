Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:64443 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab3A1Qcm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 11:32:42 -0500
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 05/14] wil6210: Count Tx statistics on Tx completion
Date: Mon, 28 Jan 2013 18:31:00 +0200
Message-ID: <1359390669-9310-6-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130128_173245_518776_2CA3D4E2)
In-Reply-To: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows to account for Tx errors

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index f3b523b..e7ea538 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -752,8 +752,7 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	}
 	switch (rc) {
 	case 0:
-		ndev->stats.tx_packets++;
-		ndev->stats.tx_bytes += skb->len;
+		/* statistics will be updated on the tx_complete */
 		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
 	case -ENOMEM:
@@ -777,6 +776,7 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
  */
 void wil_tx_complete(struct wil6210_priv *wil, int ringid)
 {
+	struct net_device *ndev = wil_to_ndev(wil);
 	struct device *dev = wil_to_dev(wil);
 	struct vring *vring = &wil->vring_tx[ringid];
 
@@ -804,6 +804,13 @@ void wil_tx_complete(struct wil6210_priv *wil, int ringid)
 		pa = d->dma.addr_low | ((u64)d->dma.addr_high << 32);
 		skb = vring->ctx[vring->swtail];
 		if (skb) {
+			if (d->dma.error == 0) {
+				ndev->stats.tx_packets++;
+				ndev->stats.tx_bytes += skb->len;
+			} else {
+				ndev->stats.tx_errors++;
+			}
+
 			dma_unmap_single(dev, pa, d->dma.length, DMA_TO_DEVICE);
 			dev_kfree_skb_any(skb);
 			vring->ctx[vring->swtail] = NULL;
-- 
1.7.10.4

