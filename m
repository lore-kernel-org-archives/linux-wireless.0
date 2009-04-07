Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:48415 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950AbZDGTfV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 15:35:21 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211: changing number of queues in ops->start
Date: Tue, 7 Apr 2009 21:33:21 +0200
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <200904072024.41910.mb@bu3sch.de> <1239132567.7187.1.camel@johannes.local>
In-Reply-To: <1239132567.7187.1.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200904072133.21296.mb@bu3sch.de> (sfid-20090407_213525_462007_BF1F26DC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 07 April 2009 21:29:27 Johannes Berg wrote:
> On Tue, 2009-04-07 at 20:24 +0200, Michael Buesch wrote:
> > I'm wondering how to implement QoS capability runtime detection
> > in a mac80211 driver.
> > 
> > In b43 we don't know at ieee80211_register time whether the firmware does
> > support QoS or not, because it's not loaded yet. (Reasons for not loading
> > it that early are issues with builtin-b43, etc...).
> > So we don't know whether we are going to load opensource fw (no QoS) or
> > proprietary fw (QoS capable).
> > But it seems that mac80211 requires to set hw->queues before ieee80211_register.
> > 
> > So what I'd need is a way to change the number of possible queues from within
> > the ops->start handler.
> 
> Well, I suppose you could register with the max and later reduce and
> stop the remaining queues you're not using... Or not stop them and drop
> packets on them. That's somewhat fragile, gives people who look at tc a
> wrong idea, and I can't imagine supporting it, but it should work.

mkay, I'll try this. thanks :)

I wonder, however, will mac80211 try to queue packets on queues that are stopped?
And I think just dropping them is not an option, because this will cause breakage.

What about just queueing everything on a single queue, no matter what queue mac80211
puts the frame into? Would this cause ordering issues?
Or the other way around, is there anything that _depends_ on the higher priority queues
to get sent before the higher priority queues?

-- 
Greetings, Michael.
