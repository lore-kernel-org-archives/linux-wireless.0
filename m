Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13023 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174Ab0GAJeo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jul 2010 05:34:44 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 01 Jul 2010 02:31:35 -0700
Date: Thu, 1 Jul 2010 15:04:38 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] mac80211: Dont allow to wake up netif tx queues
	while on off channel
Message-ID: <20100701093438.GA4563@vasanth-laptop>
References: <1277892907-2401-1-git-send-email-vasanth@atheros.com> <1277893026.7823.7.camel@jlt3.sipsolutions.net> <20100630104715.GA2192@vasanth-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20100630104715.GA2192@vasanth-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 30, 2010 at 04:17:15PM +0530, Vasanth Thiagarajan wrote:
> On Wed, Jun 30, 2010 at 03:47:06PM +0530, Johannes Berg wrote:
> > On Wed, 2010-06-30 at 03:15 -0700, Vasanthakumar Thiagarajan wrote:
> > > Drivers are not supposed to call ieee80211_wake_queue() while operating
> > > on off channel during sw scanning, but there is no clear way for
> > > the driver to know that it is operating on off channel during scanning.
> > > There are cases (unavailablity/availability of tx buffers in ath9k, for
> > > example) where driver needs to stop/restart tx queues during background
> > > scanning state, this might result in waking up the corresponding netif
> > > tx queue when the device is on off channel which is not desired. This
> > > patches fixes this by checking SCAN_OFF_CHANNEL bit in scanning before
> > > restarting the tx queue.
> > > 
> > > Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> > > ---
> > >  net/mac80211/util.c |    3 ++-
> > >  1 files changed, 2 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> > > index a54cf14..1938a67 100644
> > > --- a/net/mac80211/util.c
> > > +++ b/net/mac80211/util.c
> > > @@ -277,7 +277,8 @@ static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
> > >  
> > >  	__clear_bit(reason, &local->queue_stop_reasons[queue]);
> > >  
> > > -	if (local->queue_stop_reasons[queue] != 0)
> > > +	if ((local->queue_stop_reasons[queue] != 0) ||
> > > +	    test_bit(SCAN_OFF_CHANNEL, &local->scanning))
> > >  		/* someone still has this queue stopped */
> > >  		return;
> > 
> > That doesn't seem to make sense, since we treat driver and scan stop
> > status separately via wake_queue_by_reason()
> 
> I dont know if I explained the issue properly. The issue here is
> waking up the queues by driver during scan, particularly when
> operating on off channel. With ath9k, there is a possibility that
> ieee80211_wake_queue() can be called while moving from operational
> channel (during channel set in driver). In this case driver still
> needs to be allowed to clear the bit in queue_stop_reasons[] but
> not wake up the tx queue.

The actual issue here is

 - ath9k does a ieee80211_stop_queue() upon detecting the shortage
    in tx buffer.

 - by the time it wakes up the queue, network manager issues a
   background scanning. tx buffers become available again by
   draining the driver's tx queues while configuring the hw with
   a non-operational channel. As driver can not really clear its
   queue stop request by calling ieee80211_wake_queue() during
   off channel, the stopped queue would remain stopped by driver
   for ever.

My patch makes ieee80211_wake_queue() callable any time by driver.
This would just clear the driver's stop req bit in queue_stop_reasons[]
when on non-operational channel so that the frames coming from that
queue would be passed to driver when the interface is put back on
operational channel. The commit description in that patch is
misleading. If you are ok with this fix, I will resend the patch
with proper commit message. I could not even come up with a decent
workaround in ath9k as there is no clean way for driver to know
if it is moving in/out of operational channel.

This issue is easily seen with ath9k from latest wireless-testing and
NM. With a simple iperf traffic, tx from mac80211 to driver would stop
with in 20 secs.

Vasanth
