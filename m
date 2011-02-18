Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42191 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab1BRLHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 06:07:30 -0500
Subject: Re: [PATCH 1/2] mac80211: Fix a race on enabling power save.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1298018776-6936-1-git-send-email-vnatarajan@atheros.com>
References: <1298018776-6936-1-git-send-email-vnatarajan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 12:07:25 +0100
Message-ID: <1298027245.3772.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-02-18 at 14:16 +0530, Vivek Natarajan wrote:
> There is a race on sending a data frame before the tx completion
> of nullfunc frame for enabling power save. As the data quickly
> follows the nullfunc frame, the AP thinks that the station is out
> of power save and continues to send the frames. Whereas in the
> station, the nullfunc ack will be processed after the tx completion
> of data frame and mac80211 goes to powersave. Thus the power
> save state mismatch between the station and the AP causes some
> data loss and some applications fail because of that. This patch
> fixes this issue.
> 
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> ---
>  net/mac80211/mlme.c   |   11 ++++++++++-
>  net/mac80211/status.c |    2 --
>  2 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index d89e878..91006a2 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -738,8 +738,16 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
>  		return;
>  
>  	if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
> -	    (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)))
> +	    (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED))) {
> +		netif_tx_stop_all_queues(sdata->dev);
> +		/* flush all the frames queued in the driver before
> +		 * going to power save
> +		 */
> +		drv_flush(local, false);

Ok, I should've thought of this earlier -- but can we really do this?

I know we currently don't allow powersave when there's more than one
interface, but we still allow it while there are monitor interfaces and
a monitor interface could be sending packets, which would violate the
flush() contract with the driver -- the driver may expect not to get any
packets during flush.

I'm not sure. Maybe we should disable powersave when there are monitor
interfaces after all, even though that would rob us of a way to debug
things. Thoughts?

johannes

