Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60813 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760833AbXHCOtf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 10:49:35 -0400
Subject: Re: [PATCH stable] softmac: Fix deadlock of wx_set_essid with  assoc work
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: stable@kernel.org, John Linville <linville@tuxdriver.com>,
	David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200708031250.51161.mb@bu3sch.de>
References: <200708011253.06569.mb@bu3sch.de>
	 <1186092127.4647.10.camel@johannes.berg>  <200708031250.51161.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-itOxmwI+zZrL3B2ifZZy"
Date: Fri, 03 Aug 2007 16:49:11 +0200
Message-Id: <1186152551.4647.46.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-itOxmwI+zZrL3B2ifZZy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-03 at 12:50 +0200, Michael Buesch wrote:
> On Friday 03 August 2007 00:02:07 Johannes Berg wrote:
> > Adding to my previous mail, this fix is not enough. As you can see
> > below, it is never safe to call flush_scheduled_work() under rtnl
> > because some other things running *from* the global events workqueue
> > acquire the rtnl and hence it we could deadlock against them.
> >=20
> > I think the fix would be to use cancel_delayed_work_sync() here instead
> > of a combination of cancel_delayed_work() and flush_workqueue().
>=20
> Ah, Ok. I didn't see that rtnl is locked there, too.

Well, it's a wireless extensions call...

> cancel_delayed_work_sync could probably work. Care to test that?

I can give it a try next week.

johannes

--=-itOxmwI+zZrL3B2ifZZy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGs0Bn/ETPhpq3jKURAlw1AJ4hm0X90L7nxRu99Hu5XnMe0pGPSACcCrbx
Cy2wAYaCMbvoSvIEWFUPrpM=
=FzWV
-----END PGP SIGNATURE-----

--=-itOxmwI+zZrL3B2ifZZy--

