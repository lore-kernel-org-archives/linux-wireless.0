Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59851 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759367AbYBAMO5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 07:14:57 -0500
Subject: Re: [PATCH 2/2] ath5k: ath5k_copy_channels() was not setting the
	channel band
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, bruno@thinktube.com,
	jirislaby@gmail.com, mickflemm@gmail.com
In-Reply-To: <20080201012628.GE28995@ruslug.rutgers.edu> (sfid-20080201_022633_385916_137874C0)
References: <20080201012628.GE28995@ruslug.rutgers.edu>
	 (sfid-20080201_022633_385916_137874C0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0EBMvnTp7LNWz0111QS8"
Date: Fri, 01 Feb 2008 13:13:38 +0100
Message-Id: <1201868018.4188.2.camel@johannes.berg> (sfid-20080201_121502_401657_38A29759)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0EBMvnTp7LNWz0111QS8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Your CC lists are somehow messed up... some things are on twice.


> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath=
5k/base.c
> index bd9c9a8..1e7eeec 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -899,6 +899,8 @@ ath5k_copy_channels(struct ath5k_hw *ah,
> =20
>  		/* Write channel info and increment counter */
>  		channels[count].center_freq =3D freq;
> +		channels[count].band =3D (chfreq =3D=3D CHANNEL_2GHZ) ?
> +			IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;

No need, cfg80211 will do that when you register the wiphy.

johannes

--=-0EBMvnTp7LNWz0111QS8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6MM8aVg1VMiehFYAQI4UQ//cQSm+sHtPE/qWmmmP8zfnt/BQpgJ3I+y
8dtY+Zt0yiaeNKHpEcs6ECfgjRwj57ckwgqG1PJvtKeMyJqyvFfwfO0ut601+t4o
k/BF4dHZITs0suA+/hTKugqU9k6AlqXkr3+GaTJNQVBfEgHgbK1BEDaqitTibWvF
5NDLbSQICozqfpKkKlIzuw8iogSVIGklsIm6NOufDVKcnWRpdTtGh9MmIfgvNqHF
1H556WX7U1vB5NWCdXwNun4oc7WZ7epYODTp9TXJ3NLYzXJ9WxeQCVvJBuMeLXaG
HceBz5pr7bXUhn3M89O7Y97d9dvEBVSNgYARxKQXPQd9ZYnupGzp7eEBUIzNT/Ie
NSopKA5SPoZX2WwiRkmrkowpWSreX2HJIlDVK8+J288CFKjPltQr/ps2s9chIw79
OP0qLKRa1HoztM/CJAAhbuMs8uRRreo299N2iCruRA/rXji3eTiBEuKMb33uFWe0
pnZ8o9JXVO0gXcnoRQ+x+Gr/jo1oZNtMqIpzTCBEKLaWMYqgMJrlg9/8ZoZ9JDpC
NQehUCtjahH6YBMKw3S+g1GSWxgZigj5SIXYB//72YTzLZ9I/Eh8Q5mBeIuf45jq
jTXdSiKolgMQzpRDctL+Z7vFh27Cc03ek21iqDH+dr0GoqvDukNnVQaUd5NYqnYL
ZROt6Mz2FxM=
=0x5y
-----END PGP SIGNATURE-----

--=-0EBMvnTp7LNWz0111QS8--

