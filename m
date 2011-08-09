Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254Ab1HILgY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 07:36:24 -0400
Date: Tue, 9 Aug 2011 13:36:21 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: fix resuming when device is gone
Message-ID: <20110809113620.GA2488@redhat.com> (sfid-20110809_133627_374007_701046F1)
References: <20110808141900.GA25857@redhat.com>
 <1312819106.4372.37.camel@jlt3.sipsolutions.net>
 <20110809092314.GA2152@redhat.com>
 <1312882082.4109.2.camel@jlt3.sipsolutions.net>
 <20110809093909.GB2152@redhat.com>
 <1312883113.4109.5.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1312883113.4109.5.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 09, 2011 at 11:45:13AM +0200, Johannes Berg wrote:
> > > > Then if ieee80211_reconfig() is called, we schedule
> > > > sta_cleanup timer. After that, when sysfs drop reference counter we
> > > > free rdev. Then sta_info_cleanup() crash kernel.
> > > 
> > > Ok let me get this straight -- even after device_del() we get a resume
> > > callback from the core subsystem? That doesn't seem right.
> > 
> > No, ieee80211_reconfig() is called before device_del() (but can be
> > called right after ieee80211_unregister_hw() and perhaps
> > ieee80211_free_hw).
> 
> Ah so it's racy.
> 
> But I think you meant to say resume() is called before device_del()?

Yes, but __ieee80211_resume() calls directly ieee80211_reconfig().

Stanislaw

