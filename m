Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:44262 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754811AbZAOTDY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 14:03:24 -0500
Date: Thu, 15 Jan 2009 10:37:03 -0800
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
Cc: Joseph Cheek <joseph@cheek.com>, stable@kernel.org,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [stable] [ath9k-devel] 2.6.2{7, 8} with
	compat-wireless-2008-12-3{0, 1) drops link every 2-3 minutes
Message-ID: <20090115183703.GB10674@kroah.com> (sfid-20090115_200329_154596_E3316ABC)
References: <495C7640.8060806@cheek.com> <20090105170432.GA6834@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090105170432.GA6834@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 05, 2009 at 09:04:32AM -0800, Luis R. Rodriguez wrote:
> On Wed, Dec 31, 2008 at 11:52:32PM -0800, Joseph Cheek wrote:
> > Hi all,
> > 
> > Happy New Year!  It's about 2:30 AM here and I'm up debugging my shiny
> > new DWA-552 <AR5416+AR2133> XtremeN Desktop Adapter.  Stock 2.6.28 gave
> > me the dreaded "No ProbeResp from current AP" in syslog with a
> > disconnect every few minutes, even after updating
> > |IEEE80211_MONITORING_INTERVAL to (100 * HZ).  It's highly annoying.
> 
> This should be due to the fact that the RX filter disabled beaconing from
> the current AP and mac80211 expects beacons from the AP. This was fixed
> in wireless-testing but I do not see this pushed out for 2.6.28.
> 
> Greg, this was fixed in Linus' tree via ffb826767bffda61426d964a8fc24a216a14b0bd,
> merged by John on Fri, 21 Nov 2008, the patch is titled:
> "ath9k: enable RXing of beacons on STA/IBSS". Just in case I've
> provided the hunk below. Without this patch users will face this disconnect
> issue on noisy environments where the beacons don't reach mac80211 within
> a certain time frame dicated by mac80211.

Thanks, I'll queue this up for 2.6.28, but it doesn't apply to
2.6.27-stable.  If you want it there, can you please provide a backport
for it?

thanks,

greg k-h
