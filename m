Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dev-nolb.cloudtrax.com ([54.203.245.161]:52969 "EHLO
	dev-nolb.cloudtrax.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbaDKLb1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2014 07:31:27 -0400
Message-ID: <5347D26C.6020002@open-mesh.com> (sfid-20140411_133154_844930_2988EDEB)
Date: Fri, 11 Apr 2014 13:30:52 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org
Subject: Re: [RFCv2 2/6] mac80211: add new RC API to retrieve expected throughput
References: <1396211704-4677-1-git-send-email-antonio@meshcoding.com>		 <1396211704-4677-3-git-send-email-antonio@meshcoding.com>	 <1396951464.5936.17.camel@jlt4.sipsolutions.net>	 <5346BE8A.5080601@open-mesh.com> <1397150096.4757.24.camel@jlt4.sipsolutions.net>
In-Reply-To: <1397150096.4757.24.camel@jlt4.sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="siGolMumFnsVlocEQJfwu7bLnWlGJILDN"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--siGolMumFnsVlocEQJfwu7bLnWlGJILDN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 10/04/14 19:14, Johannes Berg wrote:
> On Thu, 2014-04-10 at 17:53 +0200, Antonio Quartulli wrote:
>>
>> On 08/04/14 12:04, Johannes Berg wrote:
>>> On Sun, 2014-03-30 at 22:35 +0200, Antonio Quartulli wrote:
>>>
>>>> +	u32 (*get_expected_throughput)(void *priv, void *priv_sta,
>>>> +				       struct ieee80211_supported_band *sband);
>>>
>>> why would that need an sband argument?
>>>
>>
>> I needed this because I saw it is required by some RC algo (only
>> minstrel) to extract the bitrate starting from the index.
>>
>> You can check patch 4/6 for this:
>>
>> +	bitrate =3D sband->bitrates[mi->r[idx].rix].bitrate;
>>
>> maybe I can extract it from another structure? I couldn't find any way=
=2E.
>=20
> Bit strange that the algorithm doesn't have the band, if it has an
> index? but I guess I didn't check all the patches...

I just rechecked, and it looked to me that all the other functions in
Minstreal (non-HT) take the sband as argument.

It is not stored anywhere and therefore it has to be passed as argument
to this new API as well..

A general beautification might be applied to rate_control_ops (and not
only)...but it is out of the scope of this patchset :)

Cheers,


--=20
Antonio Quartulli


--siGolMumFnsVlocEQJfwu7bLnWlGJILDN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJTR9JwAAoJEEKTMo6mOh1VpOwP/15JZO+qqMz7DiAMseFILIOo
1MfWcTkqE/cCQQzA1iau75BVMInKGebJ00ds48n1nFCdn0EZJRuN0qP9j+VLnUer
f+gegINWu371c7TUlHJW/b/hPtR0pdIBNTKwLakruGaG21nDA4LI03dRMUCJ+UvE
j2vhR60nr3V1PPSzy77yHNW20iX+ovJRCzRHVhNw/fhsKuadFOOyBNgata1CJqqa
7ydwTXgRPUgGq7xLNT+AN54df6RJwEqRio6F/Q3hvUQPMmngF4Tq03VEy9jw1WVi
6dFOtoQvuzhLFodew4ePp0nX1khip6WHmbuYOBDfx7JQ5AUJspoQbl4ymGljQ0YN
PiU3pISVuId96UOY5Ma+RLuQAgKfLUR1vEdo/KMUaOGO7TRvM9wysEzd0J5tInys
yNE707Q9B4TTF5E7Zg7+OaRFYL3LdVavpH2PT61Fmeno2MMwB/jm8uKUma5RtwGu
T4yN5fZ80iDjVVJ01bkjqBfoDTX+hs4awpAe+qS3NKiTvtESYyqSRariv3wh7OEX
xDE6uOGhJn+Ec1DPENIqDzHMWHHY4m+vu3/asnhsw6fXAvapaU/ecXVuUjV9cgvK
dhX1mpLSa1X5d0o4hXZLLp/6Z8pPKtETU3VOVv5Re+UuFl1cbflxMY0DPpFyuZ2h
tPx6cy7ip7GvnfLNcUKM
=E1sJ
-----END PGP SIGNATURE-----

--siGolMumFnsVlocEQJfwu7bLnWlGJILDN--
