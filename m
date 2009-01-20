Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:45831 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755312AbZATUSS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 15:18:18 -0500
Date: Tue, 20 Jan 2009 12:16:13 -0800
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Paul Hickey <paul@christianpatriot.us>,
	"stable@kernel.org" <stable@kernel.org>,
	Kyle McMartin <kyle@mcmartin.ca>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [stable] Failed Build of modules for 2.6.27.9-159
Message-ID: <20090120201613.GA5313@kroah.com> (sfid-20090120_211824_488825_2A2EF1D2)
References: <1232319854.4596.1.camel@localhost.localdomain> <20090119191138.GA4018@tesla> <1232404986.3641.2.camel@localhost.localdomain> <20090120000336.GB4018@tesla> <1232433738.3696.3.camel@localhost.localdomain> <20090120194243.GC19581@tesla> <20090120200515.GA5077@kroah.com> <20090120201316.GG19581@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20090120201316.GG19581@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 20, 2009 at 12:13:16PM -0800, Luis R. Rodriguez wrote:
> On Tue, Jan 20, 2009 at 12:05:15PM -0800, Greg KH wrote:
> > On Tue, Jan 20, 2009 at 11:42:43AM -0800, Luis R. Rodriguez wrote:
> > > On Mon, Jan 19, 2009 at 10:42:18PM -0800, Paul Hickey wrote:
> > > > Hi Luis,
> > > >
> > > > 2.6.27.9-159.fc10.x86_64 is the kernel. I burned the distro rig=
ht from
> > > > Fedora.
> > >
> > > I am =FCber-surprised to hear that FC10 2.6.27 kernels have added
> > > pci_ioremap_bar() in their kernel header include/linux/pci.h. I
> > > have verified this by checking:
> > >
> > > http://download.fedora.redhat.com/pub/fedora/linux/updates/10/x86=
_64/kernel-devel-2.6.27.9-159.fc10.x86_64.rpm
> > >
> > > I have checked upstrea 2.6.27.9 and even 2.6.27.12 and they do no=
t have this. This breaks
> > > compatibility projects like compat-wireless :(
> >=20
> > compatibility projects should be checking for the absense or presen=
ce of
> > specific functions, not triggering off of kernel release numbers :)
>=20
> How can I do that? #ifdef no worky on static inlines, for example.

You can automatically test if the feature is there, right?  If so, then
set your own #define for your compatiblity wrappers.

> BTW are you saying the above practice of adding new stuff to headers
> is OK too? I wish it wasn't...

Sure it's ok, distros can do whatever they want in their kernels, are
you telling them that they are now not allowed to do that?  :)

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
