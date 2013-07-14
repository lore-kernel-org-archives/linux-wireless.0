Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36656 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab3GNU5b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Jul 2013 16:57:31 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/4] mac80211_hwsim: claim uAPSD support
Date: Sun, 14 Jul 2013 23:57:20 +0300
Message-Id: <1373835442-3322-2-git-send-email-johannes@sipsolutions.net> (sfid-20130714_225739_887322_90E7C0DF)
In-Reply-To: <1373835442-3322-1-git-send-email-johannes@sipsolutions.net>
References: <1373835442-3322-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since mac80211 does everything, we can just claim it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 11adae8..0a439f8 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2309,7 +2309,8 @@ static int __init init_mac80211_hwsim(void)
 			hw->flags |= IEEE80211_HW_SUPPORTS_RC_TABLE;
 
 		hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
-				    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
+				    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
+				    WIPHY_FLAG_AP_UAPSD;
 
 		/* ask mac80211 to reserve space for magic */
 		hw->vif_data_size = sizeof(struct hwsim_vif_priv);
-- 
1.8.0

