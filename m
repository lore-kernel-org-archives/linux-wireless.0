Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51559 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab0AEJ3g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 04:29:36 -0500
Subject: Re: [PATCH 1/3] mac80211: Select lowest rate based on basic rate
 set in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <20091229105919.GB18493@jm.kir.nu>
References: <20091229105919.GB18493@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QXa9dqw/y0ne814HENX9"
Date: Tue, 05 Jan 2010 10:29:30 +0100
Message-ID: <1262683770.20098.12.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QXa9dqw/y0ne814HENX9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-12-29 at 12:59 +0200, Jouni Malinen wrote:

> +	if (basic_rates & (1 << *idx))
> +		return; /* selected rate is a basic rate */
> +
> +	for (i =3D *idx + 1; i <=3D max_rate_idx; i++) {

Starting at *idx+1 only works because it's always 0 or something?
Wouldn't you want to go down from max_rate and find the highest basic
rate or so?

Other than that seems fine to me, except I'm not sure I like the
"txrc.ap" thing much, but it's probably a reasonable choice to make at
this point (but consider mesh, IBSS?)

johannes


--=-QXa9dqw/y0ne814HENX9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLQwZ3AAoJEODzc/N7+QmaofUP/1IxoZwgjR7sjD7KKVonMLbU
nkJjwRbEed1wG4Kxtc1EpoNshDjoi0Rtfm0k8lyV++GrABA2M8yw2syh7GkZJ7kq
GOFgX/GmCV8rt82RWh/6zyl+s4j9IgR+8KimkdvuJePSjhjH3CXdjfT3oKF5P2+9
HbLz3bdhogXrvg8Qf849zgZTLAKBsTiNiPB80okNJ1aDmQbi6JynxvRzUIVski1Q
QV0JmoN73F9VzAVFeMOlitM03ViabIxe0O8dkPJWnyAtrSUs6BtbdQs67Qjl+AGu
9Kdf0BNYO5kmvjTJx1gxd7f6YwICQXUETN8r43kKNucE9uu057BjSh2sjrUrv3hv
ZH4w1LIaG7B+9R0TOS78Q4OuSBGjcZGEq/y0EmJvRpHYG2XPdRgxE99YttXPlk9K
yJ8vYu98GvqDXuKQ7/V11rGrMRHdWIV2MA2RVSIqTMiLTiiDOJomsYz3B/6kspc4
0GgdB+lUBmTw9qBfPxSO8/EC7bY62EkKDEI/Zof+r33RglngCkJ+zoFEA/n7r/6o
HZ4FN8jwbcIeOaTnUaKKcdP9Cqnx6b4Mn8QtozZStkVh1nHSwRW1pvi7y3CdJ4rg
lN5zHBayduilN7/8moyKYMhN9fC3FSmdFXus912WoRDPENQKfs1A9PtodgmKkGJq
nxtrmPp7LnryuJRsvieO
=5/9o
-----END PGP SIGNATURE-----

--=-QXa9dqw/y0ne814HENX9--

