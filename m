Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32353 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbcCIL1O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 06:27:14 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/2] mac80211: add NETIF_F_RXCSUM to features white list
Date: Wed,  9 Mar 2016 13:27:08 +0200
Message-Id: <1457522829-315-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160309_122717_308343_C93FBBEE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

NETIF_F_RXCSUM is not in the white list, though some
drivers may want to set it in order to enable seeing the
actual RX checksum status in ethtool.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 8155961..33c80de 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -856,7 +856,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	/* Only HW csum features are currently compatible with mac80211 */
 	feature_whitelist = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 			    NETIF_F_HW_CSUM | NETIF_F_SG | NETIF_F_HIGHDMA |
-			    NETIF_F_GSO_SOFTWARE;
+			    NETIF_F_GSO_SOFTWARE | NETIF_F_RXCSUM;
 	if (WARN_ON(hw->netdev_features & ~feature_whitelist))
 		return -EINVAL;
 
-- 
2.5.0

