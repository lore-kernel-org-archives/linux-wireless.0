Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:25259 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbXKSTjE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 14:39:04 -0500
Received: by py-out-1112.google.com with SMTP id u77so5998586pyb
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2007 11:39:03 -0800 (PST)
Message-ID: <43e72e890711191139l78e6908apbdc0ba2b25d7f828@mail.gmail.com> (sfid-20071119_193910_519598_9F47BA6F)
Date: Mon, 19 Nov 2007 14:39:02 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: libertas ub8xxx - bcdDevice 30.06 - firmware issues?
Cc: libertas-dev@lists.infradead.org,
	"Stefano Brivio" <stefano.brivio@polimi.it>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1195492257.3248.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890711161726m11682a2fwcaba31c2d093310f@mail.gmail.com>
	 <1195492257.3248.1.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 19, 2007 12:10 PM, Dan Williams <dcbw@redhat.com> wrote:
> On Fri, 2007-11-16 at 20:26 -0500, Luis R. Rodriguez wrote:
> > I have a USB libertas 1286:2001 with bcdDevice 30.06 (from lsusb -v).
> > I tried downloading the firmware from marvell:
> >
> > https://www.marvell.com/drivers/driverDisplay.do?dId=160&pId=38
> >
> > renaming and to usb8388.bin and putting it in firmware dir. Is this
> > the right firmware??
>
> Yikes; really old.  You might want to try:
>
> http://dev.laptop.org/pub/firmware/libertas/
>
> Dan

Removing linux-kernel as it was a typo, just keeping linux-wireless.

Thanks Dan, I've tried

http://dev.laptop.org/pub/firmware/libertas/usb8388-5.220.11.p5.bin

as I thought that would be the latest as it has the highest point
release. It fails with:

root@node1-1:/usr/lib/hotplug/firmware# modprobe  usb8xxx
root@node1-1:/usr/lib/hotplug/firmware# dmesg -c
ieee80211: 802.11 data/management/control stack, 1.2.18
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
usb8xxx: URB in failure status: -71
usb 4-1: reset high speed USB device using ehci_hcd and address 5
usb 4-1: reset high speed USB device using ehci_hcd and address 5
usb 4-1: reset high speed USB device using ehci_hcd and address 5
usb 4-1: reset high speed USB device using ehci_hcd and address 5
usb 4-1: reset high speed USB device using ehci_hcd and address 5
usb 4-1: reset high speed USB device using ehci_hcd and address 5
usb 4-1: reset high speed USB device using ehci_hcd and address 5
usb 4-1: reset high speed USB device using ehci_hcd and address 5
usb 4-1: reset high speed USB device using ehci_hcd and address 5
usb 4-1: reset high speed USB device using ehci_hcd and address 5
usb 4-1: reset high speed USB device using ehci_hcd and address 5
usb8xxx: probe of 4-1:1.0 failed with error -12
usbcore: registered new interface driver usb8xxx


I wasn't sure if the latest dated firmware was the one I should have
used so I tried it:

http://dev.laptop.org/pub/firmware/libertas/usb8388-5.110.20.p0.bin

but I then get:

root@node1-1:/usr/lib/hotplug/firmware# modprobe  usb8xxx
root@node1-1:/usr/lib/hotplug/firmware# dmesg -c
ieee80211_crypt: registered algorithm 'NULL'
ieee80211: 802.11 data/management/control stack, 1.2.18
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
usb8xxx: URB in failure status: -71
usb 4-1: reset high speed USB device using ehci_hcd and address 5
usb 4-1: reset high speed USB device using ehci_hcd and address 5
usb 4-1: reset high speed USB device using ehci_hcd and address 5
usb 4-1: reset high speed USB device using ehci_hcd and address 5
usb 4-1: reset high speed USB device using ehci_hcd and address 5
usb 4-1: reset high speed USB device using ehci_hcd and address 5
usb 4-1: reset high speed USB device using ehci_hcd and address 5
usb 4-1: reset high speed USB device using ehci_hcd and address 5
usb 4-1: reset high speed USB device using ehci_hcd and address 5
usb 4-1: reset high speed USB device using ehci_hcd and address 5
usb 4-1: reset high speed USB device using ehci_hcd and address 5
usb8xxx: probe of 4-1:1.0 failed with error -12
usbcore: registered new interface driver usb8xxx

Do I have to perhaps update the firmware on the device first? I saw
instruction on how to do this for some devices with a higher bcdDevice
number but not for this old one. I also am not sure where to get the
files the wiki entry mentioned on doing this.

  Luis
