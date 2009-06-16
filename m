Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35270 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbZFPOOi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 10:14:38 -0400
Subject: Re: [PATCH 2/4] rfkill: don't restore software blocked state on
 persistent devices
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4A37A3E1.8060606@tuffmail.co.uk>
References: <4A37A3E1.8060606@tuffmail.co.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7nbtJnXpNbs7xCIgZmLH"
Date: Tue, 16 Jun 2009 16:14:05 +0200
Message-Id: <1245161645.13461.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7nbtJnXpNbs7xCIgZmLH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-16 at 14:53 +0100, Alan Jenkins wrote:

>  /**
> + * rfkill_init_sw_state - Initialize persistent software block state
> + * @rfkill: pointer to the rfkill class to modify.
> + * @state: the current software block state to set
> + *
> + * rfkill drivers that preserve their software block state over power of=
f
> + * use this function to notify the rfkill core (and through that also
> + * userspace) of their initial state.  It should only be used before
> + * registration.
> + *
> + * In addition, it marks the device as "persistent".  Persistent devices
> + * are expected to preserve preserve their own state when suspended.
> + */
> +void rfkill_init_sw_state(struct rfkill *rfkill, bool blocked);
> +
> +/**
>   * rfkill_set_states - Set the internal rfkill block states
>   * @rfkill: pointer to the rfkill class to modify.
>   * @sw: the current software block state to set

You forgot the inline for !RFKILL.

Otherwise looks good.

johannes

--=-7nbtJnXpNbs7xCIgZmLH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKN6ipAAoJEODzc/N7+QmaQgcP/3S7OWfhc2Ik64T2vCl1YEpK
85l9Ly2mhlj2eZjYQGqfyu0KzSTXAgIqSHYsi+Yo+ukSSJs7sEQJhwErGE40/53I
WztnlLqqlugpoT6xibHv8K2GD/0wKUAFuLjiFJU563hiyHVz/+pybCJdMtmu7nmk
Fhk1k17Lw7Fytx8JObj15hUXg9ODl6Zd3TGW2qvtXsqPqG1K2ke4MW8ymTdCYoLT
S5SOuevubgEZ2d1Lup4BZ/j4SlhXiZAsceJqBVdxYcjs1zY+IJGajy05g9DNjC80
dl1yIV142Rdl0ZDOcsz9SlpjGRHI4YkV5HNCgS+AFBHvl74eUhReFHlAtN/rPUsC
5tkTYDBQjk1DNiT9wrG2U9JNMTk1uFk3vaJqYvSQoWx+1InkLgk35G5IvdeY1EWB
SSDjcCj3OFCgSJ2GWCAGqmfkV64pJfx5sbF0YQeFpaBjBK2UJ4uf795O4svgpPQh
CYe04ccIWWl8EILC0E+f8VNcLxU0FftBLpkjAin4+j9WufPI0zq+jAaSuMrsnZfF
6h1mvUHNGSElkuHbOojuE+hN9kiL8ula5JAUAeLgw/k91FRntMpw+JU7VV3ijsiv
sPcnOJQUdCApI165UkKGDu47h0MXtc8SSeiwg4ZT9nIQqpDIg6iCKbJ+YY7AeTxJ
F0xZyoGNpeT6aTQlK8/X
=WGf3
-----END PGP SIGNATURE-----

--=-7nbtJnXpNbs7xCIgZmLH--

