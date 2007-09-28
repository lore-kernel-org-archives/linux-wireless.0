Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46999 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbXI1K55 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2007 06:57:57 -0400
Subject: Re: hostapd: passing sta info struct to drivers?
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070928011630.GI27241@jm.kir.nu>
References: <1190911599.5021.4.camel@johannes.berg>
	 <20070928011630.GI27241@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vToFq+Dof9/5L5lsgX3C"
Date: Fri, 28 Sep 2007 12:59:17 +0200
Message-Id: <1190977157.5021.28.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vToFq+Dof9/5L5lsgX3C
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-09-27 at 18:16 -0700, Jouni Malinen wrote:

> > During porting the STA management to nl80211 it turned out that it woul=
d
> > be much nicer in the kernel if we would always set all the flags on a
> > STA that the kernel needs to get from hostapd.
>=20
> That I might be able to support at least partially by merging together
> some operations, but still, I would expect there to be valid scenarios
> where it would be useful to be able to just toggle a single flag.

Are there really? I can only see three flags in the kernel being set by
hostapd, those being "authorized", "wme capable" and "shortslot
capable". Some additional flags for the userspace MLME maybe, I need to
look into that later.
Hence, I don't see any place where we'd ever need to set a single flag,
we need to keep track of all those flags anyway.

It is certainly possible to have selective flags updating but I don't
quite see the point.

> This is not going to happen. struct sta_info (the one in hostapd) is
> internal for the core implementation and the driver wrappers should
> never touch it directly, i.e., pointer to this is not passed on purpose.
> If changes to the operation between the driver wrapper and kernel is
> desired, it will need to be done in a different way.

Ok. I'm still thinking about the best way to do VLAN/STA finding but I
may just do that by the AP interface VLANs are tied to. Then the only
thing I really need changed is the above flags change.

johannes

--=-vToFq+Dof9/5L5lsgX3C
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG/N6F/ETPhpq3jKURAvyzAJoDUqGWzQlg+hnci+JlEuuuGWBE6QCgrYeL
7ieoYWnIBFZ1uiY77o+VTd0=
=uM6n
-----END PGP SIGNATURE-----

--=-vToFq+Dof9/5L5lsgX3C--

