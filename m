Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22054 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbZDGXIW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 19:08:22 -0400
Subject: Re: iwlagn preventing hibernation with TuxOnIce
From: reinette chatre <reinette.chatre@intel.com>
To: Mathias =?ISO-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <8ccc1dbe0904071409k61daaf47t2261e3cfc48615be@mail.gmail.com>
References: <8ccc1dbe0904061150w18d38193v772492e480f0aa15@mail.gmail.com>
	 <8ccc1dbe0904061216m1e31aaf4j53b0c067b9e19999@mail.gmail.com>
	 <1239125023.16010.33.camel@rc-desk>
	 <8ccc1dbe0904071409k61daaf47t2261e3cfc48615be@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 07 Apr 2009 16:14:10 -0700
Message-Id: <1239146050.29937.11.camel@rc-desk> (sfid-20090408_010827_122917_D6124013)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mathias,

(please cc mailing list on your response)

On Tue, 2009-04-07 at 14:09 -0700, Mathias Bur=C3=A9n wrote:
>=20
>=20
> 2009/4/7 reinette chatre <reinette.chatre@intel.com>
>         Mathias,
>        =20
>         On Mon, 2009-04-06 at 12:16 -0700, Mathias Bur=C3=A9n wrote:
>         > Hi,
>         >
>         > I think I've found a bug. Either it's iwlagn or it's
>         TuxOnIce, I'll
>         > try here first. Whenever my wlan0 interfaces is up, TuxOnIc=
e
>         causes a
>         > kernel panic
>        =20
>        =20
>         Does this mean you do not get a kernel panic if your wlan0
>         interface is
>         down? Does it matter whether iwlagn module is loaded or not,
>         or just
>         interface being up or down? Does it happen during hibernate o=
r
>         when you
>         resume?
>        =20
>=20
> Yes, if I ifdown wlan0 before hibernation all goes well. It does not
> matter if iwlagn is loaded or not. This is only during hibernation,
> resume works fine (although I have to hibernate with wlan0 down first
> of course in order to resume from anything).
>=20
> I tried to hibernate from gnome just now, and it seemingly stops at
> the same step as before (writing kernel and process data). I can see
> the SSD work (probably writes the image) for a while, then all goes
> silent. However, TuxOnIce responds to the keyboard because if I press
> escape it changes the text to "aborting hibernation", but nothing
> happens, just sits there with the text.
>=20
> This time I didn't get a panic (that I could see), but the computer
> shut itself off after about a minute (normal hibernation takes about =
4
> seconds), and just before the poweroff I saw this: received netlink
> error: invalid argument. I have no idea if it's related.
> =20
>=20
>        =20
>         > when it's 'writing kernel and process information', after
>         > a while I get a backtrace (?) about something with sda (my
>         SSD). I was
>         > first using iwlagn from 2.6.29 but I just installed
>         > compat-wireless-2009-04-06 and it made no difference.
>         >
>         > Hardware being used:
>         > Dell Inspiron 1520
>         >
>         > iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux,
>         1.3.27ks
>         > iwlagn: Copyright(c) 2003-2009 Intel Corporation
>         > iwlagn 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IR=
Q
>         17
>         > iwlagn 0000:0c:00.0: setting latency timer to 64
>         > iwlagn 0000:0c:00.0: Detected Intel Wireless WiFi Link
>         4965AGN REV=3D0x4
>         > iwlagn 0000:0c:00.0: Tunable channels: 13 802.11bg, 19
>         802.11a channels
>         > iwlagn 0000:0c:00.0: irq 29 for MSI/MSI-X
>         > phy0: Selected rate control algorithm 'iwl-agn-rs'
>         > iwlagn 0000:0c:00.0: firmware: requesting
>         iwlwifi-4965-2.ucode
>         > iwlagn 0000:0c:00.0: loaded firmware version 228.57.2.23
>         > Registered led device: iwl-phy0::radio
>         > Registered led device: iwl-phy0::assoc
>         > Registered led device: iwl-phy0::RX
>         > Registered led device: iwl-phy0::TX
>         >
>         > Vanilla 2.6.29.1 kernel with TuxOnIce patch, fs for / is
>         ext4, using
>         > the deadline scheduler. Kernel configuration at [1]. dmesg
>         at [2].
>        =20
>        =20
>         The dmesg does not contain any panic or errors related to
>         iwlagn that I
>         can see.
>        =20
>=20
> I thought about that, how can I provide a logfile for a system crash?
> Nothing gets written in any logs what I can see. I don't have another
> machine to debug with unfortunately. (was thinking logging to serial
> or whatever)

You can try serial console (if you have one) or netconsole. You can als=
o
try to get syslog to log things for you with a request that it syncs
after every write (you surely do not want this enabled always).
Something like this in your syslog.conf:
kern.*		/var/log/kern.log

Reinette

>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
