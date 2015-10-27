Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:35853 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965025AbbJ0TJl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 15:09:41 -0400
Date: Tue, 27 Oct 2015 20:09:00 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH 1/2] ssb: move functions specific to SoC hosted bus to
 separated file
Message-ID: <20151027200900.490e4b03@wiggum> (sfid-20151027_200944_420915_CCC28409)
In-Reply-To: <1445797963-5968-1-git-send-email-zajec5@gmail.com>
References: <1445797963-5968-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Vs+knf+TdPBwELoCPJ+B.=l"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/Vs+knf+TdPBwELoCPJ+B.=l
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 25 Oct 2015 19:32:42 +0100
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> This cleans main.c a bit and will allow us to compile SoC related code
> conditionally in the future.

Looks good.

Acked-by: Michael Buesch <m@bues.ch>

> +#ifdef CONFIG_SSB_BLOCKIO

I wonder whether we should remove that option entirely. It does not save
that much space and most people will probably have it enabled anyway.
It's required for non-DMA PIO transfers.

So if you want, you could remove that in a separate patch.

--=20
Michael

--Sig_/Vs+knf+TdPBwELoCPJ+B.=l
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWL8vMAAoJEPUyvh2QjYsOi2YP/RVfQW7HZGOozTPCXXJoRrMR
JRTQmMw/B6StynlTulRr8GF8TyVb/IowY0em9QlkBRSFcf4IelacMLBeC+6aZAlI
NhfX1z+L7bH/8lKv3BVtox9rGROnOogKFCHS4CBAO92WYoWBsXdpew631ENQjlgL
FoPyajVF7KNwFqxKt//lpEHF+4ZEtmesUs/4mLD8t3+bNbZGOjPXFU2VI/7vh3G3
niNy8OQ6QCGjbR3qEr+QN33ocJLsVNaeyD+Z8/nZdGOdBr88ENVHEVWvZfX7/BnL
uI6JViVQd2OKJIB4L6a8q/qeq6qDAfdnpWZcVplrimbDQNe/SeiJgZxSA4CKGmcG
GcjVRRz+En0hxf9oIAXBWVThvAOwwmLLtlB7LaxUC0E63Ugh1MgaYfZdsCgbQRkw
C1818V4aoKW3wf4SxV5sqTdOKLDF3+8R+Xo6QmEJyYmeiUReal0ccs+6BGwSpoSb
xvPX4ggi86tu/qK0B5pZLVgTc9gBLSykCrIGRY1PoMr573DTCqBTULwKuMf+hBro
5b5XItm6yeiqadZIhF9um3JIwPW2iGWaPO9aKCRcF/sYpB3nmMF2bZ/TM7LB9CpQ
M7wOYl3atAogD7ZY4k2t+MRZIJ3fLKdmb2PtOb76rPJ+3IC4CFery39rugbe4SPf
pTG457UGqVb1f1UCpv6r
=fSYc
-----END PGP SIGNATURE-----

--Sig_/Vs+knf+TdPBwELoCPJ+B.=l--
