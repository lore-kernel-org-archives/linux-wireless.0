Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47429 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab1CNRjB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 13:39:01 -0400
Received: by iwn34 with SMTP id 34so5151923iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 10:39:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300119843.3802.21.camel@jlt3.sipsolutions.net>
References: <AANLkTi=taszKd9-kyijN100oEegnFi=0u5L4WCp7R_sJ@mail.gmail.com> <1300119843.3802.21.camel@jlt3.sipsolutions.net>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Mon, 14 Mar 2011 10:38:40 -0700
Message-ID: <AANLkTinnCD9eFJ2r21SOGd3zNj1dxmrXa_xqbEoq8--w@mail.gmail.com>
Subject: Re: bug: iwlwifi, aggregation, and mac80211's reorder buffer
To: Johannes Berg <johannes@sipsolutions.net>
Cc: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 14, 2011 at 9:24 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2011-03-11 at 00:11 -0800, Daniel Halperin wrote:
>
>> One thing that Intel does that ath9k does not is transmit packets out
>> of sequence number order inside a batch.  (This is legal in the 802.11
>> standard).
>
> Even if that's legal it seems very strange? Do you have packet captures
> of this by any chance?

I can acquire and send you some logs. I'm not sure whether packet logs
work -- last I checked [3 yrs ago] iwlwifi monitor mode didn't pick up
agg batches to other destinations -- and I'm not sure where in the
stack packet logs fall when taken on the host (e.g., before or after
the reorder buffer?).

What I did log was the reported sequence numbers from
iwlagn_tx_status_reply_tx. What you see is:

enqueued frame 1
enqueued frame 2
enqueued frame 3
enqueued frame 4
...
enqueued frame 31
<got compressed block-ack only missing frame 2>

enqueued frame 32
enqueued frame 33
enqueued frame 34
enqueued frame 35
enqueued frame 36
enqueued frame 2
enqueued frame 37
enqueued frame 38

In other words, it looks like the scheduler hardware is preloading
some of these frames before it gets the compressed BA, allowing the
window to be larger than 31 frames.  Here, even if frame 2 is
received, mac80211 will have already dumped through frame 36: RX of
frame 33 causes it to shift the window past 2 and thus dump the
entirely successfully received window from 3 through 36.

I'll get logs to confirm this a bit later.  (this example is made up
and assumes iwlwifi's default limit of 31 frames)

>> I figured that one explanation for the TCP SACKs would be
>> if, somehow, frames got released to the network stack out of order;
>> indeed, many of the "holes" covered by the SACKs are filled quickly
>> (within ~4ms, about the length of one aggregation batch).  Note that
>> iwlwifi defaults to an aggregation frame limit, hence buffer size, of
>> 31 frames.  mac80211 honors this buffer size specification by
>> releasing frames to the network stack that are >= 31 sequence numbers
>> below the highest received frame.
>>
>> It looks like Intel doesn't honor its own frame limit, as I often saw
>> it have more than 31 frames outstanding, causing mac80211 on the
>> receiver to release many frames early.  Changing iwlwifi's default agg
>> limit to 63 frames on both ends dramatically reduced the prevalence of
>> SACKs/TCP retransmissions and improved avg TCP performance to ~100
>> Mbps (ranging 83-110).
>
> Great ... what if you just change the mac80211 code like you suggested?
> Does that already help, by making the receiver have a larger window?

Yes. The mac80211 code change I suggested makes Intel work better
regardless of Intel's frame limit.

>> (2) Is there a way to make iwlwifi honor the aggregation limit?  I
>> know that agg is controlled by a hardware scheduler, so this may be
>> difficult.
>
> Heh. I'd hope it already does but I guess if it doesn't then there's
> little we can do (but internally report a bug). This is actually not
> just a throughput problem, but also a correctness issue, since some
> devices do not allow for receiving long aggregates!

Yep. It looks like Intel correctly sends only 31 frames in a batch,
but lets more than 31 frames be in the **window** as described above.

>> (3) mac80211's reorder buffer code could probably also be relaxed.  It
>> probably wouldn't hurt to have the buffer be twice the transmitter's
>> advertised buffer, and might compensate for devices that don't
>> properly honor frame limits.
>
> Well, it doesn't make sense to go above 64, no? Can't have reordering
> across aggregates.

I think that's true, yes.  When I said "twice" I meant min(2*RX
bufsize, 64).  Twice makes sense when the default is 31 ;).

>> Also, mac80211 only flushes the reorder
>> buffer every 100 ms.  That seems like a LONG time given that batches
>> are limited to 4ms -- 100ms is room for at least 10, maybe 20
>> retransmissions to attempt to fill in the holes(!).
>
> Yeah that's true, but you don't really know how much time there is
> between retries, bluetooth for example might block the retransmission
> for quite a while.

Fair enough.

>> (4) even after this fix, I see a few SACKs, and even when there aren't
>> SACKs I still see TCP "dead time" up to ~100ms.  What else would you
>> use to debug this setup?

It's been several days more of debugging so I'm not *positive*, but I
believe "after this fix" probably meant the iwlwifi->63 change, and
maybe also the mac80211->64 change.

Dan
