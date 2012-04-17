Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57991 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515Ab2DQAji (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 20:39:38 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org
Subject: [PATCH v3] ath5k: add possible wiphy interface combinations
Date: Tue, 17 Apr 2012 02:39:27 +0200
Message-Id: <1334623167-64479-1-git-send-email-nbd@openwrt.org> (sfid-20120417_023945_783769_41B4BF1E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath5k/base.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 3007bba..ad549d2 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2415,6 +2415,22 @@ ath5k_tx_complete_poll_work(struct work_struct *work)
 * Initialization routines *
 \*************************/
 
+static const struct ieee80211_iface_limit if_limits[] = {
+	{ .max = 2048,	.types = BIT(NL80211_IFTYPE_STATION) },
+	{ .max = 4,	.types =
+#ifdef CONFIG_MAC80211_MESH
+				 BIT(NL80211_IFTYPE_MESH_POINT) |
+#endif
+				 BIT(NL80211_IFTYPE_AP) },
+};
+
+static const struct ieee80211_iface_combination if_comb = {
+	.limits = if_limits,
+	.n_limits = ARRAY_SIZE(if_limits),
+	.max_interfaces = 2048,
+	.num_different_channels = 1,
+};
+
 int __devinit
 ath5k_init_ah(struct ath5k_hw *ah, const struct ath_bus_ops *bus_ops)
 {
@@ -2436,6 +2452,9 @@ ath5k_init_ah(struct ath5k_hw *ah, const struct ath_bus_ops *bus_ops)
 		BIT(NL80211_IFTYPE_ADHOC) |
 		BIT(NL80211_IFTYPE_MESH_POINT);
 
+	hw->wiphy->iface_combinations = &if_comb;
+	hw->wiphy->n_iface_combinations = 1;
+
 	/* SW support for IBSS_RSN is provided by mac80211 */
 	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 
-- 
1.7.3.2

