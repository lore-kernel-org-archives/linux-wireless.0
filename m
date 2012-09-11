Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40285 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab2IKNZq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 09:25:46 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TBQTJ-0007Jk-8p
	for linux-wireless@vger.kernel.org; Tue, 11 Sep 2012 15:25:45 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: mac80211: multi-channel work
Date: Tue, 11 Sep 2012 15:26:11 +0200
Message-Id: <1347369983-12459-1-git-send-email-johannes@sipsolutions.net> (sfid-20120911_152550_674774_4B771C3D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's been a long time since I posted this last, and I've merged
a lot of preparation work already.

Obviously patch 10 needs to be rolled into 9 if I merge the patch
it fixes, but I wanted to keep that separate for now.

Over the last repost we have a bunch of bugfixes and the last
patch in this series, the one to let the driver know how many
RX chains it needs to enable always and dynamically on which
channel context.

The TX power setting is still missing, we've discussed that it
should probably be a per-interface setting to match what users
can configure. I'll work on that, but I think we can merge this
work before that is done.

I would like to get reviews on this and then merge it. I know
I still need to address at least the TX power issue, and while
it is important I don't think it's important enough to prevent
everybody from starting to work with this new API. I also still
want to see if I can address the RCU usage that's ugly in some
parts, but that's purely a mac80211 internal so I can always do
some work on that later as well.

Please review :-)

johannes
