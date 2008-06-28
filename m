Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49352 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbYF1IIk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 04:08:40 -0400
Subject: Re: [PATCH 1/1] mac80211: removing duplicated parsing of
	information elements
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Ester Kummer <ester.kummer@intel.com>
In-Reply-To: <1214582088-1138-1-git-send-email-tomas.winkler@intel.com>
References: <1214582088-1138-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ctrv27bfqHXdv6VPYUnU"
Date: Sat, 28 Jun 2008 10:08:26 +0200
Message-Id: <1214640506.5507.12.camel@johannes.berg> (sfid-20080628_100847_500263_A9B2B950)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ctrv27bfqHXdv6VPYUnU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-06-27 at 18:54 +0300, Tomas Winkler wrote:
> From: Ester Kummer <ester.kummer@intel.com>
>=20
> This patch removes the duplicated parsing of information elements
> in ieee80211_rx_bss_info and in ieee_rx_mgmt_beacon

Looks good to me, thanks.

> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>=20
> Signed-off-by: Ester Kummer <ester.kummer@intel.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/mlme.c |  188 ++++++++++++++++++++++++++-------------------=
------
>  1 files changed, 97 insertions(+), 91 deletions(-)
>=20
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 55659a7..0f8fed3 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -2537,11 +2537,10 @@ static void ieee80211_rx_bss_info(struct net_devi=
ce *dev,
>  				  struct ieee80211_mgmt *mgmt,
>  				  size_t len,
>  				  struct ieee80211_rx_status *rx_status,
> +				  struct ieee802_11_elems *elems,
>  				  int beacon)
>  {
>  	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
> -	struct ieee802_11_elems elems;
> -	size_t baselen;
>  	int freq, clen;
>  	struct ieee80211_sta_bss *bss;
>  	struct sta_info *sta;
> @@ -2560,29 +2559,24 @@ static void ieee80211_rx_bss_info(struct net_devi=
ce *dev,
>  	       print_mac(mac, mgmt->sa), print_mac(mac2, mgmt->da));
>  #endif
> =20
> -	baselen =3D (u8 *) mgmt->u.beacon.variable - (u8 *) mgmt;
> -	if (baselen > len)
> -		return;
> -
>  	beacon_timestamp =3D le64_to_cpu(mgmt->u.beacon.timestamp);
> -	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems);
> =20
> -	if (ieee80211_vif_is_mesh(&sdata->vif) && elems.mesh_id &&
> -	    elems.mesh_config && mesh_matches_local(&elems, dev)) {
> -		u64 rates =3D ieee80211_sta_get_rates(local, &elems,
> +	if (ieee80211_vif_is_mesh(&sdata->vif) && elems->mesh_id &&
> +	    elems->mesh_config && mesh_matches_local(elems, dev)) {
> +		u64 rates =3D ieee80211_sta_get_rates(local, elems,
>  						rx_status->band);
> =20
>  		mesh_neighbour_update(mgmt->sa, rates, dev,
> -				      mesh_peer_accepts_plinks(&elems, dev));
> +				      mesh_peer_accepts_plinks(elems, dev));
>  	}
> =20
>  	rcu_read_lock();
> =20
> -	if (sdata->vif.type =3D=3D IEEE80211_IF_TYPE_IBSS && elems.supp_rates &=
&
> +	if (sdata->vif.type =3D=3D IEEE80211_IF_TYPE_IBSS && elems->supp_rates =
&&
>  	    memcmp(mgmt->bssid, sdata->u.sta.bssid, ETH_ALEN) =3D=3D 0 &&
>  	    (sta =3D sta_info_get(local, mgmt->sa))) {
>  		u64 prev_rates;
> -		u64 supp_rates =3D ieee80211_sta_get_rates(local, &elems,
> +		u64 supp_rates =3D ieee80211_sta_get_rates(local, elems,
>  							rx_status->band);
> =20
>  		prev_rates =3D sta->supp_rates[rx_status->band];
> @@ -2607,8 +2601,8 @@ static void ieee80211_rx_bss_info(struct net_device=
 *dev,
> =20
>  	rcu_read_unlock();
> =20
> -	if (elems.ds_params && elems.ds_params_len =3D=3D 1)
> -		freq =3D ieee80211_channel_to_frequency(elems.ds_params[0]);
> +	if (elems->ds_params && elems->ds_params_len =3D=3D 1)
> +		freq =3D ieee80211_channel_to_frequency(elems->ds_params[0]);
>  	else
>  		freq =3D rx_status->freq;
> =20
> @@ -2618,23 +2612,23 @@ static void ieee80211_rx_bss_info(struct net_devi=
ce *dev,
>  		return;
> =20
>  #ifdef CONFIG_MAC80211_MESH
> -	if (elems.mesh_config)
> -		bss =3D ieee80211_rx_mesh_bss_get(dev, elems.mesh_id,
> -				elems.mesh_id_len, elems.mesh_config, freq);
> +	if (elems->mesh_config)
> +		bss =3D ieee80211_rx_mesh_bss_get(dev, elems->mesh_id,
> +				elems->mesh_id_len, elems->mesh_config, freq);
>  	else
>  #endif
>  		bss =3D ieee80211_rx_bss_get(dev, mgmt->bssid, freq,
> -					   elems.ssid, elems.ssid_len);
> +					   elems->ssid, elems->ssid_len);
>  	if (!bss) {
>  #ifdef CONFIG_MAC80211_MESH
> -		if (elems.mesh_config)
> -			bss =3D ieee80211_rx_mesh_bss_add(dev, elems.mesh_id,
> -				elems.mesh_id_len, elems.mesh_config,
> -				elems.mesh_config_len, freq);
> +		if (elems->mesh_config)
> +			bss =3D ieee80211_rx_mesh_bss_add(dev, elems->mesh_id,
> +				elems->mesh_id_len, elems->mesh_config,
> +				elems->mesh_config_len, freq);
>  		else
>  #endif
>  			bss =3D ieee80211_rx_bss_add(dev, mgmt->bssid, freq,
> -						   elems.ssid, elems.ssid_len);
> +						  elems->ssid, elems->ssid_len);
>  		if (!bss)
>  			return;
>  	} else {
> @@ -2647,43 +2641,43 @@ static void ieee80211_rx_bss_info(struct net_devi=
ce *dev,
>  	}
> =20
>  	/* save the ERP value so that it is available at association time */
> -	if (elems.erp_info && elems.erp_info_len >=3D 1) {
> -		bss->erp_value =3D elems.erp_info[0];
> +	if (elems->erp_info && elems->erp_info_len >=3D 1) {
> +		bss->erp_value =3D elems->erp_info[0];
>  		bss->has_erp_value =3D 1;
>  	}
> =20
> -	if (elems.ht_cap_elem &&
> -	     (!bss->ht_ie || bss->ht_ie_len !=3D elems.ht_cap_elem_len ||
> -	     memcmp(bss->ht_ie, elems.ht_cap_elem, elems.ht_cap_elem_len))) {
> +	if (elems->ht_cap_elem &&
> +	     (!bss->ht_ie || bss->ht_ie_len !=3D elems->ht_cap_elem_len ||
> +	     memcmp(bss->ht_ie, elems->ht_cap_elem, elems->ht_cap_elem_len))) {
>  		kfree(bss->ht_ie);
> -		bss->ht_ie =3D kmalloc(elems.ht_cap_elem_len + 2, GFP_ATOMIC);
> +		bss->ht_ie =3D kmalloc(elems->ht_cap_elem_len + 2, GFP_ATOMIC);
>  		if (bss->ht_ie) {
> -			memcpy(bss->ht_ie, elems.ht_cap_elem - 2,
> -				elems.ht_cap_elem_len + 2);
> -			bss->ht_ie_len =3D elems.ht_cap_elem_len + 2;
> +			memcpy(bss->ht_ie, elems->ht_cap_elem - 2,
> +				elems->ht_cap_elem_len + 2);
> +			bss->ht_ie_len =3D elems->ht_cap_elem_len + 2;
>  		} else
>  			bss->ht_ie_len =3D 0;
> -	} else if (!elems.ht_cap_elem && bss->ht_ie) {
> +	} else if (!elems->ht_cap_elem && bss->ht_ie) {
>  		kfree(bss->ht_ie);
>  		bss->ht_ie =3D NULL;
>  		bss->ht_ie_len =3D 0;
>  	}
> =20
> -	if (elems.ht_info_elem &&
> +	if (elems->ht_info_elem &&
>  	     (!bss->ht_add_ie ||
> -	     bss->ht_add_ie_len !=3D elems.ht_info_elem_len ||
> -	     memcmp(bss->ht_add_ie, elems.ht_info_elem,
> -			elems.ht_info_elem_len))) {
> +	     bss->ht_add_ie_len !=3D elems->ht_info_elem_len ||
> +	     memcmp(bss->ht_add_ie, elems->ht_info_elem,
> +			elems->ht_info_elem_len))) {
>  		kfree(bss->ht_add_ie);
>  		bss->ht_add_ie =3D
> -			kmalloc(elems.ht_info_elem_len + 2, GFP_ATOMIC);
> +			kmalloc(elems->ht_info_elem_len + 2, GFP_ATOMIC);
>  		if (bss->ht_add_ie) {
> -			memcpy(bss->ht_add_ie, elems.ht_info_elem - 2,
> -				elems.ht_info_elem_len + 2);
> -			bss->ht_add_ie_len =3D elems.ht_info_elem_len + 2;
> +			memcpy(bss->ht_add_ie, elems->ht_info_elem - 2,
> +				elems->ht_info_elem_len + 2);
> +			bss->ht_add_ie_len =3D elems->ht_info_elem_len + 2;
>  		} else
>  			bss->ht_add_ie_len =3D 0;
> -	} else if (!elems.ht_info_elem && bss->ht_add_ie) {
> +	} else if (!elems->ht_info_elem && bss->ht_add_ie) {
>  		kfree(bss->ht_add_ie);
>  		bss->ht_add_ie =3D NULL;
>  		bss->ht_add_ie_len =3D 0;
> @@ -2693,20 +2687,20 @@ static void ieee80211_rx_bss_info(struct net_devi=
ce *dev,
>  	bss->capability =3D le16_to_cpu(mgmt->u.beacon.capab_info);
> =20
>  	bss->supp_rates_len =3D 0;
> -	if (elems.supp_rates) {
> +	if (elems->supp_rates) {
>  		clen =3D IEEE80211_MAX_SUPP_RATES - bss->supp_rates_len;
> -		if (clen > elems.supp_rates_len)
> -			clen =3D elems.supp_rates_len;
> -		memcpy(&bss->supp_rates[bss->supp_rates_len], elems.supp_rates,
> +		if (clen > elems->supp_rates_len)
> +			clen =3D elems->supp_rates_len;
> +		memcpy(&bss->supp_rates[bss->supp_rates_len], elems->supp_rates,
>  		       clen);
>  		bss->supp_rates_len +=3D clen;
>  	}
> -	if (elems.ext_supp_rates) {
> +	if (elems->ext_supp_rates) {
>  		clen =3D IEEE80211_MAX_SUPP_RATES - bss->supp_rates_len;
> -		if (clen > elems.ext_supp_rates_len)
> -			clen =3D elems.ext_supp_rates_len;
> +		if (clen > elems->ext_supp_rates_len)
> +			clen =3D elems->ext_supp_rates_len;
>  		memcpy(&bss->supp_rates[bss->supp_rates_len],
> -		       elems.ext_supp_rates, clen);
> +		       elems->ext_supp_rates, clen);
>  		bss->supp_rates_len +=3D clen;
>  	}
> =20
> @@ -2730,33 +2724,33 @@ static void ieee80211_rx_bss_info(struct net_devi=
ce *dev,
>  		return;
>  	}
> =20
> -	if (elems.wpa &&
> -	    (!bss->wpa_ie || bss->wpa_ie_len !=3D elems.wpa_len ||
> -	     memcmp(bss->wpa_ie, elems.wpa, elems.wpa_len))) {
> +	if (elems->wpa &&
> +	    (!bss->wpa_ie || bss->wpa_ie_len !=3D elems->wpa_len ||
> +	     memcmp(bss->wpa_ie, elems->wpa, elems->wpa_len))) {
>  		kfree(bss->wpa_ie);
> -		bss->wpa_ie =3D kmalloc(elems.wpa_len + 2, GFP_ATOMIC);
> +		bss->wpa_ie =3D kmalloc(elems->wpa_len + 2, GFP_ATOMIC);
>  		if (bss->wpa_ie) {
> -			memcpy(bss->wpa_ie, elems.wpa - 2, elems.wpa_len + 2);
> -			bss->wpa_ie_len =3D elems.wpa_len + 2;
> +			memcpy(bss->wpa_ie, elems->wpa - 2, elems->wpa_len + 2);
> +			bss->wpa_ie_len =3D elems->wpa_len + 2;
>  		} else
>  			bss->wpa_ie_len =3D 0;
> -	} else if (!elems.wpa && bss->wpa_ie) {
> +	} else if (!elems->wpa && bss->wpa_ie) {
>  		kfree(bss->wpa_ie);
>  		bss->wpa_ie =3D NULL;
>  		bss->wpa_ie_len =3D 0;
>  	}
> =20
> -	if (elems.rsn &&
> -	    (!bss->rsn_ie || bss->rsn_ie_len !=3D elems.rsn_len ||
> -	     memcmp(bss->rsn_ie, elems.rsn, elems.rsn_len))) {
> +	if (elems->rsn &&
> +	    (!bss->rsn_ie || bss->rsn_ie_len !=3D elems->rsn_len ||
> +	     memcmp(bss->rsn_ie, elems->rsn, elems->rsn_len))) {
>  		kfree(bss->rsn_ie);
> -		bss->rsn_ie =3D kmalloc(elems.rsn_len + 2, GFP_ATOMIC);
> +		bss->rsn_ie =3D kmalloc(elems->rsn_len + 2, GFP_ATOMIC);
>  		if (bss->rsn_ie) {
> -			memcpy(bss->rsn_ie, elems.rsn - 2, elems.rsn_len + 2);
> -			bss->rsn_ie_len =3D elems.rsn_len + 2;
> +			memcpy(bss->rsn_ie, elems->rsn - 2, elems->rsn_len + 2);
> +			bss->rsn_ie_len =3D elems->rsn_len + 2;
>  		} else
>  			bss->rsn_ie_len =3D 0;
> -	} else if (!elems.rsn && bss->rsn_ie) {
> +	} else if (!elems->rsn && bss->rsn_ie) {
>  		kfree(bss->rsn_ie);
>  		bss->rsn_ie =3D NULL;
>  		bss->rsn_ie_len =3D 0;
> @@ -2776,20 +2770,21 @@ static void ieee80211_rx_bss_info(struct net_devi=
ce *dev,
>  	 * inclusion of the WMM Parameters in beacons, however, is optional.
>  	 */
> =20
> -	if (elems.wmm_param &&
> -	    (!bss->wmm_ie || bss->wmm_ie_len !=3D elems.wmm_param_len ||
> -	     memcmp(bss->wmm_ie, elems.wmm_param, elems.wmm_param_len))) {
> +	if (elems->wmm_param &&
> +	    (!bss->wmm_ie || bss->wmm_ie_len !=3D elems->wmm_param_len ||
> +	     memcmp(bss->wmm_ie, elems->wmm_param, elems->wmm_param_len))) {
>  		kfree(bss->wmm_ie);
> -		bss->wmm_ie =3D kmalloc(elems.wmm_param_len + 2, GFP_ATOMIC);
> +		bss->wmm_ie =3D kmalloc(elems->wmm_param_len + 2, GFP_ATOMIC);
>  		if (bss->wmm_ie) {
> -			memcpy(bss->wmm_ie, elems.wmm_param - 2,
> -			       elems.wmm_param_len + 2);
> -			bss->wmm_ie_len =3D elems.wmm_param_len + 2;
> +			memcpy(bss->wmm_ie, elems->wmm_param - 2,
> +			       elems->wmm_param_len + 2);
> +			bss->wmm_ie_len =3D elems->wmm_param_len + 2;
>  		} else
>  			bss->wmm_ie_len =3D 0;
> -	} else if (elems.wmm_info &&
> -		    (!bss->wmm_ie || bss->wmm_ie_len !=3D elems.wmm_info_len ||
> -		     memcmp(bss->wmm_ie, elems.wmm_info, elems.wmm_info_len))) {
> +	} else if (elems->wmm_info &&
> +		    (!bss->wmm_ie || bss->wmm_ie_len !=3D elems->wmm_info_len ||
> +		     memcmp(bss->wmm_ie, elems->wmm_info,
> +						elems->wmm_info_len))) {
>  		 /* As for certain AP's Fifth bit is not set in WMM IE in
>  		  * beacon frames.So while parsing the beacon frame the
>  		  * wmm_info structure is used instead of wmm_param.
> @@ -2799,14 +2794,14 @@ static void ieee80211_rx_bss_info(struct net_devi=
ce *dev,
>  		  * n-band association.
>  		  */
>  		kfree(bss->wmm_ie);
> -		bss->wmm_ie =3D kmalloc(elems.wmm_info_len + 2, GFP_ATOMIC);
> +		bss->wmm_ie =3D kmalloc(elems->wmm_info_len + 2, GFP_ATOMIC);
>  		if (bss->wmm_ie) {
> -			memcpy(bss->wmm_ie, elems.wmm_info - 2,
> -			       elems.wmm_info_len + 2);
> -			bss->wmm_ie_len =3D elems.wmm_info_len + 2;
> +			memcpy(bss->wmm_ie, elems->wmm_info - 2,
> +			       elems->wmm_info_len + 2);
> +			bss->wmm_ie_len =3D elems->wmm_info_len + 2;
>  		} else
>  			bss->wmm_ie_len =3D 0;
> -	} else if (!elems.wmm_param && !elems.wmm_info && bss->wmm_ie) {
> +	} else if (!elems->wmm_param && !elems->wmm_info && bss->wmm_ie) {
>  		kfree(bss->wmm_ie);
>  		bss->wmm_ie =3D NULL;
>  		bss->wmm_ie_len =3D 0;
> @@ -2817,8 +2812,9 @@ static void ieee80211_rx_bss_info(struct net_device=
 *dev,
>  	    !local->sta_sw_scanning && !local->sta_hw_scanning &&
>  	    bss->capability & WLAN_CAPABILITY_IBSS &&
>  	    bss->freq =3D=3D local->oper_channel->center_freq &&
> -	    elems.ssid_len =3D=3D sdata->u.sta.ssid_len &&
> -	    memcmp(elems.ssid, sdata->u.sta.ssid, sdata->u.sta.ssid_len) =3D=3D=
 0) {
> +	    elems->ssid_len =3D=3D sdata->u.sta.ssid_len &&
> +	    memcmp(elems->ssid, sdata->u.sta.ssid,
> +				sdata->u.sta.ssid_len) =3D=3D 0) {
>  		if (rx_status->flag & RX_FLAG_TSFT) {
>  			/* in order for correct IBSS merging we need mactime
>  			 *
> @@ -2877,7 +2873,17 @@ static void ieee80211_rx_mgmt_probe_resp(struct ne=
t_device *dev,
>  					 size_t len,
>  					 struct ieee80211_rx_status *rx_status)
>  {
> -	ieee80211_rx_bss_info(dev, mgmt, len, rx_status, 0);
> +	size_t baselen;
> +	struct ieee802_11_elems elems;
> +
> +	baselen =3D (u8 *) mgmt->u.probe_resp.variable - (u8 *) mgmt;
> +	if (baselen > len)
> +		return;
> +
> +	ieee802_11_parse_elems(mgmt->u.probe_resp.variable, len - baselen,
> +				&elems);
> +
> +	ieee80211_rx_bss_info(dev, mgmt, len, rx_status, &elems, 0);
>  }
> =20
>=20
> @@ -2894,7 +2900,14 @@ static void ieee80211_rx_mgmt_beacon(struct net_de=
vice *dev,
>  	struct ieee80211_conf *conf =3D &local->hw.conf;
>  	u32 changed =3D 0;
> =20
> -	ieee80211_rx_bss_info(dev, mgmt, len, rx_status, 1);
> +	/* Process beacon from the current BSS */
> +	baselen =3D (u8 *) mgmt->u.beacon.variable - (u8 *) mgmt;
> +	if (baselen > len)
> +		return;
> +
> +	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems);
> +
> +	ieee80211_rx_bss_info(dev, mgmt, len, rx_status, &elems, 1);
> =20
>  	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
>  	if (sdata->vif.type !=3D IEEE80211_IF_TYPE_STA)
> @@ -2905,13 +2918,6 @@ static void ieee80211_rx_mgmt_beacon(struct net_de=
vice *dev,
>  	    memcmp(ifsta->bssid, mgmt->bssid, ETH_ALEN) !=3D 0)
>  		return;
> =20
> -	/* Process beacon from the current BSS */
> -	baselen =3D (u8 *) mgmt->u.beacon.variable - (u8 *) mgmt;
> -	if (baselen > len)
> -		return;
> -
> -	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems);
> -
>  	ieee80211_sta_wmm_params(dev, ifsta, elems.wmm_param,
>  				 elems.wmm_param_len);
> =20

--=-Ctrv27bfqHXdv6VPYUnU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIZfF2AAoJEKVg1VMiehFYyRYP/3UJA6v4xSndpJ7u4xCu40Qn
C6pzXVP9kW4mPMymTn2a87e6PspxsFpvrZczyHB0w1PEelaPabNkpOdmnQ2BTjeX
SsoKwM+omUhqN2H1F9TjTFGyPXcnF41+q/tZWo58rF0PTzrUNJsxg4wanN19cydH
g9FmIrJkJnD0nSeonDajebKQ/9vmhyo2vi8bvnknAlcg6z4Ar3+XqPAC0xoa4ajK
bKf0bNLqDPxUoxxXYzfEBJe0/xuxUyo5yhoZRqjnM+Teq/HCAv2mOB5eX1fpy3q6
Oe4INM3ntf10i9CKsG33XbAmya6KTOJqX6e5YHjrHbX7SlfH3RxWYVINl2nD97Wk
WYtYtPp5L3VVR2qT7C4/Ym9/jRg9/T2oQ53BTNzVIOMVqvPUP7JPShs288aU+iWy
XYrfvKShUuC9DmYLeuzzojsIFR88uVMfcpcUlaXXrYXqe+hYwVbku4FzcDJHKezp
acoh0K1kbhBgoqZOdJ23aZGQ1Zl90Cxl8jV6KprkX06DYspfUd81NTQY8I962qrF
cnTJw6wuZd4ckL28BtDyYAN5fLpfxFeMCm79sWlV4w+TDPKRW7dhz8yECqlxgmJK
xyb+1die3ZHvc726bD/ul0UP9IDzWgyT31x4L0KYVvkoNgLXwfNgTx3f/kMGb33/
yFq6Viet1Itc3mrg1IcB
=55Ps
-----END PGP SIGNATURE-----

--=-Ctrv27bfqHXdv6VPYUnU--

