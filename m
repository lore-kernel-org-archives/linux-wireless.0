Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:42231 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab3GXIY6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jul 2013 04:24:58 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/5] ath9k: Cleanup BT/WLAN RX diversity
Date: Wed, 24 Jul 2013 13:51:28 +0530
Message-Id: <1374654090-24408-3-git-send-email-sujith@msujith.org> (sfid-20130724_102506_704543_68F644DA)
In-Reply-To: <1374654090-24408-1-git-send-email-sujith@msujith.org>
References: <1374654090-24408-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

For single-chain WLAN+BT cards, the BT antenna can be used for
WLAN RX when the BT interface is disabled. Rename the modparam
"antenna_diversity" to "bt_ant_diversity" to clarify this.

Also, there is no need to check if btcoex is disabled to enable
WLAN/BT RX diversity.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath.h           |  2 +-
 drivers/net/wireless/ath/ath9k/antenna.c |  2 +-
 drivers/net/wireless/ath/ath9k/debug.c   | 32 ++++++++++++++++----------------
 drivers/net/wireless/ath/ath9k/init.c    | 30 +++++++++++++++++++++++-------
 4 files changed, 41 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index daeafef..e0ba7cd 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -159,7 +159,7 @@ struct ath_common {
 
 	bool btcoex_enabled;
 	bool disable_ani;
-	bool antenna_diversity;
+	bool bt_ant_diversity;
 };
 
 struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
diff --git a/drivers/net/wireless/ath/ath9k/antenna.c b/drivers/net/wireless/ath/ath9k/antenna.c
index a05fa18..6560dcb 100644
--- a/drivers/net/wireless/ath/ath9k/antenna.c
+++ b/drivers/net/wireless/ath/ath9k/antenna.c
@@ -831,6 +831,6 @@ void ath_ant_comb_update(struct ath_softc *sc)
 
 	ath9k_hw_antdiv_comb_conf_set(ah, &div_ant_conf);
 
-	if (common->antenna_diversity)
+	if (common->bt_ant_diversity)
 		ath9k_hw_antctrl_shared_chain_lnadiv(ah, true);
 }
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 87454f6..5639c5b 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -270,25 +270,25 @@ static const struct file_operations fops_ani = {
 	.llseek = default_llseek,
 };
 
-static ssize_t read_file_ant_diversity(struct file *file, char __user *user_buf,
-				       size_t count, loff_t *ppos)
+static ssize_t read_file_bt_ant_diversity(struct file *file, char __user *user_buf,
+					  size_t count, loff_t *ppos)
 {
 	struct ath_softc *sc = file->private_data;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	char buf[32];
 	unsigned int len;
 
-	len = sprintf(buf, "%d\n", common->antenna_diversity);
+	len = sprintf(buf, "%d\n", common->bt_ant_diversity);
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
-static ssize_t write_file_ant_diversity(struct file *file,
-					const char __user *user_buf,
-					size_t count, loff_t *ppos)
+static ssize_t write_file_bt_ant_diversity(struct file *file,
+					   const char __user *user_buf,
+					   size_t count, loff_t *ppos)
 {
 	struct ath_softc *sc = file->private_data;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	unsigned long antenna_diversity;
+	unsigned long bt_ant_diversity;
 	char buf[32];
 	ssize_t len;
 
@@ -300,22 +300,22 @@ static ssize_t write_file_ant_diversity(struct file *file,
 		goto exit;
 
 	buf[len] = '\0';
-	if (kstrtoul(buf, 0, &antenna_diversity))
+	if (kstrtoul(buf, 0, &bt_ant_diversity))
 		return -EINVAL;
 
-	common->antenna_diversity = !!antenna_diversity;
+	common->bt_ant_diversity = !!bt_ant_diversity;
 	ath9k_ps_wakeup(sc);
 	ath_ant_comb_update(sc);
-	ath_dbg(common, CONFIG, "Antenna diversity: %d\n",
-		common->antenna_diversity);
+	ath_dbg(common, CONFIG, "BT/WLAN RX Antenna diversity: %d\n",
+		common->bt_ant_diversity);
 	ath9k_ps_restore(sc);
 exit:
 	return count;
 }
 
-static const struct file_operations fops_ant_diversity = {
-	.read = read_file_ant_diversity,
-	.write = write_file_ant_diversity,
+static const struct file_operations fops_bt_ant_diversity = {
+	.read = read_file_bt_ant_diversity,
+	.write = write_file_bt_ant_diversity,
 	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
@@ -1814,8 +1814,8 @@ int ath9k_init_debug(struct ath_hw *ah)
 			   sc->debug.debugfs_phy, &sc->sc_ah->gpio_mask);
 	debugfs_create_u32("gpio_val", S_IRUSR | S_IWUSR,
 			   sc->debug.debugfs_phy, &sc->sc_ah->gpio_val);
-	debugfs_create_file("diversity", S_IRUSR | S_IWUSR,
-			    sc->debug.debugfs_phy, sc, &fops_ant_diversity);
+	debugfs_create_file("bt_ant_diversity", S_IRUSR | S_IWUSR,
+			    sc->debug.debugfs_phy, sc, &fops_bt_ant_diversity);
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 	debugfs_create_file("btcoex", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_btcoex);
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 16f8b20..d27395f 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -53,9 +53,9 @@ static int ath9k_btcoex_enable;
 module_param_named(btcoex_enable, ath9k_btcoex_enable, int, 0444);
 MODULE_PARM_DESC(btcoex_enable, "Enable wifi-BT coexistence");
 
-static int ath9k_enable_diversity;
-module_param_named(enable_diversity, ath9k_enable_diversity, int, 0444);
-MODULE_PARM_DESC(enable_diversity, "Enable Antenna diversity for AR9565");
+static int ath9k_bt_ant_diversity;
+module_param_named(bt_antenna_diversity, ath9k_bt_ant_diversity, int, 0444);
+MODULE_PARM_DESC(bt_antenna_diversity, "Use BT antenna for WLAN RX diversity");
 
 bool is_ath9k_unloaded;
 /* We use the hw_value as an index into our private channel structure */
@@ -631,11 +631,27 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	ath9k_init_platform(sc);
 
 	/*
-	 * Enable Antenna diversity only when BTCOEX is disabled
-	 * and the user manually requests the feature.
+	 * Enable WLAN RX Antenna diversity for WLAN/BT combo
+	 * chips only when the user manually requests the feature.
+	 *
+	 * The BT antenna can be used for WLAN RX when the
+	 * BT interface is disabled. Currently, there is no
+	 * mechanism in the kernel to pass such information
+	 * between the WLAN and BT subsystems. The user has
+	 * to make sure that the BT card is disabled when enabling
+	 * WLAN RX diversity.
+	 *
+	 * Cards which can use this feature are:
+	 *
+	 * WB225 - AR9485 + AR3012
+	 * WB335 - AR9565 (WLAN+BT Combo SoC).
+	 *
+	 * Diversity combining is available for WB225 and WB335.
+	 * WB195 which is a AR9285 + AR3011 card doesn't have
+	 * this feature.
 	 */
-	if (!common->btcoex_enabled && ath9k_enable_diversity)
-		common->antenna_diversity = 1;
+	if (ath9k_bt_ant_diversity)
+		common->bt_ant_diversity = 1;
 
 	spin_lock_init(&common->cc_lock);
 
-- 
1.8.3.3

