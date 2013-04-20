Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:44103 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965144Ab3DTApG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 20:45:06 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: use PCI_DMA_FROMDEVICE for RX queue de-init
Date: Fri, 19 Apr 2013 17:44:42 -0700
Message-ID: <1366418684-6148-2-git-send-email-bzhao@marvell.com> (sfid-20130420_024529_363291_504A7DB7)
In-Reply-To: <1366418684-6148-1-git-send-email-bzhao@marvell.com>
References: <1366418684-6148-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

There is a typo in mwifiex_cleanup_rxq_ring() which uses
PCI_DMA_TODEVICE while unmapping PCI memory.
We should actually use PCI_DMA_FROMDEVICE.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 856959b..80f282c 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -572,7 +572,7 @@ static void mwifiex_cleanup_rxq_ring(struct mwifiex_adapter *adapter)
 			if (card->rx_buf_list[i]) {
 				skb = card->rx_buf_list[i];
 				pci_unmap_single(card->dev, desc2->paddr,
-						 skb->len, PCI_DMA_TODEVICE);
+						 skb->len, PCI_DMA_FROMDEVICE);
 				dev_kfree_skb_any(skb);
 			}
 			memset(desc2, 0, sizeof(*desc2));
@@ -581,7 +581,7 @@ static void mwifiex_cleanup_rxq_ring(struct mwifiex_adapter *adapter)
 			if (card->rx_buf_list[i]) {
 				skb = card->rx_buf_list[i];
 				pci_unmap_single(card->dev, desc->paddr,
-						 skb->len, PCI_DMA_TODEVICE);
+						 skb->len, PCI_DMA_FROMDEVICE);
 				dev_kfree_skb_any(skb);
 			}
 			memset(desc, 0, sizeof(*desc));
-- 
1.7.0.2

