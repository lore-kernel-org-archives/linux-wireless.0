Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58681 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933009Ab0BEPCO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 10:02:14 -0500
Subject: Re: [PATCH] mac80211: Improved IBSS merges
From: Johannes Berg <johannes@sipsolutions.net>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4B6C2D24.3020001@free.fr>
References: <1265319990-25583-1-git-send-email-benoit.papillault@free.fr>
	 <1265365977.3613.2.camel@johannes.local>  <4B6C2D24.3020001@free.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-XAxyHzoMdPpZqdJjSXag"
Date: Fri, 05 Feb 2010 16:02:11 +0100
Message-ID: <1265382131.3613.15.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XAxyHzoMdPpZqdJjSXag
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-02-05 at 15:37 +0100, Benoit PAPILLAULT wrote:
> Johannes Berg a =C3=A9crit :
> > On Thu, 2010-02-04 at 22:46 +0100, Benoit Papillault wrote:
> >
> >  =20
> >> Next, we merge even if the BSSID from the received beacon is the same =
as
> >> our since merge can update more things that BSSID itself. This is
> >> specifically true for ath9k where the merge updates TBTT timers as a
> >> side effect and this is indeed needed if the TSF has been updated (if
> >> TSF is updated, we need to update TBTT timers as well).
> >>    =20
> >
> >  =20
> >> @@ -373,10 +370,6 @@ static void ieee80211_rx_bss_info(struct ieee8021=
1_sub_if_data *sdata,
> >>  				sdata->u.ibss.ssid_len))
> >>  		goto put_bss;
> >> =20
> >> -	/* same BSSID */
> >> -	if (memcmp(cbss->bssid, sdata->u.ibss.bssid, ETH_ALEN) =3D=3D 0)
> >> -		goto put_bss;
> >> -
> >>  	if (rx_status->flag & RX_FLAG_TSFT) {
> >>  		/*
> >>  		 * For correct IBSS merging we need mactime; since mactime is
> >>    =20
> >
> > NACK. This will create merges and merges and merges and merges whenever
> > you use hardware that doesn't have accurate timestamps all the time.
> >
> > johannes
> >  =20
> Humm... could you give an example? For hardware that don't have RX=20
> timestamp, we will use the drv_get_tsf() function, this function will=20
> only return a timestamp that is later than the real time at which the=20
> beacon is received, so we can only miss IBSS merges in fact. Did I miss=20
> something?

There's hardware that also doesn't have get_tsf()

johannes

--=-XAxyHzoMdPpZqdJjSXag
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLbDLsAAoJEODzc/N7+Qmaiz4P/jX+B5EVwMIvlV/oxEggdq8K
1+MnBogW8Ab38K+p/Ob1kuy0Pt2zneacrFmSKMZywIwT8Fg98il7xuMbQhn8PY35
aWy30NkO5/FyBYjqiuU6iYlHhoUoBIe2rmtuxXuOhg5Jbx533saQy/zAdkaPYFY7
B9H0vo7Q3kdXiqZIVfyLH/0Vfe9bKJ4wYHSi2sFltSMEgmRFIuZZknkGKbaFpUra
RwomWMrv8BmWr/aHlDvdJJcVWlJPZbIGMacHWC4++UoCalfZQHwsmp6kxZURH+AJ
LoiOugzHU3Fkp6WXwAw2rJqHgn3/rpjE1bPhIzEsz5305/D5YG87ogXad6aqVYuC
QQ8xB/iVMzFIi6aqJ0zNBzrY86OYuXCW3wk4iAmyZu8Ca/eKq01fO2OQlorh5duG
5N3oy9b5yP/yNkMg3kvJYjGdEnpsRr1EOuNdAKxf/jUdP32n2LpNczaGV2sPiQ5g
y8ddXawHcHUl7By3tmxyf9qDIyzaoaR6Hv42bMKV2IttNk8y8uKhBXXs1gRJakhU
2okr0mTJex93FogxezImJ6wDmS1PgXZ5ugYQ2QCizy8ApXGzcSr+oCIj56fXNw0R
WzuLXMwrb1RZssVsT1K2U0ydXqVbdA2Iyh/tlpEOY2XGj9qOOFLjLMZfx9/iABUE
7S16IKBatnT91EjVvLF7
=OUT8
-----END PGP SIGNATURE-----

--=-XAxyHzoMdPpZqdJjSXag--

