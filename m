Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dev-nolb.cloudtrax.com ([54.203.245.161]:43893 "EHLO
	dev-nolb.cloudtrax.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261AbaAUQIZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 11:08:25 -0500
Message-ID: <52DE9B30.3000505@open-mesh.com> (sfid-20140121_170828_599926_E2574B93)
Date: Tue, 21 Jan 2014 17:07:12 +0100
From: Antonio Quartulli <antonio@open-mesh.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Antonio Quartulli <antonio@meshcoding.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 5/5] cfg80211: implement cfg80211_get_station
References: <1390302591-3352-1-git-send-email-antonio@meshcoding.com>	 <1390302591-3352-6-git-send-email-antonio@meshcoding.com> <1390320181.6199.64.camel@jlt4.sipsolutions.net>
In-Reply-To: <1390320181.6199.64.camel@jlt4.sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PuCOVILNDI42uRqftKEsDWLX1VjCKSMXb"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PuCOVILNDI42uRqftKEsDWLX1VjCKSMXb
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 21/01/14 17:03, Johannes Berg wrote:
> On Tue, 2014-01-21 at 12:09 +0100, Antonio Quartulli wrote:
>=20
>> +++ b/net/wireless/nl80211.c
>> @@ -3780,6 +3780,28 @@ static int nl80211_get_station(struct sk_buff *=
skb, struct genl_info *info)
>>  	return genlmsg_reply(msg, info);
>>  }
>> =20
>> +int cfg80211_get_station(struct net_device *dev, const u8 *mac_addr,
>> +			 struct station_info *sinfo)
>=20
> Not sure nl80211.c is the best place for this?

mh true, I saw other cfg80211_* function in there..but they are all
NL80211 related. :)

I think util.c is a better place.

>=20
>> +{
>> +	struct cfg80211_registered_device *rdev;
>> +	struct wireless_dev *wdev;
>> +	int err;
>> +
>> +	wdev =3D dev->ieee80211_ptr;
>> +	if (!wdev)
>> +		return -EOPNOTSUPP;
>> +
>> +	rdev =3D wiphy_to_dev(wdev->wiphy);
>> +	if (!rdev->ops->get_station)
>> +		return -EOPNOTSUPP;
>> +
>> +	err =3D rdev_get_station(rdev, dev, mac_addr, sinfo);
>> +	if (err)
>> +		return err;
>> +
>> +	return 0;
>=20
> Those "err" variable checks and whatever are just pointless -- this is
> really just
> return rdev_get_station(...)

agreed!

>=20
>> +}
>=20
> Consider exporting it if you actually want to use your new function. :)=


agreed=C2=B2!!


Thanks!


--=20
Antonio Quartulli


--PuCOVILNDI42uRqftKEsDWLX1VjCKSMXb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS3ps0AAoJEEKTMo6mOh1VqOkP/iZi+HRYhkyTMS/nZCENOjuS
80RlTkSZMlwQc1vTDkEnUoJj53c3v77sSlmlnCg+nzTTcu21rJxo0qopDs10DTod
6mB0OgVDtKGiEN2lr4zpTLJ00xLT6zcILkaFyhsSL4bOlNXORST2sv33w3xX40yk
nXYWUc7fpsGjMgkcGaqQb6B6K+DwOh3UUHEml+5WT2vWTzXjpzTlr0mj2n4cwh1I
Aa4n+x88Yyvbbld9bqZPYXab0yBqJhzLTx1170qnTkMxOCCdQaBqgJCIVjyDIoTM
+RPAk2NtYs+Um3UYRmewcsxuj31phDITUG1iH7KkgbE0eMObQ/MEPOF2BgLDPdhG
o0u/qpbBb5Yaa+OjVWdyrIkGJlEwVzt/MIBhyYDtCsABH9Z5j3FeFaT1MTWzf81e
jqqSy35LQvJc099CeaD0BdFGnE81qg0RL1XaMQHFqeVgX161B4uKZllnoPqe0hgJ
pFuZnxP4SSoA1awWopThFuqasaKy8501fYudGjChFqLEBKxP9jg53ZDK6+s7oN1a
UGkaH2TVsDRbIK492InrcPIPQyeXyOsRwToMNDr1wjCVXog6rGOKNCKUNPStxxpx
1UMwhckYIqqXDoeC3vc99osRHbCnpnKg/0HPOu3OLSWcU/ZIfaKqBjE3bH0TiAkf
IEouylKuvq68rcIKJgxg
=T9Ac
-----END PGP SIGNATURE-----

--PuCOVILNDI42uRqftKEsDWLX1VjCKSMXb--
