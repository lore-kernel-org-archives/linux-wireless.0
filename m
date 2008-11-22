Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52629 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbYKVS0X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2008 13:26:23 -0500
Subject: Re: [PATCH] nl80211: Report max TX power in NL80211_BAND_ATTR_FREQS
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20081122182051.GE4887@jm.kir.nu>
References: <20081121170130.GA4887@jm.kir.nu>
	 <1227376464.3599.20.camel@johannes.berg>  <20081122182051.GE4887@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0xG2RKC8c3KqdodbKDgv"
Date: Sat, 22 Nov 2008 19:26:15 +0100
Message-Id: <1227378375.3599.27.camel@johannes.berg> (sfid-20081122_192627_914004_931015F9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0xG2RKC8c3KqdodbKDgv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-11-22 at 20:20 +0200, Jouni Malinen wrote:

> Well.. Maximum TX power is stored as dBm and it is used as dBm in
> Country IE. Some of the current uses of EIRP seem to be converting the
> values between dBm and mBm, so it does not look like the extra accuracy
> would be needed there. Why was mBm used in the first place? It does not
> seem to be used anywhere outside Linux regulatory code as a standard
> unit which makes it quite a bit less obvious than dBm..

Yeah, true, I think we originally wanted it in the regulatory code and
also push it throughout but then ended up converting it in the kernel.
However, the userspace API is defined with the extra accuracy.

> I kind of agree with consistency being a good reason for a change here,
> but I just find the mBm a bit odd choice as a unit unless there is need
> for greater accuracy than 1 dBm

Broadcom hw at least supports 1/4 dBm steps, iirc. So it could at least
make some sense.

>  (and in that case, the chan->max_power
> value should likely be changed to use mBm, too).

True, but that's in the kernel and much easier to change later than
userspace APIs.

johannes

--=-0xG2RKC8c3KqdodbKDgv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJKE7DAAoJEKVg1VMiehFYNiIP/3VgH4h9k4HkI7A2oor2SsIG
bqdzfnG/xbLL+/dOWhpmKZLXBM3s/IlAa/CacD4nzKv9HO6f3Htfb92CNqsrb322
XsNnzKz/0MadV36xe+Shj+C7VBHTliCzb6rvnFXpOwIGrygoAz2/BCmyZscSkaI1
fds0zkHzWPwM2Wqg9kc0onxR6S4ro7KHbAtUWqos4CP1JhijaKx5tpDJwuhfWWV5
dJVgDspHr7l+Lpl8GUysdI4LPsxH7QFuW7PwApHAsbUhGihNbVnMhnu2V46yvWe9
9DIuRx+b7zHqDTjXynjIWiTcMuldrgyaJ46eQ1E3SFF6ouRbTbYF+ihF0WSJUK6B
9/l/24miC+IKAVzZdrntPh6HaJC8BwYzr9GZ9hbFnCW0mqbvOTDTF+jkQsajTUJP
h5eSr9GA4IyE7TEAfCx67vW/AwrklclQj56ACWBTbjJT01m58MebxesETKmmXcj5
Ubp1eTbcuFXTtxhbea223FIeH8f2I4iJhL6eg1vUWOjG6zP8du8G9nfP6xxCIH+3
0drQFvBH8nCgC17LX8YdcEnx8bfjNM4d7SFgeVUJpVFO/kPoutoRrVarMlAhXIeD
QCmiBxW+L/OkFjEdTxGL3GSoFneQeJc0UJNFs0KOBos/1vltciS4f7RvSw0uiX2b
BA/oS1js0lRTHEXtnMfZ
=GoOf
-----END PGP SIGNATURE-----

--=-0xG2RKC8c3KqdodbKDgv--

