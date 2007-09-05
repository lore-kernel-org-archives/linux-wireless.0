Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:59339
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211AbXIEOQ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2007 10:16:56 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC 2/2] mac80211: revamp interface and filter configuration
Date: Wed, 5 Sep 2007 16:16:24 +0200
Cc: Ulrich Kunitz <kune@deine-taler.de>, Daniel Drake <dsd@gentoo.org>,
	linux-wireless@vger.kernel.org
References: <20070821161845.165557000@sipsolutions.net> <20070905051626.GA12198@deine-taler.de> <1188991396.9942.97.camel@johannes.berg>
In-Reply-To: <1188991396.9942.97.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200709051616.25044.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 05 September 2007, Johannes Berg wrote:
> On Wed, 2007-09-05 at 07:16 +0200, Ulrich Kunitz wrote:
> 
> > I see three options to achieve this:
> > 
> > 1) Use ieee80211_stop_queues() in ->configure_filter() and
> >    ieee80211_wake_queues() at the end of the workqueue function.
> > 
> > 2) Throw away all packets until the workqueue function
> >    terminates.
> > 
> > 3) Implement our own tx queue.
> > 
> > I prefer to do option (1) because it wouldn't require adding
> > additional fields to our private structure beside the work_struct
> > for the workqueue function, it is simple to implement and it would
> > not throw away any packets. Are there any side effects that I have
> > overlooked?
> 
> I think Michael says it's currently buggy if called outside of ->tx().

Yes, we had a bug in b43 where we used it in the periodic workqueue.
It causes really hard to track down system freezes on UP
systems due to races with the TX code.
It will hang and busy wait in the qdisc code when this triggers.
I didn't see a fix for this, yet.
But I think a fix could probably be to take the netif_tx_lock
in the ieee80211_stop_queues() function, so we make sure that no
TX is in progress while we stop it.
