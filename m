Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:39758 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753611Ab1BHMDk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 07:03:40 -0500
Message-ID: <20110208140329.16761adb54ekbcpw@hayate.sektori.org>
Date: Tue, 08 Feb 2011 14:03:29 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sujith <m.sujith@gmail.com>, Martin Schleier <drahemmaps@gmx.net>,
	linux-wireless@vger.kernel.org, dsd@gentoo.org,
	linville@tuxdriver.com, kune@deine-taler.de,
	linux-usb@vger.kernel.org, gregkh@suse.de
Subject: Re: Override endpoint attributes (was: RE: [PATCH] zd1211rw:
 change endpoint types of EP_REGS_OUT and EP_INT_IN from interrupt to bulk)
References: <Pine.LNX.4.44L0.1102061457400.24963-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1102061457400.24963-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Alan Stern <stern@rowland.harvard.edu>:

> On Sun, 6 Feb 2011, Sujith wrote:
>
>> Alan Stern wrote:
>> > Why do you want to?  Why does changing the endpoint type from interrupt
>> > to bulk improve performance?  Yes, the description says that this
>> > causes CPU usage to go from 10% to below 1%, but _why_ does it do that?
>> >
>> > Maybe the same effect can be achieved simply by changing the interrupt
>> > interval instead.
>>
>> Well, when the device is plugged in, the USB core recognizes the endpoints
>> as interrupt type. Later, in the probe() callback, the FW is uploaded to the
>> target and it patches the endpoints' type to bulk. Please correct me if am
>> wrong, but I think this mismatch between the host and the target would be
>> the cause for the high CPU usage, when the transmission load for that
>> endpoint is high.
>
> (Actually, bulk transfers generally cause a higher CPU load than
> interrupt transfers.  But never mind that...)
>
> The problem is that the kernel doesn't know the firmware has been
> changed.  The kernel has to be told about this, one way or another.
> Typically the device would disconnect itself from the USB bus briefly,
> when starting to run the new firmware.  Or the kernel would be told to
> reset the device after the firmware was transferred, after which the
> device would start running the new firmware.
>
> Apparently the driver needs to call usb_reset_device() when the
> firmware has been transferred.  Following the reset, the kernel will
> see that the descriptors have changed and it will reload all of them.
> Then it will know that the endpoint is bulk rather than interrupt.
>

Atleast with zd1211rw, after usb_reset_device() endpoints still show  
as interrupt type and device requires firmware to be transferred  
again. I cannot tell if zd1211 firmware actually changes endpoint  
types (as ath9k_htc) but I know that vendor driver uses these  
endpoints with bulk urbs and using those solve/workaround CPU usage  
problem. Increasing interrupt interval from 1 to 255 didn't help.

I think zd1211rw have been trying to use bulk urbs too, but  
usb_bulk_msg() silently switches to interrupt mode. I don't know if  
editing endpoint descriptors is right way solve this, or why CPU usage  
is higher.

CPU usage comes from writing beacon frame to device, this is done  
usually every 100ms on AP-mode. On Atom writing beacon (multiple  
usb_bulk_msg() calls) with interrupt endpoints usually takes ~20msec  
and this is when CPU usage goes up. By changing endpoints to bulk,  
time to write beacon drops to 0~3msec.

Endpoint descriptors appear to be edited by two drivers,  
drivers/media/IR/mceusb.c (bulk to intr) and  
/drivers/net/wireless/ath/ath9k/hif_usb.c (intr to bulk). Also bulk  
endpoints are changed to interrupt type for buggy low-speed devices in  
drivers/usb/core/config.c.

So what is right way to proceed? Is problem in usb core or with  
device? Deal with buggy device in driver and override endpoint as  
patch does?

-Jussi

