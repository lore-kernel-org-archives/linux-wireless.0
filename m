Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42290 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab1GFKQ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 06:16:28 -0400
Message-Id: <20110706100929.554431961@sipsolutions.net> (sfid-20110706_121632_072401_EB6BF86E)
Date: Wed, 06 Jul 2011 12:09:29 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] fix mac80211 crypto races
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211's crypto code is racing against itself, since
we can process multiple TX packets at the same time on
different ACs.

These two patches fix this. I'm not backporting them
since nobody complained, and the worst case probably
is lost packets (though in the case of TKIP maybe it
can cause countermeasures?)

johannes
