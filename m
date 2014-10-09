Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59490 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbaJISgg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 14:36:36 -0400
Message-ID: <1412879793.1828.61.camel@jlt4.sipsolutions.net> (sfid-20141009_203714_056828_057CA82D)
Subject: Re: [PATCH] cfg80211: set the rates mask in connection probes over
 specified freq
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Thu, 09 Oct 2014 20:36:33 +0200
In-Reply-To: <20141009162616.GA27065@magnum.frso.rivierawaves.com> (sfid-20141009_182654_483434_DAE79D4C)
References: <1412674938-13071-1-git-send-email-karl.beldan@gmail.com>
	 <1412847177.1828.33.camel@jlt4.sipsolutions.net>
	 <20141009130035.GB20644@magnum.frso.rivierawaves.com>
	 <1412861162.1828.45.camel@jlt4.sipsolutions.net>
	 <20141009162616.GA27065@magnum.frso.rivierawaves.com>
	 (sfid-20141009_182654_483434_DAE79D4C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-10-09 at 18:26 +0200, Karl Beldan wrote:

> > Then again, maybe you can make a bit more verbose commit log, and check
> > what broke it?
> > 
> After a glimpse before leaving FWIU :
> 
> - 6829c878 Jul 2009 - "cfg80211: emulate connect with auth/assoc"
> original code for 'cmd'
> ieee80211_build_preq_ies takes supported rates from sband->bitrates[].
> - 8dcb2003 Aug 2010 - "mac80211: Filter ProbeReq SuppRates based on TX
> rate mask"
> ieee80211_build_preq_ies takes a rate mask, hw_scan uses -1/sw_scan uses
> sdata->rc_rateidx_mask.
> - 34850ab2 Jul 2011 - "cfg80211: allow userspace to control supported
> rates in scan" add a "bitmap of rates to advertise" in the scan request.
> - 85a237fe Jul 2011 - "mac80211: implement scan supported rates"
> take the rate mask from 'cmd'
> - 3965ac00 Sep 2011 - "wireless: Fix rate mask for scan request"
> fix rate mask when 'cmd' has params.channel
> 
> 
> .. and rate mask remains unset when 'cmd' has params.channel
> So I guess it started showing after 85a237fe, but the original cmd never
> filled a rate mask which started existing only after 34850ab ..

Heh, so I guess this goes way back ... what does it actually affect
really though? only connections with iw, which should really not be done
that much? potentially wpa_s with wext, though I'm not even sure that
works?

Either way - is it worth for 3.18/stable?

johannes

