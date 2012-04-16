Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42662 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794Ab2DPP2a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 11:28:30 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org
Subject: [PATCH] ath5k: add possible wiphy interface combinations
Date: Mon, 16 Apr 2012 17:28:22 +0200
Message-Id: <1334590102-83386-1-git-send-email-nbd@openwrt.org> (sfid-20120416_172834_154696_50414FB0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath5k/base.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 3007bba..2e385f5 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2415,6 +2415,19 @@ ath5k_tx_complete_poll_work(struct work_struct *work)
 * Initialization routines *
 \*************************/
 
+static const struct ieee80211_iface_limit if_limits[] = {
+	{ .max = 256,	.types = BIT(NL80211_IFTYPE_STATION) },
+	{ .max = 4,	.types = BIT(NL80211_IFTYPE_AP) |
+				 BIT(NL80211_IFTYPE_MESH_POINT) },
+};
+
+static const struct ieee80211_iface_combination if_comb = {
+	.limits = if_limits,
+	.n_limits = ARRAY_SIZE(if_limits),
+	.max_interfaces = 256,
+	.num_different_channels = 1,
+};
+
 int __devinit
 ath5k_init_ah(struct ath5k_hw *ah, const struct ath_bus_ops *bus_ops)
 {
@@ -2436,6 +2449,9 @@ ath5k_init_ah(struct ath5k_hw *ah, const struct ath_bus_ops *bus_ops)
 		BIT(NL80211_IFTYPE_ADHOC) |
 		BIT(NL80211_IFTYPE_MESH_POINT);
 
+	hw->wiphy->iface_combinations = &if_comb;
+	hw->wiphy->n_iface_combinations = 1;
+
 	/* SW support for IBSS_RSN is provided by mac80211 */
 	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 
-- 
1.7.3.2

