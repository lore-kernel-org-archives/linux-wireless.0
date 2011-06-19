Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43536 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab1FSILT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 04:11:19 -0400
Subject: Re: [RFC] mac80211: dynamic PS - don't enter PS when TX frames are
 pending
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1308425533-20854-1-git-send-email-arik@wizery.com> (sfid-20110618_213240_045942_FA93F38D)
References: <1308425533-20854-1-git-send-email-arik@wizery.com>
	 (sfid-20110618_213240_045942_FA93F38D)
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Jun 2011 10:11:16 +0200
Message-ID: <1308471076.4145.6.camel@jlt3.sipsolutions.net> (sfid-20110619_101123_487402_6B03C73F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-06-18 at 22:32 +0300, Arik Nemtsov wrote:
> Use the tx_frames_pending() driver callback to determine if Tx frames are
> pending for its internal queues. If so postpone the dynamic PS timeout
> to avoid interrupting Tx traffic.
> 
> The commit e8306f989483e4b97a8b37dd268de6c8c6f35e75 enabled this
> behavior for drivers with IEEE80211_HW_PS_NULLFUNC_STACK. We enable this
> for all drivers supporting dynamic PS.
> 
> This patch helps improve performance in noisy environments.

FWIW, I don't really consider myself maintaining the PS
implementation ;-) I don't understand it and think the code is way too
complex.

I'm still not convinced I like the drv_tx_frames_pending() thing, but
then again I don't really care much anyway about PS stuff.

johannes

> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---
>  net/mac80211/mlme.c |   22 +++++++++++++---------
>  1 files changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index a41f234..3a1699b 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -758,19 +758,23 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
>  	if (local->hw.conf.flags & IEEE80211_CONF_PS)
>  		return;
>  
> +	/* don't enter PS if dynamic PS is enabled and TX frames are pending */
> +	if (local->hw.conf.dynamic_ps_timeout > 0 &&
> +	    !local->disable_dynamic_ps && drv_tx_frames_pending(local)) {
> +		mod_timer(&local->dynamic_ps_timer, jiffies +
> +			  msecs_to_jiffies(
> +			  local->hw.conf.dynamic_ps_timeout));
> +		return;
> +	}
> +
>  	if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
>  	    (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED))) {
>  		netif_tx_stop_all_queues(sdata->dev);
>  
> -		if (drv_tx_frames_pending(local))
> -			mod_timer(&local->dynamic_ps_timer, jiffies +
> -				  msecs_to_jiffies(
> -				  local->hw.conf.dynamic_ps_timeout));
> -		else {
> -			ieee80211_send_nullfunc(local, sdata, 1);
> -			/* Flush to get the tx status of nullfunc frame */
> -			drv_flush(local, false);
> -		}
> +		ieee80211_send_nullfunc(local, sdata, 1);
> +
> +		/* Flush to get the tx status of nullfunc frame */
> +		drv_flush(local, false);
>  	}
>  
>  	if (!((local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) &&


