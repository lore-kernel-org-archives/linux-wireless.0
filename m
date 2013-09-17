Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:32398 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab3IQMXn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Sep 2013 08:23:43 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] cfg80211: don't start p2p device while in RFKILL
Date: Tue, 17 Sep 2013 15:23:39 +0300
Message-Id: <1379420619-6123-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20130917_142353_657499_16B62AEC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/wireless/nl80211.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 316503f..6bb03b5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8666,6 +8666,9 @@ static int nl80211_start_p2p_device(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
+	if (rfkill_blocked(rdev->rfkill))
+		return -ERFKILL;
+
 	err = rdev_start_p2p_device(rdev, wdev);
 	if (err)
 		return err;
-- 
1.7.10.4

