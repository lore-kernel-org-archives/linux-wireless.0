Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:12554 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875AbYKIWkx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2008 17:40:53 -0500
Received: by ey-out-2122.google.com with SMTP id 6so834152eyi.37
        for <linux-wireless@vger.kernel.org>; Sun, 09 Nov 2008 14:40:51 -0800 (PST)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Fix race condition when using inderect registers
Date: Sun, 9 Nov 2008 23:40:46 +0100
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200811092340.46631.IvDoorn@gmail.com> (sfid-20081109_234101_134532_C19013F2)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Indirect registers require multiple calls to the CSR
register in order to access the indirect registers.
This must be protected under a lock to prevent race
conditions which could cause invalid data to
be returned when reading from the indirect register or silent
failures when writing data to the indirect register.

USB drivers where already protected under a mutex,
so rename the mutex and make PCI drivers use the mutex
as well.
This now means that BBP and RF registers are no longer
accessible in interrupt context. That is not a bad
situation since the slow behavior of accessing
those registers means we don't _want_ to access them
in interrupt context either.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index c4c56b0..aa86723 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -69,14 +69,14 @@ static void rt2400pci_bbp_write(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
+	mutex_lock(&rt2x00dev->csr_mutex);
+
 	/*
 	 * Wait until the BBP becomes ready.
 	 */
 	reg = rt2400pci_bbp_check(rt2x00dev);
-	if (rt2x00_get_field32(reg, BBPCSR_BUSY)) {
-		ERROR(rt2x00dev, "BBPCSR register busy. Write failed.\n");
-		return;
-	}
+	if (rt2x00_get_field32(reg, BBPCSR_BUSY))
+		goto exit_fail;
 
 	/*
 	 * Write the data into the BBP.
@@ -88,6 +88,15 @@ static void rt2400pci_bbp_write(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, BBPCSR_WRITE_CONTROL, 1);
 
 	rt2x00pci_register_write(rt2x00dev, BBPCSR, reg);
+
+	mutex_unlock(&rt2x00dev->csr_mutex);
+
+	return;
+
+exit_fail:
+	mutex_unlock(&rt2x00dev->csr_mutex);
+
+	ERROR(rt2x00dev, "BBPCSR register busy. Write failed.\n");
 }
 
 static void rt2400pci_bbp_read(struct rt2x00_dev *rt2x00dev,
@@ -95,14 +104,14 @@ static void rt2400pci_bbp_read(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
+	mutex_lock(&rt2x00dev->csr_mutex);
+
 	/*
 	 * Wait until the BBP becomes ready.
 	 */
 	reg = rt2400pci_bbp_check(rt2x00dev);
-	if (rt2x00_get_field32(reg, BBPCSR_BUSY)) {
-		ERROR(rt2x00dev, "BBPCSR register busy. Read failed.\n");
-		return;
-	}
+	if (rt2x00_get_field32(reg, BBPCSR_BUSY))
+		goto exit_fail;
 
 	/*
 	 * Write the request into the BBP.
@@ -118,13 +127,20 @@ static void rt2400pci_bbp_read(struct rt2x00_dev *rt2x00dev,
 	 * Wait until the BBP becomes ready.
 	 */
 	reg = rt2400pci_bbp_check(rt2x00dev);
-	if (rt2x00_get_field32(reg, BBPCSR_BUSY)) {
-		ERROR(rt2x00dev, "BBPCSR register busy. Read failed.\n");
-		*value = 0xff;
-		return;
-	}
+	if (rt2x00_get_field32(reg, BBPCSR_BUSY))
+		goto exit_fail;
 
 	*value = rt2x00_get_field32(reg, BBPCSR_VALUE);
+
+	mutex_unlock(&rt2x00dev->csr_mutex);
+
+	return;
+
+exit_fail:
+	mutex_unlock(&rt2x00dev->csr_mutex);
+
+	ERROR(rt2x00dev, "BBPCSR register busy. Read failed.\n");
+	*value = 0xff;
 }
 
 static void rt2400pci_rf_write(struct rt2x00_dev *rt2x00dev,
@@ -136,6 +152,8 @@ static void rt2400pci_rf_write(struct rt2x00_dev *rt2x00dev,
 	if (!word)
 		return;
 
+	mutex_lock(&rt2x00dev->csr_mutex);
+
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
 		rt2x00pci_register_read(rt2x00dev, RFCSR, &reg);
 		if (!rt2x00_get_field32(reg, RFCSR_BUSY))
@@ -143,6 +161,7 @@ static void rt2400pci_rf_write(struct rt2x00_dev *rt2x00dev,
 		udelay(REGISTER_BUSY_DELAY);
 	}
 
+	mutex_unlock(&rt2x00dev->csr_mutex);
 	ERROR(rt2x00dev, "RFCSR register busy. Write failed.\n");
 	return;
 
@@ -155,6 +174,8 @@ rf_write:
 
 	rt2x00pci_register_write(rt2x00dev, RFCSR, reg);
 	rt2x00_rf_write(rt2x00dev, word, value);
+
+	mutex_unlock(&rt2x00dev->csr_mutex);
 }
 
 static void rt2400pci_eepromregister_read(struct eeprom_93cx6 *eeprom)
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 08fb8e0..7f1fce0 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -69,14 +69,14 @@ static void rt2500pci_bbp_write(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
+	mutex_lock(&rt2x00dev->csr_mutex);
+
 	/*
 	 * Wait until the BBP becomes ready.
 	 */
 	reg = rt2500pci_bbp_check(rt2x00dev);
-	if (rt2x00_get_field32(reg, BBPCSR_BUSY)) {
-		ERROR(rt2x00dev, "BBPCSR register busy. Write failed.\n");
-		return;
-	}
+	if (rt2x00_get_field32(reg, BBPCSR_BUSY))
+		goto exit_fail;
 
 	/*
 	 * Write the data into the BBP.
@@ -88,6 +88,15 @@ static void rt2500pci_bbp_write(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, BBPCSR_WRITE_CONTROL, 1);
 
 	rt2x00pci_register_write(rt2x00dev, BBPCSR, reg);
+
+	mutex_unlock(&rt2x00dev->csr_mutex);
+
+	return;
+
+exit_fail:
+	mutex_unlock(&rt2x00dev->csr_mutex);
+
+	ERROR(rt2x00dev, "BBPCSR register busy. Write failed.\n");
 }
 
 static void rt2500pci_bbp_read(struct rt2x00_dev *rt2x00dev,
@@ -95,14 +104,14 @@ static void rt2500pci_bbp_read(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
+	mutex_lock(&rt2x00dev->csr_mutex);
+
 	/*
 	 * Wait until the BBP becomes ready.
 	 */
 	reg = rt2500pci_bbp_check(rt2x00dev);
-	if (rt2x00_get_field32(reg, BBPCSR_BUSY)) {
-		ERROR(rt2x00dev, "BBPCSR register busy. Read failed.\n");
-		return;
-	}
+	if (rt2x00_get_field32(reg, BBPCSR_BUSY))
+		goto exit_fail;
 
 	/*
 	 * Write the request into the BBP.
@@ -118,13 +127,20 @@ static void rt2500pci_bbp_read(struct rt2x00_dev *rt2x00dev,
 	 * Wait until the BBP becomes ready.
 	 */
 	reg = rt2500pci_bbp_check(rt2x00dev);
-	if (rt2x00_get_field32(reg, BBPCSR_BUSY)) {
-		ERROR(rt2x00dev, "BBPCSR register busy. Read failed.\n");
-		*value = 0xff;
-		return;
-	}
+	if (rt2x00_get_field32(reg, BBPCSR_BUSY))
+		goto exit_fail;
 
 	*value = rt2x00_get_field32(reg, BBPCSR_VALUE);
+
+	mutex_unlock(&rt2x00dev->csr_mutex);
+
+	return;
+
+exit_fail:
+	mutex_unlock(&rt2x00dev->csr_mutex);
+
+	ERROR(rt2x00dev, "BBPCSR register busy. Read failed.\n");
+	*value = 0xff;
 }
 
 static void rt2500pci_rf_write(struct rt2x00_dev *rt2x00dev,
@@ -136,6 +152,8 @@ static void rt2500pci_rf_write(struct rt2x00_dev *rt2x00dev,
 	if (!word)
 		return;
 
+	mutex_lock(&rt2x00dev->csr_mutex);
+
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
 		rt2x00pci_register_read(rt2x00dev, RFCSR, &reg);
 		if (!rt2x00_get_field32(reg, RFCSR_BUSY))
@@ -143,6 +161,7 @@ static void rt2500pci_rf_write(struct rt2x00_dev *rt2x00dev,
 		udelay(REGISTER_BUSY_DELAY);
 	}
 
+	mutex_unlock(&rt2x00dev->csr_mutex);
 	ERROR(rt2x00dev, "RFCSR register busy. Write failed.\n");
 	return;
 
@@ -155,6 +174,8 @@ rf_write:
 
 	rt2x00pci_register_write(rt2x00dev, RFCSR, reg);
 	rt2x00_rf_write(rt2x00dev, word, value);
+
+	mutex_unlock(&rt2x00dev->csr_mutex);
 }
 
 static void rt2500pci_eepromregister_read(struct eeprom_93cx6 *eeprom)
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index ecc4e5a..a2b48a4 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -47,7 +47,7 @@
  * between each attampt. When the busy bit is still set at that time,
  * the access attempt is considered to have failed,
  * and we will print an error.
- * If the usb_cache_mutex is already held then the _lock variants must
+ * If the csr_mutex is already held then the _lock variants must
  * be used instead.
  */
 static inline void rt2500usb_register_read(struct rt2x00_dev *rt2x00dev,
@@ -132,7 +132,7 @@ static void rt2500usb_bbp_write(struct rt2x00_dev *rt2x00dev,
 {
 	u16 reg;
 
-	mutex_lock(&rt2x00dev->usb_cache_mutex);
+	mutex_lock(&rt2x00dev->csr_mutex);
 
 	/*
 	 * Wait until the BBP becomes ready.
@@ -151,12 +151,12 @@ static void rt2500usb_bbp_write(struct rt2x00_dev *rt2x00dev,
 
 	rt2500usb_register_write_lock(rt2x00dev, PHY_CSR7, reg);
 
-	mutex_unlock(&rt2x00dev->usb_cache_mutex);
+	mutex_unlock(&rt2x00dev->csr_mutex);
 
 	return;
 
 exit_fail:
-	mutex_unlock(&rt2x00dev->usb_cache_mutex);
+	mutex_unlock(&rt2x00dev->csr_mutex);
 
 	ERROR(rt2x00dev, "PHY_CSR8 register busy. Write failed.\n");
 }
@@ -166,7 +166,7 @@ static void rt2500usb_bbp_read(struct rt2x00_dev *rt2x00dev,
 {
 	u16 reg;
 
-	mutex_lock(&rt2x00dev->usb_cache_mutex);
+	mutex_lock(&rt2x00dev->csr_mutex);
 
 	/*
 	 * Wait until the BBP becomes ready.
@@ -194,12 +194,12 @@ static void rt2500usb_bbp_read(struct rt2x00_dev *rt2x00dev,
 	rt2500usb_register_read_lock(rt2x00dev, PHY_CSR7, &reg);
 	*value = rt2x00_get_field16(reg, PHY_CSR7_DATA);
 
-	mutex_unlock(&rt2x00dev->usb_cache_mutex);
+	mutex_unlock(&rt2x00dev->csr_mutex);
 
 	return;
 
 exit_fail:
-	mutex_unlock(&rt2x00dev->usb_cache_mutex);
+	mutex_unlock(&rt2x00dev->csr_mutex);
 
 	ERROR(rt2x00dev, "PHY_CSR8 register busy. Read failed.\n");
 	*value = 0xff;
@@ -214,7 +214,7 @@ static void rt2500usb_rf_write(struct rt2x00_dev *rt2x00dev,
 	if (!word)
 		return;
 
-	mutex_lock(&rt2x00dev->usb_cache_mutex);
+	mutex_lock(&rt2x00dev->csr_mutex);
 
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
 		rt2500usb_register_read_lock(rt2x00dev, PHY_CSR10, &reg);
@@ -223,7 +223,7 @@ static void rt2500usb_rf_write(struct rt2x00_dev *rt2x00dev,
 		udelay(REGISTER_BUSY_DELAY);
 	}
 
-	mutex_unlock(&rt2x00dev->usb_cache_mutex);
+	mutex_unlock(&rt2x00dev->csr_mutex);
 	ERROR(rt2x00dev, "PHY_CSR10 register busy. Write failed.\n");
 	return;
 
@@ -241,7 +241,7 @@ rf_write:
 	rt2500usb_register_write_lock(rt2x00dev, PHY_CSR10, reg);
 	rt2x00_rf_write(rt2x00dev, word, value);
 
-	mutex_unlock(&rt2x00dev->usb_cache_mutex);
+	mutex_unlock(&rt2x00dev->csr_mutex);
 }
 
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index baccea7..fee61be 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -746,16 +746,15 @@ struct rt2x00_dev {
 	} csr;
 
 	/*
-	 * Mutex to protect register accesses on USB devices.
-	 * There are 2 reasons this is needed, one is to ensure
-	 * use of the csr_cache (for USB devices) by one thread
-	 * isn't corrupted by another thread trying to access it.
-	 * The other is that access to BBP and RF registers
-	 * require multiple BUS transactions and if another thread
-	 * attempted to access one of those registers at the same
-	 * time one of the writes could silently fail.
-	 */
-	struct mutex usb_cache_mutex;
+	 * Mutex to protect register accesses.
+	 * For PCI and USB devices it protects against concurrent indirect
+	 * register access (BBP, RF, MCU) since accessing those
+	 * registers require multiple calls to the CSR registers.
+	 * For USB devices it also protects the csr_cache since that
+	 * field is used for normal CSR access and it cannot support
+	 * multiple callers simultaneously.
+	 */
+	struct mutex csr_mutex;
 
 	/*
 	 * Current packet filter configuration for the device.
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index bb510a2..7fc1d76 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1051,6 +1051,8 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 {
 	int retval = -ENOMEM;
 
+	mutex_init(&rt2x00dev->csr_mutex);
+
 	/*
 	 * Make room for rt2x00_intf inside the per-interface
 	 * structure ieee80211_vif.
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 4eb550f..c507b0d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -79,7 +79,7 @@ int rt2x00usb_vendor_req_buff_lock(struct rt2x00_dev *rt2x00dev,
 {
 	int status;
 
-	BUG_ON(!mutex_is_locked(&rt2x00dev->usb_cache_mutex));
+	BUG_ON(!mutex_is_locked(&rt2x00dev->csr_mutex));
 
 	/*
 	 * Check for Cache availability.
@@ -110,13 +110,13 @@ int rt2x00usb_vendor_request_buff(struct rt2x00_dev *rt2x00dev,
 {
 	int status;
 
-	mutex_lock(&rt2x00dev->usb_cache_mutex);
+	mutex_lock(&rt2x00dev->csr_mutex);
 
 	status = rt2x00usb_vendor_req_buff_lock(rt2x00dev, request,
 						requesttype, offset, buffer,
 						buffer_length, timeout);
 
-	mutex_unlock(&rt2x00dev->usb_cache_mutex);
+	mutex_unlock(&rt2x00dev->csr_mutex);
 
 	return status;
 }
@@ -132,7 +132,7 @@ int rt2x00usb_vendor_request_large_buff(struct rt2x00_dev *rt2x00dev,
 	unsigned char *tb;
 	u16 off, len, bsize;
 
-	mutex_lock(&rt2x00dev->usb_cache_mutex);
+	mutex_lock(&rt2x00dev->csr_mutex);
 
 	tb  = (char *)buffer;
 	off = offset;
@@ -148,7 +148,7 @@ int rt2x00usb_vendor_request_large_buff(struct rt2x00_dev *rt2x00dev,
 		off += bsize;
 	}
 
-	mutex_unlock(&rt2x00dev->usb_cache_mutex);
+	mutex_unlock(&rt2x00dev->csr_mutex);
 
 	return status;
 }
@@ -531,7 +531,6 @@ int rt2x00usb_probe(struct usb_interface *usb_intf,
 	rt2x00dev->dev = &usb_intf->dev;
 	rt2x00dev->ops = ops;
 	rt2x00dev->hw = hw;
-	mutex_init(&rt2x00dev->usb_cache_mutex);
 
 	rt2x00dev->usb_maxpacket =
 	    usb_maxpacket(usb_dev, usb_sndbulkpipe(usb_dev, 1), 1);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index cea66bb..c7cc5e9 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -75,14 +75,14 @@ static void rt61pci_bbp_write(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
+	mutex_lock(&rt2x00dev->csr_mutex);
+
 	/*
 	 * Wait until the BBP becomes ready.
 	 */
 	reg = rt61pci_bbp_check(rt2x00dev);
-	if (rt2x00_get_field32(reg, PHY_CSR3_BUSY)) {
-		ERROR(rt2x00dev, "PHY_CSR3 register busy. Write failed.\n");
-		return;
-	}
+	if (rt2x00_get_field32(reg, PHY_CSR3_BUSY))
+		goto exit_fail;
 
 	/*
 	 * Write the data into the BBP.
@@ -94,6 +94,14 @@ static void rt61pci_bbp_write(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, PHY_CSR3_READ_CONTROL, 0);
 
 	rt2x00pci_register_write(rt2x00dev, PHY_CSR3, reg);
+	mutex_unlock(&rt2x00dev->csr_mutex);
+
+	return;
+
+exit_fail:
+	mutex_unlock(&rt2x00dev->csr_mutex);
+
+	ERROR(rt2x00dev, "PHY_CSR3 register busy. Write failed.\n");
 }
 
 static void rt61pci_bbp_read(struct rt2x00_dev *rt2x00dev,
@@ -101,14 +109,14 @@ static void rt61pci_bbp_read(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
+	mutex_lock(&rt2x00dev->csr_mutex);
+
 	/*
 	 * Wait until the BBP becomes ready.
 	 */
 	reg = rt61pci_bbp_check(rt2x00dev);
-	if (rt2x00_get_field32(reg, PHY_CSR3_BUSY)) {
-		ERROR(rt2x00dev, "PHY_CSR3 register busy. Read failed.\n");
-		return;
-	}
+	if (rt2x00_get_field32(reg, PHY_CSR3_BUSY))
+		goto exit_fail;
 
 	/*
 	 * Write the request into the BBP.
@@ -124,13 +132,19 @@ static void rt61pci_bbp_read(struct rt2x00_dev *rt2x00dev,
 	 * Wait until the BBP becomes ready.
 	 */
 	reg = rt61pci_bbp_check(rt2x00dev);
-	if (rt2x00_get_field32(reg, PHY_CSR3_BUSY)) {
-		ERROR(rt2x00dev, "PHY_CSR3 register busy. Read failed.\n");
-		*value = 0xff;
-		return;
-	}
+	if (rt2x00_get_field32(reg, PHY_CSR3_BUSY))
+		goto exit_fail;
 
 	*value = rt2x00_get_field32(reg, PHY_CSR3_VALUE);
+	mutex_unlock(&rt2x00dev->csr_mutex);
+
+	return;
+
+exit_fail:
+	mutex_unlock(&rt2x00dev->csr_mutex);
+
+	ERROR(rt2x00dev, "PHY_CSR3 register busy. Read failed.\n");
+	*value = 0xff;
 }
 
 static void rt61pci_rf_write(struct rt2x00_dev *rt2x00dev,
@@ -142,6 +156,8 @@ static void rt61pci_rf_write(struct rt2x00_dev *rt2x00dev,
 	if (!word)
 		return;
 
+	mutex_lock(&rt2x00dev->csr_mutex);
+
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
 		rt2x00pci_register_read(rt2x00dev, PHY_CSR4, &reg);
 		if (!rt2x00_get_field32(reg, PHY_CSR4_BUSY))
@@ -149,6 +165,7 @@ static void rt61pci_rf_write(struct rt2x00_dev *rt2x00dev,
 		udelay(REGISTER_BUSY_DELAY);
 	}
 
+	mutex_unlock(&rt2x00dev->csr_mutex);
 	ERROR(rt2x00dev, "PHY_CSR4 register busy. Write failed.\n");
 	return;
 
@@ -161,6 +178,8 @@ rf_write:
 
 	rt2x00pci_register_write(rt2x00dev, PHY_CSR4, reg);
 	rt2x00_rf_write(rt2x00dev, word, value);
+
+	mutex_unlock(&rt2x00dev->csr_mutex);
 }
 
 #ifdef CONFIG_RT2X00_LIB_LEDS
@@ -175,14 +194,12 @@ static void rt61pci_mcu_request(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
+	mutex_lock(&rt2x00dev->csr_mutex);
+
 	rt2x00pci_register_read(rt2x00dev, H2M_MAILBOX_CSR, &reg);
 
-	if (rt2x00_get_field32(reg, H2M_MAILBOX_CSR_OWNER)) {
-		ERROR(rt2x00dev, "mcu request error. "
-		      "Request 0x%02x failed for token 0x%02x.\n",
-		      command, token);
-		return;
-	}
+	if (rt2x00_get_field32(reg, H2M_MAILBOX_CSR_OWNER))
+		goto exit_fail;
 
 	rt2x00_set_field32(&reg, H2M_MAILBOX_CSR_OWNER, 1);
 	rt2x00_set_field32(&reg, H2M_MAILBOX_CSR_CMD_TOKEN, token);
@@ -194,6 +211,17 @@ static void rt61pci_mcu_request(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, HOST_CMD_CSR_HOST_COMMAND, command);
 	rt2x00_set_field32(&reg, HOST_CMD_CSR_INTERRUPT_MCU, 1);
 	rt2x00pci_register_write(rt2x00dev, HOST_CMD_CSR, reg);
+
+	mutex_unlock(&rt2x00dev->csr_mutex);
+
+	return;
+
+exit_fail:
+	mutex_unlock(&rt2x00dev->csr_mutex);
+
+	ERROR(rt2x00dev,
+	      "mcu request error. Request 0x%02x failed for token 0x%02x.\n",
+	      command, token);
 }
 #endif /* CONFIG_RT2X00_LIB_LEDS */
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index eddc489..c5645e1 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -55,7 +55,7 @@ MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
  * between each attampt. When the busy bit is still set at that time,
  * the access attempt is considered to have failed,
  * and we will print an error.
- * The _lock versions must be used if you already hold the usb_cache_mutex
+ * The _lock versions must be used if you already hold the csr_mutex
  */
 static inline void rt73usb_register_read(struct rt2x00_dev *rt2x00dev,
 					 const unsigned int offset, u32 *value)
@@ -135,7 +135,7 @@ static void rt73usb_bbp_write(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
-	mutex_lock(&rt2x00dev->usb_cache_mutex);
+	mutex_lock(&rt2x00dev->csr_mutex);
 
 	/*
 	 * Wait until the BBP becomes ready.
@@ -154,12 +154,12 @@ static void rt73usb_bbp_write(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, PHY_CSR3_READ_CONTROL, 0);
 
 	rt73usb_register_write_lock(rt2x00dev, PHY_CSR3, reg);
-	mutex_unlock(&rt2x00dev->usb_cache_mutex);
+	mutex_unlock(&rt2x00dev->csr_mutex);
 
 	return;
 
 exit_fail:
-	mutex_unlock(&rt2x00dev->usb_cache_mutex);
+	mutex_unlock(&rt2x00dev->csr_mutex);
 
 	ERROR(rt2x00dev, "PHY_CSR3 register busy. Write failed.\n");
 }
@@ -169,7 +169,7 @@ static void rt73usb_bbp_read(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
-	mutex_lock(&rt2x00dev->usb_cache_mutex);
+	mutex_lock(&rt2x00dev->csr_mutex);
 
 	/*
 	 * Wait until the BBP becomes ready.
@@ -196,12 +196,12 @@ static void rt73usb_bbp_read(struct rt2x00_dev *rt2x00dev,
 		goto exit_fail;
 
 	*value = rt2x00_get_field32(reg, PHY_CSR3_VALUE);
-	mutex_unlock(&rt2x00dev->usb_cache_mutex);
+	mutex_unlock(&rt2x00dev->csr_mutex);
 
 	return;
 
 exit_fail:
-	mutex_unlock(&rt2x00dev->usb_cache_mutex);
+	mutex_unlock(&rt2x00dev->csr_mutex);
 
 	ERROR(rt2x00dev, "PHY_CSR3 register busy. Read failed.\n");
 	*value = 0xff;
@@ -216,7 +216,7 @@ static void rt73usb_rf_write(struct rt2x00_dev *rt2x00dev,
 	if (!word)
 		return;
 
-	mutex_lock(&rt2x00dev->usb_cache_mutex);
+	mutex_lock(&rt2x00dev->csr_mutex);
 
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
 		rt73usb_register_read_lock(rt2x00dev, PHY_CSR4, &reg);
@@ -225,7 +225,7 @@ static void rt73usb_rf_write(struct rt2x00_dev *rt2x00dev,
 		udelay(REGISTER_BUSY_DELAY);
 	}
 
-	mutex_unlock(&rt2x00dev->usb_cache_mutex);
+	mutex_unlock(&rt2x00dev->csr_mutex);
 	ERROR(rt2x00dev, "PHY_CSR4 register busy. Write failed.\n");
 	return;
 
@@ -245,7 +245,8 @@ rf_write:
 
 	rt73usb_register_write_lock(rt2x00dev, PHY_CSR4, reg);
 	rt2x00_rf_write(rt2x00dev, word, value);
-	mutex_unlock(&rt2x00dev->usb_cache_mutex);
+
+	mutex_unlock(&rt2x00dev->csr_mutex);
 }
 
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
