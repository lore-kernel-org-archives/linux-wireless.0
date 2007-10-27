Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:4082 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbXJ0LZe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 07:25:34 -0400
Received: by nf-out-0910.google.com with SMTP id g13so973044nfb
        for <linux-wireless@vger.kernel.org>; Sat, 27 Oct 2007 04:25:32 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 19/21] rt2x00: Place mutex around USB register access
Date: Sat, 27 Oct 2007 13:43:29 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200710271334.34192.IvDoorn@gmail.com>
In-Reply-To: <200710271334.34192.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710271343.29316.IvDoorn@gmail.com> (sfid-20071027_122536_931514_639B79E3)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Adam Baker <linux@baker-net.org.uk>

There is a buffer, csr_cache which is used to hold copies of data being passed
to the USB stack which can get corrupted if multiple threads attempt to access
CSR registers simultaneously. There is also the possibility if multiple
threads try to access BBP or RF registers for the multiple USB operations
needed to get interleaved leading to incorrect results. This patch introduces
a mutex to prevent such simultaneous access. The interleaved access problem
may also affect the PCI devices but if so that will be handled in a follow-up
patch.

Signed-off-by: Adam Baker <linux@baker-net.org.uk>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |   52 ++++++++++++++++++++++++++----
 drivers/net/wireless/rt2x00/rt2x00.h    |   13 ++++++++
 drivers/net/wireless/rt2x00/rt2x00usb.c |   32 ++++++++++++++++--
 drivers/net/wireless/rt2x00/rt2x00usb.h |    8 +++++
 drivers/net/wireless/rt2x00/rt73usb.c   |   42 ++++++++++++++++++++++---
 5 files changed, 131 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 041a847..fdc6da5 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -52,6 +52,8 @@
  * between each attampt. When the busy bit is still set at that time,
  * the access attempt is considered to have failed,
  * and we will print an error.
+ * If the usb_cache_mutex is already held then the _lock variants must
+ * be used instead.
  */
 static inline void rt2500usb_register_read(struct rt2x00_dev *rt2x00dev,
 					   const unsigned int offset,
@@ -64,6 +66,17 @@ static inline void rt2500usb_register_read(struct rt2x00_dev *rt2x00dev,
 	*value = le16_to_cpu(reg);
 }
 
+static inline void rt2500usb_register_read_lock(struct rt2x00_dev *rt2x00dev,
+						const unsigned int offset,
+						u16 *value)
+{
+	__le16 reg;
+	rt2x00usb_vendor_req_buff_lock(rt2x00dev, USB_MULTI_READ,
+				       USB_VENDOR_REQUEST_IN, offset,
+				       &reg, sizeof(u16), REGISTER_TIMEOUT);
+	*value = le16_to_cpu(reg);
+}
+
 static inline void rt2500usb_register_multiread(struct rt2x00_dev *rt2x00dev,
 						const unsigned int offset,
 						void *value, const u16 length)
@@ -84,6 +97,16 @@ static inline void rt2500usb_register_write(struct rt2x00_dev *rt2x00dev,
 				      &reg, sizeof(u16), REGISTER_TIMEOUT);
 }
 
+static inline void rt2500usb_register_write_lock(struct rt2x00_dev *rt2x00dev,
+						 const unsigned int offset,
+						 u16 value)
+{
+	__le16 reg = cpu_to_le16(value);
+	rt2x00usb_vendor_req_buff_lock(rt2x00dev, USB_MULTI_WRITE,
+				       USB_VENDOR_REQUEST_OUT, offset,
+				       &reg, sizeof(u16), REGISTER_TIMEOUT);
+}
+
 static inline void rt2500usb_register_multiwrite(struct rt2x00_dev *rt2x00dev,
 						 const unsigned int offset,
 						 void *value, const u16 length)
@@ -100,7 +123,7 @@ static u16 rt2500usb_bbp_check(struct rt2x00_dev *rt2x00dev)
 	unsigned int i;
 
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2500usb_register_read(rt2x00dev, PHY_CSR8, &reg);
+		rt2500usb_register_read_lock(rt2x00dev, PHY_CSR8, &reg);
 		if (!rt2x00_get_field16(reg, PHY_CSR8_BUSY))
 			break;
 		udelay(REGISTER_BUSY_DELAY);
