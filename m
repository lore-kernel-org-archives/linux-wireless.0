Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59179 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab1AKNnW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 08:43:22 -0500
Subject: Re: [RFC] mac80211: Allow AP to change channels for DFS support
From: Johannes Berg <johannes@sipsolutions.net>
To: Wojciech Dubowik <dubowoj@neratec.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	lrodriguez <lrodriguez@atheros.com>, nbd <nbd@openwrt.org>
In-Reply-To: <2847292.30.1294752879394.JavaMail.wlan@CHBU500181>
References: <2847292.30.1294752879394.JavaMail.wlan@CHBU500181>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Jan 2011 14:43:21 +0100
Message-ID: <1294753401.3611.31.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-11 at 14:34 +0100, Wojciech Dubowik wrote:
> Hello,
> 
>   I have started studying DFS support possibilities in ath9k 
> and I have noticed that at the moment AP is not allowed to 
> change channels when it's using beacons.
> 
> I have found that I can go around it by setting CHAN_MODE_UNDEFINED
> for this case. Not sure whether we need extra mode for it but
> to me this is a case when AP is neither fixed nor hopping.
> 
> --- a/net/mac80211/chan.c
> +++ b/net/mac80211/chan.c 
> @@ -34,8 +34,11 @@
>  				return CHAN_MODE_HOPPING;
>  		}
>  
> -		if (sdata->vif.type == NL80211_IFTYPE_AP &&
> -		    !sdata->u.ap.beacon)
> +
> +		/* TODO: CHAN_MODE_FIXED shouldn't be set when
> +		  AP is on DFS channel. For now assume always
> +		  undefined */
> +		if (sdata->vif.type == NL80211_IFTYPE_AP)
>  			continue;
>  
>  		return CHAN_MODE_FIXED;
> 
> 
> It's also possible to check whether channel is of radar type
> and set mode undefined for this case. Question is whether it's 
> needed at all.
> 
> Any comments?

I don't think this is a good thing. Putting undefined here will inhibit
any other use of the channel since nothing can rely on it. However, in
the DFS case, everybody else will need to switch away as well, so ...

A similar issue exists with DFS clients too, btw, since they could also
hop channels which we don't currently really model.

johannes

