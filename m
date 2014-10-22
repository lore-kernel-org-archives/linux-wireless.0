Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56684 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287AbaJVTXR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 15:23:17 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v3 9/9] mac80211:  support creating vifs with specified mac address
Date: Wed, 22 Oct 2014 12:23:06 -0700
Message-Id: <1414005786-27572-9-git-send-email-greearb@candelatech.com> (sfid-20141022_212328_081539_AD7897D8)
In-Reply-To: <1414005786-27572-1-git-send-email-greearb@candelatech.com>
References: <1414005786-27572-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This is useful when creating virtual interfaces.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/iface.c | 5 ++++-
 net/mac80211/main.c  | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index e469b33..1ffcc07 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1671,7 +1671,10 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		}
 
 		ieee80211_assign_perm_addr(local, ndev->perm_addr, type);
-		memcpy(ndev->dev_addr, ndev->perm_addr, ETH_ALEN);
+		if (params && is_valid_ether_addr(params->macaddr))
+			memcpy(ndev->dev_addr, params->macaddr, ETH_ALEN);
+		else
+			memcpy(ndev->dev_addr, ndev->perm_addr, ETH_ALEN);
 		SET_NETDEV_DEV(ndev, wiphy_dev(local->hw.wiphy));
 
 		/* don't use IEEE80211_DEV_TO_SUB_IF -- it checks too much */
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 7d40e3f..282a4f3 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -542,6 +542,7 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 			   NL80211_FEATURE_SAE |
 			   NL80211_FEATURE_HT_IBSS |
 			   NL80211_FEATURE_VIF_TXPOWER |
+			   NL80211_FEATURE_MAC_ON_CREATE |
 			   NL80211_FEATURE_USERSPACE_MPM;
 
 	if (!ops->hw_scan)
-- 
1.7.11.7

