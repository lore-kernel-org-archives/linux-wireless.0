Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:33680 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbYLSQKH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 11:10:07 -0500
Date: Fri, 19 Dec 2008 17:08:36 +0100
From: Harald Welte <laforge@gnumonks.org>
To: Colin McCabe <colin@cozybit.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	Andrey Yurovsky <andrey@cozybit.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>
Subject: Re: [PATCH 3/3] libertas: if_spi, driver for libertas GSPI devices
Message-ID: <20081219160836.GQ9285@prithivi.gnumonks.org> (sfid-20081219_171012_631138_6CEB2029)
References: <1229398052-27465-1-git-send-email-colin@cozybit.com> <1229398052-27465-2-git-send-email-colin@cozybit.com> <1229398052-27465-3-git-send-email-colin@cozybit.com> <1229398052-27465-4-git-send-email-colin@cozybit.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GlnCQLZWzqLRJED8"
In-Reply-To: <1229398052-27465-4-git-send-email-colin@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--GlnCQLZWzqLRJED8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Colin,

thanks a lot for your patch, it is greatly appreciated.

Stefan Schmidt (see Cc) and myself are currently working on using a 8686
attached t o SPI of a S3C2442 SoC.

Let me make some comments on the actual code:

On Mon, Dec 15, 2008 at 07:27:32PM -0800, Colin McCabe wrote:

> +struct libertas_spi_platform_data {
> +	u16 host_irq_num;
> +
> +	u16 gpio_cs;
> +};

> +	gpio_set_value(card->gpio_cs, 0); /* assert CS */
> +	gpio_set_value(card->gpio_cs, 1); /* drop CS */

Typically, in the Linux SPI framework, it is the SPI host controller
driver that exercises the chipselect GPIO, not the client (device) driver.

Also, the host_irq_num is typically passed by the '.irq' member of
spi_board_info structure, since it is board specific data (see e.g.
arch/arm/mach-pxa/spitz.c)

Unless there is a specific reason that I'm missing, it would probably be a
good idea to follow the general conventions on this.

Cheers,
--=20
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)

--GlnCQLZWzqLRJED8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFJS8cEXaXGVTD0i/8RArLqAJ9/P1suQJqfpGmKjHBQ8vr7a1jYwACfc9Aj
f31T0rhK/ajOYPgJQKdXm6Q=
=HRmB
-----END PGP SIGNATURE-----

--GlnCQLZWzqLRJED8--
