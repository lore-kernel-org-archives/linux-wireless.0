Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:14625 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbXJ0LZU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 07:25:20 -0400
Received: by fk-out-0910.google.com with SMTP id z23so1035411fkz
        for <linux-wireless@vger.kernel.org>; Sat, 27 Oct 2007 04:25:19 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 14/21] rt2x00: Unconstify rt2x00dev
Date: Sat, 27 Oct 2007 13:41:25 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200710271334.34192.IvDoorn@gmail.com>
In-Reply-To: <200710271334.34192.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710271341.25836.IvDoorn@gmail.com> (sfid-20071027_124128_127708_33E6E00A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Adam Baker <linux@baker-net.org.uk>

Some register accesses need rt2x00dev to be non-const
they all need modifying so the prototype is consistent.

Signed-off-by: Adam Baker <linux@baker-net.org.uk>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |   12 ++++++------
 drivers/net/wireless/rt2x00/rt2500pci.c   |   12 ++++++------
 drivers/net/wireless/rt2x00/rt2500usb.c   |   22 ++++++++++------------
 drivers/net/wireless/rt2x00/rt2x00.h      |   10 +++++-----
 drivers/net/wireless/rt2x00/rt2x00debug.h |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00pci.h   |    8 ++++----
 drivers/net/wireless/rt2x00/rt2x00usb.c   |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00usb.h   |   11 +++++------
 drivers/net/wireless/rt2x00/rt61pci.c     |   14 +++++++-------
 drivers/net/wireless/rt2x00/rt73usb.c     |   22 ++++++++++------------
 10 files changed, 57 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index fc16212..f2d0feb 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -54,7 +54,7 @@
  * the access attempt is considered to have failed,
  * and we will print an error.
  */
-static u32 rt2400pci_bbp_check(const struct rt2x00_dev *rt2x00dev)
+static u32 rt2400pci_bbp_check(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
 	unsigned int i;
@@ -69,7 +69,7 @@ static u32 rt2400pci_bbp_check(const struct rt2x00_dev *rt2x00dev)
 	return reg;
 }
 
-static void rt2400pci_bbp_write(const struct rt2x00_dev *rt2x00dev,
+static void rt2400pci_bbp_write(struct rt2x00_dev *rt2x00dev,
 				const unsigned int word, const u8 value)
 {
 	u32 reg;
@@ -95,7 +95,7 @@ static void rt2400pci_bbp_write(const struct rt2x00_dev *rt2x00dev,
 	rt2x00pci_register_write(rt2x00dev, BBPCSR, reg);
 }
 
-static void rt2400pci_bbp_read(const struct rt2x00_dev *rt2x00dev,
+static void rt2400pci_bbp_read(struct rt2x00_dev *rt2x00dev,
 			       const unsigned int word, u8 *value)
 {
 	u32 reg;
@@ -132,7 +132,7 @@ static void rt2400pci_bbp_read(const struct rt2x00_dev *rt2x00dev,
 	*value = rt2x00_get_field32(reg, BBPCSR_VALUE);
 }
 
-static void rt2400pci_rf_write(const struct rt2x00_dev *rt2x00dev,
+static void rt2400pci_rf_write(struct rt2x00_dev *rt2x00dev,
 			       const unsigned int word, const u32 value)
 {
 	u32 reg;
@@ -195,13 +195,13 @@ static void rt2400pci_eepromregister_write(struct eeprom_93cx6 *eeprom)
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 #define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
 
-static void rt2400pci_read_csr(const struct rt2x00_dev *rt2x00dev,
+static void rt2400pci_read_csr(struct rt2x00_dev *rt2x00dev,
 			       const unsigned int word, u32 *data)
 {
 	rt2x00pci_register_read(rt2x00dev, CSR_OFFSET(word), data);
 }
 
-static void rt2400pci_write_csr(const struct rt2x00_dev *rt2x00dev,
+static void rt2400pci_write_csr(struct rt2x00_dev *rt2x00dev,
 				const unsigned int word, u32 data)
 {
 	rt2x00pci_register_write(rt2x00dev, CSR_OFFSET(word), data);
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index c59ca0a..fbda28e 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -54,7 +54,7 @@
  * the access attempt is considered to have failed,
  * and we will print an error.
  */
-static u32 rt2500pci_bbp_check(const struct rt2x00_dev *rt2x00dev)
+static u32 rt2500pci_bbp_check(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
 	unsigned int i;
@@ -69,7 +69,7 @@ static u32 rt2500pci_bbp_check(const struct rt2x00_dev *rt2x00dev)
 	return reg;
 }
 
-static void rt2500pci_bbp_write(const struct rt2x00_dev *rt2x00dev,
+static void rt2500pci_bbp_write(struct rt2x00_dev *rt2x00dev,
 				const unsigned int word, const u8 value)
 {
 	u32 reg;
@@ -95,7 +95,7 @@ static void rt2500pci_bbp_write(const struct rt2x00_dev *rt2x00dev,
 	rt2x00pci_register_write(rt2x00dev, BBPCSR, reg);
 }
 
-static void rt2500pci_bbp_read(const struct rt2x00_dev *rt2x00dev,
+static void rt2500pci_bbp_read(struct rt2x00_dev *rt2x00dev,
 			       const unsigned int word, u8 *value)
 {
 	u32 reg;
@@ -132,7 +132,7 @@ static void rt2500pci_bbp_read(const struct rt2x00_dev *rt2x00dev,
 	*value = rt2x00_get_field32(reg, BBPCSR_VALUE);
 }
 
-static void rt2500pci_rf_write(const struct rt2x00_dev *rt2x00dev,
+static void rt2500pci_rf_write(struct rt2x00_dev *rt2x00dev,
 			       const unsigned int word, const u32 value)
 {
 	u32 reg;
@@ -195,13 +195,13 @@ static void rt2500pci_eepromregister_write(struct eeprom_93cx6 *eeprom)
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 #define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
 
-static void rt2500pci_read_csr(const struct rt2x00_dev *rt2x00dev,
+static void rt2500pci_read_csr(struct rt2x00_dev *rt2x00dev,
 			       const unsigned int word, u32 *data)
 {
 	rt2x00pci_register_read(rt2x00dev, CSR_OFFSET(word), data);
 }
 
-static void rt2500pci_write_csr(const struct rt2x00_dev *rt2x00dev,
+static void rt2500pci_write_csr(struct rt2x00_dev *rt2x00dev,
 				const unsigned int word, u32 data)
 {
 	rt2x00pci_register_write(rt2x00dev, CSR_OFFSET(word), data);
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 6c2e275..de89e60 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -53,7 +53,7 @@
  * the access attempt is considered to have failed,
  * and we will print an error.
  */
-static inline void rt2500usb_register_read(const struct rt2x00_dev *rt2x00dev,
+static inline void rt2500usb_register_read(struct rt2x00_dev *rt2x00dev,
 					   const unsigned int offset,
 					   u16 *value)
 {
@@ -64,8 +64,7 @@ static inline void rt2500usb_register_read(const struct rt2x00_dev *rt2x00dev,
 	*value = le16_to_cpu(reg);
 }
 
-static inline void rt2500usb_register_multiread(const struct rt2x00_dev
-						*rt2x00dev,
+static inline void rt2500usb_register_multiread(struct rt2x00_dev *rt2x00dev,
 						const unsigned int offset,
 						void *value, const u16 length)
 {
@@ -75,7 +74,7 @@ static inline void rt2500usb_register_multiread(const struct rt2x00_dev
 				      value, length, timeout);
 }
 
-static inline void rt2500usb_register_write(const struct rt2x00_dev *rt2x00dev,
+static inline void rt2500usb_register_write(struct rt2x00_dev *rt2x00dev,
 					    const unsigned int offset,
 					    u16 value)
 {
@@ -85,8 +84,7 @@ static inline void rt2500usb_register_write(const struct rt2x00_dev *rt2x00dev,
 				      &reg, sizeof(u16), REGISTER_TIMEOUT);
 }
 
-static inline void rt2500usb_register_multiwrite(const struct rt2x00_dev
-						 *rt2x00dev,
+static inline void rt2500usb_register_multiwrite(struct rt2x00_dev *rt2x00dev,
 						 const unsigned int offset,
 						 void *value, const u16 length)
 {
@@ -96,7 +94,7 @@ static inline void rt2500usb_register_multiwrite(const struct rt2x00_dev
 				      value, length, timeout);
 }
 
-static u16 rt2500usb_bbp_check(const struct rt2x00_dev *rt2x00dev)
+static u16 rt2500usb_bbp_check(struct rt2x00_dev *rt2x00dev)
 {
 	u16 reg;
 	unsigned int i;
@@ -111,7 +109,7 @@ static u16 rt2500usb_bbp_check(const struct rt2x00_dev *rt2x00dev)
 	return reg;
 }
 
-static void rt2500usb_bbp_write(const struct rt2x00_dev *rt2x00dev,
+static void rt2500usb_bbp_write(struct rt2x00_dev *rt2x00dev,
 				const unsigned int word, const u8 value)
 {
 	u16 reg;
@@ -136,7 +134,7 @@ static void rt2500usb_bbp_write(const struct rt2x00_dev *rt2x00dev,
 	rt2500usb_register_write(rt2x00dev, PHY_CSR7, reg);
 }
 
-static void rt2500usb_bbp_read(const struct rt2x00_dev *rt2x00dev,
+static void rt2500usb_bbp_read(struct rt2x00_dev *rt2x00dev,
 			       const unsigned int word, u8 *value)
 {
 	u16 reg;
@@ -173,7 +171,7 @@ static void rt2500usb_bbp_read(const struct rt2x00_dev *rt2x00dev,
 	*value = rt2x00_get_field16(reg, PHY_CSR7_DATA);
 }
 
-static void rt2500usb_rf_write(const struct rt2x00_dev *rt2x00dev,
+static void rt2500usb_rf_write(struct rt2x00_dev *rt2x00dev,
 			       const unsigned int word, const u32 value)
 {
 	u16 reg;
@@ -210,13 +208,13 @@ rf_write:
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 #define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u16)) )
 
-static void rt2500usb_read_csr(const struct rt2x00_dev *rt2x00dev,
+static void rt2500usb_read_csr(struct rt2x00_dev *rt2x00dev,
 			       const unsigned int word, u32 *data)
 {
 	rt2500usb_register_read(rt2x00dev, CSR_OFFSET(word), (u16 *) data);
 }
 
-static void rt2500usb_write_csr(const struct rt2x00_dev *rt2x00dev,
+static void rt2500usb_write_csr(struct rt2x00_dev *rt2x00dev,
 				const unsigned int word, u32 data)
 {
 	rt2500usb_register_write(rt2x00dev, CSR_OFFSET(word), data);
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index e488d9b..82e061c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -777,13 +777,13 @@ struct rt2x00_dev {
  * Generic RF access.
  * The RF is being accessed by word index.
  */
-static inline void rt2x00_rf_read(const struct rt2x00_dev *rt2x00dev,
+static inline void rt2x00_rf_read(struct rt2x00_dev *rt2x00dev,
 				  const unsigned int word, u32 *data)
 {
 	*data = rt2x00dev->rf[word];
 }
 
-static inline void rt2x00_rf_write(const struct rt2x00_dev *rt2x00dev,
+static inline void rt2x00_rf_write(struct rt2x00_dev *rt2x00dev,
 				   const unsigned int word, u32 data)
 {
 	rt2x00dev->rf[word] = data;
@@ -793,19 +793,19 @@ static inline void rt2x00_rf_write(const struct rt2x00_dev *rt2x00dev,
  *  Generic EEPROM access.
  * The EEPROM is being accessed by word index.
  */
-static inline void *rt2x00_eeprom_addr(const struct rt2x00_dev *rt2x00dev,
+static inline void *rt2x00_eeprom_addr(struct rt2x00_dev *rt2x00dev,
 				       const unsigned int word)
 {
 	return (void *)&rt2x00dev->eeprom[word];
 }
 
-static inline void rt2x00_eeprom_read(const struct rt2x00_dev *rt2x00dev,
+static inline void rt2x00_eeprom_read(struct rt2x00_dev *rt2x00dev,
 				      const unsigned int word, u16 *data)
 {
 	*data = le16_to_cpu(rt2x00dev->eeprom[word]);
 }
 
-static inline void rt2x00_eeprom_write(const struct rt2x00_dev *rt2x00dev,
+static inline void rt2x00_eeprom_write(struct rt2x00_dev *rt2x00dev,
 				       const unsigned int word, u16 data)
 {
 	rt2x00dev->eeprom[word] = cpu_to_le16(data);
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.h b/drivers/net/wireless/rt2x00/rt2x00debug.h
index 860e8fa..d37efbd 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.h
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.h
@@ -30,9 +30,9 @@ struct rt2x00_dev;
 
 #define RT2X00DEBUGFS_REGISTER_ENTRY(__name, __type)		\
 struct reg##__name {						\
-	void (*read)(const struct rt2x00_dev *rt2x00dev,	\
+	void (*read)(struct rt2x00_dev *rt2x00dev,		\
 		     const unsigned int word, __type *data);	\
-	void (*write)(const struct rt2x00_dev *rt2x00dev,	\
+	void (*write)(struct rt2x00_dev *rt2x00dev,		\
 		      const unsigned int word, __type data);	\
 								\
 	unsigned int word_size;					\
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
index 82adeac..0357205 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
@@ -57,7 +57,7 @@
 /*
  * Register access.
  */
-static inline void rt2x00pci_register_read(const struct rt2x00_dev *rt2x00dev,
+static inline void rt2x00pci_register_read(struct rt2x00_dev *rt2x00dev,
 					   const unsigned long offset,
 					   u32 *value)
 {
@@ -65,14 +65,14 @@ static inline void rt2x00pci_register_read(const struct rt2x00_dev *rt2x00dev,
 }
 
 static inline void
-rt2x00pci_register_multiread(const struct rt2x00_dev *rt2x00dev,
+rt2x00pci_register_multiread(struct rt2x00_dev *rt2x00dev,
 			     const unsigned long offset,
 			     void *value, const u16 length)
 {
 	memcpy_fromio(value, rt2x00dev->csr_addr + offset, length);
 }
 
-static inline void rt2x00pci_register_write(const struct rt2x00_dev *rt2x00dev,
+static inline void rt2x00pci_register_write(struct rt2x00_dev *rt2x00dev,
 					    const unsigned long offset,
 					    u32 value)
 {
@@ -80,7 +80,7 @@ static inline void rt2x00pci_register_write(const struct rt2x00_dev *rt2x00dev,
 }
 
 static inline void
-rt2x00pci_register_multiwrite(const struct rt2x00_dev *rt2x00dev,
+rt2x00pci_register_multiwrite(struct rt2x00_dev *rt2x00dev,
 			      const unsigned long offset,
 			      void *value, const u16 length)
 {
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 73cc726..47a9e5d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -38,7 +38,7 @@
 /*
  * Interfacing with the HW.
  */
-int rt2x00usb_vendor_request(const struct rt2x00_dev *rt2x00dev,
+int rt2x00usb_vendor_request(struct rt2x00_dev *rt2x00dev,
 			     const u8 request, const u8 requesttype,
 			     const u16 offset, const u16 value,
 			     void *buffer, const u16 buffer_length,
@@ -76,7 +76,7 @@ int rt2x00usb_vendor_request(const struct rt2x00_dev *rt2x00dev,
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_vendor_request);
 
-int rt2x00usb_vendor_request_buff(const struct rt2x00_dev *rt2x00dev,
+int rt2x00usb_vendor_request_buff(struct rt2x00_dev *rt2x00dev,
 				  const u8 request, const u8 requesttype,
 				  const u16 offset, void *buffer,
 				  const u16 buffer_length, const int timeout)
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index 2681abe..53282b0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -91,7 +91,7 @@
  * a buffer allocated by kmalloc. Failure to do so can lead
  * to unexpected behavior depending on the architecture.
  */
-int rt2x00usb_vendor_request(const struct rt2x00_dev *rt2x00dev,
+int rt2x00usb_vendor_request(struct rt2x00_dev *rt2x00dev,
 			     const u8 request, const u8 requesttype,
 			     const u16 offset, const u16 value,
 			     void *buffer, const u16 buffer_length,
@@ -107,7 +107,7 @@ int rt2x00usb_vendor_request(const struct rt2x00_dev *rt2x00dev,
  * kmalloc. Hence the reason for using a previously allocated cache
  * which has been allocated properly.
  */
-int rt2x00usb_vendor_request_buff(const struct rt2x00_dev *rt2x00dev,
+int rt2x00usb_vendor_request_buff(struct rt2x00_dev *rt2x00dev,
 				  const u8 request, const u8 requesttype,
 				  const u16 offset, void *buffer,
 				  const u16 buffer_length, const int timeout);
@@ -117,8 +117,7 @@ int rt2x00usb_vendor_request_buff(const struct rt2x00_dev *rt2x00dev,
  * command to the device. Since we don't use the buffer argument we
  * don't have to worry about kmalloc here.
  */
-static inline int rt2x00usb_vendor_request_sw(const struct rt2x00_dev
-					      *rt2x00dev,
+static inline int rt2x00usb_vendor_request_sw(struct rt2x00_dev *rt2x00dev,
 					      const u8 request,
 					      const u16 offset,
 					      const u16 value,
@@ -134,8 +133,8 @@ static inline int rt2x00usb_vendor_request_sw(const struct rt2x00_dev
  * from the device. Note that the eeprom argument _must_ be allocated using
  * kmalloc for correct handling inside the kernel USB layer.
  */
-static inline int rt2x00usb_eeprom_read(const struct rt2x00_dev *rt2x00dev,
-					 __le16 *eeprom, const u16 lenght)
+static inline int rt2x00usb_eeprom_read(struct rt2x00_dev *rt2x00dev,
+					__le16 *eeprom, const u16 lenght)
 {
 	int timeout = REGISTER_TIMEOUT * (lenght / sizeof(u16));
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 7f0665e..d540525 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -52,7 +52,7 @@
  * the access attempt is considered to have failed,
  * and we will print an error.
  */
-static u32 rt61pci_bbp_check(const struct rt2x00_dev *rt2x00dev)
+static u32 rt61pci_bbp_check(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
 	unsigned int i;
@@ -67,7 +67,7 @@ static u32 rt61pci_bbp_check(const struct rt2x00_dev *rt2x00dev)
 	return reg;
 }
 
-static void rt61pci_bbp_write(const struct rt2x00_dev *rt2x00dev,
+static void rt61pci_bbp_write(struct rt2x00_dev *rt2x00dev,
 			      const unsigned int word, const u8 value)
 {
 	u32 reg;
@@ -93,7 +93,7 @@ static void rt61pci_bbp_write(const struct rt2x00_dev *rt2x00dev,
 	rt2x00pci_register_write(rt2x00dev, PHY_CSR3, reg);
 }
 
-static void rt61pci_bbp_read(const struct rt2x00_dev *rt2x00dev,
+static void rt61pci_bbp_read(struct rt2x00_dev *rt2x00dev,
 			     const unsigned int word, u8 *value)
 {
 	u32 reg;
@@ -130,7 +130,7 @@ static void rt61pci_bbp_read(const struct rt2x00_dev *rt2x00dev,
 	*value = rt2x00_get_field32(reg, PHY_CSR3_VALUE);
 }
 
-static void rt61pci_rf_write(const struct rt2x00_dev *rt2x00dev,
+static void rt61pci_rf_write(struct rt2x00_dev *rt2x00dev,
 			     const unsigned int word, const u32 value)
 {
 	u32 reg;
@@ -160,7 +160,7 @@ rf_write:
 	rt2x00_rf_write(rt2x00dev, word, value);
 }
 
-static void rt61pci_mcu_request(const struct rt2x00_dev *rt2x00dev,
+static void rt61pci_mcu_request(struct rt2x00_dev *rt2x00dev,
 				const u8 command, const u8 token,
 				const u8 arg0, const u8 arg1)
 {
@@ -220,13 +220,13 @@ static void rt61pci_eepromregister_write(struct eeprom_93cx6 *eeprom)
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 #define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
 
-static void rt61pci_read_csr(const struct rt2x00_dev *rt2x00dev,
+static void rt61pci_read_csr(struct rt2x00_dev *rt2x00dev,
 			     const unsigned int word, u32 *data)
 {
 	rt2x00pci_register_read(rt2x00dev, CSR_OFFSET(word), data);
 }
 
-static void rt61pci_write_csr(const struct rt2x00_dev *rt2x00dev,
+static void rt61pci_write_csr(struct rt2x00_dev *rt2x00dev,
 			      const unsigned int word, u32 data)
 {
 	rt2x00pci_register_write(rt2x00dev, CSR_OFFSET(word), data);
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index d1119e3..57fa18d 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -53,7 +53,7 @@
  * the access attempt is considered to have failed,
  * and we will print an error.
  */
-static inline void rt73usb_register_read(const struct rt2x00_dev *rt2x00dev,
+static inline void rt73usb_register_read(struct rt2x00_dev *rt2x00dev,
 					 const unsigned int offset, u32 *value)
 {
 	__le32 reg;
@@ -63,8 +63,7 @@ static inline void rt73usb_register_read(const struct rt2x00_dev *rt2x00dev,
 	*value = le32_to_cpu(reg);
 }
 
-static inline void rt73usb_register_multiread(const struct rt2x00_dev
-					      *rt2x00dev,
+static inline void rt73usb_register_multiread(struct rt2x00_dev *rt2x00dev,
 					      const unsigned int offset,
 					      void *value, const u32 length)
 {
@@ -74,7 +73,7 @@ static inline void rt73usb_register_multiread(const struct rt2x00_dev
 				      value, length, timeout);
 }
 
-static inline void rt73usb_register_write(const struct rt2x00_dev *rt2x00dev,
+static inline void rt73usb_register_write(struct rt2x00_dev *rt2x00dev,
 					  const unsigned int offset, u32 value)
 {
 	__le32 reg = cpu_to_le32(value);
@@ -83,8 +82,7 @@ static inline void rt73usb_register_write(const struct rt2x00_dev *rt2x00dev,
 				      &reg, sizeof(u32), REGISTER_TIMEOUT);
 }
 
-static inline void rt73usb_register_multiwrite(const struct rt2x00_dev
-					       *rt2x00dev,
+static inline void rt73usb_register_multiwrite(struct rt2x00_dev *rt2x00dev,
 					       const unsigned int offset,
 					       void *value, const u32 length)
 {
@@ -94,7 +92,7 @@ static inline void rt73usb_register_multiwrite(const struct rt2x00_dev
 				      value, length, timeout);
 }
 
-static u32 rt73usb_bbp_check(const struct rt2x00_dev *rt2x00dev)
+static u32 rt73usb_bbp_check(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
 	unsigned int i;
@@ -109,7 +107,7 @@ static u32 rt73usb_bbp_check(const struct rt2x00_dev *rt2x00dev)
 	return reg;
 }
 
-static void rt73usb_bbp_write(const struct rt2x00_dev *rt2x00dev,
+static void rt73usb_bbp_write(struct rt2x00_dev *rt2x00dev,
 			      const unsigned int word, const u8 value)
 {
 	u32 reg;
@@ -135,7 +133,7 @@ static void rt73usb_bbp_write(const struct rt2x00_dev *rt2x00dev,
 	rt73usb_register_write(rt2x00dev, PHY_CSR3, reg);
 }
 
-static void rt73usb_bbp_read(const struct rt2x00_dev *rt2x00dev,
+static void rt73usb_bbp_read(struct rt2x00_dev *rt2x00dev,
 			     const unsigned int word, u8 *value)
 {
 	u32 reg;
@@ -172,7 +170,7 @@ static void rt73usb_bbp_read(const struct rt2x00_dev *rt2x00dev,
 	*value = rt2x00_get_field32(reg, PHY_CSR3_VALUE);
 }
 
-static void rt73usb_rf_write(const struct rt2x00_dev *rt2x00dev,
+static void rt73usb_rf_write(struct rt2x00_dev *rt2x00dev,
 			     const unsigned int word, const u32 value)
 {
 	u32 reg;
@@ -212,13 +210,13 @@ rf_write:
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 #define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
 
-static void rt73usb_read_csr(const struct rt2x00_dev *rt2x00dev,
+static void rt73usb_read_csr(struct rt2x00_dev *rt2x00dev,
 			     const unsigned int word, u32 *data)
 {
 	rt73usb_register_read(rt2x00dev, CSR_OFFSET(word), data);
 }
 
-static void rt73usb_write_csr(const struct rt2x00_dev *rt2x00dev,
+static void rt73usb_write_csr(struct rt2x00_dev *rt2x00dev,
 			      const unsigned int word, u32 data)
 {
 	rt73usb_register_write(rt2x00dev, CSR_OFFSET(word), data);
-- 
1.5.3.4

