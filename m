Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:52877 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758644AbYDURAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 13:00:11 -0400
Received: by fk-out-0910.google.com with SMTP id 19so2556605fkr.5
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2008 10:00:10 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 7/9] rt2x00: Add helper macros
Date: Mon, 21 Apr 2008 19:01:58 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200804211858.46659.IvDoorn@gmail.com>
In-Reply-To: <200804211858.46659.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804211901.59134.IvDoorn@gmail.com> (sfid-20080421_190106_252988_878451DD)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add some helper macro's to help determining the
the timeout for USB register access.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |    8 ++++----
 drivers/net/wireless/rt2x00/rt2x00usb.c |    2 +-
 drivers/net/wireless/rt2x00/rt2x00usb.h |   19 ++++++++++++++++---
 drivers/net/wireless/rt2x00/rt73usb.c   |   18 ++++++++----------
 4 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 0dac1f5..80b34d4 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -76,10 +76,10 @@ static inline void rt2500usb_register_multiread(struct rt2x00_dev *rt2x00dev,
 						const unsigned int offset,
 						void *value, const u16 length)
 {
-	int timeout = REGISTER_TIMEOUT * (length / sizeof(u16));
 	rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_READ,
 				      USB_VENDOR_REQUEST_IN, offset,
-				      value, length, timeout);
+				      value, length,
+				      REGISTER_TIMEOUT16(length));
 }
 
 static inline void rt2500usb_register_write(struct rt2x00_dev *rt2x00dev,
@@ -106,10 +106,10 @@ static inline void rt2500usb_register_multiwrite(struct rt2x00_dev *rt2x00dev,
 						 const unsigned int offset,
 						 void *value, const u16 length)
 {
-	int timeout = REGISTER_TIMEOUT * (length / sizeof(u16));
 	rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_WRITE,
 				      USB_VENDOR_REQUEST_OUT, offset,
-				      value, length, timeout);
+				      value, length,
+				      REGISTER_TIMEOUT16(length));
 }
 
 static u16 rt2500usb_bbp_check(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 47f96b3..98aafc2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -344,7 +344,7 @@ void rt2x00usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 	struct data_queue *queue;
 	unsigned int i;
 
-	rt2x00usb_vendor_request_sw(rt2x00dev, USB_RX_CONTROL, 0x0000, 0x0000,
+	rt2x00usb_vendor_request_sw(rt2x00dev, USB_RX_CONTROL, 0, 0,
 				    REGISTER_TIMEOUT);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index 11e5518..1efaaae 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -47,6 +47,20 @@
 #define REGISTER_TIMEOUT		500
 #define REGISTER_TIMEOUT_FIRMWARE	1000
 
+/**
+ * REGISTER_TIMEOUT16 - Determine the timeout for 16bit register access
+ * @__datalen: Data length
+ */
+#define REGISTER_TIMEOUT16(__datalen)	\
+	( REGISTER_TIMEOUT * ((__datalen) / sizeof(u16)) )
+
+/**
+ * REGISTER_TIMEOUT32 - Determine the timeout for 32bit register access
+ * @__datalen: Data length
+ */
+#define REGISTER_TIMEOUT32(__datalen)	\
+	( REGISTER_TIMEOUT * ((__datalen) / sizeof(u32)) )
+
 /*
  * Cache size
  */
@@ -187,11 +201,10 @@ static inline int rt2x00usb_vendor_request_sw(struct rt2x00_dev *rt2x00dev,
 static inline int rt2x00usb_eeprom_read(struct rt2x00_dev *rt2x00dev,
 					__le16 *eeprom, const u16 lenght)
 {
-	int timeout = REGISTER_TIMEOUT * (lenght / sizeof(u16));
-
 	return rt2x00usb_vendor_request(rt2x00dev, USB_EEPROM_READ,
 					USB_VENDOR_REQUEST_IN, 0, 0,
-					eeprom, lenght, timeout);
+					eeprom, lenght,
+					REGISTER_TIMEOUT16(lenght));
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index a6419c9..351d95c 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -74,10 +74,10 @@ static inline void rt73usb_register_multiread(struct rt2x00_dev *rt2x00dev,
 					      const unsigned int offset,
 					      void *value, const u32 length)
 {
-	int timeout = REGISTER_TIMEOUT * (length / sizeof(u32));
 	rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_READ,
 				      USB_VENDOR_REQUEST_IN, offset,
-				      value, length, timeout);
+				      value, length,
+				      REGISTER_TIMEOUT32(length));
 }
 
 static inline void rt73usb_register_write(struct rt2x00_dev *rt2x00dev,
@@ -102,10 +102,10 @@ static inline void rt73usb_register_multiwrite(struct rt2x00_dev *rt2x00dev,
 					       const unsigned int offset,
 					       void *value, const u32 length)
 {
-	int timeout = REGISTER_TIMEOUT * (length / sizeof(u32));
 	rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_WRITE,
 				      USB_VENDOR_REQUEST_OUT, offset,
-				      value, length, timeout);
+				      value, length,
+				      REGISTER_TIMEOUT32(length));
 }
 
 static u32 rt73usb_bbp_check(struct rt2x00_dev *rt2x00dev)
@@ -876,7 +876,6 @@ static int rt73usb_load_firmware(struct rt2x00_dev *rt2x00dev, void *data,
 	char *ptr = data;
 	char *cache;
 	int buflen;
-	int timeout;
 
 	/*
 	 * Wait for stable hardware.
@@ -907,14 +906,14 @@ static int rt73usb_load_firmware(struct rt2x00_dev *rt2x00dev, void *data,
 
 	for (i = 0; i < len; i += CSR_CACHE_SIZE_FIRMWARE) {
 		buflen = min_t(int, len - i, CSR_CACHE_SIZE_FIRMWARE);
-		timeout = REGISTER_TIMEOUT * (buflen / sizeof(u32));
 
 		memcpy(cache, ptr, buflen);
 
 		rt2x00usb_vendor_request(rt2x00dev, USB_MULTI_WRITE,
 					 USB_VENDOR_REQUEST_OUT,
 					 FIRMWARE_IMAGE_BASE + i, 0,
-					 cache, buflen, timeout);
+					 cache, buflen,
+					 REGISTER_TIMEOUT32(buflen));
 
 		ptr += buflen;
 	}
@@ -1966,7 +1965,6 @@ static int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct rt2x00_intf *intf = vif_to_intf(control->vif);
 	struct skb_frame_desc *skbdesc;
 	unsigned int beacon_base;
-	unsigned int timeout;
 	u32 reg;
 
 	if (unlikely(!intf->beacon))
@@ -2006,10 +2004,10 @@ static int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 */
 	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
 	beacon_base = HW_BEACON_OFFSET(intf->beacon->entry_idx);
-	timeout = REGISTER_TIMEOUT * (skb->len / sizeof(u32));
 	rt2x00usb_vendor_request(rt2x00dev, USB_MULTI_WRITE,
 				 USB_VENDOR_REQUEST_OUT, beacon_base, 0,
-				 skb->data, skb->len, timeout);
+				 skb->data, skb->len,
+				 REGISTER_TIMEOUT32(skb->len));
 	rt73usb_kick_tx_queue(rt2x00dev, QID_BEACON);
 
 	return 0;
-- 
1.5.4.5

