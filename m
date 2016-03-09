Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:44848 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbcCIIId (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 03:08:33 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: Set global RRM capability
Date: Wed,  9 Mar 2016 10:08:27 +0200
Message-Id: <1457510907-8863-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160309_090836_298402_495ED127)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow publishing RRM capabilities for features that are not
HW dependent.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 8190bf2..8155961 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -558,6 +558,8 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 	if (!ops->set_key)
 		wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 
+	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_RRM);
+
 	wiphy->bss_priv_size = sizeof(struct ieee80211_bss);
 
 	local = wiphy_priv(wiphy);
-- 
2.5.0

