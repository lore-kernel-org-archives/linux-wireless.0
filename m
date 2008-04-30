Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from element.ksp.sk ([158.195.16.154]:32827 "EHLO element.ksp.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758673AbYD3PD2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 11:03:28 -0400
Message-ID: <48188A3D.70707@work.ksp.sk> (sfid-20080430_170336_690520_C7C278E3)
Date: Wed, 30 Apr 2008 17:03:25 +0200
From: Vladimir Koutny <vlado@work.ksp.sk>
MIME-Version: 1.0
To: bruno randolf <bruno@thinktube.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] WARNING: at net/mac80211/ieee80211_rate.h:159 rate_lowest_index()
References: <48174652.6080909@work.ksp.sk> <200804292042.20500.bruno@thinktube.com>
In-Reply-To: <200804292042.20500.bruno@thinktube.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig47058CE88F5C9DD75DE1961D"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig47058CE88F5C9DD75DE1961D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

>> [...]
>>
>> The question is how sta->supp_rates should be initialized:
>>
>> - we could initialize it to our sta's rates, but then we could
>>   probably transmit to a station at unsupported rate
>=20
> isn't this what is done right now, and the rateset is zero sometimes an=
d then=20
> we get the warning?

Yes, kind-of. It is initialized to the rateset of an ibss we are part of,=

which is the one of ibss we are joining to, or our supported rateset if w=
e
create a new one. However, it is 0 before one of those 2 actions happen, =
and
then we get the warning.

> this might be wrong anyways: as you said it could make us send frames a=
t an=20
> unsupported rate.

Actually, this can happen even now:
- we join an g-ibss, thus setting the rateset to 1-54
- we receive a data frame from a b-only station -> we assign all 1-54 rat=
es to it
- we send something to this station
Probably not a big issue, as a) we will update the sta-rateset on its bea=
con,
and b) I would expect that such an ibss would adapt to 1-11 only in the
presence of b-only station..

>=20
>> - add new ibss station only on received beacon, not on a data frame;
>>   currently, beacons are ignored for this purpose (they just update
>>   the bss list later on)
>=20
> i think stations should be added on reception of both beacons and data =
frames.

Or, do we need this information _before_ joining/creating a new ibss?
Couldn't we just ignore all STAs around until we have a reason not to?

>=20
>> - something else (like 1Mbps only)?
>=20
> what about the rate of the currently received data frame (and maybe any=
 other=20
> rates we could safely deduce from that)?

Yes, that would be a reasonable option - providing that we have the rate
(which we should - there is a WARN_ON(1) in rx-path if it is not set corr=
ectly)

As I think about that, I would suggest:
- no sta info is being collected prior to join/create
- sta entry is added/updated on each beacon with reported rateset
- sta entry is added/updated on data frames with just the received-rate

Vlado

>=20
> bruno


--------------enig47058CE88F5C9DD75DE1961D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQCVAwUBSBiKPbrYBI/WS7s0AQL9cgP+KPrbhi9tmkskEIH2PpBitzUMOKfStzq4
4tQzAB7dU0KIoYjGwzDa6pLLhylHMLuYWSmhy8MXhHu8Zk+gH2tV0XydkxLCxdAD
mnkmZVgwtULyfRN+KbcAAUG3iblXra9UW4atHJxkYNSO5XQVDKwpZZRBrOw2q6N4
3SWPOy/s1gU=
=Jiza
-----END PGP SIGNATURE-----

--------------enig47058CE88F5C9DD75DE1961D--
