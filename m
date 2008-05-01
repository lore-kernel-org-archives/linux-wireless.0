Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41123 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbYEAAfJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 20:35:09 -0400
Subject: Re: putting ieee80211_tx_control into skb->cb?
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Chr <chunkeey@web.de>, Michael Wu <flamingice@sourmilk.net>,
	Daniel Drake <dsd@gentoo.org>,
	Andrea Merello <andreamrl@tiscali.it>,
	Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <1209570457.18659.59.camel@johannes.berg> (sfid-20080430_174737_678263_D9A9E0B9)
References: <1209570457.18659.59.camel@johannes.berg>
	 (sfid-20080430_174737_678263_D9A9E0B9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rmq5X4ofECu7YO6CH0dw"
Date: Thu, 01 May 2008 02:34:23 +0200
Message-Id: <1209602063.7173.2.camel@johannes.berg> (sfid-20080501_023459_247577_A82C0B13)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rmq5X4ofECu7YO6CH0dw
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-04-30 at 17:47 +0200, Johannes Berg wrote:
> With my patch to shrink ieee80211_tx_control, I can now put that into
> skb->cb.
>=20
> Do we want to use that as the interface to drivers as well? Many drivers
> could benefit from that a lot since we could save all the extra copies
> done here.

Yes, we do.

Proof-of-concept code
here: =EF=BB=BFhttp://johannes.sipsolutions.net/patches/kernel/all/2008-05-=
01-00:32/041-mac80211-tx-info-skb-cb.patch

If you want to give it a try, beware! I changed a number of patches this
is based on, the GSO-fragmentation one is among them, so you really want
to pull all those from there rather than using the versions I posted.

Will have to update all the other drivers now (done b43 so far)... But
I'll let this simmer in my tree for a while and test with AP mode etc.,
I think we should do one thing at a time ;)

johannes

--=-rmq5X4ofECu7YO6CH0dw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBkQDqVg1VMiehFYAQIwiw/+JZ+j6dUz3vOAD6Zhk72w3HMEj/+raRCR
qcWofvoKlVFwrqPT6cIShm5by49n+8tS5JJ/pgzPEh8VFX6eh0OqPwkDAa7rWXio
ClYbXHcvI909zhc2QERQaFjUd9HUhkDiSxmnlZo64u4PKk8YeRBPgpDj5EKUanlM
N7wM1XxDcejTC6BuGp+80VDMAT5p72yrg/DR+hfDu1Cd4+KH4GhDLpi52imsqetN
QxxPYPLV8ZrrUyurvsrJfgtxPQH/geme64rMFpMcjOxzGcSGTBNW8ZzSq+r4lcVb
KdaJj/ojKGY5qWkpGiaWGmHzo6bUaRlWCf8DcX8HEQGfiUIaeVYJIvAtMeid0E69
n57x4qC3091wN4ZTuNLL5Adk7q66orCLHnsHrBRyrOF01OaHpDPbFDn6uR2D1zMV
h5Fi1+FtymRreE8lcnoYwf5CuTN9mw6Sbw76NWNLNfAQAqxx2QiUzx1blTQRprUR
ts+I77DIDYHYw4yviSsGLrghVGJq00DYsVO4AoYAfJGX0Z5XVF1Z8gPNlbU81ODK
700HPCASw4Ade1BOJ3MQxXOi8WtBdY1+H0XppSVuo9sj+7tRA2/n+X/Uk+B7Bygd
Mf0vYWKq6LZe3nY+gGYoQp/8CBIi/LfEcElqYsV2RhtmEzixoT9wZRJu+c8P1aXe
lpB2MyuwSKs=
=ukEr
-----END PGP SIGNATURE-----

--=-rmq5X4ofECu7YO6CH0dw--

