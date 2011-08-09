Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302Ab1HIJjK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:39:10 -0400
Date: Tue, 9 Aug 2011 11:39:12 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: fix resuming when device is gone
Message-ID: <20110809093909.GB2152@redhat.com> (sfid-20110809_113914_190485_87968507)
References: <20110808141900.GA25857@redhat.com>
 <1312819106.4372.37.camel@jlt3.sipsolutions.net>
 <20110809092314.GA2152@redhat.com>
 <1312882082.4109.2.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1312882082.4109.2.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 09, 2011 at 11:28:01AM +0200, Johannes Berg wrote:
> On Tue, 2011-08-09 at 11:23 +0200, Stanislaw Gruszka wrote:
> 
> > > But ... if sta_cleanup timer operates on freed memory, why doesn't
> > > "local->registered"?
> > 
> > I think I was unclear. The sta_cleanup timer callback, namely
> > sta_info_cleanup(), can operate on freed memory. On
> > ieee80211_unregister_hw() -> sta_info_stop() we delete this timer, but
> > rdev/wiphy/local/hw structure is not freed. It's keep by reference
> > counter. 
> 
> You mean by device_del(&rdev->wiphy.dev) right?

Yes.

> > Then if ieee80211_reconfig() is called, we schedule
> > sta_cleanup timer. After that, when sysfs drop reference counter we
> > free rdev. Then sta_info_cleanup() crash kernel.
> 
> Ok let me get this straight -- even after device_del() we get a resume
> callback from the core subsystem? That doesn't seem right.

No, ieee80211_reconfig() is called before device_del() (but can be
called right after ieee80211_unregister_hw() and perhaps
ieee80211_free_hw).

Stanislaw
