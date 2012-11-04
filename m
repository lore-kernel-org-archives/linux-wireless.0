Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:39493 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab2KDULj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Nov 2012 15:11:39 -0500
Date: Sun, 4 Nov 2012 21:11:31 +0100
From: Seth Forshee <seth.forshee@canonical.com>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH 00/18] brcmsmac: Tx rework and expanded debug/trace
 support
Message-ID: <20121104201131.GA24905@ubuntu-mba51> (sfid-20121104_211153_841586_79ACE1E9)
References: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
 <20121102104935.GA12843@eleaks.org>
 <1351941357.21705.4.camel@jlt4.sipsolutions.net>
 <20121103135022.GA13562@eleaks.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121103135022.GA13562@eleaks.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 03, 2012 at 02:50:22PM +0100, Karl Beldan wrote:
> On Sat, Nov 03, 2012 at 12:15:57PM +0100, Johannes Berg wrote:
> > On Fri, 2012-11-02 at 11:49 +0100, Karl Beldan wrote:
> > 
> > > > The patches also add flow control to stop incoming tx packets when the
> > > > DMA ring is full. In practice I found that we will sometimes receive a
> > > > single frame from mac80211 after stopping the queues, so some headroom
> > > > is reserved when stopping the queues. I also reduced the number of tx
> > > > descriptors per ring to 64 and fixed a bug that prevented having
> > > > differing non-zero numbers of tx and rx descriptors for a given ring.
> > > >
> > > It is strange that you would get one frame after stopping the queues.
> > > Apart from the iface up/down code which I did not look at, it seems the tx 
> > > codepaths for queues stop/wake are all properly protected by spin_lock_bhs.
> > > You mention a possible race in your code comments .. are you referring to 
> > > mac80211 or the driver itself ?
> > 
> > It's generally a race between mac80211 and the driver, if the driver
> > uses ieee80211_stop_queue() outside the TX path, the TX path can be
> > handing it a packet at the exact same time, and therefore there can be
> > one packet (on each queue!) that goes to the driver during the call to
> > stop_queue().

This is what I suspected ...

> Yes, yet in this case, it seems to be another pb.
> The driver performs ieee80211_stop_queue() inside the TX path exept for the 
> call within the tx status callback tasklet for ampdu retries - and the latter 
> should not trigger the pb since, as the comment puts it:
> {
>                 /*
>                  * We shouldn't be out of space in the DMA
>                  * ring here since we're reinserting a frame
>                  * that was just pulled out.
>                  */
> }
> At first sight I would more likely doubt the txavail, though I haven't really
> looked into the code, the potential race caught my attention within the diff 
> and I thought it might be useful to follow up.

... but this is also true. The truth is that I need to go back and check
for this situation again, because the extra frame may not actually be
happening any more. The flow control was a little different in earlier
iterations of this patch, and I can't say for sure whether or not I
checked again after it changed.

I did check previously that the queue really was stopped when these
"extra" frames came in, and it always was. That points to some kind of
race.

Seth
