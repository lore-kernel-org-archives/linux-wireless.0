Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44030 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab0GTNFZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 09:05:25 -0400
Subject: Re: [PATCH] cfg80211: fix WEXT ioctl GIWFREQ for monitor interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: David Gnedt <david.gnedt@davizone.at>
Cc: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <4C44DFBB.6070604@davizone.at>
References: <4C449C67.6010004@davizone.at>
	 <1279571235.30478.5.camel@jlt3.sipsolutions.net>
	 <AANLkTimxBt7dPcZrmAihWq9UKs77qS0cnAxQXIY_55ci@mail.gmail.com>
	 <4C44DFBB.6070604@davizone.at>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Jul 2010 15:04:56 +0200
Message-ID: <1279631096.3706.33.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-07-20 at 01:28 +0200, David Gnedt wrote:
> Am 2010-07-19 23:06, schrieb Gábor Stefanik:
> > (BTW, I say that a GIWFREQ on a monitor interface should always return
> > the channel the PHY is tuned to at the moment when it is issued. Most
> > tools seem to expect this behavior.)
> 
> I agree, that would be the expected behaviour.
> 
> I am not very familar with the entire wireless subsystem yet, but wouldn't that
> imply a interface change in cfg80211 and mac80211 to add an "get_channel" function?

Yes, I think so.

> Because if the card is hopping channels (e.g. because of 2 station interfaces on
> different channels), only the driver itself can tell what's really the current
> channel.

Right. Although in that case I'm not sure we should be telling userspace
what channel the monitor interface is on, since there's no single
channel it is on, and I certainly hope userspace won't be requesting the
channel many times per second!

> Nevertheless a default implementation for this new "get_channel" can be written
> at mac80211 level (or even cfg80211?), which tries to find the current channel
> by looking at all virtual interfaces, so only mac80211 drivers which allow
> multiple channels (and non-mac80211 drivers) need to implement it.

Indeed, but I think mac80211 would be more appropriate than cfg80211
since the latter won't really have all the information unless it makes a
whole bunch of assumptions that we'll eventually have to reconsider.

johannes

