Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:38046 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811AbZEDRzq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 13:55:46 -0400
Received: by qw-out-2122.google.com with SMTP id 5so3222058qwd.37
        for <linux-wireless@vger.kernel.org>; Mon, 04 May 2009 10:55:45 -0700 (PDT)
Message-ID: <49FF2AE5.6040104@gmail.com>
Date: Mon, 04 May 2009 13:50:29 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: report operating frequency rather than current
References: <1241452330.8683.49.camel@johannes.local>
In-Reply-To: <1241452330.8683.49.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> It's not very helpful to see, in iwconfig, the current frequency
> the card is tuned to if that frequency is currently somewhere
> across the board because we're scanning. Since we keep track of
> the frequency the user wants, display that instead.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  net/mac80211/wext.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- wireless-testing.orig/net/mac80211/wext.c	2009-05-04 17:41:53.000000000 +0200
> +++ wireless-testing/net/mac80211/wext.c	2009-05-04 17:42:02.000000000 +0200
> @@ -185,7 +185,7 @@ static int ieee80211_ioctl_giwfreq(struc
>  	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
>  		return cfg80211_ibss_wext_giwfreq(dev, info, freq, extra);
>  
> -	freq->m = local->hw.conf.channel->center_freq;
> +	freq->m = local->oper_channel->center_freq;
>  	freq->e = 6;
>  
>  	return 0;
>
>
>   
Nack.  People should see the hardware channel. If I set channel 6 and my 
wifi card is on channel 11 I need to see 11 not 6.  Doesn't make any 
sense to show some imaginary idealistic "I wish it was on channel 6" 
when the hardware is on channel 11.  Am I missing something here?

Thanks,
Rick Farina

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   

