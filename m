Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756456AbXKTRZp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 12:25:45 -0500
Subject: RE: [PATCH] mac80211: hardware scan rework (V2)
From: Dan Williams <dcbw@redhat.com>
To: "Abbas, Mohamed" <mohamed.abbas@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Zhu, Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	"Cahill, Ben M" <ben.m.cahill@intel.com>
In-Reply-To: <33E1C72C74DBE747B7B59C1740F74437027F30D4@orsmsx417.amr.corp.intel.com>
References: <119553601948-git-send-email-yi.zhu@intel.com>
	 <1195566632.10920.39.camel@johannes.berg>
	 <33E1C72C74DBE747B7B59C1740F74437027F30D4@orsmsx417.amr.corp.intel.com>
Content-Type: text/plain
Date: Tue, 20 Nov 2007 12:21:47 -0500
Message-Id: <1195579307.3389.52.camel@localhost.localdomain> (sfid-20071120_172548_789107_8E4B3F13)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-11-20 at 09:17 -0800, Abbas, Mohamed wrote:
> Johannes
> The firmware will go back to the old setting, the ones before scan, once
> done scanning by it self. The calls by mac80211 after scan complete to
> set channel will be ignored by the iwl driver if we still tuned to the
> same channel, iwl wont call firmware on the same setting, it has to be a
> change to call down to firmware. I need to check what happen if user
> change channel during scan, this call might be necessary in this case.

I'd expect that either (a) the scan gets canceled and then the channel
change happens, or (b) the channel change gets queued and happens
immediately after the scan completes.  (b) is probably the easier thing
to do here unless the ucode has a cancel-scan command, but then you have
to wait until the scan is actually canceled anyway, which sort of
implies (b) too.  So maybe just do (b) and be done with it :)

Dan

> Mohamed
> 
> -----Original Message-----
> From: Johannes Berg [mailto:johannes@sipsolutions.net] 
> Sent: Tuesday, November 20, 2007 5:51 AM
> To: Zhu, Yi
> Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org; Abbas,
> Mohamed; Cahill, Ben M
> Subject: Re: [PATCH] mac80211: hardware scan rework (V2)
> 
> Hi,
> 
> Thanks!
> 
> > 1. fix a hw scan bug in ieee80211_rx_bss_info() for setting beacon
> >    supported rates
> > 2. let control frames pass in ieee80211_sta_rx_scan() during hw scan
> > 3. set local->sta_{hw|sw}_scanning type to bool
> > 4. avoid channel setting during hw scan
> 
> Why this? I was confused at first and I'm sorry if I confused you, but
> since we're now fully unaware of hardware scan thanks to your item 5, I
> think we need to allow setting channel during hardware scan so the
> firmware will change to the right channel once it finished scanning.
> 
> > 5. rework ieee80211_scan_completed() to make it symmetric for hw scan
> 
> 
> > diff --git a/net/mac80211/ieee80211_sta.c
> b/net/mac80211/ieee80211_sta.c
> > index 015b3f8..26f404a 100644
> > --- a/net/mac80211/ieee80211_sta.c
> > +++ b/net/mac80211/ieee80211_sta.c
> > @@ -1487,8 +1487,18 @@ static void ieee80211_rx_bss_info(struct
> net_device *dev,
> >  		u32 supp_rates, prev_rates;
> >  		int i, j;
> >  
> > -		mode = local->sta_scanning ?
> > +		mode = local->sta_sw_scanning ?
> >  		       local->scan_hw_mode : local->oper_hw_mode;
> > +
> > +		if (local->sta_hw_scanning) {
> > +			/* search for the correct mode matches the
> beacon */
> > +			list_for_each_entry(mode, &local->modes_list,
> list)
> > +				if (mode->mode == rx_status->phymode)
> > +					break;
> > +
> > +			if (mode == NULL)
> > +				mode = local->oper_hw_mode;
> > +		}
> 
> Good catch.
> 
> > @@ -1985,7 +2003,7 @@ void ieee80211_sta_work(struct work_struct
> *work)
> >  	if (!netif_running(dev))
> >  		return;
> >  
> > -	if (local->sta_scanning)
> > +	if (local->sta_sw_scanning || local->sta_hw_scanning)
> >  		return;
> 
> Shouldn't the sta work be able to run normally while hw scan is in
> progress?
>  
> > -	if (unlikely(local->sta_scanning != 0)) {
> > -		ieee80211_sta_rx_scan(rx->dev, skb, rx->u.rx.status);
> > +	if (unlikely(local->sta_hw_scanning))
> > +		return ieee80211_sta_rx_scan(rx->dev, skb,
> rx->u.rx.status);
> > +
> > +	if (unlikely(local->sta_sw_scanning)) {
> > +		/* drop all the other packets during a software scan
> anyway */
> > +		if (ieee80211_sta_rx_scan(rx->dev, skb, rx->u.rx.status)
> > +		    != TXRX_QUEUED)
> > +			dev_kfree_skb(skb);
> 
> Not entirely sure why we do this, but nothing we should change with this
> patch.
> 
> Other than the ioctl thing it looks good to me.
> 
> johannes
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

