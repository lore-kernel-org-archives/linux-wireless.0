Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47655 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521Ab2GLRHQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 13:07:16 -0400
Message-ID: <1342112833.4531.44.camel@jlt3.sipsolutions.net> (sfid-20120712_190722_102019_00E2236A)
Subject: Re: [PATCH] cfg80211: fix set_monitor_enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Date: Thu, 12 Jul 2012 19:07:13 +0200
In-Reply-To: <CAB3XZEfP6qUfrnxeCHoJ_XrD4H_HjkVw685C04XCrVm=1wD8Mw@mail.gmail.com> (sfid-20120712_183750_406882_C65E8DAC)
References: <1342106133-26954-1-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEdfVAgNH4vP6B0O36riyDokpf+UHEG-+Yqn2a1Xjpt8ow@mail.gmail.com>
	 <1342108999.4531.34.camel@jlt3.sipsolutions.net>
	 <CAB3XZEc0nk5xj10WadANvHaUxMYaZ9k26aCUnDbMDLGbTGEzPw@mail.gmail.com>
	 <1342110662.4531.42.camel@jlt3.sipsolutions.net>
	 <CAB3XZEfP6qUfrnxeCHoJ_XrD4H_HjkVw685C04XCrVm=1wD8Mw@mail.gmail.com>
	 (sfid-20120712_183750_406882_C65E8DAC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-07-12 at 19:37 +0300, Eliad Peller wrote:
> On Thu, Jul 12, 2012 at 7:31 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Thu, 2012-07-12 at 19:26 +0300, Eliad Peller wrote:
> >
> >> >> why not always do it only on IFACE_UP?
> >> >
> >> > Yeah .. thought so too at first, but it doesn't work, say you have this
> >> > situation:
> >> >
> >> >  * up moni0 (monitor)
> >> >  * up wlan0 (managed)
> >> >
> >> > Then the set_monitor_enabled(false) should happen before wlan0 is
> >> > brought up, otherwise mac80211/the driver will correctly reject wlan0
> >> > being brought up.
> >> >
> >> but you don't call set_monitor_enabled(false) on pre_up in your
> >> patch...
> >
> > It does, this is what happens when wlan0 is brought up:
> >
> 
> >>       if (monitors_only) {
> >
> > no, we'll go into else
> >
> i completely overlooked this if :)
> 
> >> afaict, the only effect of pre_up is updating
> >> rdev->num_running_ifaces/rdev->num_running_monitor_ifaces, which don't
> >> seem to matter much...
> >
> > No :-)
> >
> thanks for the detailed walkthrough :D

:-)

However, I just realised that it's still all broken. We must not do any
accounting in NETDEV_PRE_UP, because it might fail afterwards and we'd
never get NETDEV_UP, but also don't get NETDEV_DOWN or anything else.

It seems we can't fix it and will have to revert the monitor interface
tracking changes in cfg80211/mac80211.

johannes

