Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43050 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174Ab2DPQTz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 12:19:55 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v2] ath9k: add possible wiphy interface combinations
Date: Mon, 16 Apr 2012 18:19:50 +0200
Message-Id: <1334593190-90956-1-git-send-email-nbd@openwrt.org> (sfid-20120416_182148_363894_EC2CD380)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/init.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 7a6b9f6..622dd15 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -646,6 +646,21 @@ void ath9k_reload_chainmask_settings(struct ath_softc *sc)
 		setup_ht_cap(sc, &sc->sbands[IEEE80211_BAND_5GHZ].ht_cap);
 }
 
+static const struct ieee80211_iface_limit if_limits[] = {
+	{ .max = 2048,	.types = BIT(NL80211_IFTYPE_STATION) |
+				 BIT(NL80211_IFTYPE_P2P_CLIENT) |
+				 BIT(NL80211_IFTYPE_WDS) },
+	{ .max = 8,	.types = BIT(NL80211_IFTYPE_AP) |
+				 BIT(NL80211_IFTYPE_P2P_GO) |
+				 BIT(NL80211_IFTYPE_MESH_POINT) },
+};
+
+static const struct ieee80211_iface_combination if_comb = {
+	.limits = if_limits,
+	.n_limits = ARRAY_SIZE(if_limits),
+	.max_interfaces = 2048,
+	.num_different_channels = 1,
+};
 
 void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 {
@@ -675,6 +690,9 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 		BIT(NL80211_IFTYPE_ADHOC) |
 		BIT(NL80211_IFTYPE_MESH_POINT);
 
+	hw->wiphy->iface_combinations = &if_comb;
+	hw->wiphy->n_iface_combinations = 1;
+
 	if (AR_SREV_5416(sc->sc_ah))
 		hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
-- 
1.7.3.2

