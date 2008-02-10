Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:23023 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbYBJVxi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 16:53:38 -0500
Received: by fg-out-1718.google.com with SMTP id e21so3582755fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2008 13:53:36 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 06/14] rt2x00: make csr_cache and csr_addr an union
Date: Sun, 10 Feb 2008 22:49:13 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802102246.04515.IvDoorn@gmail.com>
In-Reply-To: <200802102246.04515.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802102249.13147.IvDoorn@gmail.com> (sfid-20080210_215341_172623_F2050D42)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The csr_cache and csr_addr pointers are both the same size
and they are never used both by the same driver. This makes
them a nice candidate for an union.
We could merge into 1 pointer, but that would either upset sparse,
or require a lot of __force casts.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |   10 ++++++----
 drivers/net/wireless/rt2x00/rt2x00pci.c |   10 +++++-----
 drivers/net/wireless/rt2x00/rt2x00pci.h |    8 ++++----
 drivers/net/wireless/rt2x00/rt2x00usb.c |   16 ++++++++--------
 4 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index f6ec9fe..9098532 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -707,11 +707,13 @@ struct rt2x00_dev {
 
 	/*
 	 * Register pointers
-	 * csr_addr: Base register address. (PCI)
-	 * csr_cache: CSR cache for usb_control_msg. (USB)
+	 * csr.base: CSR base register address. (PCI)
+	 * csr.cache: CSR cache for usb_control_msg. (USB)
 	 */
-	void __iomem *csr_addr;
-	void *csr_cache;
+	union csr {
+		void __iomem *base;
+		void *cache;
+	} csr;
 
 	/*
 	 * Mutex to protect register accesses on USB devices.
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 238f1c1..b8c6a8c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -350,9 +350,9 @@ static void rt2x00pci_free_reg(struct rt2x00_dev *rt2x00dev)
 	kfree(rt2x00dev->eeprom);
 	rt2x00dev->eeprom = NULL;
 
-	if (rt2x00dev->csr_addr) {
-		iounmap(rt2x00dev->csr_addr);
-		rt2x00dev->csr_addr = NULL;
+	if (rt2x00dev->csr.base) {
+		iounmap(rt2x00dev->csr.base);
+		rt2x00dev->csr.base = NULL;
 	}
 }
 
@@ -360,9 +360,9 @@ static int rt2x00pci_alloc_reg(struct rt2x00_dev *rt2x00dev)
 {
 	struct pci_dev *pci_dev = rt2x00dev_pci(rt2x00dev);
 
-	rt2x00dev->csr_addr = ioremap(pci_resource_start(pci_dev, 0),
+	rt2x00dev->csr.base = ioremap(pci_resource_start(pci_dev, 0),
 				      pci_resource_len(pci_dev, 0));
-	if (!rt2x00dev->csr_addr)
+	if (!rt2x00dev->csr.base)
 		goto exit;
 
 	rt2x00dev->eeprom = kzalloc(rt2x00dev->ops->eeprom_size, GFP_KERNEL);
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
index 71335e1..8932b31 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
@@ -61,7 +61,7 @@ static inline void rt2x00pci_register_read(struct rt2x00_dev *rt2x00dev,
 					   const unsigned long offset,
 					   u32 *value)
 {
-	*value = readl(rt2x00dev->csr_addr + offset);
+	*value = readl(rt2x00dev->csr.base + offset);
 }
 
 static inline void
@@ -69,14 +69,14 @@ rt2x00pci_register_multiread(struct rt2x00_dev *rt2x00dev,
 			     const unsigned long offset,
 			     void *value, const u16 length)
 {
-	memcpy_fromio(value, rt2x00dev->csr_addr + offset, length);
+	memcpy_fromio(value, rt2x00dev->csr.base + offset, length);
 }
 
 static inline void rt2x00pci_register_write(struct rt2x00_dev *rt2x00dev,
 					    const unsigned long offset,
 					    u32 value)
 {
-	writel(value, rt2x00dev->csr_addr + offset);
+	writel(value, rt2x00dev->csr.base + offset);
 }
 
 static inline void
@@ -84,7 +84,7 @@ rt2x00pci_register_multiwrite(struct rt2x00_dev *rt2x00dev,
 			      const unsigned long offset,
 			      void *value, const u16 length)
 {
-	memcpy_toio(rt2x00dev->csr_addr + offset, value, length);
+	memcpy_toio(rt2x00dev->csr.base + offset, value, length);
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 44ab216..4219057 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -84,20 +84,20 @@ int rt2x00usb_vendor_req_buff_lock(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Check for Cache availability.
 	 */
-	if (unlikely(!rt2x00dev->csr_cache || buffer_length > CSR_CACHE_SIZE)) {
+	if (unlikely(!rt2x00dev->csr.cache || buffer_length > CSR_CACHE_SIZE)) {
 		ERROR(rt2x00dev, "CSR cache not available.\n");
 		return -ENOMEM;
 	}
 
 	if (requesttype == USB_VENDOR_REQUEST_OUT)
-		memcpy(rt2x00dev->csr_cache, buffer, buffer_length);
+		memcpy(rt2x00dev->csr.cache, buffer, buffer_length);
 
 	status = rt2x00usb_vendor_request(rt2x00dev, request, requesttype,
-					  offset, 0, rt2x00dev->csr_cache,
+					  offset, 0, rt2x00dev->csr.cache,
 					  buffer_length, timeout);
 
 	if (!status && requesttype == USB_VENDOR_REQUEST_IN)
-		memcpy(buffer, rt2x00dev->csr_cache, buffer_length);
+		memcpy(buffer, rt2x00dev->csr.cache, buffer_length);
 
 	return status;
 }
@@ -562,14 +562,14 @@ static void rt2x00usb_free_reg(struct rt2x00_dev *rt2x00dev)
 	kfree(rt2x00dev->eeprom);
 	rt2x00dev->eeprom = NULL;
 
-	kfree(rt2x00dev->csr_cache);
-	rt2x00dev->csr_cache = NULL;
+	kfree(rt2x00dev->csr.cache);
+	rt2x00dev->csr.cache = NULL;
 }
 
 static int rt2x00usb_alloc_reg(struct rt2x00_dev *rt2x00dev)
 {
-	rt2x00dev->csr_cache = kzalloc(CSR_CACHE_SIZE, GFP_KERNEL);
-	if (!rt2x00dev->csr_cache)
+	rt2x00dev->csr.cache = kzalloc(CSR_CACHE_SIZE, GFP_KERNEL);
+	if (!rt2x00dev->csr.cache)
 		goto exit;
 
 	rt2x00dev->eeprom = kzalloc(rt2x00dev->ops->eeprom_size, GFP_KERNEL);
-- 
1.5.4

