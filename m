Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42353 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab2AQPgS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 10:36:18 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.77)
	(envelope-from <johannes@sipsolutions.net>)
	id 1RnB56-0003r6-6e
	for linux-wireless@vger.kernel.org; Tue, 17 Jan 2012 16:36:16 +0100
Subject: mac80211: mode-specific configuration calls?
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Jan 2012 16:36:16 +0100
Message-ID: <1326814576.3342.81.camel@jlt3.sipsolutions.net> (sfid-20120117_163621_695420_6F48C23F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Continuing my quest to make things better for drivers that are not on
the extreme end of the soft/hard-MAC spectrum like ath9k, like the
station state stuff, I'm now thinking about per-mode callbacks.

For example, we have per-vif idle today. It's fairly obvious what this
means, but the sequences aren't always completely obvious (or even
correct). Similarly, calls to bss_info_changed() could appear to happen
at any time, even though they really shouldn't.

I'm also continuing to think about multi-channel scenarios, and those
can be even more complex in the driver/device setup that they need.

So I'm thinking that maybe we should have per-interface & per-type
calls, modelled more like how cfg80211 works, maybe like this:

managed/p2p-client
------------------

 - prepare_connect(vif, bssid, channel, ?)
 - connected(vif, ...) [optional -- if/after assoc success]
 - disconnect(vif)

AP mode
-------

 - start_ap(vif, bssid, channel, ...)
 - stop_ap(vif)

...


Some of this would not interact well with software-based scanning &
remain-on-channel, but I'm beginning to think about pushing that
implementation closer to (some) drivers by shared code/callbacks.

Thoughts?

johannes

