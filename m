Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53903 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757318Ab1F0MqJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 08:46:09 -0400
Subject: Re: [RFC v3 1/3] mac80211: add some helper functions
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <alexander.simon@saxnet.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1308671129.2656.4.camel@alex-2> (sfid-20110621_174753_258660_B2E3ED7C)
References: <1308671129.2656.4.camel@alex-2>
	 (sfid-20110621_174753_258660_B2E3ED7C)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Jun 2011 14:46:13 +0200
Message-ID: <1309178773.3911.18.camel@jlt3.sipsolutions.net> (sfid-20110627_144742_621475_5E3D074E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-06-21 at 17:45 +0200, Alexander Simon wrote:

> +struct cfg80211_bss *cfg80211_get_bss_ht(struct wiphy *wiphy,
> +					  struct ieee80211_channel *channel,
> +					  const u8 *bssid,
> +					  const u8 *ssid, size_t ssid_len,
> +					  u16 capa_mask, u16 capa_val,
> +				       enum nl80211_channel_type channel_type);

indentation confusion?

Also, this definitely doesn't belong into a mac80211 patch. Please split
into mac80211/cfg80211.

> --- a/net/wireless/scan.c	2011-06-01 21:04:32.000000000 +0200
> +++ b/net/wireless/scan.c	2011-06-21 13:21:38.000000000 +0200
> @@ -343,6 +343,18 @@ struct cfg80211_bss *cfg80211_get_bss(st
>  				      const u8 *ssid, size_t ssid_len,
>  				      u16 capa_mask, u16 capa_val)
>  {
> +	return cfg80211_get_bss_ht(wiphy, channel, bssid, ssid, ssid_len,
> +				   capa_mask, capa_val, NL80211_CHAN_NO_HT);
> +}
> +EXPORT_SYMBOL(cfg80211_get_bss);

This is misleading/confusing. You're passing NO_HT in order to ignore
the channel bandwidth, but you make it seem like it's a filter. Also,
you didn't update _any_ documentation at all!

johannes

