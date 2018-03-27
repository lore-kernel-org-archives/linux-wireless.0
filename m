Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36056 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751114AbeC0GuP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 02:50:15 -0400
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [RFC 1/3] cfg80211: fix data type of sta_opmode_info parameter
Date: Tue, 27 Mar 2018 12:18:14 +0530
Message-Id: <1522133296-2583-2-git-send-email-tamizhr@codeaurora.org> (sfid-20180327_085019_467993_3E89D540)
In-Reply-To: <1522133296-2583-1-git-send-email-tamizhr@codeaurora.org>
References: <1522133296-2583-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently bw and smps_mode are u8 type value in sta_opmode_info
structure. This values filled in mac80211 from ieee80211_sta_rx_bandwidth
and ieee80211_smps_mode. These enum values are specific to mac80211 and
userspace/cfg80211 doesn't know about that. This will lead to incorrect
result/assumption by the user space application.
Change bw and smps_mode parameters to their respective enums in nl80211.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/cfg80211.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index fc40843..4341508 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3572,15 +3572,15 @@ enum wiphy_opmode_flag {
 /**
  * struct sta_opmode_info - Station's ht/vht operation mode information
  * @changed: contains value from &enum wiphy_opmode_flag
- * @smps_mode: New SMPS mode of a station
- * @bw: new max bandwidth value of a station
+ * @smps_mode: New SMPS mode value from &enum nl80211_smps_mode of a station
+ * @bw: new max bandwidth value from &enum nl80211_chan_width of a station
  * @rx_nss: new rx_nss value of a station
  */
 
 struct sta_opmode_info {
 	u32 changed;
-	u8 smps_mode;
-	u8 bw;
+	enum nl80211_smps_mode smps_mode;
+	enum nl80211_chan_width bw;
 	u8 rx_nss;
 };
 
-- 
1.9.1
