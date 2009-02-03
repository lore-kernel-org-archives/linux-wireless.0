Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52327 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbZBCKLG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 05:11:06 -0500
Subject: Re: [PATCH v2] mac80211: Remove bss information of the current AP
	when it goes out of range
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1233635989-20664-1-git-send-email-vasanth@atheros.com>
References: <1233635989-20664-1-git-send-email-vasanth@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IQ3JKrwCdQ5sE4AMPJUg"
Date: Tue, 03 Feb 2009 11:10:53 +0100
Message-Id: <1233655853.5460.0.camel@johannes.local> (sfid-20090203_111110_980161_0754344B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IQ3JKrwCdQ5sE4AMPJUg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-02-03 at 10:09 +0530, Vasanthakumar Thiagarajan wrote:
> There is no point having the bss information of currently associated AP
> when the AP is detected to be out of range.

Seems sane to me. There are a few other places I think where we hold on
to the bss info way too long, in fact, we hold on to it _forever_ most
of the time.

> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> ---
>  net/mac80211/mlme.c |   18 ++++++++++++++++--
>  1 files changed, 16 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 9d51e27..945c10d 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1042,6 +1042,7 @@ static void ieee80211_associated(struct ieee80211_s=
ub_if_data *sdata,
>  	struct ieee80211_local *local =3D sdata->local;
>  	struct sta_info *sta;
>  	int disassoc;
> +	bool remove_bss =3D false;
> =20
>  	/* TODO: start monitoring current AP signal quality and number of
>  	 * missed beacons. Scan other channels every now and then and search
> @@ -1067,6 +1068,7 @@ static void ieee80211_associated(struct ieee80211_s=
ub_if_data *sdata,
>  				       "range\n",
>  				       sdata->dev->name, ifsta->bssid);
>  				disassoc =3D 1;
> +				remove_bss =3D true;
>  			} else
>  				ieee80211_send_probe_req(sdata, ifsta->bssid,
>  							 ifsta->ssid,
> @@ -1086,12 +1088,24 @@ static void ieee80211_associated(struct ieee80211=
_sub_if_data *sdata,
> =20
>  	rcu_read_unlock();
> =20
> -	if (disassoc)
> +	if (disassoc) {
>  		ieee80211_set_disassoc(sdata, ifsta, true, true,
>  					WLAN_REASON_PREV_AUTH_NOT_VALID);
> -	else
> +		if (remove_bss) {
> +			struct ieee80211_bss *bss;
> +
> +			bss =3D ieee80211_rx_bss_get(local, ifsta->bssid,
> +					local->hw.conf.channel->center_freq,
> +					ifsta->ssid, ifsta->ssid_len);
> +			if (bss) {
> +				atomic_dec(&bss->users);
> +				ieee80211_rx_bss_put(local, bss);
> +			}
> +		}
> +	} else {
>  		mod_timer(&ifsta->timer, jiffies +
>  				      IEEE80211_MONITORING_INTERVAL);
> +	}
>  }
> =20
>=20

--=-IQ3JKrwCdQ5sE4AMPJUg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJiBgqAAoJEKVg1VMiehFYbksQAMHjaRMQNEVmDK8i3OYQny6W
cr+H4ge7vpKOYKVE/pGWG6jnHCNrnuGDY7ZhIs9WbKDSbUtCu33Y5NoWZ66wqJ24
e7Sp5jFeAW4gyBeLcQIMQPGmribJvWJZEb5tirOCclIOdAd43wrEqnYlLM+amlbq
EVQqmYqmpvVdnWsNjx1PuSO4wHJvgGVXWlqQ+aXR4g1cdYpVg3Rp96c3RlVpPCq6
Y1of3T3ZD9t5Y58kYLW5b2mSjCTJaJM051lJMCqz4ZpVMd7RbO/yNRURNeKWh+6I
+uJJMYdPiBZ82j6F5YFfhYwzUfK1awtEdJdjWdJZ7AUwnmBgZCqYRTrGQrPefvNq
7JlEvrvZcWyK5n/TmhaN8KjvthxR0BZ3FA5eEZkRvokim+rrXv7UJugkryKbNDEC
RtONVP6iHrAvlkq7T3P9MpHfHt/LIgB0qm0uSl8VVSBe1hmMiRCCu+NkiLgbe8Ob
CIHMeqCdka3r//2o3Wqla4WV3M/5timtx749vnaZgCWLWWGCT55dnwid8sw+NYMy
sA46qocJ0GBN+Sag539+RDGVcS3zhFELV02n2YZ1gVHHHvnF9lm7t6FASi1AhKs1
dl3FV2LR+jHEcytl2IJwH/uyhT+SVDBN8evfi4t/JyG9lwQyYONZipFMbvFyM1oy
xPCSXyy4/6VuQ+1dmJLB
=LWYe
-----END PGP SIGNATURE-----

--=-IQ3JKrwCdQ5sE4AMPJUg--

