Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48763 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755Ab3JQHmv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 03:42:51 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 18/21] rt2x00: rt2800pci: move rt2800mmio_enable_radio function to another module
Date: Thu, 17 Oct 2013 09:42:32 +0200
Message-Id: <1381995755-16471-19-git-send-email-juhosg@openwrt.org> (sfid-20131017_100807_754062_2700FCE2)
In-Reply-To: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
References: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the function into the rt2800mmio module, in order
to make it usable from other modules.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800mmio.c |   15 +++++++++++++++
 drivers/net/wireless/rt2x00/rt2800mmio.h |    3 +++
 drivers/net/wireless/rt2x00/rt2800pci.c  |   13 -------------
 3 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800mmio.c b/drivers/net/wireless/rt2x00/rt2800mmio.c
index 7e8c224..ae15228 100644
--- a/drivers/net/wireless/rt2x00/rt2800mmio.c
+++ b/drivers/net/wireless/rt2x00/rt2800mmio.c
@@ -852,6 +852,21 @@ int rt2800mmio_init_registers(struct rt2x00_dev *rt2x00dev)
 }
 EXPORT_SYMBOL_GPL(rt2800mmio_init_registers);
 
+/*
+ * Device state switch handlers.
+ */
+int rt2800mmio_enable_radio(struct rt2x00_dev *rt2x00dev)
+{
+	/* Wait for DMA, ignore error until we initialize queues. */
+	rt2800_wait_wpdma_ready(rt2x00dev);
+
+	if (unlikely(rt2800mmio_init_queues(rt2x00dev)))
+		return -EIO;
+
+	return rt2800_enable_radio(rt2x00dev);
+}
+EXPORT_SYMBOL_GPL(rt2800mmio_enable_radio);
+
 MODULE_AUTHOR(DRV_PROJECT);
 MODULE_VERSION(DRV_VERSION);
 MODULE_DESCRIPTION("rt2800 MMIO library");
diff --git a/drivers/net/wireless/rt2x00/rt2800mmio.h b/drivers/net/wireless/rt2x00/rt2800mmio.h
index 392895a..6a10de3 100644
--- a/drivers/net/wireless/rt2x00/rt2800mmio.h
+++ b/drivers/net/wireless/rt2x00/rt2800mmio.h
@@ -159,4 +159,7 @@ void rt2800mmio_clear_entry(struct queue_entry *entry);
 int rt2800mmio_init_queues(struct rt2x00_dev *rt2x00dev);
 int rt2800mmio_init_registers(struct rt2x00_dev *rt2x00dev);
 
+/* Device state switch handlers. */
+int rt2800mmio_enable_radio(struct rt2x00_dev *rt2x00dev);
+
 #endif /* RT2800MMIO_H */
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 88dd242..77ddd1a 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -205,23 +205,10 @@ static int rt2800pci_write_firmware(struct rt2x00_dev *rt2x00dev,
 
 	return 0;
 }
-#endif /* CONFIG_PCI */
 
 /*
  * Device state switch handlers.
  */
-static int rt2800mmio_enable_radio(struct rt2x00_dev *rt2x00dev)
-{
-	/* Wait for DMA, ignore error until we initialize queues. */
-	rt2800_wait_wpdma_ready(rt2x00dev);
-
-	if (unlikely(rt2800mmio_init_queues(rt2x00dev)))
-		return -EIO;
-
-	return rt2800_enable_radio(rt2x00dev);
-}
-
-#ifdef CONFIG_PCI
 static int rt2800pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
-- 
1.7.10
