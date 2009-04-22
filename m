Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48879 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbZDVTC6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 15:02:58 -0400
Subject: Re: [PATCH] nl80211: Add event for authentication/association
 timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090422183825.GA16766@jm.kir.nu>
References: <20090422183825.GA16766@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SXeDsi0j250u3Mg+zmRS"
Date: Wed, 22 Apr 2009 21:02:24 +0200
Message-Id: <1240426944.30082.10.camel@johannes.local> (sfid-20090422_210301_631886_2EBECCEA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SXeDsi0j250u3Mg+zmRS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-04-22 at 21:38 +0300, Jouni Malinen wrote:

> --- uml.orig/net/mac80211/mlme.c	2009-04-22 21:04:47.000000000 +0300
> +++ uml/net/mac80211/mlme.c	2009-04-22 21:10:57.000000000 +0300
> @@ -920,7 +920,7 @@ static void ieee80211_authenticate(struc
>  		       " timed out\n",
>  		       sdata->dev->name, ifmgd->bssid);
>  		ifmgd->state =3D IEEE80211_STA_MLME_DISABLED;
> -		ieee80211_sta_send_apinfo(sdata);
> +		cfg80211_send_auth_timeout(sdata->dev, ifmgd->bssid);
>  		ieee80211_rx_bss_remove(sdata, ifmgd->bssid,
>  				sdata->local->hw.conf.channel->center_freq,
>  				ifmgd->ssid, ifmgd->ssid_len);
> @@ -1103,7 +1103,7 @@ static void ieee80211_associate(struct i
>  		       " timed out\n",
>  		       sdata->dev->name, ifmgd->bssid);
>  		ifmgd->state =3D IEEE80211_STA_MLME_DISABLED;
> -		ieee80211_sta_send_apinfo(sdata);
> +		cfg80211_send_assoc_timeout(sdata->dev, ifmgd->bssid);
>  		ieee80211_rx_bss_remove(sdata, ifmgd->bssid,
>  				sdata->local->hw.conf.channel->center_freq,
>  				ifmgd->ssid, ifmgd->ssid_len);
> --- uml.orig/net/wireless/mlme.c	2009-04-22 20:54:06.000000000 +0300

I think you also need to send this if the direct probe step didn't work?
Or do we skip that for nl80211 commands? It normally won't be done since
we've just scanned, but ...

johannes

--=-SXeDsi0j250u3Mg+zmRS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ72m9AAoJEKVg1VMiehFYCk4P/0ToUxYipA8IR02RtPBpJeVK
GWABrvPA0GQ1Y4O2tJ0dM/lUCgVVzVRMqgy1iwblHxwd5m++syC4opOrkzlx88HA
fO1cXG0Bm32EjuXcHEz5vUqhAw0CnZUMZGk+RZvCByzHiJkMP3nRjBNQaPdIjuCG
7WA85yaUb3MGlTT60Z3dLuQD29ey7X3UwvrZTWHNtytuSCJFIPsZ90FHLXpgvfUG
d+VZD9AMxl1h1b859CrCmQhYjRA7c1C5iC1W2a0d3AQJiFjsBDd+RgXE1jc7823u
d0ZtWpKRpbEuhbVUAsjueMb90cXGltE1oYGYZyM4PhX8Nc2DU7i7OjG6r2+3IYC0
V1fHc9yBtAZKKxK+DzyMAwEFxDKpwx1/Ztq8smS69q+qAhTsp4v1udBAoagH22ZB
lLnMIf1oQp2/IJKaY4oh6Lm2Z3HNdsxg+Wg6o1cxNHIotO1+eOyiuNsfrgved7SD
BqySUnTnsZSeUDklp5UVweTPxgypkAgPI8SUgQUexVHzMzOQKc0pXuUYkyIwtdLe
kEY1z5moNzmhZXK8PKuijHbmPKhEwxbIS8wHhj5J79uOrP2LHifFa3JfuqdX+zLb
q6kvC77Wla3WQ9YS7dHcXDg9gq9ewi7OencO6cqad46+SS+WOEQm7LO02Xj9eNnG
4qCs3RpMEizd2XS/cBEp
=hg2x
-----END PGP SIGNATURE-----

--=-SXeDsi0j250u3Mg+zmRS--

