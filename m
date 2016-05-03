Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39640 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750728AbcECN0r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 09:26:47 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Date: Tue,  3 May 2016 16:26:40 +0300
Message-Id: <1462282000-25676-1-git-send-email-luca@coelho.fi> (sfid-20160503_152651_255179_366819E0)
Subject: [PATCH] cfg80211: remove erroneous comment
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The devlist_mtx mutex was removed about two years ago, in favour of just
using RTNL/RCU protection. Remove the comment still referencing it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index ac44e77..f75d760 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -53,7 +53,7 @@ struct cfg80211_registered_device {
 	/* associated wireless interfaces, protected by rtnl or RCU */
 	struct list_head wdev_list;
 	int devlist_generation, wdev_id;
-	int opencount; /* also protected by devlist_mtx */
+	int opencount;
 	wait_queue_head_t dev_wait;
 
 	struct list_head beacon_registrations;
-- 
2.8.0.rc3

