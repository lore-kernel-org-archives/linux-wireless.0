Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:35164 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752645Ab1BHPV4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 10:21:56 -0500
Date: Tue, 8 Feb 2011 10:21:54 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
cc: Sujith <m.sujith@gmail.com>, Martin Schleier <drahemmaps@gmx.net>,
	<linux-wireless@vger.kernel.org>, <dsd@gentoo.org>,
	<linville@tuxdriver.com>, <kune@deine-taler.de>,
	<linux-usb@vger.kernel.org>, <gregkh@suse.de>
Subject: Re: Override endpoint attributes (was: RE: [PATCH] zd1211rw: change
 endpoint types of EP_REGS_OUT and EP_INT_IN from interrupt to bulk)
In-Reply-To: <20110208140329.16761adb54ekbcpw@hayate.sektori.org>
Message-ID: <Pine.LNX.4.44L0.1102081011030.2100-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 8 Feb 2011, Jussi Kivilinna wrote:

> Atleast with zd1211rw, after usb_reset_device() endpoints still show  
> as interrupt type and device requires firmware to be transferred  
> again.

Ah, this is one of those bogus devices which has no way of telling the 
host when its descriptors change.  Have you tried testing this device 
across hibernation?

>  I cannot tell if zd1211 firmware actually changes endpoint  
> types (as ath9k_htc)

Use "lsusb -v".

>  but I know that vendor driver uses these  
> endpoints with bulk urbs and using those solve/workaround CPU usage  
> problem. Increasing interrupt interval from 1 to 255 didn't help.
> 
> I think zd1211rw have been trying to use bulk urbs too, but  
> usb_bulk_msg() silently switches to interrupt mode. I don't know if  
> editing endpoint descriptors is right way solve this, or why CPU usage  
> is higher.
> 
> CPU usage comes from writing beacon frame to device, this is done  
> usually every 100ms on AP-mode. On Atom writing beacon (multiple  
> usb_bulk_msg() calls) with interrupt endpoints usually takes ~20msec  
> and this is when CPU usage goes up. By changing endpoints to bulk,  
> time to write beacon drops to 0~3msec.

That's part of the problem -- the driver shouldn't use usb_bulk_msg().  
Create a bunch of URBs and submit them explicitly all at once; don't
wait for one to finish before submitting the next.  Setting the
URB_NO_INTERRUPT flag on all but the last could also help.  This might 
use even less CPU time than you see currently.

> Endpoint descriptors appear to be edited by two drivers,  
> drivers/media/IR/mceusb.c (bulk to intr) and  
> /drivers/net/wireless/ath/ath9k/hif_usb.c (intr to bulk). Also bulk  
> endpoints are changed to interrupt type for buggy low-speed devices in  
> drivers/usb/core/config.c.
> 
> So what is right way to proceed? Is problem in usb core or with  
> device? Deal with buggy device in driver and override endpoint as  
> patch does?

There are at least three problems that I can see.  First, the device 
doesn't disconnect from and reconnect to the USB bus when it starts 
using new firmware.  Second, the device loses its firmware when it is 
reset.  Third, the driver wastes too much CPU time writing beacon 
frames.

The first two problems are the device's fault, and the third is the 
driver's fault.  None of them are the fault of usbcore.

Alan Stern

