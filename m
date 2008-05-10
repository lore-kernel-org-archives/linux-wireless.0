Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45486 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbYEJVUf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 17:20:35 -0400
Subject: Re: [PATCH 4/5] rt2x00: Convert rt2x00 to read control info from
	skb->cb
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200805101351.11467.IvDoorn@gmail.com> (sfid-20080510_141040_628124_2BF61C9B)
References: <200805101349.19481.IvDoorn@gmail.com>
	 <200805101351.11467.IvDoorn@gmail.com>
	 (sfid-20080510_141040_628124_2BF61C9B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EMsKJdLpKFBDMP4OjyM5"
Date: Sat, 10 May 2008 23:20:12 +0200
Message-Id: <1210454412.12837.16.camel@johannes.berg> (sfid-20080510_232041_658710_085E1C19)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EMsKJdLpKFBDMP4OjyM5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	/*
> +	 * Don't automatically kick the beacon queue.
> +	 */
> +	tx_info->flags &=3D ~IEEE80211_TX_CTL_READY_FOR_TX;
> =20
>  	/*
>  	 * Fill in skb descriptor
>  	 */
>  	skbdesc =3D get_skb_frame_desc(skb);
>  	memset(skbdesc, 0, sizeof(*skbdesc));
> -	skbdesc->flags |=3D FRAME_DESC_DRIVER_GENERATED;

Could you live w/o that change? I'm pondering removing that flag again
since it doesn't have any meaning any more with the fragmentation/busy
reschedule rewrite I'll do.

johannes

--=-EMsKJdLpKFBDMP4OjyM5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCYRi6Vg1VMiehFYAQLYlw//Sft3nl7yvN/eODL+FrZbIpuwN9J6abT4
lmyjcjYO93Tw68+9U9dXp9wYgiFBIHJ6uDDQYZh6Ae4Y2qPk3VEcx/oEsWAPCMbF
2Hb83ZJJeks4gmJFAebieKSLOYw4kN3C1khRCyTPH/PVXTC1iy+flk8xK7TN7txS
ZmFu7izZv1NxEBTo0lAwD47FaMo2X1ggLquejxcqupp5Azw3c9qeDVqIMjHFBXnt
LaNNq4THKdhQtCMOTd+NqEHvjjuriW8AcJ9C1mgjlHXkdAq8Us2A8KDfLdXRkVwj
fJ654B9RykBnJXz1laFf0T5Aga587dO25+hBCT1fKPqlzvcA2AB0hZMWN9VYEuCi
jiHu6DNJZqHmD2SwOp6DtRv4wTOcI/uRrDiFJwDhHLbdmNzAjT+26I17Eg7X64Fg
cGKMdsPvAzGDfnWXnHbbHFzt6/fAm5fqp9Rf8uI07Lkgl/YNpUqWXRHOwYQADjVm
1wlxxlhFedT3tTeRGqjhsNVNHQShwdMpj6AABhCTBpD+j7nFtZGSFMKBiQKTiNHg
gIVxqQiopKnllj8tEvX6fkpc0fF6KQMOIzmHi5d3aNkOoYTmpzbfRc+3VVOJWe8b
K0QQBOUuCCSWB+ErMbnikeBhoRhVFEO3NLM9p+n0uj2OAMZkHwoS+kuTgpJyiTmz
RDj86mYTzXc=
=38Ky
-----END PGP SIGNATURE-----

--=-EMsKJdLpKFBDMP4OjyM5--

