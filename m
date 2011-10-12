Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37591 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab1JLIVU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 04:21:20 -0400
Subject: Re: [RFC 02/07] compat-wireless: Connection quality monitor
 extensions
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Bartosz MARKOWSKI <bartosz.markowski@tieto.com>,
	Janusz DZIEDZIC <janusz.dziedzic@tieto.com>
In-Reply-To: <op.v27rulkhya27un@edmitar> (sfid-20111012_030243_875021_0262D42B)
References: <op.v27rulkhya27un@edmitar>
	 (sfid-20111012_030243_875021_0262D42B)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 10:21:17 +0200
Message-ID: <1318407677.3933.18.camel@jlt3.sipsolutions.net> (sfid-20111012_102125_646147_7169FB15)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-10-12 at 03:02 +0200, Dmitry Tarnyagin wrote:

> added:
> * beacon miss threshold - This value specifies the threshold
>    for the BEACON loss level
> * tx fail - This value specifies the threshold for the TX loss level

That's a bit short for a changelog for such a big patch. The patch might
stand to be split up into two and be explained better.

Also, as Julian pointed out -- get your compat vs. wireless tree in
order. You don't want to be modifying the compat repository, it's even
impossible, you need to be submitting patches against wireless-next or
-testing. You also need to make sure they apply against those trees,
which this patch obviously can't:


>   include/linux/compat-3.0.h |    2 +

as you can see easily :)

> +++ b/include/linux/nl80211.h
> @@ -2311,6 +2311,14 @@ enum nl80211_ps_state {
>    * @NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT: RSSI threshold event
>    * @NL80211_ATTR_CQM_PKT_LOSS_EVENT: a u32 value indicating that this many
>    *	consecutive packets were not acknowledged by the peer
> + * @NL80211_ATTR_CQM_BEACON_MISS_THOLD: BEACON threshold. This value  
> specifies
> + *	the threshold for the BEACON loss level at which an event will be
> + *	sent. Zero to disable.

Should it really be zero to disable rather than leaving it out to
disable?

> + * @NL80211_ATTR_CQM_BEACON_MISS_THOLD_EVENT: BEACON miss event
> + * @NL80211_ATTR_CQM_TX_FAIL_THOLD: TX threshold. This value specifies the
> + *	the threshold for the TX loss level at which an event will be
> + *	sent. Zero to disable.
> + * @NL80211_ATTR_CQM_TX_FAIL_THOLD_EVENT: TX threshold event

How's this not the same as PKT_LOSS_EVENT?

Some advertising for whether this is supported or not is necessary.

> +++ b/include/net/mac80211.h

Again a fairly complex patch modifying both cfg80211 and mac80211 -- not
good. Keep in mind that there are in fact drivers not using mac80211.

> @@ -244,6 +244,10 @@ enum ieee80211_rssi_event {
>    * @cqm_rssi_thold: Connection quality monitor RSSI threshold, a zero  
> value
>    *	implies disabled
>    * @cqm_rssi_hyst: Connection quality monitor RSSI hysteresis
> + * @cqm_beacon_miss_thold: Connection quality monitor beacon threshold, a  
> zero
> + *	value implies disabled
> + * @cqm_tx_fail_thold: Connection quality monitor tx threshold, a zero  
> value
> + *	implies disabled

Your line-wrapping makes this hard to read :(

> +++ b/net/mac80211/cfg.c
> @@ -1751,6 +1751,58 @@ static int ieee80211_set_cqm_rssi_config(struct  
> wiphy *wiphy,
>   	return 0;
>   }
> 
> +static int ieee80211_set_cqm_beacon_miss_config(struct wiphy *wiphy,
> +						struct net_device *dev,
> +						u32 beacon_thold)
> +{
> +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
> +	struct ieee80211_vif *vif = &sdata->vif;
> +	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
> +
> +	if (beacon_thold == bss_conf->cqm_beacon_miss_thold)
> +		return 0;
> +
> +	bss_conf->cqm_beacon_miss_thold = beacon_thold;
> +
> +	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_CQM_BEACON_MISS)) {
> +		if (sdata->vif.type != NL80211_IFTYPE_STATION)
> +			return -EOPNOTSUPP;
> +		return 0;

This looks/is wrong in multiple ways.

> +++ b/net/mac80211/mlme.c
> @@ -2174,7 +2174,10 @@ void ieee80211_sta_work(struct  
> ieee80211_sub_if_data *sdata)
>   				    ifmgd->probe_send_count, max_tries);
>   #endif
>   			ieee80211_mgd_probe_ap_send(sdata);
> -		} else {
> +		} else if (!(local->hw.flags &
> +				IEEE80211_HW_SUPPORTS_CQM_BEACON_MISS) &&
> +			   !(local->hw.flags &
> +				IEEE80211_HW_SUPPORTS_CQM_TX_FAIL)) {
>   			/*
>   			 * We actually lost the connection ... or did we?
>   			 * Let's make sure!

explain.

> diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
> index 21fc970..4194b3e 100644
> --- a/net/wireless/mlme.c
> +++ b/net/wireless/mlme.c
> @@ -1097,6 +1097,7 @@ void cfg80211_gtk_rekey_notify(struct net_device  
> *dev, const u8 *bssid,
>   }
>   EXPORT_SYMBOL(cfg80211_gtk_rekey_notify);
> 
> +
>   void cfg80211_pmksa_candidate_notify(struct net_device *dev, int index,

spurious whitespace change

johannes

