Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:36256 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761485Ab3EAPRg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 11:17:36 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 6/7] rt2x00: rt2x00dev: defer operational mode detection
Date: Wed,  1 May 2013 17:17:34 +0200
Message-Id: <1367421455-18463-7-git-send-email-juhosg@openwrt.org> (sfid-20130501_171754_899552_431ABCF9)
In-Reply-To: <1367421455-18463-1-git-send-email-juhosg@openwrt.org>
References: <1367421455-18463-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only do it after the queues are allocated. This
will allow to use the 'rt2x00dev->bcn->limit'
instead of 'rt2x00dev->ops->bcn->entry_num'.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |   34 +++++++++++++++----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index b287467..6a20172 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1301,23 +1301,6 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 		(rt2x00dev->ops->max_ap_intf - 1);
 
 	/*
-	 * Determine which operating modes are supported, all modes
-	 * which require beaconing, depend on the availability of
-	 * beacon entries.
-	 */
-	rt2x00dev->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
-	if (rt2x00dev->ops->bcn->entry_num > 0)
-		rt2x00dev->hw->wiphy->interface_modes |=
-		    BIT(NL80211_IFTYPE_ADHOC) |
-		    BIT(NL80211_IFTYPE_AP) |
-#ifdef CONFIG_MAC80211_MESH
-		    BIT(NL80211_IFTYPE_MESH_POINT) |
-#endif
-		    BIT(NL80211_IFTYPE_WDS);
-
-	rt2x00dev->hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
-
-	/*
 	 * Initialize work.
 	 */
 	rt2x00dev->workqueue =
@@ -1348,6 +1331,23 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 		goto exit;
 
 	/*
+	 * Determine which operating modes are supported, all modes
+	 * which require beaconing, depend on the availability of
+	 * beacon entries.
+	 */
+	rt2x00dev->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+	if (rt2x00dev->ops->bcn->entry_num > 0)
+		rt2x00dev->hw->wiphy->interface_modes |=
+		    BIT(NL80211_IFTYPE_ADHOC) |
+		    BIT(NL80211_IFTYPE_AP) |
+#ifdef CONFIG_MAC80211_MESH
+		    BIT(NL80211_IFTYPE_MESH_POINT) |
+#endif
+		    BIT(NL80211_IFTYPE_WDS);
+
+	rt2x00dev->hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
+
+	/*
 	 * Initialize ieee80211 structure.
 	 */
 	retval = rt2x00lib_probe_hw(rt2x00dev);
-- 
1.7.10

