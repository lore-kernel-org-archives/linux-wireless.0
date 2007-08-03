Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40294 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762797AbXHCPTK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 11:19:10 -0400
Subject: Re: [PATCH 18/24] rt2x00: Add Multicast/Broadcast filtering
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200708031709.39208.IvDoorn@gmail.com>
References: <200707312037.33060.IvDoorn@gmail.com>
	 <1186149676.4647.42.camel@johannes.berg>
	 <200708031709.39208.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4b/hSEIuBmyfcdypdkwT"
Date: Fri, 03 Aug 2007 17:20:35 +0200
Message-Id: <1186154435.4647.50.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4b/hSEIuBmyfcdypdkwT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-03 at 17:09 +0200, Ivo van Doorn wrote:
> On Friday 03 August 2007, Johannes Berg wrote:
> > On Tue, 2007-07-31 at 20:37 +0200, Ivo van Doorn wrote:
> >=20
> > > +	if (is_monitor_present(intf)) {
> > > +		filter =3D IFF_PROMISC | IFF_MULTICAST | IFF_BROADCAST;
> > > +		if (intf->filter !=3D filter)
> > > +			__set_bit(PACKET_FILTER_PENDING, &rt2x00dev->flags);
> > > +	}
> >=20
> > Don't do that. There's no requirement that monitor mode interfaces
> > always be promisc. Also, earlier in the code:
>=20
> Note that this "Enable promisc" on monitor mode here will only be send to
> the device. It does not mean that the non-monitor mode will have promisc
> mode enabled. In fact, when the monitor interface goes down, the normal
> setting will be used again.
> If with monitor mode, IFF_PROMISC is not send to the device, monitor
> mode is useless since it will not catch anything except beacons
> (Especially true when you only have 1 interface which is in monitor mode)

But don't you allow monitoring during operation? In that case this would
make that monitor interface always promisc which isn't what you want
unless you set the promisc bit on any of the interfaces.

johannes

--=-4b/hSEIuBmyfcdypdkwT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGs0fC/ETPhpq3jKURAmyLAJ4jmk5Dkd102FGrYpaVjziF3lT2igCguxbQ
T6s6mq/OdSbi4R70NZ9m/uI=
=fiYw
-----END PGP SIGNATURE-----

--=-4b/hSEIuBmyfcdypdkwT--

