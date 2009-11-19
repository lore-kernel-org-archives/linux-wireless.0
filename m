Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32804 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbZKSO34 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 09:29:56 -0500
Subject: Re: mac80211 breaks suspend to disk
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1258638183.5063.4.camel@maxim-laptop>
References: <1258568836.4512.13.camel@maxim-laptop>
	 <20091118202802.GE2911@tuxdriver.com>
	 <1258576749.8018.7.camel@maxim-laptop>
	 <1258578199.30511.80.camel@johannes.local>
	 <1258579170.4525.2.camel@maxim-laptop>
	 <1258579261.30511.84.camel@johannes.local>
	 <1258638183.5063.4.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QPqoFILT+yLqXbxzOLF8"
Date: Thu, 19 Nov 2009 15:29:59 +0100
Message-ID: <1258640999.7094.19.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QPqoFILT+yLqXbxzOLF8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-11-19 at 15:43 +0200, Maxim Levitsky wrote:

> This problem definitely is fixed.

Thanks for checking.

> One more finding from the hibernate loop though:
>=20
> Nov 19 12:25:49 maxim-laptop NetworkManager: <info>  (wlan0): deactivatin=
g device (reason: 37).
> Nov 19 12:25:49 maxim-laptop NetworkManager: <info>  (wlan0): canceled DH=
CP transaction, dhcp client pid 6130
> Nov 19 12:25:49 maxim-laptop kernel: [  239.925841] wlan0: disassociating=
 from 00:1b:9e:d8:77:02 by local choice (reason=3D3)
> Nov 19 12:25:49 maxim-laptop kernel: [  239.940401] phy0: Removed STA 00:=
1b:9e:d8:77:02
> Nov 19 12:25:49 maxim-laptop kernel: [  239.982746] phy0: Destroyed STA 0=
0:1b:9e:d8:77:02
> Nov 19 12:25:49 maxim-laptop NetworkManager: <WARN>  check_one_route(): (=
wlan0) error -34 returned from rtnl_route_del(): Sucess#012
> Nov 19 12:25:49 maxim-laptop NetworkManager: <info>  (wlan0): cleaning up=
...
> Nov 19 12:25:49 maxim-laptop NetworkManager: <info>  (wlan0): taking down=
 device.
> Nov 19 12:25:49 maxim-laptop avahi-daemon[1626]: Withdrawing address reco=
rd for 10.1.0.2 on wlan0.
> Nov 19 12:25:49 maxim-laptop avahi-daemon[1626]: Leaving mDNS multicast g=
roup on interface wlan0.IPv4 with address 10.1.0.2.
> Nov 19 12:25:49 maxim-laptop kernel: [  239.998665] wlan0: deauthenticati=
ng from 00:1b:9e:d8:77:02 by local choice (reason=3D3)
> Nov 19 12:25:49 maxim-laptop kernel: [  240.072664] phy0: device now idle
> Nov 19 12:25:49 maxim-laptop kernel: [  240.105115] ------------[ cut her=
e ]------------
> Nov 19 12:25:49 maxim-laptop avahi-daemon[1626]: Interface wlan0.IPv4 no =
longer relevant for mDNS.
> Nov 19 12:25:49 maxim-laptop kernel: [  240.120021] WARNING: at /home/max=
im/software/kernel/linux-2.6/net/wireless/core.c:618 wdev_cleanup_work+0xe9=
/0x110 [cfg80211]()

You're using 3945 it seems, this kind of warning happens when it doesn't
do the scan notifications properly. I'd look at 3945 for this one.

> Other that that, I got few freezes, this time with no feedback whatsoever=
, blank screen, thus very likely something different.
> Might be nvidia proprietary driver fault too.

Fun.

johannes

--=-QPqoFILT+yLqXbxzOLF8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLBVZjAAoJEODzc/N7+QmavwgP/2vG/ejTGp1PvOU+RZWW9Rkb
dr96YApBAhnLP/qBYSB2fAMhCnxNOJkKeEmocc/P1+yjn1yTHB97vZhelwQstfc1
UHN9Px2yko5kkAY1gZMriiPMOdke+C+ywrjcadTxQ3ljyvlh2tGtEVUBq9IVDmAY
cASAdDKVACtyxzupbwrQm9mZKwIbaAMgoK2GMctBGM7BisWMeeFXxJqTuWSoJ2NH
0rB/ixCwbpK7kZQAa6+EYyPzcU6dCT2Z6rAU3XmoxE24X5RUBi7XqS9V2LJFiXTo
LEi/k47OqZdTuNOzXnq1fM/wUryoCvsptUcNKwlM8S12obZELu879jZcVkKKDX6d
OvO0a7UzvzNKcJIAvAvp472YNA04pMMKSxiA++tkfUgTyUhTJ54/PAbKCcu++CAR
wCK1SL4y9z0cmuO2n/4Mr2F3oPnC3UyFbxH6mhUODuGDt6DNOawDsoeQmOFn0toj
uqrykresrcp5jIN8/3OTFXLB2EPKXVKGhgA0ZL8EBPLuVlHkh1oICk2o3Nytjgvk
2J1515VDWPn+LLG0Exa2FeVz81b0mtb2/fC2nzMAmvY0b5QI3TA7R1uTZurw3Tyx
yMokQQQZ04a4jLIVCCbilwXGA0Ayr9PvpEm0bYf0LOSU++hMQNfjEJ5Ls2AvXcop
b661j6hN7FhgVzfKstDy
=xSIL
-----END PGP SIGNATURE-----

--=-QPqoFILT+yLqXbxzOLF8--

