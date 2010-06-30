Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:11167 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755494Ab0F3K5e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jun 2010 06:57:34 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 30 Jun 2010 03:57:34 -0700
Date: Wed, 30 Jun 2010 03:57:28 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] mac80211: Dont allow to wake up netif tx queues
 while on off channel
Message-ID: <20100630105728.GC2192@vasanth-laptop>
References: <1277892907-2401-1-git-send-email-vasanth@atheros.com>
 <1277893026.7823.7.camel@jlt3.sipsolutions.net>
 <1277893571.7823.9.camel@jlt3.sipsolutions.net>
 <20100630105118.GB2192@vasanth-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20100630105118.GB2192@vasanth-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 30, 2010 at 04:21:19PM +0530, Vasanth Thiagarajan wrote:
> On Wed, Jun 30, 2010 at 03:56:11PM +0530, Johannes Berg wrote:
> > On Wed, 2010-06-30 at 12:17 +0200, Johannes Berg wrote:
> > > On Wed, 2010-06-30 at 03:15 -0700, Vasanthakumar Thiagarajan wrote:
> > > > Drivers are not supposed to call ieee80211_wake_queue() while operating
> > > > on off channel during sw scanning,
> > 
> > > That doesn't seem to make sense, since we treat driver and scan stop
> > > status separately via wake_queue_by_reason()
> > 
> > IOW, the above assertion would seem to be false already.
> 
> Sorry, I mean the existing code assumes that ieee80211_wake_queue() while
> operating on off channel during scanning.

I mean the existing code assumes that ieee80211_wake_queue() is not
supposed to be called while operating on off channel during
scanning as it is not right to pass packets to the drivers when
hw is on different channel.

Vasanth
