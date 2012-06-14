Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39844 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab2FNQxn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 12:53:43 -0400
Message-ID: <1339692819.9786.4.camel@jlt3.sipsolutions.net> (sfid-20120614_185349_413162_789FD6AA)
Subject: Re: [PATCH] mac80211: add support for userspace to handle auth
 frames on adhoc ifaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Cc: Will Hawkins <hawkinsw@opentechinstitute.org>,
	linux-wireless@vger.kernel.org
Date: Thu, 14 Jun 2012 18:53:39 +0200
In-Reply-To: <4FD9DD35.4070709@lri.fr>
References: <4FD8B5D4.8060305@opentechinstitute.org>
	  <4FD99A24.3020907@lri.fr> <1339673095.4461.2.camel@jlt3.sipsolutions.net>
	 <4FD9DD35.4070709@lri.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-14 at 14:46 +0200, Nicolas Cavallari wrote:
> On 14/06/2012 13:24, Johannes Berg wrote:
> > On Thu, 2012-06-14 at 10:00 +0200, Nicolas Cavallari wrote:
> > 
> >> I just have a question here : when auth frames are not delivered to
> >> userspace, mac80211 will respond to them, and also uses them to detect
> >> node reboot. If you register for auth frames, mac80211 will still send
> >> auth frames as soon as a new station is seen, which might be confusing
> >> for user space. Is that ok to do this ? Or should userspace have more
> >> control over how mac80211 sends auth frames ?
> > 
> > Please read the code. If userspace registers for them, mac80211 will
> > never do anything with the frame.
> 
> I didn't say the contrary. But if you read ieee80211_ibss_finish_sta(),
> you see that mac80211 sends auth frames to each discovered station, even
> if userspace want to handle auth frames. This seems strange to be able
> to receive and handle auth frames from userspace while mac80211 sends
> them behind userspace's back.

Oops, sorry, yes. I forgot all about that code!

I suppose we'd have to check whether userspace is handling
authentication?

> >> There is also another thing to consider if you want to send auth frames
> >> from userspace, as CMD_FRAME requires a frequency, which in IBSS mode,
> >> can change anytime without userspace being notified. If you only have to
> >> answer to received auth frames, this is easier as you can reuse the
> >> frequency given by nl80211 when receiving the auth frame. But if you
> >> want to send a auth frame independently, how do you get the frequency to
> >> use ?
> > 
> > You check the BSS info, that's trivial.
> 
> There is no GET_BSS from userspace. when merging IBSS, only the new
> BSSID is notified. The only way to get this info from userspace would be
> to dump the scan result and check the "we joined that ibss" flag, and
> this isn't race-free. That, or using fixed_freq.

Yeah, I guess that's true -- we should probably just allow not giving a
frequency attribute at all and then it only works if you're
connected/... but uses the right frequency.

johannes

