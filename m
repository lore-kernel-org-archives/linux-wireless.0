Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34165 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbZGVKxc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 06:53:32 -0400
Subject: Re: lockdep complaint on tip + some pending patches
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890907211750s69420e47ma98b4c3214dfd1f1@mail.gmail.com>
References: <43e72e890907211750s69420e47ma98b4c3214dfd1f1@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MC1VqcP615AtiFc+WRqP"
Date: Wed, 22 Jul 2009 12:52:58 +0200
Message-Id: <1248259978.8124.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MC1VqcP615AtiFc+WRqP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-07-21 at 17:50 -0700, Luis R. Rodriguez wrote:
> While running on wireless-testing + netns pending patches + wow patches:
>=20
> wpa_supplicant -D wext -i wlan1 -c mosca.conf
>=20
> [  233.096916] phy0: device now idle
> [  233.114625] ADDRCONF(NETDEV_UP): wlan1: link is not ready
> [  234.116189] phy0: device no longer idle - scanning
> [  234.233767]
> [  234.233772] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [  234.233797] [ INFO: possible circular locking dependency detected ]
> [  234.233807] 2.6.31-rc3-wl #16
> [  234.233814] -------------------------------------------------------
> [  234.233824] wpa_supplicant/3089 is trying to acquire lock:
> [  234.233835]  (cfg80211_mutex){+.+.+.}, at: [<f83eb185>]
> cfg80211_get_dev_from_ifindex+0x15/0x80 [cfg80211]
> [  234.233887]
> [  234.233889] but task is already holding lock:
> [  234.233901]  (rtnl_mutex){+.+.+.}, at: [<c049de2f>] rtnl_lock+0xf/0x20
> [  234.233932]
> [  234.233934] which lock already depends on the new lock.
> [  234.233936]
> [  234.233957]
> [  234.233958] the existing dependency chain (in reverse order) is:
> [  234.233970]
> [  234.233972] -> #1 (rtnl_mutex){+.+.+.}:
> [  234.233996]        [<c0169b35>] __lock_acquire+0xba5/0x1020
> [  234.234014]        [<c016a06b>] lock_acquire+0xbb/0xe0
> [  234.234029]        [<c05838f4>] mutex_lock_nested+0x54/0x300
> [  234.234045]        [<c049de2f>] rtnl_lock+0xf/0x20
> [  234.234061]        [<f83f734a>] nl80211_send_reg_change_event+0x1aa/0x=
250 [cfg80211]

I think you're using the wrong genetlink netns patch.

johannes

--=-MC1VqcP615AtiFc+WRqP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKZu+FAAoJEODzc/N7+QmayNkQALdvrg1eaAaHO2lSAEY1ghnO
ZK5klxSqMpGNx2vzSWt0dxGpdS+M3LvTc2+oQ+HTxtO06xnhNdzspP7NX1/w9c+0
W/5SRW9mQxsBTjt3mVH/5cjrbLiwmGQq51pQ8xY2wd8g8CAd6fg1MlZacUHxEWAv
K7N5H0wOWom7XWmqOu7nEMZI5xrDyFJ3MT7Ps3xSJ0dh0iLpnqhAtRKlEDupx53h
r2xADU+gVcjdZpqwr3Wc+mZyHq3vJPDHdMaQ5rg4QJx2deOEBNVkX4GThoNpByUt
cMN12KGj527/Uwb314DVVIrvFH3N9YNH13LUYNgIfqqqs1fPtZBnDuHVejAOcaVn
0mAyK1vJnZzluBfUbYFcKRxY2Lgc36YQ+CqfUoGiSyfyCuzpNZe3BWdbFYH973aH
9VbxQ2p+KbKGB+XLuyoiALSIntSL7/qF5aqzPIAZHHMRKWqi6384UjFnxf6XgBlR
TmMYP3YmhKi8xWJXGhqDwqjKYP3Bsj6iV52uvxAd2owERbOCltS6sYCy035UWuWS
p+NFNXRnz6oS8e1m4s6shl9JM5LiE0a975Oc445VbLYMfa2h8InfCWff+PgwMkLi
irzFjqPUkukKnump2P0lFsSMrAeMFs3cMeuf5nBF9cdIZPXZXNyAFLNHO7V7DGut
sN5RqFFt/iC8ZlhEHDXA
=F2Cw
-----END PGP SIGNATURE-----

--=-MC1VqcP615AtiFc+WRqP--

