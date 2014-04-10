Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:2481 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965170AbaDJI00 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 04:26:26 -0400
Message-ID: <53465591.7000404@meshcoding.com> (sfid-20140410_102631_424377_8D97FB01)
Date: Thu, 10 Apr 2014 10:25:53 +0200
From: Antonio Quartulli <antonio@meshcoding.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, stefan.pietsch@lsexperts.de
Subject: Re: [PATCH 2/2] cfg80211: ignore invalid BSSIDs when looking for
 BSSes
References: <1397075965-2684-1-git-send-email-johannes@sipsolutions.net>	 <1397075965-2684-2-git-send-email-johannes@sipsolutions.net>	 <53464190.1030202@meshcoding.com> <1397116783.4757.4.camel@jlt4.sipsolutions.net>
In-Reply-To: <1397116783.4757.4.camel@jlt4.sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="X7g7Jlx3JlOPPbfSWiHExnBm4d5BUwJfe"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--X7g7Jlx3JlOPPbfSWiHExnBm4d5BUwJfe
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 10/04/14 09:59, Johannes Berg wrote:
> On Thu, 2014-04-10 at 09:00 +0200, Antonio Quartulli wrote:
>> On 09/04/14 22:39, Johannes Berg wrote:
>>> diff --git a/net/wireless/scan.c b/net/wireless/scan.c
>>> index 7d09a712cb1f..746c56ebd66c 100644
>>> --- a/net/wireless/scan.c
>>> +++ b/net/wireless/scan.c
>>> @@ -540,6 +540,8 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiph=
y *wiphy,
>>>  			continue;
>>>  		if (channel && bss->pub.channel !=3D channel)
>>>  			continue;
>>> +		if (!is_valid_ether_addr(bss->pub.bssid))
>>> +			continue;
>>
>> Wouldn't it be better to prevent such entry to end up in the bss list =
at
>> all? (i.e. filtering during the scan?)
>=20
> I thought about that, but I'm not so sure.
>=20
> On the one hand, that would make sense since it's unusable, on the othe=
r
> hand it could cause confusion if you don't see some other network that
> you expect to show up ...

I agree here.
Showing the network is reasonable because the user expects to see what's
around. Imagine a user that scans just to see which channel is less
crowded...

>=20
> And then again, if you can click the network in the UI and then it won'=
t
> connect to it, that also causes confusion. I'm not sure what the best
> way is ...
>=20

True. But here it's up to the UI to check the MAC and tell the user that
this is an invalid BSSID, no?

In the end I drop my original objection :)



Cheers,

--=20
Antonio Quartulli


--X7g7Jlx3JlOPPbfSWiHExnBm4d5BUwJfe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJTRlWUAAoJEEKTMo6mOh1Vw30P/j5xq5Tc3URBm98eFWsralPy
SSZ5elFHAfG+hznXeyxA0P7UxgmLzibIUm342qgsso80vT4rynI/DGPBzKVUBo96
/FNvLiMsQzDf7MLiLSHtx45W6dyMEQllPl6jhkZ7qHbKPTZIupoP8XSqVHYcS+JD
CFmhzIQN6iAtEDKGKTDzoTKdOnyjz2j6RSX8PIT+9x0bnJxc7tBputyqp5bHYl9f
JvBdWrkeEpGf0YQzKt8eqKijBIwmg7OGskTomZ7trdFvW8HdU6Fl4tYweufklSfe
22790voTYJETgdd2e4N6/dDEnv2eVRR4J12iv5PgBNYj/LAKyiinHI64svs7hSID
sIcVV4gxAl+CH6clbJuPI0/dv+pfJa9MBZsguL7crCXqMHd2v/nexA8Qf+otHAvU
esSbJgJlIZ4TzPNxEyAzuk5mrs9wyFE9lv4MIvzZwcQi1KQ3LdQd7yvOlepVyHZu
J4RRILUkAFNqyh2f07MG3phTRXUrrJXHQPtZg0m40Zh0gQs3kecmBwPLvAOUwTyL
alZb+HNGHBSpE8gfqniFCAFWQsrnP7ti5yM90WZO1pQom4Gfh1G1vBZ9ii1vCAY7
Lur223l9W3gqkctm9B12PgO011F1oW7ZXIoc5z35bzwM54Luc8y0jxpKO4ZJCEEx
9wSevuI+0B36YJd8fP0K
=MchB
-----END PGP SIGNATURE-----

--X7g7Jlx3JlOPPbfSWiHExnBm4d5BUwJfe--
