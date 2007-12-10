Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57411 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbXLJQ0G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 11:26:06 -0500
Subject: Re: coding style lesson: iwlwifi vs. endianness
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1ba2fa240712100821u284571d7k39b326e58aac93af@mail.gmail.com> (sfid-20071210_162131_710145_6241CB89)
References: <1196189059.6058.95.camel@johannes.berg>
	 <1ba2fa240712100618g35a8e13ve143f8687f1b531a@mail.gmail.com>
	 <1197299937.6035.81.camel@johannes.berg> <200712101630.48124.mb@bu3sch.de>
	 <1ba2fa240712100821u284571d7k39b326e58aac93af@mail.gmail.com>
	 (sfid-20071210_162131_710145_6241CB89)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YOKJejE6LLX2lb7a0CRb"
Date: Mon, 10 Dec 2007 17:25:38 +0100
Message-Id: <1197303938.6035.100.camel@johannes.berg> (sfid-20071210_162610_310116_D791B299)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YOKJejE6LLX2lb7a0CRb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Our case is
>=20
> Loop:
>  my_big_little_endian_struct.
>  set little tiny bit in it
>  send to HW
> end

You could even code the "set little tiny bit in it" as

struct->flags |=3D cpu_to_le32(flag value);

which all other drivers do.

It boils down to what I just said:

Most people prefer making endian conversions explicit in the code while
you're hiding it in defines which is unintuitive if only because it
differs from what everybody else does.

johannes

--=-YOKJejE6LLX2lb7a0CRb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR11ogaVg1VMiehFYAQIO4w/9EInsAGLAyqq5azH33qZb44OcqmzRRUwt
x6QkFJsrcsWHgUxoQY9TPRCQGMbAbTlUZifIVuC8WURD9RrtQ0TAIfJghMxgRRwT
fL76GIe1x42/cRIsStsr1qopaILmKTe2F9poLeLvO5fEOg1SJy5DixQIgn7Sfefu
qXLA3WaK78+zOgVzImwgtNIXgQrlV6VRrsx+wLdnNv9zFd4DJYlFcN/DJKrc+csf
ap4I6UTyWg8DdmzGn4wxBeN9Yq/qhlr0gRivjdIll5Dgk2azSVHaAmWT5ya3u/l6
T5a2U28BNcq6GWO0SjqX867bUZykiqIs33NFQAIuHy/4BhdpJq2uqHGwojPHJDe/
qpf9DCDzwIIY1lxkPl7tcFh1b4GFetcWIXWbhxAkdJH4mlskigZrmv/Sxp/ljfB0
KbqJDbvhy21iHbUXZ7G5FpOQLnAfohDQs+pL8EZKYsIM/hirivTQWyGL4zLSCK8x
pGf8A2ToyHzpKuPM2IwkiE6hnyFqC9L6TqheotQROB2dxmYDEEn3BDT5P6uP2CBy
FOZJe6jiUIRfTmYSa65hkn8dvwpZoucoJ34JXb3ZvodUQ9K9MaQ4krTw/Z5nCcRW
crEDKKYuy4mgJYMw+se6YtxK2FDlpTN3ZiFsFP+bangbj/FPR6RekGRl+9wyqOK3
kNmBYDfgTeg=
=P/1q
-----END PGP SIGNATURE-----

--=-YOKJejE6LLX2lb7a0CRb--

