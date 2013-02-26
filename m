Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759705Ab3BZQCs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 11:02:48 -0500
Date: Tue, 26 Feb 2013 17:02:59 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mac80211:  Stop timers before canceling work
 items.
Message-ID: <20130226160258.GB5256@redhat.com> (sfid-20130226_170252_769794_41DE784C)
References: <1361382069-31729-1-git-send-email-greearb@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1361382069-31729-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 20, 2013 at 09:41:08AM -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Re-order the quiesce code so that timers are
> always stopped before work-items are flushed.  This was
> not the problem I saw, but I think it may still be more
> correct.

I posted patch which remove quiesce functions, so this one
can be skipped.

http://marc.info/?l=linux-wireless&m=136179302820130&w=2

Stanislaw

> ---
>  net/mac80211/mlme.c |   13 ++++++++-----
>  1 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 164ecf0..4001d1c 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -2946,6 +2946,13 @@ void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata)
>  {
>  	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
>  
> +	/* Stop timers before deleting work items, as timers could
> +	 * race and re-add the work-items.
> +	 * These will be re-established on connection.
> +	 */
> +	del_timer_sync(&ifmgd->conn_mon_timer);
> +	del_timer_sync(&ifmgd->bcn_mon_timer);
> +
>  	/*
>  	 * we need to use atomic bitops for the running bits
>  	 * only because both timers might fire at the same
> @@ -2960,13 +2967,9 @@ void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata)
>  	if (del_timer_sync(&ifmgd->timer))
>  		set_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running);
>  
> -	cancel_work_sync(&ifmgd->chswitch_work);
>  	if (del_timer_sync(&ifmgd->chswitch_timer))
>  		set_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running);
> -
> -	/* these will just be re-established on connection */
> -	del_timer_sync(&ifmgd->conn_mon_timer);
> -	del_timer_sync(&ifmgd->bcn_mon_timer);
> +	cancel_work_sync(&ifmgd->chswitch_work);
>  }
>  
>  void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
> -- 
> 1.7.3.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
