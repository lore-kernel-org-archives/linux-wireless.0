Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55161 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbZGYJNv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 05:13:51 -0400
Subject: Re: new lockdep warning in 2.6.31-rc3-wl
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <1248461132.1216.53.camel@rc-desk>
References: <1248461132.1216.53.camel@rc-desk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1V/28I2585j5Bea3WiAe"
Date: Sat, 25 Jul 2009 11:13:51 +0200
Message-Id: <1248513231.32151.60.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1V/28I2585j5Bea3WiAe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Reinette, Luis,

It's easy to see why this is happening, but I have no easy fix.

> [   65.053694] phy0/3223 is trying to acquire lock:
> [   65.053738]  (cfg80211_mutex){+.+.+.}, at: [<ffffffffa01c9a72>] regula=
tory_hint_11d+0x32/0x430 [cfg80211]
> [   65.053887]=20
> [   65.053888] but task is already holding lock:
> [   65.053968]  (&ifmgd->mtx){+.+.+.}, at: [<ffffffffa0220f78>] ieee80211=
_sta_work+0x118/0x11c0 [mac80211]

Clearly, ifmgd->mtx has to be taken from a bunch of cfg80211 calls, but=20
all calls from cfg80211 into mac80211 hold the cfg80211_mutex.

Now the problem here is that regulatory_hint_11d takes the
cfg80211_mutex.

I looked at two possible solutions:

1) Remove the requirement to hold cfg80211_mutex in cfg80211 for this
   function. This is my preferred solution, since I don't think a hint
   function should have strange locking constraints. However, the
   function accesses a whole bunch of global variables and right now I
   don't see how to reduce that, except possibly by allocating and
   queueing new work struct, but then I don't see how to cancel that
   work struct when the wiphy is unregistered while it might be pending.

2) Move the regulatory_hint_11d call outside the ifmgd->mtx locked
   section. This isn't nice, as it means we require more effort from the
   callers. Also, I think it's not sufficient, because mac80211 has to
   cancel_work_sync() the sta work, which would be calling this, when an
   interface is taken down --- BUT taking down an interface can happen,
   when it's simply removed with nl80211 (!), within cfg80211 context,
   and as such again under the lock, which has the same problem.

3) Remove the regulatory_hint_11d function (or rather make it not
   exported), and instead pass the country IE (or the whole beacon
   frame) to regulatory_hint_found_beacon(), and process it all from the
   regulatory work that hint_found_beacon queues. That also reduces the
   number of entry points from drivers, and means that if the driver
   uses cfg80211-based scanning, it also automatically takes part in the
   regulatory infrastructure. Win.

Obviously 3) is my favourite solution, not only because it's the only
one that seems feasible at all, but it's somewhat more complex, and I
don't really have time to do that today.

johannes

--=-1V/28I2585j5Bea3WiAe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKaszMAAoJEODzc/N7+QmaIQsP/3ysdqVODlMnJQ79xnbAYtfO
waQISa3jUtBCivxoNVR16o5tGGSKZsXOYUqNFGXMK4Ik9K9k4shuh0JQMDU848/A
3sDrEtbXV8MVOyY9labnD+HefGwe4C8HHfw/Byy6nwVa77Hd0xzTN0EUcz7aGDf8
xQ+hmoqpKOXclH6n0QtE0X2Zc7GFOkNovR9jerIxqe5UAv7vKukDDv2QfxupqDWA
nrbcKJZ4c/jdnm8S/I1H3N/6oKxxrcGI3DUv2RDYDZ6CoqchY/khBd12HR0Tepoh
w6RfYq4NY5KeBL6fX7RgXZ2pZqOS8dMcMyDW6O5MDt56Bx1N6du0zGzqVWsocLB7
9DaawyVVdhewizbnIa1V53WxV64BsufbqVszxaGgeHGrShemZM98ZZJFFTR6C0op
nzoC/1G8MEquc1kjmu3fe9BswnzCtcGYrNWog37fNgV4Ni04ejxZlHfKFidp9kBp
qGJEyQv4Evi+OjPenKZJoxK4aErCBG6UKe/njyehZyYuVI/m6MrXx+FOouSD/rEu
28oylz+yfHb7AKMPSeKBd2VAdrk9+r/T2Mw8HdmKUggvBufCOnhpA27Knvjj73d9
y7G19sZgHFktjIDJPUOD+WeVBS356bIiYupYtEErtPjQSckZ3jCOikXS/bPX1pyp
KNLDPQEKLHrWp55H2Yni
=DnhQ
-----END PGP SIGNATURE-----

--=-1V/28I2585j5Bea3WiAe--

