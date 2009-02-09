Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33832 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbZBIUK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 15:10:26 -0500
Subject: Re: [PATCH] mac80211: reject extra IEs for probe resp when hw_scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090209200627.GA17463@jm.kir.nu>
References: <1234209631.4175.242.camel@johannes.local>
	 <20090209200627.GA17463@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jZDGUosPwjdRKQq4Bgbk"
Date: Mon, 09 Feb 2009 21:09:52 +0100
Message-Id: <1234210192.4175.249.camel@johannes.local> (sfid-20090209_211030_418818_58207B5B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jZDGUosPwjdRKQq4Bgbk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-09 at 22:06 +0200, Jouni Malinen wrote:
> On Mon, Feb 09, 2009 at 09:00:31PM +0100, Johannes Berg wrote:
> > We cannot currently hand off extra IEs to hw_scan, so reject
> > configuring extra IEs for probe response frames when hw_scan
> > is set.
>=20
> Assuming this was for probe request..

Yeah, it was meant to, but I screwed up.

>  I'm actually planning on adding
> support to pass the extra IEs into hw_scan handler, so that would need
> to revert this type of patch for probe req should one make in. Anyway,
> that will also make it more difficult to figure out whether the IEs can
> actually be added since the driver would need to somehow indicate
> whether it supports this or not.

Since I've posted my cfg80211 scan work, and I guess it'll go in, how
about instead extending that to pass in IEs? The scan request struct is
already passed down from cfg80211 through mac80211 to drivers, so
anything in there would be available to drivers too.

johannes

--=-jZDGUosPwjdRKQq4Bgbk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJkI2NAAoJEKVg1VMiehFYDS4QAMM35peE/KTl2RYR5RgMnPGY
W3xtokgM/kAilorhB/euSm/JmvniN5hJMCdEEpFrxV4EATQA6gtoZnSoabIIQmgd
CluL9UxFr19zLTz8QsgAgPENF+myhKaPIoDcMekNy/WQ0bsHagI5WC4T6fbd3BkD
J/NIYainYyfKczKXQ7Zj5Psh56SpofZf/UPvO5Mdby6t7bSYUJ17h9F720IYLJf7
7NsU//m57qh0wvLxVc0wScARZTbhlVFVI/j+Ehrss/U5seB8LfNu46RgBsfGAYgb
M6MfiZx9m8jq1U/5C3pPYsjDIYh2zXi9KCr3HlqB9zEdIqiJRzn/pxE9NO4U0C4y
3AkQ87Mgu0p1raQzgezv8fv2XXrtMkyQxbtOZC/Awxx7ShmF1FH0pSurDH8AvL5Y
ZcJIKTOKY9mIUzDUtn768xpUWZwYrVyvZaIrhq6e2zhrNsaOJZzZOhWP5JLwIxBm
hMQagap0tEjrFZQ1yVrEEhlms+dxjvqXszu547bFUZWbM/giKeZ/zf2j4J8B0yNg
pIN88vj2wAcbEftXjsm8coyRQpsP5WkdPm/rqWIkQ1LD1OkEyCdwnbToA+wX3SXN
Uml7IKSpZGv45R6xUkubKy9vbyHfcBZwy0D7KJB7rU/yZqusqMQBHwtylx9SJ3XH
9BIR7PyzcdpqBePn4H9/
=gmQ8
-----END PGP SIGNATURE-----

--=-jZDGUosPwjdRKQq4Bgbk--

