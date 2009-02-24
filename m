Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46552 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbZBXCGQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 21:06:16 -0500
Subject: Re: [PATCH v2] mac80211: Introduce a generic commit() to apply
	changes
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <20090221002729.65900@gmx.net> (sfid-20090221_012801_080762_FF735B4B)
References: <20090221002729.65900@gmx.net>
	 (sfid-20090221_012801_080762_FF735B4B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SOj3qNosUXajxvt5ZY7E"
Date: Mon, 23 Feb 2009 17:44:50 -0800
Message-Id: <1235439890.4455.37.camel@johannes.local> (sfid-20090224_030620_350479_030B15D9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SOj3qNosUXajxvt5ZY7E
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-02-21 at 01:27 +0100, Alina Friedrichsen wrote:
> This patch introduces a generic commit() function which initiate a new
> network joining process. It should be called after some interface
> config changes, so that the changes get applied more cleanly.
> Currently set_ssid() and set_bssid() call it. Others can be added in
> future patches.

Seems fine to me.

johannes

> In version 1 the header files was forgotten, sorry.
>=20
> Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
> ---
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index 1bbfc70..aa8937c 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -788,6 +788,23 @@ void ieee80211_ibss_setup_sdata(struct ieee80211_sub=
_if_data *sdata)
>  			IEEE80211_IBSS_AUTO_CHANNEL_SEL;
>  }
> =20
> +int ieee80211_ibss_commit(struct ieee80211_sub_if_data *sdata)
> +{
> +	struct ieee80211_if_ibss *ifibss =3D &sdata->u.ibss;
> +
> +	ifibss->flags &=3D ~IEEE80211_IBSS_PREV_BSSID_SET;
> +
> +	if (ifibss->ssid_len)
> +		ifibss->flags |=3D IEEE80211_IBSS_SSID_SET;
> +	else
> +		ifibss->flags &=3D ~IEEE80211_IBSS_SSID_SET;
> +
> +	ifibss->ibss_join_req =3D jiffies;
> +	ifibss->state =3D IEEE80211_IBSS_MLME_SEARCH;
> +
> +	return ieee80211_sta_find_ibss(sdata);
> +}
> +
>  int ieee80211_ibss_set_ssid(struct ieee80211_sub_if_data *sdata, char *s=
sid, size_t len)
>  {
>  	struct ieee80211_if_ibss *ifibss =3D &sdata->u.ibss;
> @@ -801,16 +818,7 @@ int ieee80211_ibss_set_ssid(struct ieee80211_sub_if_=
data *sdata, char *ssid, siz
>  		ifibss->ssid_len =3D len;
>  	}
> =20
> -	ifibss->flags &=3D ~IEEE80211_IBSS_PREV_BSSID_SET;
> -
> -	if (len)
> -		ifibss->flags |=3D IEEE80211_IBSS_SSID_SET;
> -	else
> -		ifibss->flags &=3D ~IEEE80211_IBSS_SSID_SET;
> -
> -	ifibss->ibss_join_req =3D jiffies;
> -	ifibss->state =3D IEEE80211_IBSS_MLME_SEARCH;
> -	return ieee80211_sta_find_ibss(sdata);
> +	return ieee80211_ibss_commit(sdata);
>  }
> =20
>  int ieee80211_ibss_get_ssid(struct ieee80211_sub_if_data *sdata, char *s=
sid, size_t *len)
> @@ -842,7 +850,7 @@ int ieee80211_ibss_set_bssid(struct ieee80211_sub_if_=
data *sdata, u8 *bssid)
>  		}
>  	}
> =20
> -	return ieee80211_ibss_set_ssid(sdata, ifibss->ssid, ifibss->ssid_len);
> +	return ieee80211_ibss_commit(sdata);
>  }
> =20
>  /* scan finished notification */
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index d06c757..ecbc8e0 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -934,6 +934,7 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_i=
f_data *sdata);
>  ieee80211_rx_result ieee80211_sta_rx_mgmt(struct ieee80211_sub_if_data *=
sdata,
>  					  struct sk_buff *skb,
>  					  struct ieee80211_rx_status *rx_status);
> +int ieee80211_sta_commit(struct ieee80211_sub_if_data *sdata);
>  int ieee80211_sta_set_ssid(struct ieee80211_sub_if_data *sdata, char *ss=
id, size_t len);
>  int ieee80211_sta_get_ssid(struct ieee80211_sub_if_data *sdata, char *ss=
id, size_t *len);
>  int ieee80211_sta_set_bssid(struct ieee80211_sub_if_data *sdata, u8 *bss=
id);
> @@ -944,6 +945,7 @@ void ieee80211_send_pspoll(struct ieee80211_local *lo=
cal,
>  			   struct ieee80211_sub_if_data *sdata);
> =20
>  /* IBSS code */
> +int ieee80211_ibss_commit(struct ieee80211_sub_if_data *sdata);
>  int ieee80211_ibss_set_ssid(struct ieee80211_sub_if_data *sdata, char *s=
sid, size_t len);
>  int ieee80211_ibss_get_ssid(struct ieee80211_sub_if_data *sdata, char *s=
sid, size_t *len);
>  int ieee80211_ibss_set_bssid(struct ieee80211_sub_if_data *sdata, u8 *bs=
sid);
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 5a49779..7f23858 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1855,6 +1855,20 @@ void ieee80211_sta_req_auth(struct ieee80211_sub_i=
f_data *sdata)
>  	}
>  }
> =20
> +int ieee80211_sta_commit(struct ieee80211_sub_if_data *sdata)
> +{
> +	struct ieee80211_if_managed *ifmgd =3D &sdata->u.mgd;
> +
> +	ifmgd->flags &=3D ~IEEE80211_STA_PREV_BSSID_SET;
> +
> +	if (ifmgd->ssid_len)
> +		ifmgd->flags |=3D IEEE80211_STA_SSID_SET;
> +	else
> +		ifmgd->flags &=3D ~IEEE80211_STA_SSID_SET;
> +
> +	return 0;
> +}
> +
>  int ieee80211_sta_set_ssid(struct ieee80211_sub_if_data *sdata, char *ss=
id, size_t len)
>  {
>  	struct ieee80211_if_managed *ifmgd;
> @@ -1870,14 +1884,7 @@ int ieee80211_sta_set_ssid(struct ieee80211_sub_if=
_data *sdata, char *ssid, size
>  		ifmgd->ssid_len =3D len;
>  	}
> =20
> -	ifmgd->flags &=3D ~IEEE80211_STA_PREV_BSSID_SET;
> -
> -	if (len)
> -		ifmgd->flags |=3D IEEE80211_STA_SSID_SET;
> -	else
> -		ifmgd->flags &=3D ~IEEE80211_STA_SSID_SET;
> -
> -	return 0;
> +	return ieee80211_sta_commit(sdata);
>  }
> =20
>  int ieee80211_sta_get_ssid(struct ieee80211_sub_if_data *sdata, char *ss=
id, size_t *len)
> @@ -1907,7 +1914,7 @@ int ieee80211_sta_set_bssid(struct ieee80211_sub_if=
_data *sdata, u8 *bssid)
>  		}
>  	}
> =20
> -	return ieee80211_sta_set_ssid(sdata, ifmgd->ssid, ifmgd->ssid_len);
> +	return ieee80211_sta_commit(sdata);
>  }
> =20
>  int ieee80211_sta_set_extra_ie(struct ieee80211_sub_if_data *sdata, char=
 *ie, size_t len)
