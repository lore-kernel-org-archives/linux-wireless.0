Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696AbXLDUYx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 15:24:53 -0500
Subject: Re: [RFC PATCH] [try 2] orinoco: more reliable scan handling
From: Dan Williams <dcbw@redhat.com>
To: Dave <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4755A382.5000806@gmail.com>
References: <1191946643.20183.2.camel@localhost.localdomain>
	 <20071010183251.GK5962@tuxdriver.com>
	 <1192074985.31110.4.camel@localhost.localdomain>
	 <47489C2D.7030606@gmail.com>
	 <1196790911.14982.4.camel@localhost.localdomain>
	 <4755A382.5000806@gmail.com>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 15:19:43 -0500
Message-Id: <1196799583.4701.6.camel@localhost.localdomain> (sfid-20071204_202458_535655_F0189720)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-12-04 at 18:59 +0000, Dave wrote:
> Dan Williams wrote:
> > On Sat, 2007-11-24 at 21:48 +0000, Dave wrote:
> >> Dan Williams wrote:
> >>> Bring scan result handling more in line with drivers like ipw.  Scan
> >>> results are aggregated and a BSS dropped after 15 seconds if no beacon
> >>> is received.  This allows the driver to interact better with userspace
> >>> where more than one process may request scans or results at any time.
> >> I've only seen this recently, and am using it as a basis for some other changes. However I've noticed a couple issues:
> >>
> >>> +static int orinoco_process_scan_results(struct net_device *dev,
> >>> +					unsigned char *buf,
> >>> +					int len)
> >>> +{
> >>  <snip>
> >>> +		/* Try to update an existing bss first */
> >>> +		list_for_each_entry(bss, &priv->bss_list, list) {
> >>> +			if (compare_ether_addr(bss->bss.a.bssid, atom->a.bssid))
> >>                         if (!compare_ether_addr(bss->bss.a.bssid, atom->a.bssid))
> >>
> >> So that we proceed to the next bss when ether_addr doesn't match. Otherwise this loop never matches.
> > 
> > compare_ether_addr(), like memcmp, returns 0 when the two arguments
> > match.  So I think this is OK.
> 
> Agreed. My mistake.
> 
> >  What the loop should be doing is trying
> > to find a BSSID + ESSID match and just update the last_seen value, which
> > from my reread is what it's doing here...
> 
> Agreed.
> 
> If something in userspace triggers a scan every 10 seconds, the scan results will always be the same (the oldest).
> 
> If that is the desired behaviour (or we don't care about this misuse) this is fine. Personally I'd expect the results to be updated, but I've only recently started messing with wireless drivers.

Is the information returned from the firmware for a previous scan result
of a BSS expected to differ significantly from the information returned
from a newer scan?  I guess this might cause problems when you change
the encryption parameters, update the IE on the AP, or change supported
rateset or something.  So I guess it does make sense to update the
record.  Will send a new patch doing so.

Thanks,
Dan


