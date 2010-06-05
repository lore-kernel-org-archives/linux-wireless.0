Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62084 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab0FEUII (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jun 2010 16:08:08 -0400
Date: Sat, 05 Jun 2010 15:08:29 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>, chunkeey@web.de
Cc: dravet@hotmail.com, linux-wireless@vger.kernel.org
Subject: [PATCH] p54usb: Add device ID for Dell WLA3310 USB
Message-ID: <4c0aaebd.7lqiusTk9vdkgjCd%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jason Dravet <dravet@hotmail.com>

Add Dell WLA3310 USB wireless card, which has a Z-Com XG-705A chipset, to the
USB Ids in p54usc.

Signed-off-by: Jason Dravet <dravet@hotmail.com>
Tested-by: Richard Gregory Tillmore <rtillmore@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

Please submit this update for 2.6.35.

Jason reports "The only problem I see is the LED light goes on when I plug
the card in and it goes out when I get a dhcp address (dhclient).  The LED
doesn't flicker when I ping the router either. The other funny thing it has
two LEDs, one on top and one on the bottom. It appears they do the same thing
i.e. they are both on or both off." From this I conclude that this driver may
need some additional tweaking to support LEDs, but that is of secondary
importance.

Larry
---

Index: wireless-testing/drivers/net/wireless/p54/p54usb.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/p54/p54usb.c
+++ wireless-testing/drivers/net/wireless/p54/p54usb.c
@@ -80,6 +80,7 @@ static struct usb_device_id p54u_table[]
 	{USB_DEVICE(0x1413, 0x5400)},   /* Telsey 802.11g USB2.0 Adapter */
 	{USB_DEVICE(0x1435, 0x0427)},	/* Inventel UR054G */
 	{USB_DEVICE(0x2001, 0x3704)},	/* DLink DWL-G122 rev A2 */
+	{USB_DEVICE(0x413c, 0x5513)},	/* Dell WLA3310 USB Wireless Adapter */
 	{USB_DEVICE(0x413c, 0x8102)},	/* Spinnaker DUT */
 	{USB_DEVICE(0x413c, 0x8104)},	/* Cohiba Proto board */
 	{}
