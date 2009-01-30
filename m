Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38684 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbZA3LDK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 06:03:10 -0500
Subject: Re: [PATCH v3] mac80211: do not TX injected frames when not allowed
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Jouni.Malinen@atheros.com, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1233111019-7827-1-git-send-email-lrodriguez@atheros.com>
References: <1233111019-7827-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-eBNU7AXFuVrwsQOTnlKU"
Date: Fri, 30 Jan 2009 12:03:02 +0100
Message-Id: <1233313382.30970.3.camel@johannes.local> (sfid-20090130_120316_412324_D4618463)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eBNU7AXFuVrwsQOTnlKU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-27 at 18:50 -0800, Luis R. Rodriguez wrote:
> Monitor mode is able to TX by using injected frames. We should
> not allow injected frames to be sent unless allowed by regulatory
> rules. Since AP mode uses a monitor interfaces to transmit
> management frames we have to take care to not break AP mode as
> well while resolving this. We deal with this by allowing compliant
> APs solutions to inform mac80211 if their monitor interface is
> intended to be used for an AP by setting a cfg80211 flag for the
> monitor interface. hostapd, for example, currently does its own
> checks to ensure AP mode is not used on channels which require radar
> detection. Once such solutions are available it can can enable this
> flag.

> + * @NL80211_MNTR_FLAG_AP_MGT: this monitor interface is used for AP mode
> + * 	to be able to inject management frames.

Come to think of it, is that really a good name? The intention is "will
check for radar" but then we don't even have a way to check for radar
yet!

So maybe we should leave that out, and introduce it with proper radar
support later?

johannes

--=-eBNU7AXFuVrwsQOTnlKU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgt5jAAoJEKVg1VMiehFYPasP/jiX97alJk+2+hCsUgKHCouc
5Fw3g5aHXd4x+xeYnTuPH0mjjXqshSKrA3chGzbI/V3KTscLyxR1m2533TurP813
hAv3jI/DfICqEcNna5yxChzw8NnmY8vcczV/d32r1AluJRA0MLUJnpYxOFKjkm4e
GeJVUqi9kK5o3wgwq6yHV3M5n8MguVhEmk9N9RomonLEaVqQAP+fckmqNRcj8yXQ
vpWlGPLwIN7x1lPyo8nhj31emfDweCRE+ydZprOztqvA8QWi18ecABaFmOnMnMG7
tvMpyjAqr1vBIL3wYRWFoTFEfeCk3MWRfE9xr1XbXffeVQ6BAaS2QfRYFEEaEZOi
BYMgA5tLGumeY5b8btcHu3v41VFMOfvQY7N9v51TlyJd8AiFsKcdUp06WjNoPLxW
O2vcBm+VUoXqtT5a7wszhYRr4vcS58HN/PvHeI3JhJqQNu2Jbg/fwtuU1KKonNxV
7vpiCwpHq+ObLgeXcFkUIt1XakC+zCUNKxIJJlPRx7fuTLf5oYLZIlJR+MDHC0cJ
V3+xi7lrsjDHU6yS2ledt+hvAA1efjkDP1Csf5yGA1Wfr0pU5hnpSq3OnWPUY/7g
O6o9Ztt11PTh3v2TH7+VXT2ZcUgYFpD6p4zD8eongYBAUFAiKC/mgGbavAyVSmbo
/94dbTdMjAPZ9NtylHxe
=xHLj
-----END PGP SIGNATURE-----

--=-eBNU7AXFuVrwsQOTnlKU--

