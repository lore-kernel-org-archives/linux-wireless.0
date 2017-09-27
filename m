Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.linuxprofi.at ([93.83.54.199]:35000 "EHLO
        zimbra.linuxprofi.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751396AbdI0FqI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Sep 2017 01:46:08 -0400
Subject: Re: [PATCH] ath9k: fix tx99 potential info leak
From: =?UTF-8?Q?Christoph_B=c3=b6hmwalder?= <christoph@boehmwalder.at>
To: miaoqing@codeaurora.org, kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        sssa@qti.qualcomm.com
References: <1506474814-18118-1-git-send-email-miaoqing@codeaurora.org>
 <01A373FA-9C6A-45B0-B793-8C87BE0DF079@boehmwalder.at>
Message-ID: <3d748efa-6e0c-b5eb-5f3b-5963b3cc3d0d@boehmwalder.at> (sfid-20170927_074717_574507_9C514C41)
Date: Wed, 27 Sep 2017 07:45:44 +0200
MIME-Version: 1.0
In-Reply-To: <01A373FA-9C6A-45B0-B793-8C87BE0DF079@boehmwalder.at>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="du6nkmT0RbW5g93kHaEcALm0KCUuKOXEw"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--du6nkmT0RbW5g93kHaEcALm0KCUuKOXEw
Content-Type: multipart/mixed; boundary="x1qQRcF22ck7m0ub8fG40s58jbiRRjQhp";
 protected-headers="v1"
From: =?UTF-8?Q?Christoph_B=c3=b6hmwalder?= <christoph@boehmwalder.at>
To: miaoqing@codeaurora.org, kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
 sssa@qti.qualcomm.com
Message-ID: <3d748efa-6e0c-b5eb-5f3b-5963b3cc3d0d@boehmwalder.at>
Subject: Re: [PATCH] ath9k: fix tx99 potential info leak
References: <1506474814-18118-1-git-send-email-miaoqing@codeaurora.org>
 <01A373FA-9C6A-45B0-B793-8C87BE0DF079@boehmwalder.at>
In-Reply-To: <01A373FA-9C6A-45B0-B793-8C87BE0DF079@boehmwalder.at>

--x1qQRcF22ck7m0ub8fG40s58jbiRRjQhp
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable


>>
>> +	buf[len] =3D '\0';
>> +
>=20
> I think it would be more appropriate here to check if buf[len] =3D=3D '=
\0' and return an error otherwise.

Nevermind, I just had a closer look and I actually think your approach
is fine. I hadn't considered the possibility of someone deliberately
passing a non-null-terminated string with a specific length.

>> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>

Reviewed-by: Christoph B=C3=B6hmwalder <christoph@boehmwalder.at>

--=20
Regards,
Christoph


--x1qQRcF22ck7m0ub8fG40s58jbiRRjQhp--

--du6nkmT0RbW5g93kHaEcALm0KCUuKOXEw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJZyzsbAAoJEM3PQE6B9NDDA20P/0Und52cLmIs2viBoJcSav+p
Eq3hw0mYANeM1v4g9N7x/Te1hfbnTfh/fiEIcPQ9CGjJJATdF/efNOeBIrPwPCiA
ofVYT5AXq14R7BL2qLM6OcvvacPFjV/ERQNHkhr5VuwDOMk00rCJZgrkzyj2BP0F
SqBSxsJvf63oXmOyb8meQRxbFlE9PuNHy/STnv1Vh+otrTJusXnyV95xiwzWwwCJ
aX+SFnByUXSVRmKlPh2PpUYVDj+zHRxDFdn0IdfKZExAfEdWj9YdVSjVQpzIUpVj
+Qkpo8hJiMbyCvyRKdX2GmXcjFewap+vqu79Pk0cB+zIn6E8iTzYlJWiMSKKaZQL
9ZzZ8lA+ldhnO/sNq42s8Xs39fARExQEPBz/5zJSX9BjRTJzjH2JdX65QMkf0YWp
LdUEHyxr24N9u848MvtGamNnwWiyHJRHpn5kpoKWTrtt9Syn0WeoAjJvYvFgNwpV
LfOQ3B1hdQxvmCDL10jNZtN0rE7ZjoLDawSPzTgd0u2H9Qry1k1/v7Pvs5TAV7lJ
EpsF27y5u/owvg+USNST/fCY0uCNuAQ4R4AYYOl2XqAGOOiy6VQhhS1QbuufL1j+
8aGe1gnhiaBs5qNvvulW9DK6ZDJnHw92J/J94D++B8Dxplre81oqwfsfh25p32lM
U9Y7ZNzJumpmAIYq3Oqd
=RDF8
-----END PGP SIGNATURE-----

--du6nkmT0RbW5g93kHaEcALm0KCUuKOXEw--
