Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51095 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbZCMVWP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 17:22:15 -0400
Subject: Re: [PATCH v2] mac80211: resume properly, add suspend/resume test
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <bcopeland@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <b6c5339f0903131151m2dc43fbo52ace9d9070096c@mail.gmail.com> (sfid-20090313_195123_661173_7AA0BF95)
References: <1236939917.5235.7.camel@johannes.local>
	 <1236941058.5235.12.camel@johannes.local>
	 <1236941339.5235.14.camel@johannes.local>
	 <1236941908.5235.27.camel@johannes.local>
	 <b6c5339f0903131151m2dc43fbo52ace9d9070096c@mail.gmail.com>
	 (sfid-20090313_195123_661173_7AA0BF95)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-F9EF/QnYULor0FfGGlqJ"
Date: Fri, 13 Mar 2009 22:19:53 +0100
Message-Id: <1236979193.5235.52.camel@johannes.local> (sfid-20090313_222220_501204_38F42DA0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-F9EF/QnYULor0FfGGlqJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-13 at 14:51 -0400, Bob Copeland wrote:

> > [  289.753866]
> > [  289.753869] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > [  289.754164] [ INFO: inconsistent lock state ]
> > [  289.754372] 2.6.29-rc7-wl-17155-g2f7ab92-dirty #29
> > [  289.754598] ---------------------------------
> > [  289.754805] inconsistent {in-softirq-W} -> {softirq-on-W} usage.
>=20
> [softirq-on-W stack looks like:
>=20
>   sta_notify
>     ath_node_detach
>       ath_tx_node_cleanup
>         spin_lock()
>=20
> vs the ath9k_tx_tasklet]
>=20
> > Looks like we need to disable BHs for the sta functions or something?

> Yup... or pm can take sta_lock with spin_lock_irqsave() like the other
> callers of sta_notify.

Yes, we probably should do that in mac80211 for consistency, I'll cook
up a patch tomorrow or so.

> Feel free to add my Acked-by on both the PM patches.  I'd been using
> CONFIG_PM_DEBUG to simulate suspend/resume but since you have to
> do 'devices' anyway to get the desired effect, the debug file here
> is nicer.

PM_DEBUG works too, this just seemed a little more self-contained.

johannes

--=-F9EF/QnYULor0FfGGlqJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJus33AAoJEKVg1VMiehFYaxkP/R2Uotlhl0OHzurkdD0xdMwQ
ayX3kG/6LHqwXHMICsPSg2RF5sJEctp4ktbGeA1nh4TmPDjVX2rG9y6X8HQc0h5q
+xmTTbJ6XzHzpIj2b9rTv38gQlXiNWb4bKP8QssLgwJsY5dczWDdGm8PiRbaPBVt
3TZxM+5RO4sRZmDnIDY3WnmaCA6LEmI3d4URRTpHGVzrqbWHwAPGC4W30yM1TDF5
NHO+FODW4OWXnNiqtpijujhCVWTZzSGkFWMrNphHAXPbJd/HaxIpImQRAofnDuFg
46XQ/g56PZzCZhQ4l9KVdjAld7f4bSeTGQI6Ir6pDWYa6NcL3vi2EUbHb4GsKrbV
rRzdn9Q8UgWwgTWg6VOUZ8UPueZgZL14TOIW8jzZKPeV21AGQrbb2mFv7Ou6VEe4
0DRddGUs+scgeiaShij/MtQxutEQWIlgTwamGfSS6CFZPctR4hLeWkGjVWZqktXL
roklHMECPs3vzH5tEWo7q42v1XwHLgLYVbE1QZHw/YRGqSuZIe+HJ/BCNkGG6KIZ
aT4vgyZj8FP6S5mDv/+m2lCn42GGo9vggT7SVRKFcwdWcdsLlHbBNvtpK7x2ZoiR
kekBZysHBqzasAfY5WLeCOzurN9H4Fb/xujLHi0+TX6J6otwAIxUbryJ//GQgP/o
l1LR2YMrLvYVK9dMHr2Z
=6Fjp
-----END PGP SIGNATURE-----

--=-F9EF/QnYULor0FfGGlqJ--

