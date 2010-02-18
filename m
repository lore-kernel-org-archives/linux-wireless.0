Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.108.102.1]:60893 "EHLO parez.praha12.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756491Ab0BRVsR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 16:48:17 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH] iw: add country IE parsing
Date: Thu, 18 Feb 2010 22:40:31 +0100
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
References: <1266459208-12408-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1266459208-12408-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4459569.UAReCT7cWg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <201002182240.38016.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4459569.UAReCT7cWg
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 18.2.2010 03:13 Luis R. Rodriguez wrote:
> coverage =3D (distance + 449) / 450;
> coverage/450 =3D distance + 499
> (coverage/450) - 499 =3D distance

Inverting the formula like this doesn't make much sense...

The addition of 449 is there to round the resulting number up, because the=
=20
coverage class limits maximum distance and if it was rounded down as normal=
=20
integer division does, the resulting ACK timeout would be too low.

However, if you subtract 449 in the inverted formula, you get something lik=
e a=20
minimum distance for the coverage class - which doesn't mean anything,=20
because higher ACK timeout and slot time works for smaller distances too.=20
Maximum distance is what's interesting to the user. So the correct=20
calculation is just multiplying the coverage class by 450 as I'm doing in=20
print_phy_handler():

printf("\tCoverage class: %d (up to %dm)\n", coverage, 450 * coverage);

Lukas Turek

--nextPart4459569.UAReCT7cWg
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iQIcBAABAgAGBQJLfbPVAAoJEEBjvk/UOfYwlAUP/infkh7hzuDet5M0gFz7uDUg
geFPC7X4d4sAUMXiQtAunxktLbsX8mSe7obn278uw866PVc8aMEYWVtp2lvfMRMV
XUYeQUMmj53hwVMH/JgF1pGd+3sHEf9aWJ7WGIZu+9Up1bueSyWHusWh2Y6hemll
gTGG3lqc4Tr/9vRDgeOhldWiMG93EEbvq5Ga4Ak/R0n8RT3A2LnpnvhvTFZZ6mbT
+QnYD6DlvcBRJhS0Cq5Xv3G8nAwPJhruYheVuOQTFkJtsZuLrWafPnh3VolTlVSy
hdiZlLWAnBQUxFXx890r/7HhCozZKEKegOYoqufhfb5CSnk7ubafxHIPhGxNPpxO
6LdTRe3BjKQVKg3lsQ4KotbPJ/H7oJu3usXyI63lD8+KQp/beztBSdyBEhR1m8vV
dVmDfLNBCDzWIUBDymwMEhcGC0l8M+na0u/kKNGIlG/QimxWgLlqMHOktgnusc9b
ZPXdm+0pISw9b0r+WnhxNXtQB57OjKkBCveMH4UBmie/+6+WH2DAfHy0qNoiFyuB
YDV2sBDq2WUltI8YZmTFTZj46htzQp7bzHk8/sO/ALg8HSZMIngYxSXUF23Txy2R
06+Ly+pAU0bQLo26pHgu39jh8VovVvFlPApIsDRNWEVpM6SXR5HG8dJEpvipTpda
bcNuygfq7sNlayKyt/C+
=78H+
-----END PGP SIGNATURE-----

--nextPart4459569.UAReCT7cWg--
