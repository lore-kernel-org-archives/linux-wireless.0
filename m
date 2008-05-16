Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:41564 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbYEPSRA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 14:17:00 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Association broken with wpa_supplicant
Date: Fri, 16 May 2008 20:16:28 +0200
Cc: Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <200805160030.11244.mb@bu3sch.de> <20080516145832.GA6510@tuxdriver.com>
In-Reply-To: <20080516145832.GA6510@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805162016.28348.mb@bu3sch.de> (sfid-20080516_201704_263588_CA108462)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 16 May 2008 16:58:32 John W. Linville wrote:
> Instead of reverting it, could you try applying this one on top of it?
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 508f675..76ad4ed 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -3440,8 +3440,11 @@ static int ieee80211_sta_config_auth(struct net_device *dev,
>  		if (!(bss->capability & WLAN_CAPABILITY_ESS))
>  			continue;
>  
> -		if (!!(bss->capability & WLAN_CAPABILITY_PRIVACY) ^
> -		    !!sdata->default_key)
> +		if ((ifsta->flags & (IEEE80211_STA_AUTO_SSID_SEL |
> +			IEEE80211_STA_AUTO_BSSID_SEL |
> +			IEEE80211_STA_AUTO_CHANNEL_SEL)) &&
> +		    (!!(bss->capability & WLAN_CAPABILITY_PRIVACY) ^
> +		     !!sdata->default_key))
>  			continue;
>  
>  		if (!(ifsta->flags & IEEE80211_STA_AUTO_CHANNEL_SEL) &&


This patch fixes the bug for me.

-- 
Greetings Michael.
