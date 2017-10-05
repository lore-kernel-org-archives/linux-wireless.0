Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:42732 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751536AbdJEQn6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Oct 2017 12:43:58 -0400
Message-ID: <1507221836.2387.66.camel@sipsolutions.net> (sfid-20171005_184401_350622_C89B8832)
Subject: Re: converting mac80211 to TXQs entirely
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless <linux-wireless@vger.kernel.org>
Cc: nbd <nbd@nbd.name>
Date: Thu, 05 Oct 2017 18:43:56 +0200
In-Reply-To: <87efqhsgni.fsf@toke.dk>
References: <1507205618.2387.19.camel@sipsolutions.net>
         <1507217947.2387.60.camel@sipsolutions.net> <87efqhsgni.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-10-05 at 18:28 +0200, Toke Høiland-Jørgensen wrote:

> I'm been thinking about how to move the airtime fairness scheduler
> out of ath9k and into mac80211 (so more drivers can take advantage of
> it). This will require some changes to the TXQ API that drivers speak
> to, so wanted to add my thoughts here to make sure it's compatible
> with your thinking.
> 
> I think the easiest way to have mac80211 handle airtime fairness is
> to add a way for ieee80211_tx_dequeue() to return some sort of DEFER
> signal which semantically means "there is no packet for this queue
> right now, but please keep scheduling it" (which would be the result
> of a TXQ belonging to a station that has used its airtime quota but
> still has packets pending). This is different from the current
> meaning of NULL, which will make the driver stop scheduling that TXQ
> until it gets a new wake signal.

I think that's reasonable. I'm not really sure it's *necessary* though?
Couldn't mac80211 return NULL, and then simply call wake_tx_queue again
when the TXQ becomes eligible for scheduling again? Otherwise the
driver might end up doing a lot of polling for it to become eligible
again?

I've mostly glossed over a mac80211 scheduler, which is obviously
needed as part of a complete conversion, and it'd just have to
integrate with this new return value.

> The alternative would be to change the API so the driver asks
> mac80211 which TXQ it should pull from next, instead of doing its own
> scheduling as it does now. But I'm not sure that's doable with a sane
> API.
> 
> Now, I believe this is related to this point of yours:
> 
> > 5) handle non-data frames for vifs
> > 
> > Similarly, we need a vif->nondata_txq where we can put probe
> > responses and the (few) other frames that we send before we have a
> > station entry.
> > 
> > According to my earlier analysis (previous email) after these steps
> > we have a TXQ for all frames. All of these steps will require
> > certain adjustments in the drivers currently using TXQs (ath9k &
> > ath10k) since they'll be relying on some amount of buffering and
> > queue stop/wake in mac80211 for these frames. We might just have to
> > add some API to ask "is queue stopped" to make the transition here
> > easy.
> 
> And I'm wondering if this "is queue stopped" API could be the same
> one used for the airtime DEFER case?

I think these are two completely different cases.

The "is queue stopped" I was thinking of would be basically checking
the variable local->queue_stop_reasons, so that the driver could still
use the stop_queue API(s). Yeah, this would be very roundabout, but as
a conversion step I think that'd not be a bad thing.

A more complete conversion likely wouldn't need this, but would instead
have the driver record its own stop reasons and just stop scheduling
those TXQs that belong to a stopped "class" (it's no longer really a
queue).

(and for mac80211 stop reasons, it would just return NULL and re-
schedule the TXQ when it becomes eligible again)


> Oh, and BTW: I see this is on the list of topics for the wireless
> summit in Seoul. How do I go about signing up for that? I'll be at
> netdev talking about some of this stuff anyway[1] :)

Just show up there, or you can add yourself to the list on the wiki
page :)

johannes
