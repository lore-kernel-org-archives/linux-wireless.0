Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:56843 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbYKNDL7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 22:11:59 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 13 Nov 2008 19:11:59 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Clarify we only want 32-bit DMA
Date: Thu, 13 Nov 2008 19:11:56 -0800
Message-ID: <1226632317-23688-1-git-send-email-lrodriguez@atheros.com> (sfid-20081114_041203_778468_27814957)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use DMA_32BIT_MASK to clarify we only want 32-bit DMA
memory. What was there before is also 32-bit but this makes it
clearer

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 04342ec..e6701b7 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1594,9 +1594,8 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (pci_enable_device(pdev))
 		return -EIO;
 
-	/* XXX 32-bit addressing only */
-	if (pci_set_dma_mask(pdev, 0xffffffff)) {
-		printk(KERN_ERR "ath_pci: 32-bit DMA not available\n");
+	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+		printk(KERN_ERR "ath9k: 32-bit DMA not available\n");
 		ret = -ENODEV;
 		goto bad;
 	}
-- 
1.5.6.rc2.15.g457bb.dirty

