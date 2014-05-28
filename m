Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:43614 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752348AbaE1JkF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 05:40:05 -0400
Date: Wed, 28 May 2014 11:36:53 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Hans de Goede <hdegoede@redhat.com>, Chris Ball <chris@printf.net>,
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
Message-ID: <20140528093653.GN4730@lukather> (sfid-20140528_114022_010584_DD5D815E)
References: <1401090486-4414-1-git-send-email-hdegoede@redhat.com>
 <1401090486-4414-4-git-send-email-hdegoede@redhat.com>
 <CACRpkdZcGJTXfcxN_sogm+hYHM56d_VxtuZqth0t-c2mgAJ0vA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2YJj5f1P6Th4nBRw"
In-Reply-To: <CACRpkdZcGJTXfcxN_sogm+hYHM56d_VxtuZqth0t-c2mgAJ0vA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--2YJj5f1P6Th4nBRw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 27, 2014 at 04:18:29PM +0200, Linus Walleij wrote:
> On Mon, May 26, 2014 at 9:47 AM, Hans de Goede <hdegoede@redhat.com> wrot=
e:
>=20
> > With level triggered interrupt mask / unmask will get called for each
> > interrupt, doing the somewhat expensive mux setting on each unmask thus=
 is
> > not a good idea. Instead move it to the set_type callback, which is typ=
ically
> > done only once for each irq.
> >
> > Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>=20
> Yes move it out of mask/unmask but no, not into set_type().
>=20
> Can you not use the irqchip startup()/shutdown() callbacks
> instead?

I think we can use irq_request_resources then
https://lkml.org/lkml/2014/3/12/307

We could even merge the gpio_to_irq code into it.

It's called in __setup_irq, so it's guaranteed to be called, and it
will bail out early without doing anything, since it's one of the
first thing __setup_irq does.

> And how come we have no clean separation between gpiochip
> and the pinmux parts here, why cant we just call
> pinctrl_request_gpio() and pinctrl_free_gpio() here instead?
> Or maybe pinctrl_gpio_direction_input() and have that set
> up the muxing in the pinctrl driver side?

Because the function it has to be muxed to is neither gpio_in or
gpio_out, and it's not even considered a gpio. It really is just
another muxing function, like i2c or mmc.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--2YJj5f1P6Th4nBRw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTha41AAoJEBx+YmzsjxAg4tcP/1UvvatNfABOs5guVCHqh4Tr
YnK8WvmzQJkSsmXb7Tktl29YU9aUWacvc+cKf8t+ByWZgyOUefJWVgMO/PT7f1id
mr/Ux9w5UqgcNEJ6r69pYJoXb8GVkT2aXGaJ2jwQY4zrPuY0DlLObbTK/aKTJv/r
LhdSN3VFkRIfJroPCZdKdU8/lTes7lAhUAI0J1UHniYof3pZsx/+q45PvB2TxbeG
plnex8U0yRGe+kEL0waf3G/K64PS2mP71WBVHnksZpb2JhHhp53PwCEvnl/g4qRd
YUW7oRXwFiner+ASyAwkHuzOumGPb2MbndEAQvT+CM6uOuIpT6IeaAd1le9Kytp6
EjQ4PQeZIjCsETy6yN5whF/RfUgz2FqvwkJmEBKDdRuWC2p3y/O2l1LbEFO2txay
+s3scBoP0tfMPv3uWfwPz05U24QPuSMCpAG1+XhvekW4f2PGgn+WTJxA7M9tYAF9
655p2aYWYwPBWtLXYeHy3BPf2R4DwkDQrTkhVwM3s+6e5FoAAI/hQlr4un6pSX0Y
A5X+Tlvwh1XyPLSOEGPwamWWiwgTLanRwpgjC/9NYlk48Zg5C2vCo2s8+XFuJcQz
6wGinKnQ03mm6GdcMHi43ykK2rC3pPGVf1RmPNoXySI1S4bKNVZ8xK05lGZzjXCq
2V4qiKjeHXHRoM+fXYpp
=oL2X
-----END PGP SIGNATURE-----

--2YJj5f1P6Th4nBRw--
