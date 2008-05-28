Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43695 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbYE1PgJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 11:36:09 -0400
Subject: Re: [PATCH] mac80211: fix alignment issue with compare_ether_addr()
From: Johannes Berg <johannes@sipsolutions.net>
To: Senthil Balasubramanian <senthilkumar@atheros.com>
Cc: linville@tuxdriver.com, ron.rindjunsky@intel.com,
	linux-wireless@vger.kernel.org, Luis.Rodriguez@Atheros.com
In-Reply-To: <20080528145048.GB5244@senthil-lnx.users.atheros.com>
References: <20080528145048.GB5244@senthil-lnx.users.atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+1EfyXFGDezPJaPlCrET"
Date: Wed, 28 May 2008 17:34:42 +0200
Message-Id: <1211988882.21624.14.camel@johannes.berg> (sfid-20080528_173613_270531_9AB40FBF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+1EfyXFGDezPJaPlCrET
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	/* Should be aligned on 2 bytes for compare_ether_addr() */
> +	u16 src_aligned[ETH_ALEN >> 1];
> +	u8 *src =3D (u8 *)src_aligned;

why not use aligned attribute here as well?

> -	static const u8 pae_group_addr[ETH_ALEN]
> +	static const u8 pae_group_addr[ETH_ALEN] __attribute__ ((aligned(2)))

I think we should use __aligned(2)

johannes

--=-+1EfyXFGDezPJaPlCrET
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASD17kaVg1VMiehFYAQInTw//QxO/ni3ZRTwyzm7wcYhnR7JbReXBYSTB
OFW9fp2jOJE1B5N3KsQdbt7/8uHnZXQmiV9naOSjHrLdWzh79vgurwYmsMaiV9L8
7CYatpOCgIsLkGn9IwEFATyr7si0fxx6djfnRVT2+k1EEOxAWSnOLws8GMo1tmnO
FjWj4aiI7a09j7bT4xRXYQa33m7ABr5MtVtlxAlEnUTftWanSP3nnxD89ep2DMc0
sVCt7MbIns7xv4FsHg+PQzJekZZv5PEIN95i0r1YfoIokAUWbu/TzbKhEHYVsf2N
Juf5Gf+yjPhS0gbHJKob0032foKf2J9rNmeFj2jPwJ3gLd9OKsvgr4EDO9dCTCQN
mSY8zQDblRZ5N9qzrFLuD1ONEj63oljtTtvY/k4DH/EUbVow7q3whk22wOYey2Cl
AnYlWvPjATTqhKAugxdO8rxoRd6KlAM4juxuRbI/cmvTL8CHtf/MVB6ta8aRtiwV
mkpfgUqAoJQI6mOfJIRlitoNZHesRXSYmVtIsGZQ68FcFx0mxlQUgzHsi9WJjpKb
VgrpGhIfxSVXyTLdd5aOrVQDtFh0WPtZx9mdeUcYWpXc+Dq/X/n539DwVUfTA5kM
0QlV5QG+3eKOjaRi+Yk5EYFN51IL4bnACMQO8cWCv85vCxEXdCH4gwPNRqCCOhYD
XGEBX3vcfsM=
=p2wR
-----END PGP SIGNATURE-----

--=-+1EfyXFGDezPJaPlCrET--

