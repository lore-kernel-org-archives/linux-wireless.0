Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:42230 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754469AbeGCJpV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jul 2018 05:45:21 -0400
Message-ID: <1530611118.4735.13.camel@sipsolutions.net> (sfid-20180703_114524_793674_7B5F3D61)
Subject: Re: [PATCH] mac80211: add stop/start logic for software TXQs
From: Johannes Berg <johannes@sipsolutions.net>
To: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 03 Jul 2018 11:45:18 +0200
In-Reply-To: <87345305-94d2-7c5e-379e-757670b7e59f@codeaurora.org>
References: <1529997415-20551-1-git-send-email-mpubbise@codeaurora.org>
         <1530263375.3481.23.camel@sipsolutions.net>
         <87345305-94d2-7c5e-379e-757670b7e59f@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-07-02 at 14:48 +0530, Manikanta Pubbisetty wrote:
> > 
> > > @@ -298,10 +354,15 @@ static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
> > >   	if (local->q_stop_reasons[queue][reason] == 0)
> > >   		__clear_bit(reason, &local->queue_stop_reasons[queue]);
> > >   
> > > +	if (local->ops->wake_tx_queue)
> > > +		__clear_bit(reason, &local->txqs_stopped);
> > > +
> > >   	if (local->queue_stop_reasons[queue] != 0)
> > >   		/* someone still has this queue stopped */
> > >   		return;
> > >   
> > > +	ieee80211_wake_txqs(local);
> > 
> > I'm not sure this is the right place to hook in?
> > 
> > This might interact really strangely with drivers - which also get here.
> > Perhaps we should make this conditional on reason != DRIVER?
> 
> Good point!  IMO the condition (reason != DRIVER) does not fit well; if 
> the reason for stop queues is DRIVER then we don't get a chance to wake 
> them again. May be deferring the wake_txqs by scheduling a tasklet 
> should help?

Not sure what you mean? But I see what I said was also confusing.

What I meant is that we should just not allow the driver to stop the
TXQs this way - if it's a TXQ driver then it should just stop scheduling
if it needs to, it shouldn't continue scheduling and rely on us blocking
it.

We, for mac80211's purposes, need to stop, cannot influence scheduling
and want to unify it with the 'normal' queue stop - so my thought would
be that we should only set the TXQ to stopped if the reason isn't
DRIVER.

johannes
