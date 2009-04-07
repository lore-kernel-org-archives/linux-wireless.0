Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:14338 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbZDGRR4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 13:17:56 -0400
Subject: Re: iwlagn preventing hibernation with TuxOnIce
From: reinette chatre <reinette.chatre@intel.com>
To: Mathias =?ISO-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <8ccc1dbe0904061216m1e31aaf4j53b0c067b9e19999@mail.gmail.com>
References: <8ccc1dbe0904061150w18d38193v772492e480f0aa15@mail.gmail.com>
	 <8ccc1dbe0904061216m1e31aaf4j53b0c067b9e19999@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 07 Apr 2009 10:23:43 -0700
Message-Id: <1239125023.16010.33.camel@rc-desk> (sfid-20090407_191800_500043_CAF05AF7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mathias,

On Mon, 2009-04-06 at 12:16 -0700, Mathias Bur=C3=A9n wrote:
> Hi,
>=20
> I think I've found a bug. Either it's iwlagn or it's TuxOnIce, I'll
> try here first. Whenever my wlan0 interfaces is up, TuxOnIce causes a
> kernel panic=20

Does this mean you do not get a kernel panic if your wlan0 interface is
down? Does it matter whether iwlagn module is loaded or not, or just
interface being up or down? Does it happen during hibernate or when you
resume?

> when it's 'writing kernel and process information', after
> a while I get a backtrace (?) about something with sda (my SSD). I wa=
s
> first using iwlagn from 2.6.29 but I just installed
> compat-wireless-2009-04-06 and it made no difference.
>=20
> Hardware being used:
> Dell Inspiron 1520
>=20
> iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
> iwlagn: Copyright(c) 2003-2009 Intel Corporation
> iwlagn 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> iwlagn 0000:0c:00.0: setting latency timer to 64
> iwlagn 0000:0c:00.0: Detected Intel Wireless WiFi Link 4965AGN REV=3D=
0x4
> iwlagn 0000:0c:00.0: Tunable channels: 13 802.11bg, 19 802.11a channe=
ls
> iwlagn 0000:0c:00.0: irq 29 for MSI/MSI-X
> phy0: Selected rate control algorithm 'iwl-agn-rs'
> iwlagn 0000:0c:00.0: firmware: requesting iwlwifi-4965-2.ucode
> iwlagn 0000:0c:00.0: loaded firmware version 228.57.2.23
> Registered led device: iwl-phy0::radio
> Registered led device: iwl-phy0::assoc
> Registered led device: iwl-phy0::RX
> Registered led device: iwl-phy0::TX
>=20
> Vanilla 2.6.29.1 kernel with TuxOnIce patch, fs for / is ext4, using
> the deadline scheduler. Kernel configuration at [1]. dmesg at [2].

The dmesg does not contain any panic or errors related to iwlagn that I
can see.=20

>=20
> Is there any way you could help me debug this? Thanks,

We can start with iwlagn debugging. Please recompile your driver with
debugging enabled and then load it with "modprobe iwlagn
debug=3D0x43fff".=20

>=20
> Mathias
>=20
>=20
> [1] http://rafb.net/p/qWvmzl19.html
> [2] http://rafb.net/p/3c2Nuw14.html
> --

Reinette

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
