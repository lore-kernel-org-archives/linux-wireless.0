Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39859 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbYI1HrP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2008 03:47:15 -0400
Subject: Re: scheduling while atomic: iwl3945 in mmotm 2008-09-23-11-27
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org, flamingice@sourmilk.net,
	Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <48DE8EC9.80306@gmail.com> (sfid-20080927_215201_348716_1480E298)
References: <48DE8EC9.80306@gmail.com>
	 (sfid-20080927_215201_348716_1480E298)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/wYwXLRSEG7P7fErVV/Q"
Date: Sun, 28 Sep 2008 09:47:09 +0200
Message-Id: <1222588029.3798.77.camel@johannes.berg> (sfid-20080928_094723_068131_55A4B203)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/wYwXLRSEG7P7fErVV/Q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-09-27 at 21:51 +0200, Jiri Slaby wrote:

> BUG: scheduling while atomic: iwl3945/0/1154/0x00000002

>  [<ffffffff80257315>] synchronize_rcu+0x35/0x40

>  [<ffffffff80551d17>] sta_info_destroy+0x47/0x110
>  [<ffffffff80559156>] ieee80211_set_disassoc+0x146/0x250
>  [<ffffffff805593d5>] ieee80211_sta_req_auth+0x85/0x90
>  [<ffffffff8055b156>] ieee80211_notify_mac+0x56/0xa0
>  [<ffffffffa0054663>] iwl3945_bg_alive_start+0x2f3/0x360 [iwl3945]

> I don't know who is responsible here. Maybe ieee80211_notify_mac? Citing:
> "It is illegal to block while in an RCU read-side critical section." from
> rcu_read_lock comments, but synchronize_rcu() in __ieee80211_key_todo()
> sleeps and few mutexes are locked and might_sleep() invoked on the path t=
oo.

Yup, for sure.

This is a combination of various things, when ieee80211_notify_mac was
added ieee80211_sta_req_auth didn't destroy the sta info, later they
fixed a different bug that started doing that and we all missed that it
was called from here...

We can fix this by using RTNL locking instead, not sure though that'll
work because I don't know how iwl3945 calls this, I'll let Tomas deal
with it.

johannes

--=-/wYwXLRSEG7P7fErVV/Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI3zZ6AAoJEKVg1VMiehFYqFAP/iWwzM9oHXi5IocwKyCXH6A2
RqBaUiS5BjNMRBF1R70+x+j46AQqkbK9S+kA+sWUO84jCct+skJ83ucjke4T9bea
Q63+DHbLSlPijhJlsrNULx1Gbsg59WQgLwmSyK7UvTSdUe4+VbFDcmvzx1rFKBzD
W5n69V/e4ln5mw/A8u8wYGdTUpikWO2uliBs8oeBDvZFr2ucU9OwH+fztmfV+aXa
G9CjUE7Aie4HVcKHmXRjB2zCqiVg0RdfLBYH7OTwSkj5OM+3vMmdiVIw4Ww2O2pL
ROGpBTmDexF0kya2sLU5J6oWVn5SQPC/Zkyg0tABtDOYi+QJqqVOE7E+4ZEJOZWU
mY4SCoyIZfdShRK5zSNRPPgQhCbI2NAyb/eIJ/IxiDDY/4tMUDgIhKKSsOARxqoP
TXgXrf2YDxETlYxbB8HktVeJFboRxWwuCuLO5wvbEPVsyzB6PKmE6nk1xGVxBmxQ
F9Vn8oAyBk3pL4JOdYcnJVSKXcDALSRm0zibG9UyyeweNDBTks7JoxFEh8v+SyMW
0+TADSeKXWXgmGvMnKBf/5Pc5ToV8nTvP87IF3S6xE0Lxth/HMI0zTLAzJyHN8Ud
yzwXBQ7Rv/GBFJyA82SxqvwTVC1qlPtOui7Rmkp9/ZXBJoYbuQPKfI/EscJ2esK6
QGIq72AOZevCqjOFsWMf
=NsAy
-----END PGP SIGNATURE-----

--=-/wYwXLRSEG7P7fErVV/Q--

