Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60254 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbbA0IYd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 03:24:33 -0500
Message-ID: <1422347067.1890.49.camel@sipsolutions.net> (sfid-20150127_092436_281282_C38E7099)
Subject: Re: [PATCH] cfg80211: PBSS basic support
From: Johannes Berg <johannes@sipsolutions.net>
To: Dedy Lansky <dlansky@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Tue, 27 Jan 2015 09:24:27 +0100
In-Reply-To: <1422345312-2963-1-git-send-email-dlansky@codeaurora.org>
References: <1422345312-2963-1-git-send-email-dlansky@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-01-27 at 09:55 +0200, Dedy Lansky wrote:

> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
> @@ -1602,6 +1602,15 @@ enum {
>  	IEEE80211_BANDID_60G   = 5, /* 60 GHz */
>  };
>  
> +/* BSS Type, 802.11ad #6.3.3.2 */
> +enum ieee80211_bsstype {
> +	IEEE80211_BSS_TYPE_ESS,
> +	IEEE80211_BSS_TYPE_PBSS,
> +	IEEE80211_BSS_TYPE_IBSS,
> +	IEEE80211_BSS_TYPE_MBSS,
> +	IEEE80211_BSS_TYPE_ANY
> +};

Technically the standard defines this, but not as over the air bits as
everything else in this file. I think this should therefore be moved
into cfg80211.h as a local enum, we don't use the exact definitions from
clause 6 anywhere anyway.

> @@ -4007,6 +4009,7 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
>  				      struct ieee80211_channel *channel,
>  				      const u8 *bssid,
>  				      const u8 *ssid, size_t ssid_len,
> +				      enum ieee80211_bsstype bss_type,
>  				      u16 capa_mask, u16 capa_val);

As far as I can tell, the only remaining use for capa_mask/val is the
privacy -- for some reason some drivers like ath6kl don't specify it and
don't care (which is odd) but it'd be nicer to remove capa_mask/val now
and add a privacy enum allowing UNSPEC, ON and OFF or so. That'll make
the callers clearer.

> +static bool cfg80211_bss_type_to_capa(enum ieee80211_bsstype bss_type,
> +				      enum ieee80211_band band,
> +				      u16 *capa_mask, u16 *capa_val)
> +{
> +	bool ret = true;
> +
> +	if (bss_type == IEEE80211_BSS_TYPE_ANY)
> +		return ret;
> +
> +	if (band == IEEE80211_BAND_60GHZ) {
> +		*capa_val &= ~WLAN_CAPABILITY_DMG_TYPE_MASK;
> +		*capa_mask |= WLAN_CAPABILITY_DMG_TYPE_MASK;
> +		switch (bss_type) {
> +		case IEEE80211_BSS_TYPE_ESS:
> +			*capa_val |= WLAN_CAPABILITY_DMG_TYPE_AP;
> +			break;
> +		case IEEE80211_BSS_TYPE_PBSS:
> +			*capa_val |= WLAN_CAPABILITY_DMG_TYPE_PBSS;
> +			break;
> +		case IEEE80211_BSS_TYPE_IBSS:
> +			*capa_val |= WLAN_CAPABILITY_DMG_TYPE_IBSS;
> +			break;
> +		default:
> +			ret = false;
> +			break;
> +		}
> +	} else {
> +		*capa_val &= ~(WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_IBSS);
> +		*capa_mask |= WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_IBSS;
> +		switch (bss_type) {
> +		case IEEE80211_BSS_TYPE_ESS:
> +			*capa_val |= WLAN_CAPABILITY_ESS;
> +			break;
> +		case IEEE80211_BSS_TYPE_IBSS:
> +			*capa_val |= WLAN_CAPABILITY_IBSS;
> +			break;
> +		case IEEE80211_BSS_TYPE_MBSS:
> +			break;
> +		default:
> +			ret = false;
> +			break;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
>  /* Returned bss is reference counted and must be cleaned up appropriately. */
>  struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
>  				      struct ieee80211_channel *channel,
>  				      const u8 *bssid,
>  				      const u8 *ssid, size_t ssid_len,
> +				      enum ieee80211_bsstype bss_type,
>  				      u16 capa_mask, u16 capa_val)
>  {
>  	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
>  	struct cfg80211_internal_bss *bss, *res = NULL;
>  	unsigned long now = jiffies;
>  
> -	trace_cfg80211_get_bss(wiphy, channel, bssid, ssid, ssid_len, capa_mask,
> -			       capa_val);
> +	trace_cfg80211_get_bss(wiphy, channel, bssid, ssid, ssid_len, bss_type,
> +			       capa_mask, capa_val);
>  
>  	spin_lock_bh(&rdev->bss_lock);
>  
>  	list_for_each_entry(bss, &rdev->bss_list, list) {
> +		if (!cfg80211_bss_type_to_capa(bss_type,
> +					       bss->pub.channel->band,
> +					       &capa_val, &capa_mask))
> +			continue;

This doesn't make any sense - you're also storing the bss_type in the
bss struct, so why translate here to match?

> @@ -896,6 +949,7 @@ cfg80211_inform_bss_width(struct wiphy *wiphy,
>  	struct cfg80211_bss_ies *ies;
>  	struct ieee80211_channel *channel;
>  	struct cfg80211_internal_bss tmp = {}, *res;
> +	int bss_type;

enum.

Except that you actually forgot to store the BSS type ...

Actually - you didn't add it to the bss struct, but to wdev? Why is it
needed there?? I don't see you using it?

johannes

