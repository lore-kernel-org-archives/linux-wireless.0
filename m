Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:39253 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345AbYHCVMV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 17:12:21 -0400
Received: by nf-out-0910.google.com with SMTP id d3so631473nfc.21
        for <linux-wireless@vger.kernel.org>; Sun, 03 Aug 2008 14:12:19 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2] rt2x00: Disable link tuning in rt2500usb
Date: Sun, 3 Aug 2008 23:36:01 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	"Stefanik =?utf-8?q?G=C3=A1bor?=" <netrolller.3d@gmail.com>
References: <200808031657.27710.IvDoorn@gmail.com>
In-Reply-To: <200808031657.27710.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808032336.01359.IvDoorn@gmail.com> (sfid-20080803_231224_384209_322C6080)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 921724b82bebfbfe4b4f70940bba748923738cb4 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sun, 3 Aug 2008 15:34:53 +0200
Subject: [PATCH] rt2x00: Disable link tuning in rt2500usb

In the legacy rt2570 driver the link tuner was never
really called. And now the reason has finally become
apparent: It breaks TX capabilities

As soon as the device has been associated all following
TX frames will be queued in the hardware and never transmitted
to the air. Disabling sections of the link tuner did not
have the expected result, but completely disabling the
link tuner did have the right result (Both of my rt2570 devices
came back to life).

This should fix Fedora bug: 411481

v2: Fix typos

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index c6f6eb6..5e6383d 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -633,6 +633,16 @@ static void rt2500usb_reset_tuner(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->link.vgc_level = value;
 }
 
+/*
+ * NOTE: This function is directly ported from legacy driver, but
+ * despite it being declared it was never called. Although link tuning
+ * sounds like a good idea, and usually works well for the other drivers,
+ * it does _not_ work with rt2500usb. Enabling this function will result
+ * in TX capabilities only until association kicks in. Immediately
+ * after the successful association all TX frames will be kept in the
+ * hardware queue and never transmitted.
+ */
+#if 0
 static void rt2500usb_link_tuner(struct rt2x00_dev *rt2x00dev)
 {
 	int rssi = rt2x00_get_link_rssi(&rt2x00dev->link);
@@ -752,6 +762,9 @@ dynamic_cca_tune:
 		rt2x00dev->link.vgc_level = r17;
 	}
 }
+#else
+#define rt2500usb_link_tuner	NULL
+#endif
 
 /*
  * Initialization functions.
@@ -1737,6 +1750,7 @@ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	__set_bit(DRIVER_REQUIRE_ATIM_QUEUE, &rt2x00dev->flags);
 	__set_bit(DRIVER_REQUIRE_BEACON_GUARD, &rt2x00dev->flags);
 	__set_bit(DRIVER_REQUIRE_SCHEDULED, &rt2x00dev->flags);
+	__set_bit(CONFIG_DISABLE_LINK_TUNING, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
-- 
1.5.6.1

