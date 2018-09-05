Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:42276 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbeIEOUV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 10:20:21 -0400
Message-ID: <1536141045.3528.4.camel@sipsolutions.net> (sfid-20180905_115059_607216_1B560655)
Subject: Re: [PATCH] mac80211: use non-zero TID only for QoS frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>
Date: Wed, 05 Sep 2018 11:50:45 +0200
In-Reply-To: <87in3k6zti.fsf@toke.dk>
References: <20180905080036.9177-1-johannes@sipsolutions.net>
         <87in3k6zti.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-09-05 at 11:47 +0200, Toke Høiland-Jørgensen wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > Some frames may have a non-zero skb->priority assigned by
> > mac80211 internally, e.g. TDLS setup frames, regardless of
> > support for QoS.
> > 
> > Currently, we set skb->priority to 0 for all data frames.
> > Note that there's a comment that this is "required for
> > correct WPA/11i MIC", but that doesn't seem true as we use
> > 
> >         if (ieee80211_is_data_qos(hdr->frame_control))
> >                 qos_tid = ieee80211_get_tid(hdr);
> >         else
> >                 qos_tid = 0;
> > 
> > in the code there. We could therefore reconsider this, but
> > it seems like unnecessary complexity for the unlikely (and
> > not very useful) case of not having QoS on the connection.
> > 
> > This situation then causes something strange - most data
> > frames will go on TXQ for TID 0 for non-QoS connections,
> > but very few exceptions that are internally generated will
> > go on another TXQ, possibly causing confusion.
> 
> What kind of confusion are you seeing? Reordering issues, or something
> else?

I haven't actually been able to test this...

But with the iwlwifi work we're doing, at the very least we'd waste a
hardware queue for the case that basically never happens, since you'd
end up putting these frames (that are very few) on a separate TXQ and
thus hardware queue.

You could argue we should explicitly _not_ do this, but then we should
also set skb->priority to be non-zero for non-QoS stations. Then we
could benefit from some form of QoS (between the TXQs) for non-QoS
connections, but that seems pretty complex and doesn't seem worth it
since all connections that want anything from HT/11n and newer need QoS
anyway.

So basically this gets rid of a corner case that we shouldn't have.
Either we should decide that using different TXQs is *always* correct
for non-QoS, or - what I thought - that this isn't worth it, and then we
should *never* do it.

johannes
