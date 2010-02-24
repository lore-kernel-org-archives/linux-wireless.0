Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.irobot.com ([206.83.81.187]:35141 "EHLO smtp1.irobot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758546Ab0BXXny (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2010 18:43:54 -0500
Message-ID: <4B85B88E.3050402@irobot.com>
Date: Wed, 24 Feb 2010 15:38:54 -0800
From: Adam Wozniak <awozniak@irobot.com>
MIME-Version: 1.0
To: Bruno Randolf <br1@einfach.org>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix rates setup on IBSS merge
References: <20100223095113.25360.75291.stgit@void>
In-Reply-To: <20100223095113.25360.75291.stgit@void>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I noticed this a while back and tried (unsuccessfully) to get some 
patches pushed through for it.  Your patch looks cleaner than mine (I 
don't think I understood as much at the time as I do now).

You can look through the linux-wireless archives for some of my old 
posts.  Things to note:

For minstrel, calling rate_control_init() is effectively an update.  A 
workable solution may be to add a minstrel rate_control_update() that 
simply calls init().  I don't *think* PID has an update either, and 
don't forget about the cases where the rate control algorithm is handled 
in the firmware for the device.

Flow control in ieee80211_rx_bss_info() could use some cleanup.  It's 
possible to reach the end and use uninitialized variables.

To solve the problem for my devices, I used a patch to minstrel which 
actually ignores the rates in the beacon, under the assumption that if 
the other STA can't use them, they'll get 0% probability in the rate 
table.  This seems to work well for me.

--Adam

Bruno Randolf wrote:
> when an IBSS merge happened, the supported rates for the newly added station
> were left empty, causing the rate control module to be initialized with only
> the basic rates.
>
> also the section of the ibss code which deals with updating supported rates for
> an already existing station fails to inform the rate control module about the
> new rates. as i don't know how to fix this (minstrel does not have an update
> function), i have just added a comment for now.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>
>  net/mac80211/ibss.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index f3e9424..b840d90 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -276,6 +276,8 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
>  				    (unsigned long long) sta->sta.supp_rates[band]);
>  #endif
>  			rcu_read_unlock();
> +
> +			/* FIXME: update rate control */
>  		} else {
>  			rcu_read_unlock();
>  			ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
> @@ -370,6 +372,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
>  		       sdata->name, mgmt->bssid);
>  #endif
>  		ieee80211_sta_join_ibss(sdata, bss);
> +		supp_rates = ieee80211_sta_get_rates(local, elems, band);
>  		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
>  				       supp_rates, GFP_KERNEL);
>  	}
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

