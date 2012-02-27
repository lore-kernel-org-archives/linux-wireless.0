Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50325 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab2B0Lth (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 06:49:37 -0500
Subject: mac80211 queue handling in multi-channel
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Eliad Peller <eliad@wizery.com>, Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Feb 2012 12:49:34 +0100
Message-ID: <1330343374.3483.46.camel@jlt3.sipsolutions.net> (sfid-20120227_124940_942920_32DA7DE7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'd discussed this briefly yesterday with Eliad but think I should write
it down more coherently (as if :) ) and also for wider dissemination.

We're already running into problems with remain-on-channel where they
want to flush the non-off-channel frames, but can only stop the queues
globally which then also stops off-channel frames. We haven't seen these
issues yet in our device but I think we probably will see it too.

This will be exacerbated by multi-channel, so I thought we probably need
to actually resolve this problem. Currently, the only indication the
driver has that a frame is off-channel is IEEE80211_TX_CTL_TX_OFFCHAN,
which only our driver seems to use. However, even that isn't sufficient,
if the off-channel period happens to fall into a period where the
regular queues are stopped, mac80211 will not send out the frame to
start with.

As a consequence, I'm thinking that we should redesign the mac80211 /
driver queue API to mirror more closely the kind of queues hardware
really has.

To recap: today, almost all drivers expose four queues to mac80211 for
the four ACs. In reality, many have many more queues, e.g. in iwlwifi:
 * 4 for the first vif
 * 4 for the second vif
 * 1 for CAB (content after [DTIM] beacon)
 * 1 for off-channel

They are mapped as follows:
 * all vif ACs -> 4 ACs
 * off-channel -> BE
 * CAB         -> BE (I believe, maybe all?)

Thus when e.g. in our driver the BE queue for the second VIF is full, we
stop all traffic across all VIFs. When both VIFs are on the same
channel, this isn't really a problem. However, when they are on
different channels, there could be vastly different performance
characteristics on those two channels due to interference etc. Currently
we also don't even handle the CAB or off-channel queue getting full
(which doesn't really happen, but it actually could, particularly CAB)


As a result of all of this, I think it may make sense to redesign the
queue API to better mirror what's going on. I'm thinking that the driver
should expose all of the queues and indicate to mac80211 how to sort
frames into them.

So what changes would this require?

First of all, of course the driver needs to advertise the number of
hardware queues it supports. We'll have to think about changing the
check "do we support QoS" from "hw.queues >= 4" to something else, but I
think >=4 will still be a good indication and it seems unlikely that
somebody will have a device with a lot of queues yet not support QoS.

Then of course, the driver needs to tell mac80211 about queue mapping.
For this, there's one global queue:
 * off-channel TX queue
Additionally, there are per-interface queues:
 * 4 per AC
 * CAB for this interface

The biggest change would be that we now have to modify the queue mapping
at the driver/mac80211 API boundary. Incoming frames from the network
layer would still get their queue mapping to be set to the AC (since
each virtual interface keeps the four AC software queues) but then to
the driver we have to set the queue mapping to the right hardware queue.
We might decide to use another field in the tx control data, but we have
no space in there :-)

Now when a driver stops a queue, we would stop it in mac80211, and then
instead of going through all interfaces and stopping the corresponding
queue there we'd go through all interfaces and check if it's used for
that interface and then stop the corresponding queue in the netdev.
(Ditto for wake, obviously.)


The way I see this being used is having four queues per concurrent
channel that the device supports, plus a few of the auxiliary queues.
This is necessary anyway for quick channel switching (you can't flush to
switch channels, too slow). Then each virtual interface gets its queues
mapped into the right hardware queues, and the driver actually has less
work to do in re-mapping the AC (we do that today.)

Thoughts? Is that description coherent enough? :-)

johannes

