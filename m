Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from element.ksp.sk ([158.195.16.154]:38801 "EHLO element.ksp.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbYGOGNg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 02:13:36 -0400
Message-ID: <487C4050.1010006@work.ksp.sk> (sfid-20080715_081340_011373_7C6CAC2D)
Date: Tue, 15 Jul 2008 08:14:40 +0200
From: Vladimir Koutny <vlado@work.ksp.sk>
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: Mattias Nissler <mattias.nissler@gmx.de>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: mac80211 : WARN at net/mac80211/rate.h:153
References: <20080714075010.GA3559@darkstar> <200807141614.51628.mb@bu3sch.de>	 <1216055849.4435.7.camel@localhost> <a8e1da0807142251p14324917w62d751bed5a56b92@mail.gmail.com>
In-Reply-To: <a8e1da0807142251p14324917w62d751bed5a56b92@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig886B8FAA33E5C957E04D6A94"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig886B8FAA33E5C957E04D6A94
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Dave Young wrote:
> On Tue, Jul 15, 2008 at 1:17 AM, Mattias Nissler <mattias.nissler@gmx.d=
e> wrote:
>> On Mon, 2008-07-14 at 16:14 +0200, Michael Buesch wrote:
>>> CCing PID guys.
>>> I've seen several people hitting this. What's the meaning of this war=
ning?
>> It basically means the rate control cannot find any rate in
>> local->hw.wiphy->bands[local->hw.conf.channel->band] that is supported=

>> by the sta in question. Normally this should not happen. I guess the
>> reason is that the supported rates bits in the sta info are all zero,
>> which would probably be a bug. I haven't seen this here, but I don't u=
se
>> the IBSS code either. To further investigate this, you could the
>> following just before the WARN_ON:


This has been solved already:

http://git.kernel.org/?p=3Dlinux/kernel/git/linville/wireless-testing.git=
;a=3Dcommitdiff;h=3Ddef5e9a210235d690e79ae660972792860568421

Vlado

>>
>> printk(KERN_DEBUG "supported rates bitmask: %08x\n",
>>        sta->supp_rates[sband->band]);
>=20
> Yes, as you said, I get:
>=20
> supported rates bitmask: 00000000
>=20
>> Mattias
>>
>>
>=20
>=20
>=20



--------------enig886B8FAA33E5C957E04D6A94
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iJwEAQECAAYFAkh8QFIACgkQutgEj9ZLuzT7yAP8CG+AX1qL1vLPFc0I41mUS9U2
QrRJqDm5Yu+oYC21UwaNzsepcAGCe0SFTuPqwSsjh2h1b8QdRtK+SHR2Mi0DFQ4L
1bZ1s7vVJHQPvKLzAbwRXNSgF0ZKJ5KtqA2KqE9AowpksZtABaScmX+JVdJ84C/B
N8RthrZtIbqyPz/smPs=
=m+4W
-----END PGP SIGNATURE-----

--------------enig886B8FAA33E5C957E04D6A94--
