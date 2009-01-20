Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:56847 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756814AbZATUNv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 15:13:51 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2009 12:13:51 -0800
Date: Tue, 20 Jan 2009 12:13:16 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Greg KH <greg@kroah.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Paul Hickey <paul@christianpatriot.us>,
	"stable@kernel.org" <stable@kernel.org>,
	Kyle McMartin <kyle@mcmartin.ca>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [stable] Failed Build of modules for 2.6.27.9-159
Message-ID: <20090120201316.GG19581@tesla> (sfid-20090120_211355_760128_F2F269CB)
References: <1232319854.4596.1.camel@localhost.localdomain> <20090119191138.GA4018@tesla> <1232404986.3641.2.camel@localhost.localdomain> <20090120000336.GB4018@tesla> <1232433738.3696.3.camel@localhost.localdomain> <20090120194243.GC19581@tesla> <20090120200515.GA5077@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20090120200515.GA5077@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 20, 2009 at 12:05:15PM -0800, Greg KH wrote:
> On Tue, Jan 20, 2009 at 11:42:43AM -0800, Luis R. Rodriguez wrote:
> > On Mon, Jan 19, 2009 at 10:42:18PM -0800, Paul Hickey wrote:
> > > Hi Luis,
> > >
> > > 2.6.27.9-159.fc10.x86_64 is the kernel. I burned the distro right=
 from
> > > Fedora.
> >
> > I am =FCber-surprised to hear that FC10 2.6.27 kernels have added
> > pci_ioremap_bar() in their kernel header include/linux/pci.h. I
> > have verified this by checking:
> >
> > http://download.fedora.redhat.com/pub/fedora/linux/updates/10/x86_6=
4/kernel-devel-2.6.27.9-159.fc10.x86_64.rpm
> >
> > I have checked upstrea 2.6.27.9 and even 2.6.27.12 and they do not =
have this. This breaks
> > compatibility projects like compat-wireless :(
>=20
> compatibility projects should be checking for the absense or presence=
 of
> specific functions, not triggering off of kernel release numbers :)

How can I do that? #ifdef no worky on static inlines, for example.

BTW are you saying the above practice of adding new stuff to headers
is OK too? I wish it wasn't...

> > > Also, the ForceXPA might not be a problem, but it makes and logs =
its
> > > attempts 4X per minute. It may not be much of an impact on the CP=
U, but
> > > is it necessary? Plus the message log gets really long really fas=
t.
> >
> > Good point, hopefully this is enough of an argument to make the pat=
ch
> > go into 2.6.27. The patch is already in for >=3D 2.6.28.
> >
> > Greg -- there is an annoying message that gets printed very often
> > when new Atheros 11n cards are used, this is printed upon hw reset
> > which occurs on channel changes (scans) and as such happens quite
> > often. The message was moved to print only when "EEPROM debugging"
> > was enaabled through upstream commit f1dc56003b23d2d5bb5a756de6b163=
3a76c9e697.
> > Unfortunately this commit is pretty large as it refactored hw.c int=
o
> > separate files. Below is a small one line patch that changes this. =
Please
> > let me know if this is OK for 2.6.27.x
>=20
> Looks good to me, I'll queue it up for the next .27 release.

Awesome thanks.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
