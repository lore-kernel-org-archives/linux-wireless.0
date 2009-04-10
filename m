Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:20643 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758812AbZDJW0N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2009 18:26:13 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 10 Apr 2009 15:26:13 -0700
Date: Fri, 10 Apr 2009 15:26:09 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: Pavel Roskin <proski@gnu.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath5k-devel] BUG in wiphy_update_regulatory when loading
	ath5k (on latest git)
Message-ID: <20090410222609.GE5750@tesla> (sfid-20090411_002619_112592_9BC0A9F4)
References: <49DF6216.8040303@tuffmail.co.uk> <49DF714F.9070600@tuffmail.co.uk> <1239385533.24621.11.camel@mj> <20090410181157.GC5750@tesla> <1239394864.3673.2.camel@mj> <49DFAC64.5050208@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <49DFAC64.5050208@tuffmail.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 10, 2009 at 01:30:28PM -0700, Alan Jenkins wrote:
> Pavel Roskin wrote:
> > On Fri, 2009-04-10 at 11:11 -0700, Luis R. Rodriguez wrote:
> >
> >
> >> Thanks pavel, please try this patch:
> >>
> >
> > I checked ath5k, ath9k and b43, and in all cases last_request is
> > initialized before it's used by the code changed in your patch.  In
> > fact, last_request is initialized before there is any message from ath5k
> > or another driver.
> >
> > I wonder if "module: create a request_module_nowait()" reverted in
> > wireless-testing was causing the initialization to go in a different
> > order.  I tried reapplying it and still could not reproduce the problem
> > (that is, last_request is not NULL in wiphy_update_regulatory).  But
> > maybe I'm just lucky.
> >
> > Anyway, your patch makes the code safer and doesn't break anything for
> > me.
> >
> 
> I see.  That would explain why it's not deterministic.
> 
> I've done 5 or so test runs with the patch applied, and I haven't had
> any more BUGs.  Thanks for the quick response!

Hm, yeah so when you load cfg80211 you always trigger a core regulatory hint
and technically there is a race between the workqueue running and you
loading your driver and mac80211 and your driver having been registered
before the workqueue ran.. what might be easiest is for us to schedule
somewhere or use the kernel completion thing but I haven't used that
myself yet.

  Luis
