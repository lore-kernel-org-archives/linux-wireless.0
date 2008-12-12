Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48189 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005AbYLLPry (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 10:47:54 -0500
Subject: Re: [PATCH 1/3] mac80211: Add HT rates into RX status reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20081212123910.704978781@atheros.com>
References: <20081212123832.506588839@atheros.com>
	 <20081212123910.704978781@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oS8bvGx85FQ28fqw7icq"
Date: Fri, 12 Dec 2008 16:47:46 +0100
Message-Id: <1229096866.3600.16.camel@johannes.berg> (sfid-20081212_164758_392650_CE034479)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oS8bvGx85FQ28fqw7icq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-12-12 at 14:38 +0200, Jouni Malinen wrote:

> --- wireless-testing.orig/net/mac80211/rx.c	2008-12-12 00:26:04.000000000=
 +0200
> +++ wireless-testing/net/mac80211/rx.c	2008-12-12 14:09:52.000000000 +020=
0
> @@ -149,7 +149,17 @@ ieee80211_add_rx_radiotap_header(struct=20
>  	pos++;
> =20
>  	/* IEEE80211_RADIOTAP_RATE */
> -	*pos =3D rate->bitrate / 5;
> +	if (status->flag & RX_FLAG_HT) {
> +		/*
> +		 * TODO: add following information into radiotap header once
> +		 * suitable fields are defined for it:
> +		 * - MCS index (status->rate_idx)
> +		 * - HT40 (status->flag & RX_FLAG_40MHZ)
> +		 * - short-GI (status->flag & RX_FLAG_SHORT_GI)
> +		 */
> +		*pos =3D 0;
> +	} else
> +		*pos =3D rate->bitrate / 5;
>  	pos++;

I think we should also unset the 1<<IEEE80211_RADIOTAP_RATE bit in the
HT case so the *pos =3D 0 will just be padding to dissectors. That's
correct then because the field after this (channel) requires 2-byte
alignment.

johannes

--=-oS8bvGx85FQ28fqw7icq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQoefAAoJEKVg1VMiehFYYuAP/0XvpgrjwgelHe4j//s7OT0T
3g0b3Uh1Ef5UiWeWtINZRvfusjoWgNSqqUoKMw9FEIsCq6ur5VVbTT9UR5kKZNc0
t/xkYUkF3LJmRoj0Ulqgimeulh6vMNi6fRKAPepE2ZA07G8Utz5JrEOf8TrkLBIx
GVMemJ3VkNsDlGE+NnlG0Ng9h+06uQ1cpUPdZNslyPQ5ddHLBEibzIIIzF5JF7eE
WjT2AZTtRPFeE6xwOC/tiCu2xGsRZntdpYUanWBIMNN6pBKMKJ3UnvAQIfRG8jEu
GEKz1wK0KDibAcVRPIERhpRWP89z/mYcHHNMV9a+hFFCCqanawTGrJRhF4hjKGUm
EJrwb0iAIy/2Dh+sdW9xoRz+JOiKm/I/2OaSKajA/tao5LAQTkievrBQ2tbEEq3n
gvGkQQX2vYM5kG/rpMTllm4ZRsuhN5pTqjqsAinuhOJIrAx52Cjox3MCcf3EhSA4
A9gPTO5Lv/gdZ/+TNm0Dtda0l5s3j4YmOnNiSEXQ0aSmfdPwS4tHsa/DUBUcaznA
D7vZGRTmoByHMeD6Wx0q6fCNMRN39e15ZRC51mcxLXUQq8iH0/Iy6TZg5p5zwalB
n2RD0HBbAGeWyEVUpJyEemoOQfZG+feh3r8b1ybn7iFGN4VEwRRIgkd1N7u3anoF
0EP4Rr7sFoh4sFmggtbi
=5oVX
-----END PGP SIGNATURE-----

--=-oS8bvGx85FQ28fqw7icq--

