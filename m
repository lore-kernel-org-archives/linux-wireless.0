Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46325 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab1AaS5A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:57:00 -0500
Subject: Re: [PATCH] mac80211:  Recalculate channel-type on iface removal.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4D470416.9020403@candelatech.com>
References: <1296499072-6721-1-git-send-email-greearb@candelatech.com>
	 <1296499462.3812.41.camel@jlt3.sipsolutions.net>
	 <4D470416.9020403@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 19:57:00 +0100
Message-ID: <1296500220.3812.43.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-31 at 10:48 -0800, Ben Greear wrote:
> On 01/31/2011 10:44 AM, Johannes Berg wrote:
> > On Mon, 2011-01-31 at 10:37 -0800, greearb@candelatech.com wrote:
> >
> >> Also, use WARN_ON_ONCE instead of WARN_ON if user has
> >> ht40- stations in conjunction with ht40+.  It's not
> >> really a kernel bug, just a mis-configuration of the
> >> user's wifi environment.
> >
> > But how did we end up here to start with -- shouldn't that have been
> > rejected?
> 
> The set-channel-type logic will complain, and I imagine the interfaces
> will bounce around and attempt to re-associate, but I think it can
> get into the mixed state.

I think we should try to avoid that.

> Regardless of that, it may be something more mundane where we have
> some HT-40 and HT-20 interfaces that can co-exist, but one of those
> leaves.  We should still re-calculate in case their leaving changes
> the super-chan calculation.

Yeah, no argument about that part of the patch.

johannes

