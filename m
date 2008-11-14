Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:56845 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbYKNDMA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 22:12:00 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 13 Nov 2008 19:12:00 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: make DMA memory consistent
Date: Thu, 13 Nov 2008 19:11:57 -0800
Message-ID: <1226632317-23688-2-git-send-email-lrodriguez@atheros.com> (sfid-20081114_041208_383001_5DCBA46A)
In-Reply-To: <1226632317-23688-1-git-send-email-lrodriguez@atheros.com>
References: <1226632317-23688-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make the DMAable mameory consistent with pci_set_consistent_dma_mask().
The DMA-mapping.txt Documentation recommends this but for PCI-X
considerations and on strange architecture like SGI SN2, not sure
why it would fix an issue but lets see if it does, just in case.

Before this, this driver was tested with x86_64 with about
7 GB of RAM, not sure if this is really needed.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index e6701b7..828d27a 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1594,9 +1594,18 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (pci_enable_device(pdev))
 		return -EIO;
 
-	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+	ret =  pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+
+	if (ret) {
 		printk(KERN_ERR "ath9k: 32-bit DMA not available\n");
-		ret = -ENODEV;
+		goto bad;
+	}
+
+	ret = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+
+	if (ret) {
+		printk(KERN_ERR "ath9k: 32-bit DMA consistent "
+			"DMA enable faled\n");
 		goto bad;
 	}
 
-- 
1.5.6.rc2.15.g457bb.dirty

