Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54920 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751048AbdCQKl3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Mar 2017 06:41:29 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH] cfg80211: preserve wdev ID across netns changes
Date: Fri, 17 Mar 2017 11:41:26 +0100
Message-Id: <20170317104126.3714-1-johannes@sipsolutions.net> (sfid-20170317_114216_822565_8532D717)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a wdev changes network namespace, its wdev ID will get
reassigned since NETDEV_REGISTER is called again, in the new
network namespace. Avoid that by checking if it was already
assigned before, and document why we do that.

Reported-and-tested-by: Arend Van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index b1a028d381ef..b0d6761f0cdd 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1159,7 +1159,15 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		INIT_LIST_HEAD(&wdev->mgmt_registrations);
 		spin_lock_init(&wdev->mgmt_registrations_lock);
 
-		wdev->identifier = ++rdev->wdev_id;
+		/*
+		 * We get here also when the interface changes network namespaces,
+		 * as it's registered into the new one, but we don't want it to
+		 * change ID in that case. Checking if the ID is already assigned
+		 * works, because 0 isn't considered a valid ID and the memory is
+		 * 0-initialized.
+		 */
+		if (!wdev->identifier)
+			wdev->identifier = ++rdev->wdev_id;
 		list_add_rcu(&wdev->list, &rdev->wiphy.wdev_list);
 		rdev->devlist_generation++;
 		/* can only change netns with wiphy */
-- 
2.11.0
