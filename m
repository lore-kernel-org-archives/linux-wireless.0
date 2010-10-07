Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695Ab0JGJhC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 05:37:02 -0400
Date: Thu, 7 Oct 2010 11:38:33 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Latest wireless-testing has broken scan locking.
Message-ID: <20101007093832.GD2435@redhat.com>
References: <4CAD48DA.9010208@candelatech.com>
 <1286440488.3657.23.camel@jlt3.sipsolutions.net>
 <20101007091839.GC2435@redhat.com>
 <1286443486.3657.32.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1286443486.3657.32.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 07, 2010 at 11:24:46AM +0200, Johannes Berg wrote:
> On Thu, 2010-10-07 at 11:18 +0200, Stanislaw Gruszka wrote:
> 
> > > --- wireless-testing.orig/net/mac80211/scan.c	2010-10-07 10:27:37.000000000 +0200
> > > +++ wireless-testing/net/mac80211/scan.c	2010-10-07 10:31:19.000000000 +0200
> > > @@ -693,8 +693,6 @@ void ieee80211_scan_work(struct work_str
> > >  		goto out_complete;
> > >  	}
> > >  
> > > -	mutex_unlock(&local->mtx);
> > > -
> > >  	/*
> > >  	 * as long as no delay is required advance immediately
> > >  	 * without scheduling a new work
> > > @@ -725,6 +723,7 @@ void ieee80211_scan_work(struct work_str
> > >  	} while (next_delay == 0);
> > >  
> > >  	ieee80211_queue_delayed_work(&local->hw, &local->scan_work, next_delay);
> > > +	mutex_unlock(&local->mtx);
> > >  	return;
> > >  
> > >  out_complete:
> > 
> > We never keep locking inside do { } while (next_delay == 0) loop,
> > perhaps below patch is something better:
> 
> Yeah, we didn't have that before, but weren't you yourself arguing that
> dropping and re-acquiring could lead to issues? :)

Yep.

> FWIW, I've looked at the code and all we do is possibly acquire the
> iflist_mtx (which is fine under local->mtx) and do some driver calls,
> which should also be fine.
> 
> So what do you think?

Let's fix with your patch. I'm going to test it (on hw scan :/ at least).

Stanislaw
