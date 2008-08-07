Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.infineon.com ([217.10.60.22]:35773 "EHLO
	smtp1.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbYHGMV3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 08:21:29 -0400
From: <Friedrich.Beckmann@infineon.com>
To: <johannes@sipsolutions.net>, <tomasw@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <j@w1.fi>
Date: Thu, 7 Aug 2008 14:21:23 +0200
Subject: RE: mac80211 aggregation (was: iwlwifi aggregation info)
Message-ID: <8469FC7DDCBE054D9653D8506E1FF0F001F1FE2164@mucse406.eu.infineon.com> (sfid-20080807_142211_122721_3C1987F6)
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217431179.10489.134.camel@johannes.berg>
	 <1ba2fa240807300908x5489e3f8g54ff83e7e5912c0b@mail.gmail.com>
	 <1217509511.10489.140.camel@johannes.berg>
	 <1ba2fa240807311114t3e1b4fb3oe6643fbe28f2c2ac@mail.gmail.com>
	 <1217528597.10489.150.camel@johannes.berg>
	 <1ba2fa240807311216u1a45cf22j219046ab357b0910@mail.gmail.com>
	 <1217592554.8621.23.camel@johannes.berg>
	 <1ba2fa240808010540g660cdaa9p1158a27061e3fcd@mail.gmail.com>
	 <1217595279.8621.38.camel@johannes.berg>
	 <1ba2fa240808061531i9b71df5l21475455d8115f3f@mail.gmail.com>
	 (sfid-20080807_003152_933183_1A6EF13B)
 <1218107628.23048.130.camel@johannes.berg>
In-Reply-To: <1218107628.23048.130.camel@johannes.berg>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> > This is really theoretical question. Wireless has defined 4
> AC stream
> > for simplicity so you map 2 TIDs out of 8 into 4 AC stream. One
> > possible view of aggregation you don't map TID into AC
> stream but run
> > it along to get more fine grained.
> > Otherwise why don't we do <AC, RA> but <TID,RA> . Just a possible
> > view. after all it's mapped back to AC.
>
> Well 802.11 isn't really clear about this, it talks about
> QSTAs having no more than one frame per <TID,RA,SA>
> outstanding at a time. I don't have access to wi-fi documents
> but I suspect they add further constraints because it's not
> feasible to have that many packets buffered on the hardware.

The aggregation is introduced in 802.11n and A-MPDU aggregation
always comes together with block acknowledgement. The reason is that
the component frames of an A-MPDU aggregate are individually subject
to retransmission but not the aggregate itself.

Block Acknowlegment allows to have a configurable number of
outstanding packets (up to 128) which you can transmit before
you require an acknowledgement. Therefore you also have to
keep the packets for which you do not have already an
acknowledgement. This is similar to TCP windows.

Each block acknowledgement and aggregation process is
identfied by the <TID, RA, SA> tuple. Having this ID has
as a consequence that you have one sequence number counter
for these packets, allowing the duplicate detection and retransmission.

Maximum number of outstanding packets = 1 is only valid
for the standard acknowledgement procedure (= one ack per packet).

The AC has first hand only to do with the access priority to the
air, but as a consequence the order of packets is only guaranteed
within each AC. So each AC needs an individual TID and as a result an
individual sequence number counter in order to do
the duplicate detection.

>
>
> I've looked into the Atheros driver, they way the implement
> it is that when frames for an aggregation session are passed
> to the ->tx() call they simply buffer them in software and
> when they have enough they enqueue all of them to the
> hardware queue for the particular AC they map into. This
> scales much better, with 16 TIDs and many stations you can
> that way possibly support a lot of concurrent aggregation sessions.
>
> Anyway, I'm confident you can work it out, I don't have time
> any more for it right now, as I'll announce in a separate
> email. I had a patch that mostly went the "just have queues
> per AC" route, but it was incomplete, if anybody wants to
> take a look it's at
> http://johannes.sipsolutions.net/patches/kernel/all/2008-08-04
> -12%3a26/006-fix-skb-cb-agg.patch
>
> Here's a recap of the current issues that I'm aware of:
>
>       * select_queue cannot really look into any state because due to
>         the lack of a single TX lock there's nothing to prevent it
>         racing against the code starting/stopping the aggregation
>       * you cannot re-queue and assume that skb->cb will be
> left intact,
>         but that's codified now by clearing skb->cb on
> master_start_xmit
>       * the current implementation of ieee80211_requeue is
> racy against
>         select_queue, select_queue is called under RCU lock though so
>         you can use synchronize_rcu to avoid the race, this requires
>         moving ieee80211_requeue into process context though
>
> johannes
>

The atheros way is for sure possible but it comes with some constraints
in building the aggregates.

a) You can not dynamically adapt the A-MPDU to the remaining TXOP.
b) You need to start a retransmission process of the aggregate packets in
   the AC queue immediatly, because otherwise you cannot release the
   buffers.

Regards

Friedrich
