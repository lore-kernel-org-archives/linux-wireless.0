Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47565 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933647Ab2GLQbE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 12:31:04 -0400
Message-ID: <1342110662.4531.42.camel@jlt3.sipsolutions.net> (sfid-20120712_183107_738789_F1ADFFFA)
Subject: Re: [PATCH] cfg80211: fix set_monitor_enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 12 Jul 2012 18:31:02 +0200
In-Reply-To: <CAB3XZEc0nk5xj10WadANvHaUxMYaZ9k26aCUnDbMDLGbTGEzPw@mail.gmail.com> (sfid-20120712_182615_622530_0365C4FD)
References: <1342106133-26954-1-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEdfVAgNH4vP6B0O36riyDokpf+UHEG-+Yqn2a1Xjpt8ow@mail.gmail.com>
	 <1342108999.4531.34.camel@jlt3.sipsolutions.net>
	 <CAB3XZEc0nk5xj10WadANvHaUxMYaZ9k26aCUnDbMDLGbTGEzPw@mail.gmail.com>
	 (sfid-20120712_182615_622530_0365C4FD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-07-12 at 19:26 +0300, Eliad Peller wrote:

> >> why not always do it only on IFACE_UP?
> >
> > Yeah .. thought so too at first, but it doesn't work, say you have this
> > situation:
> >
> >  * up moni0 (monitor)
> >  * up wlan0 (managed)
> >
> > Then the set_monitor_enabled(false) should happen before wlan0 is
> > brought up, otherwise mac80211/the driver will correctly reject wlan0
> > being brought up.
> >
> but you don't call set_monitor_enabled(false) on pre_up in your
> patch...

It does, this is what happens when wlan0 is brought up:

> 	rdev->num_running_ifaces += num;
>         if (iftype == NL80211_IFTYPE_MONITOR)
>                 rdev->num_running_monitor_ifaces += num;

will inc num_running_ifaces by one

>         monitors_only = cfg80211_has_monitors_only(rdev);

will be false, while it was previously true

> 	if (monitors_only && rdev->monitor_only_enabled)
>                 return;

doesn't return, since monitors_only == false

> 	if (!monitors_only && !rdev->monitor_only_enabled)
>                 return;

doesn't return since monitor_only_enabled == true


> 	if (monitors_only) {

no, we'll go into else

> 	} else {
>                 rdev->monitor_channel = NULL;
>                 rdev->monitor_channel_type = NL80211_CHAN_NO_HT;
>                 if (rdev->ops->set_monitor_enabled)
>                         rdev->ops->set_monitor_enabled(&rdev->wiphy, false);
>         }

and call set_monitor_enabled(false)

> so i guess the driver will still get its add_interface
> callback while the monitor is enabled?

add_interface is a long time ago. I'm talking about bringing it up, and
PRE_UP happens before the ndo_open() is called for the interface.

> afaict, the only effect of pre_up is updating
> rdev->num_running_ifaces/rdev->num_running_monitor_ifaces, which don't
> seem to matter much...

No :-)

johannes

