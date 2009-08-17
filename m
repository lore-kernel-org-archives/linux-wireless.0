Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38511 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbZHQPQu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 11:16:50 -0400
Subject: Re: 2.6.31-rc6 lockdep report
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <20090817151223.GA13125@hash.localnet>
References: <20090817151223.GA13125@hash.localnet>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-yqoZkzh1fiQZQ1Nvpfzz"
Date: Mon, 17 Aug 2009 17:16:49 +0200
Message-Id: <1250522209.15103.19.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yqoZkzh1fiQZQ1Nvpfzz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-08-17 at 11:12 -0400, Bob Copeland wrote:
> Haven't looked at it yet, I just hit this one while riding the
> train this morning and connecting to someone's adhoc station.
>=20
> [43559.227490] wlan0: Selected IBSS BSSID 2a:51:0a:35:5c:a1 based on conf=
igured SSID
> [43559.258660] ath5k phy0: bf=3Defb0b680 bf_skb=3D(null)
> [43559.291501] phy0: Adding new IBSS station 00:21:e9:94:5e:93 (dev=3Dwla=
n0)
> [43559.291518] phy0: Allocated STA 00:21:e9:94:5e:93
> [43559.292327] phy0: Inserted STA 00:21:e9:94:5e:93
> [43633.646820] phy0: Adding new IBSS station 00:1e:c2:3b:f4:e3 (dev=3Dwla=
n0)
> [43633.646838] phy0: Allocated STA 00:1e:c2:3b:f4:e3
> [43633.646859]=20
> [43633.646860] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [43633.646864] [ INFO: possible irq lock inversion dependency detected ]
> [43633.646867] 2.6.31-rc6 #179
> [43633.646870] ---------------------------------------------------------
> [43633.646873] cc1/18756 just changed the state of lock:
> [43633.646876]  (&local->sta_lock){..-...}, at: [<fa244acd>] sta_info_ins=
ert+0x91/0x174 [mac80211]
> [43633.646900] but this lock took another, SOFTIRQ-unsafe lock in the pas=
t:
> [43633.646903]  (todo_lock){+.+...}
> [43633.646906]=20
> [43633.646907] and interrupts could create inverse lock ordering between =
them.

Yeah, commit 6565a1c6d2e0754b5f1e8160252f6dc9493ed6c4 needs to be
backported. I suspect it applies as-is, John mind trying that? If not,
let me know and I'll port it.

johannes

--=-yqoZkzh1fiQZQ1Nvpfzz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKiXRaAAoJEODzc/N7+QmaL5EQALlZkxJYA92eaOjrfAcoiNCo
wevlFuVplcETM7Vou/yMxZaal8/6FXNMfaLFMvaw0xAagtbd1fCtaPm5+mj8PGLv
i6rFTzo7orFgEMYZ/7pp7FIWydtthTAzOCf34un12+b7i6zmVeZ0Yr5yk78HVILU
jySdBuu19XjWl8VIBo2qndHATAM9QiuU0xPkJUzAESfFdEtp6v43fT/28zj+4rsz
KPb+nKpfx4OtM3C/3a7NRiJluwbHLOhkLmREtlJl4E2CLgvuBzP/cyOD/hMAb4OW
kKW+X86T3/9gaMBnmuzJIrXol+mZEfpOA5d33Lknb/yT34KRL9XAavCVMp+/ARfc
fpEHbyfLw0xvnp7ulmpcYyn8iMk8XfjyJ0OIEtHdJn/xA/979AtRLKjHi+sR0xfD
WnEPpRqZFLaVe2+63sbJMqsFSqbqOYpIGdXrtug1jCH8Ajo4eOAdYAgtkAL8iilO
cHORtpxbWclthP9NFF3+WxvMTS43ddGwwrdukZBhJ5UzI2EMmh2jLy7zCiFWbJ7j
OPJJnx/SGIEeWcOjxpGzjr8PHoQBZfMNVNdqNODCuNuxTcbe13rqio/lWptiqEi7
Gr6Iugt3icAIYPK+7HdD9fgcjYO6cqaY1//XPZrVdKoV50T2I/gb9GR26iwLqAff
qCaNFrelUPMYjRx7jy53
=6uNu
-----END PGP SIGNATURE-----

--=-yqoZkzh1fiQZQ1Nvpfzz--

