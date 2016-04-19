Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54912 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbcDSRyT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 13:54:19 -0400
Date: Tue, 19 Apr 2016 18:54:02 +0100
From: Mark Brown <broonie@kernel.org>
To: "Reizer, Eyal" <eyalr@ti.com>
Cc: "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
	=?utf-8?B?15DXmdeZ15wg16jXmdeZ15bXqA==?= <eyalreizer@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>
Message-ID: <20160419175402.GE3217@sirena.org.uk> (sfid-20160419_195628_599136_19A3AD20)
References: <1460273570-12298-1-git-send-email-eyalr@ti.com>
 <14313437.cDJIgY3kzo@wuerfel>
 <8665E2433BC68541A24DFFCA87B70F5B360BF614@DFRE01.ent.ti.com>
 <1463330011.BhWEcYYuGD@wuerfel>
 <8665E2433BC68541A24DFFCA87B70F5B360C0745@DFRE01.ent.ti.com>
 <20160419171239.GC3217@sirena.org.uk>
 <sjdvun1fuj4nyi0bgf268g53.1461086401627@email.android.com>
 <20160419172706.GD3217@sirena.org.uk>
 <oe8hqfknrcljrjawnrxlohvr.1461087275186@email.android.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="xzV2nyj/vUZRUtI2"
In-Reply-To: <oe8hqfknrcljrjawnrxlohvr.1461087275186@email.android.com>
Subject: Re: [PATCHv2] wlcore: spi: add wl18xx support
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--xzV2nyj/vUZRUtI2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 19, 2016 at 05:38:02PM +0000, Reizer, Eyal wrote:
> Hi Mark,
>=20
> Hope you can see the attached picture that illustrates what need to sent =
for sucesfull SPI init.

I think what the picture shows is that you just need to send at least
one byte at the end of the transfer *after* deasserting /CS which is
totally not what I'd have understood from any of the previous
discussion.  That is already supported, just send an extra byte using
=2Ecs_change to do what is says.

--xzV2nyj/vUZRUtI2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJXFnC3AAoJECTWi3JdVIfQU8kH/3jz5VWTyBTQmHtKqmredWGw
RCR7Gu9WWJy4QZKDJsnKK0bfYB2uwv2CoiWQoHsfKmnQUOImfeO3AsoMqKgFOqlB
ejS61RJfH8LGFv9vYR+6+hiAetRz1QU8klHemhxZ+DoYkTeqTW2hb6Igzr2TVrEi
OJQDhPYSBJFqEjrd3U7Ew/lLHmpTmq0ITo2OPn203djVqUlaBnS/jbS5LFriGfds
cAd6FKENsrYdq3r4YNpoi7pD2heRWK4mPKzSrza6cAN//HB7Uqx0FO9A2tsh4Q7+
bsyY/GKjhwuo6CfP0LVuzcw8pQ+WaMj4lOa86b2W0t4ZzITDHEQC3BLsFKhWAEo=
=1OGS
-----END PGP SIGNATURE-----

--xzV2nyj/vUZRUtI2--
