Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57170 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbYK0WAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2008 17:00:09 -0500
Subject: Re: [RFC] rtl8187: Do not wait for an ACK when
	IEEE80211_TX_CTL_NO_ACK is set
From: Johannes Berg <johannes@sipsolutions.net>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <200811271952.21408.herton@mandriva.com.br>
References: <69e28c910811261431u26e341d3p51ebadca807f4b61@mail.gmail.com>
	 <200811271543.59126.herton@mandriva.com.br>
	 <69e28c910811271202s295bbf5bo3dc8c04c50b08a01@mail.gmail.com>
	 <200811271952.21408.herton@mandriva.com.br>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bVLC1eg3fkYgSmCLZVb6"
Date: Thu, 27 Nov 2008 22:59:09 +0100
Message-Id: <1227823149.7559.1.camel@johannes.berg> (sfid-20081127_230013_746029_A888B297)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bVLC1eg3fkYgSmCLZVb6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-27 at 19:52 -0200, Herton Ronaldo Krzesinski wrote:

> In this case then shouldn't mac80211/rate control alg give a right rates[=
0].count?

It probably should put 1 into that value, yes. It doesn't seem to
enforce that now though, I'll take a look at doing that.

> And other drivers have same bug?

possibly.

Another thing: the ".count" is the number of tries you should do, so if
the hardware expects retries then you need to subtract 1.

johannes

--=-bVLC1eg3fkYgSmCLZVb6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJLxgpAAoJEKVg1VMiehFYEAwQALMTmA38Pmcrh+e+XrLa1r++
n83LQ+4/ZNm2JU37dw/xClxqB7042UANd5CZmTDEKFIUu1dYcXd2oJbUnxFQJd6H
qAw5CW0NyIMr3RkXYer6s4919iHusv33C5aCZd7DL1R4arPzkV0/SkweXmgO3/w8
LuksorHggnvIuHr6j07sgJkpjDCMVN90aPUHt60GnIYAgGdoPWPto38EHDiGycSE
DA/eDqPKDG6lfivHwgNazL6bSH+L/nL7pHGw/x/99eObNTONKmzfhnFYob9X6ze+
etbVThn1fPPuta/MlXUiaTbaSV2F3hCmv6B1MJnMpUWU4aErwLLtbQxWXjXh59N8
9k/BBCdi0dIc91/BJUatAJm+a5zp7pBAYHD7+ozLf6KuSehamtjrPQYKahhiuRfl
pRRajb0NgoQZDj0fuLcFKdDQrbe/u1IooruOTzOv9KpIfmDAYvminpAcw+cQ4PrN
m9EkZo+tvvgGcPE1O3ddIeKBC4aVx1NZz9ubxAFHdZ2dZ9XFUKS0YeT0Gw3ZEOhu
psINEvQKbps6jAu70wbRddALPxdLUqvoyATuv2DUzGXK9PGUwhKPUW9p9OknDLVy
jzTC1+IEo2HQrW2WnNlzduxufInW7/aoromF2ikYqJDudRjy2MCVim8BX1TwNoVI
tOBZE/ChTIaKf2iCFswu
=8TkC
-----END PGP SIGNATURE-----

--=-bVLC1eg3fkYgSmCLZVb6--

