Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49104 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbbKKWPZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2015 17:15:25 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jason Baron <jbaron@akamai.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Michal Marek <mmarek@suse.com>
Subject: [RFC v3 0/8] mac80211: jump labels for HW flags
Date: Wed, 11 Nov 2015 23:15:12 +0100
Message-Id: <1447280120-16010-1-git-send-email-johannes@sipsolutions.net> (sfid-20151111_231529_664064_3A7C3039)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes since v2:
 * introduce Kconfig count and use it instead of _ON/_OFF in
   the first few patches and described below
   (I'll squash that later if I don't abandon the whole thing)

Changes since v1:
 * use struct static_key_false
 * get rid of all those generated macros and use the optimiser

-----

This was an experiment I thought of on Sunday ...

As also explained in the log for patch 3, we have a lot of behaviour
differences in mac80211 based on which driver we're working against.
In many cases (say OpenWRT router, or a phone/tablet, ChromeBook, etc.)
we only have a single driver built into the system though. In that
case we could - theoretically - elide all the code that isn't required
by that driver, but that seems too dangerous.

Instead, use static keys to set a default for each of the flags. If
the flag is selected as _OFF in Kconfig, then any code that needs it
to be on will be placed out of line and the jump NOPed out; if then
a driver registers that actually needs the code the jump will be put
back and the first thing in the out-of-line section will be to check
the real hw flags.

This pretty much results in the same thing as removing the code/if,
but with more safety.

I haven't done any measurements whatsoever, but I think it might be
something to test on a little MIPS router box.


As far as the code is concerned, there are two really ugly things:
 1) I still use struct static_key - couldn't quite figure it out
    with static_key_false. I think I can replace it easily though.
 2) There are a lot of boilerplate ifdefs/macros.

I can't see a way to avoid more of (2), although I think that we
can probably remove it for a lot of flags and just not have this
ability for those that aren't used in RX/TX/status paths. That'd
probably reduce the code quite a bit.

If anyone has an easy setup to test it on a low-power platform that
would be great.

johannes


