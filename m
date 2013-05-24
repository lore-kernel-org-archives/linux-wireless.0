Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:33693 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750950Ab3EXJbP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 May 2013 05:31:15 -0400
Date: Fri, 24 May 2013 14:42:25 +0530
From: Nishant Sarmukadam <nishants@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>
Subject: [PATCH] mwl8k: Fix the firmware hang issue for 8764
Message-ID: <20130524091224.GA2583@markyou.marvell.com> (sfid-20130524_113118_944496_555E90E9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware hang issue is not seen very often,
though it is still seen sometimes (once in 12
hours in local tests). The changes in the driver
,to interrupt the firmware, are needed when we
detect that firmware is stuck and when the host
queues are full and we begin to drop packets.
This is to ensure that the firmware does not
miss any PPA_RDY interrupts to cause the firmware
restart dont miss PPA_READY interrupt for SC2

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwl8k.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 6820fce..a3707fd 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1548,7 +1548,7 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
 	if (!priv->pending_tx_pkts)
 		return 0;
 
-	retry = 0;
+	retry = 1;
 	rc = 0;
 
 	spin_lock_bh(&priv->tx_lock);
@@ -1572,13 +1572,19 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
 
 		spin_lock_bh(&priv->tx_lock);
 
-		if (timeout) {
+		if (timeout || !priv->pending_tx_pkts) {
 			WARN_ON(priv->pending_tx_pkts);
 			if (retry)
 				wiphy_notice(hw->wiphy, "tx rings drained\n");
 			break;
 		}
 
+		if (retry) {
+			mwl8k_tx_start(priv);
+			retry = 0;
+			continue;
+		}
+
 		if (priv->pending_tx_pkts < oldcount) {
 			wiphy_notice(hw->wiphy,
 				     "waiting for tx rings to drain (%d -> %d pkts)\n",
@@ -2055,6 +2061,7 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw,
 				mwl8k_remove_stream(hw, stream);
 				spin_unlock(&priv->stream_lock);
 			}
+			mwl8k_tx_start(priv);
 			spin_unlock_bh(&priv->tx_lock);
 			pci_unmap_single(priv->pdev, dma, skb->len,
 					 PCI_DMA_TODEVICE);
-- 
1.8.0.3

