Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:36100 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752376AbeEGSol (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 14:44:41 -0400
Date: Mon, 7 May 2018 20:43:17 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Matt Redfearn <matt.redfearn@mips.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression caused by commit 882164a4a928
Message-ID: <20180507204317.52992b6c@wiggum> (sfid-20180507_204455_697519_531A111A)
In-Reply-To: <7bbc067a-c412-3d2e-174a-abc31b46e246@lwfinger.net>
References: <7bbc067a-c412-3d2e-174a-abc31b46e246@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/iHDMw0Mv5.LLHwtO+_Zrb7t"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/iHDMw0Mv5.LLHwtO+_Zrb7t
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 7 May 2018 10:44:34 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> Although commit 882164a4a928 ("ssb: Prevent build of PCI host features in=
=20
> module") appeared to be harmless, it leads to complete failure of drivers=
 b43.=20

>   config SSB_DRIVER_PCICORE_POSSIBLE
>          bool
> -       depends on SSB_PCIHOST && SSB =3D y
> +       depends on SSB_PCIHOST && (SSB =3D y || !MIPS)
>          default y
>=20
>   config SSB_DRIVER_PCICORE


https://patchwork.kernel.org/patch/10161131/

Could we _please_ switch to not applying patches to ssb or b43, if
nobody acked (or better reviewed) a patch?

We had multiple changes to ssb and b43 in the recent past that did not
have a review at all and broke something. I don't think such software
quality is acceptable at all.
So please revert 882164a4a928.

I'm sorry that this patch slipped through the cracks of my inbox.
But the reaction to that shall not be to just apply the patch. It
shall be to resubmit it for review.



But back to the technical topic.
I don't remember why SSB_DRIVER_PCICORE_POSSIBLE depends on SSB_PCIHOST.
But that looks and feels wrong.

I would say it should rather look like

config SSB_DRIVER_PCICORE_POSSIBLE
	depends on SSB && (PCI =3D y || PCI =3D SSB)

completely untested, though.

--=20
Michael

--Sig_/iHDMw0Mv5.LLHwtO+_Zrb7t
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlrwnkUACgkQ9TK+HZCN
iw6+rw/+IKUHfewDddQA/cS2YI/26ozyojOOrFiKui7+NvBUWazjYMf4yjRKgLA2
Rxjm2OaC8TjDREXG3wnvIgvnMDkJTYHTTQ8hti+EA4R0vUsPUsDfOCQ4cggD4ev4
Ob0gk1pbAd5avlL6N/0zPTMc4c7TD4Htt1ZlWRq/01JQfLg3rlBz9PkfQpI1OE7r
5doGf86Aks44GE9EVjGTLPmWoeX7AqqwMBm7jdB1U/TAUgyw8zW/9Mrd3QoUuKDO
M+0S/fWiv9DNvKaR+fW00ngLiwuXR5g/9SI2+uIEuzgon0HSHV5daLVP4y0BXZvS
BS4D0mfVnCMNLIDXqkqfJkc1zSY2Gy/qzHG6n8G6x7pbd9mlLWqJ8bFxek7iKCSA
S0hLIR4jBmHoQrVJPHhAq15yRKl72gsUS6qA+ucGiv7oRJjwQDnIo4rZCOdXNVN8
7d5tGTr5Q59nquerxodSvimbX+6yG/aqBLhEw6TfMafs3cZJB0A3LGio8zCz1IQR
e//pycsWK4tbeThjQbJh3el0e0IHtyJmxJcDNIPXjidUvAAuPXgQdT26m61AKttM
aoqJANhfItTPy9BLbf35vikHcZdmkx8jr05ossZpZ1nNDEuV70TBk2BkyWTV9k2g
rrZQSEmsC0awOC4HQG7bTXyc1bWGzA2TPcPdlIaZK47puh5LTw0=
=mn4E
-----END PGP SIGNATURE-----

--Sig_/iHDMw0Mv5.LLHwtO+_Zrb7t--
