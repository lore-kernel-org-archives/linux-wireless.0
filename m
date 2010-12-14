Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:55968 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932236Ab0LNQEc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 11:04:32 -0500
Subject: Re: [RFC v2 2/2] mac80211: add support for HW scheduled scan
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1292012143.3531.31.camel@jlt3.sipsolutions.net>
References: <1291993632-6921-1-git-send-email-luciano.coelho@nokia.com>
	 <1291993632-6921-3-git-send-email-luciano.coelho@nokia.com>
	 <1292012143.3531.31.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Dec 2010 18:06:10 +0200
Message-ID: <1292342770.25719.500.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-12-10 at 21:15 +0100, ext Johannes Berg wrote:
> See ... I see nothing here in main.c that would set the wiphy flag, so
> you really should've checked it in cfg8021 :-)

Heheh! Well, as we discussed on IRC, I had set the wiphy flag directly
in the driver code.  But as you recommended, I have now changed it so
that mac80211 will check if the driver has an op->sched_scan_start and
set the flag accordingly.


> > +struct ieee80211_sched_scan_ies {
> > +	u8 *ie[IEEE80211_NUM_BANDS];
> 
> const?

As discussed on IRC, in this case this doesn't need to be const.  This
struct belongs to mac80211 and it needs to write to it when preparing
the sched_scan, so no need to const it and cast back to non-const when
assigning values to it.  There no need to restrict the access to it from
the driver's point-of-view.  In normal cases, the driver should not
write to the IEs, but there's no reason to prevent it from doing it.


> > + * @sched_scan_start: Ask the hardware to start scanning repeatedly at
> > + * 	specific intervals.  The driver must call the
> > + * 	ieee80211_sched_scan_results() function whenever it finds results.
> > + * 	This process will continue until sched_scan_stop is called.
> > + *
> > + * @sched_scan_stop: Tell the hardware to stop an ongoing periodic scan.
> > + * 
> > + * ieee80211_sched_scan_results() each time it finds some results.
> 
> I think that should talk about filtering as well? Maybe a DOC: section
> would be good, dunno.

As discussed in your comments to the previous patch, I decided to leave
the filtering out for now and will add it later with a separate patch,
to keep things simple.

There was this extra "ieee80211_sched_scan_results..." pasted wrongly
there, which I have removed.


> >  /**
> > + * ieee80211_sched_scan_results - got results from periodic scan
> > + *
> > + * When a periodic scan is running, this function needs to be called by the
> > + * driver whenever there are new scan results availble.
> 
> typo: available

Fixed.


> > +TRACE_EVENT(drv_sched_scan_results,
> > +	TP_PROTO(struct ieee80211_local *local),
> > +
> > +	TP_ARGS(local),
> > +
> > +	TP_STRUCT__entry(
> > +		LOCAL_ENTRY
> > +	),
> > +
> > +	TP_fast_assign(
> > +		LOCAL_ASSIGN;
> > +	),
> > +
> > +	TP_printk(
> > +		LOCAL_PR_FMT, LOCAL_PR_ARG
> > +	)
> > +);
> 
> Shouldn't that be in the _api_ section?

Indeed.  In fact this trace was not even used anywhere.  I'll move it to
the api_ section and call it properly.


> > @@ -642,6 +642,7 @@ enum queue_stop_reason {
> >   *	that the scan completed.
> >   * @SCAN_ABORTED: Set for our scan work function when the driver reported
> >   *	a scan complete for an aborted scan.
> > + * @SCAN_SCHED_SCANNING: We're currently performing periodic scans
> 
> That reminds me ... can you scan and sched_scan at the same time?
> sched_scan while associated? Should these be prohibited, or documented
> as being implementation dependent?

With the wl12xx firmware, you can scan and sched_scan at the same time.
In theory, I haven't tried it very thoroughly.  It doesn't support
sched_scan while associated, yet.  But I think it's a good feature, eg.
for roaming, and we shouldn't restrict it in the mac80211.

I think the best is to document that it is implementation dependent.

And again, for the record, I'll implement a NL80211_SCHED_SCAN_STOPPED
event that the driver can send to userspace at any time when the
sched_scan is running.  By doing so, we allow drivers that need to stop
the scan in certain scenarios (eg. while associating or starting a
one-shot scan) to inform the userspace, which then decides whether to
restart it or not.

Maybe we just mandate that sched_scan must work when idle.  In other
cases the driver can always return -EBUSY, for instance if it doesn't
support sched_scan while associated.


> Also, how does this interact with IDLE? Obviously, the device won't be
> idle with this, but you still want it to be "otherwise" idle, no? Should
> we take this out of scanning flags and specify that it must be supported
> while the device is told that it's idle by mac80211? Do you expect this
> to be stopped before trying to associate?

The last question is easy to answer: see above. :)

About idle... I have made the assumption that we will consider
sched_scanning as idle, so mac80211 is not calling config() with
IEEE80211_CONF_CHANGE_IDLE when starting or stopping the sched_scan (it
checks local->scan_data when recalculating idle).

But indeed, now checking it more carefully,  I can see that the scanning
flags are checked in many different places.  I guess the best thing to
do is to take the sched_scan out of the scanning flags and check case by
case.  Some kind of new state... we shouldn't suspend things while
sched_scan is running.


> > @@ -392,7 +392,8 @@ ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
> >  	if (likely(!(status->rx_flags & IEEE80211_RX_IN_SCAN)))
> >  		return RX_CONTINUE;
> >  
> > -	if (test_bit(SCAN_HW_SCANNING, &local->scanning))
> > +	if (test_bit(SCAN_HW_SCANNING, &local->scanning) ||
> > +	    test_bit(SCAN_SCHED_SCANNING, &local->scanning))
> >  		return ieee80211_scan_rx(rx->sdata, skb);
> 
> This won't work while associated...

Damn, this is getting more complicated than I expected.  As discussed,
this would eat all beacons during the entire duration of the sched_scan,
so association would break.

Can I change my mind and just forbid sched_scan while not idle? :D

No seriously, I'll continue thinking aboout how to solve this tomorrow.


> > +	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
> > +		local->sched_scan_ies.ie[i] = kzalloc(2 +
> > +						      IEEE80211_MAX_SSID_LEN +
> > +						      local->scan_ies_len,
> > +						      GFP_KERNEL);
> 
> 
> Oops ... how about if this allocation fails?

Oorgh! Fixed.


> > +void ieee80211_sched_scan_results(struct ieee80211_hw *hw)
> > +{
> > +	struct ieee80211_local *local = hw_to_local(hw);
> > +
> > +	mutex_lock(&local->mtx);
> > +
> > +	cfg80211_sched_scan_results(hw->wiphy);
> > +
> > +	mutex_unlock(&local->mtx);
> 
> Does that really need locking? Seems ... pointless since cfg80211 will
> have to take care of its locking.

Indeed.  Removed the locking here.


> Finally: how does this interact with HW reset? Should it be re-started
> if it was ever started?

As described earlier, we can rely on the NL80211_SCHED_SCAN_STOPPED
event, so the userspace may decided whether to restart the sched_scan or
not.


-- 
Cheers,
Luca.

