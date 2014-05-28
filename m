Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:43623 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751711AbaE1JkF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 05:40:05 -0400
Date: Wed, 28 May 2014 11:39:06 +0200
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
Subject: Re: [PATCH 03/11] pinctrl: sunxi: Move setting of mux to irq type
 from unmask to set_type
Message-ID: <20140528093906.GO4730@lukather> (sfid-20140528_114022_674695_32ABE9C1)
References: <1401090486-4414-1-git-send-email-hdegoede@redhat.com>
 <1401090486-4414-4-git-send-email-hdegoede@redhat.com>
 <20140527080952.GC4730@lukather>
 <5384544F.6000806@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uWbmMdDzzl2TXAgx"
In-Reply-To: <5384544F.6000806@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--uWbmMdDzzl2TXAgx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 27, 2014 at 11:01:03AM +0200, Hans de Goede wrote:
> Hi,
>=20
> On 05/27/2014 10:09 AM, Maxime Ripard wrote:
> > On Mon, May 26, 2014 at 09:47:58AM +0200, Hans de Goede wrote:
> >> With level triggered interrupt mask / unmask will get called for each
> >> interrupt, doing the somewhat expensive mux setting on each unmask thu=
s is
> >> not a good idea. Instead move it to the set_type callback, which is ty=
pically
> >> done only once for each irq.
> >=20
> > *This* is the bad idea. Nothing prevents you from calling
> > gpio_get_value whenever you just got your interrupt, that will change
> > the muxing, and never change it back, effectively breaking the
> > interrupts.
>=20
> Hmm, interesting point, but your assuming 2 things which are both not tru=
e:
>=20
> 1) That calling gpiod_get_value changes the muxing, which is not true, all
> gpiod_get_value variants end up in drivers/gpio/gpiolib.c _gpiod_get_raw_=
value()
> which does no such thing

Somehow I was convinced it was the case, but yeah, it doesn't really
make much sense, especially since you can get the value of an output,
without wanting to change it to input.

>=20
> 2) That unmask will always get called after the gpio_get_value to restore=
 the mux
> setting for us, which is not guaranteed at all. Before this patch set pin=
ctrl-sunxi.c
> was using handle_simple_irq which does not mask / unmask at all.
>=20
> And even with an irq-handler which masks / unmasks, what if the irq wakes=
 up
> a thread and that thread then does the gpio_get_value ?
>=20
> Note this is *exactly* what e.g. the mmc gpio card-detect code does, it u=
ses
> a thread to read the gpio for debouncing.
>=20
> Luckily 2. is not a problem, since 1. means that the mux won't get change=
d at all
> so we don't need to change it back.

Ok.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--uWbmMdDzzl2TXAgx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTha66AAoJEBx+YmzsjxAgUr8QALuQMqsa7xEoyVm956BpvhM9
94MPksjtcXOgDr0DQtUMTRKsr0dOP2PQhuyKTwLiH9lqtm9LIlc3EO9SSVlYGVGl
RUvl0XOpaZZgODDzwnc/o41uiA/NQ3Ufc0dINAf+Avai0DTNjIBd42pSA6b95wHz
qwv2BA7l4ezb8KgGz0vXzZfVF+FxPadW2wWw6GtS3LUpa2YpL2Fqr6GURzigIVpu
Ji1/5GoeRztoUJ54881EZWXWrVKuQxPPDaTfF1HLqMDhkX2BgeUSyWpwQBsA2ydu
+9N2pEQFQwspARzdzJ03bNWasha7aVBOBAQmZaPqr6+jird1tqPjYqLWbNp1/13a
G5U1/qn01rT1+GL1wEzI6mUPbU3GMlEnqNKdekvm1KG3xHLRSuUQnt97b/zI5u21
MxgGbjHrNbqVejjqQRmplyNaRjK1xJvImYQpJIeY0qO6gmn1aYIL/qEa4njhXo92
GdNkI/tSwUaci2WbYhvojIptDkskYiH8jcc7EfJkFJje9ZlU1KsyoRIyfpdNdwGe
sV+pNewmagHRPOQWnKtV+arXNN3v0RuSxGKhRDiCVknLGOTkZs6vozmViDZh16xZ
HejH/fO1bMxsEjzhR0lRJBZIJ0x0hf9IWoro7D9NadsIyliqfu6nn4t42FEo55nB
8irL58/Z52y/wRD31shr
=vCef
-----END PGP SIGNATURE-----

--uWbmMdDzzl2TXAgx--
