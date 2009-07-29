Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42727 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbZG2Vph (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 17:45:37 -0400
Subject: Re: [PATCH] mac80211: use beacons for connection monitoring
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1248903159-17024-1-git-send-email-reinette.chatre@intel.com>
References: <1248903159-17024-1-git-send-email-reinette.chatre@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0qkKdElGJFalG/zhJFv1"
Date: Wed, 29 Jul 2009 23:45:02 +0200
Message-Id: <1248903902.8925.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0qkKdElGJFalG/zhJFv1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-29 at 14:32 -0700, Reinette Chatre wrote:
> From: Reinette Chatre <reinette.chatre@intel.com>
>=20
> The connection monitor currently relies on probe requests paired
> with probe responses to ensure that a connection is alive. This is
> fragile in some environments where probe responses can get lost.
> When we receive beacons we can also consider the connection to be
> alive, so cancel connection poll instance when we receive a beacon.
>=20
> The debug message "cancelling probereq poll due to a received beacon"
> is removed as part of this change as this case is hit very often after
> the above change and debug log receives significant number of these messa=
ges.

Not doing that was actually intentional -- we want to know whether or
not the connection is working both ways, not just whether we can receive
frames. This can certainly be improved, but I'm not sure this is the
best approach.

johannes

--=-0qkKdElGJFalG/zhJFv1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcMLbAAoJEODzc/N7+QmanbMQAI6L6X6G4b1Hu9dm4RSS3F9D
QSUpTUWye6E1Keq7YeHc3kvz101UC+CXEABWX36sVjevCU/jRQbBSuX/XgJw6xc2
aehbm8J+653uyWB2zwezG0rar1r7rcd4XLJn+u2QfY/Oxb7KOvk48+h/+tgh26iI
i2od/wq7hpOh9/xTExXZ/WqPsHeRseS5e9raMvG44BcQKUdWvp/rKvaps/bTPAvi
irC/cFFWquvWO96omx/nv66BlsLo5++x9Z9OuTwp17PhYxN60/0Cf4MslmZNxAWP
3MnCslSPvu5SEikxrfcMHXzkNGjQO7M7xBzXaFn8uB7n0cQJVo96G2IvyR01yiJh
yqDqsCVqkHuBwdW6lIzgaEAZgONNdVGffVUmwwTAwGCjhkKhVJ6qNZAmWXZPusUR
LEp8ysFv74aXpOK3kxmhCT5AfroySatq80Az/E5468JtrkJud+bAZRgbmVISceM+
lbNuqjUoOh0GpFn/55TJm++CYtyCwKa8aiaX58BvWVmMOMo2aIK0ry6z9GA8WE3V
NxSl/8c2nf+CZeE3RoMsHfHdF7xVt/0+Sf8bFx613prZ73LO9zHp/uqebaahrHRU
NFnORzUNNC/Db3BGPDm7tkD/26wWRpvQAp26l7b+e/0jS3khYcgF9nJNY8Ibblqn
IvsKvTknkYfJx1aj3MmR
=2NDL
-----END PGP SIGNATURE-----

--=-0qkKdElGJFalG/zhJFv1--

