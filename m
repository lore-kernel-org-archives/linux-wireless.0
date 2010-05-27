Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:34634 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab0E0FfC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 01:35:02 -0400
Subject: Re: [RFC PATCHv2] mac80211: Add support for hardware ARP query
 filtering
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1274878321.3658.7.camel@jlt3.sipsolutions.net>
References: <1274873379-12944-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1274874739.3658.5.camel@jlt3.sipsolutions.net>
	 <1274878272.5277.1890.camel@wimaxnb.nmp.nokia.com>
	 <1274878321.3658.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 08:36:50 +0300
Message-ID: <1274938610.5277.2914.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-05-26 at 14:52 +0200, ext Johannes Berg wrote:
> On Wed, 2010-05-26 at 15:51 +0300, Juuso Oikarinen wrote:
> 
> > > > +	rtnl_lock();
> > > > +	ieee80211_set_arp_filter(sdata);
> > > > +	rtnl_unlock();
> > > > +
> > > 
> > > Please analyse locking in more detail and enable lockdep :)
> > > 
> > > This will cause deadlocks.
> > 
> > I have lockdep permanently enabled in my development kernel. It has
> > given me no complaints in testing with the corresponding wl1271 driver
> > patch.
> > 
> > But I will look into those locks further if I can figure out any
> > deadlock scenarios.
> 
> Interesting .. because for sure a lot of the ieee80211_mgd_* functions
> are called with rtnl held and lock the mgd mutex, but it is the other
> way around here.

You are right. There are at least some paths where mgd mutex is locked
with rtnl held, so there is a risk of deadlock. This has not occurred in
my limited testing, but is certainly possible, and obviously we should
always do locking in the same order.

I'll have to see if I can move this notification outside the mgd lock,
and if I can't, I'll have to use a workqueue function.

-Juuso

> johannes
> 


