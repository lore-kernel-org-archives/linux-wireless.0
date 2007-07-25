Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:54766 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760500AbXGYUsi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 16:48:38 -0400
Received: by ug-out-1314.google.com with SMTP id j3so420027ugf
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2007 13:48:36 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 06/11] rt2x00: Reduce requirement for debugfs wrapper functions
Date: Wed, 25 Jul 2007 22:50:15 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707252250.15946.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 6a6a1092f310fcea951cac0072287073b1fd4e93 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Tue, 24 Jul 2007 17:31:09 +0200
Subject: [PATCH 06/11] rt2x00: Reduce requirement for debugfs wrapper functions

Because the callback functions for each register for
very generic, individual drivers needed to add wrapper
functions to translate passed values to the correct type.

We should make rt2x00debug more aware of the different types,
and make both the rt2x00debug code less complex by adding
some better helper macros. And help the driver part by removing
the requirement of wrapper functions for BBP and EEPROM.
CSR wrapping remains requirement due to the word->offset
translation.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/mac80211/rt2x00/rt2400pci.c   |   56 ++----
 drivers/net/wireless/mac80211/rt2x00/rt2500pci.c   |   56 ++----
 drivers/net/wireless/mac80211/rt2x00/rt2500usb.c   |   66 ++----
 drivers/net/wireless/mac80211/rt2x00/rt2x00.h      |    4 +-
 drivers/net/wireless/mac80211/rt2x00/rt2x00debug.c |  240 +++++++-------------
 drivers/net/wireless/mac80211/rt2x00/rt2x00debug.h |   27 +--
 drivers/net/wireless/mac80211/rt2x00/rt61pci.c     |   56 ++----
 drivers/net/wireless/mac80211/rt2x00/rt73usb.c     |   64 ++----
 8 files changed, 192 insertions(+), 377 deletions(-)

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index a6c7602..62d742c 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -74,7 +74,7 @@ static u32 rt2400pci_bbp_check(const struct rt2x00_dev *rt2x00dev)
 }
 
 static void rt2400pci_bbp_write(const struct rt2x00_dev *rt2x00dev,
-	const u8 reg_id, const u8 value)
+	const unsigned int word, const u8 value)
 {
 	u32 reg;
 
@@ -92,7 +92,7 @@ static void rt2400pci_bbp_write(const struct rt2x00_dev *rt2x00dev,
 	 */
 	reg = 0;
 	rt2x00_set_field32(&reg, BBPCSR_VALUE, value);
-	rt2x00_set_field32(&reg, BBPCSR_REGNUM, reg_id);
+	rt2x00_set_field32(&reg, BBPCSR_REGNUM, word);
 	rt2x00_set_field32(&reg, BBPCSR_BUSY, 1);
 	rt2x00_set_field32(&reg, BBPCSR_WRITE_CONTROL, 1);
 
@@ -100,7 +100,7 @@ static void rt2400pci_bbp_write(const struct rt2x00_dev *rt2x00dev,
 }
 
 static void rt2400pci_bbp_read(const struct rt2x00_dev *rt2x00dev,
-	const u8 reg_id, u8 *value)
+	const unsigned int word, u8 *value)
 {
 	u32 reg;
 
@@ -117,7 +117,7 @@ static void rt2400pci_bbp_read(const struct rt2x00_dev *rt2x00dev,
 	 * Write the request into the BBP.
 	 */
 	reg = 0;
-	rt2x00_set_field32(&reg, BBPCSR_REGNUM, reg_id);
+	rt2x00_set_field32(&reg, BBPCSR_REGNUM, word);
 	rt2x00_set_field32(&reg, BBPCSR_BUSY, 1);
 	rt2x00_set_field32(&reg, BBPCSR_WRITE_CONTROL, 0);
 
@@ -199,59 +199,35 @@ static void rt2400pci_eepromregister_write(struct eeprom_93cx6 *eeprom)
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 #define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
 
-static void rt2400pci_read_csr(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
+static void rt2400pci_read_csr(const struct rt2x00_dev *rt2x00dev,
+	const unsigned int word, u32 *data)
 {
 	rt2x00pci_register_read(rt2x00dev, CSR_OFFSET(word), data);
 }
 
-static void rt2400pci_write_csr(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
+static void rt2400pci_write_csr(const struct rt2x00_dev *rt2x00dev,
+	const unsigned int word, u32 data)
 {
-	rt2x00pci_register_write(rt2x00dev, CSR_OFFSET(word), *((u32*)data));
-}
-
-static void rt2400pci_read_eeprom(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
-{
-	rt2x00_eeprom_read(rt2x00dev, word, data);
-}
-
-static void rt2400pci_write_eeprom(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
-{
-	rt2x00_eeprom_write(rt2x00dev, word, *((u16*)data));
-}
-
-static void rt2400pci_read_bbp(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
-{
-	rt2400pci_bbp_read(rt2x00dev, word, data);
-}
-
-static void rt2400pci_write_bbp(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
-{
-	rt2400pci_bbp_write(rt2x00dev, word, *((u8*)data));
+	rt2x00pci_register_write(rt2x00dev, CSR_OFFSET(word), data);
 }
 
 static const struct rt2x00debug rt2400pci_rt2x00debug = {
 	.owner 		= THIS_MODULE,
-	.reg_csr	= {
+	.csr	= {
 		.read		= rt2400pci_read_csr,
 		.write		= rt2400pci_write_csr,
 		.word_size	= sizeof(u32),
 		.word_count	= CSR_REG_SIZE / sizeof(u32),
 	},
-	.reg_eeprom	= {
-		.read		= rt2400pci_read_eeprom,
-		.write		= rt2400pci_write_eeprom,
+	.eeprom	= {
+		.read		= rt2x00_eeprom_read,
+		.write		= rt2x00_eeprom_write,
 		.word_size	= sizeof(u16),
 		.word_count	= EEPROM_SIZE / sizeof(u16),
 	},
-	.reg_bbp	= {
-		.read		= rt2400pci_read_bbp,
-		.write		= rt2400pci_write_bbp,
+	.bbp	= {
+		.read		= rt2400pci_bbp_read,
+		.write		= rt2400pci_bbp_write,
 		.word_size	= sizeof(u8),
 		.word_count	= BBP_SIZE / sizeof(u8),
 	},
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index 088c717..3aa4e5f 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -74,7 +74,7 @@ static u32 rt2500pci_bbp_check(const struct rt2x00_dev *rt2x00dev)
 }
 
 static void rt2500pci_bbp_write(const struct rt2x00_dev *rt2x00dev,
-	const u8 reg_id, const u8 value)
+	const unsigned int word, const u8 value)
 {
 	u32 reg;
 
@@ -92,7 +92,7 @@ static void rt2500pci_bbp_write(const struct rt2x00_dev *rt2x00dev,
 	 */
 	reg = 0;
 	rt2x00_set_field32(&reg, BBPCSR_VALUE, value);
-	rt2x00_set_field32(&reg, BBPCSR_REGNUM, reg_id);
+	rt2x00_set_field32(&reg, BBPCSR_REGNUM, word);
 	rt2x00_set_field32(&reg, BBPCSR_BUSY, 1);
 	rt2x00_set_field32(&reg, BBPCSR_WRITE_CONTROL, 1);
 
@@ -100,7 +100,7 @@ static void rt2500pci_bbp_write(const struct rt2x00_dev *rt2x00dev,
 }
 
 static void rt2500pci_bbp_read(const struct rt2x00_dev *rt2x00dev,
-	const u8 reg_id, u8 *value)
+	const unsigned int word, u8 *value)
 {
 	u32 reg;
 
@@ -117,7 +117,7 @@ static void rt2500pci_bbp_read(const struct rt2x00_dev *rt2x00dev,
 	 * Write the request into the BBP.
 	 */
 	reg = 0;
-	rt2x00_set_field32(&reg, BBPCSR_REGNUM, reg_id);
+	rt2x00_set_field32(&reg, BBPCSR_REGNUM, word);
 	rt2x00_set_field32(&reg, BBPCSR_BUSY, 1);
 	rt2x00_set_field32(&reg, BBPCSR_WRITE_CONTROL, 0);
 
@@ -199,59 +199,35 @@ static void rt2500pci_eepromregister_write(struct eeprom_93cx6 *eeprom)
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 #define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
 
-static void rt2500pci_read_csr(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
+static void rt2500pci_read_csr(const struct rt2x00_dev *rt2x00dev,
+	const unsigned int word, u32 *data)
 {
 	rt2x00pci_register_read(rt2x00dev, CSR_OFFSET(word), data);
 }
 
-static void rt2500pci_write_csr(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
+static void rt2500pci_write_csr(const struct rt2x00_dev *rt2x00dev,
+	const unsigned int word, u32 data)
 {
-	rt2x00pci_register_write(rt2x00dev, CSR_OFFSET(word), *((u32*)data));
-}
-
-static void rt2500pci_read_eeprom(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
-{
-	rt2x00_eeprom_read(rt2x00dev, word, data);
-}
-
-static void rt2500pci_write_eeprom(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
-{
-	rt2x00_eeprom_write(rt2x00dev, word, *((u16*)data));
-}
-
-static void rt2500pci_read_bbp(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
-{
-	rt2500pci_bbp_read(rt2x00dev, word, data);
-}
-
-static void rt2500pci_write_bbp(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
-{
-	rt2500pci_bbp_write(rt2x00dev, word, *((u8*)data));
+	rt2x00pci_register_write(rt2x00dev, CSR_OFFSET(word), data);
 }
 
 static const struct rt2x00debug rt2500pci_rt2x00debug = {
 	.owner 		= THIS_MODULE,
-	.reg_csr	= {
+	.csr	= {
 		.read		= rt2500pci_read_csr,
 		.write		= rt2500pci_write_csr,
 		.word_size	= sizeof(u32),
 		.word_count	= CSR_REG_SIZE / sizeof(u32),
 	},
-	.reg_eeprom	= {
-		.read		= rt2500pci_read_eeprom,
-		.write		= rt2500pci_write_eeprom,
+	.eeprom	= {
+		.read		= rt2x00_eeprom_read,
+		.write		= rt2x00_eeprom_write,
 		.word_size	= sizeof(u16),
 		.word_count	= EEPROM_SIZE / sizeof(u16),
 	},
-	.reg_bbp	= {
-		.read		= rt2500pci_read_bbp,
-		.write		= rt2500pci_write_bbp,
+	.bbp	= {
+		.read		= rt2500pci_bbp_read,
+		.write		= rt2500pci_bbp_write,
 		.word_size	= sizeof(u8),
 		.word_count	= BBP_SIZE / sizeof(u8),
 	},
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index 8967155..77e7a95 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -56,7 +56,7 @@
  */
 static inline void rt2500usb_register_read(
 	const struct rt2x00_dev *rt2x00dev,
-	const u16 offset, u16 *value)
+	const unsigned int offset, u16 *value)
 {
 	__le16 reg;
 	rt2x00usb_vendor_request(
@@ -67,7 +67,7 @@ static inline void rt2500usb_register_read(
 
 static inline void rt2500usb_register_multiread(
 	const struct rt2x00_dev *rt2x00dev,
-	const u16 offset, void *value, const u16 length)
+	const unsigned int offset, void *value, const u16 length)
 {
 	rt2x00usb_vendor_request(
 		rt2x00dev, USB_MULTI_READ, USB_VENDOR_REQUEST_IN,
@@ -77,7 +77,7 @@ static inline void rt2500usb_register_multiread(
 
 static inline void rt2500usb_register_write(
 	const struct rt2x00_dev *rt2x00dev,
-	const u16 offset, u16 value)
+	const unsigned int offset, u16 value)
 {
 	__le16 reg = cpu_to_le16(value);
 	rt2x00usb_vendor_request(
@@ -87,7 +87,7 @@ static inline void rt2500usb_register_write(
 
 static inline void rt2500usb_register_multiwrite(
 	const struct rt2x00_dev *rt2x00dev,
-	const u16 offset, void *value, const u16 length)
+	const unsigned int offset, void *value, const u16 length)
 {
 	rt2x00usb_vendor_request(
 		rt2x00dev, USB_MULTI_WRITE, USB_VENDOR_REQUEST_OUT,
@@ -111,7 +111,7 @@ static u16 rt2500usb_bbp_check(const struct rt2x00_dev *rt2x00dev)
 }
 
 static void rt2500usb_bbp_write(const struct rt2x00_dev *rt2x00dev,
-	const u8 reg_id, const u8 value)
+	const unsigned int word, const u8 value)
 {
 	u16 reg;
 
@@ -129,14 +129,14 @@ static void rt2500usb_bbp_write(const struct rt2x00_dev *rt2x00dev,
 	 */
 	reg = 0;
 	rt2x00_set_field16(&reg, PHY_CSR7_DATA, value);
-	rt2x00_set_field16(&reg, PHY_CSR7_REG_ID, reg_id);
+	rt2x00_set_field16(&reg, PHY_CSR7_REG_ID, word);
 	rt2x00_set_field16(&reg, PHY_CSR7_READ_CONTROL, 0);
 
 	rt2500usb_register_write(rt2x00dev, PHY_CSR7, reg);
 }
 
 static void rt2500usb_bbp_read(const struct rt2x00_dev *rt2x00dev,
-	const u8 reg_id, u8 *value)
+	const unsigned int word, u8 *value)
 {
 	u16 reg;
 
@@ -153,7 +153,7 @@ static void rt2500usb_bbp_read(const struct rt2x00_dev *rt2x00dev,
 	 * Write the request into the BBP.
 	 */
 	reg =0;
-	rt2x00_set_field16(&reg, PHY_CSR7_REG_ID, reg_id);
+	rt2x00_set_field16(&reg, PHY_CSR7_REG_ID, word);
 	rt2x00_set_field16(&reg, PHY_CSR7_READ_CONTROL, 1);
 
 	rt2500usb_register_write(rt2x00dev, PHY_CSR7, reg);
@@ -205,59 +205,35 @@ rf_write:
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 #define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u16)) )
 
-static void rt2500usb_read_csr(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
+static void rt2500usb_read_csr(const struct rt2x00_dev *rt2x00dev,
+	const unsigned int word, u32 *data)
 {
-	rt2500usb_register_read(rt2x00dev, CSR_OFFSET(word), data);
+	rt2500usb_register_read(rt2x00dev, CSR_OFFSET(word), (u16*)data);
 }
 
-static void rt2500usb_write_csr(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
+static void rt2500usb_write_csr(const struct rt2x00_dev *rt2x00dev,
+	const unsigned int word, u32 data)
 {
-	rt2500usb_register_write(rt2x00dev, CSR_OFFSET(word), *((u16*)data));
-}
-
-static void rt2500usb_read_eeprom(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
-{
-	rt2x00_eeprom_read(rt2x00dev, word, data);
-}
-
-static void rt2500usb_write_eeprom(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
-{
-	rt2x00_eeprom_write(rt2x00dev, word, *((u16*)data));
-}
-
-static void rt2500usb_read_bbp(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
-{
-	rt2500usb_bbp_read(rt2x00dev, word, data);
-}
-
-static void rt2500usb_write_bbp(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
-{
-	rt2500usb_bbp_write(rt2x00dev, word, *((u8*)data));
+	rt2500usb_register_write(rt2x00dev, CSR_OFFSET(word), data);
 }
 
 static const struct rt2x00debug rt2500usb_rt2x00debug = {
 	.owner 		= THIS_MODULE,
-	.reg_csr	= {
+	.csr	= {
 		.read		= rt2500usb_read_csr,
 		.write		= rt2500usb_write_csr,
 		.word_size	= sizeof(u16),
 		.word_count	= CSR_REG_SIZE / sizeof(u16),
 	},
-	.reg_eeprom	= {
-		.read		= rt2500usb_read_eeprom,
-		.write		= rt2500usb_write_eeprom,
+	.eeprom	= {
+		.read		= rt2x00_eeprom_read,
+		.write		= rt2x00_eeprom_write,
 		.word_size	= sizeof(u16),
 		.word_count	= EEPROM_SIZE / sizeof(u16),
 	},
-	.reg_bbp	= {
-		.read		= rt2500usb_read_bbp,
-		.write		= rt2500usb_write_bbp,
+	.bbp	= {
+		.read		= rt2500usb_bbp_read,
+		.write		= rt2500usb_bbp_write,
 		.word_size	= sizeof(u8),
 		.word_count	= BBP_SIZE / sizeof(u8),
 	},
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
index bc4557d..4a71a96 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
@@ -951,13 +951,13 @@ static inline void* rt2x00_eeprom_addr(const struct rt2x00_dev *rt2x00dev,
 }
 
 static inline void rt2x00_eeprom_read(const struct rt2x00_dev *rt2x00dev,
-	const u8 word, u16 *data)
+	const unsigned int word, u16 *data)
 {
 	*data = le16_to_cpu(rt2x00dev->eeprom[word]);
 }
 
 static inline void rt2x00_eeprom_write(const struct rt2x00_dev *rt2x00dev,
-	const u8 word, u16 data)
+	const unsigned int word, u16 data)
 {
 	rt2x00dev->eeprom[word] = cpu_to_le16(data);
 }
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.c b/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.c
index e99d783..3ff07e2 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.c
@@ -107,127 +107,74 @@ static int rt2x00debug_file_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static ssize_t rt2x00debug_file_read(void *device, char __user *buf,
-	loff_t *offset, unsigned int word, const struct rt2x00debug_reg *reg)
-{
-	unsigned long value;
-	unsigned int size;
-	char *line;
-
-	if (*offset)
-		return 0;
-
-	line = kzalloc(PRINT_REG_LEN_MAX, GFP_KERNEL);
-	if (!line)
-		return -ENOMEM;
-
-	reg->read(device, word, &value);
-
-	if (reg->word_size == sizeof(u8))
-		size = sprintf(line, PRINT_REG8_STR, (u8)value);
-	else if (reg->word_size == sizeof(u16))
-		size = sprintf(line, PRINT_REG16_STR, (u16)value);
-	else
-		size = sprintf(line, PRINT_REG32_STR, (u32)value);
-
-	if (copy_to_user(buf, line, size))
-		goto exit;
-
-	kfree(line);
-
-	*offset += size;
-	return size;
-
-exit:
-	kfree(line);
-
-	return -EFAULT;
+#define RT2X00DEBUGFS_OPS_READ(__name, __format, __type)	\
+static ssize_t rt2x00debug_read_##__name(struct file *file,	\
+	char __user *buf, size_t length, loff_t *offset)	\
+{								\
+	struct rt2x00debug_intf *intf =	file->private_data;	\
+	const struct rt2x00debug *debug = intf->debug;		\
+	char line[16];						\
+	size_t size;						\
+	__type value;						\
+								\
+	if (intf->offset_##__name > debug->__name.word_count)	\
+		return -EINVAL;					\
+								\
+	debug->__name.read(intf->rt2x00dev,			\
+		intf->offset_##__name, &value);			\
+								\
+	size = sprintf(line, __format, value);			\
+								\
+	if (copy_to_user(buf, line, size))			\
+		return -EFAULT;					\
+								\
+	*offset += size;					\
+	return size;						\
 }
 
-static ssize_t rt2x00debug_file_write(void *device, const char __user *buf,
-	loff_t *offset, unsigned int word, unsigned int length,
-	const struct rt2x00debug_reg *reg)
-{
-	unsigned long value;
-	int size;
-	char *line;
-
-	if (!capable(CAP_NET_ADMIN))
-		return -EPERM;
-
-	line = kzalloc(length, GFP_KERNEL);
-	if (!line)
-		return -ENOMEM;
-
-	if (copy_from_user(line, buf, length))
-		goto exit;
-
-	size = strlen(line);
-	value = simple_strtoul(line, NULL, 0);
-
-	reg->write(device, word, &value);
-
-	kfree(line);
-
-	*offset += size;
-	return size;
-
-exit:
-	kfree(line);
-
-	return -EFAULT;
+#define RT2X00DEBUGFS_OPS_WRITE(__name, __type)			\
+static ssize_t rt2x00debug_write_##__name(struct file *file,	\
+	const char __user *buf, size_t length, loff_t *offset)	\
+{								\
+	struct rt2x00debug_intf *intf =	file->private_data;	\
+	const struct rt2x00debug *debug = intf->debug;		\
+	char line[16];						\
+	size_t size;						\
+	__type value;						\
+								\
+	if (!capable(CAP_NET_ADMIN))				\
+		return -EPERM;					\
+								\
+	if (intf->offset_##__name > debug->__name.word_count)	\
+		return -EINVAL;					\
+								\
+	if (copy_from_user(line, buf, length))			\
+		return -EFAULT;					\
+								\
+	size = strlen(line);					\
+	value = simple_strtoul(line, NULL, 0);			\
+								\
+	debug->__name.write(intf->rt2x00dev,			\
+		intf->offset_##__name, value);			\
+								\
+	*offset += size;					\
+	return size;						\
 }
 
-#define RT2X00DEBUGFS_OPS_READ(__name)					\
-	static ssize_t rt2x00debug_read_##__name(struct file *file,	\
-		char __user *buf, size_t length, loff_t *offset)	\
-	{								\
-		struct rt2x00debug_intf *intf =	file->private_data;	\
-		const struct rt2x00debug *debug = intf->debug;		\
-		const struct rt2x00debug_reg *reg = &debug->reg_##__name;\
-									\
-		if (intf->offset_##__name > reg->word_count)		\
-			return -EINVAL;					\
-									\
-		return rt2x00debug_file_read(intf->rt2x00dev, buf,	\
-			offset, intf->offset_##__name, reg);		\
-	}
-
-RT2X00DEBUGFS_OPS_READ(csr);
-RT2X00DEBUGFS_OPS_READ(eeprom);
-RT2X00DEBUGFS_OPS_READ(bbp);
-
-#define RT2X00DEBUGFS_OPS_WRITE(__name)					\
-	static ssize_t rt2x00debug_write_##__name(struct file *file,	\
-		const char __user *buf, size_t length, loff_t *offset)	\
-	{								\
-		struct rt2x00debug_intf *intf =	file->private_data;	\
-		const struct rt2x00debug *debug = intf->debug;		\
-		const struct rt2x00debug_reg *reg = &debug->reg_##__name;\
-									\
-		if (intf->offset_##__name > reg->word_count)		\
-			return -EINVAL;					\
-									\
-		return rt2x00debug_file_write(intf->rt2x00dev, buf,	\
-			offset, intf->offset_##__name, length, reg);	\
-	}
-
-RT2X00DEBUGFS_OPS_WRITE(csr);
-RT2X00DEBUGFS_OPS_WRITE(eeprom);
-RT2X00DEBUGFS_OPS_WRITE(bbp);
-
-#define RT2X00DEBUGFS_OPS(__name)					\
-	static const struct file_operations rt2x00debug_fop_##__name = {\
-		.owner		= THIS_MODULE,				\
-		.read		= rt2x00debug_read_##__name,		\
-		.write		= rt2x00debug_write_##__name,		\
-		.open		= rt2x00debug_file_open,		\
-		.release	= rt2x00debug_file_release,		\
-	};
+#define RT2X00DEBUGFS_OPS(__name, __format, __type)		\
+RT2X00DEBUGFS_OPS_READ(__name, __format, __type);		\
+RT2X00DEBUGFS_OPS_WRITE(__name, __type);			\
+static const struct file_operations rt2x00debug_fop_##__name = {\
+	.owner		= THIS_MODULE,				\
+	.read		= rt2x00debug_read_##__name,		\
+	.write		= rt2x00debug_write_##__name,		\
+	.open		= rt2x00debug_file_open,		\
+	.release	= rt2x00debug_file_release,		\
+};
 
-RT2X00DEBUGFS_OPS(csr);
-RT2X00DEBUGFS_OPS(eeprom);
-RT2X00DEBUGFS_OPS(bbp);
+RT2X00DEBUGFS_OPS(csr, "0x%.8x\n", u32);
+RT2X00DEBUGFS_OPS(eeprom, "0x%.4x\n", u16);
+RT2X00DEBUGFS_OPS(bbp, "0x%.2x\n", u8);
 
 static struct dentry *rt2x00debug_create_file_driver(const char *name,
 	struct rt2x00debug_intf *intf, struct debugfs_blob_wrapper *blob)
@@ -258,10 +205,9 @@ static struct dentry *rt2x00debug_create_file_chipset(const char *name,
 		return NULL;
 
 	blob->data = data;
-	data += sprintf(data, "csr length: %d\n", debug->reg_csr.word_count);
-	data += sprintf(data, "eeprom length: %d\n",
-		debug->reg_eeprom.word_count);
-	data += sprintf(data, "bbp length: %d\n", debug->reg_bbp.word_count);
+	data += sprintf(data, "csr length: %d\n", debug->csr.word_count);
+	data += sprintf(data, "eeprom length: %d\n", debug->eeprom.word_count);
+	data += sprintf(data, "bbp length: %d\n", debug->bbp.word_count);
 	blob->size = strlen(blob->data);
 
 	return debugfs_create_blob(name, S_IRUGO, intf->driver_folder, blob);
@@ -297,38 +243,28 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 	if (IS_ERR(intf->chipset_entry))
 		goto exit;
 
-	intf->csr_off_entry = debugfs_create_u32("csr_offset",
-		S_IRUGO | S_IWUSR, intf->driver_folder, &intf->offset_csr);
-	if (IS_ERR(intf->csr_off_entry))
-		goto exit;
-
-	intf->csr_val_entry = debugfs_create_file("csr_value",
-		S_IRUGO | S_IWUSR, intf->driver_folder, intf,
-		&rt2x00debug_fop_csr);
-	if (IS_ERR(intf->csr_val_entry))
-		goto exit;
-
-	intf->eeprom_off_entry = debugfs_create_u32("eeprom_offset",
-		S_IRUGO | S_IWUSR, intf->driver_folder, &intf->offset_eeprom);
-	if (IS_ERR(intf->eeprom_off_entry))
-		goto exit;
-
-	intf->eeprom_val_entry = debugfs_create_file("eeprom_value",
-		S_IRUGO | S_IWUSR, intf->driver_folder, intf,
-		&rt2x00debug_fop_eeprom);
-	if (IS_ERR(intf->eeprom_val_entry))
-		goto exit;
-
-	intf->bbp_off_entry = debugfs_create_u32("bbp_offset",
-		S_IRUGO | S_IWUSR, intf->driver_folder, &intf->offset_bbp);
-	if (IS_ERR(intf->bbp_off_entry))
-		goto exit;
-
-	intf->bbp_val_entry = debugfs_create_file("bbp_value",
-		S_IRUGO | S_IWUSR, intf->driver_folder, intf,
-		&rt2x00debug_fop_bbp);
-	if (IS_ERR(intf->bbp_val_entry))
-		goto exit;
+#define RT2X00DEBUGFS_CREATE_ENTRY(__name)		\
+({							\
+	intf->__name##_off_entry = debugfs_create_u32(	\
+		__stringify(__name) "_offset",		\
+		S_IRUGO | S_IWUSR, intf->driver_folder,	\
+		&intf->offset_##__name);		\
+	if (IS_ERR(intf->__name##_off_entry))		\
+		goto exit;				\
+							\
+	intf->__name##_val_entry = debugfs_create_file(	\
+		__stringify(__name) "_value",		\
+		S_IRUGO | S_IWUSR, intf->driver_folder,	\
+		intf, &rt2x00debug_fop_##__name);	\
+	if (IS_ERR(intf->__name##_val_entry))		\
+		goto exit;				\
+})
+
+	RT2X00DEBUGFS_CREATE_ENTRY(csr);
+	RT2X00DEBUGFS_CREATE_ENTRY(eeprom);
+	RT2X00DEBUGFS_CREATE_ENTRY(bbp);
+
+#undef RT2X00DEBUGFS_CREATE_ENTRY
 
 	return;
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.h
index 680811c..82b4df8 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.h
@@ -30,16 +30,15 @@
 
 #include <net/wireless.h>
 
-typedef void (debug_access_t)(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data);
-
-struct rt2x00debug_reg {
-	debug_access_t *read;
-	debug_access_t *write;
-
-	unsigned int word_size;
-	unsigned int word_count;
-};
+#define RT2X00DEBUGFS_REGISTER_ENTRY(__name, __type)	\
+struct reg##__name {					\
+	void (*read)(const struct rt2x00_dev *rt2x00dev,\
+		const unsigned int word, __type *data);	\
+	void (*write)(const struct rt2x00_dev *rt2x00dev,\
+		const unsigned int word, __type data);	\
+	unsigned int word_size;				\
+	unsigned int word_count;			\
+} __name
 
 struct rt2x00debug {
 	/*
@@ -48,11 +47,11 @@ struct rt2x00debug {
 	struct module *owner;
 
 	/*
-	 * Register access information.
+	 * Register access entries.
 	 */
-	struct rt2x00debug_reg reg_csr;
-	struct rt2x00debug_reg reg_eeprom;
-	struct rt2x00debug_reg reg_bbp;
+	RT2X00DEBUGFS_REGISTER_ENTRY(csr, u32);
+	RT2X00DEBUGFS_REGISTER_ENTRY(eeprom, u16);
+	RT2X00DEBUGFS_REGISTER_ENTRY(bbp, u8);
 };
 
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index ad66cc1..3999cc8 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -72,7 +72,7 @@ static u32 rt61pci_bbp_check(const struct rt2x00_dev *rt2x00dev)
 }
 
 static void rt61pci_bbp_write(const struct rt2x00_dev *rt2x00dev,
-	const u8 reg_id, const u8 value)
+	const unsigned int word, const u8 value)
 {
 	u32 reg;
 
@@ -90,7 +90,7 @@ static void rt61pci_bbp_write(const struct rt2x00_dev *rt2x00dev,
 	 */
 	reg = 0;
 	rt2x00_set_field32(&reg, PHY_CSR3_VALUE, value);
-	rt2x00_set_field32(&reg, PHY_CSR3_REGNUM, reg_id);
+	rt2x00_set_field32(&reg, PHY_CSR3_REGNUM, word);
 	rt2x00_set_field32(&reg, PHY_CSR3_BUSY, 1);
 	rt2x00_set_field32(&reg, PHY_CSR3_READ_CONTROL, 0);
 
@@ -98,7 +98,7 @@ static void rt61pci_bbp_write(const struct rt2x00_dev *rt2x00dev,
 }
 
 static void rt61pci_bbp_read(const struct rt2x00_dev *rt2x00dev,
-	const u8 reg_id, u8 *value)
+	const unsigned int word, u8 *value)
 {
 	u32 reg;
 
@@ -115,7 +115,7 @@ static void rt61pci_bbp_read(const struct rt2x00_dev *rt2x00dev,
 	 * Write the request into the BBP.
 	 */
 	reg =0;
-	rt2x00_set_field32(&reg, PHY_CSR3_REGNUM, reg_id);
+	rt2x00_set_field32(&reg, PHY_CSR3_REGNUM, word);
 	rt2x00_set_field32(&reg, PHY_CSR3_BUSY, 1);
 	rt2x00_set_field32(&reg, PHY_CSR3_READ_CONTROL, 1);
 
@@ -223,59 +223,35 @@ static void rt61pci_eepromregister_write(struct eeprom_93cx6 *eeprom)
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 #define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
 
-static void rt61pci_read_csr(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
+static void rt61pci_read_csr(const struct rt2x00_dev *rt2x00dev,
+	const unsigned int word, u32 *data)
 {
 	rt2x00pci_register_read(rt2x00dev, CSR_OFFSET(word), data);
 }
 
-static void rt61pci_write_csr(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
+static void rt61pci_write_csr(const struct rt2x00_dev *rt2x00dev,
+	const unsigned int word, u32 data)
 {
-	rt2x00pci_register_write(rt2x00dev, CSR_OFFSET(word), *((u32*)data));
-}
-
-static void rt61pci_read_eeprom(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
-{
-	rt2x00_eeprom_read(rt2x00dev, word, data);
-}
-
-static void rt61pci_write_eeprom(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
-{
-	rt2x00_eeprom_write(rt2x00dev, word, *((u16*)data));
-}
-
-static void rt61pci_read_bbp(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
-{
-	rt61pci_bbp_read(rt2x00dev, word, data);
-}
-
-static void rt61pci_write_bbp(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
-{
-	rt61pci_bbp_write(rt2x00dev, word, *((u8*)data));
+	rt2x00pci_register_write(rt2x00dev, CSR_OFFSET(word), data);
 }
 
 static const struct rt2x00debug rt61pci_rt2x00debug = {
 	.owner 		= THIS_MODULE,
-	.reg_csr	= {
+	.csr	= {
 		.read		= rt61pci_read_csr,
 		.write		= rt61pci_write_csr,
 		.word_size	= sizeof(u32),
 		.word_count	= CSR_REG_SIZE / sizeof(u32),
 	},
-	.reg_eeprom	= {
-		.read		= rt61pci_read_eeprom,
-		.write		= rt61pci_write_eeprom,
+	.eeprom	= {
+		.read		= rt2x00_eeprom_read,
+		.write		= rt2x00_eeprom_write,
 		.word_size	= sizeof(u16),
 		.word_count	= EEPROM_SIZE / sizeof(u16),
 	},
-	.reg_bbp	= {
-		.read		= rt61pci_read_bbp,
-		.write		= rt61pci_write_bbp,
+	.bbp	= {
+		.read		= rt61pci_bbp_read,
+		.write		= rt61pci_bbp_write,
 		.word_size	= sizeof(u8),
 		.word_count	= BBP_SIZE / sizeof(u8),
 	},
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index 664cd38..0188c72 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -56,7 +56,7 @@
  */
 static inline void rt73usb_register_read(
 	const struct rt2x00_dev *rt2x00dev,
-	const u16 offset, u32 *value)
+	const unsigned int offset, u32 *value)
 {
 	__le32 reg;
 	rt2x00usb_vendor_request(
@@ -67,7 +67,7 @@ static inline void rt73usb_register_read(
 
 static inline void rt73usb_register_multiread(
 	const struct rt2x00_dev *rt2x00dev,
-	const u16 offset, void *value, const u32 length)
+	const unsigned int offset, void *value, const u32 length)
 {
 	rt2x00usb_vendor_request(
 		rt2x00dev, USB_MULTI_READ, USB_VENDOR_REQUEST_IN,
@@ -77,7 +77,7 @@ static inline void rt73usb_register_multiread(
 
 static inline void rt73usb_register_write(
 	const struct rt2x00_dev *rt2x00dev,
-	const u16 offset, u32 value)
+	const unsigned int offset, u32 value)
 {
 	__le32 reg = cpu_to_le32(value);
 	rt2x00usb_vendor_request(
@@ -87,7 +87,7 @@ static inline void rt73usb_register_write(
 
 static inline void rt73usb_register_multiwrite(
 	const struct rt2x00_dev *rt2x00dev,
-	const u16 offset, void *value, const u32 length)
+	const unsigned int offset, void *value, const u32 length)
 {
 	rt2x00usb_vendor_request(
 		rt2x00dev, USB_MULTI_WRITE, USB_VENDOR_REQUEST_OUT,
@@ -111,7 +111,7 @@ static u32 rt73usb_bbp_check(const struct rt2x00_dev *rt2x00dev)
 }
 
 static void rt73usb_bbp_write(const struct rt2x00_dev *rt2x00dev,
-	const u8 reg_id, const u8 value)
+	const unsigned int word, const u8 value)
 {
 	u32 reg;
 
@@ -129,7 +129,7 @@ static void rt73usb_bbp_write(const struct rt2x00_dev *rt2x00dev,
 	 */
 	reg = 0;
 	rt2x00_set_field32(&reg, PHY_CSR3_VALUE, value);
-	rt2x00_set_field32(&reg, PHY_CSR3_REGNUM, reg_id);
+	rt2x00_set_field32(&reg, PHY_CSR3_REGNUM, word);
 	rt2x00_set_field32(&reg, PHY_CSR3_BUSY, 1);
 	rt2x00_set_field32(&reg, PHY_CSR3_READ_CONTROL, 0);
 
@@ -137,7 +137,7 @@ static void rt73usb_bbp_write(const struct rt2x00_dev *rt2x00dev,
 }
 
 static void rt73usb_bbp_read(const struct rt2x00_dev *rt2x00dev,
-	const u8 reg_id, u8 *value)
+	const unsigned int word, u8 *value)
 {
 	u32 reg;
 
@@ -154,7 +154,7 @@ static void rt73usb_bbp_read(const struct rt2x00_dev *rt2x00dev,
 	 * Write the request into the BBP.
 	 */
 	reg =0;
-	rt2x00_set_field32(&reg, PHY_CSR3_REGNUM, reg_id);
+	rt2x00_set_field32(&reg, PHY_CSR3_REGNUM, word);
 	rt2x00_set_field32(&reg, PHY_CSR3_BUSY, 1);
 	rt2x00_set_field32(&reg, PHY_CSR3_READ_CONTROL, 1);
 
@@ -202,59 +202,35 @@ rf_write:
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 #define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
 
-static void rt73usb_read_csr(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
+static void rt73usb_read_csr(const struct rt2x00_dev *rt2x00dev,
+	const unsigned int word, u32 *data)
 {
 	rt73usb_register_read(rt2x00dev, CSR_OFFSET(word), data);
 }
 
-static void rt73usb_write_csr(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
+static void rt73usb_write_csr(const struct rt2x00_dev *rt2x00dev,
+	const unsigned int word, u32 data)
 {
-	rt73usb_register_write(rt2x00dev, CSR_OFFSET(word), *((u32*)data));
-}
-
-static void rt73usb_read_eeprom(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
-{
-	rt2x00_eeprom_read(rt2x00dev, word, data);
-}
-
-static void rt73usb_write_eeprom(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
-{
-	rt2x00_eeprom_write(rt2x00dev, word, *((u16*)data));
-}
-
-static void rt73usb_read_bbp(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
-{
-	rt73usb_bbp_read(rt2x00dev, word, data);
-}
-
-static void rt73usb_write_bbp(struct rt2x00_dev *rt2x00dev,
-	const unsigned int word, void *data)
-{
-	rt73usb_bbp_write(rt2x00dev, word, *((u8*)data));
+	rt73usb_register_write(rt2x00dev, CSR_OFFSET(word), data);
 }
 
 static const struct rt2x00debug rt73usb_rt2x00debug = {
 	.owner 		= THIS_MODULE,
-	.reg_csr	= {
+	.csr	= {
 		.read		= rt73usb_read_csr,
 		.write		= rt73usb_write_csr,
 		.word_size	= sizeof(u32),
 		.word_count	= CSR_REG_SIZE / sizeof(u32),
 	},
-	.reg_eeprom	= {
-		.read		= rt73usb_read_eeprom,
-		.write		= rt73usb_write_eeprom,
+	.eeprom	= {
+		.read		= rt2x00_eeprom_read,
+		.write		= rt2x00_eeprom_write,
 		.word_size	= sizeof(u16),
 		.word_count	= EEPROM_SIZE / sizeof(u16),
 	},
-	.reg_bbp	= {
-		.read		= rt73usb_read_bbp,
-		.write		= rt73usb_write_bbp,
+	.bbp	= {
+		.read		= rt73usb_bbp_read,
+		.write		= rt73usb_bbp_write,
 		.word_size	= sizeof(u8),
 		.word_count	= BBP_SIZE / sizeof(u8),
 	},
-- 
1.5.2.2

