Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42059 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428AbYBGKgn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2008 05:36:43 -0500
Subject: Re: [PATCH 06/13] o11s: mesh.c, support functions for mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47a7827a.1d35640a.1895.040e@mx.google.com> (sfid-20080204_212419_996010_27841680)
References: <47a7827a.1d35640a.1895.040e@mx.google.com>
	 (sfid-20080204_212419_996010_27841680)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NNwkRbrI+jJ4hmB3tg/t"
Date: Thu, 07 Feb 2008 01:36:44 +0100
Message-Id: <1202344604.9965.64.camel@johannes.berg> (sfid-20080207_103651_677757_4EE98A53)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NNwkRbrI+jJ4hmB3tg/t
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	p =3D kmalloc(sizeof(struct rmc_entry), GFP_ATOMIC);

rcm_entry is pretty small (24/48 bytes on 32/64-bit machines, if you
reorder the fields and put "sa" last it will be only 22/46 bytes) and
there are lots of it, maybe it would be worth using a kmem_cache?=20

johannes

--=-NNwkRbrI+jJ4hmB3tg/t
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6pSm6Vg1VMiehFYAQLgng//Y7Eu4aH5lD2XQ3hPISIyNK+dT9lcR6ZR
iiF+gf4gxJGCisCc75ipt7WEtE0XHjRHspsuImAeB89X36nsPvmxt3yNiHP6StWN
3k8piEUD4RA4wfIGwENePSRFjgaPolDQOq/2ZbKlqm/rQR5vRPNfke6vkhVy0kei
irGoQJ8BpDyfsFJoIFSHT9FyzJyD1Si1Q/McVE3d48U7Sqo7u0UQHGNoExV9NVrC
CJP1OyUHNFUv4/pkoesj9Diz+0rnhgF/ju988JsUiwC+adDpbefel1Tmi95IAUh2
jKHt0CJEdVr9riruygmfq/ma6hUqsT/Xnjw+3gsZXb6QyimBvWlQDUu6sVSgRXci
sDfUUw5+UuC0itDNzg6XZgpXtmtJ1stxn3MF0mdfjTKAH2yyzhCKN6aFyZ0NhvGy
E3RcQIwf8W9sI6EFWK9vi7diUS5bcU4q66Hg6cLcDzby7uPlc6V1CE6d6/cH3zAO
3dUVyQj2+/30b0rH6XBkoOUV5eUOPKtImRM6LClhJo9XxpnO8wVUT85y50I4rX+d
QBzbaey40XiDJmkvYVAoDaAYDA0Z1hOW7qJN1WN1q8fDRnleRuyreXTEDTKc8uxJ
3D5wXLNPW48FkwI9F59UltwQWf+Wq8reLGwqJ5tNC7Qd1ucXkltUlm0LzxXYNztb
aKBPnIOA8D0=
=UTJh
-----END PGP SIGNATURE-----

--=-NNwkRbrI+jJ4hmB3tg/t--