>=20

--=-SOj3qNosUXajxvt5ZY7E
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJo1EPAAoJEKVg1VMiehFYqXwP/2zeF5I51UfiBom+YT5EtANo
kvRFt0Dk+1g16efkF5zySrvY58dAFcTMSvx4vzewT4a/gqMq1xVTBCxzLBqDOU14
8jZsgbl6csgC6J0WfRRUO3i4TlCyB4Qm1pAtliixaURQjLtAIatzchmQhcq3uk/U
8EQwkkcexLKqnywdB202GYA28b0uwLuPF+z9xx0fQ4qZeuCHzRfloG9WuhlK+ilS
1JL2StbnbaOwyxdLdZx2jFcjsqFXcZMrk+KLxFQF4LNrdA2dD8h0P9XDtiRO/TsI
esJ648rUoTQ5y5M4BV6bVxecA81U0EBuhbJ56YmK6gjiRctjOGVObYeFq5woThCR
MhsIPkQHtoCmrNCmRuvmnu5idJ8HzBYx+hrCY4hFxe7vev/2adH1tjd7mm+2o+jN
xnhVKhRM+/4/wPI0bmiNlgh16y8W2sWdeS2KImvl6T6rM6W0JixtJbn+mMVw3URN
JKTClzfRoe29lDfC0KmzFtFYah6BGPYa2IkD8IqzSjMN+BduiESuPf0aTWKJcvG6
yFbPKJ5f3puTVaUiVL1oz0U+m7YDiiLKMSzc341QIFu+e6eX0gV2WPz8ULYlTuz6
0nPXSmYG4hvpcgqWyJo23xzIx6VG5JiqkumyIAmOc+8Tk8I14AfffnOX+8wzcrgh
IyT7SNIIh36+vMnblzLV
=1mQb
-----END PGP SIGNATURE-----

--=-SOj3qNosUXajxvt5ZY7E--

