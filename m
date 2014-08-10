Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:43054 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaHJINX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2014 04:13:23 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: GFP flags for cfg80211_rx_mgmt
Date: Sun, 10 Aug 2014 01:13:19 -0700
Message-ID: <2261364.hhWvLn60TS@lx-wigig-72> (sfid-20140810_101349_165494_FBB5F689)
In-Reply-To: <1405935461.32255.3.camel@jlt4.sipsolutions.net>
References: <2433125.jSlKTrms1X@lx-wigig-72> <1405935461.32255.3.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, July 21, 2014 11:37:41 AM Johannes Berg wrote:
> On Sun, 2014-07-13 at 08:02 -0700, Vladimir Kondratiev wrote:
> > Hi,
> > 
> > In the cfg80211_rx_mgmt(), there is parameter 'gfp_t gfp' that is
> > passed to the nl80211_send_mgmt() and then to alloc_skb().
> > In fact, nl80211_send_mgmt() called under spinlock, so
> > one can't use GFP_KERNEL. However, documentation for
> > cfg80211_rx_mgmt does not restrict GFP flags.
> > 
> > I suggest to document this, and enforce in some way (WARN_ONCE?),
> > or just remove this parameter - everywhere in the kernel
> > GFP_ATOMIC is used.
> 
> I say just remove it, want to send a patch?
> 
> johannes
> 
Yes, I will. Sorry for delay, was out (climbing some 7000m+ peak :-) )
