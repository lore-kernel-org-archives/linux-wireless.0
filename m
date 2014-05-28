Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:44125 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751662AbaE1KfE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 06:35:04 -0400
Date: Wed, 28 May 2014 12:33:51 +0200
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
Message-ID: <20140528103351.GQ4730@lukather> (sfid-20140528_123509_932990_099EEC2B)
References: <1401090486-4414-1-git-send-email-hdegoede@redhat.com>
 <1401090486-4414-4-git-send-email-hdegoede@redhat.com>
 <CACRpkdZcGJTXfcxN_sogm+hYHM56d_VxtuZqth0t-c2mgAJ0vA@mail.gmail.com>
 <20140528093653.GN4730@lukather>
 <5385B1B8.8070803@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0UhZIN3Sa23/ILEd"
In-Reply-To: <5385B1B8.8070803@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--0UhZIN3Sa23/ILEd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 11:51:52AM +0200, Hans de Goede wrote:
> Hi,
>=20
> On 05/28/2014 11:36 AM, Maxime Ripard wrote:
> > On Tue, May 27, 2014 at 04:18:29PM +0200, Linus Walleij wrote:
> >> On Mon, May 26, 2014 at 9:47 AM, Hans de Goede <hdegoede@redhat.com> w=
rote:
> >>
> >>> With level triggered interrupt mask / unmask will get called for each
> >>> interrupt, doing the somewhat expensive mux setting on each unmask th=
us is
> >>> not a good idea. Instead move it to the set_type callback, which is t=
ypically
> >>> done only once for each irq.
> >>>
> >>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> >>
> >> Yes move it out of mask/unmask but no, not into set_type().
> >>
> >> Can you not use the irqchip startup()/shutdown() callbacks
> >> instead?
> >=20
> > I think we can use irq_request_resources then
> > https://lkml.org/lkml/2014/3/12/307
>=20
> Sounds good, I'll modify the patch to move it here before posting a v2 of
> this series. Note v2 likely won't happen till this weekend, -ENOTIME.
>=20
> > We could even merge the gpio_to_irq code into it.
>=20
> Erm, no we need that as a separate function for the gpio_chip's to_irq
> callback.

Linus sent a patch stating otherwise a few weeks ago, and was
suggesting moving it to irq_startup.

https://lkml.org/lkml/2014/5/9/50

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--0UhZIN3Sa23/ILEd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJThbuPAAoJEBx+YmzsjxAglxgP/0k/zqqXxIaurdLrYu3NWmZI
SFMbcggtnBu9z8xL4xviBmGOplDfJHMMvodkf8BOkr8n+RyW0HZFB5kKEpguC8LQ
/v4x3GL1sQMbQx5qWmJTcFkCCrUZOEcwZl8ulKOEzkBqDRn2awOu2bR2KkF75PZt
LkSxmn+fEkleURuu3RtiXNNcov5rNS0DNFTkgxHP1Z/ZP6ddcknJKtj0YJvdniWJ
G8hhPS/ssAHXkUAkukmUflxyCETwJQRyKCkXp8QLs0hY/EhRSdaolzoGL7VGTLIq
i5BgBhqgUz/m1JSLlP3RcGXLj4S50/dPfzSUOHvB1pN32k227Vt+PyjMoVkV5RSF
v8k3QwmF8QP8CqF519PMIGJHFKV9xsl3VYlyu8O63dm5Kavjh74PpB8umQL59aiA
gl5Agvcu84GRO+IvujdCe6hdxb2kzV0k0RZVR2iP1QHIYeR3IW29Cj1GliF8Eh4D
nB1BKHztRrX/xgWixd8C+p5CPx7p7puTfhsbTePTatkPhv1CCL83NBfftsH2x7iY
wFpsb0Z02jzAxeIt3J4ActH4c/2TmLFMvtB8x8LDfYd64UDM/nGBRhJceskiWOKO
+rR5Sw3+SeKtBLvQVgAx65DEvMt8k1upZRZtw5cecDDpo7qUZK/AaaFNjs7hyqyD
9qROitLKhNzKUjaEHneb
=b4iU
-----END PGP SIGNATURE-----

--0UhZIN3Sa23/ILEd--
