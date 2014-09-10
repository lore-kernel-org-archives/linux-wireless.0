Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33056 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbaIJKnk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 06:43:40 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 4/4] cfg80211: clear rekey data on stack
Date: Wed, 10 Sep 2014 13:39:57 +0300
Message-Id: <1410345597-28565-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140910_124344_062207_339C2732)
In-Reply-To: <1410345597-28565-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1410345597-28565-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Clear the rekey data on the stack to avoid leaving it there
in case another place might leak some stack bytes.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/wireless/nl80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f4194af..51eb526 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9062,6 +9062,7 @@ static int nl80211_set_rekey_data(struct sk_buff *skb, struct genl_info *info)
 	err = rdev_set_rekey_data(rdev, dev, &rekey_data);
  out:
 	wdev_unlock(wdev);
+	memset(&rekey_data, 0, sizeof(rekey_data));
 	return err;
 }
 
-- 
1.9.1

