Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:35375 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965955AbZLHUHH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 15:07:07 -0500
Subject: Re: wireless device and udev
From: Marcel Holtmann <marcel@holtmann.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-hotplug@vger.kernel.org
In-Reply-To: <43e72e890912081050w265bcbc1sd1380ef52fc0799b@mail.gmail.com>
References: <20091207172616.7470ed2b@nehalam>
	 <20091208142940.GB15172@tuxdriver.com>  <20091208104336.3d5a7fb4@nehalam>
	 <43e72e890912081050w265bcbc1sd1380ef52fc0799b@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Dec 2009 21:07:08 +0100
Message-ID: <1260302828.2901.17.camel@violet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

> >> > The default udev persistent network rules based on hardware mac id doesn't
> >> > work well when multiple SSID's are created on an access-point.  The command
> >> >  iw phy phy0 interface add wlan1 type managed
> >> >
> >> > is supposed to make a device name wlan1, but udev sees that it has the same
> >> > mac address as wlan0 and gets confused leaving the device named wlan1_rename
> >> >
> >> > It looks like wlanX is breaking assumptions of existing udev persistent network
> >> > device name generation rules.  Perhaps there needs to be special case for wlanX
> >> > devices?
> >>
> >> Yes, probably so.  But what would it be?  Factoring-in SSID is clearly
> >> not right for the usual case (i.e. one interface on a mobile device).
> >> I'm not sure what else one could use as a key.
> >>
> >> What does udev do for bridge, bond, or vlan devices?  Don't those
> >> share MAC addresses with the underlying physical device?
> >>
> >> John
> >
> > At least on ubuntu/debian the name whitelist is:
> >
> >
> > # device name whitelist
> > KERNEL!="eth*|ath*|wlan*[0-9]|msh*|ra*|sta*|ctc*|lcs*|hsi*", GOTO="persistent_net_generator_end"
> >
> > So bond or bridge don't match and don't get tampered with.
> >
> > The problem is that wlan* device names are used for both hardware and virtual
> > devices.  Udev scripts can be fixed "do the right thing" but there is not sufficient
> > information for the script to decide how to attach persistent name.
> > What values from sysfs (ie attributes) should script be using?  This probably
> > means that additional attributes needed to be added to wireless device infrastructure
> > in kernel.
> 
> We could likely use the new SET_NETDEV_DEVTYPE() but I have yet to see
> where this is exported. It must be there somewhere.

they are part of the uevent the kernel sends. It will have the DEVTYPE
value there. However this has to be exactly the hardware type and in
both cases it will be "wlan" and has to be. The analogy that works here
is similar to partitions and disks in the storage world. We have just
different kinds of network interfaces.

Regards

Marcel


