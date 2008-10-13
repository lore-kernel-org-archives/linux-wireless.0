Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41790 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbYJMRdh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 13:33:37 -0400
Subject: Re: [RFC] mac80211: fix short preamble determination
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>, Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <20081013155938.GA30095@jm.kir.nu>
References: <1223713593.29811.38.camel@johannes.berg>
	 <20081013155938.GA30095@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LYihIeyb2nXb0VsUasKu"
Date: Mon, 13 Oct 2008 19:31:50 +0200
Message-Id: <1223919110.10113.1.camel@johannes.berg> (sfid-20081013_193340_804497_F6E5B133)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LYihIeyb2nXb0VsUasKu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-13 at 18:59 +0300, Jouni Malinen wrote:

> > -	if (ieee80211_is_data(hdr->frame_control) &&
> > -	    tx->sdata->vif.bss_conf.use_short_preamble &&
> > -	    (!tx->sta || test_sta_flags(tx->sta, WLAN_STA_SHORT_PREAMBLE)))
> > +	if (tx->sdata->vif.bss_conf.use_short_preamble &&
> > +	    (ieee80211_is_data(hdr->frame_control) ||
> > +	     (tx->sta && test_sta_flags(tx->sta, WLAN_STA_SHORT_PREAMBLE)))
>=20
> Changing '!tx->sta ||' to 'tx->sta &&' sounds reasonable, but I'm not so
> sure about the other change.. In theory, short preamble is negotiated
> per STA and while we do current disable short preamble completely in the
> BSS if a non-short-preamble-capable STA associates, I'm not sure whether
> that would be an absolute requirement.

I don't see how it cannot be -- you need stations not capable of
short-preamble to correctly update their NAV, no?

> As far as management frames
> (e.g., Probe Response) are concerned, IEEE 802.11-2007 18.2.2.2 has an
> interesting statement: "all management traffic is returned with the same
> type preamble as received". I have not been able to find normative
> requirement for that being the case, though.

Yeah, I found that statement too, but no other information on it either,
heh. Not that we can actually support that easily at all. And besides,
it would be kinda weird to send probe _requests_ with short preamble to
start with, since then you wouldn't find APs w/o short preamble...

johannes

--=-LYihIeyb2nXb0VsUasKu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI84YCAAoJEKVg1VMiehFYOTAP/0FSHPcphrRjX2gmMONphw5C
kvSV5BlPg7l3EUz6s4xt0+FvxGTwayYShQiYM0mHrba6Sd6nQo0BCzwgkIWs1A1o
ctOR2zkNEFU22q0IwQzPRjsbJuFOraBcKMHfwESPX0OBmN/7kv4kDIsA6KJ1B07e
J+Za0/hq88ofB8k0wzwiwf+uj1AgiOiuDq2vzQlHf+4X8Pz4nhuSSqDjkxmJFBKw
zTCg4e1iJkca50udllEqFy8ei5mEvjPCciQd8hbVYDQcONl+GwVIB35B1xqmr9uE
M2G6hzviyQmu0L0fscy5EEr8rt8sjqOqlRQYjIvdqF3phZF7KhdTXQLzjL1Gy6Q2
DyYtmqXHLIkouwqMuNFgAGEfc3hKwof6EkDbVe2Er0EyArYIIVHIZ9/nrF4wgaTc
4EYvTzQ9iWO1TVuyyi/dJq3v9OGMLdiGFrnytIpo5wIej2sssA8wjoMIqfnGdy56
z5CQaXel6NDnWzBIxoNyhoZ8wqNhVqL6q2RzhfXfqE7dGssnJEsllxhp9VDhmxex
LPZx0lvhOVWYK7eo2Nv0IWp/DhlNatVZhzLCPHKDPDOH6xtFQPP3rGbMDiBYT1Q8
QVXlpf5gyxuZbEU0yFQsn5/OpI9IPtbTueTWrbbtUTSXCK16IJ8pYc+308JdyyhA
JWqYNaMWuyVz8oQW3Y3U
=ZefX
-----END PGP SIGNATURE-----

--=-LYihIeyb2nXb0VsUasKu--

