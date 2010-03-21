Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193Ab0CUIqT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Mar 2010 04:46:19 -0400
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2L8kIb3019958
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Sun, 21 Mar 2010 04:46:19 -0400
Received: from localhost.localdomain (vpn1-6-219.ams2.redhat.com [10.36.6.219])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o2L8kGOY000384
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 21 Mar 2010 04:46:18 -0400
Message-ID: <4BA5DD22.2070404@redhat.com>
Date: Sun, 21 Mar 2010 09:47:30 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: PATCH: add new usb id to p54usb
Content-Type: multipart/mixed;
 boundary="------------030608070304090206060106"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030608070304090206060106
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

The attached patch adds support for the Thomson Speedtouch 120g to the
p54usb driver (only thing needed is adding the USB ID). A friend of
mine happened to have one of these and gave it to me, so I can
confirm that it works once the USB ID is added.

Regards,

Hans

--------------030608070304090206060106
Content-Type: text/plain;
 name="0002-Add-USB-ID-for-Thomson-SpeedTouch-120g-to-p54usb-id-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-Add-USB-ID-for-Thomson-SpeedTouch-120g-to-p54usb-id-.pa";
 filename*1="tch"

>From f69c319b3321524e384408e7fec7dd691519419f Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Wed, 17 Mar 2010 14:37:16 +0100
Subject: [PATCH 2/2] Add USB ID for Thomson SpeedTouch 120g to p54usb id table

Thanks to Chris Chabot for giving his old wireless usb dongle to me
to test it under Linux.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/net/wireless/p54/p54usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index b3c4fbd..e3cfc00 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -35,6 +35,7 @@ MODULE_FIRMWARE("isl3887usb");
 static struct usb_device_id p54u_table[] __devinitdata = {
 	/* Version 1 devices (pci chip + net2280) */
 	{USB_DEVICE(0x0506, 0x0a11)},	/* 3COM 3CRWE254G72 */
+	{USB_DEVICE(0x06b9, 0x0120)},	/* Thomson SpeedTouch 120g */
 	{USB_DEVICE(0x0707, 0xee06)},	/* SMC 2862W-G */
 	{USB_DEVICE(0x07aa, 0x001c)},	/* Corega CG-WLUSB2GT */
 	{USB_DEVICE(0x083a, 0x4501)},	/* Accton 802.11g WN4501 USB */
-- 
1.7.0


--------------030608070304090206060106--
