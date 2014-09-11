Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:59676 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaIKQD4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 12:03:56 -0400
Message-ID: <1410451415.32328.13.camel@hadess.net> (sfid-20140911_180359_645141_6EBAF8C9)
Subject: Re: Realtek GPIO chipset, for Baytrail?
From: Bastien Nocera <hadess@hadess.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 11 Sep 2014 18:03:35 +0200
In-Reply-To: <F79C10A5-18F8-4165-BFC5-FDAD35BE46BE@holtmann.org>
References: <1410256608.4077.7.camel@hadess.net>
	 <F79C10A5-18F8-4165-BFC5-FDAD35BE46BE@holtmann.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-09-11 at 08:06 -0700, Marcel Holtmann wrote:
> Hi Bastien,
> 
> > I have a tablet that seems to be using Realtek chips to do wireless
> > communications (hopefully, this time I won't be wrong[1]).
> > 
> > The device, under the gpio class in /sys, shows with a modalias of
> > "acpi:OBDA8723:" (that's on "O", not "0"). This seems to correspond to a
> > Realtek chipset (Larry tells me it matches the PCI ID of 0bda:8723 for
> > the RTL8723AE chipset).
> > 
> > It shows up under:
> > /sys/devices/platform/80860F0A:00/subsystem/devices
> > 
> > Does anyone have details on how this chipset is actually hooked up? Can
> > a portion of the existing RTL8723AE driver code be reused?
> 
> so after a little bit of digging, this seems to be the UART device for
> the Bluetooth chip. Can you try using 8250_dw.ko driver and see if it
> binds to it and you get a new serial port.
> 
> If I am correct then you have to run H:5 UART transport protocol to
> enable Bluetooth for this device.
> 
> Please double check that this ACPI tables really wrongly declare this
> as a Broadcom chip. This seems to be a firmware bug then.

No, there are devices declared in the DSDT that won't be available on
the platform itself. The _STA function for each device will tell you
whether the device is available or not (look for TSC in the DSDT, I
don't have 3 touchscreens either ;).

>  Unfortunately I think that for Broadcom you run H:4 UART transport
> protocol and for Realtek you have to run H:5 UART transport protocol.
> So no idea how to nicely differentiate these.

