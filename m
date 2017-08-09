Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:4702 "EHLO
        alexa-out-lv-02.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752227AbdHIXlv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Aug 2017 19:41:51 -0400
From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] cfg80211: enable setting cqm config for AP mode
Date: Wed,  9 Aug 2017 16:41:36 -0700
Message-Id: <1502322097-29746-1-git-send-email-pradeepc@codeaurora.org> (sfid-20170810_014156_279827_01D9B6D6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable connection monitoring for AP mode which makes it possible to track
signal strength of connected stations.

Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
---
 net/wireless/nl80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index bafab07530d6..beda9c62f74a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9784,7 +9784,8 @@ static int nl80211_set_cqm_rssi(struct genl_info *info,
 	}
 
 	if (wdev->iftype != NL80211_IFTYPE_STATION &&
-	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
+	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT &&
+	    wdev->iftype != NL80211_IFTYPE_AP)
 		return -EOPNOTSUPP;
 
 	wdev_lock(wdev);
-- 
1.9.1
