Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44660 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbYGXDSn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 23:18:43 -0400
Subject: Re: [ath9k-devel] [PATCH 1/4] Add new Atheros IEEE 802.11n ath9k
	driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	ath9k-devel@lists.ath9k.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
In-Reply-To: <18567.57982.939459.435411@localhost.localdomain> (sfid-20080724_040954_505987_F044D178)
References: <20080720024341.GQ17936@ruslug.rutgers.edu>
	 <20080720024500.GR17936@ruslug.rutgers.edu>
	 <1216842238.13587.31.camel@johannes.berg>
	 <18567.57982.939459.435411@localhost.localdomain>
	 (sfid-20080724_040954_505987_F044D178)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GmxSOmhXzCJYkAPihxGB"
Date: Thu, 24 Jul 2008 05:18:17 +0200
Message-Id: <1216869497.13587.46.camel@johannes.berg> (sfid-20080724_051846_259861_1445A916)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GmxSOmhXzCJYkAPihxGB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


>  > +enum hal_freq_band {
>  > +	HAL_FREQ_BAND_5GHZ =3D 0,
>  > +	HAL_FREQ_BAND_2GHZ =3D 1,
>  > +};
>  >=20
>  > You can remove those.
>=20
> And use mac80211's band macros ?

I guess the question really is what you need them for, but yeah, if you
really need them you should be using the mac80211 stuff to avoid having
to translate the values into each other all the time.

>  > +struct ath_node *ath_node_get(struct ath_softc *sc, u8 *addr)
>  >=20
>  > + * Setup driver-specific state for a newly associated node.  This rou=
tine
>  > + * really only applies if compression or XR are enabled, there is no =
code
>  > + * covering any other cases.
>  >=20
>  > What sort of state do you need? Anything mac80211 could cover?
>=20
> Aggregation information is maintained on a per-STA basis.
> All this node stuff will be cleaned up anyway.

Ok cool. As I just discussed with the Intel folks, we can give you a
private area in the sta_info struct that we pass down all the time so
you can look in there instead of implementing your own
hashtable/list/...

>  > What sort of node state do you really need? Why do you need PS state?
>  > Can we help you here with mac80211? Get some insight into a part of
>  > sta_info and have that passed to the driver to avoid having a list/has=
h
>  > table in the driver etc.
>=20
> Can sta_info be accessed directly from the driver ?
> Don't we need a ieee80211_local ptr to retrieve sta_info ?
> And if so, is that ok ?
> Or will you be providing a private driver area embedded in sta_info ?

No, you cannot look at sta_info, but it shouldn't be hard to make part
of the structure public, embed a private area into it and pass that
down, like the "vif" pointer in a few places.

>  > +	error =3D ath_vap_attach(sc, 0, conf->vif, ic_opmode, ic_opmode, 0);
>  > +	if (error) {
>  > +		DPRINTF(sc, ATH_DEBUG_FATAL,
>  > +			"%s: Unable to attach vap, error: %d\n",
>  > +			__func__, error);
>  > +		goto bad;
>  >=20
>  > Does that reject the call if ic_opmode is 0? Why is ic_opmode passed t=
wice?
>=20
> No it doesn't, for some reason IBSS has a value 0 for its opmode.
> But if opmode happens to be invalid, -EINVAL is returned.
> And yep, it shouldn't be passed twice.

Ok so of course I think you should use the mac80211 interface type
instead of opmode all the way through, and you should be checking the
interface types you support here because right now it looks like if I
try to bring up an AP or mesh interface I'll get IBSS?

johannes

--=-GmxSOmhXzCJYkAPihxGB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIh/R1AAoJEKVg1VMiehFYhK8P/1LMVZ/SpHXTa8m2yxNRxCWy
JFpRw2UPoZrLdmOU5aLgXA4PANpvbFczjyeukr2a+vczkUT4bKMnbVQCJhJoViVo
O4GnfBCdeH+6R6jO5g2jKGK6LqDDfq/43pyciljjyVhKgsLYbREEwpffe7LXrFet
NNV0f3g1nXHp/Px+5Cd6oP3shW8ihleeeQ16By4jmLGHVOo41F6WSBjwd+rPziub
ihQJLApGCJjCkozcAzP3sf2gjvtCB9EOcWIfWTSIOZVysB50pkK8w9yfLIoxsBjy
nzNRsup+88/U+5hw65TYcW9NizVqMEy7HER0lFJYeMH6oUh2cdVGBBRPv5hkS4Gu
jq0IVqvPVTYYI2kWNfcsj4NPJtJNLgFv0POxGPMbUFTjQ581BryPiFv6H5tuAt58
usC+4Il6s0SGA21vQHcuCh6bGgyCQ4tcaFPYrEIUC3CKT37qJwyd4XMbrFCu/A6g
mEa3ze87Sbx7cnhB0HrCOcwgbmhTScInD6c3GkonQk9q7x9iSw47TMzEnSd8Lu5A
15kik0eXf94b2UkIRfJfbbgKXmddxJv/4EByRav5eLtQTqrFLAHkMDyebR3zrDtB
vurvKJpQnIcMT9rw3Da6M0I3zbtsHRRvxhO4qcYGNy0SObu+HsQRnI9KLIK5XvYA
m1RyvtTdEslgewzo2syZ
=5kPC
-----END PGP SIGNATURE-----

--=-GmxSOmhXzCJYkAPihxGB--

