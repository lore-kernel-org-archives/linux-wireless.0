Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 220-135-115-6.HINET-IP.hinet.net ([220.135.115.6]:51885 "EHLO
	ns.kevlo.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab3JXFrQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Oct 2013 01:47:16 -0400
Date: Thu, 24 Oct 2013 13:24:08 +0800
From: Kevin Lo <kevlo@kevlo.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: [PATCH] rt2x00: rt2800lib: update RF registers for RT5390
Message-ID: <20131024052408.GA7828@ns.kevlo.org> (sfid-20131024_074719_644874_0AEC96F2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mirror the latest MediaTek/Ralink driver with respect to RT5390 RF register
programming.  The PCI and USB devices use different init values.

Signed-off-by: Kevin Lo <kevlo@kevlo.org>
---

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index c5738f1..2c4e436 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -6453,7 +6453,7 @@ static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 7, 0x00);
 	rt2800_rfcsr_write(rt2x00dev, 10, 0x53);
 	rt2800_rfcsr_write(rt2x00dev, 11, 0x4a);
-	rt2800_rfcsr_write(rt2x00dev, 12, 0xc6);
+	rt2800_rfcsr_write(rt2x00dev, 12, 0x46);
 	rt2800_rfcsr_write(rt2x00dev, 13, 0x9f);
 	rt2800_rfcsr_write(rt2x00dev, 14, 0x00);
 	rt2800_rfcsr_write(rt2x00dev, 15, 0x00);
@@ -6466,7 +6466,8 @@ static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 22, 0x20);
 	rt2800_rfcsr_write(rt2x00dev, 23, 0x00);
 	rt2800_rfcsr_write(rt2x00dev, 24, 0x00);
-	if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
+	if (rt2x00_is_usb(rt2x00dev) &&
+	    rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
 		rt2800_rfcsr_write(rt2x00dev, 25, 0x80);
 	else
 		rt2800_rfcsr_write(rt2x00dev, 25, 0xc0);
@@ -6486,10 +6487,7 @@ static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 38, 0x85);
 	rt2800_rfcsr_write(rt2x00dev, 39, 0x1b);
 
-	if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
-		rt2800_rfcsr_write(rt2x00dev, 40, 0x0b);
-	else
-		rt2800_rfcsr_write(rt2x00dev, 40, 0x4b);
+	rt2800_rfcsr_write(rt2x00dev, 40, 0x0b);
 	rt2800_rfcsr_write(rt2x00dev, 41, 0xbb);
 	rt2800_rfcsr_write(rt2x00dev, 42, 0xd2);
 	rt2800_rfcsr_write(rt2x00dev, 43, 0x9a);
@@ -6510,16 +6508,26 @@ static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
 		rt2800_rfcsr_write(rt2x00dev, 53, 0x84);
 	rt2800_rfcsr_write(rt2x00dev, 54, 0x78);
 	rt2800_rfcsr_write(rt2x00dev, 55, 0x44);
-	rt2800_rfcsr_write(rt2x00dev, 56, 0x22);
+	if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
+		rt2800_rfcsr_write(rt2x00dev, 56, 0x42);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 56, 0x22);
 	rt2800_rfcsr_write(rt2x00dev, 57, 0x80);
 	rt2800_rfcsr_write(rt2x00dev, 58, 0x7f);
 	rt2800_rfcsr_write(rt2x00dev, 59, 0x8f);
 
 	rt2800_rfcsr_write(rt2x00dev, 60, 0x45);
-	if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
-		rt2800_rfcsr_write(rt2x00dev, 61, 0xd1);
-	else
-		rt2800_rfcsr_write(rt2x00dev, 61, 0xdd);
+	if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F)) {
+		if (rt2x00_is_usb(rt2x00dev))
+			rt2800_rfcsr_write(rt2x00dev, 61, 0xd1);
+		else
+			rt2800_rfcsr_write(rt2x00dev, 61, 0xd5);
+	} else {
+		if (rt2x00_is_usb(rt2x00dev))
+			rt2800_rfcsr_write(rt2x00dev, 61, 0xdd);
+		else
+			rt2800_rfcsr_write(rt2x00dev, 61, 0xb5);
+	}
 	rt2800_rfcsr_write(rt2x00dev, 62, 0x00);
 	rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
 
