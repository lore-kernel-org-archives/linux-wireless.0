Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34635 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbYIHIX1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 04:23:27 -0400
Subject: Re: [RFC PATCH 1/3] mac80211: restructure disassoc/deauth flows
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1220739259-16918-2-git-send-email-tomas.winkler@intel.com>
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
	 <1220739259-16918-2-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5bWyEghntD5nbIBGPeX3"
Date: Mon, 08 Sep 2008 10:23:20 +0200
Message-Id: <1220862200.31304.24.camel@johannes.berg> (sfid-20080908_102331_162426_D5323730)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5bWyEghntD5nbIBGPeX3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-09-07 at 01:14 +0300, Tomas Winkler wrote:

> @@ -1104,16 +1133,12 @@ static void ieee80211_associated(struct ieee80211=
_sub_if_data *sdata,
> =20
>  	rcu_read_unlock();
> =20
> -	if (disassoc && sta)
> -		sta_info_destroy(sta);
> -
> -	if (disassoc) {
> -		ifsta->state =3D IEEE80211_STA_MLME_DISABLED;
> -		ieee80211_set_associated(sdata, ifsta, 0);
> -	} else {
> +	if (disassoc)
> +		ieee80211_set_disassoc(sdata, ifsta, 1, 1,
> +					WLAN_REASON_PREV_AUTH_NOT_VALID);
> +	else
>  		mod_timer(&ifsta->timer, jiffies +
>  				      IEEE80211_MONITORING_INTERVAL);
> -	}
>  }
> =20
>=20

This hunk has another bug, or rather, we need to add this hunk:

@@ -1084,7 +1114,6 @@ static void ieee80211_associated(struct=20
                                       "range\n",
                                       sdata->dev->name, print_mac(mac, ifs=
ta->bssid));
                                disassoc =3D 1;
-                               sta_info_unlink(&sta);
                        } else
                                ieee80211_send_probe_req(sdata, ifsta->bssi=
d,
                                                         local->scan_ssid,

johannes

--=-5bWyEghntD5nbIBGPeX3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIxODxAAoJEKVg1VMiehFYurUQAJcNadBNCT5Gu093ZActnavu
EEz6a1tKulLkijGm0vW8bbX5vB7JHbrt8RW9iZpYCfVYQWp0Ym2hGacdwQ/eHs2/
rzl+ShrzE2+aw1oFQtU1+ID8snXbZPxvxxVIsFM63agPh6doUMEqBKuQjwngFeL9
8+pcJbWAWQr52UAzUiocuFqfUj8wD+iCr9W9TQj99YXD8HN5JRjNq4lIHvmuWHju
g2Cs80XVJdxNHk02Uov9/++jXcZCNjLEbXLsMBHBxX2op3eGMzBGs5dHSRBkLHTz
efSjhh9uR/DG58OT31UPfcn/hpOeVdGmPfYSscUllnLn4iqmZKPSp3+kcUinanXH
IsSuzw3kO9YxvHiOPqwXGZoo62Q9RVkfWxUSoWDaXMdMw5Ft4w8qW87gDjKX7ln2
ue2gSgdXt0ZRpSS7vDDhPjxezgUzQHrPRvzNpiMhQFLHRHCihlJCvg3Qc+Q5aJgx
19BzmBjD/jZVFWBP85rK3DXz8PH2JGgL09GFHNPBRwD62TGIg0LYuMgxBxya5CFk
gghdn3i/QXABioACdIzxjA+AOCBoDiPD1pE0VApmZcxGqBTXU5tU2jKoEYRLrRDB
ZU5uTbp8jhPuoUTV8hKPQ6STwrsKPU57VU3QinXh1vbzW/OJUZPJZYYt90gDs/A4
cbCCj0eB3OSVg2EcpjA4
=yEyY
-----END PGP SIGNATURE-----

--=-5bWyEghntD5nbIBGPeX3--

