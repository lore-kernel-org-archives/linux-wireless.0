Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:11103 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367Ab0F3KrV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jun 2010 06:47:21 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 30 Jun 2010 03:47:21 -0700
Date: Wed, 30 Jun 2010 03:47:15 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] mac80211: Dont allow to wake up netif tx queues
 while on off channel
Message-ID: <20100630104715.GA2192@vasanth-laptop>
References: <1277892907-2401-1-git-send-email-vasanth@atheros.com>
 <1277893026.7823.7.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1277893026.7823.7.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 30, 2010 at 03:47:06PM +0530, Johannes Berg wrote:
> On Wed, 2010-06-30 at 03:15 -0700, Vasanthakumar Thiagarajan wrote:
> > Drivers are not supposed to call ieee80211_wake_queue() while operating
> > on off channel during sw scanning, but there is no clear way for
> > the driver to know that it is operating on off channel during scanning.
> > There are cases (unavailablity/availability of tx buffers in ath9k, for
> > example) where driver needs to stop/restart tx queues during background
> > scanning state, this might result in waking up the corresponding netif
> > tx queue when the device is on off channel which is not desired. This
> > patches fixes this by checking SCAN_OFF_CHANNEL bit in scanning before
> > restarting the tx queue.
> > 
> > Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> > ---
> >  net/mac80211/util.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> > index a54cf14..1938a67 100644
> > --- a/net/mac80211/util.c
> > +++ b/net/mac80211/util.c
> > @@ -277,7 +277,8 @@ static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
> >  
> >  	__clear_bit(reason, &local->queue_stop_reasons[queue]);
> >  
> > -	if (local->queue_stop_reasons[queue] != 0)
> > +	if ((local->queue_stop_reasons[queue] != 0) ||
> > +	    test_bit(SCAN_OFF_CHANNEL, &local->scanning))
> >  		/* someone still has this queue stopped */
> >  		return;
> 
> That doesn't seem to make sense, since we treat driver and scan stop
> status separately via wake_queue_by_reason()

I dont know if I explained the issue properly. The issue here is
waking up the queues by driver during scan, particularly when
operating on off channel. With ath9k, there is a possibility that
ieee80211_wake_queue() can be called while moving from operational
channel (during channel set in driver). In this case driver still
needs to be allowed to clear the bit in queue_stop_reasons[] but
not wake up the tx queue.

Vasanth
