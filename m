Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55370 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760582AbYBVQe4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 11:34:56 -0500
Subject: Re: [PATCH 00/13 v2] o11s: mesh interface support for mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
In-Reply-To: <1203693709.7082.35.camel@johannes.berg> (sfid-20080222_152202_419952_859BF240)
References: <47be76f9.03b48c0a.025f.54f4@mx.google.com>
	 (sfid-20080222_071727_691746_9DC8AC76)  <1203693709.7082.35.camel@johannes.berg>
	 (sfid-20080222_152202_419952_859BF240)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8DKXezGvpjFEEuFglrFU"
Date: Fri, 22 Feb 2008 17:34:49 +0100
Message-Id: <1203698089.7082.79.camel@johannes.berg> (sfid-20080222_163541_170610_46CD369C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8DKXezGvpjFEEuFglrFU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Luis, thanks for your patience with me.

> >  - We now support mesh network in scan. The part interacting with wext =
is a bit
> >    ugly but works well. I just read the mail from Johannes with a diffe=
rent
> >    approach and will consider it.
>=20
> I'll take a look here too.

Looks ok to me, if it works in userspace. Adding custom items to wext is
always fine and a new mode is ok with me, overloading the SSID is the
only sane thing to do.

> > The pid rate control algorithm has been modified to provide an estimate=
d
> > transmission error, probability, necessary for the airtime link metric,=
 and a to
> > call mesh_peer_link_broken() if it detects a sta is no longer reachable=
.
>=20
> Interesting. Would like to get Stefano's input on that.

Looks ok to me too, though it should be documented.

I think you're right and we should apply this to wireless-testing and
fix the remaining problems there. I can then rebase my last 9 patches
(including the sta info work) on top of that and we'll see where it
conflicts.

johannes

--=-8DKXezGvpjFEEuFglrFU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR775qKVg1VMiehFYAQKzTxAAloJ00HyhwvG5sDLn0xrGP161DjfCLigg
eNqxsIHLGin/cBHr+8lv9wjqv9FsJmF52LDNleyGT5pXkR+KJ1R0ubrW9PPizxou
tiV6jEuoFqxKMrIl3IeXwByzKsgJRJv7FVcQ2b//QZMi0V9wNyW3MZI3nbqgaZEs
AXxw5ozDN2GmECd/xjN9TmQW+l2KcFAyGyBBdSwV1+YSfIXVrK4O2i5XXuA2ojnh
b3MebJXTpEKUQc4QHc878sMylzmEd6m/Zd3PxlfEf5wuyhdEmGnoGG3gVyghX1t5
lFa7MQSe8WxdyOpiciHKtP1YRMrsCp9gfNgODAbSsIaB4iBAkusBCUvoWc8q7t5r
zNGeWoNzs7Giw4YQNkJD9Gjd6qYcq/DB2cZKcX/j7Z8Y9Jo2Gq/d6wqK7KU9ZCD8
CEtRn/jYwCKolezS8USBE0jwe3yvL9rLiQEam8MQSgqxfPiY/np4ptVCaV3L6EsU
SRre1UYSntlWfbvAmGZ1I37sOkA9xEbuivkeA0Z1GYpaH5l3sWShF7PdpT03h/yY
6hMM4FF2MFX5SRUqPfRKDV4pY4ElABpgA8Nnw8FqtBqtY5rYYmO4FrI9tSSrAL14
4/2dUvZRx7AX5YvCCollFmyHjgh0dInWWWSPsEUAtqMNsrDg/pEEmKm1RYTZM2am
fC7U86KU2nI=
=frTQ
-----END PGP SIGNATURE-----

--=-8DKXezGvpjFEEuFglrFU--

