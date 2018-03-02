Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59046 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424455AbeCBJDP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 04:03:15 -0500
Date: Fri, 2 Mar 2018 10:03:12 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "open list:LED SUBSYSTEM" <linux-leds@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>
Subject: Re: [PATCH v12] ath10k: add LED and GPIO controlling support for
 various chipsets
Message-ID: <20180302090312.GA30267@amd> (sfid-20180302_103519_031714_9407B856)
References: <20180226084406.2093-1-s.gottschall@dd-wrt.com>
 <CACna6rzD6z3DC6yjMCgBxgxx+DF+GGu69Ot5QA6xpJ41Ewb2=A@mail.gmail.com>
 <82d8ac0c-b391-6099-4c7f-991cc35445aa@dd-wrt.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
In-Reply-To: <82d8ac0c-b391-6099-4c7f-991cc35445aa@dd-wrt.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >>adds also debugfs interface for gpio control.
> >Hi Sebastian,
> >
> >I just noticed this patch and have one question. It seems you register
> >GPIO chip and that WiFi LED is controller by a GPIO. Shouldn't you use
> >leds-gpio driver and just register platform device with
> >gpio_led_platform_data? That way you could avoid some code duplication
> >I think? It seems to be the purpose of leds-gpio driver.

> leds-gpio is crap and limited. you can just register one platform data at
> kernel runtime since its identified by its object name "led-gpio" but the
> kernel forbidds to register 2 platform datas with the same name
> consider the ar71xx devices with qca988x wifi chipsets. they all have
> already a led platform data registered
> at boottime. a second can't be registered anymore so gpio_led is useless =
at
> all for most developers on such platforms. its mainly used for early kern=
el
> platform data initialisation for system leds.

If leds-gpio has limitations, please fix those, rather then
introducing duplicated code.

NAK.
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlqZE1AACgkQMOfwapXb+vIeLQCfc0gqxgg5FfWUqBHeEy5lb4Ia
SNYAn1e8wy+tzVSTus6fTnA8FMLkNUXx
=5wqF
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
