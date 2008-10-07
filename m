Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37273 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbYJGUK3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 16:10:29 -0400
Subject: Re: [PATCH] iwlwifi: get rid of IWL_{GET,SET}_BITS crap
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Christoph Hellwig <hch@infradead.org>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240810071306sb282e06h9d29ea2c36f5c3d5@mail.gmail.com> (sfid-20081007_220641_767871_38DFEF2F)
References: <1223311803.15196.36.camel@johannes.berg>
	 <1ba2fa240810061135t24f2dfbv2a5eb0cd5d9e8cd7@mail.gmail.com>
	 <200810070821.56462.hs4233@mail.mn-solutions.de>
	 <20081007071529.GA5010@infradead.org> <20081007131615.GR3448@tuxdriver.com>
	 <1ba2fa240810070703j471faa30mce3678febf3c20e8@mail.gmail.com>
	 <1223398724.7328.45.camel@johannes.berg>
	 <1ba2fa240810071228m52a60861r5558529426b9b487@mail.gmail.com>
	 <1223408085.3618.2.camel@johannes.berg>
	 <1223408342.3618.7.camel@johannes.berg>
	 <1ba2fa240810071306sb282e06h9d29ea2c36f5c3d5@mail.gmail.com>
	 (sfid-20081007_220641_767871_38DFEF2F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jao1Zx3/UDNhpnz4pH1I"
Date: Tue, 07 Oct 2008 22:10:26 +0200
Message-Id: <1223410226.3618.13.camel@johannes.berg> (sfid-20081007_221033_680500_CF7C857B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jao1Zx3/UDNhpnz4pH1I
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-07 at 22:06 +0200, Tomas Winkler wrote:

> > bytes (with nibbles): | . | . | . | . | . | . || . | . | . | . | . | . =
|
> >                      | addr 1          |len1 || addr 2          |len2 |
> > your forced layout:   |               |                |               =
|
> > my layout:            |               |       ||               |       =
|
> >
> > Note how this actually matches the border between the border between th=
e
> > two descriptors, the || border.
>=20
> Your layout put addr2 (which is 32 bit) sits on 16 bit boundary

So? Yours makes it need two words, which is even less efficient to
access. And since the struct is packed, on those architectures that
don't do unaligned accesses efficiently won't need any put_unaligned
either.

Also, keep in mind that address 2 is _never_ used at all anyway because
we don't and cannot do fragmented frames due to the lack of IP
checksumming in hardware, as I and davem have tried to explain to you
multiple times already.

johannes

--=-jao1Zx3/UDNhpnz4pH1I
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI68IvAAoJEKVg1VMiehFYMrEQAKqB+iZGxWyJ5Lyk57zs2F6b
daxigFBKceQQrC4Rpn6YOG6ihlexGMPHbPw4h4h9wpwdNh6FT7gUGQKmpvMe22u5
DR/TVExRGGNNNMvgjMckfNbTzItosrQffejl7BBsCJr52AXOQFj50iRUvnsjk4HO
vGtHghOsZbwfTlFQFD7kC5DZAPfzguhjpV6O3qvdyvq0epZD89UupS/GxUDFP4Ik
/JKorIi09mAntRwYxv6iD4FvjheaUVgF41VI87V+x/eiopBqVrv90hbT6RrlAqWG
LJe7S/sdhPuJk5veKq0GcCL57J0ezFZNm0JJBhoGVdsi9ZpjiinFAV0VQ0NyjFPP
PEaRJRhOCfVo4e8Uwhv/33jzImSG/m/POu28aT7FyyMPEGAsyaPRKUrtVYVxti+X
bGRIbwgvhAcCF84rjhwKc9PjalTTPcvh8zQcdqY6YkdZYBMMnFBUWrHBL2k7xCEE
zQYBtDl+i2Jj8J7c2w+ViVHZ+N5S0VDHMljMLDM28/baHXJUTqRzd7zp/YFwoaY/
wtW8Ye+KU2TEQZ+AxGwNgrpcvuXyCGNApbsi/Ih0qO7bhW43bVKsqtwMDb6Dk8p1
5kmsBPZxQ6aGdDVrpnaE7VzqRrJOl8ut/+eFuYkk8sOaVdJ7GWFWqcFyzup/gIL3
IIX1fDA348N5u7wa0Vm5
=7a77
-----END PGP SIGNATURE-----

--=-jao1Zx3/UDNhpnz4pH1I--

