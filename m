Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58979 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab1HJQSI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 12:18:08 -0400
Received: by fxh19 with SMTP id 19so1024245fxh.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 09:18:07 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Michael Buesch <m@bues.ch>
Subject: [PATCH 1/2] ssb: fix DMA translation for some specific boards
Date: Wed, 10 Aug 2011 18:11:27 +0200
Message-Id: <1312992688-6976-1-git-send-email-zajec5@gmail.com> (sfid-20110810_181812_272355_F52D985D)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Michael Buesch <m@bues.ch>
Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/main.c |   22 +++++++++++++++++++---
 1 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index 6ec6e09..dac2c0b 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -1260,16 +1260,32 @@ void ssb_device_disable(struct ssb_device *dev, u32 core_specific_flags)
 }
 EXPORT_SYMBOL(ssb_device_disable);
 
+/* Some chipsets need routing known for PCIe and 64-bit DMA */
+static bool ssb_dma_translation_special_bit(struct ssb_device *dev)
+{
+	u16 chip_id = dev->bus->chip_id;
+
+	if (dev->id.coreid == SSB_DEV_80211)
+		return (chip_id == 0x4322 || chip_id == 43221 ||
+			chip_id == 43231 || chip_id == 43222);
+	return 0;
+}
+
 u32 ssb_dma_translation(struct ssb_device *dev)
 {
 	switch (dev->bus->bustype) {
 	case SSB_BUSTYPE_SSB:
 		return 0;
 	case SSB_BUSTYPE_PCI:
-		if (ssb_read32(dev, SSB_TMSHIGH) & SSB_TMSHIGH_DMA64)
+		if (pci_is_pcie(dev->bus->host_pci) &&
+		    ssb_read32(dev, SSB_TMSHIGH) & SSB_TMSHIGH_DMA64) {
 			return SSB_PCIE_DMA_H32;
-		else
-			return SSB_PCI_DMA;
+		} else {
+			if (ssb_dma_translation_special_bit(dev))
+				return SSB_PCIE_DMA_H32;
+			else
+				return SSB_PCI_DMA;
+		}
 	default:
 		__ssb_dma_not_implemented(dev);
 	}
-- 
1.7.1

