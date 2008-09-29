Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43893 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbYI2MFx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 08:05:53 -0400
Subject: Re: NL80211_CMD_GET_WIPHY reply doesn't fit into nl message buffer
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>
In-Reply-To: <48E0C384.3000903@gmail.com> (sfid-20080929_140111_676994_F2B0D8C5)
References: <48E0A65A.2060102@gmail.com>
	 <1222682480.7064.16.camel@johannes.berg> <20080929102021.GE10429@jm.kir.nu>
	 <1222683923.7064.18.camel@johannes.berg> <48E0C185.6070705@gmail.com>
	 (sfid-20080929_135242_032949_BF501638) <1222689340.7064.26.camel@johannes.berg>
	 <48E0C384.3000903@gmail.com> (sfid-20080929_140111_676994_F2B0D8C5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-T8ccUh7z8cL2R9M9teXP"
Date: Mon, 29 Sep 2008 14:05:47 +0200
Message-Id: <1222689947.7064.28.camel@johannes.berg> (sfid-20080929_140557_896161_E9AEEC44)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-T8ccUh7z8cL2R9M9teXP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-29 at 14:01 +0200, Jiri Slaby wrote:

> Anyway it is wrong. NLMSG_GOODSIZE * x for x > 1 doesn't give skb aligned=
 to a
> page boundary. bufsize should start with PAGE_SIZE or 8192 and be multipl=
ied
> then and the parameter used for nlmsg_new SKB_WITH_OVERHEAD(bufsize).

Hm ok.

> But it's ugly as hell, I agree -- and quite a temporary solution until so=
mebody
> decides to add channels, another channel info or whatever.

I'd much prefer just splitting it up over multiple messages, shouldn't
be too hard but will possibly require changes in the userspace parsers.

johannes

--=-T8ccUh7z8cL2R9M9teXP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI4MSXAAoJEKVg1VMiehFYX/gP/2ZkxQCE9l2pPwWaWSxKKpDO
+6/ej1bd5bRV5lpHQcCFoXm6x6Hz2nDuxn8M51+ofDoDivWPVehGS34+za8a5n1L
yiMYBSoLitXtFXGGyTzJGJJ90oV3rP+H3pNoaSFzx55m4Jlsw3TZIbHVLzA+kcsZ
WA2FO4tIBHFDTC3wlIcBMNNw9n12q/D90AIFRc7q6CRZHwVTq2qGqst5WicEdUL0
m0FljGBhY8/6UYTu5C7+WLg1FdBckwEdxXO1QegNmrYnGjL8Eo++vLnXDRw1CyB6
+HkMKx8oYt2LlU/ry/ftWMpMVKZGl5SCV/6MLiUlbenET18erYDEK1IHrZpnT72h
DUIZElK4WNx6ivmFoNpUdHuzJKnjbZ5BIMcY+p1u1VUB3ChADodwxgs8KUBmj4By
wolzAvZaXen9OUnu5AjC5Ub70oOEFPD/lO9/Qj9gBFlfU110hDpXFNY4nZhNPsSe
4LL/7hkYbF9Qk+0RqmNWgOH/+NKCjrvz6drbFIcK2pvvq7XaN/mgTtmXdv5sSwBO
hkSxEfAQzMwOUk78nwugNkxSR2mQB+lzxeTgYGR5JZWp+YQhB5IlVJYRs7V0P3vL
IQlNuWAt5n7Srdd76f2axWy5EFH7eTr8/9NccLlvaagrFewushlIbItO5qiUXMaz
cH/+45L57KQGtK9Eb905
=elsc
-----END PGP SIGNATURE-----

--=-T8ccUh7z8cL2R9M9teXP--

