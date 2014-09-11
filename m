Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:44810 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaIKPGL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 11:06:11 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: Realtek GPIO chipset, for Baytrail?
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1410256608.4077.7.camel@hadess.net>
Date: Thu, 11 Sep 2014 08:06:50 -0700
Cc: linux-wireless@vger.kernel.org
Message-Id: <F79C10A5-18F8-4165-BFC5-FDAD35BE46BE@holtmann.org> (sfid-20140911_170614_696664_B022CB45)
References: <1410256608.4077.7.camel@hadess.net>
To: Bastien Nocera <hadess@hadess.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bastien,

> I have a tablet that seems to be using Realtek chips to do wireless
> communications (hopefully, this time I won't be wrong[1]).
> 
> The device, under the gpio class in /sys, shows with a modalias of
> "acpi:OBDA8723:" (that's on "O", not "0"). This seems to correspond to a
> Realtek chipset (Larry tells me it matches the PCI ID of 0bda:8723 for
> the RTL8723AE chipset).
> 
> It shows up under:
> /sys/devices/platform/80860F0A:00/subsystem/devices
> 
> Does anyone have details on how this chipset is actually hooked up? Can
> a portion of the existing RTL8723AE driver code be reused?

so after a little bit of digging, this seems to be the UART device for the Bluetooth chip. Can you try using 8250_dw.ko driver and see if it binds to it and you get a new serial port.

If I am correct then you have to run H:5 UART transport protocol to enable Bluetooth for this device.

Please double check that this ACPI tables really wrongly declare this as a Broadcom chip. This seems to be a firmware bug then. Unfortunately I think that for Broadcom you run H:4 UART transport protocol and for Realtek you have to run H:5 UART transport protocol. So no idea how to nicely differentiate these.

Regards

Marcel

