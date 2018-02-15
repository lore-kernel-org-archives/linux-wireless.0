Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:41794 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756495AbeBOW7x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Feb 2018 17:59:53 -0500
Received: by mail-wr0-f196.google.com with SMTP id f8so1259485wrh.8
        for <linux-wireless@vger.kernel.org>; Thu, 15 Feb 2018 14:59:52 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: kubakici@wp.pl
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mt7601u: make write with mask access atomic
Date: Thu, 15 Feb 2018 23:59:24 +0100
Message-Id: <5bb3bb069bdd4663b69b60b782432c2faddc1efc.1518734856.git.lorenzo.bianconi@redhat.com> (sfid-20180216_000001_040878_D54113A3)
In-Reply-To: <cover.1518734856.git.lorenzo.bianconi@redhat.com>
References: <cover.1518734856.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce __mt7601u_rr and __mt7601u_vendor_single_wr routines in order
to make mt7601u_rmw and mt7601u_rmc atomic since it is possible that
read and write accesses of mt7601u_rmw/mt7601u_rmc can be interleaved
with a different write operation on the same register.
Moreover move write trace point in __mt7601u_vendor_single_wr

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt7601u/mt7601u.h |  3 +-
 drivers/net/wireless/mediatek/mt7601u/usb.c     | 52 ++++++++++++++++++-------
 2 files changed, 39 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/mt7601u.h b/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
index c7ec40475a5f..9233744451a9 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
+++ b/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
@@ -147,7 +147,8 @@ enum {
  * @rx_lock:		protects @rx_q.
  * @con_mon_lock:	protects @ap_bssid, @bcn_*, @avg_rssi.
  * @mutex:		ensures exclusive access from mac80211 callbacks.
- * @vendor_req_mutex:	protects @vend_buf, ensures atomicity of split writes.
+ * @vendor_req_mutex:	protects @vend_buf, ensures atomicity of read/write
+ *			accesses
  * @reg_atomic_mutex:	ensures atomicity of indirect register accesses
  *			(accesses to RF and BBP).
  * @hw_atomic_mutex:	ensures exclusive access to HW during critical
diff --git a/drivers/net/wireless/mediatek/mt7601u/usb.c b/drivers/net/wireless/mediatek/mt7601u/usb.c
index b9e4f6793138..d8b7863f7926 100644
--- a/drivers/net/wireless/mediatek/mt7601u/usb.c
+++ b/drivers/net/wireless/mediatek/mt7601u/usb.c
@@ -129,15 +129,14 @@ void mt7601u_vendor_reset(struct mt7601u_dev *dev)
 			       MT_VEND_DEV_MODE_RESET, 0, NULL, 0);
 }
 
-u32 mt7601u_rr(struct mt7601u_dev *dev, u32 offset)
+/* should be called with vendor_req_mutex held */
+static u32 __mt7601u_rr(struct mt7601u_dev *dev, u32 offset)
 {
 	int ret;
 	u32 val = ~0;
 
 	WARN_ONCE(offset > USHRT_MAX, "read high off:%08x", offset);
 
-	mutex_lock(&dev->vendor_req_mutex);
-
 	ret = mt7601u_vendor_request(dev, MT_VEND_MULTI_READ, USB_DIR_IN,
 				     0, offset, dev->vend_buf, MT_VEND_BUF);
 	if (ret == MT_VEND_BUF)
@@ -146,25 +145,41 @@ u32 mt7601u_rr(struct mt7601u_dev *dev, u32 offset)
 		dev_err(dev->dev, "Error: wrong size read:%d off:%08x\n",
 			ret, offset);
 
-	mutex_unlock(&dev->vendor_req_mutex);
-
 	trace_reg_read(dev, offset, val);
 	return val;
 }
 
-int mt7601u_vendor_single_wr(struct mt7601u_dev *dev, const u8 req,
-			     const u16 offset, const u32 val)
+u32 mt7601u_rr(struct mt7601u_dev *dev, u32 offset)
 {
-	int ret;
+	u32 ret;
 
 	mutex_lock(&dev->vendor_req_mutex);
+	ret = __mt7601u_rr(dev, offset);
+	mutex_unlock(&dev->vendor_req_mutex);
 
-	ret = mt7601u_vendor_request(dev, req, USB_DIR_OUT,
-				     val & 0xffff, offset, NULL, 0);
+	return ret;
+}
+
+/* should be called with vendor_req_mutex held */
+static int __mt7601u_vendor_single_wr(struct mt7601u_dev *dev, const u8 req,
+				      const u16 offset, const u32 val)
+{
+	int ret = mt7601u_vendor_request(dev, req, USB_DIR_OUT,
+					 val & 0xffff, offset, NULL, 0);
 	if (!ret)
 		ret = mt7601u_vendor_request(dev, req, USB_DIR_OUT,
 					     val >> 16, offset + 2, NULL, 0);
+	trace_reg_write(dev, offset, val);
+	return ret;
+}
+
+int mt7601u_vendor_single_wr(struct mt7601u_dev *dev, const u8 req,
+			     const u16 offset, const u32 val)
+{
+	int ret;
 
+	mutex_lock(&dev->vendor_req_mutex);
+	ret = __mt7601u_vendor_single_wr(dev, req, offset, val);
 	mutex_unlock(&dev->vendor_req_mutex);
 
 	return ret;
@@ -175,23 +190,30 @@ void mt7601u_wr(struct mt7601u_dev *dev, u32 offset, u32 val)
 	WARN_ONCE(offset > USHRT_MAX, "write high off:%08x", offset);
 
 	mt7601u_vendor_single_wr(dev, MT_VEND_WRITE, offset, val);
-	trace_reg_write(dev, offset, val);
 }
 
 u32 mt7601u_rmw(struct mt7601u_dev *dev, u32 offset, u32 mask, u32 val)
 {
-	val |= mt7601u_rr(dev, offset) & ~mask;
-	mt7601u_wr(dev, offset, val);
+	mutex_lock(&dev->vendor_req_mutex);
+	val |= __mt7601u_rr(dev, offset) & ~mask;
+	__mt7601u_vendor_single_wr(dev, MT_VEND_WRITE, offset, val);
+	mutex_unlock(&dev->vendor_req_mutex);
+
 	return val;
 }
 
 u32 mt7601u_rmc(struct mt7601u_dev *dev, u32 offset, u32 mask, u32 val)
 {
-	u32 reg = mt7601u_rr(dev, offset);
+	u32 reg;
 
+	mutex_lock(&dev->vendor_req_mutex);
+	reg = __mt7601u_rr(dev, offset);
 	val |= reg & ~mask;
 	if (reg != val)
-		mt7601u_wr(dev, offset, val);
+		__mt7601u_vendor_single_wr(dev, MT_VEND_WRITE,
+					   offset, val);
+	mutex_unlock(&dev->vendor_req_mutex);
+
 	return val;
 }
 
-- 
2.14.3
