Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:41964 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751094AbdJEPjJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Oct 2017 11:39:09 -0400
Message-ID: <1507217947.2387.60.camel@sipsolutions.net> (sfid-20171005_173913_066765_B1E6CE86)
Subject: Re: converting mac80211 to TXQs entirely
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        nbd <nbd@nbd.name>
Date: Thu, 05 Oct 2017 17:39:07 +0200
In-Reply-To: <1507205618.2387.19.camel@sipsolutions.net> (sfid-20171005_141343_627525_0BA9C0DF)
References: <1507205618.2387.19.camel@sipsolutions.net>
         (sfid-20171005_141343_627525_0BA9C0DF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Part 2 - where can we go from here


Of course - as mentioned in the subject - my goal is to just convert
over to TXQs entirely in mac80211. That would get rid of a LOT of
special case code, like queueing for aggregation setup, powersave
buffering (both unicast and multicast), etc.


I think the following would be appropriate steps to take

1) convert multicast PS buffering

This is a bit strange today - when multicast PS buffering *isn't*
needed, frames go to TXQ drivers via the vif->txq, but when it *is*
done, then frames are tagged with IEEE80211_TX_CTL_SEND_AFTER_DTIM and
are buffered on ps->bc_buf (if HOST_BROADCAST_PS_BUFFERING is set) and
then handed to the driver through the legacy ->tx() path.

This should be reasonably simple to change - get rid of ps->bc_buf, and
keep the frames on the TXQ, making ieee80211_get_buffered_bc() retrieve
them from there instead. We'd have to tell the driver (it needs to know
in the wake callback) that it has sleeping clients and needs to buffer,
so it can decide whether or not to retrieve immediately (basically, for
TXQ drivers, implementing HOST_BROADCAST_PS_BUFFERING in driver logic:
retrieve immediately if it wants to buffer itself, or keep them there
for a later ieee80211_get_buffered_bc() call if it doesn't).

2) use TXQ for offchannel frames

I'm a bit unsure about this - we never really want to queue offchannel
packets, and if they don't go out immediately then we can basically
drop them. Nevertheless, having everything deal with the TXQ API will
be simpler, and so I think this also should. Perhaps for this we should
have a TXQ but only ever use txqi->frags, so that we never really have
to deal with the FQ stuff for these frames. Then the wake would
basically just pull down the packets and send them immediately.

3) handle monitor mode

I thought this was more complicated, but I think the easiest way to
solve this is to actually just use the local->monitor_sdata->vif.txq.
This requires that mac80211 be changed to always allocate local-
>monitor_sdata, even if WANT_MONITOR_VIF isn't set, and ath9k/ath10k do
something special for this TXQ (and perhaps ath9k should set
WANT_MONITOR_VIF), but that seems reasonable.

4) handle non-data frames for stations

This is probably the trickiest part. I have a patch to add a non-data
TID to the STA TXQs, and that's perhaps the right thing to do - though
I guess those frames should again always go onto txqi->frags so they
don't compete with data frames for resources.

For powersave reasons we'll discuss later, this should probably only
apply to bufferable MMPDUs, with others going to the vif->nondata_txq
(next item).

5) handle non-data frames for vifs

Similarly, we need a vif->nondata_txq where we can put probe responses
and the (few) other frames that we send before we have a station entry.



According to my earlier analysis (previous email) after these steps we
have a TXQ for all frames. All of these steps will require certain
adjustments in the drivers currently using TXQs (ath9k & ath10k) since
they'll be relying on some amount of buffering and queue stop/wake in
mac80211 for these frames. We might just have to add some API to ask
"is queue stopped" to make the transition here easy.


After this, we can start thinking about doing internal cleanups in
mac80211.


6) First thing to do is probably to introduce a compat layer, so that
all drivers go through the TXQs, regardless of whether they handle
that. I have the beginnings of a patch that does that, it basically
requires drivers to set the wake_tx_queue method to a new mac80211
function ieee80211_wake_tx_queue() [so the ops can remain const] when
they don't actually want to deal with TXQs themselves.

This method can then check the queue stop reasons etc. and only service
TXQs that don't have their corresponding queue stopped. We'd also hook
into when the queues get re-enabled, and call the servicing function
from there for such drivers.

My current prototype just calls the existing __ieee80211_tx() but I no
longer think that's a good idea - the idea is that this would
eventually allow us to get rid of tx_pending.

So it'd be better to have ieee80211_wake_tx_queue() just check all the
required things, and once a frame is pulled from a TXQ it's committed
to be given to the driver.

For off-channel, a special case will be needed - dropping the frame
when there's no way to transmit it at the time.

7) Remove all the now-dead code

A lot of code is now dead - we'll never have multiple netdev queues,
all IFF_NOQUEUE etc - remove all the code associated with that


8) convert more infrastructure to TXQs

It gets more vague (starting from 6), but eventually I want to
 * get rid of tx_pending (why do we even use both TXQ and tx_pending
   for aggregation?)
 * do all powersave buffering on TXQs
   [this may be tricky for filtered frames, perhaps disallow filtered
   for TXQ drivers like ath9k/ath10k, and have a separate per-TXQI list
   in the private txq data for ieee80211_wake_tx_queue]


Thoughts?

johannes
