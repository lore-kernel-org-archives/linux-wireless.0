Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51300 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbaCCNTN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 08:19:13 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michal Kazior <michal.kazior@tieto.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.14] cfg80211: remove racy beacon_interval assignment
Date: Mon,  3 Mar 2014 14:19:08 +0100
Message-Id: <1393852748-31855-1-git-send-email-johannes@sipsolutions.net> (sfid-20140303_141916_513023_57616596)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In case of AP mode, the beacon interval is already reset to
zero inside cfg80211_stop_ap(), and in the other modes it
isn't relevant. Remove the assignment to remove a potential
race since the assignment isn't properly locked.

Reported-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 010892b81a06..a3bf18d11609 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -788,8 +788,6 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
 	default:
 		break;
 	}
-
-	wdev->beacon_interval = 0;
 }
 
 static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
-- 
1.8.5.3

