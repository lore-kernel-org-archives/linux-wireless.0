Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36694 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab1HNRAf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 13:00:35 -0400
Received: by fxh19 with SMTP id 19so3189617fxh.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 10:00:34 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Michael Buesch <m@bues.ch>
Subject: [PATCH RESEND 3.2 1/2] ssb: fix DMA translation for some specific boards
Date: Sun, 14 Aug 2011 19:39:40 +0200
Message-Id: <1313343581-4395-1-git-send-email-zajec5@gmail.com> (sfid-20110814_190039_382762_2E0A3F5B)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Michael Buesch <m@bues.ch>
Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/main.c |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index 29c7d4f..d0cbdb0 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -1260,16 +1260,34 @@ void ssb_device_disable(struct ssb_device *dev, u32 core_specific_flags)
 }
 EXPORT_SYMBOL(ssb_device_disable);
 
+/* Some chipsets need routing known for PCIe and 64-bit DMA */
+static bool ssb_dma_translation_special_bit(struct ssb_device *dev)
+{
+	u16 chip_id = dev->bus->chip_id;
+
+	if (dev->id.coreid == SSB_DEV_80211) {
+		return (chip_id == 0x4322 || chip_id == 43221 ||
+			chip_id == 43231 || chip_id == 43222);
+	}
+
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
1.7.3.4

