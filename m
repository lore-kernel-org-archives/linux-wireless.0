Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39982 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbZEKN6o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 09:58:44 -0400
Subject: Re: [RFC/RFT] cfg80211: implement wext key handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <1242050250.28322.16.camel@localhost.localdomain>
References: <1241892978.31262.20.camel@johannes.local>
	 <1242050250.28322.16.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+HK2dlV7dvwosQznwizr"
Date: Mon, 11 May 2009 15:58:42 +0200
Message-Id: <1242050322.29777.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+HK2dlV7dvwosQznwizr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-11 at 09:57 -0400, Dan Williams wrote:
> On Sat, 2009-05-09 at 20:16 +0200, Johannes Berg wrote:
> > Move key handling wireless extension ioctls from mac80211 to cfg80211
> > so that all drivers that implement the cfg80211 operations get wext
> > compatibility.
> >=20
> > Note that this drops the SIOCGIWENCODE ioctl. This means that iwconfig
> > will no longer report "Security mode:open" or "Security mode:restricted=
"
> > for mac80211. However, what we displayed there (the authentication algo
> > used) was actually wrong -- linux/wireless.h states that this setting i=
s
> > meant to differentiate between "Refuse non-encoded packets" and "Accept
> > non-encoded packets". Dropping SIOCGIWENCODE also means that you can no
> > longer display the key currently in use. We believe this is a misfeatur=
e
> > in wireless extensions and unneeded; cfg80211 currently provides no way
> > to implement it.
>=20
> Does this mean inability to display current WEP key index, or just the
> key that the card is supposedly using?  Seeing the index may be
> important, but the ability to pull the actual key out of the card was
> not consistently implemented across WEXT drivers.

I actually added that back, seems people want to be able to pull the key
out... I'll address your other email separately.

johannes

--=-+HK2dlV7dvwosQznwizr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKCC8OAAoJEODzc/N7+QmaA90QAIuxDiRW9/4m0jbatsjn+CMn
7MrcW6+UTBDFZfN3HEF4ZRK5doMoT7sKHvHMG2jN44BkHZmVO0EiCaDGcevM0tyS
Uw89YvjSTAa7y/qHrUPxclux3z29GxjqrTfavAYlrSgv2x7RJaCS7WKa+ypUdWOD
0lFSqzwTOAHMk4hy9i8pFm2sZz6e5zkt6N1WTG8q3rTQ6Fgmrg+85M7+Z76MFShN
tIywV9s2yA4bFYE/e668YiHkKFLaOjaop4zjHM1KQpvPS2SY94ofpMxZTDzu9pH4
qr7xD7AbOmc3f2JuIs2mlYnzcAXDzTLHdbs18SdHvpw6Su8w4M0LoVzWeOE8oI9J
e0YJTyS9KMsavHi7eaebOY7uf9uZkkcs1qu8KA4o7w1ftyWFVNAtXdqBbjRGgLdy
w3vmA1O0xAaHEUzBVdqL8RRNgmHCEFFdFN6gFaJ+AV334n/OLG0lsdNqM5wQZldA
gu1DxB23awtg0yaz2AIH4lA4bqBCC9pcXWuZRRnvuvrIbW0g7ZTlYOcir8t8+KR0
OZUrLm0dowDqGZ5L7/ypnPACIydx0j8rLKGLnsiB62yL5kpGvjEeWKX4izmiNWfS
VQPBHv5cQNq0kWP6pynhX/WtSuSWKH/sgTa/9a3qcKr/BnLp34vJjP5rE37ai9Mr
nQw2EJQwI4ou3UpxEclv
=MyEN
-----END PGP SIGNATURE-----

--=-+HK2dlV7dvwosQznwizr--

