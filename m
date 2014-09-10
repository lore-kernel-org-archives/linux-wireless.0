Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:45724 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbaIJJvE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 05:51:04 -0400
Message-ID: <1410342645.4077.28.camel@hadess.net> (sfid-20140910_115116_129435_540517A3)
Subject: Re: Realtek GPIO chipset, for Baytrail?
From: Bastien Nocera <hadess@hadess.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 10 Sep 2014 11:50:45 +0200
In-Reply-To: <54100FF7.5060904@broadcom.com>
References: <1410256608.4077.7.camel@hadess.net>
	 <540F54B1.8040409@lwfinger.net> <1410292835.4077.21.camel@hadess.net>
	 <540F61FE.2050404@lwfinger.net>
	 <7234781D-5B78-404A-B945-D090938777C7@hadess.net>
	 <D08A763F-AD50-449D-98C6-B82866F49480@holtmann.org>
	 <54100FF7.5060904@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-09-10 at 10:46 +0200, Arend van Spriel wrote:
> On 09/10/14 01:10, Marcel Holtmann wrote:
> > Hi Bastien,
> >
> >>>>> What specific Baytrail tablet do you have?
> >>>>
> >>>> The Onda v975w. It came with Windows 8.1 32-bit.
> >>>>
> >>>> I guess that the device is probably a PCI one, but the enumeration is
> >>>> done through ACPI instead of "normal" PCI.
> >>>
> >>> In http://www.onda-tablet.com/onda-v975w-quad-core-win-8-tablet-9-7-inch-retina-screen-ram-2gb-wifi-32gb.html, someone is specifically looking for an RTL8723BS driver.
> >>
> >> That's helpful.
> >>
> >>> I will see if my contact at Realtek knows who has worked on drivers for this device, and if it would be possible to use rtl8723be if we were to supply an SDIO frontend.
> >>
> >> I'm not sure why the device doesn't show up in the sysfs tree, but maybe it needs a driver bound to it to show up.
> >
> > I just booted up my Baytrail based Minnowboard Max in ACPI enumeration and then the SDIO host controller is enumerated via ACPI. This is compared to PCI enumeration where the SDIO controller shows up in lspci.
> >
> > So can you try to install sdhci-acpi and see if that starts showing SDIO devices. If the SDIO host controllers loads, then it start SDIO enumeration and you would see the cards.
> 
> You may need to look in /sys/bus/mmc/devices/ instead of sdio.

Indeed. That did the trick.

mmc0:0001 is the builtin storage, mmc1:0001:1 however is an unbound
device with vendor 0x024c and device 0xb723 (modalias:
sdio:c07v024CdB723). More interestingly class is 0x07, which udev
interprets as "WLAN interface".

Cheers

