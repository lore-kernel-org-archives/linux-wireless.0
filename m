Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46199 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbYL2MKj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 07:10:39 -0500
Subject: Re: [PATCH] ath9k: Enable dynamic power save in ath9k.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20081229235300.GA8458@myhost.users.atheros.com> (sfid-20081229_112105_235618_A8D12202)
References: <20081229235300.GA8458@myhost.users.atheros.com>
	 (sfid-20081229_112105_235618_A8D12202)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0ugj3aYNEmJyUHS3hNux"
Date: Mon, 29 Dec 2008 13:11:00 +0100
Message-Id: <1230552660.3116.33.camel@johannes> (sfid-20081229_131046_790819_4EFBD29E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0ugj3aYNEmJyUHS3hNux
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-29 at 15:53 -0800, Vivek Natarajan wrote:

> +#define ATH9K_PS_WAKEUP(sc)						      \
> +	do {								      \
> +		if (!atomic_read(&sc->ps_usecount) && 			      \
> +		   (ah->ah_powerMode !=3D  ATH9K_PM_AWAKE)) {		      \
> +			ah->ah_restoreMode =3D ah->ah_powerMode;		      \
> +			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);	      \
> +		}							      \
> +		atomic_inc(&sc->ps_usecount);				      \
> +	} while (0);
> +
> +#define ATH9K_PS_RESTORE(sc)						      \
> +	do {								      \
> +		if (atomic_dec_and_test(&sc->ps_usecount) &&  		      \
> +		   (sc->hw->conf.flags & IEEE80211_CONF_PS))		      \
> +			ath9k_hw_setpower(sc->sc_ah, ah->ah_restoreMode);     \
> +	} while (0);

I think those would be better as static inlines rather than macros.

johannes

PS: Your clock seems to be off by 12.5 hours or so?

--=-0ugj3aYNEmJyUHS3hNux
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJWL5SAAoJEKVg1VMiehFYmOoP/jDO692DtQlQGZYonYMgVdmG
PE4VTQe5c0HHsgaDANbV3De8IidI0LbX5b94zdjCRn15+mJkYhnHxzmcmHaYCki6
Py5rOMaBKJGVvfnOVo4M8fft7YM4Gei3F0wWuOUlR38WDtLMvqbE5RtxXqCCA4Fn
eoty4ObUJOVrQXDzTPpD6pxXMWpOseS07Z5uS+dy8oCXFDShaAkz5IpVbklG+HF7
mFtIf6HMFy3iMOP/Zc6NdFzx8WPLbYhxgskXlVxvoUU+1t9phFQ0g/2rQNYmJhN2
WbbhcDzTaW2h5sYyr4TuGBxGsrYH+xpfbaD40ncFC497lwrr4olHkk32N1cMHBRp
juho/Awl5gtYdA+4QE6QfV2mWHzD26f0+YuZJCeO+5x887xpKqAJLHHpf0F5BGm4
OqVTKLaZLKUW24U6KdT/gUxC+VxT8hL8M2yaYf1pRwmrvvIRW0o/VUxNWP+dsrJ2
vgWZKhkHW11AUi1hzcR1Mq7g1J6syHr2GSCkoZanwOe3nVa/kfQ0EUa06LhkzeKd
FpeVwx++c8epu/eeonVMA2v71sWNXsSpImliTJtpWZwMRAj2TsFN2YvS6W6OBKa9
nU4YGr5ilG50Gt02z10CGUrjwD1U97N2WBd2obXJcUJjjRpR+VrnGWkNcuVQLLK6
rJer/Shx2zYMNdv7l3nT
=Uaq1
-----END PGP SIGNATURE-----

--=-0ugj3aYNEmJyUHS3hNux--

