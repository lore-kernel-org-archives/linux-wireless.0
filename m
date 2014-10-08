Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756261AbaJHMTR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 08:19:17 -0400
Date: Wed, 8 Oct 2014 14:16:37 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH] rt2x00: tune multi-registers I/O timeout
Message-ID: <20141008121635.GA5186@redhat.com> (sfid-20141008_141931_671873_E08D232A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We provide timeout value to rt2x00usb_vendor_request_buff() based on
number of registers to process. That value is passed down to
rt2x00usb_vendor_req_buff_lock() and ends in usb_control_msg(). But we
do not read/write all registers in rt2x00usb_vendor_req_buff_lock() at
once. We read/write them in chunks of 64 bytes in the loop, hence passed
timeout value to low level is too big.

Patch removes timeout argument from rt2x00usb_vendor_request_buff() and
use short REGISTER_TIMEOUT in rt2x00usb_vendor_req_buff_lock(). That
timeout value should be fine for 64 bytes and smaller requests. For
EEPROM read we introduced new timeout value equal to 2 seconds.

Patch fixes process uninterruptible sleep stalls for long period, when
USB bus has problem to satisfy a request and we wait very long time on
usb_start_wait_urb().

Reported-and-tested-by: Sakari Ailus <sakari.ailus@iki.fi>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c | 10 ++++-----
 drivers/net/wireless/rt2x00/rt2x00usb.c |  4 ++--
 drivers/net/wireless/rt2x00/rt2x00usb.h | 39 ++++++++++-----------------------
 3 files changed, 17 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index d849d59..c878e3f 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -62,7 +62,7 @@ static inline void rt2500usb_register_read(struct rt2x00_dev *rt2x00dev,
 	__le16 reg;
 	rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_READ,
 				      USB_VENDOR_REQUEST_IN, offset,
-				      &reg, sizeof(reg), REGISTER_TIMEOUT);
+				      &reg, sizeof(reg));
 	*value = le16_to_cpu(reg);
 }
 
@@ -83,8 +83,7 @@ static inline void rt2500usb_register_multiread(struct rt2x00_dev *rt2x00dev,
 {
 	rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_READ,
 				      USB_VENDOR_REQUEST_IN, offset,
-				      value, length,
-				      REGISTER_TIMEOUT16(length));
+				      value, length);
 }
 
 static inline void rt2500usb_register_write(struct rt2x00_dev *rt2x00dev,
@@ -94,7 +93,7 @@ static inline void rt2500usb_register_write(struct rt2x00_dev *rt2x00dev,
 	__le16 reg = cpu_to_le16(value);
 	rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_WRITE,
 				      USB_VENDOR_REQUEST_OUT, offset,
-				      &reg, sizeof(reg), REGISTER_TIMEOUT);
+				      &reg, sizeof(reg));
 }
 
 static inline void rt2500usb_register_write_lock(struct rt2x00_dev *rt2x00dev,
@@ -113,8 +112,7 @@ static inline void rt2500usb_register_multiwrite(struct rt2x00_dev *rt2x00dev,
 {
 	rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_WRITE,
 				      USB_VENDOR_REQUEST_OUT, offset,
-				      value, length,
-				      REGISTER_TIMEOUT16(length));
+				      value, length);
 }
 
 static int rt2500usb_regbusy_read(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 86c43d1..dc85d3e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -116,7 +116,7 @@ EXPORT_SYMBOL_GPL(rt2x00usb_vendor_req_buff_lock);
 int rt2x00usb_vendor_request_buff(struct rt2x00_dev *rt2x00dev,
 				  const u8 request, const u8 requesttype,
 				  const u16 offset, void *buffer,
-				  const u16 buffer_length, const int timeout)
+				  const u16 buffer_length)
 {
 	int status = 0;
 	unsigned char *tb;
@@ -131,7 +131,7 @@ int rt2x00usb_vendor_request_buff(struct rt2x00_dev *rt2x00dev,
 		bsize = min_t(u16, CSR_CACHE_SIZE, len);
 		status = rt2x00usb_vendor_req_buff_lock(rt2x00dev, request,
 							requesttype, off, tb,
-							bsize, timeout);
+							bsize, REGISTER_TIMEOUT);
 
 		tb  += bsize;
 		len -= bsize;
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index 831b65f..819690e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -33,27 +33,14 @@
 })
 
 /*
- * For USB vendor requests we need to pass a timeout
- * time in ms, for this we use the REGISTER_TIMEOUT,
- * however when loading firmware a higher value is
- * required. In that case we use the REGISTER_TIMEOUT_FIRMWARE.
+ * For USB vendor requests we need to pass a timeout time in ms, for this we
+ * use the REGISTER_TIMEOUT, however when loading firmware or read EEPROM
+ * a higher value is required. In that case we use the REGISTER_TIMEOUT_FIRMWARE
+ * and EEPROM_TIMEOUT.
  */
 #define REGISTER_TIMEOUT		500
 #define REGISTER_TIMEOUT_FIRMWARE	1000
