Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:7503 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985AbYBVDoy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 22:44:54 -0500
Subject: Re: hardware/firmware powersave help, Broadcom scheme
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	bruno randolf <br1@einfach.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, Jouni Malinen <j@w1.fi>
In-Reply-To: <1203591498.17534.179.camel@johannes.berg>
References: <1203520709.17534.68.camel@johannes.berg>
	 <1203574345.3099.64.camel@debian.sh.intel.com>
	 <1203591498.17534.179.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 22 Feb 2008 11:45:48 +0800
Message-Id: <1203651948.3082.93.camel@debian.sh.intel.com> (sfid-20080222_034458_880435_DC844144)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 2008-02-21 at 11:58 +0100, Johannes Berg wrote:
> Right. This completely solves the race, there's a possible scheme
> where
> the host notifies the firmware of powersave status changes which will
> still help because this can be made faster than the TX queues, but
> still
> leaves a small window. That was hypothetical though, I guess nobody
> implements such a scheme.

Maybe to your surprise, the iwlwifi firmware implemented this. But the
major purpose is not the speed, again, it's for the out of order issue.
So the STA wake -> sleep state is controlled by the firmware. The small
window of the states mismatch between firmware and mac80211 is
dangerous, so we need to avoid it by mac80211 requeuing discarded
frames. The STA sleep -> wake state is controlled by mac80211. We send
host command to notify firmware about the change. But the small window
is safe because it is OK we delay some time for packets sending after
the STA wakes up.

> Good point. Completely draining isn't really possible when we're
> communicating with another station nor is it necessary, inserting a
> sort
> of "barrier" into the queue (any frame would be sufficient) would be
> good enough so that you know when all frames inserted before the
> powersave status change are drained.
> 
> On the other hand, even that is not necessary. Because we stop TX to a
> STA right away once we see a STA going to sleep it would be sufficient
> to insert a barrier into all queues when the STA goes to sleep and
> later
> wait for those barriers to complete, which in most cases they will
> already have.

Right. Sorry if my previous "drain queue" comment is misleading, I
actually mean "begin to send until there are no frames to the target STA
in the h/w queues". So my "drain queue" is per DA.

> [continuing below]
> 
> > It's good that you look into mac80211 powersave now. We also have
> code
> > that enables master mode PS poll and uAPSD based on an early version
> of
> > mac80211. We will merge it to the latest mac80211 and submit but it
> > takes some time. I can point you the patch if you are interested.
> 
> I'm somewhat interested, I was trying to get my N810 to perform well
> with a Broadcom/mac80211 based AP. I'd be much more interested in
> having
> an iwl4965 ucode image and driver patches to get master mode working
> there though :)
> 
> As for implementing the "barrier" scheme, the following could work:
> 
> When a STA goes to sleep, mac80211 calls a new
>         ops->insert_queue_barrier(hw, u8 *sta, u32 cookie)
> 
> callback in the driver. This callback takes note of all current queue
> status and inserts the status information into a list. mac80211 has
> created a cookie (probably just based on an increasing per-sta
> counter)
> and saves that cookie in the sta_info for that particular sta (this
> barrier cookie is to allow having two barriers for the same STA in
> flight at the same time).
> 
> As part of TX status processing, the driver now checks whether any of
> the barriers completed by comparing the TX queue status to the list of
> barriers. It then calls a new
> 
>         void ieee80211_barrier_completed(u8 *sta, u32 cookie)
> 
> mac80211 function. mac80211 looks up the sta and clears the cookie if
> it
> matches, and if so also schedules all outstanding frames for
> transmission.
> 
> Additionally, mac80211 is changed to not transmit if the sta has a
> barrier cookie assigned.
> 
> What do you think?

With the STA sleep -> wake state controlled by mac80211, I think we can
avoid the hw callbacks and handle all these in mac80211. What we do is
we add an atomic hw_pending_count in sta_info. We increase the count for
every successfull ops->tx() and decrease it in ieee80211_tx_status
(whatever success or fail). When mac80211 decides to switch STA state
from sleep to wake (and send host command to firmware), it must wait
until hw_pending_count is zero. (BTW, wait here is not accurate. We
actually handled this asynchronously).

Thanks,
-yi

