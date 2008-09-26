Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbYIZOkj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 10:40:39 -0400
Subject: Re: [PATCH RFC] mac80211: notify mac80211 about rfkill events
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Ivo van Doorn <ivdoorn@gmail.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, hmh@hmh.eng.br, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1222426905.10563.100.camel@johannes.berg>
References: <1222357719-26294-1-git-send-email-tomas.winkler@intel.com>
	 <200809252310.21320.IvDoorn@gmail.com>
	 <1ba2fa240809251505p342d8a6do51cf870624e0c8dd@mail.gmail.com>
	 (sfid-20080926_000546_677648_11D1E1E6)  <1222426905.10563.100.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 26 Sep 2008 10:39:24 -0400
Message-Id: <1222439964.19895.14.camel@localhost.localdomain> (sfid-20080926_164043_242517_F245ECA2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-09-26 at 13:01 +0200, Johannes Berg wrote:
> On Fri, 2008-09-26 at 01:05 +0300, Tomas Winkler wrote:
> 
> > > I am not sure if registring a notifier would be the best solution,
> > > persionally I was thinking of implementing the rfkill structure into ieee80211_local
> > > and make it listen to events directly.
> 
> I think I like this better.
> 
> > That's definitely other option we wanted to suggest that mac80211
> > would register itself to rfkill subsystem and will provide to driver
> > appropriate callbacks.  The question is how  drivers vary in the rfkil
> > implementation and whether it wouldn't be more complex, in that case
> > the notification is quite clean solution.
> 
> How complex does it have to be?
> 
> > > That means that the only change needed in ieee80211_ioctl_siwtxpower() is
> > > only allowing the enabling of the radio when RFKILL is not set to BLOCKED.
> > 
> > That's just complicates everything and moving the policy  decisions to
> > the driver after all even
> > form txpower off you implement it as soft rfkill.
> > 
> > I would suggest just remove the support for txpower off in mac80211
> > now when appropriate or sync it with soft block after all it coming
> > from user space as a software event.
> 
> I think what we should do is in mac80211 simply synthesize the
> "radio_enabled" state that the config callback has from both rfkill and
> txpower off. Anything wrong with that?

That sounds about right.

Dan


