Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49498 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032048AbdAEMi7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jan 2017 07:38:59 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wireless: move IEEE80211_NUM_ACS to ieee80211.h
Date: Thu,  5 Jan 2017 13:38:49 +0100
Message-Id: <20170105123849.21077-1-johannes@sipsolutions.net> (sfid-20170105_133910_270809_A3B80AB8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This constant isn't really specific to mac80211, so move it
"up" a level to ieee80211.h

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h | 2 ++
 include/net/mac80211.h    | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index fe849329511a..87d1937e4671 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -185,6 +185,8 @@ static inline u16 ieee80211_sn_sub(u16 sn1, u16 sn2)
 
 /* number of user priorities 802.11 uses */
 #define IEEE80211_NUM_UPS		8
+/* number of ACs */
+#define IEEE80211_NUM_ACS		4
 
 #define IEEE80211_QOS_CTL_LEN		2
 /* 1d tag mask */
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5345d358a510..5f5cb194cd78 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -147,7 +147,6 @@ enum ieee80211_ac_numbers {
 	IEEE80211_AC_BE		= 2,
 	IEEE80211_AC_BK		= 3,
 };
-#define IEEE80211_NUM_ACS	4
 
 /**
  * struct ieee80211_tx_queue_params - transmit queue configuration
-- 
2.9.3
