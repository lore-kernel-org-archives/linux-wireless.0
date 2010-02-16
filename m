Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:40989 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756741Ab0BPXZJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 18:25:09 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1NhWmu-0004i5-Ll
	for linux-wireless@vger.kernel.org; Wed, 17 Feb 2010 00:25:04 +0100
Received: from xdsl-87-79-183-208.netcologne.de ([87.79.183.208])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 00:25:04 +0100
Received: from jm.mico by xdsl-87-79-183-208.netcologne.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 00:25:04 +0100
To: linux-wireless@vger.kernel.org
From: juanma <jm.mico@gmail.com>
Subject: Re: ath9k/AR9285 - incompatibility with bluetooth
Date: Tue, 16 Feb 2010 23:15:07 +0000 (UTC)
Message-ID: <loom.20100217T000412-571@post.gmane.org>
References: <1263494975.4643.15.camel@eclipse>  <1263492165.31774.13.camel@localhost.localdomain> <1263498975.4643.61.camel@eclipse>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Alberto José Rodríguez Rodríguez <ajrodriguez@...> writes:

> 
> Thanks for your response. I made this question because
> while this device loses the connection, on my laptop, with the same
> bluetooth device, the connection is not affected.
> 
>  03:00.0 Network controller: Intel Corporation Wireless WiFi Link 5100
> 
Hello Alberto,

I do not think your wlan problem is (only) because of Bluetooth interfering with
Wlan.

I have a Zotac Mag (with an Ath9k, and looks like the current implementation of
the drivers are pretty bad. I am having the same issues (very low signal, very
low speed and iregular connections). I do not have any bluetooth dongle.

After reading a lot, looks like kernel 6.2.32 improves it (comes with Ubuntu
Lucid Linx in April), as well as backports.

For me, backports have not improved it much, but the kernel 6.2.32 yes. Speed is
still lower than expected, signal also, but the reliability of the connection is
improved. 

What I have done is use ndiswrapper with the drivers for XP which are to be
found on the Zotac website.

I hope this helped.

Un saludo,

Juanma.

MY WLAN ADAPTER: 04:00.0 Network controller: Atheros Communications Inc. AR9285
Wireless Network Adapter (PCI-Express) (rev 01)

> El jue, 14-01-2010 a las 10:02 -0800, Dan Williams escribió:
> > On Thu, 2010-01-14 at 18:49 +0000, Alberto José Rodríguez Rodríguez
> > wrote:
> > > Hellow,
> > > 	I have a ZOTAC MAG ION and I'm having problems with wireless
> > > connections
> > > 
> > > Distribution: Ubuntu 9.10
> > > Kernel version: 2.6.31-16
> > > Device: 04:00.0 Network controller: Atheros Communications Inc. AR9285
Wireless Network Adapter
> (PCI-Express) (rev 01)
> > > Problem Description:
> > >     - Low signal strength
> > >     - Cannot connect to wireless networks
> > > Using linux-backports-modules-karmic:
> > >     - Low signal strength persists
> > >     - Can connect to WPA networks but signal strengh is low and unstable,
also when using at the same time a
> Bluetooth USB dongle (continuously inquiring) the wireless connection is lost.
> > >     - Cannot connect to WEP networks, although the WEP key is set
correctly and the device is associated to the AP
> > > Using latest linux-wireless snapshot (20100113):
> > >     - Can connect to WEP networks but when I use at the same time a
Bluetooth USB dongle (continuously
> inquiring) the speed of the wireless connection becomes very slow.
> > >     - Can connect to WPA networks but when I use at the same time a
Bluetooth USB dongle (continuously
> inquiring) the wireless connection is lost.
> > 
> > This isn't unexpected; Bluetooth and WiFi interfere with each other
> > because they both use 2.4GHz.  So don't expect great performance out of
> > either BT or WiFi when you're using both at the same time.  Many
> > built-in chips have BT co-existence capability, but that only works if
> > both the WiFi and BT chips are built into your computer and are wired up
> > to talk to each other.  External USB BT or WiFi dongles almost certainly
> > will not have working coexistence support.
> > 
> > Dan
> > 
> > 




