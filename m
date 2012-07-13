Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50817 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab2GML6y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 07:58:54 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SpeWK-0002yu-PI
	for linux-wireless@vger.kernel.org; Fri, 13 Jul 2012 13:58:53 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] cfg80211/mac80211 channel fixes
Date: Fri, 13 Jul 2012 13:58:47 +0200
Message-Id: <1342180730-19987-1-git-send-email-johannes@sipsolutions.net> (sfid-20120713_135857_735412_B113CE60)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok so the last series worked but wasn't really good. I realized
that even for normal multi-channel operation we're going to need
get_channel() since otherwise we don't know the channel *type*
that the interface is using (e.g. in managed mode) since the AP
is no real indication of it as we might decide to not use HT40
or whatever...

So instead of just reverting the get_channel removal, I'm adding
it back now with an interface argument. Nothing much changes for
mac80211, but in the future I'll adjust the cfg80211 channel
tracking code to make use of it so that it'll be required for
multi-channel (or the code will have to assume incompatibility.)

This series fixes the monitor mode problems and I've committed
them (but haven't pushed, in case somebody finds errors.)

johannes

