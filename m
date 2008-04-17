Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34086 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763098AbYDQQi6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 12:38:58 -0400
Subject: Re: mac80211 hardware encryption
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Tomas Winkler <tomasw@gmail.com>, linux-wireless@vger.kernel.org,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <200804151717.54920.IvDoorn@gmail.com> (sfid-20080415_161442_807626_6BB3493B)
References: <200804051931.58895.IvDoorn@gmail.com>
	 <200804142307.48550.IvDoorn@gmail.com>
	 <1208255742.3502.5.camel@johannes.berg>
	 <200804151717.54920.IvDoorn@gmail.com>
	 (sfid-20080415_161442_807626_6BB3493B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-R4GGfXCTSX3pspn1oQvb"
Date: Thu, 17 Apr 2008 12:14:39 +0200
Message-Id: <1208427279.4066.14.camel@johannes.berg> (sfid-20080417_174311_986857_FF778D3C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-R4GGfXCTSX3pspn1oQvb
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-04-15 at 17:17 +0200, Ivo van Doorn wrote:

> > In any case, for the problem at hand, I wouldn't mind increasing
> > hw_key_idx to a u16 all the way through, or pass the key_conf pointer
> > instead.
>=20
> I'll create a patch that changes it to the key_conf pointer then,
> that sounds like the safest option to allow changes to key_conf later.

That'll also solve your problem of having to know the algorithm, and b43
might benefit of that too, I think it currently keeps a table for the
algorithms.

One thing to keep in mind that you'll want to document clearly: the
key_conf pointer there will only be valid until ops->tx() returns, so
you must not access it (e.g. via the tx control copy you need to make
for tx status) outside of the tx() routine unless you want to somehow
make sure it isn't removed while in use (which is possible [1] since
set_key() may sleep.)

Hence, if you defer ops->tx() to some workqueue or something, you need
to copy out all the data you need from the key_conf beforehand.

Tomas: was it you who mentioned we should remove tx_control from
tx_status and just require copying the fields we need? If so, did you
ever look into that?

> Note that this change (either adding the key_conf pointer or the hw_key_i=
dx to u16)
> will cause ieee80211_tx_control to exceed the 48 bytes. So that will make=
 it
> harder to move it into the skb->cb array later.

I just had a look, we could make the rate pointers index into the rate
array instead which would make them go from 24=EF=BB=BF bytes (12 on 32-bit=
) to
3 bytes (we only need a u8 index.)

johannes

[1] using creative bit-locking in hw_key_idx.

--=-R4GGfXCTSX3pspn1oQvb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAcjDqVg1VMiehFYAQJpWw//bOzqhI93Ip8ObSxwQtJtjVti9RAduoNh
dxhcCML0RCi8/q+RNEhELVV78dfu4pGxdHjAi/JfQw/VSjJUua5HTlLdJ3y1f0RV
hx8iSPmSbiBNiwfK6tneRP5GY3SuvQmgu0HK4yzyKoPZvIZoFCvp+9ZNlN6MIEyb
FjEHPwDzp8oJHZAkOlpOcKgbBAgWBK6VWmSdKwY7NSLt148pyTnMHtxd5ZhabrYL
PbH0n0MLXJVffSVnDheWjrNscxCXQlb/KwHaOL6Tka9FtffHS0c7572sLwU9WzA+
dyBlNR/jLYUpTYzJtE817zn4zv2PrOiKmsWx9dJeritemsggIteyoYNbgwYrMfWA
hLk3l9Ff58u2+R2vOzNSwATTCBu2AhWEidB4jOetgyKQM632x4ypcyGkW7MAeL2p
xMLlmpfm9R6r6Q1IMZpLJEV2VvVL+04ZH65DiIBvwur3t9U4N3PNtCGoBQes1+co
eNAvqYGmH+lO4utr9M2untawc3jzxPQwAZJ78mYzLtIm/waGuKQx9XBomXVfcSNs
CEcLvcScaCLyUtJN4FWLRzTlHNNVTMavth8RagB2ryPNp+lTnYJrJmOyPDZSlrxA
4cvuSNJ3BbURpVk+qGq3Zblf5caNRYOLXqS8vlV1oqhC1zFdoQsMTgsddGoJNPvH
ChhNy2bnc6o=
=jJin
-----END PGP SIGNATURE-----

--=-R4GGfXCTSX3pspn1oQvb--

