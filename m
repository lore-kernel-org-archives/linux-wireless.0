Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:49588 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640AbZDGTl5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 15:41:57 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211: changing number of queues in ops->start
Date: Tue, 7 Apr 2009 21:40:23 +0200
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <200904072024.41910.mb@bu3sch.de> <200904072133.21296.mb@bu3sch.de> <1239133078.7187.3.camel@johannes.local>
In-Reply-To: <1239133078.7187.3.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200904072140.23318.mb@bu3sch.de> (sfid-20090407_214201_463238_3FCB9439)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 07 April 2009 21:37:58 Johannes Berg wrote:
> On Tue, 2009-04-07 at 21:33 +0200, Michael Buesch wrote:
> 
> > > Well, I suppose you could register with the max and later reduce and
> > > stop the remaining queues you're not using... Or not stop them and drop
> > > packets on them. That's somewhat fragile, gives people who look at tc a
> > > wrong idea, and I can't imagine supporting it, but it should work.
> > 
> > mkay, I'll try this. thanks :)
> > 
> > I wonder, however, will mac80211 try to queue packets on queues that are stopped?
> > And I think just dropping them is not an option, because this will cause breakage.
> > 
> > What about just queueing everything on a single queue, no matter what queue mac80211
> > puts the frame into? Would this cause ordering issues?
> > Or the other way around, is there anything that _depends_ on the higher priority queues
> > to get sent before the higher priority queues?
> 
> mac80211 won't try to select a queue higher than hw->queues at
> select_queue time, so it shouldn't try to put packets onto that queue,
> look in wme.c.

Ok I see. So you say it's OK to lower hw->queues after ieee80211_register.
Should I reset hw->queues back to the value ieee80211_register was called with, before
I call unregister/free? Are there resources allocated by the number of queues?

-- 
Greetings, Michael.
