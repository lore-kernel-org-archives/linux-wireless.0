Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:55178 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752252AbdEPJX3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 05:23:29 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, benjamin@sipsolutions.net,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 2/7] wireless: Only join DFS channels in mesh mode if userspace flags support
Date: Tue, 16 May 2017 11:23:11 +0200
Message-Id: <20170516092316.15636-3-sw@simonwunderlich.de> (sfid-20170516_112813_968260_E1943F5A)
In-Reply-To: <20170516092316.15636-1-sw@simonwunderlich.de>
References: <20170516092316.15636-1-sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Benjamin Berg <benjamin@sipsolutions.net>

When joining a mesh network it is not guaranteed that userspace has a
daemon listening for radar events. This is however required for channels
requiring DFS. To flag that userspace will handle radar events, it needs
to set NL80211_ATTR_HANDLE_DFS.

This matches the current mechanism used for IBSS mode.

Signed-off-by: Benjamin Berg <benjamin@sipsolutions.net>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 include/net/cfg80211.h | 4 ++++
 net/wireless/mesh.c    | 8 ++++++++
 net/wireless/nl80211.c | 3 +++
 3 files changed, 15 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b083e6cbae8c..fa25fbb67cb6 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1441,6 +1441,9 @@ struct mesh_config {
  * @mcast_rate: multicat rate for Mesh Node [6Mbps is the default for 802.11a]
  * @basic_rates: basic rates to use when creating the mesh
  * @beacon_rate: bitrate to be used for beacons
+ * @userspace_handles_dfs: whether user space controls DFS operation, i.e.
+ *	changes the channel when a radar is detected. This is required
+ *	to operate on DFS channels.
  *
  * These parameters are fixed when the mesh is created.
  */
@@ -1462,6 +1465,7 @@ struct mesh_setup {
 	int mcast_rate[NUM_NL80211_BANDS];
 	u32 basic_rates;
 	struct cfg80211_bitrate_mask beacon_rate;
+	bool userspace_handles_dfs;
 };
 
 /**
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index ec0b1c20ac99..421a6b80ec62 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -174,6 +174,14 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 							       scan_width);
 	}
 
+	err = cfg80211_chandef_dfs_required(&rdev->wiphy,
+					    &setup->chandef,
+					    NL80211_IFTYPE_MESH_POINT);
+	if (err < 0)
+		return err;
+	if (err > 0 && !setup->userspace_handles_dfs)
+		return -EINVAL;
+
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &setup->chandef,
 				     NL80211_IFTYPE_MESH_POINT))
 		return -EINVAL;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c3bc9da30cff..d47e55e3f445 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9962,6 +9962,9 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 			return err;
 	}
 
+	setup.userspace_handles_dfs =
+		nla_get_flag(info->attrs[NL80211_ATTR_HANDLE_DFS]);
+
 	return cfg80211_join_mesh(rdev, dev, &setup, &cfg);
 }
 
-- 
2.11.0
