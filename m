Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6352 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760247AbcBYJY1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2016 04:24:27 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211_hwsim: Set global RRM capability
Date: Thu, 25 Feb 2016 11:24:13 +0200
Message-Id: <1456392253-16972-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160225_102432_915268_FE32B639)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Allow publishing RRM capabilities for features that are not
HW dependent.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ee37af1..ff45688 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2458,6 +2458,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 			       NL80211_FEATURE_DYNAMIC_SMPS |
 			       NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
 	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_RRM);
 
 	/* ask mac80211 to reserve space for magic */
 	hw->vif_data_size = sizeof(struct hwsim_vif_priv);
-- 
2.5.0

