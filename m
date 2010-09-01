Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49084 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab0IAU3k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Sep 2010 16:29:40 -0400
Date: Wed, 1 Sep 2010 16:17:24 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: cancel scan in ieee80211_restart_hw if
 software scan pending
Message-ID: <20100901201723.GC4570@tuxdriver.com>
References: <1283246981.3733.7.camel@jlt3.sipsolutions.net>
 <1283282737-27749-1-git-send-email-linville@tuxdriver.com>
 <1283336978.4131.7.camel@jlt3.sipsolutions.net>
 <20100901185856.GA4570@tuxdriver.com>
 <1283368226.4124.12.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1283368226.4124.12.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 01, 2010 at 09:10:26PM +0200, Johannes Berg wrote:
> On Wed, 2010-09-01 at 14:58 -0400, John W. Linville wrote:
> > On Wed, Sep 01, 2010 at 12:29:38PM +0200, Johannes Berg wrote:
> > > On Tue, 2010-08-31 at 15:25 -0400, John W. Linville wrote:
> > > > This function exists to clean-up after a hardware error or something
> > > > similar.  The restart is accomplished using the same infrastructure used
> > > > to resume after a suspend.  The suspend path cancels running scans, so
> > > > it seems appropriate to do that here as well for software-based scans.
> > > > If a hardware-based scan is pending, issue a warning message since this
> > > > indicates that the drivers has failed to clean-up after itself.
> > > 
> > > Makes sense.
> > > 
> > > I guess unrelated to this, I wonder if we should warn in the suspend
> > > case as well, rather than doing it unconditionally. Hmm.
> > 
> > Maybe so, but I'm not sure what path we would hook for that.
> > Doesn't wiphy_suspend run before the hardware bus suspend functions?
> > How would the driver now in advance to cancel the hardware scan?
> 
> Good point! I was just thinking that if we do a mac80211 cancel only,
> then the scan request struct pointer that we gave to the driver earlier
> suddenly becomes invalid.

I see...how about we only cancel the software scans, then warn on
resume if the hardware scan is still running?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
