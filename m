Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55943 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbZJWQs7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 12:48:59 -0400
Subject: Re: [PATCH 17/19] [RFC, v2] libertas: Kconfig entry for
 libertas+cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1256316179.2164.53.camel@localhost.localdomain>
References: <20091022133043.185554096@mail.mn-solutions.de>
	 <20091022133425.317619132@mail.mn-solutions.de>
	 <1256307572.12174.33.camel@johannes.local>
	 <1256312995.2164.7.camel@localhost.localdomain>
	 <1256313851.12174.131.camel@johannes.local>
	 <1256315335.2164.44.camel@localhost.localdomain>
	 <1256315496.2164.47.camel@localhost.localdomain>
	 <1256315972.12174.168.camel@johannes.local>
	 <1256316179.2164.53.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-d5VPd6MRPgLdHTzC3TAq"
Date: Fri, 23 Oct 2009 18:48:55 +0200
Message-Id: <1256316535.12174.186.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-d5VPd6MRPgLdHTzC3TAq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-10-23 at 09:42 -0700, Dan Williams wrote:

> Yeah, I think it's best to handle the mesh WEXT ioctls separately for
> now.  There are really only 4 of them (get/set SSID, set channel, get
> mode) that matter for mesh.  The rest of the ioctls that the mesh
> interface supports get redirected to the cfg80211 handlers because they
> aren't specific to mesh.

So why can't we simply do

set_ssid()
{
	if (mesh)
		return mesh_set_ssid();
	else
		return cfg80211_wext_iwessid()
}

johannes

--=-d5VPd6MRPgLdHTzC3TAq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK4d50AAoJEODzc/N7+Qma4fYP/RnBP+lU4j2r+pTAboasTa8X
IHodlLw6xMHvOcsMBJm+rN5a9CTHzVqR56pFys/EFt18VZhwNubenfm2KItreGeV
JjWQT0/3GNUBpmkrs4weASq6iZ66apU2k+KGyAQWBVvs4IY4JXytTLyIc/rxEFwU
Dy3+K8vkaLcg1RgObYfcjoYSg42cd6tRSaKdLu1rtUHEeoWIWlmhZNNnUcRChDC+
8EI2OPvVtU0kSv/bUeNBegIG7X9A8hiw+ryqubj5jOe9bZTH6lifkcxo6My1aU2u
PW69BHFVkHfBE8nXIAv8cvaeDWNLxjt+V3p8PVExePHfV2GFg5giLPiNSWIYtWD9
T7xk5SMBI8XBSftgfeRAkVA6k6PCkEOXPQ+3qaAxTHEKvTfq/NEM8qDOeSF8x0Ol
1Bl3QELZtVGqJr0kY87SbGv+0yOhdi8GjVA+Itw9nLWBHdSNz+7rk2HOfTMkLXVa
hXElbmbluJvm1N4UOYSaoyxC+VSIwdFE5IkZ2Na8c30wcM2HrX4SMqgtFA+clJox
seAS85IjnrFZYzcoz1WN08zeZU1c+tRJoJWC91/TlKFCY3s4Y/f13e6CH0zhfPJz
TmR1/ddSiNzLpfyKr/ZoAgIafkK8HZUjmhbUrRkDjXjd3fDpfYT3SmrBiydFM79N
v9KN1jxp7QgIKA1KgQkR
=9tEo
-----END PGP SIGNATURE-----

--=-d5VPd6MRPgLdHTzC3TAq--

