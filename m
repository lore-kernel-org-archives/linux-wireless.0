Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39229 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754654AbcJYWp3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Oct 2016 18:45:29 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 8/8] mac80211: Claim Fast Initial Link Setup (FILS) support
Date: Wed, 26 Oct 2016 01:44:49 +0300
Message-ID: <1477435489-8555-4-git-send-email-jouni@qca.qualcomm.com> (sfid-20161026_004534_502575_254BBC62)
In-Reply-To: <1477435489-8555-1-git-send-email-jouni@qca.qualcomm.com>
References: <1477435489-8555-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the previous commits, initial FILS support is now functional in
mac80211-based drivers for both AP and stations roles.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/mac80211/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0d9163c..3e9ca80 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -549,6 +549,7 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 			   NL80211_FEATURE_MAC_ON_CREATE |
 			   NL80211_FEATURE_USERSPACE_MPM |
 			   NL80211_FEATURE_FULL_AP_CLIENT_STATE;
+	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_FILS);
 
 	if (!ops->hw_scan)
 		wiphy->features |= NL80211_FEATURE_LOW_PRIORITY_SCAN |
-- 
1.9.1
