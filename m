Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:47167 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751251Ab1HJMsn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 08:48:43 -0400
Received: by fxg17 with SMTP id 17so949868fxg.30
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 05:48:40 -0700 (PDT)
Subject: Re: [PATCH 16/40] wl12xx: add system_hlid
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312881233-9366-17-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	 <1312881233-9366-17-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 15:48:37 +0300
Message-ID: <1312980517.2407.589.camel@cumari> (sfid-20110810_144846_236754_61354A1C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote: 
> @@ -4385,20 +4388,26 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
>  	wl->quirks = 0;
>  	wl->platform_quirks = 0;
>  	wl->sched_scanning = false;
>  	wl->tx_security_seq = 0;
>  	wl->tx_security_last_seq_lsb = 0;
>  	wl->role_id = WL1271_INVALID_ROLE_ID;
> +	wl->system_hlid = WL1271_SYSTEM_HLID;
>  	wl->sta_hlid = WL1271_INVALID_LINK_ID;
>  	wl->dev_role_id = WL1271_INVALID_ROLE_ID;
>  	wl->dev_hlid = WL1271_INVALID_LINK_ID;
>  	setup_timer(&wl->rx_streaming_timer, wl1271_rx_streaming_timer,
>  		    (unsigned long) wl);
>  	wl->fwlog_size = 0;
>  	init_waitqueue_head(&wl->fwlog_waitq);
>  
> +	memset(wl->links_map, 0, sizeof(wl->links_map));

Why do you now need to memset this here? And if you do, why not
roles_map as well? Of course all the wl struct is initialized to zeros
by default, but we should either be always explicit here or always
implicit. ;)


> @@ -368,14 +371,16 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
>  			if (ret < 0)
>  				return ret;
>  			wl->default_key = idx;
>  		}
>  	}
>  
> -	if (wl->bss_type == BSS_TYPE_AP_BSS)
> -		hlid = wl1271_tx_get_hlid(skb);
> +	if (wl12xx_is_dummy_packet(wl, skb))
> +		hlid = wl->system_hlid;
> +	else if (wl->bss_type == BSS_TYPE_AP_BSS)
> +		hlid = wl1271_tx_get_hlid(wl, skb);
>  	else
>  		if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
>  			hlid = wl->sta_hlid;
>  		else
>  			hlid = wl->dev_hlid;

Can't you put this all in the wl1271_tx_get_hlid() function? At least
part of it seems repeated wherever it's called. 


-- 
Cheers,
Luca.

