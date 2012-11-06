Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:43045 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751367Ab2KFN5s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 08:57:48 -0500
Date: Tue, 6 Nov 2012 19:22:48 +0530
From: Nishant Sarmukadam <nishants@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH] mwl8k: Unmap the pci DMA address in xmit error path
Message-ID: <20121106135244.GA8453@markyou.marvell.com> (sfid-20121106_145759_591564_BB1E3F48)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should unmap the DMA address in the error path, else it
causes resource leaks. Fix this.

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 9961765..5b5b9ec 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2005,6 +2005,8 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw,
 				spin_unlock(&priv->stream_lock);
 			}
 			spin_unlock_bh(&priv->tx_lock);
+			pci_unmap_single(priv->pdev, dma, skb->len,
+					 PCI_DMA_TODEVICE);
 			dev_kfree_skb(skb);
 			return;
 		}
-- 
1.7.9.2

