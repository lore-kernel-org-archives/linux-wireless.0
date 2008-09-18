Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42305 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbYIRKWD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 06:22:03 -0400
Subject: Re: [PATCH] mac80211: Enable mesh point handle action packet
From: Johannes Berg <johannes@sipsolutions.net>
To: YanBo <dreamfly281@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1197ff4c0809180309p7cd5c2b4y30db3799d91bdc6b@mail.gmail.com> (sfid-20080918_120952_649821_EB80D1B5)
References: <1197ff4c0809180309p7cd5c2b4y30db3799d91bdc6b@mail.gmail.com>
	 (sfid-20080918_120952_649821_EB80D1B5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WzUkfD5Dm6N5cS1h7vKI"
Date: Thu, 18 Sep 2008 12:21:25 +0200
Message-Id: <1221733285.9262.65.camel@johannes.berg> (sfid-20080918_122207_578587_5936018C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WzUkfD5Dm6N5cS1h7vKI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-18 at 18:09 +0800, YanBo wrote:
> This patch enable vif in mesh_point mode can handle the action packet.
>=20
> Signed-off-by: Li YanBo <dreamfly281@gmail.com>
> ---
> net/mac80211/rx.c |    3 ++-
> 1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 92d898b..763c7ea 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1537,7 +1537,8 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
>  	 *	  of these frames in other modes as well!
>  	 */
>  	if (sdata->vif.type !=3D NL80211_IFTYPE_STATION &&
> -	    sdata->vif.type !=3D NL80211_IFTYPE_ADHOC)
> +	    sdata->vif.type !=3D NL80211_IFTYPE_ADHOC &&
> + 	    sdata->vif.type !=3D NL80211_IFTYPE_MESH_POINT)
>  		return RX_DROP_MONITOR;

My mistake, but the fix would be to return RX_CONTINUE here, I'll send a
fix.

johannes

--=-WzUkfD5Dm6N5cS1h7vKI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI0iuhAAoJEKVg1VMiehFYW40P+gLFquylplgj1xhRQ7RUlbR/
UWWsH/mwpKKv8qWqiHrp9PTwOJB1pLzLE54DIrjsrhyys7khY+hejuv54KfKGQ0R
L661N53IA4JWmrhS9pKha0WPNGjMxd4s3Xcx9XkwjnAXU8MS0Ke9YPS8BrdXHBeB
kTCTAPqObgRRgYcC7UV9kDIBT+oWFKmtRai/RTmyeyQO8r1Yntc9LaAb1vu2Cpk3
7qOJySmlHVZQxPH8noXQEBAoloP0jcDaHuhoOgsKy79h4H7j5in2dMqEbIHpQMli
/fx/Kdu63cvs8lyPACI44F94tcUon8r1qumLR2JMPXQ6xXttxACKUcIztYZqAUIU
wzcFA9TBlNlueCyDEUm1AjahGYi/SxCrbsRNbjs0qd65lpDLKz/yukvQ6ts7L8fL
lxJRp0TpsNhikVgRHV9R2gM6CdDfSxWzXo8fjLio9ZKLZ+gzm49faGRK2LFuHpvk
0ZOk6iguZtDIKRT9TJwgnUSLY3BurDcQBi23vSKdwWS4nyfUUSikDvyCHTHSC5Lr
lqyQqdJ4n0GTvbr6MQc1xNhZq9zZl6dBwkNLBV4SyHcUsCBIIPLQF4r6vkRbdQGB
2K7hGu1nYEdUnAvOGsYa+emQLztpTTY3ku3f8mM6n6k4+hI5nZlC4uOsFbZVT9Qg
MMp4C8isnxFs0LJmLZ/Q
=hJ6d
-----END PGP SIGNATURE-----

--=-WzUkfD5Dm6N5cS1h7vKI--

