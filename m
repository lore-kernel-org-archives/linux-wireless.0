Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:38649 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752858AbaFBKfE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2014 06:35:04 -0400
Date: Mon, 2 Jun 2014 12:33:51 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
	Chris Ball <chris@printf.net>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Chen-Yu Tsai <wens@csie.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 03/11] pinctrl: sunxi: Move setting of mux to irq type
 from unmask to set_type
Message-ID: <20140602103351.GC27722@lukather> (sfid-20140602_123533_464407_A64E08C4)
References: <53899D21.3000008@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lMM8JwqTlfDpEaS6"
In-Reply-To: <53899D21.3000008@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--lMM8JwqTlfDpEaS6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 31, 2014 at 11:13:05AM +0200, Hans de Goede wrote:
> Hi,
>=20
> On 05/28/2014 12:33 PM, Maxime Ripard wrote:
> >On Wed, May 28, 2014 at 11:51:52AM +0200, Hans de Goede wrote:
> >>Hi,
> >>
> >>On 05/28/2014 11:36 AM, Maxime Ripard wrote:
> >>>On Tue, May 27, 2014 at 04:18:29PM +0200, Linus Walleij wrote:
> >>>>On Mon, May 26, 2014 at 9:47 AM, Hans de Goede <hdegoede@redhat.com> =
wrote:
> >>>>
> >>>>>With level triggered interrupt mask / unmask will get called for each
> >>>>>interrupt, doing the somewhat expensive mux setting on each unmask t=
hus is
> >>>>>not a good idea. Instead move it to the set_type callback, which is =
typically
> >>>>>done only once for each irq.
> >>>>>
> >>>>>Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> >>>>
> >>>>Yes move it out of mask/unmask but no, not into set_type().
> >>>>
> >>>>Can you not use the irqchip startup()/shutdown() callbacks
> >>>>instead?
> >>>
> >>>I think we can use irq_request_resources then
> >>>https://lkml.org/lkml/2014/3/12/307
> >>
> >>Sounds good, I'll modify the patch to move it here before posting a v2 =
of
> >>this series. Note v2 likely won't happen till this weekend, -ENOTIME.
> >>
> >>>We could even merge the gpio_to_irq code into it.
> >>
> >>Erm, no we need that as a separate function for the gpio_chip's to_irq
> >>callback.
> >
> >Linus sent a patch stating otherwise a few weeks ago, and was
> >suggesting moving it to irq_startup.
> >
> >https://lkml.org/lkml/2014/5/9/50
>=20
> That is not going to work, that patch uses gpiochip_irqchip_add,
> which in turn uses gpiochip_to_irq as to_irq handler, which
> assumes that gpio offset =3D=3D irq offset, which is not true for
> sunxi-pinctrl.
>=20
> Specifically gpio_chio_to_irq does:
>=20
> static int gpiochip_to_irq(struct gpio_chip *chip, unsigned offset)
> {
>         return irq_find_mapping(chip->irqdomain, offset);
> }
>=20
> Where as the sunxi code does (simplified):
>=20
> static int sunxi_pinctrl_gpio_to_irq(struct gpio_chip *chip, unsigned off=
set)
> {
> 	struct sunxi_desc_function *desc =3D sunxi_pinctrl_desc_find_function_by=
_pin(pctl, offset, "irq");
> 	return irq_find_mapping(pctl->domain, desc->irqnum);\
> }

Yes, I know it's not going to work, but my point was that gpio_to_irq
might not be called by the drivers, and it's still valid not to do
it. So we might end up with a driver requesting an interrupt that
won't be muxed to it.

But thinking more about it, it would be wrong to remove the .to_irq
callback completely either, since drivers might need a "secondary"
interrupt (like the card detect one for an MMC driver), and a lot of
these use an additional gpio property to do so. So we need to keep it.


Nevermind then.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--lMM8JwqTlfDpEaS6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTjFMPAAoJEBx+YmzsjxAgTU0P/RrB9hJTlWIpQD97ZlUvCEiG
HKhWJrR0XTBwBD3mO9tlMkE3r5RhyiEeW3EYmVH4dz7X81+vL0kgKH8Feib+VDAE
SrRnVBc4MCAsnjcTl4ZYrZbYC0EN8LiGgHzYG8Pce5L3kPj6atI5wzZdN/M/Bt5R
zJaiQjcsU7H2cOjsrScMHWbArnt03EjZpn+MY6hzSQBXA/XZ6Ka5YZv/ZCwVEAoF
K4DEKUBs+IZuJAa2ZC3GIVvEqA7nVRZkq8FIRgMCTdKnTILSJQ1OwOc4OnOARSAI
C/AsQr8wjx2qJlwREkHcFPX4kRe7My38cHNKSIhNxTXXi1SnKXNZpq2DP8LqTZY+
2odTtKVRtdxH+58Kk4UBIZZr+wfQQ8deWWk2pIN5TqAf32ByEyV9kUKz4zuslIuO
kWLmYjxjFXDez6YzFtVJ1WX0iQHDtNeroquYdIGgHhCs+W0B3sczGYRKMIg2VUgH
MSzSJUbvkzGIvcOQj+voC0j0Sd1WHBv2E/jzF/hkhZp3nzDmFqkk2MMjB90qcv5G
fX8TbOl09YpvpVIRCc91jIe78uO0QOD2ZI54USIf7xuPxG8xyKyZs8BIiTYADsYG
DWzFmnr2e+8DK/Ew3yD2GUZKvX8Qr5PycXntGMLVE5XLIOZ1FmxPegnnyBrLyNhX
OoWPGoOW5JC9xBqtiOTV
=Qx7n
-----END PGP SIGNATURE-----

--lMM8JwqTlfDpEaS6--
