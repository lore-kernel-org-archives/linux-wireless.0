Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dev-nolb.cloudtrax.com ([54.203.245.161]:52867 "EHLO
	dev-nolb.cloudtrax.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933287AbaDJPyu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 11:54:50 -0400
Message-ID: <5346BEA7.9080006@open-mesh.com> (sfid-20140410_175500_901261_19B7040A)
Date: Thu, 10 Apr 2014 17:54:15 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Antonio Quartulli <antonio@meshcoding.com>
CC: b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org, Felix Fietkau <nbd@openwrt.org>
Subject: Re: [RFCv2 4/6] mac80211: minstrel - implement get_expected_throughput()
 API
References: <1396211704-4677-1-git-send-email-antonio@meshcoding.com>	 <1396211704-4677-5-git-send-email-antonio@meshcoding.com> <1396951502.5936.18.camel@jlt4.sipsolutions.net>
In-Reply-To: <1396951502.5936.18.camel@jlt4.sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7Q18qVlg1t5IdlkaW2GBD3eaHt8Hc1fJX"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7Q18qVlg1t5IdlkaW2GBD3eaHt8Hc1fJX
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 08/04/14 12:05, Johannes Berg wrote:
> On Sun, 2014-03-30 at 22:35 +0200, Antonio Quartulli wrote:
>=20
>> +static u32
>> +minstrel_get_expected_throughput(void *priv, void *priv_sta,
>> +				 struct ieee80211_supported_band *sband)
>> +{
>> +	struct minstrel_sta_info *mi =3D priv_sta;
>> +	int idx =3D mi->max_tp_rate[0];
>> +	u32 bitrate, ret;
>> +
>> +	bitrate =3D sband->bitrates[mi->r[idx].rix].bitrate;
>> +	ret =3D bitrate * MINSTREL_TRUNC(mi->r[idx].probability * 1000) / 10=
00;
>> +
>> +	return ret;
>=20
> You don't need a ret variable.

True.
thanks!


--=20
Antonio Quartulli


--7Q18qVlg1t5IdlkaW2GBD3eaHt8Hc1fJX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJTRr6rAAoJEEKTMo6mOh1V3GwP/jnYBnyIzxrIGXMaMU7hf4Ws
Pvi5y52Usqymbwm90TAZOVnLTClYSNGC4NBC3/D5h/vMdN7XUwTxlUGCnFxNhnWZ
i2N6VgRRtjaKBDPNjxSWMHS7kZq36QVPJOYqdgm0nrfxsR2f95d18p4A1FomVkRR
PHmRGVA6DfB/5jQaruE4AILHZqyfMppzZTOc5n60B6xdFrw4Xi/Fo/2s0ORPvxH5
6KDB5km9H8AJQG74w9+c9iRdRm8STH0cdeiVF/6BglGsA061pHHN+2c/xUMSZNgS
9Dq6VNuILFjNh54ojLq2hZErI3VcDswRQ9Ni2gBd7angq+OcgokUULQ0Y8RrRNx9
HqOL4ZD/QSVWSORbgH/MZGNSDRHlnKVwSdklIWi7rFa3zdayNW7AYxqpU3jZAcda
4uzM4dx/ByOrN7RXbnSC/hcnqWHlyv52BcaujzVrFd+KPE64fF/4Ng1PkhVJpuis
cYPqbEOUVemKCrWR2A89NhdZw7XS7TqxC9aNKWs9QBxeq4ebGXOlgXp5WY/uJpt3
TnAkTkNLMIoU/9COsmxAIDfWwJBR8OEQSWDfq5FoTrryObcRpIRzx+B59WzRqC51
y8i8Fo655WbDxngnvSYHxB0eFqnY9xrRGQpIzipbC3ZJ8HMV4YoYbq6fJqYQvvHL
K9OOkKiKP5D/Qezj+ykQ
=fCiM
-----END PGP SIGNATURE-----

--7Q18qVlg1t5IdlkaW2GBD3eaHt8Hc1fJX--
