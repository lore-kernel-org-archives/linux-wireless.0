Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3213 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751180AbcKHNPj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Nov 2016 08:15:39 -0500
From: <c_traja@qti.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath10k@lists.infradead.org>, <johannes@sipsolutions.net>,
        <tamizhchelvam@codeaurora.org>,
        Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCH 4/4] mac80211: Add support to update btcoex priority value
Date: Tue, 8 Nov 2016 18:45:32 +0530
Message-ID: <1478610932-21954-5-git-send-email-c_traja@qti.qualcomm.com> (sfid-20161108_141542_260107_40E2E47D)
In-Reply-To: <1478610932-21954-1-git-send-email-c_traja@qti.qualcomm.com>
References: <1478610932-21954-1-git-send-email-c_traja@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <c_traja@qti.qualcomm.com>

This patch introduces a new driver callback drv_set_btcoex_priority
to pass the priority value to driver.

Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
---
 include/net/mac80211.h    |    7 +++++++
 net/mac80211/cfg.c        |    9 +++++++++
 net/mac80211/driver-ops.h |   12 ++++++++++++
 3 files changed, 28 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e7db763..3c61015 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3456,6 +3456,11 @@ enum ieee80211_reconfig_type {
  *
  * @set_btcoex_: set_btcoex: Called when BTCOEX is enabled/disabled, use
  *	this callback to enable or disable btcoex.
+ * @set_btcoex_priority: Use this callback to set wlan high
+ *	priority frames over bluetooth. Driver supported wlan frames
+ *	for the BTCOEX is exposed by btcoex_support_flags.
+ *	When BTCOEX enabled, the high priority wlan frames will have
+ *	more priority than BT.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3709,6 +3714,8 @@ struct ieee80211_ops {
 			    struct ieee80211_vif *vif,
 			    u8 instance_id);
 	int (*set_btcoex)(struct ieee80211_hw *hw, bool enabled);
+	int (*set_btcoex_priority)(struct ieee80211_hw *hw,
+		struct cfg80211_btcoex_priority *btcoex_priority);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a687056..d75cf97 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3569,6 +3569,14 @@ static int ieee80211_set_btcoex(struct wiphy *wiphy, bool enabled)
 	return drv_set_btcoex(local, enabled);
 }
 
+static int ieee80211_set_btcoex_priority(struct wiphy *wiphy,
+			struct cfg80211_btcoex_priority *btcoex_priority)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	return drv_set_btcoex_priority(local, btcoex_priority);
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3660,4 +3668,5 @@ static int ieee80211_set_btcoex(struct wiphy *wiphy, bool enabled)
 	.add_nan_func = ieee80211_add_nan_func,
 	.del_nan_func = ieee80211_del_nan_func,
 	.set_btcoex = ieee80211_set_btcoex,
+	.set_btcoex_priority = ieee80211_set_btcoex_priority,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 16d9c98..75ac3ed 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1262,4 +1262,16 @@ static inline int drv_set_btcoex(struct ieee80211_local *local,
 	return ret;
 }
 
+static inline int drv_set_btcoex_priority(struct ieee80211_local *local,
+			struct cfg80211_btcoex_priority *btcoex_priority)
+{
+	int ret = -EOPNOTSUPP;
+
+	if (local->ops->set_btcoex_priority)
+		ret = local->ops->set_btcoex_priority(&local->hw,
+						      btcoex_priority);
+
+	return ret;
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
-- 
1.7.9.5
