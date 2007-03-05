Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50480 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933168AbXCELeg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2007 06:34:36 -0500
Subject: Re: Question about PRISM2 header rate field
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Andy Green <andy@warmcat.com>, linux-wireless@vger.kernel.org
In-Reply-To: <200703042210.52534.flamingice@sourmilk.net>
References: <45EA9E39.6080706@warmcat.com>
	 <1173053744.6131.40.camel@johannes.berg> <45EB6C3B.2060408@warmcat.com>
	 <200703042210.52534.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DM41aR0AFnjhLOIU0htx"
Date: Mon, 05 Mar 2007 12:34:07 +0100
Message-Id: <1173094447.6131.56.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DM41aR0AFnjhLOIU0htx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-03-04 at 22:10 -0500, Michael Wu wrote:
>=20
> Note that modifying the management interface to do this is possible, but =
it=20
> would break hostap (and probably wpa_supplicant w/ MLME). Doing packet=20
> injection on monitor interfaces instead is safer in that regard.

But if you want to do injection over monitor interfaces we'll need to
have the stupid mgmt interface hack around forever for the userspace
MLME so it can receive only management traffic (even the non-promisc
monitor iface we should have gets *far* too much traffic for a userspace
MLME)

Besides, to userspace, this is almost identical. In both cases it opens
a socket, binds to something (either raw socket bound to netdev or
netlink socket bound to nl80211) and then stuffs frames into that socket
with some fixed header format (for most apps anyway)

johannes

--=-DM41aR0AFnjhLOIU0htx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF7AAv/ETPhpq3jKURAvW9AKCQFkMJMwBee+RUijdMU2EBQ+QP5ACfVB25
SUT3ZcLjxxwVgSqn7JZ8zyI=
=hz2I
-----END PGP SIGNATURE-----

--=-DM41aR0AFnjhLOIU0htx--

