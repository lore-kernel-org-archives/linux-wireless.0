Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16988 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205Ab3IQMak (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Sep 2013 08:30:40 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH v2] cfg80211: don't start p2p device while in RFKILL
Date: Tue, 17 Sep 2013 15:30:36 +0300
Message-Id: <1379421036-6206-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20130917_143043_928522_5267EEDF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
v2: Check the rfkill before adding the interface
---
 net/wireless/nl80211.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 316503f..a344f23 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8659,6 +8659,9 @@ static int nl80211_start_p2p_device(struct sk_buff *skb, struct genl_info *info)
 	if (wdev->iftype != NL80211_IFTYPE_P2P_DEVICE)
 		return -EOPNOTSUPP;
 
+	if (rfkill_blocked(rdev->rfkill))
+		return -ERFKILL;
+
 	if (wdev->p2p_started)
 		return 0;
 
-- 
1.7.10.4

