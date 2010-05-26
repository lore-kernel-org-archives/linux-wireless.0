Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47558 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab0EZMwD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 08:52:03 -0400
Subject: Re: [RFC PATCHv2] mac80211: Add support for hardware ARP query
 filtering
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1274878272.5277.1890.camel@wimaxnb.nmp.nokia.com>
References: <1274873379-12944-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1274874739.3658.5.camel@jlt3.sipsolutions.net>
	 <1274878272.5277.1890.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 14:52:01 +0200
Message-ID: <1274878321.3658.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-05-26 at 15:51 +0300, Juuso Oikarinen wrote:

> > > +	rtnl_lock();
> > > +	ieee80211_set_arp_filter(sdata);
> > > +	rtnl_unlock();
> > > +
> > 
> > Please analyse locking in more detail and enable lockdep :)
> > 
> > This will cause deadlocks.
> 
> I have lockdep permanently enabled in my development kernel. It has
> given me no complaints in testing with the corresponding wl1271 driver
> patch.
> 
> But I will look into those locks further if I can figure out any
> deadlock scenarios.

Interesting .. because for sure a lot of the ieee80211_mgd_* functions
are called with rtnl held and lock the mgd mutex, but it is the other
way around here.

johannes

