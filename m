Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:2074 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbYFCS0J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 14:26:09 -0400
Received: by nf-out-0910.google.com with SMTP id d3so644244nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jun 2008 11:26:07 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 04/11] rt2x00: Restrict DMA to 32-bit addresses.
Date: Tue, 3 Jun 2008 20:29:47 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200806032024.52931.IvDoorn@gmail.com> <200806032026.16128.IvDoorn@gmail.com> <200806032026.40506.IvDoorn@gmail.com>
In-Reply-To: <200806032026.40506.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200806032029.47313.IvDoorn@gmail.com> (sfid-20080603_202614_061939_293ABD09)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@kpnplanet.nl>

None of the rt2x00 PCI devices support 64-bit DMA addresses (they all only accept 32-bit
buffer addresses). Hence it makes no sense to try to enable 64-bit DMA addresses. Only
try to enable 32-bit DMA addresses.

Signed-off-by: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00pci.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 70a3d13..d508c80 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -387,8 +387,7 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 	if (pci_set_mwi(pci_dev))
 		ERROR_PROBE("MWI not available.\n");
 
-	if (pci_set_dma_mask(pci_dev, DMA_64BIT_MASK) &&
-	    pci_set_dma_mask(pci_dev, DMA_32BIT_MASK)) {
+	if (pci_set_dma_mask(pci_dev, DMA_32BIT_MASK)) {
 		ERROR_PROBE("PCI DMA not supported.\n");
 		retval = -EIO;
 		goto exit_disable_device;
-- 
1.5.5.3

