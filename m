Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:40849 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101Ab3EEUiG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 May 2013 16:38:06 -0400
Date: Sun, 5 May 2013 14:38:03 -0600
From: Jake Edge <jake@lwn.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	lkml <linux-kernel@vger.kernel.org>
Subject: Bisected 3.9 regression for iwl4965 connection problem to 1672c0e3
Message-ID: <20130505143803.7e46e4c6@chukar.edge2.net> (sfid-20130505_223826_138840_12AE724B)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


After building 3.9 for my HP/Compaq 2510p laptop, the wireless (iwl4965)
would seemingly no longer connect.  Actually, it seems that it *will*
eventually, where that is somewhere between 4 and 21+ retries (from KDE
network manager).  Going back to 3.8 (and earlier) and the problem goes
away.  (All on Fedora 18, fwiw, but I don't think that's significant).

I bisected the problem to:

commit 1672c0e31917f49d31d30d79067103432bc20cc7
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Tue Jan 29 15:02:27 2013 +0100

    mac80211: start auth/assoc timeout on frame status

but I can't (easily) revert that in 3.9 (maybe I can in -rc1 or
something?  haven't tried that)

What more information is needed from me?  I may still mess around with
trying to revert that patch just to nail it down for sure, but two
separate bisection exercises ended up at the same place.

There are a few traps for the unwary if anyone else ends up bisecting
in through here -- the first bisection (3.8 - 3.9-rc1) ran into an IPv6
build error along the way, which I "fixed" by configuring it out --
also, the amount of retries goes from *many* (15-21+) to relatively few
(4) somewhere in there, which confused me and led to the second
bisection (3.8-3.9) ...

jake

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
