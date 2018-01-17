Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33014 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752358AbeAQHeg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 02:34:36 -0500
From: tamizhr@codeaurora.org
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, tamizhr@qti.qualcomm.com,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 2/4] cfg80211: enable setting cqm config for AP mode
Date: Wed, 17 Jan 2018 13:01:14 +0530
Message-Id: <1516174276-16789-3-git-send-email-tamizhr@codeaurora.org> (sfid-20180117_083447_220115_78782993)
In-Reply-To: <1516174276-16789-1-git-send-email-tamizhr@codeaurora.org>
References: <1516174276-16789-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>

Enable connection monitoring for AP mode which makes it possible to
track signal strength of connected stations.

Co-Developed-by: Tamizh Chelvam <tamizhr@codeaurora.org>
Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 net/wireless/nl80211.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ce5ee6f..3bb8eaa 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9884,7 +9884,10 @@ static int nl80211_set_cqm_rssi(struct genl_info *info,
 	}
 
 	if (wdev->iftype != NL80211_IFTYPE_STATION &&
-	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
+	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT &&
+	    wdev->iftype != NL80211_IFTYPE_AP &&
+	    wdev->iftype != NL80211_IFTYPE_P2P_GO &&
+	    wdev->iftype != NL80211_IFTYPE_AP_VLAN)
 		return -EOPNOTSUPP;
 
 	wdev_lock(wdev);
-- 
1.9.1