@@ -114,12 +137,15 @@ static void rt2500usb_bbp_write(struct rt2x00_dev *rt2x00dev,
 {
 	u16 reg;
 
+	mutex_lock(&rt2x00dev->usb_cache_mutex);
+
 	/*
 	 * Wait until the BBP becomes ready.
 	 */
 	reg = rt2500usb_bbp_check(rt2x00dev);
 	if (rt2x00_get_field16(reg, PHY_CSR8_BUSY)) {
 		ERROR(rt2x00dev, "PHY_CSR8 register busy. Write failed.\n");
+		mutex_unlock(&rt2x00dev->usb_cache_mutex);
 		return;
 	}
 
@@ -131,7 +157,9 @@ static void rt2500usb_bbp_write(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field16(&reg, PHY_CSR7_REG_ID, word);
 	rt2x00_set_field16(&reg, PHY_CSR7_READ_CONTROL, 0);
 
-	rt2500usb_register_write(rt2x00dev, PHY_CSR7, reg);
+	rt2500usb_register_write_lock(rt2x00dev, PHY_CSR7, reg);
+
+	mutex_unlock(&rt2x00dev->usb_cache_mutex);
 }
 
 static void rt2500usb_bbp_read(struct rt2x00_dev *rt2x00dev,
@@ -139,6 +167,8 @@ static void rt2500usb_bbp_read(struct rt2x00_dev *rt2x00dev,
 {
 	u16 reg;
 
+	mutex_lock(&rt2x00dev->usb_cache_mutex);
+
 	/*
 	 * Wait until the BBP becomes ready.
 	 */
@@ -155,7 +185,7 @@ static void rt2500usb_bbp_read(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field16(&reg, PHY_CSR7_REG_ID, word);
 	rt2x00_set_field16(&reg, PHY_CSR7_READ_CONTROL, 1);
 
-	rt2500usb_register_write(rt2x00dev, PHY_CSR7, reg);
+	rt2500usb_register_write_lock(rt2x00dev, PHY_CSR7, reg);
 
 	/*
 	 * Wait until the BBP becomes ready.
@@ -164,11 +194,14 @@ static void rt2500usb_bbp_read(struct rt2x00_dev *rt2x00dev,
 	if (rt2x00_get_field16(reg, PHY_CSR8_BUSY)) {
 		ERROR(rt2x00dev, "PHY_CSR8 register busy. Read failed.\n");
 		*value = 0xff;
+		mutex_unlock(&rt2x00dev->usb_cache_mutex);
 		return;
 	}
 
-	rt2500usb_register_read(rt2x00dev, PHY_CSR7, &reg);
+	rt2500usb_register_read_lock(rt2x00dev, PHY_CSR7, &reg);
 	*value = rt2x00_get_field16(reg, PHY_CSR7_DATA);
+
+	mutex_unlock(&rt2x00dev->usb_cache_mutex);
 }
 
 static void rt2500usb_rf_write(struct rt2x00_dev *rt2x00dev,
@@ -180,20 +213,23 @@ static void rt2500usb_rf_write(struct rt2x00_dev *rt2x00dev,
 	if (!word)
 		return;
 
+	mutex_lock(&rt2x00dev->usb_cache_mutex);
+
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2500usb_register_read(rt2x00dev, PHY_CSR10, &reg);
+		rt2500usb_register_read_lock(rt2x00dev, PHY_CSR10, &reg);
 		if (!rt2x00_get_field16(reg, PHY_CSR10_RF_BUSY))
 			goto rf_write;
 		udelay(REGISTER_BUSY_DELAY);
 	}
 
+	mutex_unlock(&rt2x00dev->usb_cache_mutex);
 	ERROR(rt2x00dev, "PHY_CSR10 register busy. Write failed.\n");
 	return;
 
 rf_write:
 	reg = 0;
 	rt2x00_set_field16(&reg, PHY_CSR9_RF_VALUE, value);
-	rt2500usb_register_write(rt2x00dev, PHY_CSR9, reg);
+	rt2500usb_register_write_lock(rt2x00dev, PHY_CSR9, reg);
 
 	reg = 0;
 	rt2x00_set_field16(&reg, PHY_CSR10_RF_VALUE, value >> 16);
@@ -201,8 +237,10 @@ rf_write:
 	rt2x00_set_field16(&reg, PHY_CSR10_RF_IF_SELECT, 0);
 	rt2x00_set_field16(&reg, PHY_CSR10_RF_BUSY, 1);
 
-	rt2500usb_register_write(rt2x00dev, PHY_CSR10, reg);
+	rt2500usb_register_write_lock(rt2x00dev, PHY_CSR10, reg);
 	rt2x00_rf_write(rt2x00dev, word, value);
+
+	mutex_unlock(&rt2x00dev->usb_cache_mutex);
 }
 
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index e41eb06..c555abb 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -31,6 +31,7 @@
 #include <linux/skbuff.h>
 #include <linux/workqueue.h>
 #include <linux/firmware.h>
+#include <linux/mutex.h>
 
 #include <net/mac80211.h>
 
@@ -659,6 +660,18 @@ struct rt2x00_dev {
 	void *csr_cache;
 
 	/*
+	 * Mutex to protect register accesses on USB devices.
+	 * There are 2 reasons this is needed, one is to ensure
+	 * use of the csr_cache (for USB devices) by one thread
+	 * isn't corrupted by another thread trying to access it.
+	 * The other is that access to BBP and RF registers
+	 * require multiple BUS transactions and if another thread
+	 * attempted to access one of those registers at the same
+	 * time one of the writes could silently fail.
+	 */
+	struct mutex usb_cache_mutex;
+
+	/*
 	 * Interface configuration.
 	 */
 	struct interface interface;
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index dfafb0e..f61dee5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -31,6 +31,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/usb.h>
+#include <linux/bug.h>
 
 #include "rt2x00.h"
 #include "rt2x00usb.h"
@@ -52,6 +53,7 @@ int rt2x00usb_vendor_request(struct rt2x00_dev *rt2x00dev,
 	    (requesttype == USB_VENDOR_REQUEST_IN) ?
 	    usb_rcvctrlpipe(usb_dev, 0) : usb_sndctrlpipe(usb_dev, 0);
 
+
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
 		status = usb_control_msg(usb_dev, pipe, request, requesttype,
 					 value, offset, buffer, buffer_length,
@@ -76,13 +78,15 @@ int rt2x00usb_vendor_request(struct rt2x00_dev *rt2x00dev,
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_vendor_request);
 
-int rt2x00usb_vendor_request_buff(struct rt2x00_dev *rt2x00dev,
-				  const u8 request, const u8 requesttype,
-				  const u16 offset, void *buffer,
-				  const u16 buffer_length, const int timeout)
+int rt2x00usb_vendor_req_buff_lock(struct rt2x00_dev *rt2x00dev,
+				   const u8 request, const u8 requesttype,
+				   const u16 offset, void *buffer,
+				   const u16 buffer_length, const int timeout)
 {
 	int status;
 
+	BUG_ON(!mutex_is_locked(&rt2x00dev->usb_cache_mutex));
+
 	/*
 	 * Check for Cache availability.
 	 */
@@ -103,6 +107,25 @@ int rt2x00usb_vendor_request_buff(struct rt2x00_dev *rt2x00dev,
 
 	return status;
 }
+EXPORT_SYMBOL_GPL(rt2x00usb_vendor_req_buff_lock);
+
+int rt2x00usb_vendor_request_buff(struct rt2x00_dev *rt2x00dev,
+				  const u8 request, const u8 requesttype,
+				  const u16 offset, void *buffer,
+				  const u16 buffer_length, const int timeout)
+{
+	int status;
+
+	mutex_lock(&rt2x00dev->usb_cache_mutex);
+
+	status = rt2x00usb_vendor_req_buff_lock(rt2x00dev, request,
+						requesttype, offset, buffer,
+						buffer_length, timeout);
+
+	mutex_unlock(&rt2x00dev->usb_cache_mutex);
+
+	return status;
+}
 EXPORT_SYMBOL_GPL(rt2x00usb_vendor_request_buff);
 
 /*
@@ -489,6 +512,7 @@ int rt2x00usb_probe(struct usb_interface *usb_intf,
 	rt2x00dev->dev = usb_intf;
 	rt2x00dev->ops = ops;
 	rt2x00dev->hw = hw;
+	mutex_init(&rt2x00dev->usb_cache_mutex);
 
 	retval = rt2x00usb_alloc_reg(rt2x00dev);
 	if (retval)
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index 53282b0..2fa45c5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -113,6 +113,14 @@ int rt2x00usb_vendor_request_buff(struct rt2x00_dev *rt2x00dev,
 				  const u16 buffer_length, const int timeout);
 
 /*
+ * A version of rt2x00usb_vendor_request_buff which must be called
+ * if the usb_cache_mutex is already held. */
+int rt2x00usb_vendor_req_buff_lock(struct rt2x00_dev *rt2x00dev,
+				   const u8 request, const u8 requesttype,
+				   const u16 offset, void *buffer,
+				   const u16 buffer_length, const int timeout);
+
+/*
  * Simple wrapper around rt2x00usb_vendor_request to write a single
  * command to the device. Since we don't use the buffer argument we
  * don't have to worry about kmalloc here.
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index d9cf997..d1375b8 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -52,6 +52,7 @@
  * between each attampt. When the busy bit is still set at that time,
  * the access attempt is considered to have failed,
  * and we will print an error.
+ * The _lock versions must be used if you already hold the usb_cache_mutex
  */
 static inline void rt73usb_register_read(struct rt2x00_dev *rt2x00dev,
 					 const unsigned int offset, u32 *value)
@@ -63,6 +64,16 @@ static inline void rt73usb_register_read(struct rt2x00_dev *rt2x00dev,
 	*value = le32_to_cpu(reg);
 }
 
+static inline void rt73usb_register_read_lock(struct rt2x00_dev *rt2x00dev,
+					      const unsigned int offset, u32 *value)
+{
+	__le32 reg;
+	rt2x00usb_vendor_req_buff_lock(rt2x00dev, USB_MULTI_READ,
+				       USB_VENDOR_REQUEST_IN, offset,
+				       &reg, sizeof(u32), REGISTER_TIMEOUT);
+	*value = le32_to_cpu(reg);
+}
+
 static inline void rt73usb_register_multiread(struct rt2x00_dev *rt2x00dev,
 					      const unsigned int offset,
 					      void *value, const u32 length)
@@ -82,6 +93,15 @@ static inline void rt73usb_register_write(struct rt2x00_dev *rt2x00dev,
 				      &reg, sizeof(u32), REGISTER_TIMEOUT);
 }
 
+static inline void rt73usb_register_write_lock(struct rt2x00_dev *rt2x00dev,
+					       const unsigned int offset, u32 value)
+{
+	__le32 reg = cpu_to_le32(value);
+	rt2x00usb_vendor_req_buff_lock(rt2x00dev, USB_MULTI_WRITE,
+				       USB_VENDOR_REQUEST_OUT, offset,
+				      &reg, sizeof(u32), REGISTER_TIMEOUT);
+}
+
 static inline void rt73usb_register_multiwrite(struct rt2x00_dev *rt2x00dev,
 					       const unsigned int offset,
 					       void *value, const u32 length)
@@ -98,7 +118,7 @@ static u32 rt73usb_bbp_check(struct rt2x00_dev *rt2x00dev)
 	unsigned int i;
 
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt73usb_register_read(rt2x00dev, PHY_CSR3, &reg);
+		rt73usb_register_read_lock(rt2x00dev, PHY_CSR3, &reg);
 		if (!rt2x00_get_field32(reg, PHY_CSR3_BUSY))
 			break;
 		udelay(REGISTER_BUSY_DELAY);
@@ -112,12 +132,15 @@ static void rt73usb_bbp_write(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
+	mutex_lock(&rt2x00dev->usb_cache_mutex);
+
 	/*
 	 * Wait until the BBP becomes ready.
 	 */
 	reg = rt73usb_bbp_check(rt2x00dev);
 	if (rt2x00_get_field32(reg, PHY_CSR3_BUSY)) {
 		ERROR(rt2x00dev, "PHY_CSR3 register busy. Write failed.\n");
+		mutex_unlock(&rt2x00dev->usb_cache_mutex);
 		return;
 	}
 
@@ -130,7 +153,8 @@ static void rt73usb_bbp_write(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, PHY_CSR3_BUSY, 1);
 	rt2x00_set_field32(&reg, PHY_CSR3_READ_CONTROL, 0);
 
-	rt73usb_register_write(rt2x00dev, PHY_CSR3, reg);
+	rt73usb_register_write_lock(rt2x00dev, PHY_CSR3, reg);
+	mutex_unlock(&rt2x00dev->usb_cache_mutex);
 }
 
 static void rt73usb_bbp_read(struct rt2x00_dev *rt2x00dev,
@@ -138,12 +162,15 @@ static void rt73usb_bbp_read(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
+	mutex_lock(&rt2x00dev->usb_cache_mutex);
+
 	/*
 	 * Wait until the BBP becomes ready.
 	 */
 	reg = rt73usb_bbp_check(rt2x00dev);
 	if (rt2x00_get_field32(reg, PHY_CSR3_BUSY)) {
 		ERROR(rt2x00dev, "PHY_CSR3 register busy. Read failed.\n");
+		mutex_unlock(&rt2x00dev->usb_cache_mutex);
 		return;
 	}
 
@@ -155,7 +182,7 @@ static void rt73usb_bbp_read(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, PHY_CSR3_BUSY, 1);
 	rt2x00_set_field32(&reg, PHY_CSR3_READ_CONTROL, 1);
 
-	rt73usb_register_write(rt2x00dev, PHY_CSR3, reg);
+	rt73usb_register_write_lock(rt2x00dev, PHY_CSR3, reg);
 
 	/*
 	 * Wait until the BBP becomes ready.
@@ -168,6 +195,7 @@ static void rt73usb_bbp_read(struct rt2x00_dev *rt2x00dev,
 	}
 
 	*value = rt2x00_get_field32(reg, PHY_CSR3_VALUE);
+	mutex_unlock(&rt2x00dev->usb_cache_mutex);
 }
 
 static void rt73usb_rf_write(struct rt2x00_dev *rt2x00dev,
@@ -179,13 +207,16 @@ static void rt73usb_rf_write(struct rt2x00_dev *rt2x00dev,
 	if (!word)
 		return;
 
+	mutex_lock(&rt2x00dev->usb_cache_mutex);
+
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt73usb_register_read(rt2x00dev, PHY_CSR4, &reg);
+		rt73usb_register_read_lock(rt2x00dev, PHY_CSR4, &reg);
 		if (!rt2x00_get_field32(reg, PHY_CSR4_BUSY))
 			goto rf_write;
 		udelay(REGISTER_BUSY_DELAY);
 	}
 
+	mutex_unlock(&rt2x00dev->usb_cache_mutex);
 	ERROR(rt2x00dev, "PHY_CSR4 register busy. Write failed.\n");
 	return;
 
@@ -203,8 +234,9 @@ rf_write:
 	rt2x00_set_field32(&reg, PHY_CSR4_IF_SELECT, 0);
 	rt2x00_set_field32(&reg, PHY_CSR4_BUSY, 1);
 
-	rt73usb_register_write(rt2x00dev, PHY_CSR4, reg);
+	rt73usb_register_write_lock(rt2x00dev, PHY_CSR4, reg);
 	rt2x00_rf_write(rt2x00dev, word, value);
+	mutex_unlock(&rt2x00dev->usb_cache_mutex);
 }
 
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-- 
1.5.3.4

