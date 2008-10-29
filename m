Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:38679 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbYJ2SlK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 14:41:10 -0400
Received: by ey-out-2122.google.com with SMTP id 6so65751eyi.37
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 11:41:07 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Remove debugfs CSR access wrappers
Date: Wed, 29 Oct 2008 19:41:03 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810291941.03793.IvDoorn@gmail.com> (sfid-20081029_194116_417524_FAB1D6E0)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move calculation of CSR register offset into rt2x00debug.c
and remove the wrapper functions from each individual driver.
(Except rt2500usb, which still needs to wrap for the
different value type argument).

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |   23 +++++++----------------
 drivers/net/wireless/rt2x00/rt2400pci.h   |    2 ++
 drivers/net/wireless/rt2x00/rt2500pci.c   |   23 +++++++----------------
 drivers/net/wireless/rt2x00/rt2500pci.h   |    2 ++
 drivers/net/wireless/rt2x00/rt2500usb.c   |   25 +++++++++++++++----------
 drivers/net/wireless/rt2x00/rt2500usb.h   |    2 ++
 drivers/net/wireless/rt2x00/rt2x00debug.c |   22 ++++++++++++++++------
 drivers/net/wireless/rt2x00/rt2x00debug.h |   13 +++++++++++++
 drivers/net/wireless/rt2x00/rt2x00pci.h   |    8 ++++----
 drivers/net/wireless/rt2x00/rt61pci.c     |   23 +++++++----------------
 drivers/net/wireless/rt2x00/rt61pci.h     |    2 ++
 drivers/net/wireless/rt2x00/rt73usb.c     |   23 +++++++----------------
 drivers/net/wireless/rt2x00/rt73usb.h     |    2 ++
 13 files changed, 86 insertions(+), 84 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 34ee431..2350f43 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -188,43 +188,34 @@ static void rt2400pci_eepromregister_write(struct eeprom_93cx6 *eeprom)
 }
 
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-#define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
-
-static void rt2400pci_read_csr(struct rt2x00_dev *rt2x00dev,
-			       const unsigned int word, u32 *data)
-{
-	rt2x00pci_register_read(rt2x00dev, CSR_OFFSET(word), data);
-}
-
-static void rt2400pci_write_csr(struct rt2x00_dev *rt2x00dev,
-				const unsigned int word, u32 data)
-{
-	rt2x00pci_register_write(rt2x00dev, CSR_OFFSET(word), data);
-}
-
 static const struct rt2x00debug rt2400pci_rt2x00debug = {
 	.owner	= THIS_MODULE,
 	.csr	= {
-		.read		= rt2400pci_read_csr,
-		.write		= rt2400pci_write_csr,
+		.read		= rt2x00pci_register_read,
+		.write		= rt2x00pci_register_write,
+		.flags		= RT2X00DEBUGFS_OFFSET,
+		.word_base	= CSR_REG_BASE,
 		.word_size	= sizeof(u32),
 		.word_count	= CSR_REG_SIZE / sizeof(u32),
 	},
 	.eeprom	= {
 		.read		= rt2x00_eeprom_read,
 		.write		= rt2x00_eeprom_write,
+		.word_base	= EEPROM_BASE,
 		.word_size	= sizeof(u16),
 		.word_count	= EEPROM_SIZE / sizeof(u16),
 	},
 	.bbp	= {
 		.read		= rt2400pci_bbp_read,
 		.write		= rt2400pci_bbp_write,
+		.word_base	= BBP_BASE,
 		.word_size	= sizeof(u8),
 		.word_count	= BBP_SIZE / sizeof(u8),
 	},
 	.rf	= {
 		.read		= rt2x00_rf_read,
 		.write		= rt2400pci_rf_write,
+		.word_base	= RF_BASE,
 		.word_size	= sizeof(u32),
 		.word_count	= RF_SIZE / sizeof(u32),
 	},
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h b/drivers/net/wireless/rt2x00/rt2400pci.h
index bbff381..9aefda4 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/rt2x00/rt2400pci.h
@@ -46,7 +46,9 @@
 #define CSR_REG_SIZE			0x014c
 #define EEPROM_BASE			0x0000
 #define EEPROM_SIZE			0x0100
+#define BBP_BASE			0x0000
 #define BBP_SIZE			0x0020
+#define RF_BASE				0x0000
 #define RF_SIZE				0x0010
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 3e755b5..9e9a6b8 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -188,43 +188,34 @@ static void rt2500pci_eepromregister_write(struct eeprom_93cx6 *eeprom)
 }
 
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-#define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
-
-static void rt2500pci_read_csr(struct rt2x00_dev *rt2x00dev,
-			       const unsigned int word, u32 *data)
-{
-	rt2x00pci_register_read(rt2x00dev, CSR_OFFSET(word), data);
-}
-
-static void rt2500pci_write_csr(struct rt2x00_dev *rt2x00dev,
-				const unsigned int word, u32 data)
-{
-	rt2x00pci_register_write(rt2x00dev, CSR_OFFSET(word), data);
-}
-
 static const struct rt2x00debug rt2500pci_rt2x00debug = {
 	.owner	= THIS_MODULE,
 	.csr	= {
-		.read		= rt2500pci_read_csr,
-		.write		= rt2500pci_write_csr,
+		.read		= rt2x00pci_register_read,
+		.write		= rt2x00pci_register_write,
+		.flags		= RT2X00DEBUGFS_OFFSET,
+		.word_base	= CSR_REG_BASE,
 		.word_size	= sizeof(u32),
 		.word_count	= CSR_REG_SIZE / sizeof(u32),
 	},
 	.eeprom	= {
 		.read		= rt2x00_eeprom_read,
 		.write		= rt2x00_eeprom_write,
+		.word_base	= EEPROM_BASE,
 		.word_size	= sizeof(u16),
 		.word_count	= EEPROM_SIZE / sizeof(u16),
 	},
 	.bbp	= {
 		.read		= rt2500pci_bbp_read,
 		.write		= rt2500pci_bbp_write,
+		.word_base	= BBP_BASE,
 		.word_size	= sizeof(u8),
 		.word_count	= BBP_SIZE / sizeof(u8),
 	},
 	.rf	= {
 		.read		= rt2x00_rf_read,
 		.write		= rt2500pci_rf_write,
+		.word_base	= RF_BASE,
 		.word_size	= sizeof(u32),
 		.word_count	= RF_SIZE / sizeof(u32),
 	},
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.h b/drivers/net/wireless/rt2x00/rt2500pci.h
index 8c26bef..e135247 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/rt2x00/rt2500pci.h
@@ -57,7 +57,9 @@
 #define CSR_REG_SIZE			0x0174
 #define EEPROM_BASE			0x0000
 #define EEPROM_SIZE			0x0200
+#define BBP_BASE			0x0000
 #define BBP_SIZE			0x0040
+#define RF_BASE				0x0000
 #define RF_SIZE				0x0014
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 66ff8fa..36d0fab 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -245,43 +245,48 @@ rf_write:
 }
 
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-#define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u16)) )
-
-static void rt2500usb_read_csr(struct rt2x00_dev *rt2x00dev,
-			       const unsigned int word, u32 *data)
+static void _rt2500usb_register_read(struct rt2x00_dev *rt2x00dev,
+				     const unsigned int offset,
+				     u32 *value)
 {
-	rt2500usb_register_read(rt2x00dev, CSR_OFFSET(word), (u16 *) data);
+	rt2500usb_register_read(rt2x00dev, offset, (u16 *)value);
 }
 
