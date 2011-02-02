Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36256 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab1BBRxa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 12:53:30 -0500
Subject: Re: [PATCH v8] mac80211: Optimize scans on current operating
 channel.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4D4997D1.5030204@candelatech.com>
References: <1296597556-17431-1-git-send-email-greearb@candelatech.com>
	 <1296652403.5671.17.camel@jlt3.sipsolutions.net>
	 <4D4997D1.5030204@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Feb 2011 18:53:29 +0100
Message-ID: <1296669209.5671.36.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-02 at 09:43 -0800, Ben Greear wrote:

> >> +	/* If this off-channel logic ever changes,  ieee80211_on_oper_channel
> >> +	 * may need to change as well.
> >> +	 */
> >
> > Would it make sense to roll this thing into one?
> >
> > Like "ieee80211_get_desired_channel(local,&chan,&chantype)"
> >
> > and then this code and on_oper_channel would use that?
> 
> As you say, the patch is big and scary already.  I would like to
> attempt this change as a small follow-on patch that does just
> one thing.  To me, the open-coded logic is a bit more similar
> to existing logic and thus easier to review.

Yeah that's a good plan.

> >> +	/* If we are scanning on-channel, pass the pkt on up the stack so that
> >> +	 * mlme can make use of it
> >> +	 */
> >> +	if (ieee80211_cfg_on_oper_channel(sdata->local)
> >> +	&&  (channel == sdata->local->oper_channel))
> >> +		return RX_CONTINUE;
> >
> > Ah, neat trick, no need to duplicate the packet :-)
> > But didn't you say this wasn't necessary since timers were stopped
> > anyway during scan? So maybe the comment shouldn't refer to scanning,
> > but other work?
> 
> Timers are stopped only if we are off-channel for scanning, I think.
> And, they are NOT stopped when we go off channel for work_work().
> Even if the packets are not currently used by the rest of the
> stack, it seems logically sound to pass them up in this case.

Right. But could you change the comment to clarify?

> >> +			/*
> >> +			 * We do need to leave operating channel, as next
> >> +			 * scan is somewhere else.
> >> +			 */
> >
> > Hmm, is that really "leave"? You aren't sorting (yet) so might this not
> > go back onto the operating channel then?
> 
> I'm checking next_chan, and it's not operating channel
> (or at least the channel_type must change), so yes, I think
> we really are leaving here.

Ok.

> >> +++ b/net/mac80211/tx.c
> >> @@ -257,7 +257,8 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
> >>   	if (unlikely(info->flags&  IEEE80211_TX_CTL_INJECTED))
> >>   		return TX_CONTINUE;
> >>
> >> -	if (unlikely(test_bit(SCAN_OFF_CHANNEL,&tx->local->scanning))&&
> >> +	if (unlikely(test_bit(SCAN_SW_SCANNING,&tx->local->scanning))&&
> >> +	    test_bit(SDATA_STATE_OFFCHANNEL,&tx->sdata->state)&&
> >
> > Shouldn't that be || ? Or only the off-channel check I think?
> 
> The old check was for scan-off-channel flag.  That is equiv
> to sw-scanning AND state-offchannel.

Oh, true. I was just thinking this should also kick in for work stuff
off-channel.

Come to think of it -- what if work isn't off-channel, but needs to
disable powersave?

> One thing:  If we are normally operating in HT40 mode, we have to
> shift to NO_HT for scanning.  But, I think we could probably still
> transmit packets even if we are temporarily in NO_HT, right?

Oh, hmm, that might be tricky depending on the rate scale algorithm and
the device. But do we really have to shift to NO_HT for scanning?

> So,
> follow-on patches might be able to relax the is-on-channel checks
> slightly to take channel-type co-existence into account.

Right.

> v9 coming soon :)

:)

Thanks!

johannes

