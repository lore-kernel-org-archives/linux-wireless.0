Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59670 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab0IATK3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Sep 2010 15:10:29 -0400
Subject: Re: [PATCH] mac80211: cancel scan in ieee80211_restart_hw if
 software scan pending
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20100901185856.GA4570@tuxdriver.com>
References: <1283246981.3733.7.camel@jlt3.sipsolutions.net>
	 <1283282737-27749-1-git-send-email-linville@tuxdriver.com>
	 <1283336978.4131.7.camel@jlt3.sipsolutions.net>
	 <20100901185856.GA4570@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Sep 2010 21:10:26 +0200
Message-ID: <1283368226.4124.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-01 at 14:58 -0400, John W. Linville wrote:
> On Wed, Sep 01, 2010 at 12:29:38PM +0200, Johannes Berg wrote:
> > On Tue, 2010-08-31 at 15:25 -0400, John W. Linville wrote:
> > > This function exists to clean-up after a hardware error or something
> > > similar.  The restart is accomplished using the same infrastructure used
> > > to resume after a suspend.  The suspend path cancels running scans, so
> > > it seems appropriate to do that here as well for software-based scans.
> > > If a hardware-based scan is pending, issue a warning message since this
> > > indicates that the drivers has failed to clean-up after itself.
> > 
> > Makes sense.
> > 
> > I guess unrelated to this, I wonder if we should warn in the suspend
> > case as well, rather than doing it unconditionally. Hmm.
> 
> Maybe so, but I'm not sure what path we would hook for that.
> Doesn't wiphy_suspend run before the hardware bus suspend functions?
> How would the driver now in advance to cancel the hardware scan?

Good point! I was just thinking that if we do a mac80211 cancel only,
then the scan request struct pointer that we gave to the driver earlier
suddenly becomes invalid.

johannes

