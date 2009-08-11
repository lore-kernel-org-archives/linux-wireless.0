Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53181 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048AbZHKO6E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 10:58:04 -0400
Subject: Re: [PATCH 2/2] usbnet: add rx queue pausing
From: Johannes Berg <johannes@sipsolutions.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	David Brownell <dbrownell@users.sourceforge.net>
In-Reply-To: <20090811145208.20888.70513.stgit@fate.lan>
References: <20090811145203.20888.83008.stgit@fate.lan>
	 <20090811145208.20888.70513.stgit@fate.lan>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-5OD2NClE2GULXYrKlj0i"
Date: Tue, 11 Aug 2009 16:58:03 +0200
Message-Id: <1250002683.13529.64.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5OD2NClE2GULXYrKlj0i
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-08-11 at 17:52 +0300, Jussi Kivilinna wrote:

> +	if (test_bit(EVENT_RX_PAUSED, &dev->flags)) {
> +		struct sk_buff *skb2;
> +
> +		skb2 =3D skb_clone(skb, GFP_ATOMIC);
> +		if (unlikely(!skb2))
> +			return;

that leaks the original afaict.

johannes

--=-5OD2NClE2GULXYrKlj0i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKgYb5AAoJEODzc/N7+Qma30QP/iY4patVn/wvvsfgT1jwfLOV
MI6FHZXvjpzM8Ez/L2YvpHtM4YQEWnXty8dg3O2+Y++1dl/4UVTU2ms0r3vyBjmJ
E+z7x186i37W9MqzrrbOhoP/uqtekbkQ2G6OMxGk533Jq3oQQtNPshHRFwj/pwAk
8iad9JdTEN5iKbzh30VsHq0/al2HXJO1QSl+ZKqjCpRF/kkFszxGZIabgsjk064i
G0OnU7OQGQC0QplFh5Iq19H0Wv81dm6XRBPm1NwoWRl1GeVyoeEpRUnSTuk12HDA
a3h8ziWs0sinkcyOlqusRJULrnvNll7ntTdSDudON1aRPeNnOhL1C69nnsmcMgLj
dNSKTW0sh4EUEYChZP49nhjCzUeo7T4n/Lw+/V7++3bL+kWXOlycqFVXYWPkqhtL
eEx5myvqauAQqIOUxx7ePxR5b3SVREurawuHJ9/BrrbflW6Ad4PTCK7g8BFvnVO0
32VBsgsaa99rWMDqfDeh8S8iIb/P76mTJnmCHhMmM3NWscSy2yBYNl4TkrovZSIv
OCauAoZo2qurG2Unc7YSkzOB9uje/2V9kBAt3NHRZ+QCyqtVZ/O8woATQ2zvOUSl
jYC1/Al94jNhEmoQmJQAtgdUWkyIzBwna6s8tQv6afXGbiDb/YrHSuAPgnhn1qnX
r8ufiNdZdw4bFZtN6bx6
=dyLW
-----END PGP SIGNATURE-----

--=-5OD2NClE2GULXYrKlj0i--

