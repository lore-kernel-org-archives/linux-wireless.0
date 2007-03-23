Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:42292
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbXCWRXF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 13:23:05 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH] mac80211: Properly kill tasklets before shutdown
Date: Fri, 23 Mar 2007 18:22:50 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <200703061902.00001.mb@bu3sch.de> <20070323181746.7a8f4b56@griffin.suse.cz>
In-Reply-To: <20070323181746.7a8f4b56@griffin.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703231822.50522.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 March 2007 18:17, Jiri Benc wrote:
> On Tue, 6 Mar 2007 19:01:59 +0100, Michael Buesch wrote:
> > We need to do tasklet_kill() on any tasklet on unregister
> > to make sure the tasklet is not running _and_ scheduled anymore.
> > (tasklet_disable() only ensures it's not running anymore).
> > 
> > This fixes the tasklet related crash that was reported some time ago.
> > 
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> > 
> > Index: bu3sch-wireless-dev/net/mac80211/ieee80211.c
> > ===================================================================
> > --- bu3sch-wireless-dev.orig/net/mac80211/ieee80211.c	2007-03-06 15:55:53.000000000 +0100
> > +++ bu3sch-wireless-dev/net/mac80211/ieee80211.c	2007-03-06 15:58:10.000000000 +0100
> > @@ -4761,8 +4761,8 @@
> >  	struct ieee80211_sub_if_data *sdata, *tmp;
> >  	int i;
> >  
> > -	tasklet_disable(&local->tasklet);
> 
> I think this tasklet_disable should not be removed.

Why?...

> > -	/* TODO: skb_queue should be empty here, no need to do anything? */
> > +	tasklet_kill(&local->tx_pending_tasklet);
> > +	tasklet_kill(&local->tasklet);

...We kill it here.

kill == (make sure it's not scheduled anymore) && disable

-- 
Greetings Michael.
