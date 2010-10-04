Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756240Ab0JDOuy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 10:50:54 -0400
Date: Mon, 4 Oct 2010 16:52:13 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/6] mac80211: keep lock when calling
 __ieee80211_scan_completed()
Message-ID: <20101004145212.GA16478@redhat.com>
References: <1285934732-16087-1-git-send-email-sgruszka@redhat.com>
 <1285934732-16087-3-git-send-email-sgruszka@redhat.com>
 <1286197746.3620.30.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1286197746.3620.30.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 04, 2010 at 03:09:06PM +0200, Johannes Berg wrote:
> On Fri, 2010-10-01 at 14:05 +0200, Stanislaw Gruszka wrote:
> 
> >  out_complete:
> > +	finish = false;
> > +	if (rc) {
> > +		hw_scan = test_bit(SCAN_HW_SCANNING, &local->scanning);
> > +		finish = __ieee80211_scan_completed(&local->hw, aborted, hw_scan);
> > +	}
> > +
> >  	mutex_unlock(&local->mtx);
> > -	if (rc)
> > -		__ieee80211_scan_completed(&local->hw, true);
> > +
> > +	if (finish)
> > +		__ieee80211_scan_completed_finish(&local->hw, hw_scan);
> >  }
> 
> And this makes the logic here even more confusing :-)

I'll try to rewrite that more clean.

Stanislaw
