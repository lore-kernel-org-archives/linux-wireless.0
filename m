Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:4134 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759437Ab0EMTQK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 15:16:10 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 3/4] rt2x00: Clean up USB vendor request buffer functions.
Date: Thu, 13 May 2010 21:16:05 +0200
Message-Id: <1273778166-3833-4-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1273778166-3833-1-git-send-email-gwingerde@gmail.com>
References: <1273778166-3833-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need to force the separation between a buffer USB vendor
request that does fit the CSR cache and one that doesn't onto the
callers. This is something that the rt2x00usb_vendor_request_buff
function can figure out by itself.
Combine the rt2x00usb_vendor_request_buff and
rt2x00usb_vendor_request_large_buff functions into a single one, as
both of them were equivalent for small buffers anyway.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |   14 +-----------
 drivers/net/wireless/rt2x00/rt2800usb.c |   13 +++--------
 drivers/net/wireless/rt2x00/rt2x00usb.c |   22 +--------------------
 drivers/net/wireless/rt2x00/rt2x00usb.h |   19 ------------------
 drivers/net/wireless/rt2x00/rt73usb.c   |   32 ++++++------------------------
 5 files changed, 14 insertions(+), 86 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index eb99934..a1af5b8 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -344,7 +344,6 @@ static int rt2500usb_config_key(struct rt2x00_dev *rt2x00dev,
 				struct rt2x00lib_crypto *crypto,
 				struct ieee80211_key_conf *key)
 {
-	int timeout;
 	u32 mask;
 	u16 reg;
 
@@ -366,18 +365,9 @@ static int rt2500usb_config_key(struct rt2x00_dev *rt2x00dev,
 
 		key->hw_key_idx += reg ? ffz(reg) : 0;
 
-		/*
-		 * The encryption key doesn't fit within the CSR cache,
-		 * this means we should allocate it seperately and use
-		 * rt2x00usb_vendor_request() to send the key to the hardware.
-		 */
 		reg = KEY_ENTRY(key->hw_key_idx);
-		timeout = REGISTER_TIMEOUT32(sizeof(crypto->key));
-		rt2x00usb_vendor_request_large_buff(rt2x00dev, USB_MULTI_WRITE,
-						    USB_VENDOR_REQUEST_OUT, reg,
-						    crypto->key,
-						    sizeof(crypto->key),
-						    timeout);
+		rt2500usb_register_multiwrite(rt2x00dev, reg,
+					      crypto->key, sizeof(crypto->key));
 
 		/*
 		 * The driver does not support the IV/EIV generation
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index eaf0a7e..0f0a4f5 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -169,11 +169,8 @@ static int rt2800usb_load_firmware(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Write firmware to device.
 	 */
-	rt2x00usb_vendor_request_large_buff(rt2x00dev, USB_MULTI_WRITE,
-					    USB_VENDOR_REQUEST_OUT,
-					    FIRMWARE_IMAGE_BASE,
-					    data + offset, length,
-					    REGISTER_TIMEOUT32(length));
+	rt2800_register_multiwrite(rt2x00dev, FIRMWARE_IMAGE_BASE,
+				   data + offset, length);
 
 	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
 	rt2800_register_write(rt2x00dev, H2M_MAILBOX_STATUS, ~0);
@@ -478,10 +475,8 @@ static void rt2800usb_write_beacon(struct queue_entry *entry,
 	 * Write entire beacon with descriptor to register.
 	 */
 	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
-	rt2x00usb_vendor_request_large_buff(rt2x00dev, USB_MULTI_WRITE,
-					    USB_VENDOR_REQUEST_OUT, beacon_base,
-					    entry->skb->data, entry->skb->len,
-					    REGISTER_TIMEOUT32(entry->skb->len));
+	rt2800_register_multiwrite(rt2x00dev, beacon_base,
+				   entry->skb->data, entry->skb->len);
 
 	/*
 	 * Enable beaconing again.
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 1f72c59..1cae159 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -112,26 +112,6 @@ int rt2x00usb_vendor_request_buff(struct rt2x00_dev *rt2x00dev,
 				  const u16 offset, void *buffer,
 				  const u16 buffer_length, const int timeout)
 {
-	int status;
-
-	mutex_lock(&rt2x00dev->csr_mutex);
-
-	status = rt2x00usb_vendor_req_buff_lock(rt2x00dev, request,
-						requesttype, offset, buffer,
-						buffer_length, timeout);
-
-	mutex_unlock(&rt2x00dev->csr_mutex);
-
-	return status;
-}
-EXPORT_SYMBOL_GPL(rt2x00usb_vendor_request_buff);
-
-int rt2x00usb_vendor_request_large_buff(struct rt2x00_dev *rt2x00dev,
-					const u8 request, const u8 requesttype,
-					const u16 offset, const void *buffer,
-					const u16 buffer_length,
-					const int timeout)
-{
 	int status = 0;
 	unsigned char *tb;
 	u16 off, len, bsize;
@@ -156,7 +136,7 @@ int rt2x00usb_vendor_request_large_buff(struct rt2x00_dev *rt2x00dev,
 
 	return status;
 }
-EXPORT_SYMBOL_GPL(rt2x00usb_vendor_request_large_buff);
+EXPORT_SYMBOL_GPL(rt2x00usb_vendor_request_buff);
 
 int rt2x00usb_regbusy_read(struct rt2x00_dev *rt2x00dev,
 			   const unsigned int offset,
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index 621d0f8..255b81e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -167,25 +167,6 @@ int rt2x00usb_vendor_req_buff_lock(struct rt2x00_dev *rt2x00dev,
 				   const u16 buffer_length, const int timeout);
 
 /**
- * rt2x00usb_vendor_request_large_buff - Send register command to device (buffered)
- * @rt2x00dev: Pointer to &struct rt2x00_dev
- * @request: USB vendor command (See &enum rt2x00usb_vendor_request)
- * @requesttype: Request type &USB_VENDOR_REQUEST_*
- * @offset: Register start offset to perform action on
- * @buffer: Buffer where information will be read/written to by device
- * @buffer_length: Size of &buffer
- * @timeout: Operation timeout
- *
- * This function is used to transfer register data in blocks larger
- * then CSR_CACHE_SIZE. Use for firmware upload, keys and beacons.
- */
-int rt2x00usb_vendor_request_large_buff(struct rt2x00_dev *rt2x00dev,
-					const u8 request, const u8 requesttype,
-					const u16 offset, const void *buffer,
-					const u16 buffer_length,
-					const int timeout);
-
-/**
  * rt2x00usb_vendor_request_sw - Send single register command to device
  * @rt2x00dev: Pointer to &struct rt2x00_dev
  * @request: USB vendor command (See &enum rt2x00usb_vendor_request)
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index dc4a028..2f7e0ce 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -269,7 +269,6 @@ static int rt73usb_config_shared_key(struct rt2x00_dev *rt2x00dev,
 {
 	struct hw_key_entry key_entry;
 	struct rt2x00_field32 field;
-	int timeout;
 	u32 mask;
 	u32 reg;
 
@@ -305,12 +304,8 @@ static int rt73usb_config_shared_key(struct rt2x00_dev *rt2x00dev,
 		       sizeof(key_entry.rx_mic));
 
 		reg = SHARED_KEY_ENTRY(key->hw_key_idx);
-		timeout = REGISTER_TIMEOUT32(sizeof(key_entry));
-		rt2x00usb_vendor_request_large_buff(rt2x00dev, USB_MULTI_WRITE,
-						    USB_VENDOR_REQUEST_OUT, reg,
-						    &key_entry,
-						    sizeof(key_entry),
-						    timeout);
+		rt2x00usb_register_multiwrite(rt2x00dev, reg,
+					      &key_entry, sizeof(key_entry));
 
 		/*
 		 * The cipher types are stored over 2 registers.
@@ -371,7 +366,6 @@ static int rt73usb_config_pairwise_key(struct rt2x00_dev *rt2x00dev,
 {
 	struct hw_pairwise_ta_entry addr_entry;
 	struct hw_key_entry key_entry;
-	int timeout;
 	u32 mask;
 	u32 reg;
 
@@ -406,17 +400,11 @@ static int rt73usb_config_pairwise_key(struct rt2x00_dev *rt2x00dev,
 		       sizeof(key_entry.rx_mic));
 
 		reg = PAIRWISE_KEY_ENTRY(key->hw_key_idx);
-		timeout = REGISTER_TIMEOUT32(sizeof(key_entry));
-		rt2x00usb_vendor_request_large_buff(rt2x00dev, USB_MULTI_WRITE,
-						    USB_VENDOR_REQUEST_OUT, reg,
-						    &key_entry,
-						    sizeof(key_entry),
-						    timeout);
+		rt2x00usb_register_multiwrite(rt2x00dev, reg,
+					      &key_entry, sizeof(key_entry));
 
 		/*
 		 * Send the address and cipher type to the hardware register.
-		 * This data fits within the CSR cache size, so we can use
-		 * rt2x00usb_register_multiwrite() directly.
 		 */
 		memset(&addr_entry, 0, sizeof(addr_entry));
 		memcpy(&addr_entry, crypto->address, ETH_ALEN);
@@ -1091,11 +1079,7 @@ static int rt73usb_load_firmware(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Write firmware to device.
 	 */
-	rt2x00usb_vendor_request_large_buff(rt2x00dev, USB_MULTI_WRITE,
-					    USB_VENDOR_REQUEST_OUT,
-					    FIRMWARE_IMAGE_BASE,
-					    data, len,
-					    REGISTER_TIMEOUT32(len));
+	rt2x00usb_register_multiwrite(rt2x00dev, FIRMWARE_IMAGE_BASE, data, len);
 
 	/*
 	 * Send firmware request to device to load firmware,
@@ -1547,10 +1531,8 @@ static void rt73usb_write_beacon(struct queue_entry *entry,
 	 * Write entire beacon with descriptor to register.
 	 */
 	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
-	rt2x00usb_vendor_request_large_buff(rt2x00dev, USB_MULTI_WRITE,
-					    USB_VENDOR_REQUEST_OUT, beacon_base,
-					    entry->skb->data, entry->skb->len,
-					    REGISTER_TIMEOUT32(entry->skb->len));
+	rt2x00usb_register_multiwrite(rt2x00dev, beacon_base,
+				      entry->skb->data, entry->skb->len);
 
 	/*
 	 * Enable beaconing again.
-- 
1.7.1

