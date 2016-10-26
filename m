Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27896 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932673AbcJZVrb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 17:47:31 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 9/9] mac80211: Claim Fast Initial Link Setup (FILS) STA support
Date: Thu, 27 Oct 2016 00:42:06 +0300
Message-ID: <1477518126-823-10-git-send-email-jouni@qca.qualcomm.com> (sfid-20161026_234750_892520_6E0F716F)
In-Reply-To: <1477518126-823-1-git-send-email-jouni@qca.qualcomm.com>
References: <1477518126-823-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the previous commits, initial FILS authentication/association
support is now functional in mac80211-based drivers for station role
(and FILS AP case is covered by user space in hostapd withotu requiring
mac80211 changes).

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/mac80211/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0d9163c..1822c77 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -549,6 +549,7 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 			   NL80211_FEATURE_MAC_ON_CREATE |
 			   NL80211_FEATURE_USERSPACE_MPM |
 			   NL80211_FEATURE_FULL_AP_CLIENT_STATE;
+	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_FILS_STA);
 
 	if (!ops->hw_scan)
 		wiphy->features |= NL80211_FEATURE_LOW_PRIORITY_SCAN |
-- 
1.9.1
