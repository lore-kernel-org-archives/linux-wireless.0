Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4495 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbYEPPU5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 11:20:57 -0400
Date: Fri, 16 May 2008 11:08:24 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stefanik =?iso-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: Martin Dubuc <martind1111@gmail.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] Monitor mode on boot
Message-ID: <20080516150824.GB6510@tuxdriver.com> (sfid-20080516_172100_831309_930F3D53)
References: <7a0107ba0805151404o778a09ddj522fffa3edbeec6@mail.gmail.com> <69e28c910805160316q7c1b869an7fd554979ea260b8@mail.gmail.com> <7a0107ba0805160627l55f53b04r69a32e1bba36ecb6@mail.gmail.com> <69e28c910805160703j4fef73e8x2c357f91d4b43ea5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <69e28c910805160703j4fef73e8x2c357f91d4b43ea5@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 16, 2008 at 04:03:15PM +0200, Stefanik G=E1bor wrote:
> On Fri, May 16, 2008 at 3:27 PM, Martin Dubuc <martind1111@gmail.com>=
 wrote:
>=20
> > You are right pointing out that it is possible to perform monitor m=
ode
> > configuration using startup scripts. However, to fit nicely in exis=
ting
> > frameworks, such as the ones available from Fedora, it would be nic=
e that
> > the driver be enhanced. Madwifi allows users to put a configuration=
 like
> > this one in the modprobe.conf.:
> >
> > options ath_pci autocreate=3Dmonitor
> >
> > The nice thing about such a configuration is that it decouples the =
device
> > type configuration from the interface management function. One does=
 not need
> > to worry which interface (wlan0, wlan1, wlan2, etc.) a device will =
come up
> > on, the system configures any device of a given type using a common=
 set of
> > configuration. For systems that have only one Wi-Fi device, your me=
thod is
> > as good as this one, but for systems that have more than one Wi-Fi =
device,
> > some of them coming off and on while the system is running, possibl=
y using
> > different interface names, the modprobe.conf solution is better.
> >
> > Martin
> >
> >
> This might better be done in the stack, rather than the driver. This =
way,
> all drivers would get this functionality. CCing the linux-wireless ma=
iling
> list.

In general I think we would like to avoid module options, especially
in cases where the userland equivalent is easily accomplished.
But if this is truly warranted it would make more sense to put it
into mac80211 than into an individual driver.

Why would you want to automatically create several monitor interfaces
on the same box?  Won't this usually be more-or-less redundant?

> Also, since an userspace solution might be preferred by Linville and =
the
> other wireless maintainers, it might be wise to add an "aggregate dev=
ice" or
> a "supermaster" which can be targeted by iw so that all devices gover=
ned by
> that driver get a new interface.

Gack!  The last thing I would want to see is more magical netdevs
with mysterious purposes...

> Alternatively, a script can be made that creates a monitor interface =
on monX
> or rtapX for all wmasterX devices. This is equivalent to madwifi's so=
lution,
> except that it's userspace, which is preferred now.

The scripts later in the thread seem simple enough.  Do they suffice?

John
--=20
John W. Linville
linville@tuxdriver.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
