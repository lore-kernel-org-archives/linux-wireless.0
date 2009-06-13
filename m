Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:45070 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbZFMLVs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jun 2009 07:21:48 -0400
Date: Sat, 13 Jun 2009 13:21:44 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, kalle.valo@iki.fi, san@google.com,
	Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH/RFC 7/7] wl12xx: add sdio support
Message-ID: <20090613132144.6c7783bc@mjolnir.ossman.eu>
In-Reply-To: <1244685780-28930-8-git-send-email-me@bobcopeland.com>
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
	<1244685780-28930-8-git-send-email-me@bobcopeland.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-25049-1244892108-0001-2"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-25049-1244892108-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 10 Jun 2009 22:03:00 -0400
Bob Copeland <me@bobcopeland.com> wrote:

> This adds the wl12xx_sdio module, enabling the SDIO interface for
> wl12xx, as used by the Google G1 phone and others.
>=20
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---

I think the drivers looks quite ok. There are really just a few things
I'm concerned about:

- Please put the device id:s in sdio_ids.h. There is no pci-ids
equivalent for SDIO so I'd like to fill up the kernel header with
device ids as much as possible.

- Why do you have a platform device with the sole purpose of enabling
power to the SDIO card? Shouldn't this be handled in the arch code?

> +	sdio_set_block_size(func, 512);

Since you do not actually rely on this, why not leave it at the default
value?

> +static void __devexit wl12xx_sdio_remove(struct sdio_func *func)
> +{
> +	struct wl12xx *wl =3D sdio_get_drvdata(func);
> +
> +	sdio_claim_host(func);
> +	sdio_release_irq(func);
> +	sdio_disable_func(func);
> +	sdio_release_host(func);
> +
> +	wl12xx_free_hw(wl);
> +}

This seems wrong. Shouldn't you unregister the device with the upper
layers first?

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-25049-1244892108-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkozi8sACgkQ7b8eESbyJLiEQgCZAWMHLtGcHhc6UxgUgSwPAefP
nrUAnjMY//Xpm0Ny9eikanpf6WN6EyCk
=YMlv
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-25049-1244892108-0001-2--
