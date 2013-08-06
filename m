Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:42744 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab3HFHRv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 03:17:51 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Fix build failure
Date: Tue,  6 Aug 2013 12:44:15 +0530
Message-Id: <1375773255-1002-1-git-send-email-sujith@msujith.org> (sfid-20130806_091755_370647_C239B738)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Make sure that CONFIG_ATH9K_BTCOEX_SUPPORT is used for
the WLAN/BT RX diversity hooks.

Reported by the kernel build testing backend.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_phy.c | 9 ++++++++-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 9 ++++++++-
 drivers/net/wireless/ath/ath9k/debug.c      | 8 ++++++--
 drivers/net/wireless/ath/ath9k/hw-ops.h     | 4 ++++
 drivers/net/wireless/ath/ath9k/hw.h         | 5 ++++-
 5 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index 456d8b9..1fc1fa9 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -555,6 +555,8 @@ static void ar9002_hw_antdiv_comb_conf_set(struct ath_hw *ah,
 	REG_WRITE(ah, AR_PHY_MULTICHAIN_GAIN_CTL, regval);
 }
 
+#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
+
 static void ar9002_hw_set_bt_ant_diversity(struct ath_hw *ah, bool enable)
 {
 	struct ath_btcoex_hw *btcoex = &ah->btcoex_hw;
@@ -614,6 +616,8 @@ static void ar9002_hw_set_bt_ant_diversity(struct ath_hw *ah, bool enable)
 	REG_WRITE(ah, AR_PHY_CCK_DETECT, regval);
 }
 
+#endif
+
 static void ar9002_hw_spectral_scan_config(struct ath_hw *ah,
 				    struct ath_spec_scan *param)
 {
@@ -689,10 +693,13 @@ void ar9002_hw_attach_phy_ops(struct ath_hw *ah)
 
 	ops->antdiv_comb_conf_get = ar9002_hw_antdiv_comb_conf_get;
 	ops->antdiv_comb_conf_set = ar9002_hw_antdiv_comb_conf_set;
-	ops->set_bt_ant_diversity = ar9002_hw_set_bt_ant_diversity;
 	ops->spectral_scan_config = ar9002_hw_spectral_scan_config;
 	ops->spectral_scan_trigger = ar9002_hw_spectral_scan_trigger;
 	ops->spectral_scan_wait = ar9002_hw_spectral_scan_wait;
 
+#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
+	ops->set_bt_ant_diversity = ar9002_hw_set_bt_ant_diversity;
+#endif
+
 	ar9002_hw_set_nf_limits(ah);
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 4898829..39c3730 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1412,6 +1412,8 @@ static void ar9003_hw_antdiv_comb_conf_set(struct ath_hw *ah,
 	REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
 }
 
+#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
+
 static void ar9003_hw_set_bt_ant_diversity(struct ath_hw *ah, bool enable)
 {
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
@@ -1513,6 +1515,8 @@ static void ar9003_hw_set_bt_ant_diversity(struct ath_hw *ah, bool enable)
 	}
 }
 
+#endif
+
 static int ar9003_hw_fast_chan_change(struct ath_hw *ah,
 				      struct ath9k_channel *chan,
 				      u8 *ini_reloaded)
@@ -1688,11 +1692,14 @@ void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 
 	ops->antdiv_comb_conf_get = ar9003_hw_antdiv_comb_conf_get;
 	ops->antdiv_comb_conf_set = ar9003_hw_antdiv_comb_conf_set;
-	ops->set_bt_ant_diversity = ar9003_hw_set_bt_ant_diversity;
 	ops->spectral_scan_config = ar9003_hw_spectral_scan_config;
 	ops->spectral_scan_trigger = ar9003_hw_spectral_scan_trigger;
 	ops->spectral_scan_wait = ar9003_hw_spectral_scan_wait;
 
+#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
+	ops->set_bt_ant_diversity = ar9003_hw_set_bt_ant_diversity;
+#endif
+
 	ar9003_hw_set_nf_limits(ah);
 	ar9003_hw_set_radar_conf(ah);
 	memcpy(ah->nf_regs, ar9300_cca_regs, sizeof(ah->nf_regs));
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index a155190..414584e 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -270,6 +270,8 @@ static const struct file_operations fops_ani = {
 	.llseek = default_llseek,
 };
 
+#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
+
 static ssize_t read_file_bt_ant_diversity(struct file *file,
 					  char __user *user_buf,
 					  size_t count, loff_t *ppos)
@@ -323,6 +325,8 @@ static const struct file_operations fops_bt_ant_diversity = {
 	.llseek = default_llseek,
 };
 
+#endif
+
 void ath9k_debug_stat_ant(struct ath_softc *sc,
 			  struct ath_hw_antcomb_conf *div_ant_conf,
 			  int main_rssi_avg, int alt_rssi_avg)
@@ -1935,11 +1939,11 @@ int ath9k_init_debug(struct ath_hw *ah)
 			   sc->debug.debugfs_phy, &sc->sc_ah->gpio_mask);
 	debugfs_create_u32("gpio_val", S_IRUSR | S_IWUSR,
 			   sc->debug.debugfs_phy, &sc->sc_ah->gpio_val);
-	debugfs_create_file("bt_ant_diversity", S_IRUSR | S_IWUSR,
-			    sc->debug.debugfs_phy, sc, &fops_bt_ant_diversity);
 	debugfs_create_file("antenna_diversity", S_IRUSR,
 			    sc->debug.debugfs_phy, sc, &fops_antenna_diversity);
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
+	debugfs_create_file("bt_ant_diversity", S_IRUSR | S_IWUSR,
+			    sc->debug.debugfs_phy, sc, &fops_bt_ant_diversity);
 	debugfs_create_file("btcoex", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_btcoex);
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index a78d48c..83f4927 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -78,12 +78,16 @@ static inline void ath9k_hw_antdiv_comb_conf_set(struct ath_hw *ah,
 	ath9k_hw_ops(ah)->antdiv_comb_conf_set(ah, antconf);
 }
 
+#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
+
 static inline void ath9k_hw_set_bt_ant_diversity(struct ath_hw *ah, bool enable)
 {
 	if (ath9k_hw_ops(ah)->set_bt_ant_diversity)
 		ath9k_hw_ops(ah)->set_bt_ant_diversity(ah, enable);
 }
 
+#endif
+
 /* Private hardware call ops */
 
 /* PHY ops */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 38f461c..64ff8e6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -719,11 +719,14 @@ struct ath_hw_ops {
 			struct ath_hw_antcomb_conf *antconf);
 	void (*antdiv_comb_conf_set)(struct ath_hw *ah,
 			struct ath_hw_antcomb_conf *antconf);
-	void (*set_bt_ant_diversity)(struct ath_hw *hw, bool enable);
 	void (*spectral_scan_config)(struct ath_hw *ah,
 				     struct ath_spec_scan *param);
 	void (*spectral_scan_trigger)(struct ath_hw *ah);
 	void (*spectral_scan_wait)(struct ath_hw *ah);
+
+#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
+	void (*set_bt_ant_diversity)(struct ath_hw *hw, bool enable);
+#endif
 };
 
 struct ath_nf_limits {
-- 
1.8.3.4

