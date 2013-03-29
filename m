Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572Ab3C2Mcj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Mar 2013 08:32:39 -0400
Date: Fri, 29 Mar 2013 13:33:22 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC 0/3] mac80211: fixes for do_stop while suspended
Message-ID: <20130329123321.GA22165@redhat.com> (sfid-20130329_133243_386340_4800DCA9)
References: <1364423602-18821-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1364423602-18821-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 27, 2013 at 11:33:19PM +0100, Johannes Berg wrote:
> I looked at this and I think we should do a bit more restructuring.
> The virtual monitor is unsafe no matter how you look at it, even
> with your second patch, due to channel contexts. I therefore opted
> to just destroy it unconditionally on suspend, and restore it when
> resuming, which has pretty much the same effect to the driver but
> handles channel contexts differently. As we disconnect etc. in all
> other interface types (*), channel contexts should thus be fully
> destroyed on suspend. I should probably add a WARN_ON() for that
> somewhere ...
> 
> I've also restructured the do_stop() function itself so it doesn't
> get "if (local->suspended)" checks all over but has it at just a
> single point at the end of the function before doing all driver
> updates.
> 
> I think this is a good compromise as it makes it obvious that the
> driver updates happen last, and only conditionally. It remains a
> tricky proposition to make sure all other state (like chanctx) is
> actually destroyed correctly, but right now that should indeed be
> the case.
> 
> No doubt I've made some mistakes here, but as I don't own any USB
> devices any more (they all broke) I'd appreciate some testing.

Just tested (with 3/3 v2 patch) and it fixes the test case I have,
that I used to create my patches. Test case is doing suspend with
reverted commit 761ce8c41ed20ee3af77f2df527edc3f92e6f3bf. This make
device is automatically removed/added during suspend, because lack 
of .reset_resume callback.

Than I tested with physical remove device from USB slot while machine
is suspend. This gives warnings in ieee80211_reconfig() and
ieee80211_stop(). I'm not sure why, I'm going to look at that, but
I think this patch set should be applied and some more fixes provided
on top of it.

Stanislaw
