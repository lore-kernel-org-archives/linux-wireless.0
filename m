Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33368 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbYBOMw6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 07:52:58 -0500
Subject: Re: [PATCH 2/3] mac80211: move function ieee80211_sta_join_ibss()
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <bruno@thinktube.com>
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, flamingice@sourmilk.net, jbenc@suse.cz
In-Reply-To: <20080215070140.32461.43925.stgit@one>
References: <20080215070116.32461.80795.stgit@one>
	 <20080215070140.32461.43925.stgit@one>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Xbn6Y7wWA+sTq2tt8yLg"
Date: Fri, 15 Feb 2008 13:52:46 +0100
Message-Id: <1203079966.8931.188.camel@johannes.berg> (sfid-20080215_125302_819558_7346678F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Xbn6Y7wWA+sTq2tt8yLg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2008-02-15 at 16:01 +0900, Bruno Randolf wrote:
> this moves ieee80211_sta_join_ibss() up for the next patch (ibss merge).

Dunno if it needs sign-off, but

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>=20
>  net/mac80211/ieee80211_sta.c |  317 +++++++++++++++++++++---------------=
------
>  1 files changed, 159 insertions(+), 158 deletions(-)
>=20
>=20
> diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
> index 2c7b8be..72d7a86 100644
> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -2030,6 +2030,165 @@ void ieee80211_rx_bss_list_deinit(struct net_devi=
ce *dev)
>  }
> =20
>=20
> +static int ieee80211_sta_join_ibss(struct net_device *dev,
> +				   struct ieee80211_if_sta *ifsta,
> +				   struct ieee80211_sta_bss *bss)
> +{
> +	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
> +	int res, rates, i, j;
> +	struct sk_buff *skb;
> +	struct ieee80211_mgmt *mgmt;
> +	struct ieee80211_tx_control control;
> +	struct rate_selection ratesel;
> +	u8 *pos;
> +	struct ieee80211_sub_if_data *sdata;
> +	struct ieee80211_supported_band *sband;
> +
> +	sband =3D local->hw.wiphy->bands[local->hw.conf.channel->band];
> +
> +	/* Remove possible STA entries from other IBSS networks. */
> +	sta_info_flush(local, NULL);
> +
> +	if (local->ops->reset_tsf) {
> +		/* Reset own TSF to allow time synchronization work. */
> +		local->ops->reset_tsf(local_to_hw(local));
> +	}
> +	memcpy(ifsta->bssid, bss->bssid, ETH_ALEN);
> +	res =3D ieee80211_if_config(dev);
> +	if (res)
> +		return res;
> +
> +	local->hw.conf.beacon_int =3D bss->beacon_int >=3D 10 ? bss->beacon_int=
 : 10;
> +
> +	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> +	sdata->drop_unencrypted =3D bss->capability &
> +		WLAN_CAPABILITY_PRIVACY ? 1 : 0;
> +
> +	res =3D ieee80211_set_freq(local, bss->freq);
> +
> +	if (local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS) {
> +		printk(KERN_DEBUG "%s: IBSS not allowed on frequency "
> +		       "%d MHz\n", dev->name, local->oper_channel->center_freq);
> +		return -1;
> +	}
> +
> +	/* Set beacon template */
> +	skb =3D dev_alloc_skb(local->hw.extra_tx_headroom + 400);
> +	do {
> +		if (!skb)
> +			break;
> +
> +		skb_reserve(skb, local->hw.extra_tx_headroom);
> +
> +		mgmt =3D (struct ieee80211_mgmt *)
> +			skb_put(skb, 24 + sizeof(mgmt->u.beacon));
> +		memset(mgmt, 0, 24 + sizeof(mgmt->u.beacon));
> +		mgmt->frame_control =3D IEEE80211_FC(IEEE80211_FTYPE_MGMT,
> +						   IEEE80211_STYPE_BEACON);
> +		memset(mgmt->da, 0xff, ETH_ALEN);
> +		memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
> +		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
> +		mgmt->u.beacon.beacon_int =3D
> +			cpu_to_le16(local->hw.conf.beacon_int);
> +		mgmt->u.beacon.capab_info =3D cpu_to_le16(bss->capability);
> +
> +		pos =3D skb_put(skb, 2 + ifsta->ssid_len);
> +		*pos++ =3D WLAN_EID_SSID;
> +		*pos++ =3D ifsta->ssid_len;
> +		memcpy(pos, ifsta->ssid, ifsta->ssid_len);
> +
> +		rates =3D bss->supp_rates_len;
> +		if (rates > 8)
> +			rates =3D 8;
> +		pos =3D skb_put(skb, 2 + rates);
> +		*pos++ =3D WLAN_EID_SUPP_RATES;
> +		*pos++ =3D rates;
> +		memcpy(pos, bss->supp_rates, rates);
> +
> +		if (bss->band =3D=3D IEEE80211_BAND_2GHZ) {
> +			pos =3D skb_put(skb, 2 + 1);
> +			*pos++ =3D WLAN_EID_DS_PARAMS;
> +			*pos++ =3D 1;
> +			*pos++ =3D ieee80211_frequency_to_channel(bss->freq);
> +		}
> +
> +		pos =3D skb_put(skb, 2 + 2);
> +		*pos++ =3D WLAN_EID_IBSS_PARAMS;
> +		*pos++ =3D 2;
> +		/* FIX: set ATIM window based on scan results */
> +		*pos++ =3D 0;
> +		*pos++ =3D 0;
> +
> +		if (bss->supp_rates_len > 8) {
> +			rates =3D bss->supp_rates_len - 8;
> +			pos =3D skb_put(skb, 2 + rates);
> +			*pos++ =3D WLAN_EID_EXT_SUPP_RATES;
> +			*pos++ =3D rates;
> +			memcpy(pos, &bss->supp_rates[8], rates);
> +		}
> +
> +		memset(&control, 0, sizeof(control));
> +		rate_control_get_rate(dev, sband, skb, &ratesel);
> +		if (!ratesel.rate) {
> +			printk(KERN_DEBUG "%s: Failed to determine TX rate "
> +			       "for IBSS beacon\n", dev->name);
> +			break;
> +		}
> +		control.vif =3D &sdata->vif;
> +		control.tx_rate =3D ratesel.rate;
> +		if (sdata->bss_conf.use_short_preamble &&
> +		    ratesel.rate->flags & IEEE80211_RATE_SHORT_PREAMBLE)
> +			control.flags |=3D IEEE80211_TXCTL_SHORT_PREAMBLE;
> +		control.antenna_sel_tx =3D local->hw.conf.antenna_sel_tx;
> +		control.flags |=3D IEEE80211_TXCTL_NO_ACK;
> +		control.retry_limit =3D 1;
> +
> +		ifsta->probe_resp =3D skb_copy(skb, GFP_ATOMIC);
> +		if (ifsta->probe_resp) {
> +			mgmt =3D (struct ieee80211_mgmt *)
> +				ifsta->probe_resp->data;
> +			mgmt->frame_control =3D
> +				IEEE80211_FC(IEEE80211_FTYPE_MGMT,
> +					     IEEE80211_STYPE_PROBE_RESP);
> +		} else {
> +			printk(KERN_DEBUG "%s: Could not allocate ProbeResp "
> +			       "template for IBSS\n", dev->name);
> +		}
> +
> +		if (local->ops->beacon_update &&
> +		    local->ops->beacon_update(local_to_hw(local),
> +					     skb, &control) =3D=3D 0) {
> +			printk(KERN_DEBUG "%s: Configured IBSS beacon "
> +			       "template\n", dev->name);
> +			skb =3D NULL;
> +		}
> +
> +		rates =3D 0;
> +		sband =3D local->hw.wiphy->bands[local->hw.conf.channel->band];
> +		for (i =3D 0; i < bss->supp_rates_len; i++) {
> +			int bitrate =3D (bss->supp_rates[i] & 0x7f) * 5;
> +			for (j =3D 0; j < sband->n_bitrates; j++)
> +				if (sband->bitrates[j].bitrate =3D=3D bitrate)
> +					rates |=3D BIT(j);
> +		}
> +		ifsta->supp_rates_bits[local->hw.conf.channel->band] =3D rates;
> +	} while (0);
> +
> +	if (skb) {
> +		printk(KERN_DEBUG "%s: Failed to configure IBSS beacon "
> +		       "template\n", dev->name);
> +		dev_kfree_skb(skb);
> +	}
> +
> +	ifsta->state =3D IEEE80211_IBSS_JOINED;
> +	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
> +
> +	ieee80211_rx_bss_put(dev, bss);
> +
> +	return res;
> +}
> +
> +
>  static void ieee80211_rx_bss_info(struct net_device *dev,
>  				  struct ieee80211_mgmt *mgmt,
>  				  size_t len,
> @@ -2896,164 +3055,6 @@ static int ieee80211_sta_config_auth(struct net_d=
evice *dev,
>  	return -1;
>  }
> =20
> -static int ieee80211_sta_join_ibss(struct net_device *dev,
> -				   struct ieee80211_if_sta *ifsta,
> -				   struct ieee80211_sta_bss *bss)
> -{
> -	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
> -	int res, rates, i, j;
> -	struct sk_buff *skb;
> -	struct ieee80211_mgmt *mgmt;
> -	struct ieee80211_tx_control control;
> -	struct rate_selection ratesel;
> -	u8 *pos;
> -	struct ieee80211_sub_if_data *sdata;
> -	struct ieee80211_supported_band *sband;
> -
> -	sband =3D local->hw.wiphy->bands[local->hw.conf.channel->band];
> -
> -	/* Remove possible STA entries from other IBSS networks. */
> -	sta_info_flush(local, NULL);
> -
> -	if (local->ops->reset_tsf) {
> -		/* Reset own TSF to allow time synchronization work. */
> -		local->ops->reset_tsf(local_to_hw(local));
> -	}
> -	memcpy(ifsta->bssid, bss->bssid, ETH_ALEN);
> -	res =3D ieee80211_if_config(dev);
> -	if (res)
> -		return res;
> -
> -	local->hw.conf.beacon_int =3D bss->beacon_int >=3D 10 ? bss->beacon_int=
 : 10;
> -
> -	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> -	sdata->drop_unencrypted =3D bss->capability &
> -		WLAN_CAPABILITY_PRIVACY ? 1 : 0;
> -
> -	res =3D ieee80211_set_freq(local, bss->freq);
> -
> -	if (local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS) {
> -		printk(KERN_DEBUG "%s: IBSS not allowed on frequency "
> -		       "%d MHz\n", dev->name, local->oper_channel->center_freq);
> -		return -1;
> -	}
> -
> -	/* Set beacon template based on scan results */
> -	skb =3D dev_alloc_skb(local->hw.extra_tx_headroom + 400);
> -	do {
> -		if (!skb)
> -			break;
> -
> -		skb_reserve(skb, local->hw.extra_tx_headroom);
> -
> -		mgmt =3D (struct ieee80211_mgmt *)
> -			skb_put(skb, 24 + sizeof(mgmt->u.beacon));
> -		memset(mgmt, 0, 24 + sizeof(mgmt->u.beacon));
> -		mgmt->frame_control =3D IEEE80211_FC(IEEE80211_FTYPE_MGMT,
> -						   IEEE80211_STYPE_BEACON);
> -		memset(mgmt->da, 0xff, ETH_ALEN);
> -		memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
> -		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
> -		mgmt->u.beacon.beacon_int =3D
> -			cpu_to_le16(local->hw.conf.beacon_int);
> -		mgmt->u.beacon.capab_info =3D cpu_to_le16(bss->capability);
> -
> -		pos =3D skb_put(skb, 2 + ifsta->ssid_len);
> -		*pos++ =3D WLAN_EID_SSID;
> -		*pos++ =3D ifsta->ssid_len;
> -		memcpy(pos, ifsta->ssid, ifsta->ssid_len);
> -
> -		rates =3D bss->supp_rates_len;
> -		if (rates > 8)
> -			rates =3D 8;
> -		pos =3D skb_put(skb, 2 + rates);
> -		*pos++ =3D WLAN_EID_SUPP_RATES;
> -		*pos++ =3D rates;
> -		memcpy(pos, bss->supp_rates, rates);
> -
> -		if (bss->band =3D=3D IEEE80211_BAND_2GHZ) {
> -			pos =3D skb_put(skb, 2 + 1);
> -			*pos++ =3D WLAN_EID_DS_PARAMS;
> -			*pos++ =3D 1;
> -			*pos++ =3D ieee80211_frequency_to_channel(bss->freq);
> -		}
> -
> -		pos =3D skb_put(skb, 2 + 2);
> -		*pos++ =3D WLAN_EID_IBSS_PARAMS;
> -		*pos++ =3D 2;
> -		/* FIX: set ATIM window based on scan results */
> -		*pos++ =3D 0;
> -		*pos++ =3D 0;
> -
> -		if (bss->supp_rates_len > 8) {
> -			rates =3D bss->supp_rates_len - 8;
> -			pos =3D skb_put(skb, 2 + rates);
> -			*pos++ =3D WLAN_EID_EXT_SUPP_RATES;
> -			*pos++ =3D rates;
> -			memcpy(pos, &bss->supp_rates[8], rates);
> -		}
> -
> -		memset(&control, 0, sizeof(control));
> -		rate_control_get_rate(dev, sband, skb, &ratesel);
> -		if (!ratesel.rate) {
> -			printk(KERN_DEBUG "%s: Failed to determine TX rate "
> -			       "for IBSS beacon\n", dev->name);
> -			break;
> -		}
> -		control.vif =3D &sdata->vif;
> -		control.tx_rate =3D ratesel.rate;
> -		if (sdata->bss_conf.use_short_preamble &&
> -		    ratesel.rate->flags & IEEE80211_RATE_SHORT_PREAMBLE)
> -			control.flags |=3D IEEE80211_TXCTL_SHORT_PREAMBLE;
> -		control.antenna_sel_tx =3D local->hw.conf.antenna_sel_tx;
> -		control.flags |=3D IEEE80211_TXCTL_NO_ACK;
> -		control.retry_limit =3D 1;
> -
> -		ifsta->probe_resp =3D skb_copy(skb, GFP_ATOMIC);
> -		if (ifsta->probe_resp) {
> -			mgmt =3D (struct ieee80211_mgmt *)
> -				ifsta->probe_resp->data;
> -			mgmt->frame_control =3D
> -				IEEE80211_FC(IEEE80211_FTYPE_MGMT,
> -					     IEEE80211_STYPE_PROBE_RESP);
> -		} else {
> -			printk(KERN_DEBUG "%s: Could not allocate ProbeResp "
> -			       "template for IBSS\n", dev->name);
> -		}
> -
> -		if (local->ops->beacon_update &&
> -		    local->ops->beacon_update(local_to_hw(local),
> -					     skb, &control) =3D=3D 0) {
> -			printk(KERN_DEBUG "%s: Configured IBSS beacon "
> -			       "template based on scan results\n", dev->name);
> -			skb =3D NULL;
> -		}
> -
> -		rates =3D 0;
> -		sband =3D local->hw.wiphy->bands[local->hw.conf.channel->band];
> -		for (i =3D 0; i < bss->supp_rates_len; i++) {
> -			int bitrate =3D (bss->supp_rates[i] & 0x7f) * 5;
> -			for (j =3D 0; j < sband->n_bitrates; j++)
> -				if (sband->bitrates[j].bitrate =3D=3D bitrate)
> -					rates |=3D BIT(j);
> -		}
> -		ifsta->supp_rates_bits[local->hw.conf.channel->band] =3D rates;
> -	} while (0);
> -
> -	if (skb) {
> -		printk(KERN_DEBUG "%s: Failed to configure IBSS beacon "
> -		       "template\n", dev->name);
> -		dev_kfree_skb(skb);
> -	}
> -
> -	ifsta->state =3D IEEE80211_IBSS_JOINED;
> -	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
> -
> -	ieee80211_rx_bss_put(dev, bss);
> -
> -	return res;
> -}
> -
> =20
>  static int ieee80211_sta_create_ibss(struct net_device *dev,
>  				     struct ieee80211_if_sta *ifsta)
>=20
>=20

--=-Xbn6Y7wWA+sTq2tt8yLg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7WLHaVg1VMiehFYAQJfnxAAkiT5ca/t71xrv32B+AveACEYjSPY5AuV
mxITAnQrdW1HZA2/kjMgkjcO7FStnNF8ZIgsz7NB3j5heYgE3XY5v3ALD/TDfyR3
N/D/GV0VF0NWb1Dn0bG7HsGoyPlXy0a0xae2x8gioJ1uwj6L6X65z2my6utPHgGc
pa9zFmstJXNFqTFG1EFBnSXhJ1hSj0erCztRPPgwK9WrT0Ccc5GAN/Mj2dJ7LOpC
6AP5z7QdvasYPs5Dpq+bf0Nhpwv/gswwmxnW265ZwCVgBBjuoLYDRzuUTqNEnCiq
VJ5lWJbPDsFxYACraL2rBKv8QHW6q0EM1Rpzf4lV5GyJ2hvZbjU5mMHTcmO6CaZG
gzncszWlgFjaSPo5IYj+bbPo+LOdlGSFo/pHEDlPGUkZWw/GDHTpOumtnXFTbRDC
ckzgCFKQpg9Gz0NG4rTNqpmViASYLrDdG9baDn8iGp9Fm9I1uFZeH0DAoJHX5SQR
Iq5wGhxZASlbDK9zNl7585Rxm6G+KTrnWPMWZHYhBmVvU+346qv1pncJHNl3KAbV
TXtozAz4+V/5mOhpXVVlR5YnlueMWdMdc1lid21uHROWcH2/gjgIE3KBlX6mlqzI
v3M8vh0asYwrLrMn2Ck++2Tp2064m4L5i9+tg7LLz8/FVS7JnJ7d9UQ+35y+6ZJE
pnjLIctbhX4=
=sJuO
-----END PGP SIGNATURE-----

--=-Xbn6Y7wWA+sTq2tt8yLg--

