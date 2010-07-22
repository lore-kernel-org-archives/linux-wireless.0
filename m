Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:52617 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049Ab0GVKVV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 06:21:21 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jul 2010 03:21:21 -0700
Date: Thu, 22 Jul 2010 15:50:55 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath9k: Fix stop in tx date traffic after scan
Message-ID: <20100722102049.GB4355@vasanth-laptop>
References: <1279790703-11521-1-git-send-email-vasanth@atheros.com> <1279792601.12439.1.camel@jlt3.sipsolutions.net> <20100722101142.GA4355@vasanth-laptop> <1279793694.12439.4.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1279793694.12439.4.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 22, 2010 at 03:44:54PM +0530, Johannes Berg wrote:
> On Thu, 2010-07-22 at 15:41 +0530, Vasanthakumar Thiagarajan wrote:
> > > Just go and implement flush() and all these issues will go away and you
> > > will stop thinking that you need to touch queues from channel switching.
> > > They have nothing to do with each other.
> > 
> > 
> > I thought about it also, but i'll hit the same issue 
> > when ieee80211_scan_state_leave_oper_channel() flushes
> > the hw tx queues where driver is not supposed to wake
> > up the queues as drv_flush() is called only after stopping
> > all queues.
> 
> I don't get it. The driver can start/stop queues at _any_ time it wants
> to. Regardless of what mac80211 is doing, all that goes via
> IEEE80211_QUEUE_STOP_REASON_DRIVER which is never touched by mac80211
> itself.

My understanding is, if driver wakes up the queues when operating on
a off-channel, it would get data frames from upper layer for
transmission but it should not send out these frames as the hw is on
non-operating channel.

Vasanth
