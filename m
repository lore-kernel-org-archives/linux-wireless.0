Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49279 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756847Ab2IFPkd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2012 11:40:33 -0400
Message-ID: <1346946070.5469.23.camel@jlt4.sipsolutions.net> (sfid-20120906_174036_810303_31569621)
Subject: Re: [PATCH 2/2] mac80211: use call_rcu() on sta deletion
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 06 Sep 2012 17:41:10 +0200
In-Reply-To: <1346865837-32265-3-git-send-email-eliad@wizery.com> (sfid-20120905_192355_860789_FC09B61A)
References: <1346865837-32265-1-git-send-email-eliad@wizery.com>
	 <1346865837-32265-3-git-send-email-eliad@wizery.com>
	 (sfid-20120905_192355_860789_FC09B61A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-09-05 at 20:23 +0300, Eliad Peller wrote:

> +++ b/net/mac80211/iface.c
> @@ -774,6 +774,10 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>  		 * frames at this very time on another CPU.
>  		 */
>  		synchronize_rcu();
> +
> +		/* flush any remaining cleanup work */
> +		flush_workqueue(local->workqueue);

I have a feeling we need rcu_barrier() here instead of synchronize_rcu()
now to guarantee that all the potentially pending call_rcu() functions
from the sta_info_flush() above have actually completed and queued the
work items that we want to flush here. Right? That's a bit unfortunate,
but I guess the best way of handling it and ifdown should be rare anyway
compared to everything else.

I think it'd also be good to make the comment more verbose and explain
which cleanup work.

> +static void free_sta_work(struct work_struct *wk)
> +{
> +	struct sta_info *sta = container_of(wk, struct sta_info, free_sta_wk);
> +	int ac, i;
> +	struct tid_ampdu_tx *tid_tx;
> +	struct ieee80211_sub_if_data *sdata = sta->sdata;
> +	struct ieee80211_local *local = sdata->local;
> +
> +	/*
> +	 * At this point, after we wait for an RCU grace period,
> +	 * neither mac80211 nor the driver can reference this
> +	 * sta struct any more except by still existing timers
> +	 * associated with this station that we clean up below.
> +	 */

Should probably rewrite the comment a bit to indicate that we have in
fact waited since we get called via call_rcu().

> +	cancel_work_sync(&sta->drv_unblock_wk);

This will deadlock now, but cancel_work() will be safe without the sync
since the workqueue is single-threaded.

johannes

