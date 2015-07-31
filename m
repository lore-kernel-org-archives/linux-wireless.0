Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.9]:39380 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbbGaNE4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 09:04:56 -0400
From: Jakub Kicinski <moorray3@wp.pl>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCH -next 1/4] mt7601u: fix dma from stack address
Date: Fri, 31 Jul 2015 15:04:46 +0200
Message-Id: <1438347889-14669-1-git-send-email-moorray3@wp.pl> (sfid-20150731_150502_234228_BB33D954)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jakub Kicinski <kubakici@wp.pl>

DMA to variables located on the stack is a bad idea.
For simplicity and to avoid frequent allocations create
a buffer inside the device structure.  Protect this
buffer with vendor_req_mutex.  Don't protect vendor
requests which don't use this buffer.

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
---
 drivers/net/wireless/mediatek/mt7601u/mt7601u.h |  4 +-
 drivers/net/wireless/mediatek/mt7601u/usb.c     | 63 ++++++++++++-------------
 drivers/net/wireless/mediatek/mt7601u/usb.h     |  2 +
 3 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/mt7601u.h b/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
index 9102be6b95cb..6bdfc1103fcc 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
+++ b/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
@@ -146,7 +146,7 @@ enum {
  * @rx_lock:		protects @rx_q.
  * @con_mon_lock:	protects @ap_bssid, @bcn_*, @avg_rssi.
  * @mutex:		ensures exclusive access from mac80211 callbacks.
- * @vendor_req_mutex:	ensures atomicity of vendor requests.
+ * @vendor_req_mutex:	protects @vend_buf, ensures atomicity of split writes.
  * @reg_atomic_mutex:	ensures atomicity of indirect register accesses
  *			(accesses to RF and BBP).
  * @hw_atomic_mutex:	ensures exclusive access to HW during critical
@@ -184,6 +184,8 @@ struct mt7601u_dev {
 	struct mt7601u_eeprom_params *ee;
 
 	struct mutex vendor_req_mutex;
+	void *vend_buf;
+
 	struct mutex reg_atomic_mutex;
 	struct mutex hw_atomic_mutex;
 
diff --git a/drivers/net/wireless/mediatek/mt7601u/usb.c b/drivers/net/wireless/mediatek/mt7601u/usb.c
index 54dba4001865..416c6045ff31 100644
--- a/drivers/net/wireless/mediatek/mt7601u/usb.c
+++ b/drivers/net/wireless/mediatek/mt7601u/usb.c
@@ -92,10 +92,9 @@ void mt7601u_complete_urb(struct urb *urb)
 	complete(cmpl);
 }
 
-static int
-__mt7601u_vendor_request(struct mt7601u_dev *dev, const u8 req,
-			 const u8 direction, const u16 val, const u16 offset,
-			 void *buf, const size_t buflen)
+int mt7601u_vendor_request(struct mt7601u_dev *dev, const u8 req,
+			   const u8 direction, const u16 val, const u16 offset,
+			   void *buf, const size_t buflen)
 {
 	int i, ret;
 	struct usb_device *usb_dev = mt7601u_to_usb_dev(dev);
@@ -110,6 +109,8 @@ __mt7601u_vendor_request(struct mt7601u_dev *dev, const u8 req,
 		trace_mt_vend_req(dev, pipe, req, req_type, val, offset,
 				  buf, buflen, ret);
 
+		if (ret == -ENODEV)
+			set_bit(MT7601U_STATE_REMOVED, &dev->state);
 		if (ret >= 0 || ret == -ENODEV)
 			return ret;
 
@@ -122,25 +123,6 @@ __mt7601u_vendor_request(struct mt7601u_dev *dev, const u8 req,
 	return ret;
 }
 
-int
-mt7601u_vendor_request(struct mt7601u_dev *dev, const u8 req,
-		       const u8 direction, const u16 val, const u16 offset,
-		       void *buf, const size_t buflen)
-{
-	int ret;
-
-	mutex_lock(&dev->vendor_req_mutex);
-
-	ret = __mt7601u_vendor_request(dev, req, direction, val, offset,
-				       buf, buflen);
-	if (ret == -ENODEV)
-		set_bit(MT7601U_STATE_REMOVED, &dev->state);
-
-	mutex_unlock(&dev->vendor_req_mutex);
-
-	return ret;
-}
-
 void mt7601u_vendor_reset(struct mt7601u_dev *dev)
 {
 	mt7601u_vendor_request(dev, MT_VEND_DEV_MODE, USB_DIR_OUT,
@@ -150,19 +132,21 @@ void mt7601u_vendor_reset(struct mt7601u_dev *dev)
 u32 mt7601u_rr(struct mt7601u_dev *dev, u32 offset)
 {
 	int ret;
-	__le32 reg;
-	u32 val;
+	u32 val = ~0;
 
 	WARN_ONCE(offset > USHRT_MAX, "read high off:%08x", offset);
 
+	mutex_lock(&dev->vendor_req_mutex);
+
 	ret = mt7601u_vendor_request(dev, MT_VEND_MULTI_READ, USB_DIR_IN,
-				     0, offset, &reg, sizeof(reg));
-	val = le32_to_cpu(reg);
-	if (ret > 0 && ret != sizeof(reg)) {
+				     0, offset, dev->vend_buf, MT_VEND_BUF);
+	if (ret == MT_VEND_BUF)
+		val = get_unaligned_le32(dev->vend_buf);
+	else if (ret > 0)
 		dev_err(dev->dev, "Error: wrong size read:%d off:%08x\n",
 			ret, offset);
-		val = ~0;
-	}
+
+	mutex_unlock(&dev->vendor_req_mutex);
 
 	trace_reg_read(dev, offset, val);
 	return val;
@@ -173,12 +157,17 @@ int mt7601u_vendor_single_wr(struct mt7601u_dev *dev, const u8 req,
 {
 	int ret;
 
+	mutex_lock(&dev->vendor_req_mutex);
+
 	ret = mt7601u_vendor_request(dev, req, USB_DIR_OUT,
 				     val & 0xffff, offset, NULL, 0);
-	if (ret)
-		return ret;
-	return mt7601u_vendor_request(dev, req, USB_DIR_OUT,
-				      val >> 16, offset + 2, NULL, 0);
+	if (!ret)
+		ret = mt7601u_vendor_request(dev, req, USB_DIR_OUT,
+					     val >> 16, offset + 2, NULL, 0);
+
+	mutex_unlock(&dev->vendor_req_mutex);
+
+	return ret;
 }
 
 void mt7601u_wr(struct mt7601u_dev *dev, u32 offset, u32 val)
@@ -275,6 +264,12 @@ static int mt7601u_probe(struct usb_interface *usb_intf,
 
 	usb_set_intfdata(usb_intf, dev);
 
+	dev->vend_buf = devm_kmalloc(dev->dev, MT_VEND_BUF, GFP_KERNEL);
+	if (!dev->vend_buf) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
 	ret = mt7601u_assign_pipes(usb_intf, dev);
 	if (ret)
 		goto err;
diff --git a/drivers/net/wireless/mediatek/mt7601u/usb.h b/drivers/net/wireless/mediatek/mt7601u/usb.h
index 49e188fa3798..bc182022b9d6 100644
--- a/drivers/net/wireless/mediatek/mt7601u/usb.h
+++ b/drivers/net/wireless/mediatek/mt7601u/usb.h
@@ -23,6 +23,8 @@
 
 #define MT_VEND_DEV_MODE_RESET	1
 
+#define MT_VEND_BUF		sizeof(__le32)
+
 enum mt_vendor_req {
 	MT_VEND_DEV_MODE = 1,
 	MT_VEND_WRITE = 2,
-- 
2.1.0

