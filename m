Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:56540 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab2KUHAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 02:00:11 -0500
Message-ID: <1353481166.10872.197.camel@cumari.coelho.fi> (sfid-20121121_080015_266245_95C32EBB)
Subject: Re: [PATCH 05/10] mac80211: convert to channel definition struct
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Date: Wed, 21 Nov 2012 08:59:26 +0200
In-Reply-To: <1353447916-17304-6-git-send-email-johannes@sipsolutions.net>
References: <1353447916-17304-1-git-send-email-johannes@sipsolutions.net>
	 <1353447916-17304-6-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-20 at 22:45 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Convert mac80211 (and where necessary, some drivers a
> little bit) to the new channel definition struct.
> 
> This will allow extending mac80211 for VHT, which is
> currently restricted to channel contexts since there
> are no drivers using that which makes it easier. As
> I also don't care about VHT for drivers not using the
> channel context API, I won't convert the previous API
> to VHT support.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

I guess these changes depend on something else that you have on your
tree and is not in w-t yet, right? At least I couldn't find the
definition of cfg80211_get_chandef_type().

> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> index 380cf1f..4f1a05b 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -3791,7 +3791,7 @@ static void wl1271_bss_info_changed_ap(struct wl1271 *wl,
>  
>  	/* Handle HT information change */
>  	if ((changed & BSS_CHANGED_HT) &&
> -	    (bss_conf->channel_type != NL80211_CHAN_NO_HT)) {
> +	    (bss_conf->chandef.width != NL80211_CHAN_WIDTH_20_NOHT)) {
>  		ret = wl1271_acx_set_ht_information(wl, wlvif,
>  					bss_conf->ht_operation_mode);
>  		if (ret < 0) {
> @@ -3905,7 +3905,8 @@ sta_not_found:
>  			u32 rates;
>  			int ieoffset;
>  			wlvif->aid = bss_conf->aid;
> -			wlvif->channel_type = bss_conf->channel_type;
> +			wlvif->channel_type =
> +				cfg80211_get_chandef_type(&bss_conf->chandef);
>  			wlvif->beacon_int = bss_conf->beacon_int;
>  			do_join = true;
>  			set_assoc = true;
> @@ -4071,7 +4072,7 @@ sta_not_found:
>  	/* Handle new association with HT. Do this after join. */
>  	if (sta_exists) {
>  		if ((changed & BSS_CHANGED_HT) &&
> -		    (bss_conf->channel_type != NL80211_CHAN_NO_HT)) {
> +		    (bss_conf->chandef.width != NL80211_CHAN_WIDTH_20_NOHT)) {
>  			ret = wl1271_acx_set_ht_capabilities(wl,
>  							     &sta_ht_cap,
>  							     true,
> @@ -4098,7 +4099,7 @@ sta_not_found:
>  
>  	/* Handle HT information change. Done after join. */
>  	if ((changed & BSS_CHANGED_HT) &&
> -	    (bss_conf->channel_type != NL80211_CHAN_NO_HT)) {
> +	    (bss_conf->chandef.width != NL80211_CHAN_WIDTH_20_NOHT)) {
>  		ret = wl1271_acx_set_ht_information(wl, wlvif,
>  					bss_conf->ht_operation_mode);
>  		if (ret < 0) {

In any case, the changes in wlcore look straightforward enough, so:

Acked-by: Luciano Coelho <coelho@ti.com> # wlcore

--
Luca.

