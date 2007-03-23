Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:33528 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992470AbXCWQBk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 12:01:40 -0400
Date: Fri, 23 Mar 2007 17:01:36 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] d80211: switch STA interfaces to PS mode during  scan
Message-ID: <20070323170136.5f6205db@griffin.suse.cz>
In-Reply-To: <200703010043.10565.flamingice@sourmilk.net>
References: <20070228203943.11473.95222.stgit@magic.sourmilk.net>
	<200702281642.24404.flamingice@sourmilk.net>
	<200702281644.42038.flamingice@sourmilk.net>
	<200703010043.10565.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 1 Mar 2007 00:43:10 -0500, Michael Wu wrote:
> On Wednesday 28 February 2007 16:44, Michael Wu wrote:
> > On Wednesday 28 February 2007 16:42, Michael Wu wrote:
> > > This makes scans switch STA interfaces into PS mode so the AP queues
> > > frames destined for us while we are scanning. This is achieved by sending
> > > a nullfunc data frame with the PS mode bit set before scanning commences,
> > > and a PS poll frame after scanning is completed.
> >
> > Er. I should update the description too..
> >
> And drop the ps_poll part since we don't use the ps poll frame now..
>
> [...]
> @@ -2541,10 +2572,12 @@ void ieee80211_scan_completed(struct iee
>  
>  	spin_lock_bh(&local->sub_if_lock);
>  	list_for_each_entry(sdata, &local->sub_if_list, list) {
> -		netif_wake_queue(sdata->dev);
> -
> -		if (sdata->type == IEEE80211_IF_TYPE_STA)
> +		if (sdata->type == IEEE80211_IF_TYPE_STA) {
> +			if (sdata->u.sta.associated)
> +				ieee80211_send_nullfunc(local, sdata, 0);
>  			ieee80211_sta_timer((unsigned long)&sdata->u.sta);
> +		}
> +		netif_wake_queue(sdata->dev);

Shouldn't the queue be woken before calling ieee80211_sta_timer?

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
