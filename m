Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:54005 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751178AbdJEQ2i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Oct 2017 12:28:38 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Cc: nbd <nbd@nbd.name>
Subject: Re: converting mac80211 to TXQs entirely
In-Reply-To: <1507217947.2387.60.camel@sipsolutions.net>
References: <1507205618.2387.19.camel@sipsolutions.net> <1507217947.2387.60.camel@sipsolutions.net>
Date: Thu, 05 Oct 2017 18:28:33 +0200
Message-ID: <87efqhsgni.fsf@toke.dk> (sfid-20171005_182842_039833_DF76AD5C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Part 2 - where can we go from here
>
>
> Of course - as mentioned in the subject - my goal is to just convert
> over to TXQs entirely in mac80211. That would get rid of a LOT of
> special case code, like queueing for aggregation setup, powersave
> buffering (both unicast and multicast), etc.


At first glance this looks like a decent way forward. I'll think about
it some more and comment again later, but for now I just wanted to add
this:

I'm been thinking about how to move the airtime fairness scheduler out
of ath9k and into mac80211 (so more drivers can take advantage of it).
This will require some changes to the TXQ API that drivers speak to, so
wanted to add my thoughts here to make sure it's compatible with your
thinking.

I think the easiest way to have mac80211 handle airtime fairness is to
add a way for ieee80211_tx_dequeue() to return some sort of DEFER signal
which semantically means "there is no packet for this queue right now,
but please keep scheduling it" (which would be the result of a TXQ
belonging to a station that has used its airtime quota but still has
packets pending). This is different from the current meaning of NULL,
which will make the driver stop scheduling that TXQ until it gets a new
wake signal.

The alternative would be to change the API so the driver asks mac80211
which TXQ it should pull from next, instead of doing its own scheduling
as it does now. But I'm not sure that's doable with a sane API.

Now, I believe this is related to this point of yours:

> 5) handle non-data frames for vifs
>
> Similarly, we need a vif->nondata_txq where we can put probe responses
> and the (few) other frames that we send before we have a station entry.
>
> According to my earlier analysis (previous email) after these steps we
> have a TXQ for all frames. All of these steps will require certain
> adjustments in the drivers currently using TXQs (ath9k & ath10k) since
> they'll be relying on some amount of buffering and queue stop/wake in
> mac80211 for these frames. We might just have to add some API to ask
> "is queue stopped" to make the transition here easy.

And I'm wondering if this "is queue stopped" API could be the same one
used for the airtime DEFER case?


Oh, and BTW: I see this is on the list of topics for the wireless summit
in Seoul. How do I go about signing up for that? I'll be at netdev
talking about some of this stuff anyway[1] :)

-Toke

[1] https://www.netdevconf.org/2.2/session.html?jorgensen-wifistack-talk
