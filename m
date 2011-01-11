Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:41553 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752515Ab1AKJQp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 04:16:45 -0500
Received: from vs3015.wh2.ocn.ne.jp (125.206.180.247)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0460337401
	for <linux-wireless@vger.kernel.org>; Tue, 11 Jan 2011 18:16:43 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Brian Prodoehl <bprodoehl@gmail.com>
Subject: Re: [PATCH] cfg80211: Extend channel to frequency mapping for 802.11j
Date: Tue, 11 Jan 2011 18:17:40 +0900
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	libertas-dev@lists.infradead.org,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	users@rt2x00.serialmonkey.com
References: <20110107052600.18730.98168.stgit@localhost6.localdomain6> <201101081243.56629.br1@einfach.org> <AANLkTimYjvJbm9DPPDWWCsD76_DnFcBG3a2Z_B8Mhpzm@mail.gmail.com>
In-Reply-To: <AANLkTimYjvJbm9DPPDWWCsD76_DnFcBG3a2Z_B8Mhpzm@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101111817.40309.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat January 8 2011 22:08:41 Brian Prodoehl wrote:
> I guess I saw what I wanted to see when I took a second look at the
> re-posted patch.  Here are compile-fixes to all the affected drivers.
> The following drivers are affected: mwl8k, iwlwifi, iwmc3200wifi,
> libertas, rt2x00, wl1251 and wl12xx.  So I guess these driver fixes
> need to be split into seven patches.  I don't use any of these
> drivers, so I can't really vouch for if I'm pulling the band the
> correct way for each.  I'm happy to split and submit, but I wouldn't
> mind another set of eyes on these changes.

Thanks! I would say these changes have to be merged with my patch, so it can 
be applied without breaking git bisect for the affected drivers.

> compat-wireless-2011-01-07.orig/drivers/net/wireless/libertas/cfg.c	2011-0
> 1-07 15:03:59.000000000 -0500
> +++
> compat-wireless-2011-01-07/drivers/net/wireless/libertas/cfg.c	2011-01-08
> 07:51:23.947290769 -0500
> @@ -607,7 +607,8 @@
>  		/* No channel, no luck */
>  		if (chan_no != -1) {
>  			struct wiphy *wiphy = priv->wdev->wiphy;
> -			int freq = ieee80211_channel_to_frequency(chan_no);
> +			int freq = ieee80211_channel_to_frequency(chan_no,
> +					chan_no <= 14 ? IEEE80211_BAND_2GHZ : 
IEEE80211_BAND_5GHZ);

The whole point of having the band argument is to avoid this. We now have 
overlapping channel numbers: channel 8 and 12 are defined in 5GHz as well as 
in 2.4GHz (that is for 20MHz channel width, there are more for 10 and 5MHz 
width, but we don't support that yet). The band has to come from the hardware 
or driver configuration.

> @@ -1597,7 +1598,8 @@
>  	lbs_deb_enter(LBS_DEB_CFG80211);
> 
>  	survey->channel = ieee80211_get_channel(wiphy,
> -		ieee80211_channel_to_frequency(priv->channel));
> +		ieee80211_channel_to_frequency(priv->channel,
> +			priv->channel <= 14 ? IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ));

Same here.

> compat-wireless-2011-01-07.orig/drivers/net/wireless/rt2x00/rt2x00dev.c	20
> 11-01-07 15:03:59.000000000 -0500
> +++
> compat-wireless-2011-01-07/drivers/net/wireless/rt2x00/rt2x00dev.c	
2011-01
> -08 07:51:23.971290769 -0500
> @@ -649,7 +649,8 @@
>  			      const int channel, const int tx_power,
>  			      const int value)
>  {
> -	entry->center_freq = ieee80211_channel_to_frequency(channel);
> +	entry->center_freq = ieee80211_channel_to_frequency(channel,
> +			channel <= 14 ? IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ);

And here.

So the two problematic drivers are libertas and rt2x00. I'm Cc'ing the 
maintainers, and hope that they have better insight into how to fix this than 
we. 

bruno
