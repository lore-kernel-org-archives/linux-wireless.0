Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47477 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161300Ab2GLQDW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 12:03:22 -0400
Message-ID: <1342108999.4531.34.camel@jlt3.sipsolutions.net> (sfid-20120712_180349_753923_69E96356)
Subject: Re: [PATCH] cfg80211: fix set_monitor_enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 12 Jul 2012 18:03:19 +0200
In-Reply-To: <CAB3XZEdfVAgNH4vP6B0O36riyDokpf+UHEG-+Yqn2a1Xjpt8ow@mail.gmail.com> (sfid-20120712_180024_704992_BE7FE31F)
References: <1342106133-26954-1-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEdfVAgNH4vP6B0O36riyDokpf+UHEG-+Yqn2a1Xjpt8ow@mail.gmail.com>
	 (sfid-20120712_180024_704992_BE7FE31F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-07-12 at 19:00 +0300, Eliad Peller wrote:
> On Thu, Jul 12, 2012 at 6:15 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > When bringing monitor mode up with a driver using the
> > mac80211 virtual monitor interface this resulted in a
> > warning because cfg80211_update_iface_num() is called
> > from PRE_UP, which causes it to call mac80211 and the
> > low-level driver before the device is started.
> >
> > For the case that another interface is added and the
> > monitor interface should be removed, this is correct.
> > However, in the case where a monitor interface is
> > added, it's not correct as the above.
> >
> > To fix this, we need to split up the cases and track
> > whether or not "only monitor" is active so that the
> > code can correctly call into the driver when things
> > change.

> why not always do it only on IFACE_UP?

Yeah .. thought so too at first, but it doesn't work, say you have this
situation:

 * up moni0 (monitor)
 * up wlan0 (managed)

Then the set_monitor_enabled(false) should happen before wlan0 is
brought up, otherwise mac80211/the driver will correctly reject wlan0
being brought up.


> > +               cfg80211_update_iface_num(rdev, ntype,
> > +                                         CFG80211_IFACE_DOWN);
> > +               cfg80211_update_iface_num(rdev, ntype,
> > +                                         CFG80211_IFACE_PRE_UP);
> > +               cfg80211_update_iface_num(rdev, otype,
> > +                                         CFG80211_IFACE_UP);
> 
> this sequence (down(new_type), pre_up (new_type), up(old_type))
> doesn't make any sense to me :)

Ouch. Thanks, will fix, it should obviously be down(new_type),
pre_up(new_type), up(new_type).

johannes

