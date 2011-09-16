Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59343 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab1IPGTT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 02:19:19 -0400
Subject: Re: [PATCH] mac80211: don't allow zero mac bssid to be configured
From: Johannes Berg <johannes@sipsolutions.net>
To: Marek Lindner <lindner_marek@yahoo.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <201109160514.16603.lindner_marek@yahoo.de>
References: <1316102844-29970-1-git-send-email-lindner_marek@yahoo.de>
	 <1316103698.3992.12.camel@jlt3.sipsolutions.net>
	 <201109160514.16603.lindner_marek@yahoo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Sep 2011 08:19:16 +0200
Message-ID: <1316153956.4130.1.camel@jlt3.sipsolutions.net> (sfid-20110916_082024_004723_280A6D71)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-09-16 at 05:14 +0200, Marek Lindner wrote:
> On Thursday, September 15, 2011 18:21:38 Johannes Berg wrote:
> > How is this related to configuration? 
> 
> These 'sdata->u.ibss' values are initialized by ieee80211_ibss_join() which is 
> called when a user invokes "iw dev wlan0 ibss join".

Right. So that means you shouldn't be rejecting the configuration when
actually using it. You should be rejecting it when it's actually set.

> > Shouldn't the configuration check be in cfg80211 instead?
> 
> No idea. I just stumbled over this obvious bug when I scrolled down the code. 
> Feel free to propose an alternative patch if you have a better solution.

It should be in cfg80211, so NACK for this patch. Also, this patch is
wrong -- at that point, checking for zero address serves a difference
purpose I think, it means more something along the lines of "did we
previously find an IBSS".

johannes

