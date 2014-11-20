Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49377 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbaKTUJX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2014 15:09:23 -0500
Message-ID: <1416514153.8557.9.camel@sipsolutions.net> (sfid-20141120_210926_712664_05A4FC83)
Subject: Re: wireless-testing: unknown symbol 'wiphy_new'
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 20 Nov 2014 21:09:13 +0100
In-Reply-To: <546E48DF.9020908@broadcom.com>
References: <546DEAE5.80904@broadcom.com>
	 <1416489794.8557.0.camel@sipsolutions.net> <546E48DF.9020908@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-11-20 at 21:02 +0100, Arend van Spriel wrote:
> On 11/20/14 14:23, Johannes Berg wrote:
> > On Thu, 2014-11-20 at 14:21 +0100, Arend van Spriel wrote:
> >> Build a fresh kernel today, ie. 3.18-rc5-wl from wireless-testing and
> >> got the following message while building brcmfmac:
> >>
> >>     LD [M]  drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.o
> >>     Building modules, stage 2.
> >>     MODPOST 2 modules
> >> WARNING: "wiphy_new"
> >> [drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko] undefined!
> >>
> >> Did not sound encouraging to continue, but did anyway. Not surprisingly
> >> the insmod failed. Checking Module.symvers showed:
> >>
> >> [arend@lb-bun-235 ~/scm/brcm80211-next]
> >> $ grep wiphy_new Module.symvers
> >> 0xba575a46	wiphy_new_nm	net/wireless/cfg80211	EXPORT_SYMBOL
> >>
> >> Rings a bell? We renamed the file wl_cfg80211.c that does wiphy_new()
> >> call to cfg80211.c. Merge issue?
> >
> > It's probably just a build issue?
> >
> > wiphy_new() is a static inline pointing to wiphy_new_nm()
> 
> Indeed a build issue, but wiphy_new_nm() was recently introduced, right? 
> Well, actually we were on 3.18-rc1 wireless-testing before I merged today.

Yes, it was recently introduced, but it sounds like you merged and
didn't get a full rebuild?

johannes

