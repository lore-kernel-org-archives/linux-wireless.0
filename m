Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:55208 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932350Ab3BMJkD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 04:40:03 -0500
Received: by mail-bk0-f44.google.com with SMTP id j4so449067bkw.31
        for <linux-wireless@vger.kernel.org>; Wed, 13 Feb 2013 01:40:01 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Andrew Wasielewski <andrew@wasielewski.co.uk>
Subject: Re: WARNING: at drivers/net/wireless/p54/main.c:443 p54_work+0x66/0x80 [p54common]() (Not tainted)
Date: Wed, 13 Feb 2013 10:39:58 +0100
Cc: linux-wireless@vger.kernel.org
References: <1732818.7oJIpSJZSL@localhost.localdomain> <201302071657.12783.chunkeey@googlemail.com> <2215579.kyTgX4RlnS@localhost.localdomain>
In-Reply-To: <2215579.kyTgX4RlnS@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201302131039.58880.chunkeey@googlemail.com> (sfid-20130213_104010_563498_0E294939)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Andrew

On Tuesday, February 12, 2013 01:04:11 AM Andrew Wasielewski wrote:
> On Thursday 07 February 2013 16:57:12 Christian Lamparter wrote:
> > On Thursday, February 07, 2013 12:51:38 AM Andrew Wasielewski wrote:
> > > On Wednesday 30 January 2013 01:06:52 Christian Lamparter wrote:
> > > > On Wednesday, January 30, 2013 12:04:38 AM Andrew Wasielewski wrote:
> > > > Reloading the driver (modprobe -r p54usb && modprobe p54usb) or replugging the 
> > > > device should have helped. Anyway, the clean "reset" procedure for these devices
> > > > is known but to Conexant. 
> > > modprobing p54usb works with the driver, but I still have to restart hostapd for
> > > it to pick up the now-working driver.  Good news is it hasn't happened again.
> > Ah, you should be able to do this automatically. For example with Debian
> > (and Ubuntu?) you can add an entry into your /etc/network/interfaces:
> I don't have /etc/network/interfaces in ClearOS.  Also my wlan0 doesn't have 
> an IP address directly, as it is bridged with wired eth0 in br0.  Can that be
> accomodated?
Do you know how hostapd is started? Is it done automatically, or do you
have some sort of custom initscript?

> > and it will automatically restart hostapd when the device
> > is replugged/driver is reloaded.
> > [Note: The driver can detect if the firmware is dead. I'm
> > thinking about implementing a simple reset-when-dead feature.
> > Would you be willing to test it once it materializes? I'm
> > asking because I don't have any isl3886usb. Just the PCI
> > versions and two isl3887usb].
> Happy to test anything you can offer.  However is there any way to trigger /
> simulate firmware failure, as it doesn't happen very often (fortunately) by
> itself.
Sure, crashing the firmware is easy (garbage in, garbage out). But we don't
need to do that, we can simply assume it "crashed" and then test
if the reset code works properly [otherwise it might take all day since
as you said: they happen, but not very often). I'm thinking of taking a
closer looksie this weekend.

> If I come across anything that looks viable I can test it.  If I can find a
> MicroATX M/b that will fit the Shuttle case I will upgrade - ideally one with
> a PCIe slot for wireless and PCI for the ADSL2+ card.  It's a FN41V3 if 
> anyone has any suggestions.
Are you sure a MicroATX M/b fits? It looks like the FN41V3 is a proprietary 
form factor. Do you think you can cram a mini-itx inside the case? If you
can, then you could look at a cheap ATOM or BOBCAT mainboard. Some of them
still have a conventional PCI slot and most also do have a minipcie-slot
too (which is preferable since you won't need any pcie<->minipcie adapters)

Regards,
	Christian
