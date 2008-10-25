Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38301 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbYJYJR2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2008 05:17:28 -0400
Subject: Re: zd1211rw (2.6.26 sparc64): unaligned access (zd_mac_rx)
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org,
	Shaddy Baddah <shaddy_baddah@hotmail.com>
In-Reply-To: <4902DEBB.3050205@hotmail.com> (sfid-20081025_111023_101434_86228069)
References: <4902DEBB.3050205@hotmail.com>
	 (sfid-20081025_111023_101434_86228069)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-22Qag55smQqW6uYPWfSp"
Date: Sat, 25 Oct 2008 11:17:21 +0200
Message-Id: <1224926241.6695.1.camel@johannes.berg> (sfid-20081025_111732_924681_40DD4DFE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-22Qag55smQqW6uYPWfSp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> [  277.190494] Kernel unaligned access at TPC[10129b68] zd_mac_rx+0x144/0=
x32c [zd1211rw]

my best bet is this:

        fc =3D *(__le16 *)buffer;

could you try something with get_unaligned? Though if this is it,
then ... We really need disassembly of the exact spot.

johannes

--=-22Qag55smQqW6uYPWfSp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJAuQdAAoJEKVg1VMiehFYgC8P/0IC6Bt8uvQudnHBzBKWfrqf
MQQ+U3nLpY8tg+gbxCKqzdHGvDAuO8VB/b6IdlFL4KJLUcFwcXWc7CXmB07XGUyu
kAp271VzUn+2XjlxT9KGaBK4CaBSeU+5oBPgrPlO/+KUjtN9n18JAViP8rYKkDTo
498dkh20NqQGewzYUb0F2tQSr1Id81OjHOm8VFDcbjgibJM8MQoRrP1P6CqxJLOY
NK/cvn0zQbn3JYldfr4QF+U4eezjUIngNGh4f3J+Rd4Qd4nKpX6+c+z6ncJDPpnY
+ff+EhhzKcWDaHqq9S6FaWruIwYwCMQN9YITpDtUIKmiEDisJu776uxnfLrU77yt
oMI2qRPGB7jNqre9jZ5VEEqiGdq82cMIReYwZ8CBeyZ6yU0bIhECC7QQu7Qo1jlY
If3FhzLqzHBkhFHM2uY0Ou44j3X14HbG/TCq0/g/fLrRFNuEwv8Est6rX7SeiCM5
vUa000gEg/MJzsGoaxln/yQG6nxak2aNwjdKoIB1ZBFnt4JHyfWy4JGeOY2+366U
+IQwtGcEmkP5zTqa+kV1FvhzhOQq+33J0PzLZxJZD7ilJIsSPS2nClchgUK164/6
QUzkec0iHE5CYAV9NZLDK8mP7LeakAZu9QwMI63RC7vJgOhFWWEdAQnPn+aX8/fR
+OqUlRv633kteeWSYUm6
=J4LZ
-----END PGP SIGNATURE-----

--=-22Qag55smQqW6uYPWfSp--

