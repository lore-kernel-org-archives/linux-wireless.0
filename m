Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56178 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbYDMHnU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2008 03:43:20 -0400
Subject: Re: [RFC 1/2] b43: Fixes injection speed (up to 350 pps)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Jory A. Pratt" <geekypenguin@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4800BBAF.7000609@gmail.com> (sfid-20080412_144023_643919_8FFFD65F)
References: <4800BBAF.7000609@gmail.com>
	 (sfid-20080412_144023_643919_8FFFD65F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-c1Sg/+3ZdSao2noyZwAO"
Date: Sun, 13 Apr 2008 09:43:13 +0200
Message-Id: <1208072593.4111.12.camel@johannes.berg> (sfid-20080413_084324_500902_F8403E5D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-c1Sg/+3ZdSao2noyZwAO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +       if (ctl->type =3D=3D IEEE80211_IF_TYPE_MNTR) {
> +               ctl->flags |=3D IEEE80211_TXCTL_NO_ACK;
> +       }
> +
>         /* TX is done without a global lock. */
>         if (b43_using_pio_transfers(dev))
>                 err =3D b43_pio_tx(dev, skb, ctl);
> diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/x=
mit.c
> index 19aefbf..85e446b 100644
> --- a/drivers/net/wireless/b43/xmit.c
> +++ b/drivers/net/wireless/b43/xmit.c
> @@ -318,7 +318,8 @@ int b43_generate_txhdr(struct b43_wldev *dev,
>         /* MAC control */
>         if (!(txctl->flags & IEEE80211_TXCTL_NO_ACK))
>                 mac_ctl |=3D B43_TXH_MAC_ACK;
> -       if (!(((fctl & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_CTL) =
&&
> +       if ( (txctl->type !=3D IEEE80211_IF_TYPE_MNTR) &&
> +             !(((fctl & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_CTL=
) &&
>               ((fctl & IEEE80211_FCTL_STYPE) =3D=3D IEEE80211_STYPE_PSPOL=
L)))
>                 mac_ctl |=3D B43_TXH_MAC_HWSEQ;
>         if (txctl->flags & IEEE80211_TXCTL_FIRST_FRAGMENT)

FWIW, Michael meant this one too, it's not acceptable and we've
previously said why.

johannes

--=-c1Sg/+3ZdSao2noyZwAO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAG5kKVg1VMiehFYAQJ57Q//cP23B0P0q4CnAhBCQ+EAxK9OT6XywXyz
EFu3iVSqAUx0NpVWwIDW6qNY9lrcxLanI/z8MbVFHJJpEgQSDCVZ4ubxDpdqJfXo
ASpKsX5Qg8T/o4QGt4paWM7PGxehNxci0i8i6jfBj+vMsATPhkHXuP2ZX9hlzpcM
nUiShBnNkT5gtk496TyM/D7b7yXeNXJRGbQA4AbcsSE9h/2MPJUvOpB40UfyFiHw
ZtPr0LwkTFJuImpl5OBA7+D4IXbFcQTHt/OcLZdyQXdhLgv8w0wxGLC3ep3mrsUD
Jbmz1Y1xgZBIDit6pfnKgHRNOrn8FFMvm3HblXh6LvLGXOpNtTRb2QbkHTYU+KTd
sJWMFd9gvG/8OMgNyQ2S56gctff+zZheVQQP11YoqQGGLMYN2kOF4pxQMWJcYO53
+NNTWOhEnCk0ZaSxpKrqOHoUGXIHpclKaQkuRoc6swqVPwXAOqPOTaHtSJSxjaVz
dCNcfYy1zyTJkp5OndaXkn9Qa8Iw9/OcYBFU/d4stH0AM6zS3qbpIyFtkvVQQyGx
ScLaGuvHLdJq1j2dMT+ivfvXQNnc/o+MMs8FeASUFR8tRPOL795G99ZLwzdJgPn+
mWSAkakdXAgnLikdia7ixxtCBKCcl4P86oo9kb2Z2uEyKaUCchsptIxxeQ56pPbi
TeHUH7KRvgw=
=v1O9
-----END PGP SIGNATURE-----

--=-c1Sg/+3ZdSao2noyZwAO--

