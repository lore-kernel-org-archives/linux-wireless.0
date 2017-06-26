Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33212 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750832AbdFZO1J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Jun 2017 10:27:09 -0400
Message-ID: <1498487226.24675.3.camel@sipsolutions.net> (sfid-20170626_162712_909431_413A9333)
Subject: Re: [RFC 3/6] mac80211: add a TXQ for other powersave-buffered
 frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org
Cc: nbd@nbd.name
Date: Mon, 26 Jun 2017 16:27:06 +0200
In-Reply-To: <b01d8009-80ba-e437-02b8-5a120c2927e4@candelatech.com>
References: <20170621235022.25362-1-johannes@sipsolutions.net>
         <20170621235022.25362-3-johannes@sipsolutions.net>
         <63c97c53-af93-107a-a28e-59cebcf01fd6@candelatech.com>
         <1498112650.2246.1.camel@sipsolutions.net>
         <3735eb1d-89b5-b4ad-6657-d0d4e9642574@candelatech.com>
         <1498209700.2595.2.camel@sipsolutions.net>
         <89353e7a-5c61-eba3-fe34-0e7eadf7588e@candelatech.com>
         <1498474826.3318.4.camel@sipsolutions.net>
         <b01d8009-80ba-e437-02b8-5a120c2927e4@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-06-26 at 07:15 -0700, Ben Greear wrote:

> > This *can* be solved, even in this piece of code I inserted here,
> > but it'd have to keep state about the queues and then insert some
> > hooks elsewhere. I'm pretty sure I can solve that, but don't have
> > the time (or even hardware) to test this (easily, I have ath10k in
> > a few routers, but ...).
> 
> What/how is it relying on buffering?

So with the TXQs, I thought we were only buffering in mac80211 on the
TXQs themselves. This isn't true though!

We still have the local->pending queues, and the drivers will still
rely on this for all the frames that are *not* going through a TXQ,
which currently is:
 * all non-data frames
 * multicast data frames if they need to be sent after DTIM
   (not sure why this is - doesn't make much sense to me to
    differentiate immediate and after-DTIM transmissions)
 * data frames to stations the driver doesn't know about (yet)

In this case, the driver can still call ieee80211_stop_queue() or
similar, and expect frames to be buffered. I completely failed to take
that into account in this patchset; the dequeue logic I added to ath9k
and ath10k would have to take that into account and not dequeue if the
corresponding queue was stopped.

I think we'll probably have to put this logic into the current
driver(s); I was planning to put it into mac80211 for non-TXQ drivers,
but the ones already using TXQs would have to deal with it, since it'd
be really hard to make mac80211 logic kick in only partially for some
TXQs and not for others.

However, due to all the different levels of buffering we need more TXQs
than I introduced in this patchset (except I really don't want to
introduce one for per-vif-multicast-dtim-buffered-data ...)

> I'd be happy to send you plenty of ath10k mini-pcie NICs if that
> would help.

No need; I have no doubt that I could obtain them, but now I'll be
going on sabbatical for 2 months anyway :-)

johannes
