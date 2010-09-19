Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:17789 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab0ISTrX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Sep 2010 15:47:23 -0400
Subject: Re: [PATCH 2/2] wl1271: bugfix: use bitwise-AND instead of
 logical-AND
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1284915309-999-2-git-send-email-eliad@wizery.com>
References: <1284915309-999-1-git-send-email-eliad@wizery.com>
	 <1284915309-999-2-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Sep 2010 22:47:15 +0300
Message-ID: <1284925635.10001.5.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-09-19 at 18:55 +0200, ext Eliad Peller wrote:
> typo - while looking for specific bits we should do a bitwise-AND instead of logical-AND.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
>  drivers/net/wireless/wl12xx/wl1271_main.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
> index e6e0852..d2b8486 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_main.c
> +++ b/drivers/net/wireless/wl12xx/wl1271_main.c
> @@ -1635,7 +1635,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
>  	if (ret < 0)
>  		goto out;
>  
> -	if ((changed && BSS_CHANGED_BEACON_INT) &&
> +	if ((changed & BSS_CHANGED_BEACON_INT) &&
>  	    (wl->bss_type == BSS_TYPE_IBSS)) {
>  		wl1271_debug(DEBUG_ADHOC, "ad-hoc beacon interval updated: %d",
>  			bss_conf->beacon_int);
> @@ -1644,7 +1644,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
>  		do_join = true;
>  	}
>  
> -	if ((changed && BSS_CHANGED_BEACON) &&
> +	if ((changed & BSS_CHANGED_BEACON) &&
>  	    (wl->bss_type == BSS_TYPE_IBSS)) {
>  		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
 
Acked-by: Luciano Coelho <luciano.coelho@nokia.com>

Nice catch! Thanks for your patch.

-- 
Cheers,
Luca.

