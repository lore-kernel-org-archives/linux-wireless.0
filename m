Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:60748 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbZJPVuU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 17:50:20 -0400
Received: by ey-out-2122.google.com with SMTP id 9so548595eyd.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2009 14:50:24 -0700 (PDT)
Message-ID: <4AD8EA95.9040200@gmail.com>
Date: Fri, 16 Oct 2009 23:50:13 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Simon Raffeiner <sturmflut@lieberbiber.de>
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	IvDoorn@gmail.com
Subject: Re: [rt2x00-users] [PATCH] rt73usb.c : more ids
References: <4AD468DB.4050700@gmail.com> <880c1630910130520p30c06846k8692634ec277340@mail.gmail.com> <20091013145600.GB2747@tuxdriver.com> <200910161517.36838.sturmflut@lieberbiber.de>
In-Reply-To: <200910161517.36838.sturmflut@lieberbiber.de>
Content-Type: multipart/mixed;
 boundary="------------040202010304010007010909"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040202010304010007010909
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

On 10/16/2009 03:17 PM, Simon Raffeiner wrote:

> I may be wrong but at least for me this concept worked - I bought an 
> RT2070L based device which is currently not supported by rt2800usb, the 
> fact that the driver got loaded pointed me into the right direction 
> (http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?f=5&t=5245&hilit=rt2070).
> 
> I'll post the patch (new ids and some cleanups) if everybody's okay with it.

I did it three days ago, but I did not get free time to post it, sorry!

from 09/15/2009, 1.04.07.0000 windows inf file.

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

-thanks-

regards,
-- 
«Allá muevan feroz guerra, ciegos reyes por un palmo más de tierra;
que yo aquí tengo por mío cuanto abarca el mar bravío, a quien nadie
impuso leyes. Y no hay playa, sea cualquiera, ni bandera de esplendor,
que no sienta mi derecho y dé pecho a mi valor.»

--------------040202010304010007010909
Content-Type: text/plain;
 name="new_id-2800usb.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="new_id-2800usb.diff"

--- o/drivers/net/wireless/rt2800usb.c	2009-10-13 13:55:35.194380796 +0200
+++ n/drivers/net/wireless/rt2800usb.c	2009-10-13 15:06:42.771378537 +0200
@@ -2886,17 +2886,23 @@
 	{ USB_DEVICE(0x0e0b, 0x9041), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Amit */
 	{ USB_DEVICE(0x15c5, 0x0008), USB_DEVICE_DATA(&rt2800usb_ops) },
+	/* Askey */
+	{ USB_DEVICE(0x1690, 0x0740), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x1690, 0x0744), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0930, 0x0a07), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* ASUS */
 	{ USB_DEVICE(0x0b05, 0x1731), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0b05, 0x1732), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0b05, 0x1742), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0b05, 0x1760), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0b05, 0x1761), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0b05, 0x1784), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* AzureWave */
 	{ USB_DEVICE(0x13d3, 0x3247), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x13d3, 0x3262), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x13d3, 0x3273), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x13d3, 0x3284), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x13d3, 0x3305), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Belkin */
 	{ USB_DEVICE(0x050d, 0x8053), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x050d, 0x805c), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -2905,6 +2911,8 @@
 	/* Buffalo */
 	{ USB_DEVICE(0x0411, 0x00e8), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0411, 0x012e), USB_DEVICE_DATA(&rt2800usb_ops) },
+	/* Cisco */
+	{ USB_DEVICE(0x167b, 0x4001), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Conceptronic */
 	{ USB_DEVICE(0x14b2, 0x3c06), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x14b2, 0x3c07), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -2920,6 +2928,8 @@
 	{ USB_DEVICE(0x07aa, 0x002f), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07aa, 0x003c), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07aa, 0x003f), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x07aa, 0x0041), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x07aa, 0x0042), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x18c5, 0x0008), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x18c5, 0x0012), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* D-Link */
@@ -2931,18 +2941,24 @@
 	{ USB_DEVICE(0x07d1, 0x3c0f), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07d1, 0x3c11), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07d1, 0x3c13), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x07d1, 0x3c15), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Edimax */
 	{ USB_DEVICE(0x7392, 0x7711), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x7392, 0x7717), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x7392, 0x7718), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Encore */
 	{ USB_DEVICE(0x203d, 0x1480), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x203d, 0x14a1), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x203d, 0x14a9), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* EnGenius */
 	{ USB_DEVICE(0X1740, 0x9701), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1740, 0x9702), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1740, 0x9703), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1740, 0x9705), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1740, 0x9706), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x1740, 0x9707), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x1740, 0x9708), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x1740, 0x9709), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1740, 0x9801), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Gemtek */
 	{ USB_DEVICE(0x15a9, 0x0010), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -2956,7 +2972,10 @@
 	{ USB_DEVICE(0x0e66, 0x0009), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0e66, 0x000b), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* I-O DATA */
+	{ USB_DEVICE(0x04bb, 0x0944), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x04bb, 0x0945), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x04bb, 0x0947), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x04bb, 0x0948), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* LevelOne */
 	{ USB_DEVICE(0x1740, 0x0605), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1740, 0x0615), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -2971,8 +2990,18 @@
 	/* Motorola */
 	{ USB_DEVICE(0x100d, 0x9031), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x100d, 0x9032), USB_DEVICE_DATA(&rt2800usb_ops) },
+	/* MSI */
+	{ USB_DEVICE(0x0db0, 0x3820), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0db0, 0x3821), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0db0, 0x3870), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0db0, 0x6899), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0db0, 0x821a), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0db0, 0x870a), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0db0, 0x899a), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Ovislink */
 	{ USB_DEVICE(0x1b75, 0x3072), USB_DEVICE_DATA(&rt2800usb_ops) },
+	/* Para */
+	{ USB_DEVICE(0x20b8, 0x8888), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Pegatron */
 	{ USB_DEVICE(0x1d4d, 0x0002), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1d4d, 0x000c), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -2988,8 +3017,6 @@
 	/* Quanta */
 	{ USB_DEVICE(0x1a32, 0x0304), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Ralink */
-	{ USB_DEVICE(0x0db0, 0x3820), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x0db0, 0x6899), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x148f, 0x2070), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x148f, 0x2770), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x148f, 0x2870), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -3013,7 +3040,12 @@
 	{ USB_DEVICE(0x0df6, 0x003e), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0df6, 0x003f), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0df6, 0x0040), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0df6, 0x0041), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0df6, 0x0042), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0df6, 0x0047), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0df6, 0x0048), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0df6, 0x004a), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0df6, 0x004d), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* SMC */
 	{ USB_DEVICE(0x083a, 0x6618), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x083a, 0x7511), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -3022,6 +3054,8 @@
 	{ USB_DEVICE(0x083a, 0x8522), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x083a, 0xa512), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x083a, 0xa618), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x083a, 0xa701), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x083a, 0xa702), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x083a, 0xb522), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x083a, 0xc522), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Sparklan */
@@ -3039,6 +3073,7 @@
 	{ USB_DEVICE(0x5a57, 0x0280), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x5a57, 0x0282), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x5a57, 0x0283), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x5a57, 0x0284), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x5a57, 0x5257), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Zyxel */
 	{ USB_DEVICE(0x0586, 0x3416), USB_DEVICE_DATA(&rt2800usb_ops) },

--------------040202010304010007010909--
