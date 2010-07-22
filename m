Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56915 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab0GVKcK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 06:32:10 -0400
Subject: Re: [PATCH 2/2] ath9k: Fix stop in tx date traffic after scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100722102049.GB4355@vasanth-laptop>
References: <1279790703-11521-1-git-send-email-vasanth@atheros.com>
	 <1279792601.12439.1.camel@jlt3.sipsolutions.net>
	 <20100722101142.GA4355@vasanth-laptop>
	 <1279793694.12439.4.camel@jlt3.sipsolutions.net>
	 <20100722102049.GB4355@vasanth-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 12:32:04 +0200
Message-ID: <1279794724.12439.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-07-22 at 15:50 +0530, Vasanthakumar Thiagarajan wrote:
> On Thu, Jul 22, 2010 at 03:44:54PM +0530, Johannes Berg wrote:
> > On Thu, 2010-07-22 at 15:41 +0530, Vasanthakumar Thiagarajan wrote:
> > > > Just go and implement flush() and all these issues will go away and you
> > > > will stop thinking that you need to touch queues from channel switching.
> > > > They have nothing to do with each other.
> > > 
> > > 
> > > I thought about it also, but i'll hit the same issue 
> > > when ieee80211_scan_state_leave_oper_channel() flushes
> > > the hw tx queues where driver is not supposed to wake
> > > up the queues as drv_flush() is called only after stopping
> > > all queues.
> > 
> > I don't get it. The driver can start/stop queues at _any_ time it wants
> > to. Regardless of what mac80211 is doing, all that goes via
> > IEEE80211_QUEUE_STOP_REASON_DRIVER which is never touched by mac80211
> > itself.
> 
> My understanding is, if driver wakes up the queues when operating on
> a off-channel, it would get data frames from upper layer for
> transmission but it should not send out these frames as the hw is on
> non-operating channel.

Ok, that seems to be true, but only because we don't properly manage the
interface queue stop in mac80211. Should be an easy fix there.

johannes

