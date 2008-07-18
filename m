Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:7770 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552AbYGRSlT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 14:41:19 -0400
Received: by nf-out-0910.google.com with SMTP id d3so160308nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jul 2008 11:41:19 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 3/6] rt2x00: Support for large vendor requests
Date: Fri, 18 Jul 2008 20:44:22 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200807182043.08990.IvDoorn@gmail.com> <200807182043.34057.IvDoorn@gmail.com> <200807182043.52015.IvDoorn@gmail.com>
In-Reply-To: <200807182043.52015.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807182044.23079.IvDoorn@gmail.com> (sfid-20080718_204122_487797_9D92C381)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Iwo Mergler <iwo@call-direct.com.au>

Adds an extra rt2x00 vendor request function to support register
transfers beyond the CSR_CACHE_SIZE / USB packet size limit. This
is useful for firmware uploads, beacon templates and keys, all
of which are to large to do with a single USB request.

Signed-off-by: Iwo Mergler <Iwo@call-direct.com.au>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00usb.c |   33 +++++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00usb.h |   21 ++++++++++++++++++-
 2 files changed, 53 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 83862e7..23ec0f4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -122,6 +122,39 @@ int rt2x00usb_vendor_request_buff(struct rt2x00_dev *rt2x00dev,
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_vendor_request_buff);
 
+
+int rt2x00usb_vendor_request_larg_buff(struct rt2x00_dev *rt2x00dev,
+			     const u8 request, const u8 requesttype,
+			     const u16 offset, void *buffer,
+			     const u16 buffer_length, const int timeout)
+{
+	int status = 0;
+	unsigned char *tb;
+	u16 off, len, bsize;
+
+	mutex_lock(&rt2x00dev->usb_cache_mutex);
+
+	tb  = buffer;
+	off = offset;
+	len = buffer_length;
+	while (len && !status) {
+		bsize = min_t(u16, CSR_CACHE_SIZE, len);
+		status = rt2x00usb_vendor_req_buff_lock(rt2x00dev, request,
+						requesttype, off, tb,
+						bsize, timeout);
+
+		tb  += bsize;
+		len -= bsize;
+		off += bsize;
+	}
+
+	mutex_unlock(&rt2x00dev->usb_cache_mutex);
+
+	return status;
+}
+EXPORT_SYMBOL_GPL(rt2x00usb_vendor_request_larg_buff);
+
+
 /*
  * TX data handlers.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index aad794a..68229d5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -70,7 +70,7 @@
 /*
  * Cache size
  */
-#define CSR_CACHE_SIZE			8
+#define CSR_CACHE_SIZE			64
 #define CSR_CACHE_SIZE_FIRMWARE		64
 
 /*
@@ -172,6 +172,25 @@ int rt2x00usb_vendor_req_buff_lock(struct rt2x00_dev *rt2x00dev,
 				   const u16 buffer_length, const int timeout);
 
 /**
+ * rt2x00usb_vendor_request_larg_buff - Send register command to device (buffered)
+ * @rt2x00dev: Pointer to &struct rt2x00_dev
+ * @request: USB vendor command (See &enum rt2x00usb_vendor_request)
+ * @requesttype: Request type &USB_VENDOR_REQUEST_*
+ * @offset: Register start offset to perform action on
+ * @buffer: Buffer where information will be read/written to by device
+ * @buffer_length: Size of &buffer
+ * @timeout: Operation timeout
+ *
+ * This function is used to transfer register data in blocks larger
+ * then CSR_CACHE_SIZE. Use for firmware upload, keys and beacons.
+ */
+int rt2x00usb_vendor_request_larg_buff(struct rt2x00_dev *rt2x00dev,
+			     const u8 request, const u8 requesttype,
+			     const u16 offset, void *buffer,
+			     const u16 buffer_length, const int timeout);
+
+
+/**
  * rt2x00usb_vendor_request_sw - Send single register command to device
  * @rt2x00dev: Pointer to &struct rt2x00_dev
  * @request: USB vendor command (See &enum rt2x00usb_vendor_request)
-- 
1.5.6.1

