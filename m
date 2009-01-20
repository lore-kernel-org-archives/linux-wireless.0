Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:42818 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755928AbZATUGe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 15:06:34 -0500
Date: Tue, 20 Jan 2009 12:05:15 -0800
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
Cc: Paul Hickey <paul@christianpatriot.us>, stable@kernel.org,
	Kyle McMartin <kyle@mcmartin.ca>,
	linux-wireless@vger.kernel.org,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [stable] Failed Build of modules for 2.6.27.9-159
Message-ID: <20090120200515.GA5077@kroah.com> (sfid-20090120_210639_214303_4759E2BB)
References: <1232319854.4596.1.camel@localhost.localdomain> <20090119191138.GA4018@tesla> <1232404986.3641.2.camel@localhost.localdomain> <20090120000336.GB4018@tesla> <1232433738.3696.3.camel@localhost.localdomain> <20090120194243.GC19581@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20090120194243.GC19581@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 20, 2009 at 11:42:43AM -0800, Luis R. Rodriguez wrote:
> On Mon, Jan 19, 2009 at 10:42:18PM -0800, Paul Hickey wrote:
> > Hi Luis,
> >=20
> > 2.6.27.9-159.fc10.x86_64 is the kernel. I burned the distro right f=
rom
> > Fedora.
>=20
> I am =FCber-surprised to hear that FC10 2.6.27 kernels have added
> pci_ioremap_bar() in their kernel header include/linux/pci.h. I
> have verified this by checking:
>=20
> http://download.fedora.redhat.com/pub/fedora/linux/updates/10/x86_64/=
kernel-devel-2.6.27.9-159.fc10.x86_64.rpm
>=20
> I have checked upstrea 2.6.27.9 and even 2.6.27.12 and they do not ha=
ve this. This breaks
> compatibility projects like compat-wireless :(

compatibility projects should be checking for the absense or presence o=
f
specific functions, not triggering off of kernel release numbers :)

> > Also, the ForceXPA might not be a problem, but it makes and logs it=
s
> > attempts 4X per minute. It may not be much of an impact on the CPU,=
 but
> > is it necessary? Plus the message log gets really long really fast.
>=20
> Good point, hopefully this is enough of an argument to make the patch
> go into 2.6.27. The patch is already in for >=3D 2.6.28.
>=20
> Greg -- there is an annoying message that gets printed very often
> when new Atheros 11n cards are used, this is printed upon hw reset
> which occurs on channel changes (scans) and as such happens quite
> often. The message was moved to print only when "EEPROM debugging"
> was enaabled through upstream commit f1dc56003b23d2d5bb5a756de6b1633a=
76c9e697.
> Unfortunately this commit is pretty large as it refactored hw.c into
> separate files. Below is a small one line patch that changes this. Pl=
ease
> let me know if this is OK for 2.6.27.x

Looks good to me, I'll queue it up for the next .27 release.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
