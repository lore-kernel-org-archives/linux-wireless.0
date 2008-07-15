Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbYGORGS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 13:06:18 -0400
Subject: Re: Some questions about missing rfkill details
From: Dan Williams <dcbw@redhat.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <20080713122247.GA6963@khazad-dum.debian.net>
References: <20080713122247.GA6963@khazad-dum.debian.net>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 13:04:34 -0400
Message-Id: <1216141474.6039.108.camel@localhost.localdomain> (sfid-20080715_190622_435067_EE7690F4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-07-13 at 09:22 -0300, Henrique de Moraes Holschuh wrote:
> I was a little burned out from rfkill work, and started looking at a certain
> non-mac80211 wireless driver to see how it could be converted to use rfkill
> (we already have many examples for mac80211).
> 
> The following doubts sprang to mind, I feel the answers to them should be
> documented, but I am not sure I have the right answers, so I am asking the
> wireless network experts ;-)
> 
> 1. For wireless network devices, the rfkill class should have as its parent
>    the main struct net_device for that wireless network device.  For
>    platform device drivers, it should have the platform device as its
>    parent.
> 
>    Correct? Incorrect?

I _think_ so, yes.  Whatever driver actually handles the operation or
notices the events should be the one that "owns" the rfkill device.  So
for ipw2200 laptops where the GPIO pins are toggled (i.e.
IPW_INTA_BIT_RF_KILL_DONE event in ipw_irq_tasklet()) the rfkill object
should be owned by the ipw2200 device.  But the hp-wmi driver's rfkill
object would be owned by it's platform device since the hp-wmi driver is
what handles events from BIOS.

> 2. We will probably benefit long-term from a guideline for naming the rfkill
>    switches.  Currently it is supposed to be a system-wide name, but that's
>    about all of it.
>    
>    Thus, what we have may not result on very user-friendly (or useful) names
>    at all.
> 
>    It really needs a local part so that drivers that have more than one
>    rfkill class attached to them (typically, multi-radio devices or platform
>    devices) can differentiate them.  But that means names like "<platform
>    device name>_bluetooth_sw", "<platform_device_name>_wwan_sw" for platform
>    drivers, and something else for wireless network devices.
> 
>    Any ideas of what we should be using, that will actually be useful for
>    userspace?

Sounds like a good idea to at least add the type to the name for human
readability.
   
>    Userspace IS supposed to be able to use sysfs to find out what the parent
>    device is, regardless of the rfkill class name.  If it cannot, that
>    pretty much would make sysfs useless for device configuration through
>    classes.

Right, since sysfs uses directory hierarchies, as long as the right
sysfs links are set up then userspace should be able to determine the
parent quite easily.

>    If we use the EEPROM MAC, should we document that userspace is to mostly
>    ignore the name and use the sysfs hierarchy to tie switches to their
>    parent devices?  And MACs can be changed, what should we do, then?

I wouldn't use the EEPROM MAC at all.  I think adding the type to the
name would be fine, but isn't strictly necessary.

>    Could we, instead of the MAC, use the main network interface name (and
>    rename the rfkill class if that name changes? How?), appending to it an
>    (optional?) small suffix for network devices with more than one
>    transmitter?  What should we use as the suffix?

Ugh, I wouldn't use the interface name either.  I just don't think it's
useful to get that specific with the name.

>    IMHO, we should also write down if we are to use names like "Mango Bango
>    Wireless Switch" or "mangobango_sw", etc.  I.e. a full naming guideline.

If there's a name that includes spaces or whatnot, then that should be
some sort of "description" property of the device in sysfs, not the
actual device name.  The actual rfkill device name should be fairly
simple but there's no requirement that it really be human-readable.

I don't think we really need to expose additional properties like a
description or location or anything yet.

>    I am not the right person to come up with answers and guidelines for the
>    above, so I am asking for comments and help.

I would say something like "<type>_sw<X>":

wwan_sw0
wwan_sw1
bluetooth_sw0
wlan_sw0

etc.  I just don't think we really need to be more specific than that,
since sysfs provides all the hierarchy details automatically as long as
the switch is parented to the right device in the driver.

Dan

