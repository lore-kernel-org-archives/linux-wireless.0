Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dev-nolb.cloudtrax.com ([54.203.245.161]:52876 "EHLO
	dev-nolb.cloudtrax.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804AbaDJQDd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 12:03:33 -0400
Message-ID: <5346C0B3.4050704@open-mesh.com> (sfid-20140410_180341_309355_9889B532)
Date: Thu, 10 Apr 2014 18:02:59 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org
Subject: Re: [RFCv2 6/6] cfg80211: implement cfg80211_get_station cfg80211
 API
References: <1396211704-4677-1-git-send-email-antonio@meshcoding.com>	 <1396211704-4677-7-git-send-email-antonio@meshcoding.com> <1396951582.5936.20.camel@jlt4.sipsolutions.net>
In-Reply-To: <1396951582.5936.20.camel@jlt4.sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ccBXlIt2soEErnVWhD91DO3kuBhL2Ught"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ccBXlIt2soEErnVWhD91DO3kuBhL2Ught
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 08/04/14 12:06, Johannes Berg wrote:
> On Sun, 2014-03-30 at 22:35 +0200, Antonio Quartulli wrote:
>=20
>>  /**
>> + * cfg80211_get_station - retrieve information about a given station
>> + * @dev: the device where the station is supposed to be connected to
>> + * @mac_addr: the mac address of the station of interest
>> + * @sinfo: pointer to the structure to fill with the information
>> + *
>> + * Returns 0 on success or a negative error code otherwise.
>> + */
>> +int cfg80211_get_station(struct net_device *dev, u8 *mac_addr,
>> +			 struct station_info *sinfo);
>=20
> mac_addr should be const

True

>=20
> Any thoughts about clearing/filling/partially filling *sinfo when
> returning an error?

At the moment this function relies on what rdev_get_station() does and I
always assumed that in case of error the content of *sinfo should be
considered "undefined".

An option can be to set the object to 0 in case of error, but is it
really needed?

Any other change should be applied to rdev->ops->get_station(), not
here. I.e. fill the object as much as possible and never return an error
- just flag what was filled.


Cheers,

--=20
Antonio Quartulli


--ccBXlIt2soEErnVWhD91DO3kuBhL2Ught
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJTRsC3AAoJEEKTMo6mOh1VfasP/0FF7jc/MRcjgPhQjYtF6Z/P
Gxv6wOOGt/yDmpUAh139WA1D9aSOLJFw5XU+4i3ksSN0rCeu0EcWl02Lpd6Re2h1
NsMAC/oBKUVJKnQlOFYmLY62TCNT/Zt7yziPRTaOT2tAPHd4C98WzUoWvZksFCk7
Vik358bMCv3vwuDiFXqoUEEjLYIDXz61/0FTQfQh/TClszcJ4ark0pZM6vn5sx+y
FQdfPf2idJn29vDj0jyPpyZP+C5vwTjCc0mv9KFl/bxjmTLFKiXhRnFSowzTKa5g
uzBiuOz8LA0IZt+xOuMVP8GNh4OMc7XsorryRS6pPwfXsArq6V6CaAfgz67UmpzF
lbEoCpEjOIphO/o2wMO6sBJkqeFPhYdRw/WQJNaqZvCun29O5yJ+BlHCZowt2i1T
0/Aumngrz5SDttrwhvpkKFnlLtcOhAriq0YyEkZvYzjkIXP4tXR9nxp31Ps6ZXYc
1iAsAgEuxITLKV/amgDrkb7yfUFTMbPnbJDBKYoKkHmgl47Bz7TD5+xdBdgcnvnK
cexMEpqyuGrMqdu3Pr3pl3fxFPEKgLR1+PAcvCOTz0+twNSCpb+sayeQfgU8L9Vu
pGLn5xXXtULhfu0EgA1Z3ZViBZKof0DFomcgiwhkff7kV8kgQT6j5DAQ0aKO3zhX
/ZjRXzuGYtEQF1zdAwRH
=1RFW
-----END PGP SIGNATURE-----

--ccBXlIt2soEErnVWhD91DO3kuBhL2Ught--
