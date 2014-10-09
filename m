Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:46336 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaJIQ07 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 12:26:59 -0400
Received: by mail-wg0-f48.google.com with SMTP id k14so1725165wgh.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Oct 2014 09:26:53 -0700 (PDT)
Date: Thu, 9 Oct 2014 18:26:50 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH] cfg80211: set the rates mask in connection probes over
 specified freq
Message-ID: <20141009162616.GA27065@magnum.frso.rivierawaves.com> (sfid-20141009_182702_979811_53D0979D)
References: <1412674938-13071-1-git-send-email-karl.beldan@gmail.com>
 <1412847177.1828.33.camel@jlt4.sipsolutions.net>
 <20141009130035.GB20644@magnum.frso.rivierawaves.com>
 <1412861162.1828.45.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1412861162.1828.45.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 09, 2014 at 03:26:02PM +0200, Johannes Berg wrote:
> On Thu, 2014-10-09 at 15:00 +0200, Karl Beldan wrote:
> > On Thu, Oct 09, 2014 at 11:32:57AM +0200, Johannes Berg wrote:
> > > On Tue, 2014-10-07 at 11:42 +0200, Karl Beldan wrote:
> > > > From: Karl Beldan <karl.beldan@rivierawaves.com>
> > > > 
> > > > ATM, specifying the frequency when connecting sends a void 'supported
> > > > rates' EID.
> > > 
> > > Seems like this should be a stable fix?
> > > 
> > Indeed, I forgot to Cc stable.
> 
> Ok, I guess I can just add it.
> 
> Then again, maybe you can make a bit more verbose commit log, and check
> what broke it?
> 
After a glimpse before leaving FWIU :

- 6829c878 Jul 2009 - "cfg80211: emulate connect with auth/assoc"
original code for 'cmd'
ieee80211_build_preq_ies takes supported rates from sband->bitrates[].
- 8dcb2003 Aug 2010 - "mac80211: Filter ProbeReq SuppRates based on TX
rate mask"
ieee80211_build_preq_ies takes a rate mask, hw_scan uses -1/sw_scan uses
sdata->rc_rateidx_mask.
- 34850ab2 Jul 2011 - "cfg80211: allow userspace to control supported
rates in scan" add a "bitmap of rates to advertise" in the scan request.
- 85a237fe Jul 2011 - "mac80211: implement scan supported rates"
take the rate mask from 'cmd'
- 3965ac00 Sep 2011 - "wireless: Fix rate mask for scan request"
fix rate mask when 'cmd' has params.channel


.. and rate mask remains unset when 'cmd' has params.channel
So I guess it started showing after 85a237fe, but the original cmd never
filled a rate mask which started existing only after 34850ab ..

 
Karl

