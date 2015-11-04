Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34289 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbbKDNJK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 08:09:10 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ayala Beker <ayala.beker@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: don't advertise NL80211_FEATURE_FULL_AP_CLIENT_STATE
Date: Wed,  4 Nov 2015 14:09:02 +0100
Message-Id: <1446642542-10436-1-git-send-email-johannes@sipsolutions.net> (sfid-20151104_140914_289694_71588875)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For now, this feature doesn't actually work. To avoid shipping a
kernel that has it enabled but where it can't be used disable it
for now - we can re-enable it when it's fixed.

This partially reverts 44674d9c2267 ("mac80211: advertise support
for full station state in AP mode").

Cc: Ayala Beker <ayala.beker@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 858f6b1cb149..175ffcf7fb06 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -541,8 +541,7 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 			   NL80211_FEATURE_HT_IBSS |
 			   NL80211_FEATURE_VIF_TXPOWER |
 			   NL80211_FEATURE_MAC_ON_CREATE |
-			   NL80211_FEATURE_USERSPACE_MPM |
-			   NL80211_FEATURE_FULL_AP_CLIENT_STATE;
+			   NL80211_FEATURE_USERSPACE_MPM;
 
 	if (!ops->hw_scan)
 		wiphy->features |= NL80211_FEATURE_LOW_PRIORITY_SCAN |
-- 
2.6.2

