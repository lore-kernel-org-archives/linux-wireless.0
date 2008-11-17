Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60045 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbYKQTrx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 14:47:53 -0500
Subject: Re: [PATCH] rtl8187: Fix transmission count sent to mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200811171742.48292.herton@mandriva.com.br>
References: <492188e5.bIuOh01ilT9fPRTO%Larry.Finger@lwfinger.net>
	 <200811171742.48292.herton@mandriva.com.br>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1vP/AgSSoRdpyL4sSWy6"
Date: Mon, 17 Nov 2008 20:47:07 +0100
Message-Id: <1226951228.3902.55.camel@johannes.berg> (sfid-20081117_204756_585625_99B4225E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1vP/AgSSoRdpyL4sSWy6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-11-17 at 17:42 -0200, Herton Ronaldo Krzesinski wrote:
> On Monday 17 November 2008 13:08:21 Larry Finger wrote:
> > In the commit entitled "mac80211/drivers: rewrite the rate control API"
> > (commit 9ea2c74de0ec971e8ec9fc5aaea9cd5b4fec95b6), the meaning of the
> > packet transmit count was changed from the number of retries to the tot=
al
> > number. In driver rtl8187, this change was missed.
>=20
> With this change as before, when using pid, rate never go above 1M in tes=
ting=20
> here (minstrel doesn't have the same issue). May be because this in=20
> rate_control_pid_tx_status (inside rc80211_pid_algo.c)?
>=20
>         if (!(info->flags & IEEE80211_TX_STAT_ACK)) {
>                 spinfo->tx_num_failed +=3D 2;
>                 spinfo->tx_num_xmit++;
>         } else if (info->status.rates[0].count) {
>                 spinfo->tx_num_failed++;
>                 spinfo->tx_num_xmit++;
>         }
>=20
> as pkt_rc + 1, looks like we always will increment tx_num_failed, and may=
 be=20
> it's causing this. Well this is only judging by a quick look, I may be wr=
ong.

Larry recently fixed the above code too.

johannes

--=-1vP/AgSSoRdpyL4sSWy6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJIco4AAoJEKVg1VMiehFYstoP/3aVbl1ukUfz644b1EmMMMYG
J0ebSpVSezg0SOyyELVX1BcWu9v6Zsuvr7jFgYXZ8kC6zarEOFOSaVCEo3hSZ0tj
h1p3sWogNY+NsT2hoySfknOnYZnenm1z8EsOGVdslx/4kY/o0TXMJcDuKrGLLT4c
aiRaMYvIPpNm4qsEgcBsdIY5rQOd+TpAr2UHLhI5E+i9r7B2Ry+PWmZS2R3hYEib
d4Dn/wA4WqOdjlADYUdaM7c5CpR8MbHmMxOe953IgenwtiMsWg+K38cO1e2frrx8
dTjY4oeK7oYPzX4+3Ox86VGZ/2w1E/ytv/A+5BpzBpKhtOBR7E/zpAv33L1JnO4z
HJUHhMCdaTXxjm4YghUFDvMHamKzv8xDFqzG/0QGKDiAJj9V0Y7S63ZuNEcKxjXL
jzT5XHbP4SjejWmXceVPiXgCLpFNXGE++UEiGuuVU4NrnvLo6gBI3I/jTCcjDIhU
af9Xx9woZ5BytVqvbxiV6g+wUBgHKGpyO+oh4I8gXj8p8qBwQwFPVb/kLePUnN0H
WWbtPO1Lz26MdePNGdZxSb3KtkbKMOtv1f2kVjlk282gYu3BQAjNmujRPkhu/hpY
DF8hX55AyGj0KqC0NVWVa+wwdTdlaegW6iAzQSbCxpXXLtPeZ0D1lbWV39vLDiNX
MJMFtzYw5+6faAvoQGZ5
=w4Iu
-----END PGP SIGNATURE-----

--=-1vP/AgSSoRdpyL4sSWy6--

