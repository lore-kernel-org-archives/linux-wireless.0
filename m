Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24176 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756675AbaDWHUr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2014 03:20:47 -0400
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@do-not-panic.com, Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH] cfg80211: Fix GO Concurrent relaxation on UNII-3
Date: Wed, 23 Apr 2014 09:22:58 +0300
Message-Id: <1398234178-24685-1-git-send-email-ilan.peer@intel.com> (sfid-20140423_092926_556077_B4B8B67A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At some locations, channels 149-165 are considered a single
bundle, while at some other locations, e.g., Indonesia, channels
149-161 are considered a single bundle, while channel 165 belongs
to a different bundle. This means that:

1. A station interface connection to an AP on channel 165 allows
   the instantiation of a P2P GO on channels 149-165.
2. A station interface connection to an AP on channels 149-161
   does NOT allow the instantiation of a P2P GO on channel 165.

Fix this.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---

Applied on top of mac80211-next/master.

 net/wireless/chan.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index c61bcdd..fb8f6a3 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -750,8 +750,24 @@ static bool cfg80211_go_permissive_chan(struct cfg80211_registered_device *rdev,
 		r1 = cfg80211_get_unii(chan->center_freq);
 		r2 = cfg80211_get_unii(other_chan->center_freq);
 
-		if (r1 != -EINVAL && r1 == r2)
+		if (r1 != -EINVAL && r1 == r2) {
+			/*
+			 * At some locations channels 149-165 are considered a
+			 * bundle, but at other locations, e.g., Indonesia,
+			 * channels 149-161 are considered a bundle while
+			 * channel 165 is left out and considered to be in a
+			 * different bundle. Thus, in case that there is a
+			 * station interface connected to an AP on channel 165,
+			 * it is assumed that channels 149-161 are allowed for
+			 * GO operations. However, having a station interface
+			 * connected to an AP on channels 149-161, does not
+			 * allow GO operation on channel 165.
+			 */
+			if (chan->center_freq == 5825 &&
+			    other_chan->center_freq != 5825)
+				continue;
 			return true;
+		}
 	}
 
 	return false;
-- 
1.7.10.4

