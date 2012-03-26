Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46884 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932606Ab2CZQJR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 12:09:17 -0400
Message-ID: <1332778151.5435.44.camel@jlt3.sipsolutions.net> (sfid-20120326_180920_983857_832570CF)
Subject: Re: [PATCH 1/2] mac80211: inform the offchannel status to AP if no
 powersave
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Mon, 26 Mar 2012 18:09:11 +0200
In-Reply-To: <1332775418-16865-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1332775418-16865-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-03-26 at 20:53 +0530, Rajkumar Manoharan wrote:
> The station has to inform the offchannel status to the assiociated AP
> while switching b/w oper and off-channel. The station uses pspoll to

Gee, ok, I thought you meant "bandwidth", not "between". Might be worth
not being so lazy in the commit log ...

> fetch the buffered data from the AP and the pspoll frame can only be
> used when the powersave is enabled. For non-PS case, the station has
> to use nullfunc frame notification. Fix that.
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  net/mac80211/offchannel.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
> index f054e94..f7aedfc 100644
> --- a/net/mac80211/offchannel.c
> +++ b/net/mac80211/offchannel.c
> @@ -129,7 +129,7 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
>  
>  		if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
>  			netif_tx_stop_all_queues(sdata->dev);
> -			if (offchannel_ps_enable &&
> +			if ((offchannel_ps_enable || !sdata->u.mgd.powersave) &&

I'm not sure I like evaluating u.mgd.powersave before we even know it's
a managed interface ... not a huge issue though.

>  			    (sdata->vif.type == NL80211_IFTYPE_STATION) &&
>  			    sdata->u.mgd.associated)
>  				ieee80211_offchannel_ps_enable(sdata, true);
> @@ -152,7 +152,7 @@ void ieee80211_offchannel_return(struct ieee80211_local *local,
>  			continue;
>  
>  		/* Tell AP we're back */
> -		if (offchannel_ps_disable &&
> +		if ((offchannel_ps_disable || !sdata->u.mgd.powersave) &&
>  		    sdata->vif.type == NL80211_IFTYPE_STATION) {
>  			if (sdata->u.mgd.associated)
>  				ieee80211_offchannel_ps_disable(sdata);


Overall though I don't get it. u.mgd.powersave has nothing to do with
the current powersave state at all, it's just whether cfg80211 requested
powersave mode or not -- so NACK.

johannes

