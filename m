Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:44907 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbZIKGHA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 02:07:00 -0400
Date: Fri, 11 Sep 2009 08:06:59 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Albert Herranz <albert_herranz@yahoo.es>
Cc: akpm@linux-foundation.org, linux-mmc@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Albert Herranz <albert_herranz@yahoo.es>
Subject: Re: [PATCH] sdio: pass unknown cis tuples to sdio drivers
Message-ID: <20090911080659.2ac822fc@mjolnir.ossman.eu>
In-Reply-To: <1252587402-7382-2-git-send-email-albert_herranz@yahoo.es>
References: <1252587402-7382-1-git-send-email-albert_herranz@yahoo.es>
	<1252587402-7382-2-git-send-email-albert_herranz@yahoo.es>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-14467-1252649223-0001-2"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-14467-1252649223-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 10 Sep 2009 14:56:42 +0200
Albert Herranz <albert_herranz@yahoo.es> wrote:

> Some manufacturers provide vendor information in non-vendor specific CIS
> tuples. For example, Broadcom uses an Extended Function tuple to provide
> the MAC address on some of their network cards, as in the case of the
> Nintendo Wii WLAN daughter card.
>=20
> This patch allows passing correct tuples unknown to the SDIO core to
> a matching SDIO driver instead of rejecting them and failing.
>=20
> Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
> ---

The description for this patch should be made clearer. The title
suggests it adds functionality that's already in place. It should be
something along the lines of "Also pass malformed tuples to card
drivers".

In the sake of sanity, you might want to add this behaviour to all
parsers, not just the FUNCE one.

I'm also unclear on how this is supposed to work. What does the
broadcom tuple look like? This patch looks like it will silence a lot
of legitimate warnings, and possibly pollute the card structures with
bogus data.

> diff --git a/drivers/mmc/core/sdio_cis.c b/drivers/mmc/core/sdio_cis.c
> index 963f293..87934ac 100644
> --- a/drivers/mmc/core/sdio_cis.c
> +++ b/drivers/mmc/core/sdio_cis.c
> @@ -123,8 +123,9 @@ static int cistpl_funce_func(struct sdio_func *func,
>  	vsn =3D func->card->cccr.sdio_vsn;
>  	min_size =3D (vsn =3D=3D SDIO_SDIO_REV_1_00) ? 28 : 42;
> =20
> +	/* let the SDIO driver take care of unknown tuples */
>  	if (size < min_size || buf[0] !=3D 1)

Misleading comment, the tuple is not unknown.

> -		return -EINVAL;
> +		return -EILSEQ;
> =20

What does this change improve?

>  	/* TPLFE_MAX_BLK_SIZE */
>  	func->max_blksize =3D buf[12] | (buf[13] << 8);
> @@ -154,13 +155,7 @@ static int cistpl_funce(struct mmc_card *card, struc=
t sdio_func *func,
>  	else
>  		ret =3D cistpl_funce_common(card, buf, size);
> =20
> -	if (ret) {
> -		printk(KERN_ERR "%s: bad CISTPL_FUNCE size %u "
> -		       "type %u\n", mmc_hostname(card->host), size, buf[0]);
> -		return ret;
> -	}
> -
> -	return 0;
> +	return ret;
>  }
> =20
>  typedef int (tpl_parse_t)(struct mmc_card *, struct sdio_func *,

Silencing a legitimate error.

> +		if (ret =3D=3D -EILSEQ) {
> +			/* this tuple is unknown to the core */

Misleading comment, the tuple might be known but malformed.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-14467-1252649223-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEARECAAYFAkqp6QUACgkQ7b8eESbyJLhuFQCeNbHWxpp9q5Uhe+vrorQXlCHd
+bMAoLadCNvhVOWHqAYZi0yXMKqcW4Ef
=yAX+
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-14467-1252649223-0001-2--
