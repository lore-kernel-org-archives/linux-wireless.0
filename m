Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54818 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404AbcDSRMs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 13:12:48 -0400
Date: Tue, 19 Apr 2016 18:12:39 +0100
From: Mark Brown <broonie@kernel.org>
To: "Reizer, Eyal" <eyalr@ti.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Eyal Reizer <eyalreizer@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>
Message-ID: <20160419171239.GC3217@sirena.org.uk> (sfid-20160419_191311_266969_F60B6993)
References: <1460273570-12298-1-git-send-email-eyalr@ti.com>
 <14313437.cDJIgY3kzo@wuerfel>
 <8665E2433BC68541A24DFFCA87B70F5B360BF614@DFRE01.ent.ti.com>
 <1463330011.BhWEcYYuGD@wuerfel>
 <8665E2433BC68541A24DFFCA87B70F5B360C0745@DFRE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="4cv0JMvpEKiCIDl2"
In-Reply-To: <8665E2433BC68541A24DFFCA87B70F5B360C0745@DFRE01.ent.ti.com>
Subject: Re: [PATCHv2] wlcore: spi: add wl18xx support
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--4cv0JMvpEKiCIDl2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 19, 2016 at 09:05:45AM +0000, Reizer, Eyal wrote:

> Understood. As this special CS manipulation is unique to wspi (wilink spi=
)  I think the=20
> best option is to move this gpio allocation into wlcore_spi as a new devi=
ce tree entry
> used only by this driver.

That sounds like it is going to break normal chip select operation which
doesn't seem like a good idea either.  What exactly are you trying to do
here?  If you need to send some extra bytes at the end of a transfer why
not just do that, or add an empty transfer with a delay.  It's hard to
see what more you could do with only control of the chip select...

--4cv0JMvpEKiCIDl2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJXFmcGAAoJECTWi3JdVIfQV3cH/13tX6IFbyU7cJBFsp94l8u0
RZ8ygWZrra/QQMyPguVMdheFO50a6wPZL1nZ0iPa2Zp8b0RUCjCuuDxtjoJf5QD6
39GH1LuyIK122A2S1DG5aRP8HjUtrOT5s1oE8IwGSTxSow9E60bJPOHoDt23uoFi
EDa6F+MnQ0QhPSQhKdUEwVCrNCep+qEmQxOT83fei+xd3MFAFtb9vTACNaPexOO4
iRU94K2wUO1np7ug8M9Q4Sx5inkXh+Fy3Ug34x2fWG8prhqa/TDXXfu/IyfDwlpM
0UIWRQheG7zxMdGqGsXL84gI4k6mNZKn0f37vwmGV3ioan07BzSY+LkBREXpv7I=
=FdXk
-----END PGP SIGNATURE-----

--4cv0JMvpEKiCIDl2--
