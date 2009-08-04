Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33263 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932492AbZHDHOW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 03:14:22 -0400
Subject: Re: [PATCH] cfg80211: clear SSID on disconnect
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg Albert <jal2@gmx.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20090804T064513-963@post.gmane.org>
References: <1249311832.4561.2.camel@johannes.local>
	 <loom.20090804T064513-963@post.gmane.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Lpw/qFFNnD7zyHS2Q8VE"
Date: Tue, 04 Aug 2009 09:13:49 +0200
Message-Id: <1249370029.9415.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Lpw/qFFNnD7zyHS2Q8VE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-08-04 at 06:55 +0000, Joerg Albert wrote:

> Sorry, but this didn't help with the ar9170 problem. I still get a call
> to  ar9170_op_bss_info_changed() after ifconfig wlan1 down.
> I put a printk at your change in sme.c and it's not called.
>=20
> Please be aware that in managed mode my adapter stays in state SCANNING, =
'cause
> there is not AP around with essid huhu_m:

Aha. yes, the same assignment is _also_ missing in
__cfg80211_connect_result(), can you add it there manually (in the
status !=3D WLAN_STATUS_SUCCESS block at the end) and see what happens?

johannes

--=-Lpw/qFFNnD7zyHS2Q8VE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKd9+qAAoJEODzc/N7+Qmaw5cP/irqw6K9DpBJAgjyk0Mozvgj
7/jus2oIbKf566EAx92yw7A0yfovGhAzfIdaQUEkcH7FZo18O24kWnYPzMQha2AE
0EnlOiQYLrilSY7/z+5G6Xg2Mmj3wJTDE0lW36pYMTzV80HJ4GUi759KSauMxklP
t3u1iahxRCJFAMSmqcoBgqhnc/lWt/r6boiljYq5SrQPQWTmwtbo7MJc5eXh6UYz
JsKqheiZLCxOE0uzEgY/HHuzOfg+mg8Er7b8ZN1SPfZerAInqmmsuBArgmOqg2kQ
8sY7kE967bB4lDfKbg75SshXaKFyqW2oZDqGE8oDqB+NjLwRijLR7vuAfRoeHAlT
hrZzQw1wyqjxNNyHWmXV3fcn48RdF7uG1bsWRBY5HGlh4TnlW0tOLh3ZTQpzsf1W
tq7tEM3sVKmqN5GUdYt74qv+srJKzcitPRC8WJUy/rixEOqdDO3js9+cHQykK98C
Pbday6S9IfyLS2nWxlQAiokE1n8iPWCeOAOi87WjoyuI1IkLudbZCEbeOAHuLQmz
yeBem78XFLI6rZBQBc/UdsbTu6tjr/57BYDJRhiUbY9ZkRneunKv1pJDHeB5hEyj
AFOw3R1rqfmTz1nIuQUiEZT4E7OKZ49omegD+/EBRgzdnt1mBxSYDKOT3q4gz/SS
LydZxgo98UabkmLQetLx
=bsZG
-----END PGP SIGNATURE-----

--=-Lpw/qFFNnD7zyHS2Q8VE--

