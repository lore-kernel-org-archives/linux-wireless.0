Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38454 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbYAMXNw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 18:13:52 -0500
Subject: Re: Antenna software diversity
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200801140004.21251.IvDoorn@gmail.com> (sfid-20080113_230434_465886_74A40A41)
References: <200801140004.21251.IvDoorn@gmail.com>
	 (sfid-20080113_230434_465886_74A40A41)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KH60t6lTLD8iG4APbds7"
Date: Mon, 14 Jan 2008 00:13:33 +0100
Message-Id: <1200266014.5887.33.camel@johannes.berg> (sfid-20080113_231355_943495_95F83C5D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KH60t6lTLD8iG4APbds7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Ivo,

> However I would like to know if this is something should remain inside
> the driver, or if it should be moved into mac80211. Possibly integrated
> into the rate selection module, or otherwise as a seperate module which
> could allow the user to select a prefered antenna selection method simila=
r
> as to how he can select the prefered rate algorithm.

I guess it would be useful for other drivers inside mac80211. Not sure
whether it should be in the rate control algorithm or not.

If it is in the rate control algorithm it could keep track of antenna
per-station to optimise the link to the station (obviously the station
still has to be in range for both antennae when it sends a frame, but
one could in theory achieve better data rates to the station with the
better antenna). On the other hand, I guess nobody would want to
implement such a thing anyway.

I think a basic implementation within mac80211 would be sufficient if
any other drivers need it.

> In mac80211 this would mean that the antenna_sel should probably become
> an enum looking like this:
>=20
> enum antenna_sel {
> 	ANTENNA_SEL_DEFAULT,
> 	ANTENNA_SEL_A,
> 	ANTENNA_SEL_B,
> 	ANTENNA_SEL_DIVERSITY,
> };
>=20
> I am not really a fan of the ANTENNA_SEL_DEFAULT, but this is already pre=
sent
> in the current mac80211 implementation. So to remove that, we could use s=
ome
> method for the driver to let the default antenna known to mac80211, proba=
bly
> through an extra field in ieee80211_hw perhaps.

Sounds like a good plan, that way we could maybe even report what
antenna is used to userland.

> The ANTENNA_SEL_DIVERSITY would in this case be hardware diversity unless
> the driver has indicated that software diversity is in action, through a =
flag in
> ieee80211_hw.

Of course, with 11n all that is moot. Or does 11n hw use diversity for
legacy frames?

johannes

--=-KH60t6lTLD8iG4APbds7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4qbHKVg1VMiehFYAQIuzA/+MB6ALWqqZyY3uEgFIaJGIR0Tucyddruq
GMIFI4/a++f1m0RZli0dC6D3gIIus1z7eyC0kSmN/qzdAFHZSTgk8SD07TNuNKD/
jUJ81F0XYrFTVe0+d00OohFnsXzzR9BNmX4Ywc/+Fe4GHerbk/DFTi3UwiKZwqw3
6KSx9MwPJaifjfBGyAt4+PQ1i9CRhVXmWbh3cg4e+MWYqc7qH/+UzEQF1dOQ41wc
VgjCZp4o1HhBWZdZcZrsYJC4dFMDXaYIDvFCsfA4904TxMFeqVqalEwdLDcdL2jY
LcimM0+1cQbf44xteRVMMeePc2Zj6MQ5keEOzI0g8X6L6GuQ+64oWsxqzNT/OZxe
UcqHJjga6go7XYxODRt90WO6bPfrNxOGxy+0Ie3mcenofh5+vtUd2YHZgiibiEat
gHBXmGLwsDezgz3GctzuhE5x4r7dEEP8lauRT0+p6Te9Wx+r+LmPB/lNOZ2hfCxO
k+Y+++mdqFUs7FynGJYoDzDN2sHou2b2T9de789AxoFZ+dbOkehGpovtj90No7W0
/WoBptSxVtmO/yWXYb+PEYqbX0yiWtFZzq+naJ3K8ON7aSwhDnekd+1J5YF7CJae
RjBie5gTsGFWPw9JojNhehAf9qDVkEDUWtjlM+frhdDXru1F6HafXhEvsopRaXqY
kV+/H1IFRX4=
=VA5F
-----END PGP SIGNATURE-----

--=-KH60t6lTLD8iG4APbds7--

