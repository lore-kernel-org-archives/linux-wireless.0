Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:2934 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753096Ab2IWSXR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Sep 2012 14:23:17 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Cc: <users@rt2x00.serialmonkey.com>, Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH 2/2] rt2x00: Replace open coded interface checking with interface combinations.
Date: Sun, 23 Sep 2012 20:22:54 +0200
Message-Id: <1348424574-1573-2-git-send-email-gwingerde@gmail.com> (sfid-20120923_202322_774279_4F3B998C)
In-Reply-To: <1348424574-1573-1-git-send-email-gwingerde@gmail.com>
References: <1348424574-1573-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mac80211 has formal infrastructure to specify which interface combinations
are supported. Make use of this facility in favor of open coding it
ourselves.
So far we only have to specify we can support multiple AP interfaces,
no other combinations are supported.

Inspired by an earlier patch from Paul Fertser.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Paul Fertser <fercerpav@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    | 14 ++++++++++++
 drivers/net/wireless/rt2x00/rt2x00dev.c | 33 ++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00mac.c | 39 ---------------------------------
 3 files changed, 47 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 09bf01c..0751b35 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -741,6 +741,14 @@ enum rt2x00_capability_flags {
 };
 
 /*
+ * Interface combinations
+ */
+enum {
+	IF_COMB_AP = 0,
+	NUM_IF_COMB,
+};
+
+/*
  * rt2x00 device structure.
  */
 struct rt2x00_dev {
@@ -867,6 +875,12 @@ struct rt2x00_dev {
 	unsigned int intf_beaconing;
 
 	/*
+	 * Interface combinations
+	 */
+	struct ieee80211_iface_limit if_limits_ap;
+	struct ieee80211_iface_combination if_combinations[NUM_IF_COMB];
+
+	/*
 	 * Link quality
 	 */
 	struct link link;
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 10cf672..69097d1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1118,6 +1118,34 @@ void rt2x00lib_stop(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->intf_associated = 0;
 }
 
+static inline void rt2x00lib_set_if_combinations(struct rt2x00_dev *rt2x00dev)
+{
+	struct ieee80211_iface_limit *if_limit;
+	struct ieee80211_iface_combination *if_combination;
+
+	/*
+	 * Build up AP interface limits structure.
+	 */
+	if_limit = &rt2x00dev->if_limits_ap;
+	if_limit->max = rt2x00dev->ops->max_ap_intf;
+	if_limit->types = BIT(NL80211_IFTYPE_AP);
+
+	/*
+	 * Build up AP interface combinations structure.
+	 */
+	if_combination = &rt2x00dev->if_combinations[IF_COMB_AP];
+	if_combination->limits = if_limit;
+	if_combination->n_limits = 1;
+	if_combination->max_interfaces = if_limit->max;
+	if_combination->num_different_channels = 1;
+
+	/*
+	 * Finally, specify the possible combinations to mac80211.
+	 */
+	rt2x00dev->hw->wiphy->iface_combinations = rt2x00dev->if_combinations;
+	rt2x00dev->hw->wiphy->n_iface_combinations = 1;
+}
+
 /*
  * driver allocation handlers.
  */
@@ -1126,6 +1154,11 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	int retval = -ENOMEM;
 
 	/*
+	 * Set possible interface combinations.
+	 */
+	rt2x00lib_set_if_combinations(rt2x00dev);
+
+	/*
 	 * Allocate the driver data memory, if necessary.
 	 */
 	if (rt2x00dev->ops->drv_data_size > 0) {
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 2f98d3d..98a9e48 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -214,45 +214,6 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 	    !test_bit(DEVICE_STATE_STARTED, &rt2x00dev->flags))
 		return -ENODEV;
 
-	switch (vif->type) {
-	case NL80211_IFTYPE_AP:
-		/*
-		 * We don't support mixed combinations of
-		 * sta and ap interfaces.
-		 */
-		if (rt2x00dev->intf_sta_count)
-			return -ENOBUFS;
-
-		/*
-		 * Check if we exceeded the maximum amount
-		 * of supported interfaces.
-		 */
-		if (rt2x00dev->intf_ap_count >= rt2x00dev->ops->max_ap_intf)
-			return -ENOBUFS;
-
-		break;
-	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_ADHOC:
-	case NL80211_IFTYPE_MESH_POINT:
-	case NL80211_IFTYPE_WDS:
-		/*
-		 * We don't support mixed combinations of
-		 * sta and ap interfaces.
-		 */
-		if (rt2x00dev->intf_ap_count)
-			return -ENOBUFS;
-
-		/*
-		 * We don't support multiple STA interfaces.
-		 */
-		if (rt2x00dev->intf_sta_count)
-			return -ENOBUFS;
-
-		break;
-	default:
-		return -EINVAL;
-	}
-
 	/*
 	 * Loop through all beacon queues to find a free
 	 * entry. Since there are as much beacon entries
-- 
1.7.12.1

