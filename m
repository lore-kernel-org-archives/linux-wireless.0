Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:36275 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbZCNQTP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 12:19:15 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: don't drop null frames during software scan
Date: Sat, 14 Mar 2009 17:18:04 +0100
Cc: Kalle Valo <kalle.valo@nokia.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <20090314144405.670.16447.stgit@tikku> <1237046839.5235.86.camel@johannes.local> <1237047169.5235.92.camel@johannes.local>
In-Reply-To: <1237047169.5235.92.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903141718.05717.mb@bu3sch.de> (sfid-20090314_171921_173989_644EFC03)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 14 March 2009 17:12:49 Johannes Berg wrote:
> On Sat, 2009-03-14 at 17:07 +0100, Johannes Berg wrote:
> > On Sat, 2009-03-14 at 17:32 +0200, Kalle Valo wrote:
> > > Johannes Berg wrote:
> > > > On Sat, 2009-03-14 at 16:44 +0200, Kalle Valo wrote:
> > > >> ieee80211_tx_h_check_assoc() was dropping everything else than probe
> > > >> requests during software scan. So the null frame with the power save
> > > >> bit was dropped and AP never received it. This meant that AP never
> > > >> buffered any frames for the station during software scan.
> > > >>
> > > >> Fix this by allowing to transmit both probe request and null frames
> > > >> during software scan. Tested with stlc45xx.
> > > > 
> > > > Would it make sense to reorder the scan code instead?
> > > 
> > > Perhaps. I chose this path only because it was simple to implement :) 
> > > I'll take a look at the scan code in more detail and fix it there.
> > 
> > You're kinda right too, we want to disable the queues first, then set
> > sw_scanning/notify the driver, and then send the nullfunc, I think. So
> > it's either this patch, or iterating the interface list twice.
> 
> Related to this, shouldn't the driver notification:
> 
>         if (local->ops->sw_scan_start)
>                 local->ops->sw_scan_start(local_to_hw(local));
> 
> be moved to _after_ we stop the subif queues, disable beacons and send
> the nullfunc? The sw_scan_complete is done before we re-enable
> everything, so it seems logical that the start should be after we
> disable it all.

For b43 it doesn't matter.

-- 
Greetings, Michael.
