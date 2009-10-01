Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37996 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbZJASjh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2009 14:39:37 -0400
Subject: Re: VLAN traffic appearing on the wrong iface
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Bla=C5=BE_Ba=C4=8Dnik?= <bacnik@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <57b62e7d0910010740t67a96d88h59b10161844f2836@mail.gmail.com>
References: <57b62e7d0909291754x352ae254sa33ee7efb430d497@mail.gmail.com>
	 <1254341787.3959.11.camel@johannes.local>
	 <57b62e7d0910010732m38ab57k916662f9047fcc91@mail.gmail.com>
	 <57b62e7d0910010740t67a96d88h59b10161844f2836@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-9PwvGaLUAVHmvL4OfR5R"
Date: Thu, 01 Oct 2009 20:39:40 +0200
Message-Id: <1254422380.3959.23.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9PwvGaLUAVHmvL4OfR5R
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for looking into the crash -- I can't explain it.

> -	if (ieee80211_vif_is_mesh(&sdata->vif)) {
> +	if (ieee80211_vif_is_mesh(&(*sta)->sdata->vif)) {

However, that doesn't make any sense, given

	struct ieee80211_sub_if_data *sdata =3D (*sta)->sdata;

Could the compiler be playing tricks on us?

johannes

--=-9PwvGaLUAVHmvL4OfR5R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKxPdoAAoJEODzc/N7+QmahOcQAMnFwKXb3y1Q8kvp5O/Z+MUg
HEksI63OZu+dsBvVlh7HtWJ1HgB1Gd0ZJxIlCohNu5hdWWUf+Sh3Uym5RXNsPL7R
ms5UHo31TTTuPIX/47F9BtBcQZaqnI2vBiBIfzIXLCX17mmjzB/yKvLjsgscFeZH
5wC2fwUHA6AP45nM1Zq8N2gE0jO51E1gE9Hc3bOqoOCSiYDdslu8TpF1/y7B/rd+
7xlW+8UCKSu8yMaPKupZaf/PDyCYsRQESdCToBBK8m/GU7HNpLm71dzIMbpWs/+e
ww0neD5sKWIIHj9yo7MizScC/DMb+iuPOVUh8kprLevAh0IdoAXYLX4PT0Z7N7qo
S5/xuvI46XkuQoms/Al88UecFks+SycMuZO8eMDydW4o1MdsWr3qBAnb4l4iHDrW
62dj9ZoyDyuMRp4DOKPY+mx6wbxK5hTuaoD/1V3NyBU3beQiRsWrIKaJp58FofjM
7O7KcBpruH/y4tfJ7aSZ/gxTRc/JIIAR+gtRTxPoJtXliap8kbX/EDIXZJjIpQql
kQBodcyma1KfdUxf12+yFUC2fSFIjAxllcVIAPP2L8ZycsXs5H6TonhCjbrcbWKg
6+MDY3xXSy/yNjjbV0wU/ubzhe1bJdLzDsg4t1mErGpbVv2uUsTkRdGRF5QVzwLZ
t5uXJi/p/uJrFHryARvj
=C4OQ
-----END PGP SIGNATURE-----

--=-9PwvGaLUAVHmvL4OfR5R--

