Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37673 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab3KRQYA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 11:24:00 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211_hwsim: use CLOCK_MONOTONIC_RAW
Date: Mon, 18 Nov 2013 17:23:53 +0100
Message-Id: <1384791833-2377-1-git-send-email-johannes@sipsolutions.net> (sfid-20131118_172402_937177_CB08372B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The beacon timers really shouldn't use any clock that is
subject to adjustments from userspace, particularly not
CLOCK_REALTIME. Use CLOCK_MONOTONIC_RAW instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index de95b174..a11dc7c 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2580,7 +2580,7 @@ static int __init init_mac80211_hwsim(void)
 
 		tasklet_hrtimer_init(&data->beacon_timer,
 				     mac80211_hwsim_beacon,
-				     CLOCK_REALTIME, HRTIMER_MODE_ABS);
+				     CLOCK_MONOTONIC_RAW, HRTIMER_MODE_ABS);
 
 		list_add_tail(&data->list, &hwsim_radios);
 	}
-- 
1.8.4.rc3

