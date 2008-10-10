Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53367 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759869AbYJJQak (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 12:30:40 -0400
Subject: Re: [stable] [PATCH v2.6.27] mac80211: fix two issues in debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg KH <greg@kroah.com>
Cc: stable <stable@kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <20081010160157.GA26323@kroah.com>
References: <1223653970.3748.23.camel@johannes.berg>
	 <20081010160157.GA26323@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8NIG4w+6W6tIT1wwDhYQ"
Date: Fri, 10 Oct 2008 18:30:32 +0200
Message-Id: <1223656232.3748.28.camel@johannes.berg> (sfid-20081010_183044_772001_82173FDA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8NIG4w+6W6tIT1wwDhYQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-10 at 09:01 -0700, Greg KH wrote:
> On Fri, Oct 10, 2008 at 05:52:49PM +0200, Johannes Berg wrote:
> > This fixes RHBZ 466264, whenever the master interface is
> > renamed this code would BUG_ON. Also fixes a separately
> > reported bug with the debugfs dir being NULL.
> >=20
> > This patch is not applicable to the next kernel version
> > because both these issues have been fixed, the first one
> > by not having the master interface have a ieee80211_ptr
> > at all, and the second one by also leaving the function
> > early.
>=20
> So this will not be going into .28, right?=20

No, it won't, the code has changed in ways that won't make this happen
any more. The fix with the (!dir) part is on it's way, I could split
that out separately if you'd like, but then we'd have to fix up the
rejects because that patch looks different too even though the result
will be very similar.

>  What -stable trees should it
> go to, .27?  .26?  .25?

Good question. The latter fix with (!dir) applies to .26 as well, but
the issue is hit so infrequently (only when adding the debugfs dir has
failed before) that I'm not sure it's worth it. And the master interface
issue isn't present before .27.

johannes

--=-8NIG4w+6W6tIT1wwDhYQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI74MkAAoJEKVg1VMiehFYk8IQALar3jJ+osl6r6vNk8OiW7cZ
iv73r8DHuNK7VeJV2VZ2u7cyY2Qya9M2peBnPGG6WnPZ2gtS4wdYVYQ+hTcn3N+B
gGwCyXn9kJkGP+l9EjndL4TLReQbMgVFWe36iF7BWRy7Xlb7w1ZJhphN5X5PzWgC
ILay+7cNWsCfLSD75cWdwuIZHCZNfY8IPHc2bFTnvTZ6QCqRM7w55MNRI9WXVrot
gPSPo4ck6XyM1fYnqmvAdvzUJFXtMTHZpyDMzrOLIVa2UgC4r7m0tnt+qmgwfzzI
jE3XzTFmxglmDuZH9jmyYe/LrBHF/P9YnTmOeEmvmublEMk7hfAAVwqxMXch2kjC
Hse5ADsmgEPInoPxOyAGsemmvAVxUuv7RDAwkTfhWgX11JFnMUhV7C/hQlVAxDo1
1uMBUJp0A5HDNTLEkbc8JMdr0BLWLqa9kpEtsKo2OCqZGaqNKWD+hmXGMlNUNZVj
TU1JOtEh3buFDXNpKKI13C4H/QmQ63LwC4ndasF1f3U8+wAx9kfD4xmDRivcB7DX
LakidLUpr+VRM5Orndef4R/nqtpI371EQBsY44wosZ/JKSG8r1NIVkA0gimAzbnQ
V163XqKzPMQWYhf+t2Ukge4Oz84iJob8JGyc/msQRUKOMSapw4TzkLpvO+fv45bn
K4lF3vifqAnUgC0+7iaq
=WO9G
-----END PGP SIGNATURE-----

--=-8NIG4w+6W6tIT1wwDhYQ--

