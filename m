Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36673 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbZHRR7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 13:59:14 -0400
Subject: Re: [PATCH] rt2x00: configure_filter() callback is allowed to sleep
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200908181954.23419.IvDoorn@gmail.com>
References: <200908181954.23419.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tZVfLWUj5XjXTUnK/WaY"
Date: Tue, 18 Aug 2009 19:58:44 +0200
Message-Id: <1250618324.9886.25.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tZVfLWUj5XjXTUnK/WaY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-08-18 at 19:54 +0200, Ivo van Doorn wrote:
> The configure_filter() callback function no longer needs
> to be atomic. Remove the scheduled work structure and
> call into the driver configure_filter() directly.

Nice, yeah, I didn't want to do that myself :)

Speaking of which -- bss_info_changed can sleep too, which means you can
remove DRIVER_REQUIRE_SCHEDULED completely I think?

johannes

--=-tZVfLWUj5XjXTUnK/WaY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKiuvQAAoJEODzc/N7+Qma6H4P/31qx9R2wcfGSLW04G+sgJht
PjFnl9CJSPNGfxbDv/kMAE9UWFKTxDHW/NoQKN7BqvoVHySOKTkCSyajx3+dPAiI
X31WZTb7LYJd2aYNfwyOcdYFgs40LT6TI0gQhvn/MqaRezkNddKv/TMn9IKVaZgP
9IMIE/xAmHtphn4M4st+efugv4Gx/eUxvMCb9cWItrX74HqrxI0JgGyF3/JcpHGq
vYudN0sdAgVI1t4nbsgKwJr1RKieeerQdFKW7KclkaG1+lLX17yVqvb7V3tpNfzQ
TrSjdGUedRM+ChBUQpSj+t4MGjvIn84+H0w2XadxjJOgLtYjMqqX1ALxCDeJxwLp
tK90wNxuX3x3UTX+JxEc6mLDfNDcmlr6T8Aw+g+iTwfCzzWGzVrEi6U/ruRp7Lvk
vCh+4HOnYC/kJlXz2uxe86vJ36wFydHICfxbErQyO0NoFgxEbu0W7FdmRnCtKWaZ
lguHpsyRrkU60KRCG5K5n3WI5Y11jF4WiAOGq1d8NTLdXyJRrkSV0Qduxus7BlKB
OQBdI12tuUh9hP90sWXQFsKSv/UkW7x1wKy8xUsSxhvq8CslZ1nfZK1GrRHH6NMK
OIarBJxqRc4JccD2ryed00cM2DEOGNV0/19vvLE1CWkbJNoV9PnyphKIsT0LIh3+
Xi0MRO6Ho0ssqLGo+R80
=YqRB
-----END PGP SIGNATURE-----

--=-tZVfLWUj5XjXTUnK/WaY--

