Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40811 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab3C0Wd3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 18:33:29 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: sgruszka@redhat.com
Subject: [RFC 0/3] mac80211: fixes for do_stop while suspended
Date: Wed, 27 Mar 2013 23:33:19 +0100
Message-Id: <1364423602-18821-1-git-send-email-johannes@sipsolutions.net> (sfid-20130327_233332_677614_50ECD480)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw,

I looked at this and I think we should do a bit more restructuring.
The virtual monitor is unsafe no matter how you look at it, even
with your second patch, due to channel contexts. I therefore opted
to just destroy it unconditionally on suspend, and restore it when
resuming, which has pretty much the same effect to the driver but
handles channel contexts differently. As we disconnect etc. in all
other interface types (*), channel contexts should thus be fully
destroyed on suspend. I should probably add a WARN_ON() for that
somewhere ...

I've also restructured the do_stop() function itself so it doesn't
get "if (local->suspended)" checks all over but has it at just a
single point at the end of the function before doing all driver
updates.

I think this is a good compromise as it makes it obvious that the
driver updates happen last, and only conditionally. It remains a
tricky proposition to make sure all other state (like chanctx) is
actually destroyed correctly, but right now that should indeed be
the case.

No doubt I've made some mistakes here, but as I don't own any USB
devices any more (they all broke) I'd appreciate some testing.

(*) the stupid one is WDS -- for it we still have the station and
    key removal in the do_stop() code. We really should kill that
    but I don't know how we could do it better, preferably in a
    backward compatible way ...

johannes

