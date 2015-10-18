Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isp-bos-04.edutel.nl ([88.159.1.182]:38518 "EHLO
	isp-bos-04.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbbJRR6h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Oct 2015 13:58:37 -0400
Message-ID: <5845ADB79D70437C90C0CF7433F3D180@FransW7> (sfid-20151018_195841_677697_A5EDC4F3)
From: "Frans van de Wiel" <fvdw@fvdw.eu>
To: "Greg KH" <greg@kroah.com>
Cc: <Larry.Finger@lwfinger.net>, <florian.c.schilhabel@googlemail.com>,
	<linux-wireless@vger.kernel.org>
References: <D805188AF08F4EC2A19325C1329525E0@FransW7> <20151018154547.GA8553@kroah.com>
In-Reply-To: <20151018154547.GA8553@kroah.com>
Subject: [PATCH 3.10-3.18] Driver, staging rtl8712,  add support for sitecom WLA2100 
Date: Sun, 18 Oct 2015 19:58:30 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The staging driver rtl8712 lacks support for dongles based on sitecom 
WLA2100.
The current driver doesn't contain the usb id for this device, this patch 
add it.

reported by: Frans van de Wiel  <fvdw@fvdw.eu>
Signed-off-by: Frans van de Wiel  <fvdw@fvdw.eu>
---
This patch is for stable kernels 3.14 to 3.18
Patch for 3.14.2 is included

--- linux-3.14.2/drivers/staging/rtl8712/usb_intf.c.orig    2014-04-27 
02:19:26.000000000 +0200
+++ linux-3.14.2/drivers/staging/rtl8712/usb_intf.c    2014-03-25 
22:31:33.000000000 +0100
@@ -144,6 +144,7 @@ static struct usb_device_id rtl871x_usb_
     {USB_DEVICE(0x0DF6, 0x0058)},
     {USB_DEVICE(0x0DF6, 0x0049)},
     {USB_DEVICE(0x0DF6, 0x004C)},
+    {USB_DEVICE(0x0DF6, 0x006C)},
     {USB_DEVICE(0x0DF6, 0x0064)},
     /* Skyworth */
     {USB_DEVICE(0x14b2, 0x3300)},
---

-----Oorspronkelijk bericht----- 
From: Greg KH
Sent: Sunday, October 18, 2015 5:45 PM
To: Frans van de Wiel
Cc: Larry.Finger@lwfinger.net ; florian.c.schilhabel@googlemail.com ; 
linux-wireless@vger.kernel.org
Subject: Re: patch for rtl8712 driver, add support for sitecom WLA2100 
(006c)

On Sun, Oct 18, 2015 at 04:34:51PM +0200, Frans van de Wiel wrote:
> dear sirs, please find attached a patch for the rtl8712 driver (staging)
> The patch add support for  sitecom WLA2100, seems this device id is 
> missing.
> Many dongles use it.
>
> Kind regards
> Frans



Can you reformat this in the way that the file
Documenatation/SubmittingPatches explains so that I can accept the
patch?  As it is, I can't :(

thanks,

greg k-h 

