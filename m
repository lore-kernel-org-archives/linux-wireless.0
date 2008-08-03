Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:5117 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbYHCOeM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 10:34:12 -0400
Received: by nf-out-0910.google.com with SMTP id d3so606658nfc.21
        for <linux-wireless@vger.kernel.org>; Sun, 03 Aug 2008 07:34:11 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Disable link tuning in rt2500usb
Date: Sun, 3 Aug 2008 16:57:27 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808031657.27710.IvDoorn@gmail.com> (sfid-20080803_163427_217562_8941B06F)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
John, please queue for 2.6.27 this fixes rt2500usb. :)

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
+ * in TX capabilities only untill association kicks in. Immediately
+ * after the successfull association all TX frames will be kept in the
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

