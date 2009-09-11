Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:39503 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbZIKF6V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 01:58:21 -0400
Date: Fri, 11 Sep 2009 07:58:19 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Albert Herranz <albert_herranz@yahoo.es>
Cc: akpm@linux-foundation.org, linux-mmc@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Albert Herranz <albert_herranz@yahoo.es>
Subject: Re: [PATCH] sdio: recognize io card without powercycle
Message-ID: <20090911075819.1989d75b@mjolnir.ossman.eu>
In-Reply-To: <1252587402-7382-1-git-send-email-albert_herranz@yahoo.es>
References: <1252587402-7382-1-git-send-email-albert_herranz@yahoo.es>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-14418-1252648703-0001-2"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-14418-1252648703-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 10 Sep 2009 14:56:41 +0200
Albert Herranz <albert_herranz@yahoo.es> wrote:

> SDIO Simplified Specification V2.00 states that it is strongly recommended
> that the host executes either a power reset or issues a CMD52 (I/O Reset)=
 to
> re-initialize an I/O only card or the I/O portion of a combo card.
> Additionally, the CMD52 must be issued first because it cannot be issued
> after a CMD0.
>=20
> With this patch the Nintendo Wii SDIO-based WLAN card is detected after a
> system reset, without requiring a complete system powercycle.
>=20
> Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
> ---

I had problems with cards already in the idle state crashing when I
sent them a reset. I suggest a big round of testing before merging this.

> @@ -182,3 +189,20 @@ int mmc_io_rw_extended(struct mmc_card *card, int wr=
ite, unsigned fn,
>  	return 0;
>  }
> =20
> +int sdio_go_idle(struct mmc_host *host)
> +{

It might be clearer if you use the terminology from the spec, so either
sdio_abort() or sdio_reset().

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-14418-1252648703-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEARECAAYFAkqp5v4ACgkQ7b8eESbyJLjFQwCfSwwLYHjebMD8t/U2TEacJRIM
lV4An3v+gqIfRxLMtded3piLxrqXOQ5y
=pmXm
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-14418-1252648703-0001-2--
