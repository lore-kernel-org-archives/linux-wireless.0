Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37256 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbYCaNDA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 09:03:00 -0400
Subject: Re: rt2500pci, infinite calls to rt2x00mc_configure_filter
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Bas Hulsken <bhulsken@hotmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <200803311451.23388.IvDoorn@gmail.com> (sfid-20080331_135223_461517_6C2BFEB4)
References: <1206801246.24689.19.camel@Bas>
	 <200803291801.17068.IvDoorn@gmail.com>
	 <1206964876.5468.12.camel@johannes.berg>
	 <200803311451.23388.IvDoorn@gmail.com>
	 (sfid-20080331_135223_461517_6C2BFEB4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7axb6vXxfKrjrLhWKQTt"
Date: Mon, 31 Mar 2008 14:56:24 +0200
Message-Id: <1206968184.5468.35.camel@johannes.berg> (sfid-20080331_140304_731636_757B5697)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7axb6vXxfKrjrLhWKQTt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> > The driver most definitely shouldn't do anything, but neither of those
> > flags should be needed. In a BSS, all frames from the stations are
> > addressed to the BSS-MAC, i.e. to the AP, so the regular MAC filter
> > should allow them through without any sort of promisc. And control
> > frames aren't needed, those are just ack/cts/... frames.
>=20
> Ok, I think I found the problem. The packet filter in all Ralink devices =
have a
> TODS filter. Currently I had this only enabled when FIF_PROMISC_IN_BSS wa=
s set.
> I'll change this to a check that determines if master mode is enabled.

Ah, that would explain it. Bas, I'll scratch this item off my todo list,
please get back to me if that doesn't fix it.

johannes

--=-7axb6vXxfKrjrLhWKQTt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/DfdqVg1VMiehFYAQIZyxAAkIDfsKkWBJFKexg1r597qVeI/NfAhW4e
QyYNwNfCc5M+4VqNWfuQQHUIw0Z6cynjAn8TGT4dzPZ3Zd5DBshyLcKlaGo51YxE
s9Gm84L88M0co6/stvLyijW+pqE5aeArCNLwBpG/s6UneYXl5j1b8r5YCssBj9cO
RrFBTQyL9zV1UdfuTXEKEIqQcDFYJOZ1tAVCdk3vd/sjx70P/xOU3ohN6Qt5XLup
oZI2ekUM47CE5sPBYfCo10fEaxEynJJ87Uhq4eFSqeUJ/l5laFcitY5hTmQG1wBS
qWx7KaRIGevOqKBpnrzfjAOSqkEraUl1IDa/JBFR4lAjtx6t7fO/n2I6W1adPI9E
pAIZlQmGKiEsDxvkjONGqgI5LoBwWrihQME5up88yrVuFouJtiO1y+xo+7R1+3GQ
2Ti7N0qOILT86i1YucWs9fAIzCLVawb1NafhUwrOElfGUfNwEYpa+0ACn45Zvn60
s0Ad81JfHSwGkMQ74EQ5INrn7bGYgTAAG0/lQA8yPd6HTaUIODoZv+Gvqvrdp7Ld
lRDTb6AgNkfWr5W1OZ1U4BIWHDFZUQYShV0Sdk/EOZkH2XQWvOHuKQDds8SRaIOo
T+D4ssmzWe08r9nkVe9TulMZT8/6Rbe5ZTvvZkdQX8Wh4a4sUHLmJSmYSx5vaRYj
SumnQ1e1hHg=
=+geR
-----END PGP SIGNATURE-----

--=-7axb6vXxfKrjrLhWKQTt--

