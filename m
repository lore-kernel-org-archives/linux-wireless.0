Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44956 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3LQK3v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 05:29:51 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.13] ath9k: disable radar detection support
Date: Tue, 17 Dec 2013 11:29:47 +0100
Message-Id: <1387276187-16063-1-git-send-email-johannes@sipsolutions.net> (sfid-20131217_112955_247958_C80745E3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since the cfg80211 and mac80211 radar detection support is
rather broken right now, disable it in the only driver that
advertises support for it. When all the bugs are resolved,
support for it can be restored.

Cc: stable@vger.kernel.org [3.10+]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 710192e..b9a1ce3 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -920,7 +920,10 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 			BIT(NL80211_IFTYPE_ADHOC) |
 			BIT(NL80211_IFTYPE_MESH_POINT);
 		hw->wiphy->iface_combinations = if_comb;
-		hw->wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
+		/* radar detection code is rather broken right now,
+		 * so for now disable it entirely
+		 */
+		hw->wiphy->n_iface_combinations = 1;
 	}
 
 	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
-- 
1.8.5.1

