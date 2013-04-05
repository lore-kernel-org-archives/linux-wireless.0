Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:33558 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161662Ab3DEG0p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 02:26:45 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	users@rt2x00.serialmonkey.com, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 6/6] rt2x00: rt2x00mmio: remove unused rt2x00pci_* defines
Date: Fri,  5 Apr 2013 08:27:05 +0200
Message-Id: <1365143225-24532-7-git-send-email-juhosg@openwrt.org> (sfid-20130405_082654_406969_61D61DA8)
In-Reply-To: <1365143225-24532-1-git-send-email-juhosg@openwrt.org>
References: <1365143225-24532-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All users are converted to use the rt2x00mmio_*
functions so remove the now unused defines.

The patch contain no functional changes.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2x00mmio.h |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mmio.h b/drivers/net/wireless/rt2x00/rt2x00mmio.h
index b0396ca..cda3dbc 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mmio.h
+++ b/drivers/net/wireless/rt2x00/rt2x00mmio.h
@@ -37,7 +37,6 @@ static inline void rt2x00mmio_register_read(struct rt2x00_dev *rt2x00dev,
 {
 	*value = readl(rt2x00dev->csr.base + offset);
 }
-#define rt2x00pci_register_read rt2x00mmio_register_read
 
 static inline void rt2x00mmio_register_multiread(struct rt2x00_dev *rt2x00dev,
 						 const unsigned int offset,
@@ -45,7 +44,6 @@ static inline void rt2x00mmio_register_multiread(struct rt2x00_dev *rt2x00dev,
 {
 	memcpy_fromio(value, rt2x00dev->csr.base + offset, length);
 }
-#define rt2x00pci_register_multiread rt2x00mmio_register_multiread
 
 static inline void rt2x00mmio_register_write(struct rt2x00_dev *rt2x00dev,
 					     const unsigned int offset,
@@ -53,7 +51,6 @@ static inline void rt2x00mmio_register_write(struct rt2x00_dev *rt2x00dev,
 {
 	writel(value, rt2x00dev->csr.base + offset);
 }
-#define rt2x00pci_register_write rt2x00mmio_register_write
 
 static inline void rt2x00mmio_register_multiwrite(struct rt2x00_dev *rt2x00dev,
 						  const unsigned int offset,
@@ -62,7 +59,6 @@ static inline void rt2x00mmio_register_multiwrite(struct rt2x00_dev *rt2x00dev,
 {
 	__iowrite32_copy(rt2x00dev->csr.base + offset, value, length >> 2);
 }
-#define rt2x00pci_register_multiwrite rt2x00mmio_register_multiwrite
 
 /**
  * rt2x00mmio_regbusy_read - Read from register with busy check
@@ -81,7 +77,6 @@ int rt2x00mmio_regbusy_read(struct rt2x00_dev *rt2x00dev,
 			    const unsigned int offset,
 			    const struct rt2x00_field32 field,
 			    u32 *reg);
-#define rt2x00pci_regbusy_read rt2x00mmio_regbusy_read
 
 /**
  * struct queue_entry_priv_mmio: Per entry PCI specific information
@@ -95,7 +90,6 @@ struct queue_entry_priv_mmio {
 	__le32 *desc;
 	dma_addr_t desc_dma;
 };
-#define queue_entry_priv_pci queue_entry_priv_mmio
 
 /**
  * rt2x00mmio_rxdone - Handle RX done events
@@ -105,7 +99,6 @@ struct queue_entry_priv_mmio {
  * pending rx frames were processed.
  */
 bool rt2x00mmio_rxdone(struct rt2x00_dev *rt2x00dev);
-#define rt2x00pci_rxdone rt2x00mmio_rxdone
 
 /**
  * rt2x00mmio_flush_queue - Flush data queue
@@ -116,15 +109,11 @@ bool rt2x00mmio_rxdone(struct rt2x00_dev *rt2x00dev);
  * to become empty.
  */
 void rt2x00mmio_flush_queue(struct data_queue *queue, bool drop);
-#define rt2x00pci_flush_queue rt2x00mmio_flush_queue
 
 /*
  * Device initialization handlers.
  */
 int rt2x00mmio_initialize(struct rt2x00_dev *rt2x00dev);
-#define rt2x00pci_initialize rt2x00mmio_initialize
-
 void rt2x00mmio_uninitialize(struct rt2x00_dev *rt2x00dev);
-#define rt2x00pci_uninitialize rt2x00mmio_uninitialize
 
 #endif /* RT2X00MMIO_H */
-- 
1.7.10

