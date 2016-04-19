Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54808 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125AbcDSRHn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 13:07:43 -0400
Date: Tue, 19 Apr 2016 18:07:31 +0100
From: Mark Brown <broonie@kernel.org>
To: "Reizer, Eyal" <eyalr@ti.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Eyal Reizer <eyalreizer@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>
Message-ID: <20160419170731.GB3217@sirena.org.uk> (sfid-20160419_190811_058357_41EF75C0)
References: <1460273570-12298-1-git-send-email-eyalr@ti.com>
 <8665E2433BC68541A24DFFCA87B70F5B360B6C90@DFRE01.ent.ti.com>
 <14313437.cDJIgY3kzo@wuerfel>
 <8665E2433BC68541A24DFFCA87B70F5B360BF614@DFRE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="m3zcgECJg5Qgddwj"
In-Reply-To: <8665E2433BC68541A24DFFCA87B70F5B360BF614@DFRE01.ent.ti.com>
Subject: Re: [PATCHv2] wlcore: spi: add wl18xx support
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--m3zcgECJg5Qgddwj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 18, 2016 at 05:55:51AM +0000, Reizer, Eyal wrote:

> > I would suggest fixing this using a new API function from the SPI core,=
 if we
> > don't already have a generic way to do it.

> Originally this is what I have done until I was pointed to the generic cs=
-gpio mechanism=20
> in the SPI core.=20
> It is a generic mechanism already in the SPI core driver.
> See: Documentation/devicetree/bindings/spi/spi-bus.txt

> It is also part of the generic spi.h (include/Linux/spi/spi.h), already p=
art of=20
> " struct spi_device" So it seemed redundant adding another mechanism for=
=20
> implementing the same.

No!  This is a *terrible* and broken idea.  Client drivers should *not*
be peering inside controller implementations like this, and they should
especially not be trying to change the chip select without the core
knowing about it.  This is at best going to be fragile, at worst it will
actively break some systems.  Whatever you are trying to do needs to go
through the SPI core with some degree of abstraction, the core needs to
know what's going on and the driver needs to support systems that don't
or can't mux the chip select out as a GPIO.

--m3zcgECJg5Qgddwj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJXFmXSAAoJECTWi3JdVIfQQzwH/3Rjx9TUJqPDdISE8n7y1lN+
c4IwT396JHdP0+B9ewcv1CMp7OqBj4/HQIQcZPW+PS5w3awzRyzWxs/Smir+qet5
mOPxB+GJAXB5H/fp1LH0Z/q/WFf2/1PimTvEztP4smIiOa9WDYiWlW7ppGOGNbu2
3+wMVJ4X/+4MqBWyCI/T26Gn10+vAMtEazMZ48im2Vr3Fm8NxLz3JnYVzYDb4y1q
H5f0b4lzW2EAvpWyvylwbnfKAuiH+mkRiHjlee2ppeoL08d6L1UlE7gEuKweUaqp
J2cTg9VnTIi18NTkOZXWxI03QkJBZ4FiSmm3HHca00ShOzafLLdDeSYeh4Zl4OQ=
=g+t8
-----END PGP SIGNATURE-----

--m3zcgECJg5Qgddwj--
