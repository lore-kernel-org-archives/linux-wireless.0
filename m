Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53040 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab1HJNxv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 09:53:51 -0400
Subject: Re: [PATCH 2/4] cfg80211: Add cfg80211_get_bss_ht to also match HT
 configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <an.alexsimon@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <8106144.ZkUl7u1lz4@alex-1> (sfid-20110808_140459_252308_3B0F09A2)
References: <1888623.Vt5VZUN2cU@alex-1>  <8106144.ZkUl7u1lz4@alex-1>
	 (sfid-20110808_140459_252308_3B0F09A2)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 15:53:48 +0200
Message-ID: <1312984428.4325.10.camel@jlt3.sipsolutions.net> (sfid-20110810_155353_999593_50A2A793)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-08-08 at 14:04 +0200, Alexander Simon wrote:

> +struct cfg80211_bss *cfg80211_get_bss_ht(struct wiphy *wiphy,
> +					  struct ieee80211_channel *channel,
> +					  const u8 *bssid,
> +					  const u8 *ssid, size_t ssid_len,
> +					  u16 capa_mask, u16 capa_val,
> +				       enum nl80211_channel_type channel_type);

indentation? Also, you really need kernel-doc for this.

> +++ b/net/wireless/chan.c
> @@ -75,6 +75,7 @@ bool can_beacon_sec_chan(struct wiphy *wiphy,
>  
>  	return true;
>  }
> +EXPORT_SYMBOL(can_beacon_sec_chan);

You've got to be kidding, if you export it you really need to give it a
decent name. Besides, you don't have to export it in this patch.

>  int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
>  		      struct wireless_dev *wdev, int freq,
> diff --git a/net/wireless/scan.c b/net/wireless/scan.c
> index 2936cb8..ff5b736 100644
> --- a/net/wireless/scan.c
> +++ b/net/wireless/scan.c
> @@ -364,6 +364,19 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy
> *wiphy,
>  				      const u8 *ssid, size_t ssid_len,
>  				      u16 capa_mask, u16 capa_val)
>  {
> +	/* call HT version with no HT requirements */
> +	return cfg80211_get_bss_ht(wiphy, channel, bssid, ssid, ssid_len,
> +				   capa_mask, capa_val, NL80211_CHAN_NO_HT);
> +}
> +EXPORT_SYMBOL(cfg80211_get_bss);

I don't like the semantics of this. Why is NO_HT indicating "don't care
about HT"? How then do you really find a NO_HT BSS?

Also, this raises a more fundamental question -- didn't you earlier say
you wanted to be able to connect with any IBSS, even non-HT ones, but
now it must match?

johannes

