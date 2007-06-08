Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:47384 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966629AbXFHDIm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 23:08:42 -0400
Message-ID: <4668C838.20301@lwfinger.net>
Date: Thu, 07 Jun 2007 22:08:40 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] mac80211: Set low initial rate in rc80211_simple
References: <4668c4f6.9foQu67PRVz5Fh3G%Larry.Finger@lwfinger.net>
In-Reply-To: <4668c4f6.9foQu67PRVz5Fh3G%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> The initial rate for STA's using rc80211_simple is set to the last
> rate in the rate table. For situations for which the signal is weak,
> the rate may be too high for authentication and association. Although
> the rc80211_simple module will adjust the speed, the response may not
> be fast enough for a successful connection. This modification sets the
> initial rate to the lowest supported value.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> 
> Index: wireless-dev/net/mac80211/rc80211_simple.c
> ===================================================================
> --- wireless-dev.orig/net/mac80211/rc80211_simple.c
> +++ wireless-dev/net/mac80211/rc80211_simple.c
> @@ -283,10 +283,10 @@ static void rate_control_simple_rate_ini
>  	int i;
>  	sta->txrate = 0;
>  	mode = local->oper_hw_mode;
> -	/* TODO: what is a good starting rate for STA? About middle? Maybe not
> -	 * the lowest or the highest rate.. Could consider using RSSI from
> -	 * previous packets? Need to have IEEE 802.1X auth succeed immediately
> -	 * after assoc.. */
> +	/* TODO: This routine should consider using RSSI from previous packets
> +	 * as we need to have IEEE 802.1X auth succeed immediately after assoc..
> +	 * Until that method is implemented, we will use the lowest supported rate
> +	 * as a workaround, */
>  	for (i = 0; i < mode->num_rates; i++) {
>  		if ((sta->supp_rates & BIT(i)) &&
>  		    (mode->rates[i].flags & IEEE80211_RATE_SUPPORTED))
> 

I missed a refresh on this patch. Corrected one to follow.

Larry

