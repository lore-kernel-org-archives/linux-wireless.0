Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:37406 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752856Ab1EINi6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 09:38:58 -0400
Received: by mail-ew0-f42.google.com with SMTP id 2so3157415ewy.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 06:38:56 -0700 (PDT)
Subject: Re: [PATCH 2/3] mac80211: add support for HW scheduled scan
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1304929342.3475.8.camel@jlt3.sipsolutions.net>
References: <1304600420-24227-1-git-send-email-coelho@ti.com>
	 <1304600420-24227-3-git-send-email-coelho@ti.com>
	 <1304929342.3475.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 16:38:53 +0300
Message-ID: <1304948333.12586.546.camel@cumari> (sfid-20110509_153901_107467_6781F545)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-05-09 at 10:22 +0200, Johannes Berg wrote:
> On Thu, 2011-05-05 at 16:00 +0300, Luciano Coelho wrote:
> 
> > +TRACE_EVENT(drv_sched_scan_start,
> > +	TP_PROTO(struct ieee80211_local *local,
> > +		 struct ieee80211_sub_if_data *sdata,
> > +		 struct cfg80211_sched_scan_request *req),
> 
> Since you're not tracing "req" (right now), could you please use
> DECLARE_EVENT_CLASS() and define a common class for this and some others
> that only have local and sdata?
> 
> > +TRACE_EVENT(api_sched_scan_results,
> > +	TP_PROTO(struct ieee80211_local *local),
> 
> and use the local_only_evt class here, cf. drv_start() for example.
> 
> > +TRACE_EVENT(api_sched_scan_stopped,
> > +	TP_PROTO(struct ieee80211_local *local),
> 
> ditto.

Sent a patch that combines a couple of traces into a class.  I also will
change my sched_scan patch so that hw_scan and sched_start/sched_stop
are combined into a new class.


> Also -- no API tracers for results/stopped?
> 
> > diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> > index 6187766..9a20671 100644
> > --- a/net/mac80211/main.c
> > +++ b/net/mac80211/main.c
> > @@ -47,7 +47,7 @@ void ieee80211_configure_filter(struct ieee80211_local *local)
> >  	if (atomic_read(&local->iff_allmultis))
> >  		new_flags |= FIF_ALLMULTI;
> >  
> > -	if (local->monitors || local->scanning)
> > +	if (local->monitors || local->scanning || local->sched_scanning)
> >  		new_flags |= FIF_BCN_PRBRESP_PROMISC;
> 
> Hmm, that seems like an implementation detail of the driver in this
> case. I'd rather not do this here, other drivers might not have a
> special filter they need for scheduled scans.

You're right, we don't really need this.  I'll remove it.


> > @@ -358,7 +358,8 @@ static void ieee80211_restart_work(struct work_struct *work)
> >  	flush_workqueue(local->workqueue);
> >  
> >  	mutex_lock(&local->mtx);
> > -	WARN(test_bit(SCAN_HW_SCANNING, &local->scanning),
> > +	WARN(test_bit(SCAN_HW_SCANNING, &local->scanning) ||
> > +	     local->sched_scanning,
> >  		"%s called with hardware scan in progress\n", __func__);
> >  	mutex_unlock(&local->mtx);
> 
> 
> Good catch, I should've thought of that in the remain-on-channel stuff,
> would've saved me some debugging :)

:)


> > diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> > index 599fa90..1158164 100644
> > --- a/net/mac80211/rx.c
> > +++ b/net/mac80211/rx.c
> > @@ -408,7 +408,8 @@ ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
> >  		return RX_CONTINUE;
> >  
> >  	if (test_bit(SCAN_HW_SCANNING, &local->scanning) ||
> > -	    test_bit(SCAN_SW_SCANNING, &local->scanning))
> > +	    test_bit(SCAN_SW_SCANNING, &local->scanning) ||
> > +	    local->sched_scanning)
> >  		return ieee80211_scan_rx(rx->sdata, skb);
> 
> I'm still not convinced that this is right.

As we discussed on IRC, it seems that this is indeed safe to do, as long
as we remove the check that drops frames smaller than 24 bytes in
length.  As we agreed, I will do that in a separate patch.

 
> > @@ -2801,7 +2802,8 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
> >  		local->dot11ReceivedFragmentCount++;
> >  
> >  	if (unlikely(test_bit(SCAN_HW_SCANNING, &local->scanning) ||
> > -		     test_bit(SCAN_SW_SCANNING, &local->scanning)))
> > +		     test_bit(SCAN_SW_SCANNING, &local->scanning) ||
> > +		     local->sched_scanning))
> >  		status->rx_flags |= IEEE80211_RX_IN_SCAN;
> 
> Nor this I guess, though we don't use this much of course.

You're right here.  The reason why I was doing this was so that the
ieee80211_rx_h_passive_scan() would not return immediately.  But this
would affect the IEEE80211_RX_RA_MATCH handling in ad-hoc ad AP.

I will add a different check in ieee80211_rx_h_passive_scan() instead.


> > +	ret = drv_sched_scan_start(local, sdata, req,
> > +				   &local->sched_scan_ies);
> > +	if (!ret)
> > +		local->sched_scanning = true;
> > +out:
> > +	mutex_unlock(&sdata->local->mtx);
> > +
> > +	return ret;
> > +
> > +out_free:
> > +	while (i > 0)
> > +		kfree(local->sched_scan_ies.ie[--i]);
> > +	goto out;
> 
> Not freeing it when the driver callback fails?
> 
> Seems like you should reorder:
> 	ret = drv...();
> 	if (ret == 0) {
> 		... = true;
> 		goto out;
> 	}
> out_free:
> 	...
> out:
> 	...

Oops! I wonder where this mess came from.  out_free calling goto out?
Horrible.  I will fix it.

-- 
Cheers,
Luca.

