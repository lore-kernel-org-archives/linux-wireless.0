Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37221 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab2FZNKg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 09:10:36 -0400
Message-ID: <1340716233.14634.31.camel@jlt3.sipsolutions.net> (sfid-20120626_151040_748067_29396226)
Subject: Re: mac80211 auth/assoc in multi-channel scenarios
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: Eliad Peller <eliad@wizery.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 26 Jun 2012 15:10:33 +0200
In-Reply-To: <CA+XVXffLy5mSqXTtEh7STC_xtSKOJTdtVF9jGPj5UEQ88wD+LQ@mail.gmail.com> (sfid-20120626_133531_465169_24BA84E2)
References: <1340640308.27437.16.camel@jlt3.sipsolutions.net>
	 <CAB3XZEe7t3MYVv6Bja9X315CuhWa=aaEyB82pGp_9hMp8grbMg@mail.gmail.com>
	 <1340707305.14634.9.camel@jlt3.sipsolutions.net>
	 <CAB3XZEfEB2TaeN4EYGyBmcuh823EfmdLhSWE55u5OwPE+Ff7oQ@mail.gmail.com>
	 <CA+XVXffLy5mSqXTtEh7STC_xtSKOJTdtVF9jGPj5UEQ88wD+LQ@mail.gmail.com>
	 (sfid-20120626_133531_465169_24BA84E2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-26 at 14:35 +0300, Arik Nemtsov wrote:

> >> Yes, we should keep that in mind, but I have a feeling that we should
> >> treat it separately. It's quite different as mac80211 is doing a lot
> >> less -- for example, mac80211 is managing retries, comeback timeouts,
> >> etc. in the managed case.
> >>
> > i guess it makes sense. i just don't like it being managed in multiple
> > places (userspace for ap, kernel for sta).
> 
> I also think managing this in multiple places can get messy. I
> slightly prefer Eliad's approach with userspace giving the ROCs, since
> it sees the bigger picture.

Yeah but I don't think the bigger picture actually helps much in this
case. The details matter much more.

Imagine userspace asking to ROC and then to authenticate when the ROC is
accepted. Then the first question is -- how long should the ROC period
be? mac80211 will transmit an auth frame, but if it doesn't get an
answer it will retransmit up to 2 times with 100ms delay. That's
*highly* implementation dependent, I don't think any other (full-MAC)
driver would do exactly the same thing. So this means you'd need about
300ms ROC time.

OTOH, WFA mandates replies within 30ms. So it makes much more sense to
have ~35ms ROC time and try a new one if it fails for some reason,
right?

The next question is whether to use a new ROC for assoc or not. How much
time is left on the ROC? Should you cancel it (could be inefficient) and
then start a new one? How can you make that decision.

And now this is just why it won't work even if we start from a clean
slate -- I haven't even talked about the backward compatibility aspect,
running an old supplicant on a driver that expects a ROC. Remember that
the driver need not give the virtual interface *any* channel time on the
right channel before needed, so if there's something going on on another
channel with multi-channel, that vif would never be able to authenticate
with an old supplicant.

I could also mention how this is a stupid userspace API, you're now
requiring to call one thing before another call is valid, but then the
other call is only very briefly valid? If we really wanted ROC, we
should embed the time for it into the auth/assoc request, I'd say.

Thinking about that though -- what for connect() calls? Whole new can of
worms ...

So I really don't see how ROC from userspace makes any sense in this
case or is even workable.

> But all userspace changes are reflected in the STA flags in kernel, so
> we can do STA + AP from kernel mode as well.

Yes, but it would need this patch and a change to hostapd to add the
station when it sends the first auth frame:
http://johannes.sipsolutions.net/patches/kernel/all/LATEST/005-nl80211-full-sta-state.patch

I haven't yet had a chance to look at this again in more detail, in
particular we need a matching hostapd implementation of course.
This would require the assumption though that when hostapd adds a
station it will also send an auth response and the client will request
assoc, but that seems like a reasonable assumption (and hostapd would
have to make assumptions about the client just as mac80211 would.)

This would probably make it possible to implement such "give it airtime"
behaviour entirely within the sta_state() callback in the driver, which
isn't really possible in the managed case.

> Can you give a bit more info on the Tx-sync approach, for the uninitiated?
> I'm also thinking that maybe we could somehow treat the sleeping-GO as
> a special case (maybe with some special code and a HW flag). Right now
> I'm not sure the wl12xx FW even supports it.

Well so the sleeping-GO case is basically that the GO could be asleep at
any time (even opportunistic PS), so you would want to receive a beacon
from it before you send an auth frame.

The TX-sync name goes back to the tx_sync API I had at some point to
handle this case, now we handle it a bit differently (but not very well)
so I removed that because the implementation details were pretty ugly,
but for the future we want something better :-) This was removed in
commit 177958e9679c23537411066cc41b205635dacb14, you can look there for
the old code.

Basically this was letting the driver know that mac80211 was going to TX
a management frame for the auth/assoc sequence, and the callback could
sleep so the driver had a chance to sync up with the GO or reserve
airtime or whatever else.

johannes