-
-/**
- * REGISTER_TIMEOUT16 - Determine the timeout for 16bit register access
- * @__datalen: Data length
- */
-#define REGISTER_TIMEOUT16(__datalen)	\
-	( REGISTER_TIMEOUT * ((__datalen) / sizeof(u16)) )
-
-/**
- * REGISTER_TIMEOUT32 - Determine the timeout for 32bit register access
- * @__datalen: Data length
- */
-#define REGISTER_TIMEOUT32(__datalen)	\
-	( REGISTER_TIMEOUT * ((__datalen) / sizeof(u32)) )
+#define EEPROM_TIMEOUT			2000
 
 /*
  * Cache size
@@ -126,7 +113,6 @@ int rt2x00usb_vendor_request(struct rt2x00_dev *rt2x00dev,
  * @offset: Register offset to perform action on
  * @buffer: Buffer where information will be read/written to by device
  * @buffer_length: Size of &buffer
- * @timeout: Operation timeout
  *
  * This function will use a previously with kmalloc allocated cache
  * to communicate with the device. The contents of the buffer pointer
@@ -139,7 +125,7 @@ int rt2x00usb_vendor_request(struct rt2x00_dev *rt2x00dev,
 int rt2x00usb_vendor_request_buff(struct rt2x00_dev *rt2x00dev,
 				  const u8 request, const u8 requesttype,
 				  const u16 offset, void *buffer,
-				  const u16 buffer_length, const int timeout);
+				  const u16 buffer_length);
 
 /**
  * rt2x00usb_vendor_request_buff - Send register command to device (buffered)
@@ -197,8 +183,7 @@ static inline int rt2x00usb_eeprom_read(struct rt2x00_dev *rt2x00dev,
 {
 	return rt2x00usb_vendor_request(rt2x00dev, USB_EEPROM_READ,
 					USB_VENDOR_REQUEST_IN, 0, 0,
-					eeprom, length,
-					REGISTER_TIMEOUT16(length));
+					eeprom, length, EEPROM_TIMEOUT);
 }
 
 /**
@@ -217,7 +202,7 @@ static inline void rt2x00usb_register_read(struct rt2x00_dev *rt2x00dev,
 	__le32 reg;
 	rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_READ,
 				      USB_VENDOR_REQUEST_IN, offset,
-				      &reg, sizeof(reg), REGISTER_TIMEOUT);
+				      &reg, sizeof(reg));
 	*value = le32_to_cpu(reg);
 }
 
@@ -257,8 +242,7 @@ static inline void rt2x00usb_register_multiread(struct rt2x00_dev *rt2x00dev,
 {
 	rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_READ,
 				      USB_VENDOR_REQUEST_IN, offset,
-				      value, length,
-				      REGISTER_TIMEOUT32(length));
+				      value, length);
 }
 
 /**
@@ -277,7 +261,7 @@ static inline void rt2x00usb_register_write(struct rt2x00_dev *rt2x00dev,
 	__le32 reg = cpu_to_le32(value);
 	rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_WRITE,
 				      USB_VENDOR_REQUEST_OUT, offset,
-				      &reg, sizeof(reg), REGISTER_TIMEOUT);
+				      &reg, sizeof(reg));
 }
 
 /**
@@ -316,8 +300,7 @@ static inline void rt2x00usb_register_multiwrite(struct rt2x00_dev *rt2x00dev,
 {
 	rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_WRITE,
 				      USB_VENDOR_REQUEST_OUT, offset,
-				      (void *)value, length,
-				      REGISTER_TIMEOUT32(length));
+				      (void *)value, length);
 }
 
 /**
-- 
1.8.3.1

