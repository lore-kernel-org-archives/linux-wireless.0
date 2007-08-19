Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:22582 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386AbXHSSaw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:30:52 -0400
Received: by ug-out-1314.google.com with SMTP id j3so446922ugf
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:30:51 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 15/30] rt2x00: Use caching for USB transfers
Date: Sun, 19 Aug 2007 20:26:53 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192026.53496.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From b75e79133fbff5d1b4cde7fc2ec362ad433c019f Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 18 Aug 2007 13:07:27 +0200
Subject: [PATCH 15/30] rt2x00: Use caching for USB transfers

The kernel USB layer demands that the buffer argument
to usb_control_msg must point to something allocated using kmalloc.
Failure to do so will lead to unexpected results depending
on the running architecture.
This will add a cache to rt2x00_dev to be used by rt2x00usb
for all data transfers to the host. This will also require some
new wrapper functions for easier handling this.
For the rt73usb firmware loader this also means it is better
to allocate the memory instead of using a 64byte array,
besides that this was a direct attack on the stack size it is
also safer.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2500usb.c |   38 +++++++--------
 drivers/net/wireless/rt2x00.h    |    5 ++-
 drivers/net/wireless/rt2x00usb.c |   92 +++++++++++++++++++++++++++++++-------
 drivers/net/wireless/rt2x00usb.h |   60 ++++++++++++++++++++++---
 drivers/net/wireless/rt73usb.c   |   92 +++++++++++++++++++++-----------------
 5 files changed, 202 insertions(+), 85 deletions(-)

diff --git a/drivers/net/wireless/rt2500usb.c b/drivers/net/wireless/rt2500usb.c
index 25d0aec..5e3cdf5 100644
--- a/drivers/net/wireless/rt2500usb.c
+++ b/drivers/net/wireless/rt2500usb.c
@@ -58,9 +58,9 @@ static inline void rt2500usb_register_read(const struct rt2x00_dev *rt2x00dev,
 					   u16 *value)
 {
 	__le16 reg;
-	rt2x00usb_vendor_request(rt2x00dev, USB_MULTI_READ,
-				 USB_VENDOR_REQUEST_IN, offset, 0x00,
-				 &reg, sizeof(u16), REGISTER_TIMEOUT);
+	rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_READ,
+				      USB_VENDOR_REQUEST_IN, offset,
+				      &reg, sizeof(u16), REGISTER_TIMEOUT);
 	*value = le16_to_cpu(reg);
 }
 
@@ -69,10 +69,10 @@ static inline void rt2500usb_register_multiread(const struct rt2x00_dev
 						const unsigned int offset,
 						void *value, const u16 length)
 {
-	rt2x00usb_vendor_request(rt2x00dev, USB_MULTI_READ,
-				 USB_VENDOR_REQUEST_IN, offset, 0x00,
-				 value, length,
-				 REGISTER_TIMEOUT * (length / sizeof(u16)));
+	int timeout = REGISTER_TIMEOUT * (length / sizeof(u16));
+	rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_READ,
+				      USB_VENDOR_REQUEST_IN, offset,
+				      value, length, timeout);
 }
 
 static inline void rt2500usb_register_write(const struct rt2x00_dev *rt2x00dev,
@@ -80,9 +80,9 @@ static inline void rt2500usb_register_write(const struct rt2x00_dev *rt2x00dev,
 					    u16 value)
 {
 	__le16 reg = cpu_to_le16(value);
-	rt2x00usb_vendor_request(rt2x00dev, USB_MULTI_WRITE,
-				 USB_VENDOR_REQUEST_OUT, offset, 0x00,
-				 &reg, sizeof(u16), REGISTER_TIMEOUT);
+	rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_WRITE,
+				      USB_VENDOR_REQUEST_OUT, offset,
+				      &reg, sizeof(u16), REGISTER_TIMEOUT);
 }
 
 static inline void rt2500usb_register_multiwrite(const struct rt2x00_dev
@@ -90,10 +90,10 @@ static inline void rt2500usb_register_multiwrite(const struct rt2x00_dev
 						 const unsigned int offset,
 						 void *value, const u16 length)
 {
-	rt2x00usb_vendor_request(rt2x00dev, USB_MULTI_WRITE,
-				 USB_VENDOR_REQUEST_OUT, offset, 0x00,
-				 value, length,
-				 REGISTER_TIMEOUT * (length / sizeof(u16)));
+	int timeout = REGISTER_TIMEOUT * (length / sizeof(u16));
+	rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_WRITE,
+				      USB_VENDOR_REQUEST_OUT, offset,
+				      value, length, timeout);
 }
 
 static u16 rt2500usb_bbp_check(const struct rt2x00_dev *rt2x00dev)
