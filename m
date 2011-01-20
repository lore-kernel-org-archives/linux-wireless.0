Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34396 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab1ATSRU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 13:17:20 -0500
Subject: Re: [RFC 2/3] mac80211: Support scanning only current active
 channel.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4D3879A6.2060909@candelatech.com>
References: <1295544750-6704-1-git-send-email-greearb@candelatech.com>
	 <1295544750-6704-2-git-send-email-greearb@candelatech.com>
	 <1295545143.3693.44.camel@jlt3.sipsolutions.net>
	 <4D3879A6.2060909@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 19:17:19 +0100
Message-ID: <1295547439.3693.46.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-01-20 at 10:06 -0800, Ben Greear wrote:

> > This doesn't seem to make much sense either -- even if we do a scan over
> > multiple channels we should be able to optimise the part on the current
> > channel (maybe put it at the beginning or end too).
> 
> Maybe..but user-space can specify the channels it wants to scan,
> and I assume that means what order to scan them in.  I have no
> idea if changing that order would confuse some application.

No, it can't actually determine the order -- we sort them in cfg80211
anyway to de-duplicate them.

> It seems to me that it would take quite a bit of re-work of the
> mac80211 scanning logic to deal with scanning on the current
> channel w/out affecting other tx/rx packets (as my patch attempts
> to do), without setting some explicit flag before you enter
> the scan state machine.

Yeah, so maybe it needs some re-work, but I think what you're doing is a
pretty strange hack.

johannes

