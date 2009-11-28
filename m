Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39362 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbZK1NM3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 08:12:29 -0500
Subject: Re: rfkill: persistent device suspend/resume
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Marcel Holtmann <marcel@holtmann.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ian Molton <ian.molton@collabora.co.uk>,
	linux-acpi@vger.kernel.org, Corentin Chary <corentincj@iksaif.net>
In-Reply-To: <20091128124158.GB17373@khazad-dum.debian.net>
References: <4A37A3E1.8060606@tuffmail.co.uk>
	 <1245161645.13461.3.camel@johannes.local> <4A37AEB7.6060405@tuffmail.co.uk>
	 <20090618030806.GE29569@khazad-dum.debian.net>
	 <20091128124158.GB17373@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-NRRMdYzNejdBaFuSnhUZ"
Date: Sat, 28 Nov 2009 14:12:25 +0100
Message-ID: <1259413945.5428.21.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NRRMdYzNejdBaFuSnhUZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-11-28 at 10:41 -0200, Henrique de Moraes Holschuh wrote:

> What do you guys think?   I will cook up a patch to implement the above, =
but
> if there are any objections to the idea, I'd like to hear it ASAP, as I d=
o
> have a regression to fix :)

What part of that don't we do?

static int rfkill_resume(struct device *dev)
{
        struct rfkill *rfkill =3D to_rfkill(dev);
        bool cur;

        if (!rfkill->persistent) {
                cur =3D !!(rfkill->state & RFKILL_BLOCK_SW);
                rfkill_set_block(rfkill, cur);
        }


johannes

--=-NRRMdYzNejdBaFuSnhUZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLESG2AAoJEODzc/N7+QmaoRYQAKm3BrfyM/9J6um4zJ0PDr1N
MAZFKJzFhhXAXYTpjhP6bYxkPAF4KilN7wCpHUMtt3gXzBPcTjpQgkbjjWGF7gvG
dNpIBkr6uAVqHuD6NT//qjrasa3+/NDuF1aaR07ZyxVqjVL65n/FUFlGdIxgvLpl
tNx3gtTtKTKawV33xL0HAOpBrKdO6MFeUA69RrfEAgPT375N8ZdrBzJdKEXcYn4y
41lDopxvVMVhMcbLxp/YvC3MYLX7FUptntIMvR9WDTiQ2t0RSKxZmoui7YAqwuBQ
CB62m69g1n1q9S7beU2f3iZEBsdrrNIvJmvuHY/HRrW2zF7sPFJ1ZiIIWTGcXj1l
ExJniGsmV1LMCM5W8MQXAwPgsLM20hp1qK4IJddQPC68esbYsBdVlM5tRjj6PrYV
h1Bbqsuh+2Ry1D7PD/CK/ISvzSq5Hk2ArMOZPqlSizfdi7MdImmcgzLQFPzpP8J7
6jqsUaAfeIA/9rwfU2wONOH/BvegQljS9981D0WopP636zvwMZAdZAhBUcFJuYlq
E4jDvyRqGhOtulXzvt158ZZPvVP0yRUM/A5SzL15UYP3+G6Bu4Jm0WRC/zqg0T9Y
d2XCnOontGQOC3VTB7AmKED+LwOvsunbq02so8tAwW4hKAL9pbEM3RUkLAwzDnFb
Aqn2lJGibA2UbUa6vfQs
=rBib
-----END PGP SIGNATURE-----

--=-NRRMdYzNejdBaFuSnhUZ--

