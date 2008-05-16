Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:64092 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755000AbYEPSTS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 14:19:18 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: Association broken with wpa_supplicant
Date: Fri, 16 May 2008 11:19:17 -0700
Message-ID: <BD524EA7912ED5469DFD0BAEF6BC752F03B3636B@orsmsx411.amr.corp.intel.com> (sfid-20080516_201921_970716_1367B2D7)
In-Reply-To: <200805162016.28348.mb@bu3sch.de>
References: <200805160030.11244.mb@bu3sch.de> <20080516145832.GA6510@tuxdriver.com> <200805162016.28348.mb@bu3sch.de>
From: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>
To: "Michael Buesch" <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>,
	"Johannes Berg" <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the problem for me too.
Abhi

-----Original Message-----
From: Michael Buesch [mailto:mb@bu3sch.de] 
Sent: Friday, May 16, 2008 11:16 AM
To: John W. Linville
Cc: Kolekar, Abhijeet; linux-wireless@vger.kernel.org; Johannes Berg
Subject: Re: Association broken with wpa_supplicant

On Friday 16 May 2008 16:58:32 John W. Linville wrote:
> Instead of reverting it, could you try applying this one on top of it?
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 508f675..76ad4ed 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -3440,8 +3440,11 @@ static int ieee80211_sta_config_auth(struct
net_device *dev,
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
