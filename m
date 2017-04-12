Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35234 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752677AbdDLLGZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Apr 2017 07:06:25 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: aviya.erenfeld@intel.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/6] cfg80211: allow leaving MU-MIMO monitor configuration unchanged
Date: Wed, 12 Apr 2017 13:06:17 +0200
Message-Id: <20170412110621.8981-2-johannes@sipsolutions.net> (sfid-20170412_130630_743447_156894B1)
In-Reply-To: <20170412110621.8981-1-johannes@sipsolutions.net>
References: <20170412110621.8981-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When changing monitor parameters, not setting the MU-MIMO attributes
should mean that they're not changed - it's documented that to turn
the feature off it's necessary to set all-zero group membership and
an invalid follow-address. This isn't implemented.

Fix this by making the parameters pointers, stop reusing the macaddr
struct member, and documenting that NULL pointers mean unchanged.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 9 ++++++---
 net/mac80211/cfg.c     | 8 ++++----
 net/wireless/nl80211.c | 8 +++-----
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ead1aa6d003e..70dfdb964958 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -370,13 +370,16 @@ static inline void wiphy_read_of_freq_limits(struct wiphy *wiphy)
  *	This feature is only fully supported by drivers that enable the
  *	%NL80211_FEATURE_MAC_ON_CREATE flag.  Others may support creating
  **	only p2p devices with specified MAC.
- * @vht_mumimo_groups: MU-MIMO groupID. used for monitoring only
- *	 packets belonging to that MU-MIMO groupID.
+ * @vht_mumimo_groups: MU-MIMO groupID, used for monitoring MU-MIMO packets
+ *	belonging to that MU-MIMO groupID; %NULL if not changed
+ * @vht_mumimo_follow_addr: MU-MIMO follow address, used for monitoring
+ *	MU-MIMO packets going to the specified station; %NULL if not changed
  */
 struct vif_params {
 	int use_4addr;
 	u8 macaddr[ETH_ALEN];
-	u8 vht_mumimo_groups[VHT_MUMIMO_GROUPS_DATA_LEN];
+	const u8 *vht_mumimo_groups;
+	const u8 *vht_mumimo_follow_addr;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ac879bb17870..dc397815a8bf 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -80,8 +80,7 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 		u32 mu_mntr_cap_flag = NL80211_EXT_FEATURE_MU_MIMO_AIR_SNIFFER;
 
 		monitor_sdata = rtnl_dereference(local->monitor_sdata);
-		if (monitor_sdata &&
-		    wiphy_ext_feature_isset(wiphy, mu_mntr_cap_flag)) {
+		if (monitor_sdata && params->vht_mumimo_groups) {
 			memcpy(monitor_sdata->vif.bss_conf.mu_group.membership,
 			       params->vht_mumimo_groups, WLAN_MEMBERSHIP_LEN);
 			memcpy(monitor_sdata->vif.bss_conf.mu_group.position,
@@ -90,10 +89,11 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 			monitor_sdata->vif.mu_mimo_owner = true;
 			ieee80211_bss_info_change_notify(monitor_sdata,
 							 BSS_CHANGED_MU_GROUPS);
+		}
 
+		if (monitor_sdata && params->vht_mumimo_follow_addr)
 			ether_addr_copy(monitor_sdata->u.mntr.mu_follow_addr,
-					params->macaddr);
-		}
+					params->vht_mumimo_follow_addr);
 
 		if (!flags)
 			return 0;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2312dc2ffdb9..1b8f267315f1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2809,8 +2809,7 @@ static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
 		    (mumimo_groups[VHT_MUMIMO_GROUPS_DATA_LEN - 1] & BIT(0)))
 			return -EINVAL;
 
-		memcpy(params.vht_mumimo_groups, mumimo_groups,
-		       VHT_MUMIMO_GROUPS_DATA_LEN);
+		params.vht_mumimo_groups = mumimo_groups;
 		change = true;
 	}
 
@@ -2820,9 +2819,8 @@ static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
 		if (!wiphy_ext_feature_isset(&rdev->wiphy, cap_flag))
 			return -EOPNOTSUPP;
 
-		nla_memcpy(params.macaddr,
-			   info->attrs[NL80211_ATTR_MU_MIMO_FOLLOW_MAC_ADDR],
-			   ETH_ALEN);
+		params.vht_mumimo_follow_addr =
+			nla_data(info->attrs[NL80211_ATTR_MU_MIMO_FOLLOW_MAC_ADDR]);
 		change = true;
 	}
 
-- 
2.11.0
