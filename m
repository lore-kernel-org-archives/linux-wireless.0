Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36659 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab3GNU5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Jul 2013 16:57:32 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/4] mac80211_hwsim: claim active monitor support
Date: Sun, 14 Jul 2013 23:57:21 +0300
Message-Id: <1373835442-3322-3-git-send-email-johannes@sipsolutions.net> (sfid-20130714_225742_273638_D463AED9)
In-Reply-To: <1373835442-3322-1-git-send-email-johannes@sipsolutions.net>
References: <1373835442-3322-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It seems to actually work this way already, so we
may need to do some work to make monitor interfaces
be _not_ active in hwsim instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 0a439f8..7b2a622 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2311,6 +2311,7 @@ static int __init init_mac80211_hwsim(void)
 		hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
 				    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
 				    WIPHY_FLAG_AP_UAPSD;
+		hw->wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;
 
 		/* ask mac80211 to reserve space for magic */
 		hw->vif_data_size = sizeof(struct hwsim_vif_priv);
-- 
1.8.0

