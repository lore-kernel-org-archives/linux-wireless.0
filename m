Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:19991 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbaEZLoF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 07:44:05 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: don't check netdev state for debugfs read/write
Date: Mon, 26 May 2014 14:40:51 +0300
Message-Id: <1401104451-12838-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140526_134419_592316_6B265AD4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Doing so will lead to an oops for a p2p-dev interface, since it has
no netdev.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/debugfs_netdev.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 3da74ae..ff4fa15 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -34,8 +34,7 @@ static ssize_t ieee80211_if_read(
 	ssize_t ret = -EINVAL;
 
 	read_lock(&dev_base_lock);
-	if (sdata->dev->reg_state == NETREG_REGISTERED)
-		ret = (*format)(sdata, buf, sizeof(buf));
+	ret = (*format)(sdata, buf, sizeof(buf));
 	read_unlock(&dev_base_lock);
 
 	if (ret >= 0)
@@ -62,8 +61,7 @@ static ssize_t ieee80211_if_write(
 
 	ret = -ENODEV;
 	rtnl_lock();
-	if (sdata->dev->reg_state == NETREG_REGISTERED)
-		ret = (*write)(sdata, buf, count);
+	ret = (*write)(sdata, buf, count);
 	rtnl_unlock();
 
 	return ret;
-- 
1.9.1

