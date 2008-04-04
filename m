Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48499 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbYDDOzM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 10:55:12 -0400
Subject: Re: mac80211 MLME scanning - BSS list trouble
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	Javier Cardona <javier@cozybit.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	Bill Moss <bmoss@CLEMSON.EDU>, Daniel Drake <dsd@gentoo.org>,
	Dan Williams <dcbw@redhat.com>, Vladimir Koutny <vlado@ksp.sk>,
	Tomas Winkler <tomasw@gmail.com>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <20080403164330.GH2025@jm.kir.nu>
References: <1206865999.22530.187.camel@johannes.berg>
	 <20080331150423.GQ14333@jm.kir.nu> <1207055773.5143.91.camel@johannes.berg>
	 <20080403164330.GH2025@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dbzkFGgtPtK/y3e/J1DL"
Date: Fri, 04 Apr 2008 16:55:01 +0200
Message-Id: <1207320901.19189.40.camel@johannes.berg> (sfid-20080404_155517_240628_5CC71B96)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dbzkFGgtPtK/y3e/J1DL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> The Beacon frames would probably need to update all <BSSID,*> entries
> for the fields that we decide need to be updated based on Beacons, not
> just the <BSSID,"">... Alternatively, we could change the BSS table to
> have just one entry for each BSSID and a list of SSID entries for each
> BSSID (with SSID, WPA/RSN IE, Privacy flag, etc. from ProbeResp). This
> would be internal to kernel, though, and the scan result would likely
> need to continue showing these as separate "BSSes" even though they have
> the same BSSID.

Oh. Good point. Any comments on Bill Moss's patch though? At least for
the time being that seems like a reasonable thing to do.

> Yeah.. Well, the problem is that no one has asked (as far as I know) for
> this for a real world use case after multi-BSS support was added. Sure,
> this would be nice for testing purposes, but the changes needed for
> multi-SSID support are somewhat complex and would not only require quite
> a bit of work now, but also make long term maintenance take more
> effort..
>=20
> I'm not completely against doing this, but this is not exactly on top of
> my to-do list ;-).

Right, makes sense :)

johannes

--=-dbzkFGgtPtK/y3e/J1DL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/ZBRKVg1VMiehFYAQLkqxAAtrif3PFcclgdqEvxMCvXaHh9AZ3YTZLR
nhd2cxF2uIfgn6quObOUD5QSz5bRMOlQDwKSdNBIbRP8FXBvIhKZfO7BR0uT6fdy
ckZwLrFfVXgxydPXOFq6O1BCR5+Weuth/X2sCudfTNjvzxClGXHHZRrEY6SZ/p9s
0jtnh8o6PGc9L7nBeFJkqrNc1A/LelTbjNdb4HqoKQxyQreOkmJ8UCPfCxiD5Z99
I3wNiYy4SGb0aIJAjnt6j5+GQyb1lpRYKg2ieldYMkS8e9wI6oIwAlwvL7Lc2WR3
UNlgh2JWi3E8PUMa7adrP48811UJSF4Kqhv1ARGQO1v59Pbyms/KtAlALP2v3aAw
CjCWepjyBd7+iLSvAVsqWUP/LJr04RFYMMHvoZuR3UDsJQ8E5N+Xx9FmA0Dua5or
B869o7RXcTnsCXwqBqkRnmRWekVd+PxjbgURfb1OH0M2AKSS9g207IWIXVfyt0SX
vq8Ipr8zBOARgujLh5zdYCQSyag1F/DzS1tx4GJoAaFm4RmqHcGeWJLrARa/s1aQ
N1uVrcwh/PaoxZkym8EZ85x0Erf7GDDA3Tbkp8Y0B12xhMP/Ln4Q5NJqNqTHcDKV
Y3I+ePz5oYoFxJUS36lCqcwo5+uMmdv3HRWnsSQn76LQkU51IM+BsmmMAcrJwqfM
5nq6flbYybE=
=p0WC
-----END PGP SIGNATURE-----

--=-dbzkFGgtPtK/y3e/J1DL--

