Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50039 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475Ab0JYOpR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 10:45:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	users@rt2x00.serialmonkey.com,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00pci: do not use GFP_DMA
Date: Mon, 25 Oct 2010 10:33:07 -0400
Message-Id: <1288017187-4575-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
It shouldn't be necessary...is it?

 drivers/net/wireless/rt2x00/rt2x00pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 2449d78..868ca19 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -105,7 +105,7 @@ static int rt2x00pci_alloc_queue_dma(struct rt2x00_dev *rt2x00dev,
 	 */
 	addr = dma_alloc_coherent(rt2x00dev->dev,
 				  queue->limit * queue->desc_size,
-				  &dma, GFP_KERNEL | GFP_DMA);
+				  &dma, GFP_KERNEL);
 	if (!addr)
 		return -ENOMEM;
 
-- 
1.7.2.3

