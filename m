Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:57479 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbaEJPRk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2014 11:17:40 -0400
Date: Sat, 10 May 2014 17:17:21 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [RFC][PATCH] b43: drop SSB dependency
Message-ID: <20140510171721.54b21a63@wiggum> (sfid-20140510_171802_713697_043CF60D)
In-Reply-To: <1399733088-26607-1-git-send-email-zajec5@gmail.com>
References: <1399733088-26607-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/0Waat6fnDhemZg540_DpPaX"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/0Waat6fnDhemZg540_DpPaX
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 10 May 2014 16:44:48 +0200
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

>  config B43_BCMA
> -	bool "Support for BCMA bus"
> -	depends on B43 && (BCMA =3D y || BCMA =3D B43)
> -	default y
> +	bool
> +	depends on B43

A dependency on a purely selected option is ignored.
So I think you can remove this one as well.

>  config B43_SSB
>  	bool
> -	depends on B43 && (SSB =3D y || SSB =3D B43)
> -	default y
> +	depends on B43

Same here.

> +choice
> +	prompt "Supported bus types"
> +	depends on B43
> +	default B43_BCMA_AND_SSB
> +
> +config B43_BUSES_BCMA_AND_SSB
> +	bool "BCMA and SSB"
> +	depends on BCMA_POSSIBLE && SSB_POSSIBLE

I think this needs to be:

	depends on (BCMA_POSSIBLE && (BCMA =3D y || BCMA =3D B43)) && (SSB_POSSIBL=
E && (SSB =3D y || SSB =3D B43))

to avoid the case where b43 is y and ssb or bcma is m.
Or did I miss something and this is caught elsewhere?

> +	select B43_BCMA
> +	select B43_SSB
> +
> +config B43_BUSES_BCMA
> +	bool "BCMA only"
> +	depends on BCMA_POSSIBLE

Similar here.

> +	select B43_BCMA
> +
> +config B43_BUSES_SSB
> +	bool "SSB only"
> +	depends on SSB_POSSIBLE

And here.

> +	select B43_SSB
> +
> +endchoice


--=20
Michael.

----
Please use PGP/GPG encryption.
Key-ID: F532BE1D908D8B0E
--------

--Sig_/0Waat6fnDhemZg540_DpPaX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTbkMBAAoJEPUyvh2QjYsOxAkP/RTZKLe8jLRklFRrvjmYO2D4
Qxg5W3JP56wWOUGMuO2/q6puvT1xCwv2uobt31S3alNIeJD9JRVOZb1E9KyDTtH2
ngDuDKjG/vjValaI7cO0uKYnLB9NspUnuGD/ds/4YQMwhhTQoPz3Hny8Y/8q5raY
s4vhqiNeLyzcBagXGASqRTnsiRq/JCOzx5qLhO3rlnzhszyQLovNX505i7/QqHKX
Ku9r7UZLRGE++4Trb7SvYPv69GSdj10qacTCaMAqVV1td5xs3yM5prUb6mb1XTHW
yGwhVGFkKcQt8zPUmfxfsTP2Z/UGGfPobeMq6T+5e8wxKRXlmEIwE52b7l72MA6S
m0ysPL7Tt0sJS0WUnv+JUk5WaAxyC2OWBbxgOi+TpcOPJZDD7XotL73ho7vHQG1R
iMV5W5eeNLdnQ6wx6UoFeJiD5sTJ5osRP+1K5KbV1OPHUcW6qxoio4nhi5rBB2OQ
+MjVqYoHqEUaGoO25P3jQU/kgkq3vAi00M/sBSpJqcUqsAhcwSbc0dNcC47tedJ9
I4lRdLM+bu2X8K3/lWZF72rrbEFRpZfxA+Fat2cLZomNs00OZXXu1lRaztOjZx1M
PLaJUanaJkyxwjXhGc1yoGy6Uqywg8zHUg2L2ahwSk5niide1A2cBK37rZvfch5f
gLqixSu/77ZGlipNsw9A
=8fJK
-----END PGP SIGNATURE-----

--Sig_/0Waat6fnDhemZg540_DpPaX--
