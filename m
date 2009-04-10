Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58197 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939034AbZDJHd2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2009 03:33:28 -0400
Subject: Re: [PATCH] rfkill: Fix broken rfkill LED in 2.6.30-rc1
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <49deb98b.b3qoCjTA6clRL5zY%Larry.Finger@lwfinger.net>
References: <49deb98b.b3qoCjTA6clRL5zY%Larry.Finger@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Purj/+lg0RSzfSDyUXYC"
Date: Fri, 10 Apr 2009 09:33:24 +0200
Message-Id: <1239348804.17031.17.camel@johannes.local> (sfid-20090410_093342_374514_4B4CAFBA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Purj/+lg0RSzfSDyUXYC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-09 at 22:14 -0500, Larry Finger wrote:
> The rfkill system fails to issue a LED trigger event when the rfkill stat=
e
> changes.

I have no issues with this patch, and will just port my rewrite over it
-- I'll get back to the rewrite next week for good, hopefully.

johannes

> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>=20
> John,
>=20
> This is 2.6.31 material.
>=20
> Larry
> ---
>=20
> Index: wireless-testing/net/rfkill/rfkill.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/net/rfkill/rfkill.c
> +++ wireless-testing/net/rfkill/rfkill.c
> @@ -96,6 +96,7 @@ static void update_rfkill_state(struct r
>  		}
>  		mutex_unlock(&rfkill->mutex);
>  	}
> +	rfkill_led_trigger(rfkill, rfkill->state);
>  }
> =20
>  /**
> @@ -136,8 +137,9 @@ static int rfkill_toggle_radio(struct rf
>  	oldstate =3D rfkill->state;
> =20
>  	if (rfkill->get_state && !force &&
> -	    !rfkill->get_state(rfkill->data, &newstate))
> +	    !rfkill->get_state(rfkill->data, &newstate)) {
>  		rfkill->state =3D newstate;
> +	}
> =20
>  	switch (state) {
>  	case RFKILL_STATE_HARD_BLOCKED:
> @@ -172,6 +174,7 @@ static int rfkill_toggle_radio(struct rf
>  	if (force || rfkill->state !=3D oldstate)
>  		rfkill_uevent(rfkill);
> =20
> +	rfkill_led_trigger(rfkill, rfkill->state);
>  	return retval;
>  }
> =20
> @@ -204,6 +207,7 @@ static void __rfkill_switch_all(const en
>  			mutex_lock(&rfkill->mutex);
>  			rfkill_toggle_radio(rfkill, state, 0);
>  			mutex_unlock(&rfkill->mutex);
> +			rfkill_led_trigger(rfkill, rfkill->state);
>  		}
>  	}
>  }
> @@ -256,6 +260,7 @@ void rfkill_epo(void)
>  				RFKILL_STATE_SOFT_BLOCKED;
>  	}
>  	mutex_unlock(&rfkill_global_mutex);
> +	rfkill_led_trigger(rfkill, rfkill->state);
>  }
>  EXPORT_SYMBOL_GPL(rfkill_epo);
> =20
> @@ -358,6 +363,7 @@ int rfkill_force_state(struct rfkill *rf
>  		rfkill_uevent(rfkill);
> =20
>  	mutex_unlock(&rfkill->mutex);
> +	rfkill_led_trigger(rfkill, rfkill->state);
> =20
>  	return 0;
>  }
> @@ -520,6 +526,7 @@ static int rfkill_resume(struct device *
>  				1);
> =20
>  		mutex_unlock(&rfkill->mutex);
> +		rfkill_led_trigger(rfkill, rfkill->state);
>  	}
> =20
>  	return 0;
>=20

--=-Purj/+lg0RSzfSDyUXYC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ3vZBAAoJEKVg1VMiehFYOd0QALm/dA4jOBc4n7UxIgOhjhfh
8xMYqSoTXJPj28C7ILmFX/yu/tY/nyTBorTd31OGgVHearN/OZXCJ/JEzB00BU0r
s+rk0xSEYZDV6i3hCwrrRHsxeXFIEgHti04y5rPKI6Azc7vCysIBnZiDDsSffm+F
KEwTdL67GJlqhpdWPPJrNOxvhfoMDr4Mt5kzRfzLG+EEWl6zjSLpPdp1+kNe+XDP
rquemRwjOhSwR8McyeeKv2rnJhDajicmRui9JcZ9e9lyldO/4ONEpV8OhOtSAUHN
yKw8pIIxvQO0kMjs1OynSr5TKqIkdolPYeGbqAE6JqhmQuOkUi0rQ5idW7l4gxbT
YH5XhCxfEdAYNvYjBkLwJlWkOix2/e+6I4W5OeSpOnhve9Zi1UNN2sBG1Xvfl61S
9TBH9bW206vERRzf8GuuxKbpG6MmyoLYj7fSh0+s/EpFVIFyQPEiSslgTcywpTRj
0nW18G63gUlI6zukiGfm+5744CibKLyt4Z2OgR22RalMSAdezS7JSEg8NOjVchyg
CipTd8u2GGk5lEW9UTmdqt/+gRi2QuopbJ0Ae/Zw3PZJd/mke6O1JOoDdlByN3qB
5FDep5Y9Yp4uPy46UOypTacsqxYhckmLF7tOBu/9fJD0GxwGeN7gWsoddFXym4h8
tWjHsh+BAlRdgJxwZcbx
=yvFo
-----END PGP SIGNATURE-----

--=-Purj/+lg0RSzfSDyUXYC--

