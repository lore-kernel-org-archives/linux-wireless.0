Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42681 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587AbYJXJyf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 05:54:35 -0400
Subject: Re: [RFC] mac80211 rx filter in mesh mode, rt2x00 mesh point
	operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org, ivdoorn@gmail.com
In-Reply-To: <445f43ac0810231507l790332b9h2c05e95aa0212392@mail.gmail.com> (sfid-20081024_000742_626566_B9F0B044)
References: <4900f16b.0b0c360a.2bc3.ffffa11a@mx.google.com>
	 <445f43ac0810231507l790332b9h2c05e95aa0212392@mail.gmail.com>
	 (sfid-20081024_000742_626566_B9F0B044)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KAZCCXe7H0A6wMgHfZMx"
Date: Fri, 24 Oct 2008 11:02:01 +0200
Message-Id: <1224838921.6002.98.camel@johannes.berg> (sfid-20081024_115444_269414_2DD9A1C1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KAZCCXe7H0A6wMgHfZMx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Javier,

On Thu, 2008-10-23 at 15:07 -0700, Javier Cardona wrote:
> Mesh frames have 4 addresses and no BSSID, so BSSID filtering should
> be disabled (i.e. FIF_OTHER_BSS should be set).

The BSSID is zeroed, right?

> The ALL_MULTI flag is also needed for mesh mode because an
> intermediate node has to forward multicast traffic for addresses that
> it may not be listening to.
>=20
> But promiscuous mode is not necessary:  mesh points don't need to
> receive unicast frames not addressed=C2=B9 to them.  Furthermore, enablin=
g
> promiscuous mode normally disables acknowledgments, which are needed
> for proper mesh operation.
>=20
> So my recommendation would be to configure the RX filter in mesh mode
> to be ( FIF_ALLMULTI | FIF_OTHER_BSS )

I agree, mesh really has no concept of a BSS so it shouldn't try to
filter on the BSSID.

johannes

--=-KAZCCXe7H0A6wMgHfZMx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJAY8FAAoJEKVg1VMiehFYFcgQAIhKqtd73JeJhpKrAjGH4ysv
T5HdpV7GkwoeoWrt9kAATv/WoLW4BlpAjRscPc1iEdCqJiIvP0yBbBLwl4F4+udw
x3SHe5QC8MIZiT/T3WZn5Zm1evLrpEZ8+u/txkTbEHiQyf9h4Hg1PeV/lbovW2Ih
FebQhPeaqHZaiIKTJ5v6bZq3um08wnhUA7rOxxuGXkuyRDXvLEDKjDElW0rHHHOl
AgqONg9lvzjA1RR0TLgfq5RymqSAGI9lIR9BPvcTpcbsfsf6hsHuALf6kXJr8Vyl
5BeIDupLL5QcyWR6aP2+gx08kSw7BqYsjyZwfBqqXIix6oqsiB2sjQy+NNXTxC9e
4U9osLrpkXHRQsg1y7ipLM3Tij8kSzey0bq8OKHY9RZkKEKmB+OcFGJg39YCo3jg
npIzhKw7Oj+JNQtAmJ6owpQwQLKBtviizMu+a7wgtE4ml8mez2530WNLAa1bnoZz
E+guTHkI0H/skWdnaXVkm8cb6AmDzhjv0//JpTZ5Cx2fAH435nF+MOJ2m5U92PZN
Vc3MKacFk5yoSQ5Ui0EJPl8whl4o/kpUD4aLMnwMss5igR4hqxolT+6iKg9p5bc9
Tum5yzCrvIxHrgxielrWxzcZO6+XdWkGrpPuuPMYNyE96xMTYiQddILDk3Ztg8ZU
AYGo+2IgxEubQV6+WXfL
=inr1
-----END PGP SIGNATURE-----

--=-KAZCCXe7H0A6wMgHfZMx--

