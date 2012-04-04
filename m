Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38719 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab2DDOm2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2012 10:42:28 -0400
Message-ID: <1333550545.18879.5.camel@jlt3.sipsolutions.net> (sfid-20120404_164231_414473_8A16D74E)
Subject: Re: [PATCH] cfg80211/mac80211: enable proper
 device_set_wakeup_enable handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 04 Apr 2012 16:42:25 +0200
In-Reply-To: <CAD2nsn0eueZ+bB8sZqAcz9NnsEc9N2yo5MxRh1F7Sc0+epDDJg@mail.gmail.com> (sfid-20120404_163910_203388_5C559E2B)
References: <1333539887.18879.1.camel@jlt3.sipsolutions.net>
	 <CAD2nsn0eueZ+bB8sZqAcz9NnsEc9N2yo5MxRh1F7Sc0+epDDJg@mail.gmail.com>
	 (sfid-20120404_163910_203388_5C559E2B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-04-04 at 20:08 +0530, Mohammed Shafi wrote:
> Hi Johannes,
> 
> On Wed, Apr 4, 2012 at 5:14 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > In WoWLAN, we only get the triggers when we actually get
> > to suspend. As a consequence, drivers currently don't
> > know that the device should enable wakeup. However, the
> > device_set_wakeup_enable() API is intended to be called
> > when the wakeup is enabled, not later when needed.
> >
> > Add a new set_wakeup() call to cfg80211 and mac80211 to
> > allow drivers to properly call device_set_wakeup_enable.
> 
> should we take care of anything else apart from
> device_set_wakeup_enable in this driver
> callback. we are working in ath9k WoW and i had seen the drivers use
> device_set_wakeup_enable
> API in the suspend/resume path. thank you.

Yeah, I also did it in the suspend/resume path but Rafael told me that
was wrong. As the PM maintainer, he should know :-)

I don't think you need to do anything else in this callback.

johannes

