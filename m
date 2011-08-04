Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from richmond.toniob.net ([88.191.116.29]:60896 "EHLO
	mail.toniob.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab1HDT4S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Aug 2011 15:56:18 -0400
Subject: rt2x00: Add rt2870 device id
From: Anthony Bourguignon <contact+kernel@toniob.net>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com
Date: Thu, 04 Aug 2011 21:45:39 +0200
Content-Type: multipart/mixed; boundary="=-JRbNT8sQzH90/tILUrks"
Message-ID: <1312487142.4832.8.camel@moss> (sfid-20110804_215626_283308_30FE4405)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JRbNT8sQzH90/tILUrks
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hello,

Dvico ships WiFi usb keys with some of their tvix hardware. The vendor
id is related to dvico and not known from the rt2800usb driver. The
chipset is found to be a rt2870. You'll find enclosed a patch to handle
theses usb keys. I've tested it on a vanilla 3.0 kernel and the key is
recognize and working perfectly.

Sincerely

Anthony Bourguignon

--=-JRbNT8sQzH90/tILUrks
Content-Disposition: attachment; filename="dvico.patch"
Content-Type: text/x-patch; name="dvico.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index ba82c97..3704ef7 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -839,6 +839,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x07d1, 0x3c16) },
 	/* Draytek */
 	{ USB_DEVICE(0x07fa, 0x7712) },
+	/* DVICO */
+	{ USB_DEVICE(0x0fe9, 0xb307) },
 	/* Edimax */
 	{ USB_DEVICE(0x7392, 0x7711) },
 	{ USB_DEVICE(0x7392, 0x7717) },

--=-JRbNT8sQzH90/tILUrks--

