Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49259 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbXLTRpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2007 12:45:22 -0500
Subject: Re: [PATCH 5/8 v2] mac80211: A-MPDU Rx handling aggregation
	reordering
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <11981435613464-git-send-email-ron.rindjunsky@intel.com>
References: <11981435524069-git-send-email-ron.rindjunsky@intel.com>
	 <11981435613464-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OpdmVYuzLSbEqqsTbT+O"
Date: Thu, 20 Dec 2007 18:14:27 +0100
Message-Id: <1198170867.16241.56.camel@johannes.berg> (sfid-20071220_174616_578798_3307266B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OpdmVYuzLSbEqqsTbT+O
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> @@ -1212,7 +1212,8 @@ void ieee80211_sta_stop_rx_BA_session(struct net_de=
vice *dev, u8 *ra, u16 tid,
>  	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
>  	struct ieee80211_hw *hw =3D &local->hw;
>  	struct sta_info *sta;
> -	int ret;
> +	struct ieee80211_rx_status status;
> +	int ret, i;
> =20
>  	sta =3D sta_info_get(local, ra);
>  	if (!sta)
> @@ -1254,6 +1255,20 @@ void ieee80211_sta_stop_rx_BA_session(struct net_d=
evice *dev, u8 *ra, u16 tid,
>  		ieee80211_send_delba(dev, ra, tid, 0, reason);
> =20
>  	/* free the reordering buffer */
> +	for (i =3D 0; i < sta->ampdu_mlme.tid_rx[tid].buf_size; i++) {

Something I just thought of but probably simply missed: where's the
session torn down when we ifdown an interface while an A-MPDU session is
active? I didn't go through all the patches again, did I miss that
somewhere?

johannes

--=-OpdmVYuzLSbEqqsTbT+O
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2qi8aVg1VMiehFYAQITCBAAweCEr0QvYd41bb1mBdUbbObbMp4D7W/z
/msD6BArSqGSwTJESFc8t7qOedy4nVaPEBsccPShXfjtykXpZVw8j3qAI8EytrLt
gyQuN23oZG0hBf/qwK9VfNZ1sOZCEtd1+C8ArceO/looX60T1cZYy0xf6ZASIIH9
xiIQNYQQdXJoWlZKLnsnCmkNQ55FIsdOMUfQaGSQbtxrSYQMvHdUAuJ9BJ0P5h6F
+O2hl126GEZnHgjV7vyqPX9UaklPLjjGbZNvrui3vErwd/9IdFyHXy2bbdyhCuz7
Ekasosfr7exMgVygAljMlRSDSldC/f1dJP2DyfYm+5hra25xvylNuZ4UjsAnfZD1
yPPqYO9YfnyUnEE56YHV8QM8JVXgC+2naHdKIQ95IreIBwTr09Qq+By9ShScARoJ
bOJIifF05oKeUdgg17yDGTEa5wAVL7mpz4Vb3lyToD74IRBVJKd/YfiF3Mdp2+Sy
zwFzulprAzVpgFZSLvEfdJpk5YrVIMQQHh1ol2doMBx8lEw6tU96zLXgwXL2x7q0
lVOygpRrmm+FSNtE66d0qINFmufmcQSM8zk3ieq1xhPMCyudg8ZJFWuy5MWacV+/
L4pxQXgo+rrmn4vtC2i4I8ctixSLsjWH63DSTaetYyEHk8BxPxZj6eayNyc9DN2o
MVHWUODa2SY=
=UHT8
-----END PGP SIGNATURE-----

--=-OpdmVYuzLSbEqqsTbT+O--

