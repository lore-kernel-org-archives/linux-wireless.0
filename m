Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49003 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbYGCRJU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 13:09:20 -0400
Subject: Re: [PATCH] mac80211: Only flush workqueue when last interface was
	removed
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200807031902.44808.IvDoorn@gmail.com> (sfid-20080703_185741_853161_D39A3EBF)
References: <200807031902.44808.IvDoorn@gmail.com>
	 (sfid-20080703_185741_853161_D39A3EBF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tsgPR2/FC516kwckEE1V"
Date: Thu, 03 Jul 2008 19:08:26 +0200
Message-Id: <1215104906.9975.19.camel@johannes.berg> (sfid-20080703_190933_542658_29750738)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tsgPR2/FC516kwckEE1V
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-07-03 at 19:02 +0200, Ivo van Doorn wrote:
> Currently the ieee80211_hw->workqueue is flushed each time
> an interface is being removed. However most scheduled work
> is not interface specific but device specific, for example things like
> periodic work for link tuners.
>=20
> This patch will move the flush_workqueue() call to directly behind
> the call to ops->stop() to make sure the workqueue is only flushed
> when all interfaces are gone and there really shouldn't be any scheduled
> work in the drivers left.

Yeah I think that's what we always wanted.

> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index 074f71a..577845e 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -533,8 +533,6 @@ static int ieee80211_stop(struct net_device *dev)
>  				local->sta_hw_scanning =3D 0;
>  		}
> =20
> -		flush_workqueue(local->hw.workqueue);
> -
>  		sdata->u.sta.flags &=3D ~IEEE80211_STA_PRIVACY_INVOKED;
>  		kfree(sdata->u.sta.extra_ie);
>  		sdata->u.sta.extra_ie =3D NULL;
> @@ -558,6 +556,8 @@ static int ieee80211_stop(struct net_device *dev)
> =20
>  		ieee80211_led_radio(local, 0);
> =20
> +		flush_workqueue(local->hw.workqueue);
> +
>  		tasklet_disable(&local->tx_pending_tasklet);
>  		tasklet_disable(&local->tasklet);
>  	}
>=20

--=-tsgPR2/FC516kwckEE1V
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIbQeGAAoJEKVg1VMiehFY87IQAIDIb8cxiNAAh8S+cecJOsDw
DJpd+alRbw6dgA7FQsnChq2ySAsbtYabxxs9t+DiG999Ka6o3xxrUZ8KHBdIa9m4
BS2uYqliBxGDMmq07kJGTBrVoUyhG7Bhadacwd0Wc++mCrh7Uyfef29s2vjP6wC6
x1M7zXlXArFiQaBuaVHVgZ4b4mzS69pMH/AAyTEw2/Q6dtM1cnFaQtPgNA/mh5Ok
i9XZopJM4nAwg76NsRf5fMBOIESSc5LqmkGH6zQvKD/5KDrPoFwF1GWIojMoOwNg
RlweHX2Cx5m9/a+wPX0IfUNm4GzeUbyWnWL2T+uJ0+wjIRFnIIE2fiOx3yvoQAMv
7536NqaDzWKMZgBQlTby7olBvkFMAKVA+kuBUIQOAEcXP6ElOLdPBKbQGE6cs1zN
Zw2XAZd8e1S3Zo/OIdOyoX6043HcqElNq5wCBT8W91hULqh96jiKLkkwrdS4rYmy
P4Ai8Y5MF8Y2JkOWYLC43xH7WAi5/zWpR3vmyPxkh0V97JlYJVHRPuynrcAieFza
1BoMp5y6OcvddwbFrPEzN7UHfSII2fxLF3jktkZSoT9TQdU7fZ2yzIVb1k/FV+dL
dFteAjERur2qszi0I8SCAJesP5RibJRojlfOQcaOmYJXgdsVXq5s/ANLfbAqRHVC
pFEusWwVpPQFdcd6xhzT
=eq0k
-----END PGP SIGNATURE-----

--=-tsgPR2/FC516kwckEE1V--

