Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx40.mail.ru ([194.67.23.36]:50896 "EHLO mx40.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245AbYKOIPx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2008 03:15:53 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: orinoco-devel@lists.sourceforge.net
Subject: Re: [Orinoco-devel] Agere PCMCIA sometimes takes very long time to associate with 9.48 FW
Date: Sat, 15 Nov 2008 11:15:47 +0300
Cc: linux-wireless@vger.kernel.org
References: <200810191436.13298.arvidjaar@mail.ru> <491349BC.8090606@gmail.com> <49134F66.4020608@gmail.com>
In-Reply-To: <49134F66.4020608@gmail.com>
MIME-Version: 1.0
Message-Id: <200811151115.48750.arvidjaar@mail.ru> (sfid-20081115_091615_311324_154AB4FB)
Content-Type: multipart/signed;
  boundary="nextPart1931282.pOpNkpcXz6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1931282.pOpNkpcXz6
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 06 November 2008, Dave wrote:
> Dave wrote:
> > Andrey Borzenkov wrote:
> >> To remind - sometimes after resume it takes *very* long time to associ=
ate,
> >> so everything else times out and I get no connection. Running orinoco =
from
> >> 2.6.28 in WPA mode and wpa_supplicant 0.6.4; in logs can be seen that
> >> wpa_supplicant endlessly tries to associate.
> >=20
> > The orinoco driver maintains its settings across an 'if down' - 'if up'.
> > This means the card will attempt to associate as soon as you 'if up'.
> >=20
> > I'm looking at a patch which will clear all driver settings in
> > orinoco_open, which should fix things for distributions which bring the
> > interface down when suspending.
>=20
> Can you try the patch below? Apologies if it gets whitespace damage.
>=20

It is hard to be sure when the problem is sporadic and no known way to
trigger it, but I have been running with this patch for a week without
issues; this so far exceeds usual score.

Now comments :)

=2D we should not be doing it in ->open. It is technically legal to set
wireless parameters before "icfonfig up" and we lose all of them. I will
try next week with similar patch in orinoco_stop().

=2D I am still not even sure we should do it at all. What is sematic of
ifconfig up/down w.r.t. wireless parameters? I.e. is "ifconfig down"
expected to clean all device state and start from scratch?

=2D finally I still think we are facing more wpa_supplicant bug, and this is
just a workaround for it. I have seen at least one case of losing access
point and wpa_supplicant was not able to cope with it after AP was found
again.

> Dave.
>=20
> ---
> diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoc=
o.c
> index 12059f4..8ca9d51 100644
> --- a/drivers/net/wireless/orinoco.c
> +++ b/drivers/net/wireless/orinoco.c
> @@ -721,6 +721,18 @@ static int orinoco_open(struct net_device *dev)
>         if (orinoco_lock(priv, &flags) !=3D 0)
>                 return -EBUSY;
>=20
> +       /* Clear driver settings. Copied from orinoco_init */
> +       priv->iw_mode =3D IW_MODE_INFRA;
> +       priv->prefer_port3 =3D priv->has_port3 && (! priv->has_ibss);
> +       set_port_type(priv);
> +       priv->channel =3D 0;
> +       priv->promiscuous =3D 0;
> +       priv->encode_alg =3D IW_ENCODE_ALG_NONE;
> +       priv->tx_key =3D 0;
> +       priv->wpa_enabled =3D 0;
> +       priv->tkip_cm_active =3D 0;
> +       priv->key_mgmt =3D 0;
> +
>         err =3D __orinoco_up(dev);
>=20
>         if (! err)
>=20
>=20
>=20



--nextPart1931282.pOpNkpcXz6
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkehTQACgkQR6LMutpd94wDMQCgzQnvk86fW9InYWja/QQiay9N
dFgAoIyeCXMdjdE20G9r2oY0//71l/YO
=6dMY
-----END PGP SIGNATURE-----

--nextPart1931282.pOpNkpcXz6--
