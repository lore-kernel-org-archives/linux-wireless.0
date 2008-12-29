Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34010 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbYL2OM1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 09:12:27 -0500
Subject: Re: [PATCH v2] ath9k: Enable dynamic power save in ath9k.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20081229135341.GB2914@myhost.users.atheros.com> (sfid-20081229_150313_922390_1E1BF6D2)
References: <20081229135341.GB2914@myhost.users.atheros.com>
	 (sfid-20081229_150313_922390_1E1BF6D2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-f15dx4xkpN3REwx60KRA"
Date: Mon, 29 Dec 2008 15:12:49 +0100
Message-Id: <1230559969.3116.56.camel@johannes> (sfid-20081229_151230_901384_2C7B7621)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-f15dx4xkpN3REwx60KRA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-29 at 19:23 +0530, Vivek Natarajan wrote:

> +static inline void ath9k_ps_wakeup(struct ath_softc *sc)
> +{
> +	if ((atomic_inc_return(&sc->ps_usecount) =3D=3D 1) &&
> +	    (sc->sc_ah->ah_powerMode !=3D  ATH9K_PM_AWAKE)) {
> +		sc->sc_ah->ah_restoreMode =3D sc->sc_ah->ah_powerMode;
> +		ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
> +	}
> +}
> +
> +static inline void ath9k_ps_restore(struct ath_softc *sc)
> +{
> +	if (atomic_dec_and_test(&sc->ps_usecount) &&
> +	   (sc->hw->conf.flags & IEEE80211_CONF_PS))
> +		ath9k_hw_setpower(sc->sc_ah, sc->sc_ah->ah_restoreMode);

Not sure which is intended, but maybe you should do the flags/powermode
check before doing the refcount change? In either case, I would probably
nest it into two if statements so it's clear which one is intended?

johannes

--=-f15dx4xkpN3REwx60KRA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJWNrfAAoJEKVg1VMiehFYypoP/RdVvIrbFZCtJihwFawzodp+
P0cBi/JPsF3dpi2frKo2O18oJdAFgJ6EmY8GLeiT6plg+im5TDQiU5CWQeqdUvw8
mT6K60LCT0x20R4Nk8hR5Lb3qUhZxgncrlg8hxgpRvbu7spZ+0ekMbsJRpfT2TDV
omam35t8tqFgbKjdxEXH8jnqbGMAVYqIl3tprixdRN5NfPyXse3Wm7/cR2ly5nrm
2Z3ynCHLbW8JnXizJEdnzYcpDFHNy6SLZOqlSV6shoIFibiDi4WV/eqopW6JOCu1
/k/7kU7P5yook+649VPY46lsoRrQOztJCDUVtb3P2I5vfK66289qhUgXS7kLdQWl
UT2L16bkQ0nTsogplzMj/CQxEgEYSzvV5ohOJVSavLoigiNfLkNjVQRIJFR6yc+W
/Nyq9WGoOA1v20ROWLKCcgeLijWTzp0jQ4QkUHgFQi5zzZ/5naZjK9+3aEof8QZY
lKIThxoC7DSvVoWI9EVqK7FMgj2wH6nNfjFP8drlf50+EzHJDQaf+VRPdkQdxaSV
AZRQg7UJagJU22fTH8vxdfdMMEbfgiV9S5l3Z65to1CW90LqkmVgCUc7uWoF/My2
Jh9KH/yx1DAupx2b7ylRMka+I7z8IgAdvU1R4RLrhujhvwNP6dYNHs3UOyGOJ7mn
G8jLCXOsafo5yYr+74RP
=I211
-----END PGP SIGNATURE-----

--=-f15dx4xkpN3REwx60KRA--

