Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:11837 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597AbZATV6E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 16:58:04 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2009 13:58:04 -0800
Date: Tue, 20 Jan 2009 13:21:56 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Kyle McMartin <kyle@infradead.org>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Paul Hickey <paul@christianpatriot.us>,
	"stable@kernel.org" <stable@kernel.org>,
	Kyle McMartin <kyle@mcmartin.ca>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Failed Build of modules for 2.6.27.9-159
Message-ID: <20090120212156.GK19581@tesla> (sfid-20090120_225811_809231_E55D6AC7)
References: <1232319854.4596.1.camel@localhost.localdomain> <20090119191138.GA4018@tesla> <1232404986.3641.2.camel@localhost.localdomain> <20090120000336.GB4018@tesla> <1232433738.3696.3.camel@localhost.localdomain> <20090120194243.GC19581@tesla> <20090120211246.GD17452@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20090120211246.GD17452@bombadil.infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 20, 2009 at 01:12:46PM -0800, Kyle McMartin wrote:
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
> >
> > Kyle?
> >
>=20
> F10 will be going to 2.6.28 within a few days... but honestly, if peo=
ple
> are going to using out of tree wireless (which is what they're doing,
> even if it's going upstream, it's not there now)=20

This stuff just pulls directly from wireless-testing BTW, the rest is j=
ust compat crap
to get it to work on older kernels.

> why can't they just
> build their own kernel too?

Because it involves a lot more work, just getting initrds to work prope=
rly these
days in distributions tends to be a real big pain in the ass for the no=
vice user.
Upgrading a user's wireless subsystem by simply typing in

make
sudo make install

Is a lot easier than trying to get them to wrap their brain around how =
to compile
and successfully install a new kernel. Additionally some project like o=
penwrt seem
to find it a lot more useful than bumping their entire kernel. 16 GB wo=
rth of
downloads of compat-wireless seems to indicate some people find it a re=
asonable
alternative. Its the only reason why I still maintain it.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
