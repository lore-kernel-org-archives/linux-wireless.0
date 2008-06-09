Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42305 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbYFISDZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 14:03:25 -0400
Subject: Re: [PATCH 1/7] mac80211: add helpers for frame control testing
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1213034059.5974.33.camel@brick> (sfid-20080609_195423_018122_29F9C06D)
References: <1212774671.6340.75.camel@brick>
	 (sfid-20080606_195944_782545_6A2B1449)  <1212997265.698.55.camel@johannes.berg>
	 <1213029086.5974.21.camel@brick>
	 (sfid-20080609_183129_796413_B211C17A)  <1213032085.22220.1.camel@johannes.berg>
	 <1213033412.5974.28.camel@brick>
	 (sfid-20080609_194341_412413_70F0E00E)  <1213033579.22220.8.camel@johannes.berg>
	 <1213034059.5974.33.camel@brick> (sfid-20080609_195423_018122_29F9C06D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0di5yX5U/HYQO4o9D9yX"
Date: Mon, 09 Jun 2008 20:02:50 +0200
Message-Id: <1213034570.22220.18.camel@johannes.berg> (sfid-20080609_200328_400585_C2B072F5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0di5yX5U/HYQO4o9D9yX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Well, the way the other functions of the same type:
>=20
> ieee80211_ctl_is_ack
> ieee80211_mgmt_is_beacon
>=20
> check not only that the ftype is exactly ctl/mgmt and that it is of
> stype ack/beacon.

Hah. Well, I think they should probably be named
ieee80211_is_ctl_ack/is_mgmt_beacon then, or just shorter
_is_ack/_is_beacon (since everybody knows ack are ctl and beacon are
mgmt.)

>   I chose ieee80211_data_has_qos because it checks
> the ftype _is_ data _and_ that it _has_ qos included.  I think my
> naming is more consistent with this.
>=20
> Do you still think it should be changed?

I think you're looking at the bits too much. If you look at 802.11-2007,
Table 7-1, you'll notice that all frames that have data ftype and the
"QoS bit" set in the subtype are actually data+qos frames, just with
extra functionality added onto them by the other stype bits.

Hence, I do think it should be changed, we're more interested in the
semantic meaning ("this is a data+QoS [possibly +stuff] frame") rather
than the bitwise meaning ("this is a data frame which has some QoS bit
set"). I guess the correct way would be to say "this is data frame which
has QoS information" which we'd have to express as "_is_data_has_qos" or
something, no?

johannes

--=-0di5yX5U/HYQO4o9D9yX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJITXBGAAoJEKVg1VMiehFYiJEP/R2hzet4/Ae1O+Z14RU+Cxbw
B0FRY6ybRHAB+l4u9wK6mOvOelzxaUXHMlF6a20Bmx1JRh8Xjk05pOGTse50PFTL
8k9j+Px2sJxo0HXFDLGULo2h+B6uV5w1N40ZlyfP4o/V0dxJlMwApP2nRod6Komh
opYdSsdrawN3+Ry+8IvpGNh+5toN3E3R3J/0OegrypYaKYhXAr/zQfeT53SESCDn
McXRNUOGLZs3PB8HSuzCWrH1Sht1ZwOdgbr/5LM6cXoLzWGOIxKILRL51yiobtaM
gmwxuCs0qRyBptXAMEv6krQaS3qN5NvQYaY7WQL/UAlJMQhSoTG/YLKrPVA13Y9N
1iMRScP4cXuaMhk3ihe5sWMtgKR0uHRiT64XnuXf+V+ZCIqSNNMC1LBqrIMxMKie
zrZiOu4OjEleW1bNz5hMBOuuoiSqZRi9yZP/7FnDJRypLHqu9oOwU8Y9Z2+GcyVu
guhJ5dBhGtELYKxf7L/p7TyiwvqSmuCYkNlhnzIFRfol2dEn2EbGAVif4DcF8KlD
2AxUFWEdB1yddUKJjh1AhC30Z34e1PfqAWII1KP4MbLmVaI+lp4ftsUQ+Fa3j5x+
Fya65SilAkUfhH7OPQnLKSUvWAv1VG7eir6WgOfWsgFt2HovHeG6osdsIszY0MNO
YBWjf8uomDSBQa4niM3C
=LGN0
-----END PGP SIGNATURE-----

--=-0di5yX5U/HYQO4o9D9yX--

