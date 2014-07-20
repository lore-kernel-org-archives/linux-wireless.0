Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:55633 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbaGTLyv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 07:54:51 -0400
Date: Sun, 20 Jul 2014 13:19:37 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 1/2] b43: implement PPR (Power Per Rate) management/API
Message-ID: <20140720131937.3229b17c@wiggum> (sfid-20140720_135454_351658_17C62DDD)
In-Reply-To: <1405854022-11833-1-git-send-email-zajec5@gmail.com>
References: <1405854022-11833-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/LaaEd..UGIZZ1ZJL/7PrG7A"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/LaaEd..UGIZZ1ZJL/7PrG7A
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 20 Jul 2014 13:00:21 +0200
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> +#define B43_PPR_CCK_RATES_NUM		4
> +#define B43_PPR_OFDM_RATES_NUM		8
> +#define B43_PPR_MCS_RATES_NUM		8
> +
> +#define B43_PPR_RATES_NUM	(B43_PPR_CCK_RATES_NUM +	\
> +				 B43_PPR_OFDM_RATES_NUM * 2 +	\
> +				 B43_PPR_MCS_RATES_NUM * 4)
> +
> +struct b43_ppr_rates {
> +	u8 cck[B43_PPR_CCK_RATES_NUM];
> +	u8 ofdm[B43_PPR_OFDM_RATES_NUM];
> +	u8 ofdm_20_cdd[B43_PPR_OFDM_RATES_NUM];
> +	u8 mcs_20[B43_PPR_MCS_RATES_NUM]; /* SISO */
> +	u8 mcs_20_cdd[B43_PPR_MCS_RATES_NUM];
> +	u8 mcs_20_stbc[B43_PPR_MCS_RATES_NUM];
> +	u8 mcs_20_sdm[B43_PPR_MCS_RATES_NUM];
> +} __packed;
> +
> +struct b43_ppr {
> +	/* All powers are in qdbm (Q5.2) */
> +	union {
> +		u8 __all_rates[B43_PPR_RATES_NUM];
> +		struct b43_ppr_rates rates;
> +	} __packed;

I don't think this union has to be packed.
And most likely struct b43_ppr_rates is ok without packing, too.
You could probably remove it there and add a BUILD_BUG which checks somethi=
ng like (pseudocode):
BUILD_BUG_ON(offsetof(struct b43_ppr_rates.mcs_20_sdm) !=3D B43_PPR_CCK_RAT=
ES_NUM + B43_PPR_OFDM_RATES_NUM * 2 + B43_PPR_MCS_RATES_NUM * 3);

Removing packed will produce much nicer code.

--=20
Michael

--Sig_/LaaEd..UGIZZ1ZJL/7PrG7A
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTy6XJAAoJEPUyvh2QjYsO5foP/0DzWhVhhHs9PcjiOVuhu0XG
UCmO9LBav3wYebIK+b/zgtlp9Iwvaw8pE5gNskMpDAKjoh216dLVXPrhxvDu2CK+
lJi7fn5OGDzv4K/zGYVmlIANYXnmOKbN2gWYwLFty64FGcBQqQsMsqRhlx30KrP3
L82A1YE/pMNvu5motfhWt0Ps8NleauVin3q6Iy1Rlom7WFlnlAHPmdm67gUe7Jhm
Rwph4el1HaOh4Mkn/+1IUveDlbNWPhIhqmBEiCEDOGTiekytHkYD4oZwoWDqCwKm
lXZ9dbZg43hcYvT61DO18iYJa0xMZRzz2CT6annXuXNntn/hARDAw5SkMT0QFF6W
mVzRYZ8+ycXIbS08OW8p2J7z7SD3iL10ECvUbR6QRABEMk3qMdsqpyW7WpiJNkX5
x2fIz1q37M1UGP2mSFxr1hs37iul4ivHT6mSubusF1A5a3V9ih6yn7FHNyIOtAOn
91LwKdreunBzBLX1JeIJmJPiIMVJCL17hrZvyFZbC2sdZTw5+7AOtvq8OLTYc4DN
B3RW4vTWk5fwcULHPoCKxnmD/RwzYh6DBc0O+Q+ewDS55dBMNXKLojw02SAuRdj0
x2KveXCewxxBckKyJzZVpSqw/o9mjbSiiBYuJvAcTqXPFt70aCbiA1hQkd3ZthJq
2Ww5KBrGIVZdkn3PoWxs
=Xdud
-----END PGP SIGNATURE-----

--Sig_/LaaEd..UGIZZ1ZJL/7PrG7A--
