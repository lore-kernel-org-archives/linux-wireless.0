Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49404 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab2ETTHw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 May 2012 15:07:52 -0400
Message-ID: <1337540836.4585.1.camel@jlt3.sipsolutions.net> (sfid-20120520_210755_672970_92507325)
Subject: Re: IWLWIFI should depend on SUSPEND
From: Johannes Berg <johannes@sipsolutions.net>
To: Sebastian Kemper <sebastian_ml@gmx.net>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 20 May 2012 21:07:16 +0200
In-Reply-To: <20120519201958.GA2313@wolfgang> (sfid-20120519_221944_090598_23FED733)
References: <20120519201958.GA2313@wolfgang>
	 (sfid-20120519_221944_090598_23FED733)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-05-19 at 22:19 +0200, Sebastian Kemper wrote:
> Hello everybody,
> 
> iwlwifi doesn't start without suspend support in the kernel. The last
> thing it says when suspend is missing is this:
> 
> iwlwifi 0000:03:00.0: Failed to register hw (error -22)
> iwlwifi 0000:03:00.0: PCI INT A disabled

I was going to say it's a mac80211 bug due to this code:

        if ((hw->wiphy->wowlan.flags || hw->wiphy->wowlan.n_patterns)
#ifdef CONFIG_PM
            && (!local->ops->suspend || !local->ops->resume)
#endif
            )
                return -EINVAL;

But then I thought about it and think it makes sense, if you don't have
suspend then you can't have WoWLAN, so the driver shouldn't advertise it
in that case, which makes it an iwlwifi bug again, we should ifdef the
wowlan support correctly.

OTOH, we could also just make the wowlan stuff not compile if CONFIG_PM
isn't set by adding an ifdef in cfg80211... That might be better so
others don't run into this trap.

Thoughts?

johannes

