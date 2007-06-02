Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:57959
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756960AbXFBNiZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jun 2007 09:38:25 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Olivier Cornu" <o.cornu@gmail.com>
Subject: Re: [PATCH] mac80211: Update stop_queues kdoc
Date: Sat, 2 Jun 2007 15:37:58 +0200
Cc: linux-wireless@vger.kernel.org
References: <200706011129.12432.mb@bu3sch.de> <200706012342.20592.mb@bu3sch.de> <7b4bf7ff0706020617l4cf50359g8358e4aa2b359999@mail.gmail.com>
In-Reply-To: <7b4bf7ff0706020617l4cf50359g8358e4aa2b359999@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200706021537.58602.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 02 June 2007 15:17:55 Olivier Cornu wrote:
> 2007/6/1, Michael Buesch <mb@bu3sch.de>:
> > On Friday 01 June 2007 23:00:16 Olivier Cornu wrote:
> > > The only call to ieee80211_stop_queue() grep can find is in
> > > bcm43xx_dma.c:1171, i.e. bcm43xx_dma_tx(). And bcm43xx_dma_tx() is
> > > only called from bcm43xx_tx().
> > > What did i miss?
> >
> > Periodic work. I removed that in my current tree.
> > And I think we also call it when resetting the device. But I'm not sure.

We also call it for a device reset. Which is required for
a band switch (in certain cases), for example. Also for other things.

> I guess i see why we did not understand each other: these are calls to
> ieee80211_stop_queues, not directly to ieee80211_stop_queue (even
> though stop_queues ultimately calls stop_queue).
> The difference is relevant because, if some kind of locking (for
> example) was needed in the special contexts stop_queues only might be
> called from, these locks would be held inside stop_queues, around its
> stop_queue calls. :)

Ok, I see. stop_queues should take the locks etc.. so that there's
no deadlock.

> Is there any way to tell mac80211 the device is in a [temporary]
> "non-functional" state (reset, association loss...) ?

As far as I can see ieee80211_stop_queues() is exactly for that, but
it's broken. In the tx handler, where it should be safe to call, it's
useless to call stop_queues().

-- 
Greetings Michael.
