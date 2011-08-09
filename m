Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46411 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab1HIJ32 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:29:28 -0400
Subject: Re: [RFC] mac80211: fix resuming when device is gone
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312882082.4109.2.camel@jlt3.sipsolutions.net> (sfid-20110809_112809_793622_99974450)
References: <20110808141900.GA25857@redhat.com>
	 <1312819106.4372.37.camel@jlt3.sipsolutions.net>
	 <20110809092314.GA2152@redhat.com>
	 <1312882082.4109.2.camel@jlt3.sipsolutions.net>
	 (sfid-20110809_112809_793622_99974450)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 11:29:26 +0200
Message-ID: <1312882166.4109.3.camel@jlt3.sipsolutions.net> (sfid-20110809_112931_309434_98770D94)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 11:28 +0200, Johannes Berg wrote:

> > I think I was unclear. The sta_cleanup timer callback, namely
> > sta_info_cleanup(), can operate on freed memory. On
> > ieee80211_unregister_hw() -> sta_info_stop() we delete this timer, but
> > rdev/wiphy/local/hw structure is not freed. It's keep by reference
> > counter. 
> 
> You mean by device_del(&rdev->wiphy.dev) right?
> 
> > Then if ieee80211_reconfig() is called, we schedule
> > sta_cleanup timer. After that, when sysfs drop reference counter we
> > free rdev. Then sta_info_cleanup() crash kernel.
> 
> Ok let me get this straight -- even after device_del() we get a resume
> callback from the core subsystem? That doesn't seem right.

Or .. what else called ieee80211_reconfig()?

johannes

