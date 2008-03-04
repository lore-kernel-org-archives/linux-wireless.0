Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763535AbYCDRQx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 12:16:53 -0500
Subject: Re: [PATCH] libertas: clean up scan.c, remove zeromac and bcastmac
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200803031218.59721.hs4233@mail.mn-solutions.de>
References: <200803031218.59721.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 12:12:31 -0500
Message-Id: <1204650751.30024.6.camel@localhost.localdomain> (sfid-20080304_171703_570395_0F252341)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-03-03 at 12:18 +0100, Holger Schurig wrote:
> From: David Woodhouse <dwmw2@infradead.org>
> 
> Should be purely cosmetic apart from the removal of the two pointless
> MAC addresses.
>     
> Signed-off-by: David Woodhouse <dwmw2@infradead.org>

Acked-by: Dan Williams <dcbw@redhat.com>

> diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
> index 46f7cba..ee6c1e1 100644
> --- a/drivers/net/wireless/libertas/scan.c
> +++ b/drivers/net/wireless/libertas/scan.c
> @@ -61,9 +61,6 @@
>  //! Scan time specified in the channel TLV for each channel for active scans
>  #define MRVDRV_ACTIVE_SCAN_CHAN_TIME   100
>  
> -static const u8 zeromac[ETH_ALEN] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
> -static const u8 bcastmac[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
> -
>  static int lbs_ret_80211_scan(struct lbs_private *priv, unsigned long dummy,
>  			      struct cmd_header *resp);
>  
> @@ -73,7 +70,7 @@ static int lbs_ret_80211_scan(struct lbs_private *priv, unsigned long dummy,
>  /*                                                                   */
>  /*********************************************************************/
>  
> -static inline void clear_bss_descriptor (struct bss_descriptor * bss)
> +static inline void clear_bss_descriptor(struct bss_descriptor *bss)
>  {
>  	/* Don't blow away ->list, just BSS data */
>  	memset(bss, 0, offsetof(struct bss_descriptor, list));
> @@ -87,7 +84,8 @@ static inline void clear_bss_descriptor (struct bss_descriptor * bss)
>   *
>   *  @return         0: ssid is same, otherwise is different
>   */
> -int lbs_ssid_cmp(u8 *ssid1, u8 ssid1_len, u8 *ssid2, u8 ssid2_len)
> +int lbs_ssid_cmp(uint8_t *ssid1, uint8_t ssid1_len, uint8_t *ssid2,
> +		 uint8_t ssid2_len)
>  {
>  	if (ssid1_len != ssid2_len)
>  		return -1;
> @@ -96,73 +94,66 @@ int lbs_ssid_cmp(u8 *ssid1, u8 ssid1_len, u8 *ssid2, u8 ssid2_len)
>  }
>  
>  static inline int match_bss_no_security(struct lbs_802_11_security *secinfo,
> -			struct bss_descriptor * match_bss)
> +					struct bss_descriptor *match_bss)
>  {
> -	if (   !secinfo->wep_enabled
> -	    && !secinfo->WPAenabled
> +	if (!secinfo->wep_enabled  && !secinfo->WPAenabled
>  	    && !secinfo->WPA2enabled
>  	    && match_bss->wpa_ie[0] != MFIE_TYPE_GENERIC
>  	    && match_bss->rsn_ie[0] != MFIE_TYPE_RSN
> -	    && !(match_bss->capability & WLAN_CAPABILITY_PRIVACY)) {
> +	    && !(match_bss->capability & WLAN_CAPABILITY_PRIVACY))
>  		return 1;
> -	}
> -	return 0;
> +	else
> +		return 0;
>  }
>  
>  static inline int match_bss_static_wep(struct lbs_802_11_security *secinfo,
> -			struct bss_descriptor * match_bss)
> +				       struct bss_descriptor *match_bss)
>  {
> -	if ( secinfo->wep_enabled
> -	   && !secinfo->WPAenabled
> -	   && !secinfo->WPA2enabled
> -	   && (match_bss->capability & WLAN_CAPABILITY_PRIVACY)) {
> +	if (secinfo->wep_enabled && !secinfo->WPAenabled
> +	    && !secinfo->WPA2enabled
> +	    && (match_bss->capability & WLAN_CAPABILITY_PRIVACY))
>  		return 1;
> -	}
> -	return 0;
> +	else
> +		return 0;
>  }
>  
>  static inline int match_bss_wpa(struct lbs_802_11_security *secinfo,
> -			struct bss_descriptor * match_bss)
> +				struct bss_descriptor *match_bss)
>  {
> -	if (  !secinfo->wep_enabled
> -	   && secinfo->WPAenabled
> -	   && (match_bss->wpa_ie[0] == MFIE_TYPE_GENERIC)
> -	   /* privacy bit may NOT be set in some APs like LinkSys WRT54G
> -	      && (match_bss->capability & WLAN_CAPABILITY_PRIVACY)) {
> -	    */
> -	   ) {
> +	if (!secinfo->wep_enabled && secinfo->WPAenabled
> +	    && (match_bss->wpa_ie[0] == MFIE_TYPE_GENERIC)
> +	    /* privacy bit may NOT be set in some APs like LinkSys WRT54G
> +	    && (match_bss->capability & WLAN_CAPABILITY_PRIVACY) */
> +	   )
>  		return 1;
> -	}
> -	return 0;
> +	else
> +		return 0;
>  }
>  
>  static inline int match_bss_wpa2(struct lbs_802_11_security *secinfo,
> -			struct bss_descriptor * match_bss)
> +				 struct bss_descriptor *match_bss)
>  {
> -	if (  !secinfo->wep_enabled
> -	   && secinfo->WPA2enabled
> -	   && (match_bss->rsn_ie[0] == MFIE_TYPE_RSN)
> -	   /* privacy bit may NOT be set in some APs like LinkSys WRT54G
> -	      && (match_bss->capability & WLAN_CAPABILITY_PRIVACY)) {
> -	    */
> -	   ) {
> +	if (!secinfo->wep_enabled && secinfo->WPA2enabled
> +	    && (match_bss->rsn_ie[0] == MFIE_TYPE_RSN)
> +	    /* privacy bit may NOT be set in some APs like LinkSys WRT54G
> +            && (match_bss->capability & WLAN_CAPABILITY_PRIVACY) */
> +	   )
>  		return 1;
> -	}
> -	return 0;
> +	else
> +		return 0;
>  }
>  
>  static inline int match_bss_dynamic_wep(struct lbs_802_11_security *secinfo,
> -			struct bss_descriptor * match_bss)
> +					struct bss_descriptor *match_bss)
>  {
> -	if (  !secinfo->wep_enabled
> -	   && !secinfo->WPAenabled
> -	   && !secinfo->WPA2enabled
> -	   && (match_bss->wpa_ie[0] != MFIE_TYPE_GENERIC)
> -	   && (match_bss->rsn_ie[0] != MFIE_TYPE_RSN)
> -	   && (match_bss->capability & WLAN_CAPABILITY_PRIVACY)) {
> +	if (!secinfo->wep_enabled && !secinfo->WPAenabled
> +	    && !secinfo->WPA2enabled
> +	    && (match_bss->wpa_ie[0] != MFIE_TYPE_GENERIC)
> +	    && (match_bss->rsn_ie[0] != MFIE_TYPE_RSN)
> +	    && (match_bss->capability & WLAN_CAPABILITY_PRIVACY))
>  		return 1;
> -	}
> -	return 0;
> +	else
> +		return 0;
>  }
>  
>  static inline int is_same_network(struct bss_descriptor *src,
> @@ -197,7 +188,7 @@ static inline int is_same_network(struct bss_descriptor *src,
>   *  @return        Index in scantable, or error code if negative
>   */
>  static int is_network_compatible(struct lbs_private *priv,
> -		struct bss_descriptor * bss, u8 mode)
> +				 struct bss_descriptor *bss, uint8_t mode)
>  {
>  	int matched = 0;
>  
> @@ -211,43 +202,39 @@ static int is_network_compatible(struct lbs_private *priv,
>  	} else if ((matched = match_bss_static_wep(&priv->secinfo, bss))) {
>  		goto done;
>  	} else if ((matched = match_bss_wpa(&priv->secinfo, bss))) {
> -		lbs_deb_scan(
> -		       "is_network_compatible() WPA: wpa_ie 0x%x "
> -		       "wpa2_ie 0x%x WEP %s WPA %s WPA2 %s "
> -		       "privacy 0x%x\n", bss->wpa_ie[0], bss->rsn_ie[0],
> -		       priv->secinfo.wep_enabled ? "e" : "d",
> -		       priv->secinfo.WPAenabled ? "e" : "d",
> -		       priv->secinfo.WPA2enabled ? "e" : "d",
> -		       (bss->capability & WLAN_CAPABILITY_PRIVACY));
> +		lbs_deb_scan("is_network_compatible() WPA: wpa_ie 0x%x "
> +			     "wpa2_ie 0x%x WEP %s WPA %s WPA2 %s "
> +			     "privacy 0x%x\n", bss->wpa_ie[0], bss->rsn_ie[0],
> +			     priv->secinfo.wep_enabled ? "e" : "d",
> +			     priv->secinfo.WPAenabled ? "e" : "d",
> +			     priv->secinfo.WPA2enabled ? "e" : "d",
> +			     (bss->capability & WLAN_CAPABILITY_PRIVACY));
>  		goto done;
>  	} else if ((matched = match_bss_wpa2(&priv->secinfo, bss))) {
> -		lbs_deb_scan(
> -		       "is_network_compatible() WPA2: wpa_ie 0x%x "
> -		       "wpa2_ie 0x%x WEP %s WPA %s WPA2 %s "
> -		       "privacy 0x%x\n", bss->wpa_ie[0], bss->rsn_ie[0],
> -		       priv->secinfo.wep_enabled ? "e" : "d",
> -		       priv->secinfo.WPAenabled ? "e" : "d",
> -		       priv->secinfo.WPA2enabled ? "e" : "d",
> -		       (bss->capability & WLAN_CAPABILITY_PRIVACY));
> +		lbs_deb_scan("is_network_compatible() WPA2: wpa_ie 0x%x "
> +			     "wpa2_ie 0x%x WEP %s WPA %s WPA2 %s "
> +			     "privacy 0x%x\n", bss->wpa_ie[0], bss->rsn_ie[0],
> +			     priv->secinfo.wep_enabled ? "e" : "d",
> +			     priv->secinfo.WPAenabled ? "e" : "d",
> +			     priv->secinfo.WPA2enabled ? "e" : "d",
> +			     (bss->capability & WLAN_CAPABILITY_PRIVACY));
>  		goto done;
>  	} else if ((matched = match_bss_dynamic_wep(&priv->secinfo, bss))) {
> -		lbs_deb_scan(
> -		       "is_network_compatible() dynamic WEP: "
> -		       "wpa_ie 0x%x wpa2_ie 0x%x privacy 0x%x\n",
> -		       bss->wpa_ie[0], bss->rsn_ie[0],
> -		       (bss->capability & WLAN_CAPABILITY_PRIVACY));
> +		lbs_deb_scan("is_network_compatible() dynamic WEP: "
> +			     "wpa_ie 0x%x wpa2_ie 0x%x privacy 0x%x\n",
> +			     bss->wpa_ie[0], bss->rsn_ie[0],
> +			     (bss->capability & WLAN_CAPABILITY_PRIVACY));
>  		goto done;
>  	}
>  
>  	/* bss security settings don't match those configured on card */
> -	lbs_deb_scan(
> -	       "is_network_compatible() FAILED: wpa_ie 0x%x "
> -	       "wpa2_ie 0x%x WEP %s WPA %s WPA2 %s privacy 0x%x\n",
> -	       bss->wpa_ie[0], bss->rsn_ie[0],
> -	       priv->secinfo.wep_enabled ? "e" : "d",
> -	       priv->secinfo.WPAenabled ? "e" : "d",
> -	       priv->secinfo.WPA2enabled ? "e" : "d",
> -	       (bss->capability & WLAN_CAPABILITY_PRIVACY));
> +	lbs_deb_scan("is_network_compatible() FAILED: wpa_ie 0x%x "
> +		     "wpa2_ie 0x%x WEP %s WPA %s WPA2 %s privacy 0x%x\n",
> +		     bss->wpa_ie[0], bss->rsn_ie[0],
> +		     priv->secinfo.wep_enabled ? "e" : "d",
> +		     priv->secinfo.WPAenabled ? "e" : "d",
> +		     priv->secinfo.WPA2enabled ? "e" : "d",
> +		     (bss->capability & WLAN_CAPABILITY_PRIVACY));
>  
>  done:
>  	lbs_deb_leave_args(LBS_DEB_SCAN, "matched: %d", matched);
> @@ -294,16 +281,15 @@ void lbs_scan_worker(struct work_struct *work)
>   *  @return              void
>   */
>  static int lbs_scan_create_channel_list(struct lbs_private *priv,
> -					  struct chanscanparamset * scanchanlist,
> -					  u8 filteredscan)
> +					struct chanscanparamset *scanchanlist,
> +					uint8_t filteredscan)
>  {
> -
>  	struct region_channel *scanregion;
>  	struct chan_freq_power *cfp;
>  	int rgnidx;
>  	int chanidx;
>  	int nextchan;
> -	u8 scantype;
> +	uint8_t scantype;
>  
>  	chanidx = 0;
>  
> @@ -314,9 +300,8 @@ static int lbs_scan_create_channel_list(struct lbs_private *priv,
>  	scantype = CMD_SCAN_TYPE_ACTIVE;
>  
>  	for (rgnidx = 0; rgnidx < ARRAY_SIZE(priv->region_channel); rgnidx++) {
> -		if (priv->enable11d &&
> -		    (priv->connect_status != LBS_CONNECTED) &&
> -		    (priv->mesh_connect_status != LBS_CONNECTED)) {
> +		if (priv->enable11d && (priv->connect_status != LBS_CONNECTED)
> +		    && (priv->mesh_connect_status != LBS_CONNECTED)) {
>  			/* Scan all the supported chan for the first scan */
>  			if (!priv->universal_channel[rgnidx].valid)
>  				continue;
> @@ -331,45 +316,30 @@ static int lbs_scan_create_channel_list(struct lbs_private *priv,
>  			scanregion = &priv->region_channel[rgnidx];
>  		}
>  
> -		for (nextchan = 0;
> -		     nextchan < scanregion->nrcfp; nextchan++, chanidx++) {
> +		for (nextchan = 0; nextchan < scanregion->nrcfp; nextchan++, chanidx++) {
> +			struct chanscanparamset *chan = &scanchanlist[chanidx];
>  
>  			cfp = scanregion->CFP + nextchan;
>  
> -			if (priv->enable11d) {
> -				scantype =
> -				    lbs_get_scan_type_11d(cfp->channel,
> -							   &priv->
> -							   parsed_region_chan);
> -			}
> +			if (priv->enable11d)
> +				scantype = lbs_get_scan_type_11d(cfp->channel,
> +								 &priv->parsed_region_chan);
>  
> -			switch (scanregion->band) {
> -			case BAND_B:
> -			case BAND_G:
> -			default:
> -				scanchanlist[chanidx].radiotype =
> -				    CMD_SCAN_RADIO_TYPE_BG;
> -				break;
> -			}
> +			if (scanregion->band == BAND_B || scanregion->band == BAND_G)
> +				chan->radiotype = CMD_SCAN_RADIO_TYPE_BG;
>  
>  			if (scantype == CMD_SCAN_TYPE_PASSIVE) {
> -				scanchanlist[chanidx].maxscantime =
> -				    cpu_to_le16(MRVDRV_PASSIVE_SCAN_CHAN_TIME);
> -				scanchanlist[chanidx].chanscanmode.passivescan =
> -				    1;
> +				chan->maxscantime = cpu_to_le16(MRVDRV_PASSIVE_SCAN_CHAN_TIME);
> +				chan->chanscanmode.passivescan = 1;
>  			} else {
> -				scanchanlist[chanidx].maxscantime =
> -				    cpu_to_le16(MRVDRV_ACTIVE_SCAN_CHAN_TIME);
> -				scanchanlist[chanidx].chanscanmode.passivescan =
> -				    0;
> +				chan->maxscantime = cpu_to_le16(MRVDRV_ACTIVE_SCAN_CHAN_TIME);
> +				chan->chanscanmode.passivescan = 0;
>  			}
>  
> -			scanchanlist[chanidx].channumber = cfp->channel;
> +			chan->channumber = cfp->channel;
>  
> -			if (filteredscan) {
> -				scanchanlist[chanidx].chanscanmode.
> -				    disablechanfilt = 1;
> -			}
> +			if (filteredscan)
> +				chan->chanscanmode.disablechanfilt = 1;
>  		}
>  	}
>  	return chanidx;
> @@ -383,11 +353,11 @@ static int lbs_scan_create_channel_list(struct lbs_private *priv,
>   * length          06 00
>   * ssid            4d 4e 54 45 53 54
>   */
> -static int lbs_scan_add_ssid_tlv(u8 *tlv,
> -	const struct lbs_ioctl_user_scan_cfg *user_cfg)
> +static int lbs_scan_add_ssid_tlv(uint8_t *tlv,
> +				 const struct lbs_ioctl_user_scan_cfg *user_cfg)
>  {
> -	struct mrvlietypes_ssidparamset *ssid_tlv =
> -		(struct mrvlietypes_ssidparamset *)tlv;
> +	struct mrvlietypes_ssidparamset *ssid_tlv = (void *)tlv;
> +
>  	ssid_tlv->header.type = cpu_to_le16(TLV_TYPE_SSID);
>  	ssid_tlv->header.len = cpu_to_le16(user_cfg->ssid_len);
>  	memcpy(ssid_tlv->ssid, user_cfg->ssid, user_cfg->ssid_len);
> @@ -420,13 +390,12 @@ static int lbs_scan_add_ssid_tlv(u8 *tlv,
>   * channel 13      00 0d 00 00 00 64 00
>   *
>   */
> -static int lbs_scan_add_chanlist_tlv(u8 *tlv,
> -	struct chanscanparamset *chan_list,
> -	int chan_count)
> +static int lbs_scan_add_chanlist_tlv(uint8_t *tlv,
> +				     struct chanscanparamset *chan_list,
> +				     int chan_count)
>  {
> -	size_t size = sizeof(struct chanscanparamset) * chan_count;
> -	struct mrvlietypes_chanlistparamset *chan_tlv =
> -		(struct mrvlietypes_chanlistparamset *) tlv;
> +	size_t size = sizeof(struct chanscanparamset) *chan_count;
> +	struct mrvlietypes_chanlistparamset *chan_tlv = (void *)tlv;
>  
>  	chan_tlv->header.type = cpu_to_le16(TLV_TYPE_CHANLIST);
>  	memcpy(chan_tlv->chanscanparam, chan_list, size);
> @@ -445,11 +414,10 @@ static int lbs_scan_add_chanlist_tlv(u8 *tlv,
>   * The rates are in lbs_bg_rates[], but for the 802.11b
>   * rates the high bit isn't set.
>   */
> -static int lbs_scan_add_rates_tlv(u8 *tlv)
> +static int lbs_scan_add_rates_tlv(uint8_t *tlv)
>  {
>  	int i;
> -	struct mrvlietypes_ratesparamset *rate_tlv =
> -		(struct mrvlietypes_ratesparamset *) tlv;
> +	struct mrvlietypes_ratesparamset *rate_tlv = (void *)tlv;
>  
>  	rate_tlv->header.type = cpu_to_le16(TLV_TYPE_RATES);
>  	tlv += sizeof(rate_tlv->header);
> @@ -537,14 +505,14 @@ out:
>   *  @return              0 or < 0 if error
>   */
>  int lbs_scan_networks(struct lbs_private *priv,
> -	const struct lbs_ioctl_user_scan_cfg *user_cfg,
> -                       int full_scan)
> +		      const struct lbs_ioctl_user_scan_cfg *user_cfg,
> +		      int full_scan)
>  {
>  	int ret = -ENOMEM;
>  	struct chanscanparamset *chan_list;
>  	struct chanscanparamset *curr_chans;
>  	int chan_count;
> -	u8 bsstype = CMD_BSS_TYPE_ANY;
> +	uint8_t bsstype = CMD_BSS_TYPE_ANY;
>  	int numchannels = MRVDRV_CHANNELS_PER_SCAN_CMD;
>  	int filteredscan = 0;
>  	union iwreq_data wrqu;
> @@ -554,8 +522,7 @@ int lbs_scan_networks(struct lbs_private *priv,
>  	DECLARE_MAC_BUF(mac);
>  #endif
>  
> -	lbs_deb_enter_args(LBS_DEB_SCAN, "full_scan %d",
> -		full_scan);
> +	lbs_deb_enter_args(LBS_DEB_SCAN, "full_scan %d", full_scan);
>  
>  	/* Cancel any partial outstanding partial scans if this scan
>  	 * is a full scan.
> @@ -567,26 +534,24 @@ int lbs_scan_networks(struct lbs_private *priv,
>  	if (user_cfg) {
>  		if (user_cfg->bsstype)
>  			bsstype = user_cfg->bsstype;
> -		if (compare_ether_addr(user_cfg->bssid, &zeromac[0]) != 0) {
> +		if (!is_zero_ether_addr(user_cfg->bssid)) {
>  			numchannels = MRVDRV_MAX_CHANNELS_PER_SCAN;
>  			filteredscan = 1;
>  		}
>  	}
> -	lbs_deb_scan("numchannels %d, bsstype %d, "
> -		"filteredscan %d\n",
> -		numchannels, bsstype, filteredscan);
> +	lbs_deb_scan("numchannels %d, bsstype %d, filteredscan %d\n",
> +		     numchannels, bsstype, filteredscan);
>  
>  	/* Create list of channels to scan */
>  	chan_list = kzalloc(sizeof(struct chanscanparamset) *
> -				LBS_IOCTL_USER_SCAN_CHAN_MAX, GFP_KERNEL);
> +			    LBS_IOCTL_USER_SCAN_CHAN_MAX, GFP_KERNEL);
>  	if (!chan_list) {
>  		lbs_pr_alert("SCAN: chan_list empty\n");
>  		goto out;
>  	}
>  
>  	/* We want to scan all channels */
> -	chan_count = lbs_scan_create_channel_list(priv, chan_list,
> -		filteredscan);
> +	chan_count = lbs_scan_create_channel_list(priv, chan_list, filteredscan);
>  
>  	netif_stop_queue(priv->dev);
>  	netif_carrier_off(priv->dev);
> @@ -613,9 +578,9 @@ int lbs_scan_networks(struct lbs_private *priv,
>  	while (chan_count) {
>  		int to_scan = min(numchannels, chan_count);
>  		lbs_deb_scan("scanning %d of %d channels\n",
> -			to_scan, chan_count);
> +			     to_scan, chan_count);
>  		ret = lbs_do_scan(priv, bsstype, curr_chans,
> -			to_scan, user_cfg);
> +				  to_scan, user_cfg);
>  		if (ret) {
>  			lbs_pr_err("SCAN_CMD failed\n");
>  			goto out2;
> @@ -624,8 +589,7 @@ int lbs_scan_networks(struct lbs_private *priv,
>  		chan_count -= to_scan;
>  
>  		/* somehow schedule the next part of the scan */
> -		if (chan_count &&
> -		    !full_scan &&
> +		if (chan_count && !full_scan &&
>  		    !priv->surpriseremoved) {
>  			/* -1 marks just that we're currently scanning */
>  			if (priv->last_scanned_channel < 0)
> @@ -634,7 +598,7 @@ int lbs_scan_networks(struct lbs_private *priv,
>  				priv->last_scanned_channel += to_scan;
>  			cancel_delayed_work(&priv->scan_work);
>  			queue_delayed_work(priv->work_thread, &priv->scan_work,
> -				msecs_to_jiffies(300));
> +					   msecs_to_jiffies(300));
>  			/* skip over GIWSCAN event */
>  			goto out;
>  		}
> @@ -649,8 +613,8 @@ int lbs_scan_networks(struct lbs_private *priv,
>  	lbs_deb_scan("scan table:\n");
>  	list_for_each_entry(iter, &priv->network_list, list)
>  		lbs_deb_scan("%02d: BSSID %s, RSSI %d, SSID '%s'\n",
> -		       i++, print_mac(mac, iter->bssid), (s32) iter->rssi,
> -		       escape_essid(iter->ssid, iter->ssid_len));
> +			     i++, print_mac(mac, iter->bssid), (int)iter->rssi,
> +			     escape_essid(iter->ssid, iter->ssid_len));
>  	mutex_unlock(&priv->lock);
>  #endif
>  
> @@ -695,7 +659,7 @@ out:
>   *  @return             0 or -1
>   */
>  static int lbs_process_bss(struct bss_descriptor *bss,
> -				u8 ** pbeaconinfo, int *bytesleft)
> +			   uint8_t **pbeaconinfo, int *bytesleft)
>  {
>  	struct ieeetypes_fhparamset *pFH;
>  	struct ieeetypes_dsparamset *pDS;
> @@ -703,9 +667,9 @@ static int lbs_process_bss(struct bss_descriptor *bss,
>  	struct ieeetypes_ibssparamset *pibss;
>  	DECLARE_MAC_BUF(mac);
>  	struct ieeetypes_countryinfoset *pcountryinfo;
> -	u8 *pos, *end, *p;
> -	u8 n_ex_rates = 0, got_basic_rates = 0, n_basic_rates = 0;
> -	u16 beaconsize = 0;
> +	uint8_t *pos, *end, *p;
> +	uint8_t n_ex_rates = 0, got_basic_rates = 0, n_basic_rates = 0;
> +	uint16_t beaconsize = 0;
>  	int ret;
>  
>  	lbs_deb_enter(LBS_DEB_SCAN);
> @@ -777,12 +741,11 @@ static int lbs_process_bss(struct bss_descriptor *bss,
>  
>  	/* process variable IE */
>  	while (pos <= end - 2) {
> -		struct ieee80211_info_element * elem =
> -			(struct ieee80211_info_element *) pos;
> +		struct ieee80211_info_element * elem = (void *)pos;
>  
>  		if (pos + elem->len > end) {
>  			lbs_deb_scan("process_bss: error in processing IE, "
> -			       "bytes left < IE length\n");
> +				     "bytes left < IE length\n");
>  			break;
>  		}
>  
> @@ -796,7 +759,7 @@ static int lbs_process_bss(struct bss_descriptor *bss,
>  			break;
>  
>  		case MFIE_TYPE_RATES:
> -			n_basic_rates = min_t(u8, MAX_RATES, elem->len);
> +			n_basic_rates = min_t(uint8_t, MAX_RATES, elem->len);
>  			memcpy(bss->rates, elem->data, n_basic_rates);
>  			got_basic_rates = 1;
>  			lbs_deb_scan("got RATES IE\n");
> @@ -837,19 +800,16 @@ static int lbs_process_bss(struct bss_descriptor *bss,
>  			lbs_deb_scan("got COUNTRY IE\n");
>  			if (pcountryinfo->len < sizeof(pcountryinfo->countrycode)
>  			    || pcountryinfo->len > 254) {
> -				lbs_deb_scan("process_bss: 11D- Err "
> -				       "CountryInfo len %d, min %zd, max 254\n",
> -				       pcountryinfo->len,
> -				       sizeof(pcountryinfo->countrycode));
> +				lbs_deb_scan("process_bss: 11D- Err CountryInfo len %d, min %zd, max 254\n",
> +					     pcountryinfo->len, sizeof(pcountryinfo->countrycode));
>  				ret = -1;
>  				goto done;
>  			}
>  
> -			memcpy(&bss->countryinfo,
> -			       pcountryinfo, pcountryinfo->len + 2);
> +			memcpy(&bss->countryinfo, pcountryinfo, pcountryinfo->len + 2);
>  			lbs_deb_hex(LBS_DEB_SCAN, "process_bss: 11d countryinfo",
> -				(u8 *) pcountryinfo,
> -				(u32) (pcountryinfo->len + 2));
> +				    (uint8_t *) pcountryinfo,
> +				    (int) (pcountryinfo->len + 2));
>  			break;
>  
>  		case MFIE_TYPE_RATES_EX:
> @@ -873,26 +833,19 @@ static int lbs_process_bss(struct bss_descriptor *bss,
>  
>  		case MFIE_TYPE_GENERIC:
>  			if (elem->len >= 4 &&
> -			    elem->data[0] == 0x00 &&
> -			    elem->data[1] == 0x50 &&
> -			    elem->data[2] == 0xf2 &&
> -			    elem->data[3] == 0x01) {
> -				bss->wpa_ie_len = min(elem->len + 2,
> -				                      MAX_WPA_IE_LEN);
> +			    elem->data[0] == 0x00 && elem->data[1] == 0x50 &&
> +			    elem->data[2] == 0xf2 && elem->data[3] == 0x01) {
> +				bss->wpa_ie_len = min(elem->len + 2, MAX_WPA_IE_LEN);
>  				memcpy(bss->wpa_ie, elem, bss->wpa_ie_len);
>  				lbs_deb_scan("got WPA IE\n");
> -				lbs_deb_hex(LBS_DEB_SCAN, "WPA IE", bss->wpa_ie,
> -				            elem->len);
> +				lbs_deb_hex(LBS_DEB_SCAN, "WPA IE", bss->wpa_ie, elem->len);
>  			} else if (elem->len >= MARVELL_MESH_IE_LENGTH &&
> -			    elem->data[0] == 0x00 &&
> -			    elem->data[1] == 0x50 &&
> -			    elem->data[2] == 0x43 &&
> -			    elem->data[3] == 0x04) {
> +				   elem->data[0] == 0x00 && elem->data[1] == 0x50 &&
> +				   elem->data[2] == 0x43 && elem->data[3] == 0x04) {
>  				lbs_deb_scan("got mesh IE\n");
>  				bss->mesh = 1;
>  			} else {
> -				lbs_deb_scan("got generiec IE: "
> -					"%02x:%02x:%02x:%02x, len %d\n",
> +				lbs_deb_scan("got generic IE: %02x:%02x:%02x:%02x, len %d\n",
>  					elem->data[0], elem->data[1],
>  					elem->data[2], elem->data[3],
>  					elem->len);
> @@ -904,12 +857,12 @@ static int lbs_process_bss(struct bss_descriptor *bss,
>  			bss->rsn_ie_len = min(elem->len + 2, MAX_WPA_IE_LEN);
>  			memcpy(bss->rsn_ie, elem, bss->rsn_ie_len);
>  			lbs_deb_hex(LBS_DEB_SCAN, "process_bss: RSN_IE",
> -				bss->rsn_ie, elem->len);
> +				    bss->rsn_ie, elem->len);
>  			break;
>  
>  		default:
>  			lbs_deb_scan("got IE 0x%04x, len %d\n",
> -				elem->id, elem->len);
> +				     elem->id, elem->len);
>  			break;
>  		}
>  
> @@ -939,18 +892,17 @@ done:
>   *  @return         index in BSSID list, or error return code (< 0)
>   */
>  struct bss_descriptor *lbs_find_bssid_in_list(struct lbs_private *priv,
> -		u8 * bssid, u8 mode)
> +					      uint8_t *bssid, uint8_t mode)
>  {
> -	struct bss_descriptor * iter_bss;
> -	struct bss_descriptor * found_bss = NULL;
> +	struct bss_descriptor *iter_bss;
> +	struct bss_descriptor *found_bss = NULL;
>  
>  	lbs_deb_enter(LBS_DEB_SCAN);
>  
>  	if (!bssid)
>  		goto out;
>  
> -	lbs_deb_hex(LBS_DEB_SCAN, "looking for",
> -		bssid, ETH_ALEN);
> +	lbs_deb_hex(LBS_DEB_SCAN, "looking for", bssid, ETH_ALEN);
>  
>  	/* Look through the scan table for a compatible match.  The loop will
>  	 *   continue past a matched bssid that is not compatible in case there
> @@ -992,10 +944,11 @@ out:
>   *  @return         index in BSSID list
>   */
>  struct bss_descriptor *lbs_find_ssid_in_list(struct lbs_private *priv,
> -		   u8 *ssid, u8 ssid_len, u8 * bssid, u8 mode,
> -		   int channel)
> +					     uint8_t *ssid, uint8_t ssid_len,
> +					     uint8_t *bssid, uint8_t mode,
> +					     int channel)
>  {
> -	u8 bestrssi = 0;
> +	uint8_t bestrssi = 0;
>  	struct bss_descriptor * iter_bss = NULL;
>  	struct bss_descriptor * found_bss = NULL;
>  	struct bss_descriptor * tmp_oldest = NULL;
> @@ -1010,7 +963,7 @@ struct bss_descriptor *lbs_find_ssid_in_list(struct lbs_private *priv,
>  			tmp_oldest = iter_bss;
>  
>  		if (lbs_ssid_cmp(iter_bss->ssid, iter_bss->ssid_len,
> -		                      ssid, ssid_len) != 0)
> +				 ssid, ssid_len) != 0)
>  			continue; /* ssid doesn't match */
>  		if (bssid && compare_ether_addr(iter_bss->bssid, bssid) != 0)
>  			continue; /* bssid doesn't match */
> @@ -1060,13 +1013,12 @@ out:
>   *
>   *  @return         index in BSSID list
>   */
> -static struct bss_descriptor *lbs_find_best_ssid_in_list(
> -	struct lbs_private *priv,
> -	u8 mode)
> +static struct bss_descriptor *lbs_find_best_ssid_in_list(struct lbs_private *priv,
> +							 uint8_t mode)
>  {
> -	u8 bestrssi = 0;
> -	struct bss_descriptor * iter_bss;
> -	struct bss_descriptor * best_bss = NULL;
> +	uint8_t bestrssi = 0;
> +	struct bss_descriptor *iter_bss;
> +	struct bss_descriptor *best_bss = NULL;
>  
>  	lbs_deb_enter(LBS_DEB_SCAN);
>  
> @@ -1108,11 +1060,12 @@ static struct bss_descriptor *lbs_find_best_ssid_in_list(
>   *
>   *  @return             0--success, otherwise--fail
>   */
> -int lbs_find_best_network_ssid(struct lbs_private *priv,
> -		u8 *out_ssid, u8 *out_ssid_len, u8 preferred_mode, u8 *out_mode)
> +int lbs_find_best_network_ssid(struct lbs_private *priv, uint8_t *out_ssid,
> +			       uint8_t *out_ssid_len, uint8_t preferred_mode,
> +			       uint8_t *out_mode)
>  {
>  	int ret = -1;
> -	struct bss_descriptor * found;
> +	struct bss_descriptor *found;
>  
>  	lbs_deb_enter(LBS_DEB_SCAN);
>  
> @@ -1147,14 +1100,14 @@ out:
>   *
>   *  @return                0-success, otherwise fail
>   */
> -int lbs_send_specific_ssid_scan(struct lbs_private *priv,
> -			u8 *ssid, u8 ssid_len, u8 clear_ssid)
> +int lbs_send_specific_ssid_scan(struct lbs_private *priv, uint8_t *ssid,
> +				uint8_t ssid_len, uint8_t clear_ssid)
>  {
>  	struct lbs_ioctl_user_scan_cfg scancfg;
>  	int ret = 0;
>  
>  	lbs_deb_enter_args(LBS_DEB_SCAN, "SSID '%s', clear %d",
> -		escape_essid(ssid, ssid_len), clear_ssid);
> +			   escape_essid(ssid, ssid_len), clear_ssid);
>  
>  	if (!ssid_len)
>  		goto out;
> @@ -1188,17 +1141,17 @@ out:
>  #define MAX_CUSTOM_LEN 64
>  
>  static inline char *lbs_translate_scan(struct lbs_private *priv,
> -					char *start, char *stop,
> -					struct bss_descriptor *bss)
> +				       char *start, char *stop,
> +				       struct bss_descriptor *bss)
>  {
>  	struct chan_freq_power *cfp;
>  	char *current_val;	/* For rates */
>  	struct iw_event iwe;	/* Temporary buffer */
>  	int j;
> -#define PERFECT_RSSI ((u8)50)
> -#define WORST_RSSI   ((u8)0)
> -#define RSSI_DIFF    ((u8)(PERFECT_RSSI - WORST_RSSI))
> -	u8 rssi;
> +#define PERFECT_RSSI ((uint8_t)50)
> +#define WORST_RSSI   ((uint8_t)0)
> +#define RSSI_DIFF    ((uint8_t)(PERFECT_RSSI - WORST_RSSI))
> +	uint8_t rssi;
>  
>  	lbs_deb_enter(LBS_DEB_SCAN);
>  
> @@ -1218,7 +1171,7 @@ static inline char *lbs_translate_scan(struct lbs_private *priv,
>  	/* SSID */
>  	iwe.cmd = SIOCGIWESSID;
>  	iwe.u.data.flags = 1;
> -	iwe.u.data.length = min((u32) bss->ssid_len, (u32) IW_ESSID_MAX_SIZE);
> +	iwe.u.data.length = min((uint32_t) bss->ssid_len, (uint32_t) IW_ESSID_MAX_SIZE);
>  	start = iwe_stream_add_point(start, stop, &iwe, bss->ssid);
>  
>  	/* Mode */
> @@ -1239,28 +1192,26 @@ static inline char *lbs_translate_scan(struct lbs_private *priv,
>  
>  	rssi = iwe.u.qual.level - MRVDRV_NF_DEFAULT_SCAN_VALUE;
>  	iwe.u.qual.qual =
> -	    (100 * RSSI_DIFF * RSSI_DIFF - (PERFECT_RSSI - rssi) *
> -	     (15 * (RSSI_DIFF) + 62 * (PERFECT_RSSI - rssi))) /
> -	    (RSSI_DIFF * RSSI_DIFF);
> +		(100 * RSSI_DIFF * RSSI_DIFF - (PERFECT_RSSI - rssi) *
> +		 (15 * (RSSI_DIFF) + 62 * (PERFECT_RSSI - rssi))) /
> +		(RSSI_DIFF * RSSI_DIFF);
>  	if (iwe.u.qual.qual > 100)
>  		iwe.u.qual.qual = 100;
>  
>  	if (priv->NF[TYPE_BEACON][TYPE_NOAVG] == 0) {
>  		iwe.u.qual.noise = MRVDRV_NF_DEFAULT_SCAN_VALUE;
>  	} else {
> -		iwe.u.qual.noise =
> -		    CAL_NF(priv->NF[TYPE_BEACON][TYPE_NOAVG]);
> +		iwe.u.qual.noise = CAL_NF(priv->NF[TYPE_BEACON][TYPE_NOAVG]);
>  	}
>  
>  	/* Locally created ad-hoc BSSs won't have beacons if this is the
>  	 * only station in the adhoc network; so get signal strength
>  	 * from receive statistics.
>  	 */
> -	if ((priv->mode == IW_MODE_ADHOC)
> -	    && priv->adhoccreate
> +	if ((priv->mode == IW_MODE_ADHOC) && priv->adhoccreate
>  	    && !lbs_ssid_cmp(priv->curbssparams.ssid,
> -	                          priv->curbssparams.ssid_len,
> -	                          bss->ssid, bss->ssid_len)) {
> +			     priv->curbssparams.ssid_len,
> +			     bss->ssid, bss->ssid_len)) {
>  		int snr, nf;
>  		snr = priv->SNR[TYPE_RXPD][TYPE_AVG] / AVG_SCALE;
>  		nf = priv->NF[TYPE_RXPD][TYPE_AVG] / AVG_SCALE;
> @@ -1291,14 +1242,13 @@ static inline char *lbs_translate_scan(struct lbs_private *priv,
>  		current_val = iwe_stream_add_value(start, current_val,
>  					 stop, &iwe, IW_EV_PARAM_LEN);
>  	}
> -	if ((bss->mode == IW_MODE_ADHOC)
> +	if ((bss->mode == IW_MODE_ADHOC) && priv->adhoccreate
>  	    && !lbs_ssid_cmp(priv->curbssparams.ssid,
> -	                          priv->curbssparams.ssid_len,
> -	                          bss->ssid, bss->ssid_len)
> -	    && priv->adhoccreate) {
> +			     priv->curbssparams.ssid_len,
> +			     bss->ssid, bss->ssid_len)) {
>  		iwe.u.bitrate.value = 22 * 500000;
>  		current_val = iwe_stream_add_value(start, current_val,
> -					 stop, &iwe, IW_EV_PARAM_LEN);
> +						   stop, &iwe, IW_EV_PARAM_LEN);
>  	}
>  	/* Check if we added any event */
>  	if((current_val - start) > IW_EV_LCP_LEN)
> @@ -1327,8 +1277,7 @@ static inline char *lbs_translate_scan(struct lbs_private *priv,
>  		char *p = custom;
>  
>  		iwe.cmd = IWEVCUSTOM;
> -		p += snprintf(p, MAX_CUSTOM_LEN - (p - custom),
> -		              "mesh-type: olpc");
> +		p += snprintf(p, MAX_CUSTOM_LEN, "mesh-type: olpc");
>  		iwe.u.data.length = p - custom;
>  		if (iwe.u.data.length)
>  			start = iwe_stream_add_point(start, stop, &iwe, custom);
> @@ -1351,7 +1300,7 @@ out:
>   *  @return             0 --success, otherwise fail
>   */
>  int lbs_set_scan(struct net_device *dev, struct iw_request_info *info,
> -		  struct iw_param *wrqu, char *extra)
> +		 struct iw_param *wrqu, char *extra)
>  {
>  	struct lbs_private *priv = dev->priv;
>  
> @@ -1375,7 +1324,7 @@ int lbs_set_scan(struct net_device *dev, struct iw_request_info *info,
>  
>  	if (!delayed_work_pending(&priv->scan_work))
>  		queue_delayed_work(priv->work_thread, &priv->scan_work,
> -			msecs_to_jiffies(50));
> +				   msecs_to_jiffies(50));
>  	/* set marker that currently a scan is taking place */
>  	priv->last_scanned_channel = -1;
>  
> @@ -1398,15 +1347,15 @@ int lbs_set_scan(struct net_device *dev, struct iw_request_info *info,
>   *  @return             0 --success, otherwise fail
>   */
>  int lbs_get_scan(struct net_device *dev, struct iw_request_info *info,
> -		  struct iw_point *dwrq, char *extra)
> +		 struct iw_point *dwrq, char *extra)
>  {
>  #define SCAN_ITEM_SIZE 128
>  	struct lbs_private *priv = dev->priv;
>  	int err = 0;
>  	char *ev = extra;
>  	char *stop = ev + dwrq->length;
> -	struct bss_descriptor * iter_bss;
> -	struct bss_descriptor * safe;
> +	struct bss_descriptor *iter_bss;
> +	struct bss_descriptor *safe;
>  
>  	lbs_deb_enter(LBS_DEB_SCAN);
>  
> @@ -1415,14 +1364,13 @@ int lbs_get_scan(struct net_device *dev, struct iw_request_info *info,
>  		return -EAGAIN;
>  
>  	/* Update RSSI if current BSS is a locally created ad-hoc BSS */
> -	if ((priv->mode == IW_MODE_ADHOC) && priv->adhoccreate) {
> +	if ((priv->mode == IW_MODE_ADHOC) && priv->adhoccreate)
>  		lbs_prepare_and_send_command(priv, CMD_802_11_RSSI, 0,
> -					CMD_OPTION_WAITFORRSP, 0, NULL);
> -	}
> +					     CMD_OPTION_WAITFORRSP, 0, NULL);
>  
>  	mutex_lock(&priv->lock);
>  	list_for_each_entry_safe (iter_bss, safe, &priv->network_list, list) {
> -		char * next_ev;
> +		char *next_ev;
>  		unsigned long stale_time;
>  
>  		if (stop - ev < SCAN_ITEM_SIZE) {
> @@ -1437,8 +1385,7 @@ int lbs_get_scan(struct net_device *dev, struct iw_request_info *info,
>  		/* Prune old an old scan result */
>  		stale_time = iter_bss->last_scanned + DEFAULT_MAX_SCAN_AGE;
>  		if (time_after(jiffies, stale_time)) {
> -			list_move_tail (&iter_bss->list,
> -			                &priv->network_free_list);
> +			list_move_tail(&iter_bss->list, &priv->network_free_list);
>  			clear_bss_descriptor(iter_bss);
>  			continue;
>  		}
> @@ -1497,8 +1444,8 @@ static int lbs_ret_80211_scan(struct lbs_private *priv, unsigned long dummy,
>  			      struct cmd_header *resp)
>  {
>  	struct cmd_ds_802_11_scan_rsp *scanresp = (void *)resp;
> -	struct bss_descriptor * iter_bss;
> -	struct bss_descriptor * safe;
> +	struct bss_descriptor *iter_bss;
> +	struct bss_descriptor *safe;
>  	uint8_t *bssinfo;
>  	uint16_t scanrespsize;
>  	int bytesleft;

