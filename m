Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.108.102.1]:41767 "EHLO parez.praha12.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271AbZLUMil (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 07:38:41 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: =?utf-8?q?=E6=B5=B7=E8=97=BB=E6=95=AC=E4=B9=8B?=
	<tkaiso@thinktube.com>
Subject: Re: [ath5k-devel] [PATCH 4/5] ath5k: Reimplement clock rate to usec conversion
Date: Mon, 21 Dec 2009 13:38:32 +0100
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
References: <1260899813-17585-1-git-send-email-8an@praha12.net> <1260899813-17585-5-git-send-email-8an@praha12.net> <4B2F4D3A.4050009@thinktube.com>
In-Reply-To: <4B2F4D3A.4050009@thinktube.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1470530.u1CzKc1sMH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200912211338.36289.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1470530.u1CzKc1sMH
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 21.12.2009 11:26 =E6=B5=B7=E8=97=BB=E6=95=AC=E4=B9=8B wrote:
> =C2=A0Didn't we have to handle CHANNEL_2GHZ case in
> ath5k_hw_write_ofdm_timings() shown below ?
The ath5k gives exactly the same results as original Atheros HAL:

  #define INIT_CLOCKMHZSCALED     0x64000000
  unsigned long clockMhzScaled =3D INIT_CLOCKMHZSCALED;
  if (IS_CHAN_TURBO(chan)) clockMhzScaled *=3D 2;
  coef_scaled =3D clockMhzScaled / chan->channel;

I don't know how the calculations work, they might be explained in the=20
referenced patent, but I didn't change their semantics at all.

> =C2=A0I think we should do. then I made my own patch to hadle it and it
> seemed =C2=A0to improve the throughput of 2.4GHz. (even still not as good=
 as
> 5Ghz case )
Where's the patch?

Lukas Turek

--nextPart1470530.u1CzKc1sMH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJLL2xMAAoJEEBjvk/UOfYwuzEQALt23tm5vZ1MzOx1Zgoi+/8E
jKzet8+eChlPljnEvFuEml+b2rH+lpBJV7exTNjLt8Tdmch+x7Wpok0oR6CKOAx/
FtPvIL6rhIojo1SSbX81mrBFyvYydIRYvAe+S7tQrfwVigMRMTeUb824RCNCJIDn
PU3wM9OtyGmMUDjs1meOFesfvSqOToP7eGg2Q9v9miPNkkDEqihgUg7vDYAIt5WR
zGDClp4IccBKlMISV3rjXQEeXbWXnTbuzE0SjWb5irKIafKFw3YcrjtidSC44a+b
XrVOHK7sC8ScXIPOGKgH+FVurVVMMjbrEjFEYkXlg9M3vao6CUJkgWIYXu7jmuJB
N0SGkAAry/STr9OTH3+k/0a0qWtqPCHz2gRDJ4yvoFJNylrCe53ib1R2CWhXMhPl
6D5AjsDJ7RXFq/0skwZ1Qx3MP9SP+nxXg8rS7clg/JolsrzkX4o/hfN+zfgaAHdY
Kya6y9rZetwYFQqr5pjgBmQa3eosHsrZ2S+rezHCyIkmkI4tASY7t4p6SvcbHMSL
bKuICtKrAwGNYi9tLORNEEDN29YYS0CBZHv87IwCFDwwWjd41hH5w6Bn0tzio8d5
+Zotbh5Qfr6drQItOZrz9jtcqZBcJanelccvB1r3gFvLQFoGPPnNEh8qsngTz6AD
ZWwSx0kwEgwzRj7z38Qn
=IGQ9
-----END PGP SIGNATURE-----

--nextPart1470530.u1CzKc1sMH--
