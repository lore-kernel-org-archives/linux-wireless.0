Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55930 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbXLCKoF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 05:44:05 -0500
Subject: Re: [RFC] mac80211: don't use if_id, use if_priv
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200711302059.23415.flamingice@sourmilk.net>
References: <1196423301.6058.187.camel@johannes.berg>
	 <200711302059.23415.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Xv756YhjAeE83ZShiQbg"
Date: Mon, 03 Dec 2007 11:44:02 +0100
Message-Id: <1196678642.6060.32.camel@johannes.berg> (sfid-20071203_104411_002644_7A4DF75C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Xv756YhjAeE83ZShiQbg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Note that a good chunk of the if_id stuff in the api was just brain damag=
e=20
> from the ERP info changes. Anywhere we have access to a skb, we have acce=
ss=20
> to a netdev, and we don't need an extra if_id argument to tell us what we=
=20
> need to know. I would love to see that get fixed first as that simplifies=
 all=20
> drivers.

True enough. But do we want to have drivers rely on that? Right now,
what parts of the patch do is use the tx_control->if_priv field for
getting back to mac80211 about e.g. CTS/RTS duration. That's not
something we should be requiring an SKB for.

> Having said that, a per-interface private area for drivers is a great ide=
a if=20
> drivers need it. They probably do.

So far I've been able to do without it in b43/multi-BSS code but I think
that more interesting things may need it so...

johannes

--=-Xv756YhjAeE83ZShiQbg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR1Pd8aVg1VMiehFYAQJB/g/7BTN9VZ5NyzWATDrfrf5ScAN/gtOX2srU
NPfmucWZh+ucmW+oLmd3Sn8ZvXazz6itmlZZ6PSiIWn8k143SoPHiF5+jD5XxZrK
GqKhKH9Y1ulKzBZzzsIiZDgCc6tEVkH5aQUyCoW6qIPdk5XTj/EcGB5JzXcCSLMK
9b4SUwWG8GiUMUSH4DhQDrXkzzLKXSJqGt2acLVk/nBdokqaIaNARkGZBwtUly9+
ayUdGhNT7D0qDnMHYZQ0FmO3h3BgoosNqW0d+MpFxoGH08z62vy1b3c3aRifTWS3
2CSp/cTOGaPc/luI/Pg2frpLp57WHS4jkO/RDbmVWHgVQv1CwZr2S7CGq/gPkl2m
oPyNsa/11pXstrIJ/tH+30Wk8HQfZUFsTSC7dzyag3zv4m1/8d0DECb9NiYz3VMV
kbV+3a7j4WB0DgtXJDQkeUBHwALPqWiq3uUVWY4bmFLyqFC6TgCcam71HX3YZTHN
tj7RkNAC/K7FGY9/KW88TjLhFD3BRNhm5741DrJZUalsRXM8CKLA8FtcZbGEN2vg
IxjqKS0WpAwp+SLdga/zWMOj/KXG6rnjVN7oiNxgR7k4QE1o05rVGFjxfh8POJo/
tJ5feT+PuGqEPeG6f6GUM0Vw8yTSlSdXD5eP3WfZrGGbIrF2POGWsJMVG3a6+4l6
9gDekFT2tws=
=Wqgt
-----END PGP SIGNATURE-----

--=-Xv756YhjAeE83ZShiQbg--

