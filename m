Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:34321 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbYFTTxa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 15:53:30 -0400
Received: by rv-out-0506.google.com with SMTP id k40so5796976rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 20 Jun 2008 12:53:29 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Fix unbalanced mutex locking
Date: Fri, 20 Jun 2008 22:11:00 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806202211.01632.IvDoorn@gmail.com> (sfid-20080620_215334_768793_D56BE2E9)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The usb_cache_mutex was not correctly released
under all circumstances. Both rt73usb as rt2500usb
didn't release the mutex under certain conditions
when the register access failed. Obviously such
failure would lead to deadlocks.

In addition under similar circumstances when the
bbp register couldn't be read the value must be
set to 0xff to indicate that the value is wrong.
This too didn't happen under all circumstances.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---

John, please queue this patch for 2.6.26 and 2.6.27

 drivers/net/wireless/rt2x00/rt2500usb.c |   36 ++++++++++++++++++-------------
 drivers/net/wireless/rt2x00/rt73usb.c   |   36 ++++++++++++++++++-------------
 2 files changed, 42 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index d095800..0dd1cb5 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -138,11 +138,8 @@ static void rt2500usb_bbp_write(struct rt2x00_dev *rt2x00dev,
 	 * Wait until the BBP becomes ready.
 	 */
 	reg = rt2500usb_bbp_check(rt2x00dev);
-	if (rt2x00_get_field16(reg, PHY_CSR8_BUSY)) {
-		ERROR(rt2x00dev, "PHY_CSR8 register busy. Write failed.\n");
-		mutex_unlock(&rt2x00dev->usb_cache_mutex);
-		return;
-	}
+	if (rt2x00_get_field16(reg, PHY_CSR8_BUSY))
+		goto exit_fail;
 
 	/*
 	 * Write the data into the BBP.
@@ -155,6 +152,13 @@ static void rt2500usb_bbp_write(struct rt2x00_dev *rt2x00dev,
 	rt2500usb_register_write_lock(rt2x00dev, PHY_CSR7, reg);
 
 	mutex_unlock(&rt2x00dev->usb_cache_mutex);
+
+	return;
+
+exit_fail:
+	mutex_unlock(&rt2x00dev->usb_cache_mutex);
+
+	ERROR(rt2x00dev, "PHY_CSR8 register busy. Write failed.\n");
 }
 
 static void rt2500usb_bbp_read(struct rt2x00_dev *rt2x00dev,
@@ -168,10 +172,8 @@ static void rt2500usb_bbp_read(struct rt2x00_dev *rt2x00dev,
 	 * Wait until the BBP becomes ready.
 	 */
 	reg = rt2500usb_bbp_check(rt2x00dev);
-	if (rt2x00_get_field16(reg, PHY_CSR8_BUSY)) {
-		ERROR(rt2x00dev, "PHY_CSR8 register busy. Read failed.\n");
-		return;
-	}
+	if (rt2x00_get_field16(reg, PHY_CSR8_BUSY))
+		goto exit_fail;
 
 	/*
 	 * Write the request into the BBP.
@@ -186,17 +188,21 @@ static void rt2500usb_bbp_read(struct rt2x00_dev *rt2x00dev,
 	 * Wait until the BBP becomes ready.
 	 */
 	reg = rt2500usb_bbp_check(rt2x00dev);
-	if (rt2x00_get_field16(reg, PHY_CSR8_BUSY)) {
-		ERROR(rt2x00dev, "PHY_CSR8 register busy. Read failed.\n");
-		*value = 0xff;
-		mutex_unlock(&rt2x00dev->usb_cache_mutex);
-		return;
-	}
+	if (rt2x00_get_field16(reg, PHY_CSR8_BUSY))
+		goto exit_fail;
 
 	rt2500usb_register_read_lock(rt2x00dev, PHY_CSR7, &reg);
 	*value = rt2x00_get_field16(reg, PHY_CSR7_DATA);
 
 	mutex_unlock(&rt2x00dev->usb_cache_mutex);
+
+	return;
+
+exit_fail:
+	mutex_unlock(&rt2x00dev->usb_cache_mutex);
+
+	ERROR(rt2x00dev, "PHY_CSR8 register busy. Read failed.\n");
+	*value = 0xff;
 }
 
 static void rt2500usb_rf_write(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index ead6db0..3ef318e 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -134,11 +134,8 @@ static void rt73usb_bbp_write(struct rt2x00_dev *rt2x00dev,
 	 * Wait until the BBP becomes ready.
 	 */
 	reg = rt73usb_bbp_check(rt2x00dev);
-	if (rt2x00_get_field32(reg, PHY_CSR3_BUSY)) {
-		ERROR(rt2x00dev, "PHY_CSR3 register busy. Write failed.\n");
-		mutex_unlock(&rt2x00dev->usb_cache_mutex);
-		return;
-	}
+	if (rt2x00_get_field32(reg, PHY_CSR3_BUSY))
+		goto exit_fail;
 
 	/*
 	 * Write the data into the BBP.
@@ -151,6 +148,13 @@ static void rt73usb_bbp_write(struct rt2x00_dev *rt2x00dev,
 
 	rt73usb_register_write_lock(rt2x00dev, PHY_CSR3, reg);
 	mutex_unlock(&rt2x00dev->usb_cache_mutex);
+
+	return;
+
+exit_fail:
+	mutex_unlock(&rt2x00dev->usb_cache_mutex);
+
+	ERROR(rt2x00dev, "PHY_CSR3 register busy. Write failed.\n");
 }
 
 static void rt73usb_bbp_read(struct rt2x00_dev *rt2x00dev,
@@ -164,11 +168,8 @@ static void rt73usb_bbp_read(struct rt2x00_dev *rt2x00dev,
 	 * Wait until the BBP becomes ready.
 	 */
 	reg = rt73usb_bbp_check(rt2x00dev);
-	if (rt2x00_get_field32(reg, PHY_CSR3_BUSY)) {
-		ERROR(rt2x00dev, "PHY_CSR3 register busy. Read failed.\n");
-		mutex_unlock(&rt2x00dev->usb_cache_mutex);
-		return;
-	}
+	if (rt2x00_get_field32(reg, PHY_CSR3_BUSY))
+		goto exit_fail;
 
 	/*
 	 * Write the request into the BBP.
@@ -184,14 +185,19 @@ static void rt73usb_bbp_read(struct rt2x00_dev *rt2x00dev,
 	 * Wait until the BBP becomes ready.
 	 */
 	reg = rt73usb_bbp_check(rt2x00dev);
-	if (rt2x00_get_field32(reg, PHY_CSR3_BUSY)) {
-		ERROR(rt2x00dev, "PHY_CSR3 register busy. Read failed.\n");
-		*value = 0xff;
-		return;
-	}
+	if (rt2x00_get_field32(reg, PHY_CSR3_BUSY))
+		goto exit_fail;
 
 	*value = rt2x00_get_field32(reg, PHY_CSR3_VALUE);
 	mutex_unlock(&rt2x00dev->usb_cache_mutex);
+
+	return;
+
+exit_fail:
+	mutex_unlock(&rt2x00dev->usb_cache_mutex);
+
+	ERROR(rt2x00dev, "PHY_CSR3 register busy. Read failed.\n");
+	*value = 0xff;
 }
 
 static void rt73usb_rf_write(struct rt2x00_dev *rt2x00dev,
-- 
1.5.5.4

