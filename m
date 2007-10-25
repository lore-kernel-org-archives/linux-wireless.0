Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54140 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbXJZKgN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 06:36:13 -0400
Subject: Multiple SSIDs on a single BSSID (was: Multiple SSID)
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: hostap@shmoo.com, linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <8704f27d0710100211j2addf0ddl86e9101af15daf09@mail.gmail.com>
References: <8704f27d0710100208y7a964b5aof60755b22adb7d14@mail.gmail.com>
	 <8704f27d0710100211j2addf0ddl86e9101af15daf09@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KEkzvRnsISwUufY9OFAW"
Date: Thu, 25 Oct 2007 21:25:57 +0200
Message-Id: <1193340357.4406.25.camel@johannes.berg> (sfid-20071026_113618_513803_6107D328)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KEkzvRnsISwUufY9OFAW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Some further thoughts on this if you want to work on it.

I think you misunderstood me, but I didn't put that right. mac80211
doesn't really need to support this, see below.

But let's discuss the starting point first; I'm thinking that multiple
SSIDs on the same BSSID are implemented by an AP by treating all
stations as belonging to the same BSS wrt. QoS, AID assignment etc.,
hiding the SSID in beacons and then keying off the SSID given in probe
requests and association requests to determine which network the station
wants to use. Different group keys can be used to separate the networks.

I'd be very interested in this as well because it would use the VLAN
interface code in mac80211 on the AP side so that I could test that at
the same time as client implementations.

=46rom the mac80211 perspective it is pretty trivial:
 - create a VLAN interface for each SSID
 - beacon with zero-length SSID
 - put stations into correct VLAN depending on the SSID they used in
   their association request frame

If you need help with the kernel side I'm certainly willing to give
advice and help.

It seems to me that the hostapd changes would essentially be:
 - allow having multiple SSIDs
 - keep some sort of SSID-structure for each BSS
 - assign stations to vlans depending on the SSID they used

I do not, however, know whether the internal hostapd structures
facilitate this let alone how to implement it.

johannes

--=-KEkzvRnsISwUufY9OFAW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyDtxKVg1VMiehFYAQKN0w//ey6MchfLG7qxVK4OgmCIpE6XcFP6wsU8
uynq3ncKGMpE7V2cGX4NKF5/dNGyHFj7GsHChgbDppNSm4XVy6waiKsiVf/l8Dkl
IEidNQsxjH18X09oYQiuP9ONM+b9Euaab0bHprqdveXrkqjOXxtISxdUY2tfOHbE
qYo5uit8zNjRUduU8clNbauA0qkl3gu/agbt3+iatfSk/akd4jyJjnL2dmWTYHwC
a7+rq+MocGZoPqOh+ODT4fmEKOuEvDIkkoqlVtVoDxjRPMTSiW6UtvKX3RCRlwjA
ipiw4n/iM0Y7JSDv/YYZmEcsOdmcOMcUhNzLWJ5QY8YZEkTJEaP5BTiE/k6EXncl
GJtmeyhUajj4UQkHotIQ9dqyyR91UD+6XEPO8BfrKWzne+/JqMbX9HTNDaYXnldg
9yJ701UdnK7kA6/mExyEPF9/oqrTvbDalOo0vdxOMfVjnW1C83Lu8M+rJf9+b2qj
YXndrTep9COi93sGQCWQq2aCTIpEp+atK7fjaxAfaYU8p0spVCTbYZA9QH7zwflG
zo49oIq026G8q2ohSOE5lr4WmGe21qQcA3m0v7l4dogZ8EbYYWytdN/5OKd4yz6i
UTQGdwOTq2RL7bqTIOZ69ccihOGVIE/RgIYHyR0NSv7/ltW2x6Q3vTBs+BE4pqE7
IV3hvYjJrQc=
=Axuk
-----END PGP SIGNATURE-----

--=-KEkzvRnsISwUufY9OFAW--

