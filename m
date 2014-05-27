Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:41386 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751900AbaE0IKD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 04:10:03 -0400
Date: Tue, 27 May 2014 10:07:46 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
	Chris Ball <chris@printf.net>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Chen-Yu Tsai <wens@csie.org>,
	linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH 02/11] pinctrl: sunxi: add IRQCHIP_SKIP_SET_WAKE flag for
 pinctrl irq chip
Message-ID: <20140527080746.GB4730@lukather> (sfid-20140527_101748_681419_B00BE04C)
References: <1401090486-4414-1-git-send-email-hdegoede@redhat.com>
 <1401090486-4414-3-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
In-Reply-To: <1401090486-4414-3-git-send-email-hdegoede@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 26, 2014 at 09:47:57AM +0200, Hans de Goede wrote:
> From: Chen-Yu Tsai <wens@csie.org>
>=20
> The sunxi pinctrl irq chip driver does not support wakeup at the
> moment. Adding IRQCHIP_SKIP_SET_WAKE lets the irqs work with drivers
> using wakeup.
>=20
> Also add a name to the irq chip.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/pinctrl/sunxi/pinctrl-sunxi.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunx=
i/pinctrl-sunxi.c
> index db9ccd6..ec60c2e 100644
> --- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
> +++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
> @@ -646,6 +646,8 @@ static struct irq_chip sunxi_pinctrl_irq_chip =3D {
>  	.irq_mask_ack	=3D sunxi_pinctrl_irq_mask_ack,
>  	.irq_unmask	=3D sunxi_pinctrl_irq_unmask,
>  	.irq_set_type	=3D sunxi_pinctrl_irq_set_type,
> +	.name		=3D "sunxi-pio",
> +	.flags		=3D IRQCHIP_SKIP_SET_WAKE,

I'd rather see the name set to dev_name() or something like that. This
will not work that great with multiple pin controller supporting
interrupts.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJThEfSAAoJEBx+YmzsjxAgemUP/3yI6XcdPZgPYFYTPh0RX0I2
b7IlgHuWJ2jnYiyk15jZ5n0afd4EJngy646fXE7VqZYpGaQ239llJCIEkwlPe03r
RaFD3Aft4S4dJd8qlTBk0q+NXEEmlee4aC8fAnxxfMZfZAXA/kNTmMNcqnlF78Oh
fRtgu4Zj1EYTSx4BNOaSnonSn09hFqWcojtHwHgP7TagJCZkAb4fExHsntGiUnyr
NQdvUOt7yD2ZrIwAs6USbJNcV+wOBS4JY8t/zN1vT8Dd8Xet6CnbMgLzp95JG5ZL
xAiJcga2O9u3KRcu1/RkSqp379VSsyYM61u9SrAXhlefrixJVZhLACh6bWATxquW
2ImCrdw2LpLNnXi/Uecjwf8BlE6pKPB1CNWIbIOXPFldAXUKRo0n7AfO+LKfX/AY
OAHbv8rtIro6eoK4+NwyYqW27GTWW/gWI4/eB9U0u751OE5h5RQO9lXBjFOxnSWd
UgWqBpAVJaaTL3Cqaj6hjRrwLqnULYNbukkF4zwcR06o3Nfi5FY45bf+ipRDC3nS
gl5cfGiXdP4NBH8ojKA6e+/I8Bii9e0XKh/qZf9UesGnY16InwqLL6qjkjEIAstT
jZwjAnXkofVt3b/AyFgQanVZiKbQqXNgi/XrZIVA528QEu6YdpTxnVqNrQ8Z3KTo
3aeOeT4KGeEKjb0Yxtkz
=JPY0
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--
