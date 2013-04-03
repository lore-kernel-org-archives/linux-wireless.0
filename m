Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:38722 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759954Ab3DCQbu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 12:31:50 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, siwu@hrz.tu-chemnitz.de,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH 1/3] ath9k: add interface combinations for DFS master
Date: Wed,  3 Apr 2013 18:31:29 +0200
Message-Id: <1365006691-16705-2-git-send-email-zefir.kurtisi@neratec.com> (sfid-20130403_183158_582099_96E32163)
In-Reply-To: <1365006691-16705-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1365006691-16705-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/init.c |   32 ++++++++++++++++++++++++--------
 1 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index af932c9..385c59a 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -727,12 +727,28 @@ static const struct ieee80211_iface_limit if_limits[] = {
 				 BIT(NL80211_IFTYPE_P2P_GO) },
 };
 
-static const struct ieee80211_iface_combination if_comb = {
-	.limits = if_limits,
-	.n_limits = ARRAY_SIZE(if_limits),
-	.max_interfaces = 2048,
-	.num_different_channels = 1,
-	.beacon_int_infra_match = true,
+
+static const struct ieee80211_iface_limit if_dfs_limits[] = {
+	{ .max = 1,	.types = BIT(NL80211_IFTYPE_AP) },
+};
+
+static const struct ieee80211_iface_combination if_comb[] = {
+	{
+		.limits = if_limits,
+		.n_limits = ARRAY_SIZE(if_limits),
+		.max_interfaces = 2048,
+		.num_different_channels = 1,
+		.beacon_int_infra_match = true,
+	},
+	{
+		.limits = if_dfs_limits,
+		.n_limits = ARRAY_SIZE(if_dfs_limits),
+		.max_interfaces = 1,
+		.num_different_channels = 1,
+		.beacon_int_infra_match = true,
+		.radar_detect_widths =	BIT(NL80211_CHAN_NO_HT) |
+					BIT(NL80211_CHAN_HT20),
+	}
 };
 
 void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
@@ -763,8 +779,8 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 		BIT(NL80211_IFTYPE_ADHOC) |
 		BIT(NL80211_IFTYPE_MESH_POINT);
 
-	hw->wiphy->iface_combinations = &if_comb;
-	hw->wiphy->n_iface_combinations = 1;
+	hw->wiphy->iface_combinations = if_comb;
+	hw->wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
 
 	if (AR_SREV_5416(sc->sc_ah))
 		hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
-- 
1.7.4.1

