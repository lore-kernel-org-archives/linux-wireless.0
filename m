Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:42210 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751846AbXKSLoy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 06:44:54 -0500
Date: Mon, 19 Nov 2007 12:44:27 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	Dan Williams <dcbw@redhat.com>
Subject: Re: [BUG] libertas: probing for Marvell USB8388 fails
Message-ID: <20071119124427.67f8dcda@morte> (sfid-20071119_114458_755592_D8D9F0D6)
In-Reply-To: <200711191144.02169.hs4233@mail.mn-solutions.de>
References: <20071117023548.79a7a33c@morte>
	<200711191008.26174.hs4233@mail.mn-solutions.de>
	<20071119102117.74932cc1@morte>
	<200711191144.02169.hs4233@mail.mn-solutions.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 19 Nov 2007 11:44:02 +0100
Holger Schurig <hs4233@mail.mn-solutions.de> wrote:

> > As long as probing fails, I doubt that my issue is firmware
> > related...
> 
> I was not sure that probing failed for you. I saw an URB submit 
> error.

Right, it looks like I didn't read carefully my logs. :)

> If usb8xxx.ko and libertas.ko get loaded, then it might be a 
> wrong firmware. When the USB driver loads, it first uses URBs to 
> send a helper firmware to the card. Then this helper firmware 
> get's started. And then it sends again URBs to the card, e.g. 
> for setup stuff. Now if the helper firmware is bogus and doesn't 
> accept the URBs to download the real firmware ...

I tried these ones,
4d80059fe935edef77c0745a426f6aab  usb8388.bin.olpc
9854fff247b970cc34fd14785384ffeb  usb8388.bin.rh
(I found both URLs in some Fedora installation script), but I still get the
same error message.

> If probing fails and udev doesn't even load usb8xxx.ko, then you 
> have an USB problem and the wireless mailing list might not be 
> of much help to you.

This is what I get when loading the libertas module with libertas_debug set
to 255:
[421322.049447] usb8xxx enter: if_usb_exit_module():1044
[421322.049502] usbcore: deregistering interface driver usb8xxx
[421322.049717] usb8xxx leave: if_usb_exit_module():1054
[421323.407779] libertas enter: libertas_exit_module():1527
[421323.407878] libertas leave: libertas_exit_module():1531
[421327.355499] libertas enter: libertas_init_module():1519
[421327.355618] libertas leave: libertas_init_module():1521
[421330.901950] usb8xxx enter: if_usb_init_module():1028
[421336.502698] usb8xxx: URB in failure status: -71
[421336.622483] usb 1-4: reset high speed USB device using ehci_hcd and address 6
[421337.992174] usb 1-4: reset high speed USB device using ehci_hcd and address 6
[421339.361828] usb 1-4: reset high speed USB device using ehci_hcd and address 6
[421340.731494] usb 1-4: reset high speed USB device using ehci_hcd and address 6
[421342.101171] usb 1-4: reset high speed USB device using ehci_hcd and address 6
[421343.470845] usb 1-4: reset high speed USB device using ehci_hcd and address 6
[421344.840515] usb 1-4: reset high speed USB device using ehci_hcd and address 6
[421346.210185] usb 1-4: reset high speed USB device using ehci_hcd and address 6
[421347.579869] usb 1-4: reset high speed USB device using ehci_hcd and address 6
[421348.949530] usb 1-4: reset high speed USB device using ehci_hcd and address 6
[421350.319203] usb 1-4: reset high speed USB device using ehci_hcd and address 6
[421350.471152] usb8xxx: probe of 1-4:1.0 failed with error -12
[421350.471354] usbcore: registered new interface driver usb8xxx
[421350.471415] usb8xxx leave: if_usb_init_module():1036, ret 0

So I would exclude that an USB problem is going on. Plus, if I load both
modules without any firmware being available, usb8xxx tells me that
request_firmware() failed:
[421274.018749] usb8xxx enter: if_usb_init_module():1028
[421274.097904] usb8xxx: request_firmware() failed with 0xfffffffe
[421274.097956] usb8xxx: firmware usb8388.bin not found
[421274.217406] usb 1-4: reset high speed USB device using ehci_hcd and address 6
[421274.369547] usb8xxx: probe of 1-4:1.0 failed with error -12
[421274.369732] usbcore: registered new interface driver usb8xxx
[421274.369792] usb8xxx leave: if_usb_init_module():1036, ret 0


--
Ciao
Stefano
