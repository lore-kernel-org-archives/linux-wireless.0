Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679Ab1HIJnq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:43:46 -0400
Date: Tue, 9 Aug 2011 11:43:48 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: fix resuming when device is gone
Message-ID: <20110809094347.GC2152@redhat.com> (sfid-20110809_114350_017737_64419FF3)
References: <20110808141900.GA25857@redhat.com>
 <1312819106.4372.37.camel@jlt3.sipsolutions.net>
 <20110809092314.GA2152@redhat.com>
 <1312882082.4109.2.camel@jlt3.sipsolutions.net>
 <1312882166.4109.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1312882166.4109.3.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 09, 2011 at 11:29:26AM +0200, Johannes Berg wrote:
> On Tue, 2011-08-09 at 11:28 +0200, Johannes Berg wrote:
> 
> > > I think I was unclear. The sta_cleanup timer callback, namely
> > > sta_info_cleanup(), can operate on freed memory. On
> > > ieee80211_unregister_hw() -> sta_info_stop() we delete this timer, but
> > > rdev/wiphy/local/hw structure is not freed. It's keep by reference
> > > counter. 
> > 
> > You mean by device_del(&rdev->wiphy.dev) right?
> > 
> > > Then if ieee80211_reconfig() is called, we schedule
> > > sta_cleanup timer. After that, when sysfs drop reference counter we
> > > free rdev. Then sta_info_cleanup() crash kernel.
> > 
> > Ok let me get this straight -- even after device_del() we get a resume
> > callback from the core subsystem? That doesn't seem right.
> 
> Or .. what else called ieee80211_reconfig()?

Only ieee80211_restart_work().

Note, I assumed that ieee80211_reconfig() have no sense
after ieee80211_unregister_hw()?

Stanislaw
