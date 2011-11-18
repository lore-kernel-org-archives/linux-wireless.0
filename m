Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48503 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757734Ab1KRKP7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 05:15:59 -0500
Subject: Re: [PATCH v9 2/2] mac80211:  Support ht-cap over-rides.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1321566884-31757-2-git-send-email-greearb@candelatech.com> (sfid-20111117_225512_858995_688665F5)
References: <1321566884-31757-1-git-send-email-greearb@candelatech.com>
	 <1321566884-31757-2-git-send-email-greearb@candelatech.com>
	 (sfid-20111117_225512_858995_688665F5)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 11:15:55 +0100
Message-ID: <1321611355.10266.30.camel@jlt3.sipsolutions.net> (sfid-20111118_111603_161247_A065C640)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-11-17 at 13:54 -0800, greearb@candelatech.com wrote:

> -void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
> +bool ieee80111_cfg_override_disables_ht40(struct ieee80211_sub_if_data *sdata)
> +{
> +	const u16 flg = IEEE80211_HT_CAP_SUP_WIDTH_20_40;
> +	if ((sdata->u.mgd.ht_capa_mask.cap_info & flg) &&
> +	    !(sdata->u.mgd.ht_capa.cap_info & flg))
> +		return true;

This looks like it has endian bugs. Note that sband->ht_cap is
ieee80211_sta_ht_cap, whereas sdata->u.mgd.ht_capa[_mask] is
ieee80211_ht_cap -- the latter is in IEEE format (LE) while the former
is in a complete different format that's easier to digest for the
CPU :-)

> +void __check_htcap_disable(struct ieee80211_sub_if_data *sdata,
> +			   struct ieee80211_sta_ht_cap *ht_cap,
> +			   u16 flag)
> +{
> +	if (sdata->u.mgd.ht_capa_mask.cap_info & flag) {
> +		if (!(sdata->u.mgd.ht_capa.cap_info & flag))
> +			ht_cap->cap &= ~flag;
> +	}
> +}

Same here.

> +	/* Allow user to decrease AMPDU factor */
> +	if (sdata->u.mgd.ht_capa_mask.ampdu_params_info &
> +	    IEEE80211_HT_AMPDU_PARM_FACTOR) {
> +		u16 n = sdata->u.mgd.ht_capa.ampdu_params_info
> +			& IEEE80211_HT_AMPDU_PARM_FACTOR;

That should be a u8.

> +	/* Allow the user to increase AMPDU density. */
> +	if (sdata->u.mgd.ht_capa_mask.ampdu_params_info &
> +	    IEEE80211_HT_AMPDU_PARM_DENSITY) {
> +		u16 n = (sdata->u.mgd.ht_capa.ampdu_params_info &
> +			 IEEE80211_HT_AMPDU_PARM_DENSITY)
> +			>> IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT;
> +		if (n > ht_cap->ampdu_density)
> +			ht_cap->ampdu_density = n;

Ditto here.

> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -558,6 +558,19 @@ ieee80211_default_mgmt_stypes[NUM_NL80211_IFTYPES] = {
>  	},
>  };
>  
> +static const struct ieee80211_ht_cap mac80211_ht_capa_mod_mask = {
> +	.ampdu_params_info = IEEE80211_HT_AMPDU_PARM_FACTOR |
> +			     IEEE80211_HT_AMPDU_PARM_DENSITY,
> +
> +	.cap_info = IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
> +		    IEEE80211_HT_CAP_MAX_AMSDU |
> +		    IEEE80211_HT_CAP_SGI_40,

That also has endian bugs.

> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -209,6 +209,7 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
>  		channel_type = NL80211_CHAN_HT20;
>  
>  		if (!(ap_ht_cap_flags & IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
> +		    !ieee80111_cfg_override_disables_ht40(sdata) &&
>  		    (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
>  		    (hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
>  			switch(hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
> @@ -1613,7 +1614,7 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
>  		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
>  
>  	if (elems.ht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
> -		ieee80211_ht_cap_ie_to_sta_ht_cap(sband,
> +		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
>  				elems.ht_cap_elem, &sta->sta.ht_cap);
>  
>  	ap_ht_cap_flags = sta->sta.ht_cap.cap;
> @@ -1982,7 +1983,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
>  
>  		sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
>  
> -		ieee80211_ht_cap_ie_to_sta_ht_cap(sband,
> +		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
>  				elems.ht_cap_elem, &sta->sta.ht_cap);
>  
>  		ap_ht_cap_flags = sta->sta.ht_cap.cap;
> @@ -2640,6 +2641,13 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
>  			ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
>  
> 
> +	if (req->flags & ASSOC_REQ_DISABLE_HT)
> +		ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
> +
> +	memcpy(&ifmgd->ht_capa, &req->ht_capa, sizeof(ifmgd->ht_capa));
> +	memcpy(&ifmgd->ht_capa_mask, &req->ht_capa_mask,
> +	       sizeof(ifmgd->ht_capa_mask));
> +

You need to reset this on disassoc, at least memset the mask to 0,
otherwise a new association w/o overrides will still have them, and if
you change the iftype to something else things will be completely
confused.

> @@ -113,9 +114,16 @@ static void ieee80211_add_ht_ie(struct sk_buff *skb, const u8 *ht_info_ie,
>  	if (ht_info_ie[1] < sizeof(struct ieee80211_ht_info))
>  		return;
>  
> +	memcpy(&ht_cap, &sband->ht_cap, sizeof(ht_cap));
> +	ieee80211_apply_htcap_overrides(sdata, &ht_cap);
> +
> +	if (!ht_cap.ht_supported)
> +		return;

Can applying the overrides change ht_supported? It didn't seem so, so
maybe this check should stay at the front (where you remove the sband
check that would still be valid)

johannes