-static void rt2500usb_write_csr(struct rt2x00_dev *rt2x00dev,
-				const unsigned int word, u32 data)
+static void _rt2500usb_register_write(struct rt2x00_dev *rt2x00dev,
+				      const unsigned int offset,
+				      u32 value)
 {
-	rt2500usb_register_write(rt2x00dev, CSR_OFFSET(word), data);
+	rt2500usb_register_write(rt2x00dev, offset, value);
 }
 
 static const struct rt2x00debug rt2500usb_rt2x00debug = {
 	.owner	= THIS_MODULE,
 	.csr	= {
-		.read		= rt2500usb_read_csr,
-		.write		= rt2500usb_write_csr,
+		.read		= _rt2500usb_register_read,
+		.write		= _rt2500usb_register_write,
+		.flags		= RT2X00DEBUGFS_OFFSET,
+		.word_base	= CSR_REG_BASE,
 		.word_size	= sizeof(u16),
 		.word_count	= CSR_REG_SIZE / sizeof(u16),
 	},
 	.eeprom	= {
 		.read		= rt2x00_eeprom_read,
 		.write		= rt2x00_eeprom_write,
+		.word_base	= EEPROM_BASE,
 		.word_size	= sizeof(u16),
 		.word_count	= EEPROM_SIZE / sizeof(u16),
 	},
 	.bbp	= {
 		.read		= rt2500usb_bbp_read,
 		.write		= rt2500usb_bbp_write,
+		.word_base	= BBP_BASE,
 		.word_size	= sizeof(u8),
 		.word_count	= BBP_SIZE / sizeof(u8),
 	},
 	.rf	= {
 		.read		= rt2x00_rf_read,
 		.write		= rt2500usb_rf_write,
+		.word_base	= RF_BASE,
 		.word_size	= sizeof(u32),
 		.word_count	= RF_SIZE / sizeof(u32),
 	},
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless/rt2x00/rt2500usb.h
index 89e5ed2..dbb5d68 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/rt2x00/rt2500usb.h
@@ -57,7 +57,9 @@
 #define CSR_REG_SIZE			0x0100
 #define EEPROM_BASE			0x0000
 #define EEPROM_SIZE			0x006a
+#define BBP_BASE			0x0000
 #define BBP_SIZE			0x0060
+#define RF_BASE				0x0000
 #define RF_SIZE				0x0014
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index a31418a..54dd100 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -424,16 +424,21 @@ static ssize_t rt2x00debug_read_##__name(struct file *file,	\
 	const struct rt2x00debug *debug = intf->debug;		\
 	char line[16];						\
 	size_t size;						\
+	unsigned int index = intf->offset_##__name;		\
 	__type value;						\
 								\
 	if (*offset)						\
 		return 0;					\
 								\
-	if (intf->offset_##__name >= debug->__name.word_count)	\
+	if (index >= debug->__name.word_count)			\
 		return -EINVAL;					\
 								\
-	debug->__name.read(intf->rt2x00dev,			\
-			   intf->offset_##__name, &value);	\
+	if (debug->__name.flags & RT2X00DEBUGFS_OFFSET)		\
+		index *= debug->__name.word_size;		\
+								\
+	index += debug->__name.word_base;			\
+								\
+	debug->__name.read(intf->rt2x00dev, index, &value);	\
 								\
 	size = sprintf(line, __format, value);			\
 								\
@@ -454,12 +459,13 @@ static ssize_t rt2x00debug_write_##__name(struct file *file,	\
 	const struct rt2x00debug *debug = intf->debug;		\
 	char line[16];						\
 	size_t size;						\
+	unsigned int index = intf->offset_##__name;		\
 	__type value;						\
 								\
 	if (*offset)						\
 		return 0;					\
 								\
-	if (intf->offset_##__name >= debug->__name.word_count)	\
+	if (index >= debug->__name.word_count)			\
 		return -EINVAL;					\
 								\
 	if (copy_from_user(line, buf, length))			\
@@ -468,8 +474,12 @@ static ssize_t rt2x00debug_write_##__name(struct file *file,	\
 	size = strlen(line);					\
 	value = simple_strtoul(line, NULL, 0);			\
 								\
-	debug->__name.write(intf->rt2x00dev,			\
-			    intf->offset_##__name, value);	\
+	if (debug->__name.flags & RT2X00DEBUGFS_OFFSET)		\
+		index *= debug->__name.word_size;		\
+								\
+	index += debug->__name.word_base;			\
+								\
+	debug->__name.write(intf->rt2x00dev, index, value);	\
 								\
 	*offset += size;					\
 	return size;						\
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.h b/drivers/net/wireless/rt2x00/rt2x00debug.h
index c4ce895..a92104d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.h
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.h
@@ -28,6 +28,16 @@
 
 struct rt2x00_dev;
 
+/**
+ * enum rt2x00debugfs_entry_flags: Flags for debugfs registry entry
+ *
+ * @RT2X00DEBUGFS_OFFSET: rt2x00lib should pass the register offset
+ *	as argument when using the callback function read()/write()
+ */
+enum rt2x00debugfs_entry_flags {
+	RT2X00DEBUGFS_OFFSET	= (1 << 0),
+};
+
 #define RT2X00DEBUGFS_REGISTER_ENTRY(__name, __type)		\
 struct reg##__name {						\
 	void (*read)(struct rt2x00_dev *rt2x00dev,		\
@@ -35,6 +45,9 @@ struct reg##__name {						\
 	void (*write)(struct rt2x00_dev *rt2x00dev,		\
 		      const unsigned int word, __type data);	\
 								\
+	unsigned int flags;					\
+								\
+	unsigned int word_base;					\
 	unsigned int word_size;					\
 	unsigned int word_count;				\
 } __name
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
index 80bf97c..a83f45f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
@@ -58,7 +58,7 @@
  * Register access.
  */
 static inline void rt2x00pci_register_read(struct rt2x00_dev *rt2x00dev,
-					   const unsigned long offset,
+					   const unsigned int offset,
 					   u32 *value)
 {
 	*value = readl(rt2x00dev->csr.base + offset);
@@ -66,14 +66,14 @@ static inline void rt2x00pci_register_read(struct rt2x00_dev *rt2x00dev,
 
 static inline void
 rt2x00pci_register_multiread(struct rt2x00_dev *rt2x00dev,
-			     const unsigned long offset,
+			     const unsigned int offset,
 			     void *value, const u16 length)
 {
 	memcpy_fromio(value, rt2x00dev->csr.base + offset, length);
 }
 
 static inline void rt2x00pci_register_write(struct rt2x00_dev *rt2x00dev,
-					    const unsigned long offset,
+					    const unsigned int offset,
 					    u32 value)
 {
 	writel(value, rt2x00dev->csr.base + offset);
@@ -81,7 +81,7 @@ static inline void rt2x00pci_register_write(struct rt2x00_dev *rt2x00dev,
 
 static inline void
 rt2x00pci_register_multiwrite(struct rt2x00_dev *rt2x00dev,
-			      const unsigned long offset,
+			      const unsigned int offset,
 			      const void *value, const u16 length)
 {
 	memcpy_toio(rt2x00dev->csr.base + offset, value, length);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index dc1c869..a8c3057 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -228,43 +228,34 @@ static void rt61pci_eepromregister_write(struct eeprom_93cx6 *eeprom)
 }
 
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-#define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
-
-static void rt61pci_read_csr(struct rt2x00_dev *rt2x00dev,
-			     const unsigned int word, u32 *data)
-{
-	rt2x00pci_register_read(rt2x00dev, CSR_OFFSET(word), data);
-}
-
-static void rt61pci_write_csr(struct rt2x00_dev *rt2x00dev,
-			      const unsigned int word, u32 data)
-{
-	rt2x00pci_register_write(rt2x00dev, CSR_OFFSET(word), data);
-}
-
 static const struct rt2x00debug rt61pci_rt2x00debug = {
 	.owner	= THIS_MODULE,
 	.csr	= {
-		.read		= rt61pci_read_csr,
-		.write		= rt61pci_write_csr,
+		.read		= rt2x00pci_register_read,
+		.write		= rt2x00pci_register_write,
+		.flags		= RT2X00DEBUGFS_OFFSET,
+		.word_base	= CSR_REG_BASE,
 		.word_size	= sizeof(u32),
 		.word_count	= CSR_REG_SIZE / sizeof(u32),
 	},
 	.eeprom	= {
 		.read		= rt2x00_eeprom_read,
 		.write		= rt2x00_eeprom_write,
+		.word_base	= EEPROM_BASE,
 		.word_size	= sizeof(u16),
 		.word_count	= EEPROM_SIZE / sizeof(u16),
 	},
 	.bbp	= {
 		.read		= rt61pci_bbp_read,
 		.write		= rt61pci_bbp_write,
+		.word_base	= BBP_BASE,
 		.word_size	= sizeof(u8),
 		.word_count	= BBP_SIZE / sizeof(u8),
 	},
 	.rf	= {
 		.read		= rt2x00_rf_read,
 		.write		= rt61pci_rf_write,
+		.word_base	= RF_BASE,
 		.word_size	= sizeof(u32),
 		.word_count	= RF_SIZE / sizeof(u32),
 	},
diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
index 8ec1451..65fe333 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -48,7 +48,9 @@
 #define CSR_REG_SIZE			0x04b0
 #define EEPROM_BASE			0x0000
 #define EEPROM_SIZE			0x0100
+#define BBP_BASE			0x0000
 #define BBP_SIZE			0x0080
+#define RF_BASE				0x0000
 #define RF_SIZE				0x0014
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index b2d7066..a5a9341 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -249,43 +249,34 @@ rf_write:
 }
 
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-#define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
-
-static void rt73usb_read_csr(struct rt2x00_dev *rt2x00dev,
-			     const unsigned int word, u32 *data)
-{
-	rt73usb_register_read(rt2x00dev, CSR_OFFSET(word), data);
-}
-
-static void rt73usb_write_csr(struct rt2x00_dev *rt2x00dev,
-			      const unsigned int word, u32 data)
-{
-	rt73usb_register_write(rt2x00dev, CSR_OFFSET(word), data);
-}
-
 static const struct rt2x00debug rt73usb_rt2x00debug = {
 	.owner	= THIS_MODULE,
 	.csr	= {
-		.read		= rt73usb_read_csr,
-		.write		= rt73usb_write_csr,
+		.read		= rt73usb_register_read,
+		.write		= rt73usb_register_write,
+		.flags		= RT2X00DEBUGFS_OFFSET,
+		.word_base	= CSR_REG_BASE,
 		.word_size	= sizeof(u32),
 		.word_count	= CSR_REG_SIZE / sizeof(u32),
 	},
 	.eeprom	= {
 		.read		= rt2x00_eeprom_read,
 		.write		= rt2x00_eeprom_write,
+		.word_base	= EEPROM_BASE,
 		.word_size	= sizeof(u16),
 		.word_count	= EEPROM_SIZE / sizeof(u16),
 	},
 	.bbp	= {
 		.read		= rt73usb_bbp_read,
 		.write		= rt73usb_bbp_write,
+		.word_base	= BBP_BASE,
 		.word_size	= sizeof(u8),
 		.word_count	= BBP_SIZE / sizeof(u8),
 	},
 	.rf	= {
 		.read		= rt2x00_rf_read,
 		.write		= rt73usb_rf_write,
+		.word_base	= RF_BASE,
 		.word_size	= sizeof(u32),
 		.word_count	= RF_SIZE / sizeof(u32),
 	},
diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/rt2x00/rt73usb.h
index 868386c..46e1405 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -48,7 +48,9 @@
 #define CSR_REG_SIZE			0x04b0
 #define EEPROM_BASE			0x0000
 #define EEPROM_SIZE			0x0100
+#define BBP_BASE			0x0000
 #define BBP_SIZE			0x0080
+#define RF_BASE				0x0000
 #define RF_SIZE				0x0014
 
 /*
-- 
1.5.6.1

