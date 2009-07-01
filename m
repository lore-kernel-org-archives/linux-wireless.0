Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:56158 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbZGAK7B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 06:59:01 -0400
Received: by bwz25 with SMTP id 25so428005bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jul 2009 03:59:03 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Some thoughts about background scanning
Date: Wed, 1 Jul 2009 12:59:02 +0200
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <200907011003.49857.helmut.schaa@gmail.com> <1246441038.4131.12.camel@johannes.local>
In-Reply-To: <1246441038.4131.12.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907011259.02946.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, 1. Juli 2009 schrieb Johannes Berg:
> > My current approach is quite easy but works well: Extend the scan state
> > machine with a new state (OPERATION) which restores the channel and the
> > correct filter flags and notifies the AP that we're back. 
> 
> Makes sense. You can optimise scanning for the _current_ channel by a
> combination of OPERATION and scanning, leaving the filter flags at the
> scan version, and sending the probe requests. In fact, if you scan that
> channel first, you can avoid IEEE80211_PROBE_DELAY since the NAV should
> be known on that channel.
> 
> Tangentially related, we can also move into SCAN_SEND_PROBE _before_
> IEEE80211_PROBE_DELAY has passed, if we receive a frame (which means NAV
> update).

Correct, that would be another minor optimzation.

> > The state
> > machine moves there after every scanned channel. The result is that
> > the complete scan can take quite some time, something a round 15 seconds.
> 
> That doesn't sound too bad. How long are you staying on the operational
> channel though?

I used the beacon interval of the currently associated AP (100ms here).
Hence, we can be sure that we receive at least one beacon from that AP
and would notice if the AP is gone in the meantime. Of course that can
be optimized by the approach I described in the last mail by proceeding
with the scan once we receive a beacon without TIM bit set.

> > Scanning multiple channels before switching back would allow us to
> > reduce the amount of time the scan takes. So, what I'd like to have is
> > integration with pm_qos in order to determine how much channels may be
> > scanned at once before we have to switch back. Shouldn't be that
> > difficult ;) 
> 
> You might be able to use local->hw.conf.max_sleep_period from
> ieee80211_recalc_ps? Or probably better move the calculation into a 
> helper function since it needs to work across all managed interfaces, if
> there are multiple.

Yep. Already thought about that one. It only needs minor adjustments (for
example it is only available if powersave is done within mac80211).

[...]

> > Advantages:
> > 
> > We could split the actual scan algorithm out of the scan state machine,
> > for example if pm_qos allows us to stay away for 150ms we could reorder
> > the channels to scan one active channel followed by one passive channel
> > before switching back to the operating channel. Should allow us to use
> > all sorts of insane optimizations.
> 
> :)
> It might be better to have even more states, e.g. make the list look
> like this:
>  - SWITCH_TO 2412 MHz
>  - NAV_WAIT max 33ms
>  - SEND_PROBES
>  - WAIT_PROBES
>  - SWITCH_TO (operation channel)
>  - OPERATION
> ...
> 
> That way we can short-circuit the NAV_WAIT on receiving a frame, for
> example. We don't receive all frames, of course, so it would be useful
> to have some driver assistance for that at some point too.

Yeah, cool idea. Have to think about which states make sense and which
don't.

> > In some cases we might shorten the pre-computed values. For example if
> > we switch back to the operating channel and receive a beacon without
> > TIM being set for our association and our TX queue is empty we might
> > immediately proceed with the scan without having to stay on the channel
> > for the full amount of time. Not sure if we can do this properly without
> > recomputing the whole table (depends on the actual algorithm used).
> 
> I think short-circuiting states should be possible from the outside for
> the NAV wait too.

Agreed.

> > Does that kind of approach sound useful? Is it overkill?
> 
> Seems useful to me :)

Great, thanks. I'll look into it some more.

Helmut

