Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:20456 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758551AbXKTQXe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 11:23:34 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH] mac80211: hardware scan rework (V2)
Date: Tue, 20 Nov 2007 08:23:24 -0800
Message-ID: <4220499A1B034C4FA93B547BA01E1FF001746499@orsmsx413.amr.corp.intel.com> (sfid-20071120_162352_025167_413D9ECB)
In-Reply-To: <1195566632.10920.39.camel@johannes.berg>
References: <119553601948-git-send-email-yi.zhu@intel.com> <1195566632.10920.39.camel@johannes.berg>
From: "Cahill, Ben M" <ben.m.cahill@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"Zhu, Yi" <yi.zhu@intel.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 

> -----Original Message-----
> From: Johannes Berg [mailto:johannes@sipsolutions.net] 
> Sent: Tuesday, November 20, 2007 8:51 AM
> To: Zhu, Yi
> Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org; 
> Abbas, Mohamed; Cahill, Ben M
> Subject: Re: [PATCH] mac80211: hardware scan rework (V2)
> 
> Hi,
> 
> Thanks!
> 
> > 1. fix a hw scan bug in ieee80211_rx_bss_info() for setting beacon
> >    supported rates
> > 2. let control frames pass in ieee80211_sta_rx_scan() 
> during hw scan 
> > 3. set local->sta_{hw|sw}_scanning type to bool 4. avoid channel 
> > setting during hw scan
> 
> Why this? I was confused at first and I'm sorry if I confused 
> you, but since we're now fully unaware of hardware scan 
> thanks to your item 5, I think we need to allow setting 
> channel during hardware scan so the firmware will change to 
> the right channel once it finished scanning.

The firmware-driven scan on 4965 (3945 also) returns to the original
channel by itself.  It might even do this several times while scanning a
given list of channels, depending on how the timing is set up.  Within
the uCode scan command, the driver sets "max_out_time" to restrict the
scan engine from being away from the service (network) channel longer
than a certain amount of time.  The scan engine will work its way
through the channel list until it doesn't have enough time to complete
the next channel's scan, then it returns to the service channel.

Conversely, the "suspend_time" controls how long the scan engine stays
back on the service channel (after returning from a scan channel) before
resuming the scan with the next channel on the list.  

If the "max_out_time" is set short, then the scan engine will take
several iterations before it completes the list of scan channels.  This
is the mechanism that keeps traffic "flowing" during the course of a
scan.

Once done with the list, the scan engine returns to the service channel
automatically.  While it *might* work okay to change or reset that
channel, it is not necessary, and might be asking for trouble.

-- Ben --

> 
> > 5. rework ieee80211_scan_completed() to make it symmetric 
> for hw scan
> 
> 
> > diff --git a/net/mac80211/ieee80211_sta.c 
> > b/net/mac80211/ieee80211_sta.c index 015b3f8..26f404a 100644
> > --- a/net/mac80211/ieee80211_sta.c
> > +++ b/net/mac80211/ieee80211_sta.c
> > @@ -1487,8 +1487,18 @@ static void 
> ieee80211_rx_bss_info(struct net_device *dev,
> >  		u32 supp_rates, prev_rates;
> >  		int i, j;
> >  
> > -		mode = local->sta_scanning ?
> > +		mode = local->sta_sw_scanning ?
> >  		       local->scan_hw_mode : local->oper_hw_mode;
> > +
> > +		if (local->sta_hw_scanning) {
> > +			/* search for the correct mode matches 
> the beacon */
> > +			list_for_each_entry(mode, 
> &local->modes_list, list)
> > +				if (mode->mode == rx_status->phymode)
> > +					break;
> > +
> > +			if (mode == NULL)
> > +				mode = local->oper_hw_mode;
> > +		}
> 
> Good catch.
> 
> > @@ -1985,7 +2003,7 @@ void ieee80211_sta_work(struct 
> work_struct *work)
> >  	if (!netif_running(dev))
> >  		return;
> >  
> > -	if (local->sta_scanning)
> > +	if (local->sta_sw_scanning || local->sta_hw_scanning)
> >  		return;
> 
> Shouldn't the sta work be able to run normally while hw scan 
> is in progress?
>  
> > -	if (unlikely(local->sta_scanning != 0)) {
> > -		ieee80211_sta_rx_scan(rx->dev, skb, rx->u.rx.status);
> > +	if (unlikely(local->sta_hw_scanning))
> > +		return ieee80211_sta_rx_scan(rx->dev, skb, 
> rx->u.rx.status);
> > +
> > +	if (unlikely(local->sta_sw_scanning)) {
> > +		/* drop all the other packets during a software 
> scan anyway */
> > +		if (ieee80211_sta_rx_scan(rx->dev, skb, rx->u.rx.status)
> > +		    != TXRX_QUEUED)
> > +			dev_kfree_skb(skb);
> 
> Not entirely sure why we do this, but nothing we should 
> change with this patch.
> 
> Other than the ioctl thing it looks good to me.
> 
> johannes
> 
