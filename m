Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s2.neomailbox.net ([5.148.176.60]:40204 "EHLO s2.neomailbox.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964856AbcJVNnE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Oct 2016 09:43:04 -0400
Date: Sat, 22 Oct 2016 21:42:22 +0800
From: Antonio Quartulli <a@unstable.cc>
To: ath9k-devel@lists.ath9k.org
Cc: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
        Antonio Quartulli <antonio@open-mesh.com>
Subject: Re: [NOT FOR MERGE] ath9k: work around key cache corruption
Message-ID: <20161022134222.GQ12558@prodigo.lan> (sfid-20161022_154307_816691_A0A58C81)
References: <20161018083552.28592-1-a@unstable.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6eUvXotnMb6+obQB"
In-Reply-To: <20161018083552.28592-1-a@unstable.cc>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--6eUvXotnMb6+obQB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I am trying to understand what's required by this patch to be merged upstre=
am.
Sven Eckelmann commented in another email by saying:

"The patch itself has (at least) one big problem. It is using some mac80211
internals in ath_key_config_iter to make sure that the uploaded keys were
actually programmed in the hardware. Without this check the keys could end =
up
in the lower slots and thus break all connections."


Does anybody else have any other additional comment?
(Please keep me in CC as I am not registered to the ath9k ML).

Cheers,

On Tue, Oct 18, 2016 at 04:35:52PM +0800, Antonio Quartulli wrote:
> From: Antonio Quartulli <antonio@open-mesh.com>
>=20
> This patch was crafted long time ago to work around a key cache
> corruption problem on ath9k chipsets.
>=20
> The workaround consists in periodically triggering a worker that
> uploads all the keys to the HW cache. The worker is triggered also
> when the vif detects 21 undecryptable packets.
>=20
>=20
> This patch is based on top compat-wireless-2015-10-26.
>=20
>=20
> I was asked to release this code to the public and, since it is
> GPL, I am now doing it.
>=20
>=20
> Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>

--=20
Antonio Quartulli

--6eUvXotnMb6+obQB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYC2y7AAoJEJ6F1zG2JyOsqnMP/1LhblEFsMiSuVKTeYHJmeor
CJhSnwXmW4Y8RPtV2QvqixWpfkqfq8IUJkVWpXvcK8jNyNPk13uO9fhzbg4On3y/
7pc6eslBXZ/l5u6bPH94lqck48H1OhFy0pleo+5Ej0RC1nsE513430FiQHdUETCQ
ChbsEjnKgswrKcqfXRfLDvAdjAwl3BU0QmwsJVcfe76AwvBZ0s7qjDe0hYUivHut
BzwBNFVRfy99CKWPbFopv/tQtPwLcb1+X+rm9Uib/hbzc3StpxNf8RG4FsZCLzWo
pxYB88c3q8feos8A5ASRlMVh48wbYSbKAaZkR6i7/y/S4QzIlXcEOS9eKMFeTvGi
wXwBzHLru1dN6UYYi8hPpw6c893d1oeCzhkrLczVwRwr/N6HfbWCs8oBGEfJi9go
wfV5aEKsov7on6s2kSzcKvWP8Ih0z+9RllH+14iuL3Kre11JyLRYuT+2duKsapFs
h0iA9UvURt6F+jRJzGAYSZbI0DHi8pJzMqvZ1e9bmAi9TtbX6QrWR06QWk6/Es3V
hx+O2gnRTqOBg4JU26gjhn7D/e8KJqwv5B/00sxkWbx5LoXNNk/YrK0Wtv7iKP9U
v6bG+JTgPWkxkThy+16fVoyN/2IK4hwtEiRlSNZhJ9ztmUpmGML7J4HdevPELOPj
FYgG26McGUwU7Mdq6+KM
=YKgx
-----END PGP SIGNATURE-----

--6eUvXotnMb6+obQB--
