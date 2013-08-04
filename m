Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:38418 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab3HDIzm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Aug 2013 04:55:42 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 06/11] ath9k: Rename ath9k_hw_antctrl_shared_chain_lnadiv
Date: Sun,  4 Aug 2013 14:21:57 +0530
Message-Id: <1375606322-9983-6-git-send-email-sujith@msujith.org> (sfid-20130804_105613_267501_FBCBA698)
In-Reply-To: <1375606322-9983-1-git-send-email-sujith@msujith.org>
References: <1375606322-9983-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Use "ath9k_hw_set_bt_ant_diversity" instead.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/antenna.c    | 2 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 5 ++---
 drivers/net/wireless/ath/ath9k/hw-ops.h     | 7 +++----
 drivers/net/wireless/ath/ath9k/hw.h         | 2 +-
 4 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/antenna.c b/drivers/net/wireless/ath/ath9k/antenna.c
index 354dc66..85391e6 100644
--- a/drivers/net/wireless/ath/ath9k/antenna.c
+++ b/drivers/net/wireless/ath/ath9k/antenna.c
@@ -888,5 +888,5 @@ void ath_ant_comb_update(struct ath_softc *sc)
 	ath9k_hw_antdiv_comb_conf_set(ah, &div_ant_conf);
 
 	if (common->bt_ant_diversity)
-		ath9k_hw_antctrl_shared_chain_lnadiv(ah, true);
+		ath9k_hw_set_bt_ant_diversity(ah, true);
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 3ec33ce..f9fe9c8 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1412,8 +1412,7 @@ static void ar9003_hw_antdiv_comb_conf_set(struct ath_hw *ah,
 	REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
 }
 
-static void ar9003_hw_antctrl_shared_chain_lnadiv(struct ath_hw *ah,
-						  bool enable)
+static void ar9003_hw_set_bt_ant_diversity(struct ath_hw *ah, bool enable)
 {
 	u8 ant_div_ctl1;
 	u32 regval;
@@ -1646,7 +1645,7 @@ void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 
 	ops->antdiv_comb_conf_get = ar9003_hw_antdiv_comb_conf_get;
 	ops->antdiv_comb_conf_set = ar9003_hw_antdiv_comb_conf_set;
-	ops->antctrl_shared_chain_lnadiv = ar9003_hw_antctrl_shared_chain_lnadiv;
+	ops->set_bt_ant_diversity = ar9003_hw_set_bt_ant_diversity;
 	ops->spectral_scan_config = ar9003_hw_spectral_scan_config;
 	ops->spectral_scan_trigger = ar9003_hw_spectral_scan_trigger;
 	ops->spectral_scan_wait = ar9003_hw_spectral_scan_wait;
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index 14b7011..a78d48c 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -78,11 +78,10 @@ static inline void ath9k_hw_antdiv_comb_conf_set(struct ath_hw *ah,
 	ath9k_hw_ops(ah)->antdiv_comb_conf_set(ah, antconf);
 }
 
-static inline void ath9k_hw_antctrl_shared_chain_lnadiv(struct ath_hw *ah,
-							bool enable)
+static inline void ath9k_hw_set_bt_ant_diversity(struct ath_hw *ah, bool enable)
 {
-	if (ath9k_hw_ops(ah)->antctrl_shared_chain_lnadiv)
-		ath9k_hw_ops(ah)->antctrl_shared_chain_lnadiv(ah, enable);
+	if (ath9k_hw_ops(ah)->set_bt_ant_diversity)
+		ath9k_hw_ops(ah)->set_bt_ant_diversity(ah, enable);
 }
 
 /* Private hardware call ops */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 4ab8f58..c037718 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -718,7 +718,7 @@ struct ath_hw_ops {
 			struct ath_hw_antcomb_conf *antconf);
 	void (*antdiv_comb_conf_set)(struct ath_hw *ah,
 			struct ath_hw_antcomb_conf *antconf);
-	void (*antctrl_shared_chain_lnadiv)(struct ath_hw *hw, bool enable);
+	void (*set_bt_ant_diversity)(struct ath_hw *hw, bool enable);
 	void (*spectral_scan_config)(struct ath_hw *ah,
 				     struct ath_spec_scan *param);
 	void (*spectral_scan_trigger)(struct ath_hw *ah);
-- 
1.8.3.4

