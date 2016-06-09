Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57995 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbcFIHpM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 03:45:12 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: remove get/set antenna and tx power warnings
Date: Thu,  9 Jun 2016 09:45:06 +0200
Message-Id: <1465458306-5721-1-git-send-email-johannes@sipsolutions.net> (sfid-20160609_094517_213811_A4155F54)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since set_tx_power and set_antenna are frequently implemented
without the matching get_tx_power/get_antenna, we shouldn't
have added warnings for those. Remove them.

The remaining ones are correct and need to be implemented
symmetrically for correct operation.

Cc: stable@vger.kernel.org
Fixes: de3bb771f471 ("cfg80211: add more warnings for inconsistent ops")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index d25c82bc1bbe..ecca3896b9f7 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -363,8 +363,6 @@ struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
 	WARN_ON(ops->remain_on_channel && !ops->cancel_remain_on_channel);
 	WARN_ON(ops->tdls_channel_switch && !ops->tdls_cancel_channel_switch);
 	WARN_ON(ops->add_tx_ts && !ops->del_tx_ts);
-	WARN_ON(ops->set_tx_power && !ops->get_tx_power);
-	WARN_ON(ops->set_antenna && !ops->get_antenna);
 
 	alloc_size = sizeof(*rdev) + sizeof_priv;
 
-- 
2.8.0.rc3

