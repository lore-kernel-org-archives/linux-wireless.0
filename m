Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dev-nolb.cloudtrax.com ([54.203.245.161]:54447 "EHLO
	dev-nolb.cloudtrax.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaDYPsd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 11:48:33 -0400
Message-ID: <535A839F.2020805@open-mesh.com> (sfid-20140425_175206_112495_4742E196)
Date: Fri, 25 Apr 2014 17:47:43 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org, Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 5/7] mac80211: minstrel - implement get_expected_throughput()
 API
References: <1397484205-20905-1-git-send-email-antonio@meshcoding.com>	 <1397484205-20905-5-git-send-email-antonio@meshcoding.com> <1398440774.4152.28.camel@jlt4.sipsolutions.net>
In-Reply-To: <1398440774.4152.28.camel@jlt4.sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3joObwGqKdsg3f71mkCoNgd64nt294gq8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3joObwGqKdsg3f71mkCoNgd64nt294gq8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 25/04/14 17:46, Johannes Berg wrote:
> On Mon, 2014-04-14 at 16:03 +0200, Antonio Quartulli wrote:
>> From: Antonio Quartulli <antonio@open-mesh.com>
>>
>> Cc: Felix Fietkau <nbd@openwrt.org>
>> Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
>> ---
>>  net/mac80211/rc80211_minstrel.c | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_mi=
nstrel.c
>> index 26fd94f..cd40bc0 100644
>> --- a/net/mac80211/rc80211_minstrel.c
>> +++ b/net/mac80211/rc80211_minstrel.c
>> @@ -657,6 +657,18 @@ minstrel_free(void *priv)
>>  	kfree(priv);
>>  }
>> =20
>> +static u32
>> +minstrel_get_expected_throughput(void *priv, void *priv_sta,
>> +				 struct ieee80211_supported_band *sband)
>> +{
>> +	struct minstrel_sta_info *mi =3D priv_sta;
>> +	int idx =3D mi->max_tp_rate[0];
>> +	u32 bitrate, ret;
>> +
>> +	bitrate =3D sband->bitrates[mi->r[idx].rix].bitrate;
>> +	return bitrate * MINSTREL_TRUNC(mi->r[idx].probability * 1000) / 100=
;
>=20
> /100? didn't you say minstrel already used your units?

MinstrelHT does, Minstrel does not...

Cheers,

--=20
Antonio Quartulli


--3joObwGqKdsg3f71mkCoNgd64nt294gq8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJTWoOjAAoJEEKTMo6mOh1Vs8AP/AwJoL3E32XilT8KqETWr/aX
P5nsQxZCTppTteu4bd1bOjmgfZsuTjTWTXJZm0X63iKLpCZl7xDLmJlM99FGkZGv
Zt/d0XnEmg/mMb0TR4i9/B6yZVaW+68iiCOKbZmRc9I9pmL/lJeakaP9Y9kYBaQZ
7Lp8YsO3TxJioXGtoVD5JwBkXUslaF+cc6Rao5VvO4k4mKf7T+gK9KF7rMkhuJc6
AR3bhcqhfUvTIlimMrL2KDcHw3rD/EgiKswtTdSeC3GwAUay7U72igSp7GklXci9
xrjnN12BPKnsRquOlJckR774sAWfb5OPR4zNUtA5VDAiojFmvsQzYmjgvVD0k0tX
GyTdd62TBmSCGTm9VzRS9DQ04GQXFhDwUa0zTcm4kVxuiyn2mHTVre6MwK0ZADPL
GENxVrsGScuOZOS8nH0254TyLy6Hm2xcG+SK7yIzKbR6GrYcWo+z6cdpcHAQ1jUT
TIRdokx+fhywaEWhKx5+JnpApiljrb6FkZapSHwSI6agOqWaxKuHAiAZhCNCIC2Q
WDj1IdZQUMnj/wqtBuBzg+iBzL30YqTylxzDnEl6x5CppSJo2+nAvwwua7MUk7Bz
9PJ1MypdJ9vcp0mbao01N6BZjc1vgAhxHbxdnxGwz6YMJBuc8TSDc1FLMINctN3K
lc6i2UbKPBlgF7BzqtJ3
=hsAy
-----END PGP SIGNATURE-----

--3joObwGqKdsg3f71mkCoNgd64nt294gq8--
