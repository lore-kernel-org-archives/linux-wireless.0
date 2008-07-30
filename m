Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52617 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962AbYG3NwS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 09:52:18 -0400
Subject: Re: AP association timeout bugzilla PR?
From: Johannes Berg <johannes@sipsolutions.net>
To: Jack Howarth <howarth@bromo.msbb.uc.edu>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <20080730132846.GA10959@bromo.msbb.uc.edu>
References: <20080728172722.GA26893@bromo.msbb.uc.edu>
	 <1217266609.15381.4.camel@johannes.berg>
	 <20080730001012.GA2046@bromo.msbb.uc.edu>
	 <1217402210.10489.81.camel@johannes.berg>
	 <20080730132846.GA10959@bromo.msbb.uc.edu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TH2C9U+BQzmcsBSySeKI"
Date: Wed, 30 Jul 2008 15:52:14 +0200
Message-Id: <1217425934.10489.128.camel@johannes.berg> (sfid-20080730_155228_630578_32E53A24)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TH2C9U+BQzmcsBSySeKI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-30 at 09:28 -0400, Jack Howarth wrote:

> Jul 30 08:19:39 localhost kernel: =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> Jul 30 08:19:39 localhost kernel: [ INFO: possible recursive locking dete=
cted ]
> Jul 30 08:19:39 localhost kernel: 2.6.27-0.186.rc1.fc9.x86_64 #1
> Jul 30 08:19:39 localhost kernel: ---------------------------------------=
------
> Jul 30 08:19:39 localhost kernel: ath9k/1379 is trying to acquire lock:
> Jul 30 08:19:39 localhost kernel: (_xmit_IEEE80211#2){-...}, at: [<ffffff=
ffa00f5
> c46>] ieee80211_scan_completed+0x142/0x2e2 [mac80211]
> Jul 30 08:19:39 localhost kernel:
> Jul 30 08:19:39 localhost kernel: but task is already holding lock:
> Jul 30 08:19:39 localhost kernel: (_xmit_IEEE80211#2){-...}, at: [<ffffff=
ffa00f5
> c46>] ieee80211_scan_completed+0x142/0x2e2 [mac80211]

I think that's the false positive due to the tx mq changes that people
were talking about all the time. Please ignore.

> Is this a known issue or perhaps due to may skb->cb patch for ath9k?

Yeah it's a known issue, nothing with your patch, except for the PAE
placement your patch is fine. And I don't understand that part of ath9k,
it shouldn't need to look at that but rather ask the RC algorithm to do
that job.

johannes

--=-TH2C9U+BQzmcsBSySeKI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIkHIJAAoJEKVg1VMiehFYuUoP/2Bo89FSlAtPdc+0kc2Ahd23
hzzIxsy3L8oI0qAmDBaQhmlmWv6t0aPLzKGFmq5cguky7McO3w5cWECI7+PJNwBI
j1THEpDPFiq7z9ETYf5Xr6aC9nFt/ELBsbl6SiZaODmxL9F2i4oxdIPPyMECyTeL
CwkPRF9GVs3fVc0+L6D90LSpUoioZPGzXkZ89XcQFOAgKSTcA0aFD227KxoJsyPX
+ucs6bF6Lp87+GFQa8AaQOsOUkep9HwSnpfgWiFbAWj2xVBYG4966peOtd0r3tjM
2I6yo2zwneEvYNYt/v7Eq2kow9uyajzMD6L7C8vc0yOTsf+3z1NtJKtcVq2413yS
H57bR8w4mpJDieOjJkzmX7lRZD720137JvHf7tlzHXb7TpvtCVf5VwSOAhoR8A0b
vENDiGSzjJg8xwOADZeFaIqn1Zx1q0ZkG2VABXjjmu1fdtBffYOXHcv702KD4t2W
HRRzKETtdYgvbzPjUQthnRH7LWblWinKA2M4kitkC9UJJIHbXNv+6PsaUYKOE0XW
CQ8tZWg5gtliZfGJcalacTXKYfTNo3fIhBwjreabYRE3Zw8B1NzSBHpQFIh2fJYD
xy7Iy23pH5IGKf3aO44NlMsSJMEuXOQ69/o7jwn8YI+a0Vv2DgFJu2c5GY6ZJM4p
ST+PxUF21WF7iNVEq1EX
=LKYe
-----END PGP SIGNATURE-----

--=-TH2C9U+BQzmcsBSySeKI--

