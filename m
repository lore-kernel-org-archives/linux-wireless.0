Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45815 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbZBDOXh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 09:23:37 -0500
Subject: Re: [PATCH] mac80211: Free current bss information in few places
	where we don't need it any more
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1233752328-6918-1-git-send-email-vasanth@atheros.com>
References: <1233752328-6918-1-git-send-email-vasanth@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GjRnAduxsX8XKdxiO4q2"
Date: Wed, 04 Feb 2009 15:23:00 +0100
Message-Id: <1233757380.3992.11.camel@johannes.local> (sfid-20090204_152341_713847_98A3B82A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GjRnAduxsX8XKdxiO4q2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-02-04 at 18:28 +0530, Vasanthakumar Thiagarajan wrote:
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Looks good to me.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/ieee80211_i.h |    2 ++
>  net/mac80211/mlme.c        |   38 +++++++++++++++++++++-----------------
>  net/mac80211/scan.c        |   13 +++++++++++++
>  3 files changed, 36 insertions(+), 17 deletions(-)
>=20
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index eaf3603..5a1f19a 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -955,6 +955,8 @@ ieee80211_rx_bss_get(struct ieee80211_local *local, u=
8 *bssid, int freq,
>  		     u8 *ssid, u8 ssid_len);
>  void ieee80211_rx_bss_put(struct ieee80211_local *local,
>  			  struct ieee80211_bss *bss);
> +void ieee80211_rx_bss_remove(struct ieee80211_sub_if_data *sdata, u8 *bs=
sid,
> +			     int freq, u8 *ssid, u8 ssid_len);
> =20
>  /* interface handling */
>  int ieee80211_if_add(struct ieee80211_local *local, const char *name,
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 57967d3..91c9a5a 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -840,6 +840,14 @@ static void ieee80211_direct_probe(struct ieee80211_=
sub_if_data *sdata,
>  		       sdata->dev->name, ifsta->bssid);
>  		ifsta->state =3D IEEE80211_STA_MLME_DISABLED;
>  		ieee80211_sta_send_apinfo(sdata, ifsta);
> +
> +		/*
> +		 * Most likely AP is not in the range so remove the
> +		 * bss information associated to the AP
> +		 */
> +		ieee80211_rx_bss_remove(sdata, ifsta->bssid,
> +				sdata->local->hw.conf.channel->center_freq,
> +				ifsta->ssid, ifsta->ssid_len);
>  		return;
>  	}
> =20
> @@ -871,6 +879,9 @@ static void ieee80211_authenticate(struct ieee80211_s=
ub_if_data *sdata,
>  		       sdata->dev->name, ifsta->bssid);
>  		ifsta->state =3D IEEE80211_STA_MLME_DISABLED;
>  		ieee80211_sta_send_apinfo(sdata, ifsta);
> +		ieee80211_rx_bss_remove(sdata, ifsta->bssid,
> +				sdata->local->hw.conf.channel->center_freq,
> +				ifsta->ssid, ifsta->ssid_len);
>  		return;
>  	}
> =20
> @@ -933,8 +944,12 @@ static void ieee80211_set_disassoc(struct ieee80211_=
sub_if_data *sdata,
> =20
>  	ieee80211_sta_send_apinfo(sdata, ifsta);
> =20
> -	if (self_disconnected || reason =3D=3D WLAN_REASON_DISASSOC_STA_HAS_LEF=
T)
> +	if (self_disconnected || reason =3D=3D WLAN_REASON_DISASSOC_STA_HAS_LEF=
T) {
>  		ifsta->state =3D IEEE80211_STA_MLME_DISABLED;
> +		ieee80211_rx_bss_remove(sdata, ifsta->bssid,
> +				sdata->local->hw.conf.channel->center_freq,
> +				ifsta->ssid, ifsta->ssid_len);
> +	}
> =20
>  	rcu_read_unlock();
> =20
> @@ -1017,6 +1032,9 @@ static void ieee80211_associate(struct ieee80211_su=
b_if_data *sdata,
>  		       sdata->dev->name, ifsta->bssid);
>  		ifsta->state =3D IEEE80211_STA_MLME_DISABLED;
>  		ieee80211_sta_send_apinfo(sdata, ifsta);
> +		ieee80211_rx_bss_remove(sdata, ifsta->bssid,
> +				sdata->local->hw.conf.channel->center_freq,
> +				ifsta->ssid, ifsta->ssid_len);
>  		return;
>  	}
> =20
> @@ -1042,7 +1060,6 @@ static void ieee80211_associated(struct ieee80211_s=
ub_if_data *sdata,
>  	struct ieee80211_local *local =3D sdata->local;
>  	struct sta_info *sta;
>  	int disassoc;
> -	bool remove_bss =3D false;
> =20
>  	/* TODO: start monitoring current AP signal quality and number of
>  	 * missed beacons. Scan other channels every now and then and search
> @@ -1068,7 +1085,6 @@ static void ieee80211_associated(struct ieee80211_s=
ub_if_data *sdata,
>  				       "range\n",
>  				       sdata->dev->name, ifsta->bssid);
>  				disassoc =3D 1;
> -				remove_bss =3D true;
>  			} else
>  				ieee80211_send_probe_req(sdata, ifsta->bssid,
>  							 ifsta->ssid,
> @@ -1088,24 +1104,12 @@ static void ieee80211_associated(struct ieee80211=
_sub_if_data *sdata,
> =20
>  	rcu_read_unlock();
> =20
> -	if (disassoc) {
> +	if (disassoc)
>  		ieee80211_set_disassoc(sdata, ifsta, true, true,
>  					WLAN_REASON_PREV_AUTH_NOT_VALID);
> -		if (remove_bss) {
> -			struct ieee80211_bss *bss;
> -
> -			bss =3D ieee80211_rx_bss_get(local, ifsta->bssid,
> -					local->hw.conf.channel->center_freq,
> -					ifsta->ssid, ifsta->ssid_len);
> -			if (bss) {
> -				atomic_dec(&bss->users);
> -				ieee80211_rx_bss_put(local, bss);
> -			}
> -		}
> -	} else {
> +	else
>  		mod_timer(&ifsta->timer, jiffies +
>  				      IEEE80211_MONITORING_INTERVAL);
> -	}
>  }
> =20
>=20
> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> index 282e6a0..50719ea 100644
> --- a/net/mac80211/scan.c
> +++ b/net/mac80211/scan.c
> @@ -327,6 +327,19 @@ ieee80211_bss_info_update(struct ieee80211_local *lo=
cal,
>  	return bss;
>  }
> =20
> +void ieee80211_rx_bss_remove(struct ieee80211_sub_if_data *sdata, u8 *bs=
sid,
> +			     int freq, u8 *ssid, u8 ssid_len)
> +{
> +	struct ieee80211_bss *bss;
> +	struct ieee80211_local *local =3D sdata->local;
> +
> +	bss =3D ieee80211_rx_bss_get(local, bssid, freq, ssid, ssid_len);
> +	if (bss) {
> +		atomic_dec(&bss->users);
> +		ieee80211_rx_bss_put(local, bss);
> +	}
> +}
> +
>  ieee80211_rx_result
>  ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *s=
kb,
>  		  struct ieee80211_rx_status *rx_status)

--=-GjRnAduxsX8XKdxiO4q2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJiaTCAAoJEKVg1VMiehFYXIsP/iUWT4du6192nFvXToTFJ0kH
sY+TD3yV2XhI5UeU4Vsx2smky9lvsKbi7sx4aRCIvfFiIz1HFIh5l65hDwyh/puN
g6wynlc5uFyd9fpXREBlOXLlvrP7DbZZEMOFu2ewXBmTD4Ab0ZLMdXUVgGxFOzmw
DgNBY3Lpbz3CnpjUFp5ZiMBAfVmdcexeLTSGJFvJ6Sm94MDFyAwtZKZV48DJwmiy
YjmPJ296tIr581367ItBM6HdU1GupGnJJOkkr7jFr0doOEe85qGklZtwY4k/xCZ0
Q6hWtz2P8rtl3LfByVi4RDYM+FU6ykgBTT2KtpRKu0/5BUxPRum8QmxGYfYxGnak
3mGZYXqlyfYRATCAXBLivA4xq6HVnlR686J2zltB6Ci7Eeo7XX4g9aop9hlS+6IF
eZWNQOaxvQIadN03XZD0WJU5Di+eV2P4qjYmaF/yAL3myt5p4kfiyR6NSz1swUdG
MGoiK/vfjnI3Miww9TChZIxPTLtR5wAabbAa3FdhuHysCtiN+wyU8umbH/AnxADI
cOyVM8z11eGxeJ8YVHQfq8oQJMrvNYDeTftu2OvUxiUwcjIfEd6Gb5Aylt6bKjd2
U11oR0aWlZH5oxIBsAFDN1g9pHNHkZUZDs+kTF9CEAyHvWXvIu7acVbwqrBRCL5x
3TNG9RQ8vs6uJlXYLtvj
=kq+J
-----END PGP SIGNATURE-----

--=-GjRnAduxsX8XKdxiO4q2--

