Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from avasout08.plus.net ([212.159.14.20]:34274 "EHLO
	avasout08.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab3BLVpG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 16:45:06 -0500
From: Andrew Wasielewski <andrew@wasielewski.co.uk>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: WARNING: at drivers/net/wireless/p54/main.c:443 p54_work+0x66/0x80 [p54common]() (Not tainted)
Date: Tue, 12 Feb 2013 00:04:11 +0000
Message-ID: <2215579.kyTgX4RlnS@localhost.localdomain> (sfid-20130212_224511_858092_EEF73763)
In-Reply-To: <201302071657.12783.chunkeey@googlemail.com>
References: <1732818.7oJIpSJZSL@localhost.localdomain> <2167973.tjlmlbBDaE@localhost.localdomain> <201302071657.12783.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian,

On Thursday 07 February 2013 16:57:12 Christian Lamparter wrote:
> Hello Andrew
> 
> On Thursday, February 07, 2013 12:51:38 AM Andrew Wasielewski wrote:
> > On Wednesday 30 January 2013 01:06:52 Christian Lamparter wrote:
> > > On Wednesday, January 30, 2013 12:04:38 AM Andrew Wasielewski wrote:
> > > > The "failed to update LEDs" messages continued until I rebooted - couldn't find
> > > > a way to reload the stack. O/S is ClearOS Community release 6.3.0 (kernel 2.6.32-279.19.1.v6.i686).
> > > > Hardware is LinkSys WUSB54G running in AP mode using hostapd, firmware isl3886usb.
> > > Reloading the driver (modprobe -r p54usb && modprobe p54usb) or replugging the 
> > > device should have helped. Anyway, the clean "reset" procedure for these devices
> > > is known but to Conexant. If you have sysfs, you can reset a dead usb device
> > > by toggling (writing 0 and then 1 into) /sys/bus/usb/devices/x-y-z/authorized.
> > The "authorized" file doesn't exist in my sysfs
> > > If this helps, we can at least let the driver reset the device automatically
> > > once it bails out. What do you think?
> > 
> > modprobing p54usb works with the driver, but I still have to restart hostapd for
> > it to pick up the now-working driver.  Good news is it hasn't happened again.
> Ah, you should be able to do this automatically. For example with Debian
> (and Ubuntu?) you can add an entry into your /etc/network/interfaces:
> 
> [use tabs]
> allow-hotplug wlan0
> iface wlan0 inet manual
> 	hostapd /etc/hostapd/hostapd.conf
> 	up /sbin/ifconfig "$IFACE" 192.168.0.254 netmask 255.255.255.0 
I don't have /etc/network/interfaces in ClearOS.  Also my wlan0 doesn't have an IP address directly, as it is bridged with wired eth0 in br0.  Can that be accomodated?
> 
> and it will automatically restart hostapd when the device
> is replugged/driver is reloaded.
> [Note: The driver can detect if the firmware is dead. I'm
> thinking about implementing a simple reset-when-dead feature.
> Would you be willing to test it once it materializes? I'm
> asking because I don't have any isl3886usb. Just the PCI
> versions and two isl3887usb].
Happy to test anything you can offer.  Some of us citizens are are with y'all the way officer.  However is there any way to trigger / simulate firmware failure, as it doesn't happen very often (fortunately) by itself.
> 
> > Unplugging is tricky as I have slightly hacked the WUSB54G to fit inside the case
> > (an old Shuttle mini-PC) with a SMA-RP connector and a decent antenna.  In fact the
> > main reason I went for the WUSB54G is because this conversion seemed quite easy.  
> > I am open to any suggestions for USB devices with b/g/n(?) support that could be
> > internally mounted in this way, + has AP mode support of course.
> Ah, well the USB + AP requirement is sort of a problem. Usually everyone favourit
> and well-tested WiFi-AP is some sort of a PCI or PCIe solution. But still, there 
> are a few alternatives. The most popular are based on:
>  - ath9k_htc 
>  - rt2800usb
> 
> Unfortunately, I can't tell if they are adequate for your needs. Some
> people have posted "stability comparision" between those. But I can't
> find any from recent times. Of course, if you are curious and don't mind
> spending 1-10 GBP [per device], you can do your own little experiments
> about cheap USB+AP solutions. I'm sure other people would be interested
> in the results too [that's a hint ;)].
If I come across anything that looks viable I can test it.  If I can find a MicroATX M/b that will fit the Shuttle case I will upgrade - ideally one with a PCIe slot for wireless and PCI for the ADSL2+ card.  It's a FN41V3 if anyone has any suggestions.
> 
> Regards
> 
> Christian
Regards,
Andrew
