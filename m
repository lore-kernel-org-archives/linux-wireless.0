Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59284 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193Ab1ERJCc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 05:02:32 -0400
Received: by ewy4 with SMTP id 4so373719ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2011 02:02:31 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: add IRQ number and pointer to DMA dev
Date: Wed, 18 May 2011 11:40:22 +0200
Message-Id: <1305711622-4244-1-git-send-email-zajec5@gmail.com> (sfid-20110518_110236_760217_A9D8C1D5)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/main.c       |    2 ++
 include/linux/bcma/bcma.h |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index be52344..a2f6b18 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -89,6 +89,8 @@ static int bcma_register_cores(struct bcma_bus *bus)
 		switch (bus->hosttype) {
 		case BCMA_HOSTTYPE_PCI:
 			core->dev.parent = &bus->host_pci->dev;
+			core->dma_dev = &bus->host_pci->dev;
+			core->irq = bus->host_pci->irq;
 			break;
 		case BCMA_HOSTTYPE_NONE:
 		case BCMA_HOSTTYPE_SDIO:
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 08763e4..8b0cef9 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -117,6 +117,8 @@ struct bcma_device {
 	struct bcma_device_id id;
 
 	struct device dev;
+	struct device *dma_dev;
+	unsigned int irq;
 	bool dev_registered;
 
 	u8 core_index;
-- 
1.7.3.4

