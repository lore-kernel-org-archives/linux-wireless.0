Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:49223
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbXHRXxV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Aug 2007 19:53:21 -0400
Message-Id: <20070818234836.401097000@bu3sch.de>
References: <20070818234833.623623000@bu3sch.de>
Date: Sun, 19 Aug 2007 01:48:39 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [patch 6/6] b43: New firmware file format
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev-new/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/b43.h	2007-08-18 19:05:09.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/b43.h	2007-08-18 19:12:05.000000000 +0200
@@ -405,11 +405,32 @@ enum {
 struct b43_dmaring;
 struct b43_pioqueue;
 
-struct b43_initval {
-	__be16 offset;
-	__be16 size;
-	__be32 value;
-} __attribute__ ((__packed__));
+/* The firmware file header */
+#define B43_FW_TYPE_UCODE	'u'
+#define B43_FW_TYPE_PCM		'p'
+#define B43_FW_TYPE_IV		'i'
+struct b43_fw_header {
+	/* File type */
+	u8 type;
+	/* File format version */
+	u8 ver;
+	u8 __padding[2];
+	/* Size of the data. For ucode and PCM this is in bytes.
+	 * For IV this is number-of-ivs. */
+	__be32 size;
+} __attribute__((__packed__));
+
+/* Initial Value file format */
+#define B43_IV_OFFSET_MASK	0x7FFF
+#define B43_IV_32BIT		0x8000
+struct b43_iv {
+	__be16 offset_size;
+	union {
+		__be16 d16;
+		__be32 d32;
+	} data __attribute__((__packed__));
+} __attribute__((__packed__));
+
 
 #define B43_PHYMODE(phytype)		(1 << (phytype))
 #define B43_PHYMODE_A			B43_PHYMODE(B43_PHYTYPE_A)
Index: wireless-dev-new/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/main.c	2007-08-18 19:05:09.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/main.c	2007-08-18 23:13:21.000000000 +0200
@@ -39,6 +39,7 @@
 #include <linux/workqueue.h>
 #include <linux/skbuff.h>
 #include <linux/dma-mapping.h>
+#include <asm/unaligned.h>
 
 #include "b43.h"
 #include "main.h"
@@ -1585,6 +1586,8 @@ static int do_request_fw(struct b43_wlde
 {
 	const size_t plen = sizeof(modparam_fwpostfix) + 32;
 	char path[plen];
+	struct b43_fw_header *hdr;
+	u32 size;
 	int err;
 
 	if (!name)
@@ -1598,8 +1601,29 @@ static int do_request_fw(struct b43_wlde
 		b43err(dev->wl, "Firmware file \"%s\" not found "
 		       "or load failed.\n", path);
 	}
+	if ((*fw)->size < sizeof(struct b43_fw_header))
+		goto err_format;
+	hdr = (struct b43_fw_header *)((*fw)->data);
+	switch (hdr->type) {
+	case B43_FW_TYPE_UCODE:
+	case B43_FW_TYPE_PCM:
+		size = be32_to_cpu(hdr->size);
+		if (size != (*fw)->size - sizeof(struct b43_fw_header))
+			goto err_format;
+		/* fallthrough */
+	case B43_FW_TYPE_IV:
+		if (hdr->ver != 1)
+			goto err_format;
+		break;
+	default:
+		goto err_format;
+	}
 
 	return err;
+
+err_format:
+	b43err(dev->wl, "Firmware file \"%s\" format error.\n", path);
+	return -EPROTO;
 }
 
 static int b43_request_firmware(struct b43_wldev *dev)
@@ -1719,6 +1743,7 @@ error:
 
 static int b43_upload_microcode(struct b43_wldev *dev)
 {
+	const size_t hdr_len = sizeof(struct b43_fw_header);
 	const __be32 *data;
 	unsigned int i, len;
 	u16 fwrev, fwpatch, fwdate, fwtime;
@@ -1726,24 +1751,26 @@ static int b43_upload_microcode(struct b
 	int err = 0;
 
 	/* Upload Microcode. */
-	data = (__be32 *) (dev->fw.ucode->data);
-	len = dev->fw.ucode->size / sizeof(__be32);
+	data = (__be32 *) (dev->fw.ucode->data + hdr_len);
+	len = (dev->fw.ucode->size - hdr_len) / sizeof(__be32);
 	b43_shm_control_word(dev, B43_SHM_UCODE | B43_SHM_AUTOINC_W, 0x0000);
 	for (i = 0; i < len; i++) {
 		b43_write32(dev, B43_MMIO_SHM_DATA, be32_to_cpu(data[i]));
 		udelay(10);
 	}
 
-	/* Upload PCM data. */
-	data = (__be32 *) (dev->fw.pcm->data);
-	len = dev->fw.pcm->size / sizeof(__be32);
-	b43_shm_control_word(dev, B43_SHM_HW, 0x01EA);
-	b43_write32(dev, B43_MMIO_SHM_DATA, 0x00004000);
-	/* No need for autoinc bit in SHM_HW */
-	b43_shm_control_word(dev, B43_SHM_HW, 0x01EB);
-	for (i = 0; i < len; i++) {
-		b43_write32(dev, B43_MMIO_SHM_DATA, be32_to_cpu(data[i]));
-		udelay(10);
+	if (dev->fw.pcm) {
+		/* Upload PCM data. */
+		data = (__be32 *) (dev->fw.pcm->data + hdr_len);
+		len = (dev->fw.pcm->size - hdr_len) / sizeof(__be32);
+		b43_shm_control_word(dev, B43_SHM_HW, 0x01EA);
+		b43_write32(dev, B43_MMIO_SHM_DATA, 0x00004000);
+		/* No need for autoinc bit in SHM_HW */
+		b43_shm_control_word(dev, B43_SHM_HW, 0x01EB);
+		for (i = 0; i < len; i++) {
+			b43_write32(dev, B43_MMIO_SHM_DATA, be32_to_cpu(data[i]));
+			udelay(10);
+		}
 	}
 
 	b43_write32(dev, B43_MMIO_GEN_IRQ_REASON, B43_IRQ_ALL);
@@ -1797,34 +1824,61 @@ static int b43_upload_microcode(struct b
 }
 
 static int b43_write_initvals(struct b43_wldev *dev,
-			      const struct b43_initval *data,
-			      size_t count)
+			      const struct b43_iv *ivals,
+			      size_t count,
+			      size_t array_size)
 {
-	u16 offset, size;
-	u32 value;
+	const struct b43_iv *iv;
+	u16 offset;
 	size_t i;
+	bool bit32;
 
+	BUILD_BUG_ON(sizeof(struct b43_iv) != 6);
+	iv = ivals;
 	for (i = 0; i < count; i++) {
-		offset = be16_to_cpu(data[i].offset);
-		size = be16_to_cpu(data[i].size);
-		value = be32_to_cpu(data[i].value);
-
-		if (unlikely(offset >= 0x1000))
+		if (array_size < sizeof(iv->offset_size))
 			goto err_format;
-		if (size == 2) {
-			if (unlikely(value & 0xFFFF0000))
+		array_size -= sizeof(iv->offset_size);
+		offset = be16_to_cpu(iv->offset_size);
+		bit32 = !!(offset & B43_IV_32BIT);
+		offset &= B43_IV_OFFSET_MASK;
+		if (offset >= 0x1000)
+			goto err_format;
+		if (bit32) {
+			u32 value;
+
+			if (array_size < sizeof(iv->data.d32))
 				goto err_format;
-			b43_write16(dev, offset, (u16) value);
-		} else if (size == 4) {
+			array_size -= sizeof(iv->data.d32);
+
+			value = be32_to_cpu(get_unaligned(&iv->data.d32));
 			b43_write32(dev, offset, value);
-		} else
-			goto err_format;
+
+			iv = (const struct b43_iv *)((const uint8_t *)iv +
+							sizeof(__be16) +
+							sizeof(__be32));
+		} else {
+			u16 value;
+
+			if (array_size < sizeof(iv->data.d16))
+				goto err_format;
+			array_size -= sizeof(iv->data.d16);
+
+			value = be16_to_cpu(iv->data.d16);
+			b43_write16(dev, offset, value);
+
+			iv = (const struct b43_iv *)((const uint8_t *)iv +
+							sizeof(__be16) +
+							sizeof(__be16));
+		}
 	}
+	if (array_size)
+		goto err_format;
 
 	return 0;
 
 err_format:
-	b43err(dev->wl, "Initial Values Firmware file-format error\n");
+	b43err(dev->wl, "Initial Values Firmware file-format error.\n");
 	b43_print_fw_helptext(dev->wl);
 
 	return -EPROTO;
@@ -1832,20 +1886,28 @@ err_format:
 
 static int b43_upload_initvals(struct b43_wldev *dev)
 {
+	const size_t hdr_len = sizeof(struct b43_fw_header);
+	const struct b43_fw_header *hdr;
 	struct b43_firmware *fw = &dev->fw;
-	struct b43_initval *ivals;
+	const struct b43_iv *ivals;
 	size_t count;
 	int err;
 
-	ivals = (struct b43_initval *)(fw->initvals->data);
-	count = fw->initvals->size / sizeof(struct b43_initval);
-	err = b43_write_initvals(dev, ivals, count);
+	hdr = (const struct b43_fw_header *)(fw->initvals->data);
+	ivals = (const struct b43_iv *)(fw->initvals->data + hdr_len);
+	count = be32_to_cpu(hdr->size);
+	err = b43_write_initvals(dev, ivals, count,
+				 fw->initvals->size - hdr_len);
 	if (err)
 		goto out;
 	if (fw->initvals_band) {
-		ivals = (struct b43_initval *)(fw->initvals_band->data);
-		count = fw->initvals_band->size / sizeof(struct b43_initval);
-		err = b43_write_initvals(dev, ivals, count);
+		hdr = (const struct b43_fw_header *)(fw->initvals_band->data);
+		ivals = (const struct b43_iv *)(fw->initvals_band->data + hdr_len);
+		count = be32_to_cpu(hdr->size);
+		err = b43_write_initvals(dev, ivals, count,
+					 fw->initvals_band->size - hdr_len);
+		if (err)
+			goto out;
 	}
 out:
 

-- 

