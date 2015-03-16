Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ring0.de ([5.45.105.125]:55502 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932670AbbCPSb2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 14:31:28 -0400
Date: Mon, 16 Mar 2015 19:25:37 +0100
From: Sebastian Reichel <sre@ring0.de>
To: Tony Lindgren <tony@atomide.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org,
	Eliad Peller <eliad@wizery.com>,
	Mark Rutland <mark.rutland@arm.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Sekhar Nori <nsekhar@ti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Rob Herring <robh+dt@kernel.org>,
	=?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
	Kumar Gala <galak@codeaurora.org>,
	Javier Martinez Canillas <javier@dowhile0.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Luciano Coelho <luca@coelho.fi>,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH v6 6/6] wlcore: remove wl12xx_platform_data
Message-ID: <20150316182536.GA16829@earth> (sfid-20150316_193132_650740_B6FF770D)
References: <1426162154-8716-1-git-send-email-eliad@wizery.com>
 <20150313151301.GJ5264@atomide.com>
 <CAB3XZEdFMQexA69JEuw=VnqsNOEkWAM0+oWWmt6DaN9+hZ+vdw@mail.gmail.com>
 <2070859.WcMooC33YH@wuerfel>
 <20150316152939.GP5264@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
In-Reply-To: <20150316152939.GP5264@atomide.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Mar 16, 2015 at 08:29:39AM -0700, Tony Lindgren wrote:
> * Arnd Bergmann <arnd@arndb.de> [150315 05:10]:
> > On Sunday 15 March 2015 10:50:42 Eliad Peller wrote:
> > > yeah, i missed it :/
> > >=20
> > > looks like there's no platform that defines platform data for it.
> > > i'll replace the dev_get_platdata() with a function that only parses
> > > the clock-frequency properties (the irq is taken in this case from the
> > > spi_device).
> > > (or maybe i should just drop it, as no one actually uses it?)
> >=20
> > I don't think we should drop the driver, but dropping the platform_data
> > support sounds reasonable. New users of this driver should all be using
> > DT, and if there is a good reason to use platform_data, it's easily
> > put back.
>=20
> Well we have n8x0 and n900 using the spi driver. For those, n8x0 boot
> all in dts mode, but n900 still also boots in legacy mode. It seems the
> board-rx51-peripherals.c only passes the power_gpio though, so that
> should be easy to keep around.
>=20
> We should keep things still working for n900 in legacy mode until the
> pending regressions with device tree based booting have been cleared
> for at least one merge cycle. I believe the last pending issues is the
> support for ATAG_REVISION in device tree mode as posted by Pali.

mh by migrating to newer gpiod interface platform data is no longer
needed (instead the boardfile would need a gpiod_lookup_table). That
way all of the dirty code is in the board file and will be removed
once the time comes. See for example rx51_fmtx_gpios_table.

Note: This is independent of wl12xx changes, since N900 uses wl1251.

-- Sebastian

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJVByAdAAoJENju1/PIO/qaugAQAJyd6jAeZYJsxqG5J2qkey+g
Zb+K1Q2yw9koChF9MMersXC4Rz8ClOZLKGx9/WWBZ8HAAlYzIrmMAP0BjCjgfswC
8u/a56VK5smNiG+9hdromtnBRKh9zpKel/nOpC+0CNP21rJevvxA4c7S2lc+ACM8
4bCvayP3PBaklZq8xSEM2NrqGNv6g2TR5+yooUMbbDbG6fg8oH/2IzkcP0StrKT7
uXSUYufCDMAUllhhM4R5bt82pOJDtmx4AB0WikVmU3ldfgC3Uf8J6g9STr8lwPX2
v19xi+8cnSE2nQtvjig35QDYiVONIP+IRoWVNezLHS3fQpMxdwSFeeQPRWN6nDvc
n3ta2C2v213hB/mIxJ8ODhXx2b/MpraaFKjn0ml8ye0T8u/PU6ZbciTgLxHZoKtV
JXwf0VvmO0+Qy2tTt5Zf/S0XNGx7zAojbRT6o/s8fxDpta/rsIPE5W+A8mtrlKhf
Am4vFn3N4fCwmDIEhSpQXEe/W2hLWlmIlm0jMjg2ANVJiYNabx/kBPDb2BUhNJ+b
wTrLv9V0L2+3Iizx6HvMKT1dt9CPf+av3vdq+wJrNBYh099pNTgbHl5j+etq09Oe
73bSwtA7S1vuiGdif08AqYgKZJohoGUH1WguJ5g8klQ0G58mPrtKSYxCA8c5RGWQ
Utgjq73IYFFZw0R5qCon
=X9g0
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
