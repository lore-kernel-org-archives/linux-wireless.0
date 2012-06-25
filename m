Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59910 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2FYHlf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 03:41:35 -0400
Message-ID: <1340610091.4589.5.camel@jlt3.sipsolutions.net> (sfid-20120625_094138_152288_06510EDA)
Subject: Re: [RFCv2 10/13] cfg80211: set initial monitor channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 25 Jun 2012 09:41:31 +0200
In-Reply-To: <4FE815FC.8040702@tieto.com>
References: <1340172859-18146-1-git-send-email-michal.kazior@tieto.com>
	   <1340172859-18146-11-git-send-email-michal.kazior@tieto.com>
	  <1340290665.4489.33.camel@jlt3.sipsolutions.net>
	  <4FE80BD8.4090904@tieto.com>
	 <1340609280.4589.2.camel@jlt3.sipsolutions.net>
	 <4FE815FC.8040702@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-25 at 09:40 +0200, Michal Kazior wrote:
> Johannes Berg wrote:
> > On Mon, 2012-06-25 at 08:57 +0200, Michal Kazior wrote:
> >> Johannes Berg wrote:
> >>> On Wed, 2012-06-20 at 08:14 +0200, Michal Kazior wrote:
> >>>> Implements behaviour seen in mac80211. A running
> >>>> monitor always has a channel - even before
> >>>> .set_channel. This way we won't break current
> >>>> behaviour.
> >>>
> >>> I'm a little doubtful about this. Currently, mac80211 will keep the
> >>> channel if you set it on say wlan0, your monitor iface gets the same
> >>> channel. Then if you remove wlan0, you still have the same channel, but
> >>> it seems here this is different now? I'm not sure it matters much, but
> >>> it's worth thinking about? Or am I totally misunderstanding this now?
> >>
> >> Right. It's not the exact same behaviour. It only guarantees a channel
> >> is always set in monitor mode. We could maybe set the last
> >> monitor-mode-channel seen when starting up monitor-mode again. Would
> >> that be okay?
> >
> > Yeah I think that's probably fine. Come to think of it, without that
> > change you always have a channel pointer, but it's not guaranteed to be
> > programmed into the device? Maybe I'm confused.
> 
> The rdev->monitor_channel is set to NULL when monitor mode is disabled 
> (see `cfg80211: track monitor channel`).
> 
> When monitor mode is started the hardware is programmed (and pointer 
> set) to the first channel found in supported bands (see `cfg80211: set 
> initial monitor channel`).

Ah ok, fair enough. I don't mind this, let's see if anyone complains? :)

johannes

