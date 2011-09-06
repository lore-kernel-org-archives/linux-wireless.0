Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49445 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab1IFKro (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 06:47:44 -0400
Subject: [PATCH] mac80211: fix missing sta_lock in __sta_info_destroy
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Sep 2011 12:47:39 +0200
Message-ID: <1315306059.3900.1.camel@jlt3.sipsolutions.net> (sfid-20110906_124755_485827_9445D636)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since my commit 34e895075e21be3e21e71d6317440d1ee7969ad0
("mac80211: allow station add/remove to sleep") there is
a race in mac80211 when it clears the TIM bit because a
sleeping station disconnected, the spinlock isn't held
around the relevant code any more. Use the right API to
acquire the spinlock correctly.

Cc: stable@kernel.org [2.6.34+]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/sta_info.c	2011-09-06 12:46:20.000000000 +0200
+++ b/net/mac80211/sta_info.c	2011-09-06 12:46:21.000000000 +0200
@@ -796,7 +796,7 @@ static int __must_check __sta_info_destr
 		BUG_ON(!sdata->bss);
 
 		atomic_dec(&sdata->bss->num_sta_ps);
-		__sta_info_clear_tim_bit(sdata->bss, sta);
+		sta_info_clear_tim_bit(sta);
 	}
 
 	local->num_sta--;


