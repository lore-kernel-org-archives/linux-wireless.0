Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:52506 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaIKQmU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 12:42:20 -0400
Message-ID: <1410453721.32328.15.camel@hadess.net> (sfid-20140911_184223_432251_A0F629F3)
Subject: Re: Realtek GPIO chipset, for Baytrail?
From: Bastien Nocera <hadess@hadess.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Loic Poulain <loic.poulain@intel.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 11 Sep 2014 18:42:01 +0200
In-Reply-To: <5F46C78F-1749-480F-B90C-702509D963AD@holtmann.org>
References: <1410256608.4077.7.camel@hadess.net>
	 <F79C10A5-18F8-4165-BFC5-FDAD35BE46BE@holtmann.org>
	 <5411C2BE.6090702@intel.com> <1410451261.32328.11.camel@hadess.net>
	 <5F46C78F-1749-480F-B90C-702509D963AD@holtmann.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-09-11 at 09:37 -0700, Marcel Holtmann wrote:
> Hi Bastien,
> 
> >> Your device is a child of 80860F0A (UART) which is driven by the 8250_dw 
> >> driver.
> >> OBDA8723 is the BT part of the realtek 8723 WiFi/BT combo chip.
> >> acpi_platform should create a platform device from the ACPI desc.
> > 
> > That does show up already in udev, so I should be fine.
> > 
> >> Then, you can add the OBDA8723 acpi id to the rfkill-gpio platform 
> >> driver (net/rfkill) which
> >> seems to handle correctly the basic power management of this chip.
> > 
> > OK. Something like that should do:
> > http://paste.fedoraproject.org/132832/14104505
> > 
> >> You need to use hciattach to attach the chip to the BT stack (with 
> >> H5/3-wire proto).
> > 
> > Will that be required to enable Bluetooth at every boot?
> > 
> > After inserting the above module, I ran:
> > hciattach -n ttyS0 3wire
> > 
> > But no Bluetooth adapters showed up in hciconfig. The rfkill device did
> > show up in rfkill list though.
> 
> my bet is that you need to start with the correct default speed, load
> some firmware and do more settings and then switch to the faster
> speed. There is an effort ongoing for the USB version of Realtek
> Bluetooth, but even that one has not yet completed.

I have a firmware and a config file from the Windows driver, but I doubt
I'd be able to make great headway without more info.

That's Larry's driver for the USB variant:
https://github.com/lwfinger/rtl8723au_bt

