Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52048 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbZKOOBt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Nov 2009 09:01:49 -0500
Subject: Re: [PATCH 1/2] mac80211: add private driver flags and ampdu
 length to tx info
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <4AFED564.8030804@openwrt.org>
References: <4AFED564.8030804@openwrt.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-9F77XijjVk0V91Zr+SsA"
Date: Sun, 15 Nov 2009 15:01:46 +0100
Message-ID: <1258293706.6294.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9F77XijjVk0V91Zr+SsA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-11-14 at 17:05 +0100, Felix Fietkau wrote:

> - * @ampdu_ack_len: number of aggregated frames.
> - * 	relevant only if IEEE80211_TX_STATUS_AMPDU was set.
> + * @ampdu_ack_len: number of acked aggregated frames.
> + * 	relevant only if ieee80211_tx_status_ampdu was set.

why lowercase that?

> -	/* 2 byte hole */
> -	u8 pad[2];
> +	u8 driver_flags;
> +	u8 pad;

The ampdu_len seems ok, but I'm still not convinced this is right.
Drivers _should_ have enough space in the driver parts of this struct,
and not need flags here. I realise that you do need that because of the
RC and other internal things, but maybe you could simply use "pad[0]"
for that so not to encourage others to start doing this too?

johannes

--=-9F77XijjVk0V91Zr+SsA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLAAnGAAoJEODzc/N7+QmaOpgP/0ZztXVNa4XaosE4QFrXumb7
u5n0ld8EfvHRVjC4FkXmvuaemtOzXgYmVhC7Tuew0POXQBCpsnrXTIFGqVtXJENW
+8Wwn9GZLsqYH0SAudDyYrGGxvvxF/PnlfACYJ6k5DpBhjqEkdBiR14tyOQJlO0C
9aYIWBq+XQlBXAyOwPbwA+y+SoDY6DXaNXPftdP+9Xz3CsQThueVArrkS2rGiUVB
QV7kiYgWM8U5DBfe+Q9dhvxEzR8PC9bEg0oX6JFpLHpjPoetMIffkX2nOKlCFOi/
DHp4s+02hmx3wxWPfl48GcvYMZFsv0J3Q4T2PVIuTKHFuSujVgrSjTawhna42JXE
6CMHg1SayCVgkkM06SCGGOP6N+Tmuk4C+wwFrvrN9lW61TTbOqvBJVfJ9HYOyv9m
9UGtAlnR26SigolQFap9F/36APIG++p1+K4eGO2qjkpHGEu3Nbz2pLtgFHdltrpb
lt/JiB0B4sU1C42pbbWiJJ3ZcH8mhHlEZPvs5lGbDv9CsgVg1P1ZmvHBn4a4FHKE
/3r8K4knfqVSq8Sa3CanBiXzACG4ngn/4qi+fvEk9q1Hgo/W1jsKvSBetuT6cU16
XYmPN7FlbABe/vs49/ybfsfu3ogOerMxlSXYMVVIeLOa/xvX+LCmKwbRNpP413nw
d1GywmwIfbbOyxNQW/A5
=WV6A
-----END PGP SIGNATURE-----

--=-9F77XijjVk0V91Zr+SsA--

