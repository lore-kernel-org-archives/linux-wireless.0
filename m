Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59491 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab0LJUPn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 15:15:43 -0500
Subject: Re: [RFC v2 2/2] mac80211: add support for HW scheduled scan
From: Johannes Berg <johannes@sipsolutions.net>
To: luciano.coelho@nokia.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1291993632-6921-3-git-send-email-luciano.coelho@nokia.com>
References: <1291993632-6921-1-git-send-email-luciano.coelho@nokia.com>
	 <1291993632-6921-3-git-send-email-luciano.coelho@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 21:15:43 +0100
Message-ID: <1292012143.3531.31.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

See ... I see nothing here in main.c that would set the wiphy flag, so
you really should've checked it in cfg8021 :-)


> +struct ieee80211_sched_scan_ies {
> +	u8 *ie[IEEE80211_NUM_BANDS];

const?

> + * @sched_scan_start: Ask the hardware to start scanning repeatedly at
> + * 	specific intervals.  The driver must call the
> + * 	ieee80211_sched_scan_results() function whenever it finds results.
> + * 	This process will continue until sched_scan_stop is called.
> + *
> + * @sched_scan_stop: Tell the hardware to stop an ongoing periodic scan.
> + * 
> + * ieee80211_sched_scan_results() each time it finds some results.

I think that should talk about filtering as well? Maybe a DOC: section
would be good, dunno.

>  /**
> + * ieee80211_sched_scan_results - got results from periodic scan
> + *
> + * When a periodic scan is running, this function needs to be called by the
> + * driver whenever there are new scan results availble.

typo: available


> +TRACE_EVENT(drv_sched_scan_results,
> +	TP_PROTO(struct ieee80211_local *local),
> +
> +	TP_ARGS(local),
> +
> +	TP_STRUCT__entry(
> +		LOCAL_ENTRY
> +	),
> +
> +	TP_fast_assign(
> +		LOCAL_ASSIGN;
> +	),
> +
> +	TP_printk(
> +		LOCAL_PR_FMT, LOCAL_PR_ARG
> +	)
> +);

Shouldn't that be in the _api_ section?

> @@ -642,6 +642,7 @@ enum queue_stop_reason {
>   *	that the scan completed.
>   * @SCAN_ABORTED: Set for our scan work function when the driver reported
>   *	a scan complete for an aborted scan.
> + * @SCAN_SCHED_SCANNING: We're currently performing periodic scans

That reminds me ... can you scan and sched_scan at the same time?
sched_scan while associated? Should these be prohibited, or documented
as being implementation dependent?

Also, how does this interact with IDLE? Obviously, the device won't be
idle with this, but you still want it to be "otherwise" idle, no? Should
we take this out of scanning flags and specify that it must be supported
while the device is told that it's idle by mac80211? Do you expect this
to be stopped before trying to associate?

> @@ -392,7 +392,8 @@ ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
>  	if (likely(!(status->rx_flags & IEEE80211_RX_IN_SCAN)))
>  		return RX_CONTINUE;
>  
> -	if (test_bit(SCAN_HW_SCANNING, &local->scanning))
> +	if (test_bit(SCAN_HW_SCANNING, &local->scanning) ||
> +	    test_bit(SCAN_SCHED_SCANNING, &local->scanning))
>  		return ieee80211_scan_rx(rx->sdata, skb);

This won't work while associated...


> +	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
> +		local->sched_scan_ies.ie[i] = kzalloc(2 +
> +						      IEEE80211_MAX_SSID_LEN +
> +						      local->scan_ies_len,
> +						      GFP_KERNEL);


Oops ... how about if this allocation fails?

> +void ieee80211_sched_scan_results(struct ieee80211_hw *hw)
> +{
> +	struct ieee80211_local *local = hw_to_local(hw);
> +
> +	mutex_lock(&local->mtx);
> +
> +	cfg80211_sched_scan_results(hw->wiphy);
> +
> +	mutex_unlock(&local->mtx);

Does that really need locking? Seems ... pointless since cfg80211 will
have to take care of its locking.

Finally: how does this interact with HW reset? Should it be re-started
if it was ever started?

johannes

