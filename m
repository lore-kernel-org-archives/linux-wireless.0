Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39070 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab3HWNYq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 09:24:46 -0400
Message-ID: <1377264280.14021.29.camel@jlt4.sipsolutions.net> (sfid-20130823_152449_696438_6ED28364)
Subject: Re: [PATCH] mac80211: remove IEEE80211_STA_BEACON_POLL
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Aug 2013 15:24:40 +0200
In-Reply-To: <20130823065200.GA3835@redhat.com>
References: <20130823065200.GA3835@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-08-23 at 08:52 +0200, Stanislaw Gruszka wrote:

> -	if (ifmgd->flags & IEEE80211_STA_BEACON_POLL) {
> +	if (ifmgd->flags & IEEE80211_STA_CONNECTION_POLL) {
>  		mlme_dbg_ratelimited(sdata,
>  				     "cancelling AP probe due to a received beacon\n");
> -		mutex_lock(&local->mtx);
> -		ifmgd->flags &= ~IEEE80211_STA_BEACON_POLL;
> -		ieee80211_run_deferred_scan(local);
> -		mutex_unlock(&local->mtx);
> -
> -		mutex_lock(&local->iflist_mtx);
> -		ieee80211_recalc_ps(local, -1);
> -		mutex_unlock(&local->iflist_mtx);
> +		ieee80211_reset_ap_probe(sdata);
>  	}

This is actually a behavioural change for drivers that implement beacon
filtering/monitoring. It means that when the driver reports beacon loss
and we poll, we'd make a received beacon later abort the poll.

That seems like a reasonable change, but you should probably note it.

johannes

