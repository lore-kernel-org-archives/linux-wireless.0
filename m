Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60039 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759535Ab3BZPKL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 10:10:11 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, users@rt2x00.serialmonkey.com
Subject: [PATCH 3.9] rt2x00: error in configurations with mesh support disabled
Date: Tue, 26 Feb 2013 16:09:55 +0100
Message-Id: <1361891395-59990-1-git-send-email-nbd@openwrt.org> (sfid-20130226_161020_675589_76D956B0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If CONFIG_MAC80211_MESH is not set, cfg80211 will now allow advertising
interface combinations with NL80211_IFTYPE_MESH_POINT present.
Add appropriate ifdefs to avoid running into errors.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 1031db6..189744d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1236,8 +1236,10 @@ static inline void rt2x00lib_set_if_combinations(struct rt2x00_dev *rt2x00dev)
 	 */
 	if_limit = &rt2x00dev->if_limits_ap;
 	if_limit->max = rt2x00dev->ops->max_ap_intf;
-	if_limit->types = BIT(NL80211_IFTYPE_AP) |
-			BIT(NL80211_IFTYPE_MESH_POINT);
+	if_limit->types = BIT(NL80211_IFTYPE_AP);
+#ifdef CONFIG_MAC80211_MESH
+	if_limit->types |= BIT(NL80211_IFTYPE_MESH_POINT);
+#endif
 
 	/*
 	 * Build up AP interface combinations structure.
@@ -1309,7 +1311,9 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 		rt2x00dev->hw->wiphy->interface_modes |=
 		    BIT(NL80211_IFTYPE_ADHOC) |
 		    BIT(NL80211_IFTYPE_AP) |
+#ifdef CONFIG_MAC80211_MESH
 		    BIT(NL80211_IFTYPE_MESH_POINT) |
+#endif
 		    BIT(NL80211_IFTYPE_WDS);
 
 	rt2x00dev->hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
-- 
1.8.0.2

