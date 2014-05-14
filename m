Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dev-nolb.cloudtrax.com ([54.203.245.161]:56432 "EHLO
	dev-nolb.cloudtrax.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbaENV3E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 17:29:04 -0400
Message-ID: <5373DFDA.800@open-mesh.com> (sfid-20140514_232908_156768_29F255D2)
Date: Wed, 14 May 2014 23:27:54 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Antonio Quartulli <antonio@meshcoding.com>
CC: b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org
Subject: Re: [PATCH 1/7] cfg80211: export expected throughput through get_station()
References: <1397484205-20905-1-git-send-email-antonio@meshcoding.com> <1398440652.4152.25.camel@jlt4.sipsolutions.net>
In-Reply-To: <1398440652.4152.25.camel@jlt4.sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Af7KlnqGHtRUAhmOr5lvF5XMNMnGea4sN"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Af7KlnqGHtRUAhmOr5lvF5XMNMnGea4sN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 25/04/14 17:44, Johannes Berg wrote:
> On Mon, 2014-04-14 at 16:03 +0200, Antonio Quartulli wrote:
>> From: Antonio Quartulli <antonio@open-mesh.com>
>>
>> Users may need information about the expected throughput
>=20
> I think this "expected throughput" should be a bit clarified.
>=20
> Are you talking about "expected PHY rate" or rather "expected (payload)=

> throughput"?

It is not payload throughput because in this "number" we also consider
the bytes being part of the 802.11 Header. Maybe we can call it
"expected MAC throughput" ?


>=20
>> towards a given peer computed by the RC algorithm.
>> Export such value in Mbps/100 through the get_station() API.
>=20
> "units of 10Kbps" might be a better description :-)
>=20
>> This unit has been chosen because it is the same of the
>> throughput returned by MinstrelHT.
>=20
> Since it's unlikely we'll ever reach the limit of a u32, maybe just
> multiply by 10 to get the nicer Kbps?

At least we are safe in the near future :) Ok, I can change it to Kbps
because it seems that a lot of people will be happier :)

>=20
>> + * @expected_throughput: expected throughput in Mbps/100 reported by =
the RC
>> + *	algorithm towards this station. The unit of this value has been ch=
osen
>> + *	because it is the same of the throughput returned by MinstrelHT
>=20
> I think the rationale shouldn't be here now.
>=20

I think I will just remove the last sentence.


Thanks a lot!

--=20
Antonio Quartulli


--Af7KlnqGHtRUAhmOr5lvF5XMNMnGea4sN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJTc9/eAAoJEEKTMo6mOh1V2ScP/1HVQEhjlJCs+A28RR3vgqJm
FwOZU4eUKR4c7kOHkI48Rl0f4IwbfKyrPpbxkTXq90FRoF0EsNSMv2pwz0D1lDU4
5SpZbhblRSsPMTS8QgOVKYI/wF+0Qq2Q3gmUUGSWsgCx8zJSFHkmobYMTMLZS7nZ
VreCmU8dvv7g1GYSMZXbb8ALdqCsnNeMhGmqUl2IeTU3K3tE9+wnbpAL+f2aPb3S
CBFTLZ3Yf/TgGpjxm2wXujbR8FTDXxNol2PvzW3BRQ0Gju1M2ytVFNKYrc2gW9Tp
v8c7sKXxtvm4DOrfoOPUHhESDSutPKtviPT4kiKXqnw42RZnVWTAK6Sqm4aNqnLf
B8Dls5lfwMdaAwT++DiZ8SnIVy1B7laqp4XLVvFDJiFWBiR8v5+TqnhICQu5ExPa
WAYefEH2K7sr3DeGTdS0vL4dycTFe2YAXhqxrjG0lHUqcwhP1ie8imw4FI/k5F1+
5eOoye93yyOVrMFDbAMCBoV26wlwUuObjMV1gYnFvJXoo7pDNb/1Jgxc8HVBxI6t
5gsdgvWMX0Im99X7+TalME/GMse/VdK+J527C6DU448Yfex+BZDEH7Qqf1vjprGu
ygRiqa/rdSAPx01Vnkwfo7pOa8VBpy4/lfr38vva0WbEjfJ5yqt7/uESZsjjfNQ9
conaJ5G2Z0Fvr3eCzEvg
=QVsi
-----END PGP SIGNATURE-----

--Af7KlnqGHtRUAhmOr5lvF5XMNMnGea4sN--
