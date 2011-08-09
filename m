Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56912 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab1HIJpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:45:15 -0400
Subject: Re: [RFC] mac80211: fix resuming when device is gone
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20110809093909.GB2152@redhat.com>
References: <20110808141900.GA25857@redhat.com>
	 <1312819106.4372.37.camel@jlt3.sipsolutions.net>
	 <20110809092314.GA2152@redhat.com>
	 <1312882082.4109.2.camel@jlt3.sipsolutions.net>
	 <20110809093909.GB2152@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 11:45:13 +0200
Message-ID: <1312883113.4109.5.camel@jlt3.sipsolutions.net> (sfid-20110809_114526_341359_58C17168)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 11:39 +0200, Stanislaw Gruszka wrote:

> Note, I assumed that ieee80211_reconfig() have no sense
> after ieee80211_unregister_hw()?

Yeah.

> > > Then if ieee80211_reconfig() is called, we schedule
> > > sta_cleanup timer. After that, when sysfs drop reference counter we
> > > free rdev. Then sta_info_cleanup() crash kernel.
> > 
> > Ok let me get this straight -- even after device_del() we get a resume
> > callback from the core subsystem? That doesn't seem right.
> 
> No, ieee80211_reconfig() is called before device_del() (but can be
> called right after ieee80211_unregister_hw() and perhaps
> ieee80211_free_hw).

Ah so it's racy.

But I think you meant to say resume() is called before device_del()?

johannes

