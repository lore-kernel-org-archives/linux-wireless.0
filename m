Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:14440 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbYGSODV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 10:03:21 -0400
Received: by nf-out-0910.google.com with SMTP id d3so250603nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2008 07:03:20 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 4/5] rt2x00: Large vendor requests for rt73usb firmware upload and beacons
Date: Sat, 19 Jul 2008 16:17:16 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	Iwo Mergler <iwo@call-direct.com.au>
References: <200807191615.22752.IvDoorn@gmail.com> <200807191616.13129.IvDoorn@gmail.com> <200807191616.54313.IvDoorn@gmail.com>
In-Reply-To: <200807191616.54313.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807191617.16820.IvDoorn@gmail.com> (sfid-20080719_160324_653593_6E479C84)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Iwo Mergler <iwo@call-direct.com.au>

Switches rt73usb to use large vendor requests for firmware
and beacons. This also fixes the garbled beacon bug.

Signed-off-by: Iwo Mergler <Iwo@call-direct.com.au>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00usb.h |    1 -
 drivers/net/wireless/rt2x00/rt73usb.c   |   40 +++++++------------------------
 2 files changed, 9 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index 8d5d427..ee3875f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -71,7 +71,6 @@
  * Cache size
  */
 #define CSR_CACHE_SIZE			64
-#define CSR_CACHE_SIZE_FIRMWARE		64
 
 /*
  * USB request types.
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 34c6ff2..26265c7 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -890,9 +890,6 @@ static int rt73usb_load_firmware(struct rt2x00_dev *rt2x00dev, void *data,
 	unsigned int i;
 	int status;
 	u32 reg;
-	char *ptr = data;
-	char *cache;
-	int buflen;
 
 	/*
 	 * Wait for stable hardware.
@@ -911,31 +908,12 @@ static int rt73usb_load_firmware(struct rt2x00_dev *rt2x00dev, void *data,
 
 	/*
 	 * Write firmware to device.
-	 * We setup a seperate cache for this action,
-	 * since we are going to write larger chunks of data
-	 * then normally used cache size.
 	 */
-	cache = kmalloc(CSR_CACHE_SIZE_FIRMWARE, GFP_KERNEL);
-	if (!cache) {
-		ERROR(rt2x00dev, "Failed to allocate firmware cache.\n");
-		return -ENOMEM;
-	}
-
-	for (i = 0; i < len; i += CSR_CACHE_SIZE_FIRMWARE) {
-		buflen = min_t(int, len - i, CSR_CACHE_SIZE_FIRMWARE);
-
-		memcpy(cache, ptr, buflen);
-
-		rt2x00usb_vendor_request(rt2x00dev, USB_MULTI_WRITE,
-					 USB_VENDOR_REQUEST_OUT,
-					 FIRMWARE_IMAGE_BASE + i, 0,
-					 cache, buflen,
-					 REGISTER_TIMEOUT32(buflen));
-
-		ptr += buflen;
-	}
-
-	kfree(cache);
+	rt2x00usb_vendor_request_large_buff(rt2x00dev, USB_MULTI_WRITE,
+					    USB_VENDOR_REQUEST_OUT,
+					    FIRMWARE_IMAGE_BASE,
+					    data, len,
+					    REGISTER_TIMEOUT32(len));
 
 	/*
 	 * Send firmware request to device to load firmware,
@@ -1374,10 +1352,10 @@ static void rt73usb_write_beacon(struct queue_entry *entry)
 	 * Write entire beacon with descriptor to register.
 	 */
 	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
-	rt2x00usb_vendor_request(rt2x00dev, USB_MULTI_WRITE,
-				 USB_VENDOR_REQUEST_OUT, beacon_base, 0,
-				 entry->skb->data, entry->skb->len,
-				 REGISTER_TIMEOUT32(entry->skb->len));
+	rt2x00usb_vendor_request_large_buff(rt2x00dev, USB_MULTI_WRITE,
+					    USB_VENDOR_REQUEST_OUT, beacon_base,
+					    entry->skb->data, entry->skb->len,
+					    REGISTER_TIMEOUT32(entry->skb->len));
 
 	/*
 	 * Clean up the beacon skb.
-- 
1.5.6.1

