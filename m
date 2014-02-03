Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37519 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbaBCNl5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 08:41:57 -0500
Message-ID: <1391434913.4488.24.camel@jlt4.sipsolutions.net> (sfid-20140203_144205_347547_0B1629BE)
Subject: Re: [RFC 2/2] cfg80211: move channel switch logic to cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 03 Feb 2014 14:41:53 +0100
In-Reply-To: <1391421529-6067-3-git-send-email-michal.kazior@tieto.com> (sfid-20140203_110356_335827_0A67B036)
References: <1391421529-6067-1-git-send-email-michal.kazior@tieto.com>
	 <1391421529-6067-3-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140203_110356_335827_0A67B036)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-02-03 at 10:58 +0100, Michal Kazior wrote:
> This introduces the following benefits:
>  * cfg80211 is now aware of channel switching
>    (although more work still needs to be done wrt
>     interface combinations & multi-interface CSA)
>  * fixes some channel switching failcases by
>    disconnecting offending interfaces
>  * STA CSA no longer modifies BSS channel from
>    within mac80211

That's nice.

> This aims to make the following possible later:
>  * defer channel switching decision to userspace
>    (if desired so),

That's probably not needed, it can disconnect after the CSA event (that
should be sent when the CSA is first received)

>  * inform userspace what interfaces will be
>    possibly disconnected by a channel switch,

Huh? Not sure I get that part, why would userspace ever be notified
about something that *will* happen? Either the interface disconnects
when the CSA is received, or it just switches and userspace gets a "CSA
will happen" event?

>  * disconnect non-complying interfaces that were
>    sharing a channel that is being abandoned by
>    channel switching interface(s),

Hmm, that sounds a bit the wrong way around? Shouldn't the CSA not be
possible (userspace CSA) or cause the switching interface to disconnect,
rather than *others*??

> - * @channel_switch: initiate channel-switch procedure (with CSA)
> + * @ch_switch_start: initiate channel-switch procedure (with CSA). This should
> + *	prompt the driver to perform preparation work (start some timers,
> + *	include CS IEs in beacons, etc) but don't do an actual channel switch.
> + *	Once driver has completed all preparations and is ready for the actual
> + *	switch (after CSA counter is completed) it must call
> + *	cfg80211_ch_switch_complete(wdev). After that ch_switch_finalize() MAY
> + *	be called, but it doesn't necessarily happen immediately as cfg80211
> + *	may need to synchronize with other interfaces. If channel switch is
> + *	cancelled for some reason ch_switch_finalize() is not called and driver
> + *	should free up resources/cleanup state in interface disconnection flow.
> + * @ch_switch_finalize: finalize channel-switch procedure, i.e. perform the
> + *	actual switch.

I don't like this at all. This totally assumes that every driver behaves
like mac80211, which clearly is not the case. The split between
"starting" and "finalizing" it should not be part of the API.

>  /**
> + * enum cfg80211_chsw_state - interface channel switch state
> + *
> + * @CHSW_STATE_NONE: channel switch is not active
> + * @CHSW_STATE_REQUESTED: channel switch has been requested but not processed
> + * @CHSW_STATE_STARTED: channel switch has been processed and accepted
> + * @CHSW_STATE_COMPLETED: channel switch has been scheduled for finalization
> + * @CHSW_STATE_SYNCING: interface is ready for channel to be re-programmed in
> + *	driver. Interface may remain in this state until some additional
> + *	requirements are met, i.e. wait until other channel switch requests on other
> + *	interfaces are synching as well.
> + */

This therefore doesn't belong into cfg80211, at least not all of it.

[snip rest that seemed pointless to look at now]

johannes