@@ -774,12 +774,10 @@ static int rt2500usb_init_registers(struct rt2x00_dev *rt2x00dev)
 {
 	u16 reg;
 
-	rt2x00usb_vendor_request(rt2x00dev, USB_DEVICE_MODE,
-				 USB_VENDOR_REQUEST_OUT, 0x0001,
-				 USB_MODE_TEST, NULL, 0, REGISTER_TIMEOUT);
-	rt2x00usb_vendor_request(rt2x00dev, USB_SINGLE_WRITE,
-				 USB_VENDOR_REQUEST_OUT, 0x0308,
-				 0xf0, NULL, 0, REGISTER_TIMEOUT);
+	rt2x00usb_vendor_request_sw(rt2x00dev, USB_DEVICE_MODE, 0x0001,
+				    USB_MODE_TEST, REGISTER_TIMEOUT);
+	rt2x00usb_vendor_request_sw(rt2x00dev, USB_SINGLE_WRITE, 0x0308,
+				    0x00f0, REGISTER_TIMEOUT);
 
 	rt2500usb_register_read(rt2x00dev, TXRX_CSR2, &reg);
 	rt2x00_set_field16(&reg, TXRX_CSR2_DISABLE_RX, 1);
diff --git a/drivers/net/wireless/rt2x00.h b/drivers/net/wireless/rt2x00.h
index de1365f..24ad264 100644
--- a/drivers/net/wireless/rt2x00.h
+++ b/drivers/net/wireless/rt2x00.h
@@ -524,9 +524,12 @@ struct rt2x00_dev {
 	struct hw_mode_spec spec;
 
 	/*
-	 * Base address of device registers (PCI devices only).
+	 * Register pointers
+	 * csr_addr: Base register address. (PCI)
+	 * csr_cache: CSR cache for usb_control_msg. (USB)
 	 */
 	void __iomem *csr_addr;
+	void *csr_cache;
 
 	/*
 	 * Interface configuration.
diff --git a/drivers/net/wireless/rt2x00usb.c b/drivers/net/wireless/rt2x00usb.c
index 6dd0801..d832d5f 100644
--- a/drivers/net/wireless/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00usb.c
@@ -39,24 +39,23 @@
  * Interfacing with the HW.
  */
 int rt2x00usb_vendor_request(const struct rt2x00_dev *rt2x00dev,
-			     const u8 request, const u8 type, const u16 offset,
-			     u32 value, void *buffer, const u16 buffer_length,
-			     const u16 timeout)
+			     const u8 request, const u8 requesttype,
+			     const u16 offset, const u16 value,
+			     void *buffer, const u16 buffer_length,
+			     u16 timeout)
 {
 	struct usb_device *usb_dev =
 	    interface_to_usbdev(rt2x00dev_usb(rt2x00dev));
 	int status;
 	unsigned int i;
-	unsigned int time = timeout;
+	unsigned int pipe =
+	    (requesttype == USB_VENDOR_REQUEST_IN) ?
+	     usb_rcvctrlpipe(usb_dev, 0) : usb_sndctrlpipe(usb_dev, 0);
 
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		status = usb_control_msg(usb_dev,
-					 ((type == USB_VENDOR_REQUEST_IN) ?
-					  usb_rcvctrlpipe(usb_dev, 0) :
-					  usb_sndctrlpipe(usb_dev, 0)),
-					 request, type, value, offset,
-					 buffer, buffer_length, time);
-
+		status = usb_control_msg(usb_dev, pipe, request, requesttype,
+					 value, offset, buffer, buffer_length,
+					 timeout);
 		if (status >= 0)
 			return 0;
 
@@ -66,7 +65,7 @@ int rt2x00usb_vendor_request(const struct rt2x00_dev *rt2x00dev,
 		 * -ENODEV: Device has disappeared, no point continuing.
 		 */
 		if (status == -ETIMEDOUT)
-			time *= 2;
+			timeout *= 2;
 		else if (status == -ENODEV)
 			break;
 	}
@@ -79,6 +78,35 @@ int rt2x00usb_vendor_request(const struct rt2x00_dev *rt2x00dev,
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_vendor_request);
 
+int rt2x00usb_vendor_request_buff(const struct rt2x00_dev *rt2x00dev,
+				  const u8 request, const u8 requesttype,
+				  const u16 offset, void *buffer,
+				  const u16 buffer_length, u16 timeout)
+{
+	int status;
+
+	/*
+	 * Check for Cache availability.
+	 */
+	if (unlikely(!rt2x00dev->csr_cache || buffer_length > CSR_CACHE_SIZE)) {
+		ERROR(rt2x00dev, "CSR cache not available.\n");
+		return -ENOMEM;
+	}
+
+	if (requesttype == USB_VENDOR_REQUEST_OUT)
+		memcpy(rt2x00dev->csr_cache, buffer, buffer_length);
+
+	status = rt2x00usb_vendor_request(rt2x00dev, request, requesttype,
+					  offset, 0, rt2x00dev->csr_cache,
+					  buffer_length, timeout);
+
+	if (!status && requesttype == USB_VENDOR_REQUEST_IN)
+		memcpy(buffer, rt2x00dev->csr_cache, buffer_length);
+
+	return status;
+}
+EXPORT_SYMBOL_GPL(rt2x00usb_vendor_request_buff);
+
 /*
  * Beacon handlers.
  */
@@ -386,9 +414,8 @@ void rt2x00usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 	struct data_ring *ring;
 	unsigned int i;
 
-	rt2x00usb_vendor_request(rt2x00dev, USB_RX_CONTROL,
-				 USB_VENDOR_REQUEST_OUT, 0x00, 0x00,
-				 NULL, 0, REGISTER_TIMEOUT);
+	rt2x00usb_vendor_request_sw(rt2x00dev, USB_RX_CONTROL, 0x0000, 0x0000,
+				    REGISTER_TIMEOUT);
 
 	/*
 	 * Cancel all rings.
@@ -489,6 +516,21 @@ EXPORT_SYMBOL_GPL(rt2x00usb_uninitialize);
 /*
  * USB driver handlers.
  */
+static int rt2x00usb_alloc_csr(struct rt2x00_dev *rt2x00dev)
+{
+	rt2x00dev->csr_cache = kzalloc(CSR_CACHE_SIZE, GFP_KERNEL);
+	if (!rt2x00dev->csr_cache)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void rt2x00usb_free_csr(struct rt2x00_dev *rt2x00dev)
+{
+	kfree(rt2x00dev->csr_cache);
+	rt2x00dev->csr_cache = NULL;
+}
+
 static int rt2x00usb_alloc_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	rt2x00dev->eeprom = kzalloc(rt2x00dev->ops->eeprom_size, GFP_KERNEL);
@@ -544,10 +586,14 @@ int rt2x00usb_probe(struct usb_interface *usb_intf,
 	rt2x00dev->ops = ops;
 	rt2x00dev->hw = hw;
 
-	retval = rt2x00usb_alloc_eeprom(rt2x00dev);
+	retval = rt2x00usb_alloc_csr(rt2x00dev);
 	if (retval)
 		goto exit_free_device;
 
+	retval = rt2x00usb_alloc_eeprom(rt2x00dev);
+	if (retval)
+		goto exit_free_cr;
+
 	retval = rt2x00usb_alloc_rf(rt2x00dev);
 	if (retval)
 		goto exit_free_eeprom;
@@ -564,6 +610,9 @@ exit_free_rf:
 exit_free_eeprom:
 	rt2x00usb_free_eeprom(rt2x00dev);
 
+exit_free_cr:
+	rt2x00usb_free_csr(rt2x00dev);
+
 exit_free_device:
 	ieee80211_free_hw(hw);
 
@@ -587,6 +636,7 @@ void rt2x00usb_disconnect(struct usb_interface *usb_intf)
 	rt2x00lib_remove_dev(rt2x00dev);
 	rt2x00usb_free_rf(rt2x00dev);
 	rt2x00usb_free_eeprom(rt2x00dev);
+	rt2x00usb_free_csr(rt2x00dev);
 	ieee80211_free_hw(hw);
 
 	/*
@@ -610,6 +660,7 @@ int rt2x00usb_suspend(struct usb_interface *usb_intf, pm_message_t state)
 
 	rt2x00usb_free_rf(rt2x00dev);
 	rt2x00usb_free_eeprom(rt2x00dev);
+	rt2x00usb_free_csr(rt2x00dev);
 
 	/*
 	 * Decrease usbdev refcount.
@@ -628,10 +679,14 @@ int rt2x00usb_resume(struct usb_interface *usb_intf)
 
 	usb_get_dev(interface_to_usbdev(usb_intf));
 
-	retval = rt2x00usb_alloc_eeprom(rt2x00dev);
+	retval = rt2x00usb_alloc_csr(rt2x00dev);
 	if (retval)
 		return retval;
 
+	retval = rt2x00usb_alloc_eeprom(rt2x00dev);
+	if (retval)
+		goto exit_free_csr;
+
 	retval = rt2x00usb_alloc_rf(rt2x00dev);
 	if (retval)
 		goto exit_free_eeprom;
@@ -648,6 +703,9 @@ exit_free_rf:
 exit_free_eeprom:
 	rt2x00usb_free_eeprom(rt2x00dev);
 
+exit_free_csr:
+	rt2x00usb_free_csr(rt2x00dev);
+
 	return retval;
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_resume);
diff --git a/drivers/net/wireless/rt2x00usb.h b/drivers/net/wireless/rt2x00usb.h
index 56044f6..eb410d2 100644
--- a/drivers/net/wireless/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00usb.h
@@ -48,6 +48,12 @@
 #define REGISTER_TIMEOUT_FIRMWARE	1000
 
 /*
+ * Cache size
+ */
+#define CSR_CACHE_SIZE			8
+#define CSR_CACHE_SIZE_FIRMWARE		64
+
+/*
  * USB request types.
  */
 #define USB_VENDOR_REQUEST	( USB_TYPE_VENDOR | USB_RECIP_DEVICE )
@@ -79,21 +85,63 @@
 #define USB_MODE_WAKEUP		0x09	/* RT73USB */
 
 /*
- * Register access.
+ * Used to read/write from/to the device.
+ * This is the main function to communicate with the device,
+ * the buffer argument _must_ either be NULL or point to
+ * a buffer allocated by kmalloc. Failure to do so can lead
+ * to unexpected behavior depending on the architecture.
  */
 int rt2x00usb_vendor_request(const struct rt2x00_dev *rt2x00dev,
-			     const u8 request, const u8 type, const u16 offset,
-			     u32 value, void *buffer, const u16 buffer_length,
-			     const u16 timeout);
+			     const u8 request, const u8 requesttype,
+			     const u16 offset, const u16 value,
+			     void *buffer, const u16 buffer_length,
+			     u16 timeout);
 
+/*
+ * Used to read/write from/to the device.
+ * This function will use a previously with kmalloc allocated cache
+ * to communicate with the device. The contents of the buffer pointer
+ * will be copied to this cache when writing, or read from the cache
+ * when reading.
+ * Buffers send to rt2x00usb_vendor_request _must_ be allocated with
+ * kmalloc. Hence the reason for using a previously allocated cache
+ * which has been allocated properly.
+ */
+int rt2x00usb_vendor_request_buff(const struct rt2x00_dev *rt2x00dev,
+				  const u8 request, const u8 requesttype,
+				  const u16 offset, void *buffer,
+				  const u16 buffer_length, u16 timeout);
+
+/*
+ * Simple wrapper around rt2x00usb_vendor_request to write a single
+ * command to the device. Since we don't use the buffer argument we
+ * don't have to worry about kmalloc here.
+ */
+static inline int rt2x00usb_vendor_request_sw(const struct rt2x00_dev
+					      *rt2x00dev,
+					      const u8 request,
+					      const u16 offset,
+					      const u16 value,
+					      int timeout)
+{
+	return rt2x00usb_vendor_request(rt2x00dev, request,
+					USB_VENDOR_REQUEST_OUT, offset,
+					value, NULL, 0, timeout);
+}
+
+/*
+ * Simple wrapper around rt2x00usb_vendor_request to read the eeprom
+ * from the device. Note that the eeprom argument _must_ be allocated using
+ * kmalloc for correct handling inside the kernel USB layer.
+ */
 static inline int rt2x00usb_eeprom_read(const struct rt2x00_dev *rt2x00dev,
 					 __le16 *eeprom, const u16 lenght)
 {
 	int timeout = REGISTER_TIMEOUT * (lenght / sizeof(u16));
 
 	return rt2x00usb_vendor_request(rt2x00dev, USB_EEPROM_READ,
-					USB_VENDOR_REQUEST_IN, 0x00, 0x00,
-					eeprom, lenght, timeout);
+					USB_VENDOR_REQUEST_IN, 0x0000,
+					0x0000, eeprom, lenght, timeout);
 }
 
 /*
diff --git a/drivers/net/wireless/rt73usb.c b/drivers/net/wireless/rt73usb.c
index 413725c..0d9c1b9 100644
--- a/drivers/net/wireless/rt73usb.c
+++ b/drivers/net/wireless/rt73usb.c
@@ -57,9 +57,9 @@ static inline void rt73usb_register_read(const struct rt2x00_dev *rt2x00dev,
 					 const unsigned int offset, u32 *value)
 {
 	__le32 reg;
-	rt2x00usb_vendor_request(rt2x00dev, USB_MULTI_READ,
-				 USB_VENDOR_REQUEST_IN, offset, 0x00,
-				 &reg, sizeof(u32), REGISTER_TIMEOUT);
+	rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_READ,
+				      USB_VENDOR_REQUEST_IN, offset,
+				      &reg, sizeof(u32), REGISTER_TIMEOUT);
 	*value = le32_to_cpu(reg);
 }
 
@@ -68,19 +68,19 @@ static inline void rt73usb_register_multiread(const struct rt2x00_dev
 					      const unsigned int offset,
 					      void *value, const u32 length)
 {
-	rt2x00usb_vendor_request(rt2x00dev, USB_MULTI_READ,
-				 USB_VENDOR_REQUEST_IN, offset, 0x00,
-				 value, length,
-				 REGISTER_TIMEOUT * (length / sizeof(u32)));
+	int timeout = REGISTER_TIMEOUT * (length / sizeof(u32));
+	rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_READ,
+				      USB_VENDOR_REQUEST_IN, offset,
+				      value, length, timeout);
 }
 
 static inline void rt73usb_register_write(const struct rt2x00_dev *rt2x00dev,
 					  const unsigned int offset, u32 value)
 {
 	__le32 reg = cpu_to_le32(value);
-	rt2x00usb_vendor_request(rt2x00dev, USB_MULTI_WRITE,
-				 USB_VENDOR_REQUEST_OUT, offset, 0x00,
-				 &reg, sizeof(u32), REGISTER_TIMEOUT);
+	rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_WRITE,
+				      USB_VENDOR_REQUEST_OUT, offset,
+				      &reg, sizeof(u32), REGISTER_TIMEOUT);
 }
 
 static inline void rt73usb_register_multiwrite(const struct rt2x00_dev
@@ -88,10 +88,10 @@ static inline void rt73usb_register_multiwrite(const struct rt2x00_dev
 					       const unsigned int offset,
 					       void *value, const u32 length)
 {
-	rt2x00usb_vendor_request(rt2x00dev, USB_MULTI_WRITE,
-				 USB_VENDOR_REQUEST_OUT, offset, 0x00,
-				 value, length,
-				 REGISTER_TIMEOUT * (length / sizeof(u32)));
+	int timeout = REGISTER_TIMEOUT * (length / sizeof(u32));
+	rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_WRITE,
+				      USB_VENDOR_REQUEST_OUT, offset,
+				      value, length, timeout);
 }
 
 static u32 rt73usb_bbp_check(const struct rt2x00_dev *rt2x00dev)
@@ -684,9 +684,8 @@ static void rt73usb_enable_led(struct rt2x00_dev *rt2x00dev)
 		rt2x00_set_field16(&rt2x00dev->led_reg,
 				   MCU_LEDCS_LINK_BG_STATUS, 1);
 
-	rt2x00usb_vendor_request(rt2x00dev, USB_LED_CONTROL,
-				 USB_VENDOR_REQUEST_OUT, 0x00,
-				 rt2x00dev->led_reg, NULL, 0, REGISTER_TIMEOUT);
+	rt2x00usb_vendor_request_sw(rt2x00dev, USB_LED_CONTROL, 0x0000,
+				    rt2x00dev->led_reg, REGISTER_TIMEOUT);
 }
 
 static void rt73usb_disable_led(struct rt2x00_dev *rt2x00dev)
@@ -695,9 +694,8 @@ static void rt73usb_disable_led(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field16(&rt2x00dev->led_reg, MCU_LEDCS_LINK_BG_STATUS, 0);
 	rt2x00_set_field16(&rt2x00dev->led_reg, MCU_LEDCS_LINK_A_STATUS, 0);
 
-	rt2x00usb_vendor_request(rt2x00dev, USB_LED_CONTROL,
-				 USB_VENDOR_REQUEST_OUT, 0x00,
-				 rt2x00dev->led_reg, NULL, 0, REGISTER_TIMEOUT);
+	rt2x00usb_vendor_request_sw(rt2x00dev, USB_LED_CONTROL, 0x0000,
+				    rt2x00dev->led_reg, REGISTER_TIMEOUT);
 }
 
 static void rt73usb_activity_led(struct rt2x00_dev *rt2x00dev, int rssi)
@@ -726,9 +724,8 @@ static void rt73usb_activity_led(struct rt2x00_dev *rt2x00dev, int rssi)
 	else
 		led = 5;
 
-	rt2x00usb_vendor_request(rt2x00dev, USB_LED_CONTROL,
-				 USB_VENDOR_REQUEST_OUT, led,
-				 rt2x00dev->led_reg, NULL, 0, REGISTER_TIMEOUT);
+	rt2x00usb_vendor_request_sw(rt2x00dev, USB_LED_CONTROL, led,
+				    rt2x00dev->led_reg, REGISTER_TIMEOUT);
 }
 
 /*
@@ -886,9 +883,10 @@ static int rt73usb_load_firmware(struct rt2x00_dev *rt2x00dev, void *data,
 	unsigned int i;
 	int status;
 	u32 reg;
-	char buf[64];
 	char *ptr = data;
+	char *cache;
 	int buflen;
+	int timeout;
 
 	/*
 	 * Wait for stable hardware.
@@ -907,23 +905,39 @@ static int rt73usb_load_firmware(struct rt2x00_dev *rt2x00dev, void *data,
 
 	/*
 	 * Write firmware to device.
+	 * We setup a seperate cache for this action,
+	 * since we are going to write larger chunks of data
+	 * then normally used cache size.
 	 */
-	for (i = 0; i < len; i += sizeof(buf)) {
-		buflen = min(len - i, sizeof(buf));
-		memcpy(buf, ptr, buflen);
-		rt73usb_register_multiwrite(rt2x00dev, FIRMWARE_IMAGE_BASE + i,
-					    buf, buflen);
+	cache = kmalloc(CSR_CACHE_SIZE_FIRMWARE, GFP_KERNEL);
+	if (!cache) {
+		ERROR(rt2x00dev, "Failed to allocate firmware cache.\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < len; i += CSR_CACHE_SIZE_FIRMWARE) {
+		buflen = min_t(int, len - i, CSR_CACHE_SIZE_FIRMWARE);
+		timeout = REGISTER_TIMEOUT * (buflen / sizeof(u32));
+
+		memcpy(cache, ptr ,buflen);
+
+		rt2x00usb_vendor_request(rt2x00dev, USB_MULTI_WRITE,
+					 USB_VENDOR_REQUEST_OUT,
+					 FIRMWARE_IMAGE_BASE + i, 0x0000,
+					 cache, buflen, timeout);
+
 		ptr += buflen;
 	}
 
+	kfree(cache);
+
 	/*
 	 * Send firmware request to device to load firmware,
 	 * we need to specify a long timeout time.
 	 */
-	status = rt2x00usb_vendor_request(rt2x00dev, USB_DEVICE_MODE,
-					  USB_VENDOR_REQUEST_OUT, 0x00,
-					  USB_MODE_FIRMWARE, NULL, 0,
-					  REGISTER_TIMEOUT_FIRMWARE);
+	status = rt2x00usb_vendor_request_sw(rt2x00dev, USB_DEVICE_MODE,
+					     0x0000, USB_MODE_FIRMWARE,
+					     REGISTER_TIMEOUT_FIRMWARE);
 	if (status < 0) {
 		ERROR(rt2x00dev, "Failed to write Firmware to device.\n");
 		return status;
@@ -1143,10 +1157,8 @@ static int rt73usb_set_state(struct rt2x00_dev *rt2x00dev, enum dev_state state)
 	put_to_sleep = (state != STATE_AWAKE);
 
 	if (!put_to_sleep)
-		rt2x00usb_vendor_request(rt2x00dev, USB_DEVICE_MODE,
-					 USB_VENDOR_REQUEST_OUT, 0x00,
-					 USB_MODE_WAKEUP, NULL, 0,
-					 REGISTER_TIMEOUT);
+		rt2x00usb_vendor_request_sw(rt2x00dev, USB_DEVICE_MODE, 0x0000,
+					    USB_MODE_WAKEUP, REGISTER_TIMEOUT);
 
 	rt73usb_register_read(rt2x00dev, MAC_CSR12, &reg);
 	rt2x00_set_field32(&reg, MAC_CSR12_FORCE_WAKEUP, !put_to_sleep);
@@ -1154,10 +1166,8 @@ static int rt73usb_set_state(struct rt2x00_dev *rt2x00dev, enum dev_state state)
 	rt73usb_register_write(rt2x00dev, MAC_CSR12, reg);
 
 	if (put_to_sleep)
-		rt2x00usb_vendor_request(rt2x00dev, USB_DEVICE_MODE,
-					 USB_VENDOR_REQUEST_OUT, 0x00,
-					 USB_MODE_SLEEP, NULL, 0,
-					 REGISTER_TIMEOUT);
+		rt2x00usb_vendor_request_sw(rt2x00dev, USB_DEVICE_MODE, 0x0000,
+					    USB_MODE_SLEEP, REGISTER_TIMEOUT);
 
 	/*
 	 * Device is not guaranteed to be in the requested state yet.
-- 
1.5.3.rc5

