Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:30041 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbXIYSoh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 14:44:37 -0400
Received: by nf-out-0910.google.com with SMTP id g13so1757580nfb
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2007 11:44:36 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/12] rt2x00: Increase rt2x00usb_vendor_request timeout.
Date: Tue, 25 Sep 2007 20:54:20 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709252052.34803.IvDoorn@gmail.com>
In-Reply-To: <200709252052.34803.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200709252054.20136.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By increasing the timeout for rt2x00usb_vendor_request,
we should limit the number of loops required to send
a signal to the device succefully.
500ms timeout is specified by the Ralink legacy drivers
for rt2500usb. For rt73usb 1000ms is specified, but that
includes the timeout for the firmware which is already
specified in a different define.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00usb.c |   10 ++++------
 drivers/net/wireless/rt2x00/rt2x00usb.h |    8 ++++----
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index a0f05ca..248144f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -42,7 +42,7 @@ int rt2x00usb_vendor_request(const struct rt2x00_dev *rt2x00dev,
 			     const u8 request, const u8 requesttype,
 			     const u16 offset, const u16 value,
 			     void *buffer, const u16 buffer_length,
-			     u16 timeout)
+			     const int timeout)
 {
 	struct usb_device *usb_dev =
 	    interface_to_usbdev(rt2x00dev_usb(rt2x00dev));
@@ -60,12 +60,10 @@ int rt2x00usb_vendor_request(const struct rt2x00_dev *rt2x00dev,
 			return 0;
 
 		/*
-		 * Check for errors,
-		 * -ETIMEDOUT: We need a bit more time to complete.
+		 * Check for errors
 		 * -ENODEV: Device has disappeared, no point continuing.
+		 * All other errors: Try again.
 		 */
-		if (status == -ETIMEDOUT)
-			timeout *= 2;
 		else if (status == -ENODEV)
 			break;
 	}
@@ -81,7 +79,7 @@ EXPORT_SYMBOL_GPL(rt2x00usb_vendor_request);
 int rt2x00usb_vendor_request_buff(const struct rt2x00_dev *rt2x00dev,
 				  const u8 request, const u8 requesttype,
 				  const u16 offset, void *buffer,
-				  const u16 buffer_length, u16 timeout)
+				  const u16 buffer_length, const int timeout)
 {
 	int status;
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index d4113e5..2681abe 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -44,7 +44,7 @@
  */
 #define REGISTER_BUSY_COUNT		5
 #define REGISTER_BUSY_DELAY		100
-#define REGISTER_TIMEOUT		20
+#define REGISTER_TIMEOUT		500
 #define REGISTER_TIMEOUT_FIRMWARE	1000
 
 /*
@@ -95,7 +95,7 @@ int rt2x00usb_vendor_request(const struct rt2x00_dev *rt2x00dev,
 			     const u8 request, const u8 requesttype,
 			     const u16 offset, const u16 value,
 			     void *buffer, const u16 buffer_length,
-			     u16 timeout);
+			     const int timeout);
 
 /*
  * Used to read/write from/to the device.
@@ -110,7 +110,7 @@ int rt2x00usb_vendor_request(const struct rt2x00_dev *rt2x00dev,
 int rt2x00usb_vendor_request_buff(const struct rt2x00_dev *rt2x00dev,
 				  const u8 request, const u8 requesttype,
 				  const u16 offset, void *buffer,
-				  const u16 buffer_length, u16 timeout);
+				  const u16 buffer_length, const int timeout);
 
 /*
  * Simple wrapper around rt2x00usb_vendor_request to write a single
@@ -122,7 +122,7 @@ static inline int rt2x00usb_vendor_request_sw(const struct rt2x00_dev
 					      const u8 request,
 					      const u16 offset,
 					      const u16 value,
-					      int timeout)
+					      const int timeout)
 {
 	return rt2x00usb_vendor_request(rt2x00dev, request,
 					USB_VENDOR_REQUEST_OUT, offset,
-- 
1.5.3.2

