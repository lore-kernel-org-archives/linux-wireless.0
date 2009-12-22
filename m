Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.108.102.1]:53775 "EHLO parez.praha12.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbZLVQIN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 11:08:13 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: =?utf-8?q?=E6=B5=B7=E8=97=BB=E6=95=AC=E4=B9=8B?=
	<tkaiso@thinktube.com>
Subject: Re: [ath5k-devel] [PATCH 4/5] ath5k: Reimplement clock rate to usec conversion
Date: Tue, 22 Dec 2009 17:08:05 +0100
Cc: johannes@sipsolutions.net, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
References: <1260899813-17585-1-git-send-email-8an@praha12.net> <200912211338.36289.8an@praha12.net> <4B301FE9.2020702@thinktube.com>
In-Reply-To: <4B301FE9.2020702@thinktube.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1547116.HlY7Wt2tTT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200912221708.09535.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1547116.HlY7Wt2tTT
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 22.12.2009 02:24 =E6=B5=B7=E8=97=BB=E6=95=AC=E4=B9=8B wrote:
> Does original Atheros HAL calls the function just for 5GHz
> or calls for both 2GHz and 5 GHz.?
=46or both, too, the condition used is IS_CHAN_OFDM(chan).

> --- reset.c_org 2009-12-17 17:01:29.000000000 +0900
> +++ reset.c 2009-12-22 09:51:16.000000000 +0900
> @@ -64,7 +64,14 @@
> * we scale coef by shifting clock value by 24 for
> * better precision since we use integers */
> /* TODO: Half/quarter rate */
> - clock =3D (channel->hw_value & CHANNEL_TURBO) ? 80 : 40;
> + if (channel->hw_value & CHANNEL_2GHZ)
> + clock =3D 44; /* here, we do not have to worry about CCK */

If it really improved your throughput, there might be something on it, but =
I=20
still don't think we should change it like that without really understandin=
g=20
the algorithm. According to my interpretation the calculation should depend=
=20
on channel width (20MHz in normal mode, 40MHz in turbo mode, same for 802.1=
1g=20
and 802.11a), not on MAC chip clocks. At least some Atheros chipsets have=20
separate radio chip with its own 40 MHz crystal.

I looked at ath9k source, and it uses the same calculation as FreeBSD HAL,=
=20
including the 0x64000000 constant. Is there anyone with access to Atheros=20
documentation who could explain the algorithm at last?

Lukas Turek

--nextPart1547116.HlY7Wt2tTT
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJLMO7pAAoJEEBjvk/UOfYwGHcP/RaMws1ZV1tGKVrhwm84J2pM
X0SJzRNLsR5N1ytafGiX7uA8mtbCsZKc3JQig+tTej9VRXqhh7HQt20GuU7yuUoq
I4/UN0Qh41+961y7bdkDGnmlEjmMWb0nQcTmn221MTKT0klcBUy4Fz44SZemCTUf
TPutbDq0afY1MHRdVYt282PDS7une4KfF/RmhGpUXY+HKjo9s/d2w8zagHk+qKvT
LEZTWz6Fc3UF5sGuP22BltQ216oar6/aihDc9h0dz346kr8DU0zTFk4zd8JFyNFB
vwFoqhqLN/wfkAYjfhgU5z7tVIrwPKRIAL6Gfr/5yQGpMesfa11CVnx4dNxyWocn
XrAjRuWQz9I3V8M+2aAya5odFrbei74+tpQrF3YHJ2+MqhAf3Fga1qI79DhABoJY
+O6H03l0sAmT72IaLsDdCs0dZBvjhOd7QEq2BD/7XlC+HzEok6rYazWx/YDy7eJH
q44+yVI03h3Cl1BSafHlUSov+7rmTv00MMf3rONg9zKl/WKK4D35Nk8pbuxO1WAa
uSQpVS4yTVTfJ1V8pVtbMgKDl8ZB+mbz49Gla9yiC01z9NcgZ0Cqfh5OYTXdJHXs
BSFNYi2ZOzbTciBOgsb1oF/aPUNYfb2QBQIfoTc8we/Zz5RjyiyMp9hKFYqNPeel
sUcmHIZe0AbCvsrq3LcM
=mEiI
-----END PGP SIGNATURE-----

--nextPart1547116.HlY7Wt2tTT--
