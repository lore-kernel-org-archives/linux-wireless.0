Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36964 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbYKEL3N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 06:29:13 -0500
Subject: Re: [RFC/RFT PATCH v2 2/2] rtl8187: feedback transmitted packets
	using tx close descriptor for 8187B
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
In-Reply-To: <4910CD42.4010402@lwfinger.net>
References: <1225806649-10050-1-git-send-email-herton@mandriva.com.br>
	 <1225806649-10050-3-git-send-email-herton@mandriva.com.br>
	 <4910CD42.4010402@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3+uXc6LiVAIYnMiXgKzy"
Date: Wed, 05 Nov 2008 12:29:12 +0100
Message-Id: <1225884552.3619.74.camel@johannes.berg> (sfid-20081105_122916_417373_FB034536)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3+uXc6LiVAIYnMiXgKzy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-11-04 at 14:31 -0800, Larry Finger wrote:
> Herton Ronaldo Krzesinski wrote:
> > Realtek 8187B has a receive command queue to feedback beacon interrupt
> > and transmitted packet status. Use it to feedback mac80211 about status
> > of transmitted packets. Unfortunately in the course of testing I found
> > that the sequence number reported by hardware includes entire sequence
> > control in a 12 bit only field, so a workaround is done to check only
> > lowest bits.
> >=20
> > Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
>=20
> Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
>=20
>=20
> Quilt shows the following warning:
>=20
> Warning: trailing whitespace in lines 438,468 of drivers/net/wireless/rtl=
8187_dev.c
>=20
> scripts/checkpatch shows the following:
>=20
> WARNING: line over 80 characters
> #138: FILE: drivers/net/wireless/rtl8187_dev.c:475:
> +                       if ((le16_to_cpu(ieee80211hdr->seq_ctrl) & 0xFFF)=
 =3D=3D seq_no)

Besides, that line looks wrong? the lowest 4 bits are teh fragment
number.

johannes

--=-3+uXc6LiVAIYnMiXgKzy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEYOEAAoJEKVg1VMiehFYU8AQAMC9jxLzNpozxbCRQSuVmVIw
l1mOF/aJtTCahekky+Ut3Wf6mazqGvZ8ZHdZpAGaKW2poUyXYE2lWSPsd8Z0OGN9
WBYr+yHHFMbWJhpGl2xqXy6SuEMrqH3LfFJZL9hetXncIoxqSN6WD2+dxTHMQJbL
r7UV1jgzDx0QigvdN+fqQmVe1m9ZpoLzwofks6cG4qCZ/fQJt/NSgq0T++J8V2QN
LxaBihzPEyRh+awe3TFOXKxh2vOI2CFhsNsUp/rbsxWzO68m/VM2Nthj58qJm/na
qvf/ynRF733ZNuBWz8DE4NBSJx3Mi2KOXcRk/MKwtt0AIIJaHY5cR7pNVEhEKEZi
gdgiXfTqg6/9hISVj2DXyFp2YGwnuSvK3vnjwSMLdszhqvf8rLm9CvS2485EKwvy
Z9s8KjT+QrIQ9acuhOGBle0lUTD9U5o+9xQ5f6veSsAfaHbUgFm12nn3xc7rIXmm
OaF6oELu/pmwguWpiJ4UeiR3+9lF1tGT8ZD98OpGknVjNvWuTQ92tHeDAsbdIo1E
c010HNpOYlgELJg+j5OItErvaBPvHbUuCC05jg1VQaQ2NitzfnzU1ngvEokol5PY
DRc4zymgfQyH8mxFWSeZHQEUxP6w7RNzrtwpUiSJrkXpEBV7Kpt85nWazaRTBHhn
jk4jNKJrwO8gm09BN5ag
=fJ3h
-----END PGP SIGNATURE-----

--=-3+uXc6LiVAIYnMiXgKzy--

