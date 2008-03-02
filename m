Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48741 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbYCBWMX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Mar 2008 17:12:23 -0500
Subject: Re: bughost-1583&1499
From: Johannes Berg <johannes@sipsolutions.net>
To: Bill Moss <bmoss@CLEMSON.EDU>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org
In-Reply-To: <47C9DA17.7000005@clemson.edu>
References: <47C983A6.8060502@clemson.edu>
	 <1204395671.3917.4.camel@johannes.berg>  <47C9DA17.7000005@clemson.edu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CwRh9+4TKz5jT9p+AygZ"
Date: Sun, 02 Mar 2008 23:12:07 +0100
Message-Id: <1204495927.3917.26.camel@johannes.berg> (sfid-20080302_221227_611082_A6565CD3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CwRh9+4TKz5jT9p+AygZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sat, 2008-03-01 at 17:35 -0500, Bill Moss wrote:
> I have pounded on your patch hard for both broadcast and hidden access=20
> points and its seems solid. I can't make it fail. After boot or iwl3945=20
> module reload, I run

Good, thanks, I'll respin without the extra loop and some cleanups. Or
actually, I should do that as a separate patch now that you've tested
it.

> For a broadcast access point, I rarely see the 'No scan results' output=20
> when running 'iwlist wlan0 scan'. For the hidden access point case, here=20
> are some results
>=20
> After module reload: 50 'No scan results' out of 50 scans
>=20
> After association/disassociation: 24 'No scan results' out of 50 scans
>=20
> Scanning while not associated is what NetworkManager does when it starts=20
> up and compares the scanned access point list with its stored list of=20
> acceptable access points. This is why I am interested in this bug. So=20
> far I am stumped. Any suggestions?

Hm, not really. You could create a monitor interface with iw
(git.sipsolutions.net), something like
# iw phydev wmaster0 interface add moni0 type monitor

and then capture on the master interface and see if there are any probe
responses. Also, can you test software scan for the second problem? If
it doesn't occur with software scan and you don't see any beacons/probe
responses on the monitor for those access points you're missing, then I
can't help you.

johannes

--=-CwRh9+4TKz5jT9p+AygZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8smNqVg1VMiehFYAQK11w/9GdBxwdJ4KD9Ph3FoLanF6q6No9nCpAOg
FObl9/NmrlVm0f2SgRgsPGbI25LJlSG6wJ91Z3ItR15S3+FxT49Qq+t+lPJtzmLq
fTiAGqeuQZ2HGCOSea0eNyujlfme0ixPFYPQF4E8RhcRS1jqH/Deqp2f1gYFi+ow
bJT4wOwgiXAKh/8L+0a5114Sf8WKKJY5t/h9bTNzo50QuJqiOYWtb3+v5BliSmOz
QoQ/3HgHlJWPLLfvEkQDV2CLeIXy2GNuGjkyviuRz26CiJ5z+ebv/131V9oJpAmX
XAytRILdBdFHzh3ueWusp9HvuIykLhLAYd1KHZx6OSpI/bGlqQTRizojyDrqQLm5
DFC+LriWO7Lmp+JF9ijyXt1IrnMvnq0X0Iaa84hdxnqxWY3aQj+4RaKugPw9MZU+
E69ZPNULoUpW6T8LaotE8Sy0HNnVxI8FsUZmnQaWTUJFKJwz8WZd9+weEhZe5PsA
PGuNpVuS93NBgBcRSAXP/ZDoOyE+xy/Rj+7DNepn4rxCoDdJxdSZRI1uGQ6cfxVu
wusF9oXPELcN2OZAiAXdrx6isO3kDIjExtGGHHG816lXZ/h8PMLfVbzx/0CnJOJK
JYTi+8pfj0buRZkvVDpkT/rtF4b764h0w5DdAa6N/1KR5I05jqEAVoMdmp6h+9k9
hOpJVTnHtDo=
=78Wa
-----END PGP SIGNATURE-----

--=-CwRh9+4TKz5jT9p+AygZ--

