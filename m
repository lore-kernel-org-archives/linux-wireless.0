Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:37442 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab1BLSns (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Feb 2011 13:43:48 -0500
Subject: [PATCH 3/4] zd1211rw: move async iowrite16v up to callers
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Sat, 12 Feb 2011 20:43:42 +0200
Message-ID: <20110212184342.2062.34436.stgit@fate.lan>
In-Reply-To: <20110212184254.2062.33710.stgit@fate.lan>
References: <20110212184254.2062.33710.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Writing beacon to device happen through multiple write command calls.
zd_usb_iowrite16v uses synchronous urb call and with multiple write
commands in row causes high CPU usage.

Make asynchronous zd_usb_iowrite16v_async available outside zd_usb.c
and use where possible.

This lower CPU usage from ~10% to ~2% on Intel Atom when running
AP-mode with 100 TU beacon interval.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_chip.c |   35 +++++++++++++++++++++++++------
 drivers/net/wireless/zd1211rw/zd_usb.c  |   11 ++++------
 drivers/net/wireless/zd1211rw/zd_usb.h  |    4 ++++
 3 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index 54f68f1..a73a305 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -142,8 +142,9 @@ int zd_ioread32v_locked(struct zd_chip *chip, u32 *values, const zd_addr_t *addr
 	return 0;
 }
 
-int _zd_iowrite32v_locked(struct zd_chip *chip, const struct zd_ioreq32 *ioreqs,
-	           unsigned int count)
+static int _zd_iowrite32v_async_locked(struct zd_chip *chip,
+				       const struct zd_ioreq32 *ioreqs,
+				       unsigned int count)
 {
 	int i, j, r;
 	struct zd_ioreq16 ioreqs16[USB_MAX_IOWRITE32_COUNT * 2];
@@ -170,7 +171,7 @@ int _zd_iowrite32v_locked(struct zd_chip *chip, const struct zd_ioreq32 *ioreqs,
 		ioreqs16[j+1].addr  = ioreqs[i].addr;
 	}
 
-	r = zd_usb_iowrite16v(&chip->usb, ioreqs16, count16);
+	r = zd_usb_iowrite16v_async(&chip->usb, ioreqs16, count16);
 #ifdef DEBUG
 	if (r) {
 		dev_dbg_f(zd_chip_dev(chip),
@@ -180,6 +181,20 @@ int _zd_iowrite32v_locked(struct zd_chip *chip, const struct zd_ioreq32 *ioreqs,
 	return r;
 }
 
+int _zd_iowrite32v_locked(struct zd_chip *chip, const struct zd_ioreq32 *ioreqs,
+			  unsigned int count)
+{
+	int r;
+
+	zd_usb_iowrite16v_async_start(&chip->usb);
+	r = _zd_iowrite32v_async_locked(chip, ioreqs, count);
+	if (r) {
+		zd_usb_iowrite16v_async_end(&chip->usb, 0);
+		return r;
+	}
+	return zd_usb_iowrite16v_async_end(&chip->usb, 50 /* ms */);
+}
+
 int zd_iowrite16a_locked(struct zd_chip *chip,
                   const struct zd_ioreq16 *ioreqs, unsigned int count)
 {
@@ -187,6 +202,8 @@ int zd_iowrite16a_locked(struct zd_chip *chip,
 	unsigned int i, j, t, max;
 
 	ZD_ASSERT(mutex_is_locked(&chip->mutex));
+	zd_usb_iowrite16v_async_start(&chip->usb);
+
 	for (i = 0; i < count; i += j + t) {
 		t = 0;
 		max = count-i;
@@ -199,8 +216,9 @@ int zd_iowrite16a_locked(struct zd_chip *chip,
 			}
 		}
 
-		r = zd_usb_iowrite16v(&chip->usb, &ioreqs[i], j);
+		r = zd_usb_iowrite16v_async(&chip->usb, &ioreqs[i], j);
 		if (r) {
+			zd_usb_iowrite16v_async_end(&chip->usb, 0);
 			dev_dbg_f(zd_chip_dev(chip),
 				  "error zd_usb_iowrite16v. Error number %d\n",
 				  r);
@@ -208,7 +226,7 @@ int zd_iowrite16a_locked(struct zd_chip *chip,
 		}
 	}
 
-	return 0;
+	return zd_usb_iowrite16v_async_end(&chip->usb, 50 /* ms */);
 }
 
 /* Writes a variable number of 32 bit registers. The functions will split
@@ -221,6 +239,8 @@ int zd_iowrite32a_locked(struct zd_chip *chip,
 	int r;
 	unsigned int i, j, t, max;
 
+	zd_usb_iowrite16v_async_start(&chip->usb);
+
 	for (i = 0; i < count; i += j + t) {
 		t = 0;
 		max = count-i;
@@ -233,8 +253,9 @@ int zd_iowrite32a_locked(struct zd_chip *chip,
 			}
 		}
 
-		r = _zd_iowrite32v_locked(chip, &ioreqs[i], j);
+		r = _zd_iowrite32v_async_locked(chip, &ioreqs[i], j);
 		if (r) {
+			zd_usb_iowrite16v_async_end(&chip->usb, 0);
 			dev_dbg_f(zd_chip_dev(chip),
 				"error _zd_iowrite32v_locked."
 				" Error number %d\n", r);
@@ -242,7 +263,7 @@ int zd_iowrite32a_locked(struct zd_chip *chip,
 		}
 	}
 
-	return 0;
+	return zd_usb_iowrite16v_async_end(&chip->usb, 50 /* ms */);
 }
 
 int zd_ioread16(struct zd_chip *chip, zd_addr_t addr, u16 *value)
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index c98f6e7..81e8048 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -1674,7 +1674,7 @@ static void iowrite16v_urb_complete(struct urb *urb)
 
 static int zd_submit_waiting_urb(struct zd_usb *usb, bool last)
 {
-	int r;
+	int r = 0;
 	struct urb *urb = usb->urb_async_waiting;
 
 	if (!urb)
@@ -1700,7 +1700,7 @@ error:
 	return r;
 }
 
-static void zd_usb_iowrite16v_async_start(struct zd_usb *usb)
+void zd_usb_iowrite16v_async_start(struct zd_usb *usb)
 {
 	ZD_ASSERT(usb_anchor_empty(&usb->submitted_cmds));
 	ZD_ASSERT(usb->urb_async_waiting == NULL);
@@ -1713,7 +1713,7 @@ static void zd_usb_iowrite16v_async_start(struct zd_usb *usb)
 	usb->urb_async_waiting = NULL;
 }
 
-static int zd_usb_iowrite16v_async_end(struct zd_usb *usb, unsigned int timeout)
+int zd_usb_iowrite16v_async_end(struct zd_usb *usb, unsigned int timeout)
 {
 	int r;
 
@@ -1749,9 +1749,8 @@ error:
 	return r;
 }
 
-static int zd_usb_iowrite16v_async(struct zd_usb *usb,
-				   const struct zd_ioreq16 *ioreqs,
-				   unsigned int count)
+int zd_usb_iowrite16v_async(struct zd_usb *usb, const struct zd_ioreq16 *ioreqs,
+			    unsigned int count)
 {
 	int r;
 	struct usb_device *udev;
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.h b/drivers/net/wireless/zd1211rw/zd_usb.h
index 9291426..b3df2c8 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.h
+++ b/drivers/net/wireless/zd1211rw/zd_usb.h
@@ -273,6 +273,10 @@ static inline int zd_usb_ioread16(struct zd_usb *usb, u16 *value,
 	return zd_usb_ioread16v(usb, value, (const zd_addr_t *)&addr, 1);
 }
 
+void zd_usb_iowrite16v_async_start(struct zd_usb *usb);
+int zd_usb_iowrite16v_async_end(struct zd_usb *usb, unsigned int timeout);
+int zd_usb_iowrite16v_async(struct zd_usb *usb, const struct zd_ioreq16 *ioreqs,
+			    unsigned int count);
 int zd_usb_iowrite16v(struct zd_usb *usb, const struct zd_ioreq16 *ioreqs,
 	              unsigned int count);
 

