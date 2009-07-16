Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:40853 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbZGPJut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 05:50:49 -0400
Received: by fxm18 with SMTP id 18so3978117fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 02:50:48 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC/RFT 5/5] mac80211: implement basic background scanning
Date: Thu, 16 Jul 2009 11:50:53 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <200907161104.41975.helmut.schaa@gmail.com> <200907161109.40471.helmut.schaa@gmail.com> <1247736318.24433.10.camel@johannes.local>
In-Reply-To: <1247736318.24433.10.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907161150.54237.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 16. Juli 2009 schrieb Johannes Berg:
> On Thu, 2009-07-16 at 11:09 +0200, Helmut Schaa wrote:
> 
> Looks nice! Some nitpicks ;)

Great, thanks ;)

> > Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.>
> 
> Missing "com" :)

Oops.

> > +/**
> > + * enum mac80211_scan_flag - currently active scan mode
> > + *
> > + * @SCAN_SW_SCANNING: We're off our operating channel for scanning
> > + * @SCAN_HW_SCANNING: The hardware is scanning for us, we have no way to
> > + *	determine if we are on the operating channel or not
> > + * @SCAN_BG_SCANNING: We're currently in the process of scanning but may
> > + *	as well be on the operating channel
> > + */
> >  enum mac80211_scan_flag {
> >  	SCAN_SW_SCANNING = 1,"SCAN_ENTER_OPER_CHANNEL"
> >  	SCAN_HW_SCANNING = 2,
> > +	SCAN_BG_SCANNING = 4,
> 
> There's some random stuff in there that doesn't belong.

Right, that does not belong there.

> Also I would 
> prefer you used BIT(0) etc. or maybe __test_bit().

Fine with me.

> > --- a/net/mac80211/iface.c
> > +++ b/net/mac80211/iface.c
> > @@ -513,7 +513,7 @@ static int ieee80211_stop(struct net_device *dev)
> >  			 * the scan_sdata is NULL already don't send out a
> >  			 * scan event to userspace -- the scan is incomplete.
> >  			 */
> > -			if (local->scanning & SCAN_SW_SCANNING)
> > +			if (local->scanning & SCAN_BG_SCANNING)
> >  				ieee80211_scan_completed(&local->hw, true);
> >  		}
> 
> That doesn't seem correct -- it should be kept I think.

See below.

> > diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> > index a1b4887..a87522f 100644
> > --- a/net/mac80211/main.c
> > +++ b/net/mac80211/main.c
> > @@ -198,7 +198,7 @@ void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
> >  	}
> >  
> >  	if (changed & BSS_CHANGED_BEACON_ENABLED) {
> > -		if (local->scanning & SCAN_SW_SCANNING) {
> > +		if (local->scanning & SCAN_BG_SCANNING) {
> >  			sdata->vif.bss_conf.enable_beacon = false;
> 
> That too.
> 
> > diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> > index 3df8a6e..24739ab 100644
> > --- a/net/mac80211/rx.c
> > +++ b/net/mac80211/rx.c
> > @@ -2136,7 +2136,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
> >  		return;
> >  	}
> >  
> > -	if (unlikely(local->scanning))
> > +	if (unlikely((local->scanning & SCAN_HW_SCANNING) || (local->scanning & SCAN_SW_SCANNING)))
> 
> I would prefer
> 	if (unlikely(local->scanning & (SCAN_HW_SCANNING | SCAN_SW_SCANNING)))

Ack.

> >  		rx.flags |= IEEE80211_RX_IN_SCAN;
> >  
> >  	ieee80211_parse_qos(&rx);
> > diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> > index b4cc556..8f33fb5 100644
> > --- a/net/mac80211/scan.c
> > +++ b/net/mac80211/scan.c
> > @@ -282,7 +282,7 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
> >  		cfg80211_scan_done(local->scan_req, aborted);
> >  	local->scan_req = NULL;
> >  
> > -	was_hw_scan = local->scanning & SCAN_HW_SCANNING;
> > +	was_hw_scan = !!(local->scanning & SCAN_HW_SCANNING);
> 
> Should that be in the other patch?

Yep.

> > @@ -435,7 +434,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
> >  	if (local->ops->hw_scan)
> >  		local->scanning |= SCAN_HW_SCANNING;
> >  	else
> > -		local->scanning |= SCAN_SW_SCANNING;
> > +		local->scanning |= SCAN_BG_SCANNING;
> 
> Ok now I'm confused. Did you really intend to replace all these?
> 
> Based on your initial description I thought it was going to be
> 	scanning == SW_SCANNING
> or
> 	scanning == SW_SCANNING | BG_SCANNING

It's exactly the other way round :)

It is either BG_SCANNING or SW_SCANNING | BG_SCANNING.

I already thought that this might cause confusion but I think
BG_SCANNING better reflects that we are currently running a scan
(independant of the current scan state) whereas SW_SCANNING better
reflects that we are on a different channel for scanning.

Maybe I should use other terms. Ideas?

> > +	if (local->scan_channel) {
> > +		/*
> > +		 * we're currently scanning a different channel, let's
> > +		 * switch back to the operating channel now if at least
> > +		 * one interface is associated. Otherwise just scan the
> > +		 * next channel
> > +		 */
> > +		if (associated)
> > +			local->scan_state = SCAN_ENTER_OPER_CHANNEL;
> > +		else
> > +			local->scan_state = SCAN_SET_CHANNEL;
> 
> :)
>  
> > +	/* advance to the next channel to be scanned */
> > +	*next_delay = HZ / 10;
> > +	local->scan_state = SCAN_SET_CHANNEL;
> 
> Maybe we should rename scan_state to next_scan_state.

Makes sense.

> > +	if (ieee80211_hw_config(local,
> > +					IEEE80211_CONF_CHANGE_CHANNEL))
> 
> That looks weird. I don't think you really need to care about the return
> value anyway, now that we have rfkill integrated it shouldn't ever be
> nonzero (and if it is, while rfkill is being activated, it doesn't
> really matter since we're taking down interfaces)

Ok, will change that.

> > +	/*
> > +	 * notify the AP about us being back and restart all STA interfaces
> > +	 */
> > +	mutex_lock(&local->iflist_mtx);
> > +	list_for_each_entry(sdata, &local->interfaces, list) {
> > +		if (!netif_running(sdata->dev))
> > +			continue;
> > +
> > +		/* Tell AP we're back */
> > +		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
> > +			if (sdata->u.mgd.associated) {
> > +				ieee80211_scan_ps_disable(sdata);
> > +			}
> 
> Could drop a set of {} here.

Right.

> > @@ -657,7 +760,7 @@ void ieee80211_scan_cancel(struct ieee80211_local *local)
> >  	 * queued -- mostly at suspend under RTNL.
> >  	 */
> >  	mutex_lock(&local->scan_mtx);
> > -	swscan = !!(local->scanning & SCAN_SW_SCANNING);
> > +	swscan = !!(local->scanning & SCAN_BG_SCANNING);
> 
> and another one -- please explain?

See above.

> Anyway looks pretty good to me! How does it fare during ping -f or
> something?

I compared it to the hw_scan implementation of iwlwifi. We loose a few
more frames (I guess due to not flushing the queues before channel switch)
but it's not really much, it was <1% for ping -f).

I didn't do much performance testing, just a single wget and the performance
dropped to about 50%. I still have to run some iperf tests (both RX and TX) to
see how it behaves.

Helmut
