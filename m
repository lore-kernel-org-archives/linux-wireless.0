Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57733 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbZCXNL1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 09:11:27 -0400
Subject: Re: [PATCH v4 0/5] mac80211: beacon filtering
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090322195619.26460.48292.stgit@tikku> (sfid-20090322_205736_404068_42654ECD)
References: <20090322195619.26460.48292.stgit@tikku>
	 (sfid-20090322_205736_404068_42654ECD)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UBWffX9MRYuPCzqVzO1f"
Date: Tue, 24 Mar 2009 14:11:16 +0100
Message-Id: <1237900276.4320.86.camel@johannes.local> (sfid-20090324_141129_858582_6969A1B6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UBWffX9MRYuPCzqVzO1f
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-03-22 at 21:56 +0200, Kalle Valo wrote:
> Here's my proposal how to implement beacon filtering in mac80211. The
> basic idea is simple, the driver enables filtering whenever mac80211
> enables power save and the driver calls ieee80211_beacon_loss()
> whenever hardware informs about beacon loss.
>=20
> I have tested this with stlc45xx (with beacon filtering) and iwl3945
> (without beacon filtering) and based on simple tests this seems to
> work. For reference I'll send the stlc45xx patch as a followup.

Something I've been wondering about now is how to populate the exclude
list (which would probably be smarter as an include list, but anyway).
This actually affects the entire stack, take for example the BSS load
element, which could potentially change frequently. Unless
wpa_supplicant would want to use it for roaming, we could ignore it.

However, how do we know which elements the various pieces of the stack
need?

johannes

--=-UBWffX9MRYuPCzqVzO1f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJyNvwAAoJEKVg1VMiehFYQRYP/3lQYhBSt6hHPXbkd5wrbtjc
CBBynyjWTYEqwR6QYiru30RZTz6/0drpAbim+U9S+JtAB6R6wObMKLqhWy5uTKHk
EzGbPRKKBmeryeKe5+i8xBSFXSX7qXkjvf5aqINeik6ZK6pDSS1QL4tjU3qsnXGB
Vjj6R7WH3cKvSWPy2RWLvm59WA7KwfA9m9OdHFgqKZ6pOaLdCyvgvO7+8Pj6VSa6
plJ6nDJGlC8YDo+s9z988Io7bR2UDNP6cLkMVVCcPpymvgpwqf599wSHuhea3EF0
IngUHL06RBkYdBzcuQlB/PtWkdcJU6A79lxwR8iU0t82+pO8rIGYm9pYmHhKnxMy
9OrRYbzyOOXeLsx1f+nIk9aDhqvAmeu5oELSow88hZuZjCULlpra282cfQIYxnCJ
bZ7wemig3vYh/1JVrzFoxz8jLrV8a7/2An2GkyFuTivClCvhUA8cmtY8NjGVjSKW
VAcTexr7+chAJaSW/8VNclrmR6PSGkrs0bBvfCbXW3tPYqUoL5dzKktedK+pk/UN
F1bpNRCCIbZp3J2PO5m5spBQv1GbYLJIduGz7i7OglrhS1h6yGNhVsUbGu1k+35o
18tG4smydYp4r64k/lGr9b+d3QD5H1v6+o1yirIkvO1BZ8Vw0Yn226ZDmdWtc3Wo
aWnzL7Z6tBvT3xb54SC4
=CVes
-----END PGP SIGNATURE-----

--=-UBWffX9MRYuPCzqVzO1f--

