Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:53647 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab3HDIzi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Aug 2013 04:55:38 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 04/11] ath9k: Cleanup WLAN/BT RX diversity
Date: Sun,  4 Aug 2013 14:21:55 +0530
Message-Id: <1375606322-9983-4-git-send-email-sujith@msujith.org> (sfid-20130804_105617_434536_1BE11B36)
In-Reply-To: <1375606322-9983-1-git-send-email-sujith@msujith.org>
References: <1375606322-9983-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

For single-chain WLAN+BT cards, the BT antenna can be used for
WLAN RX when the BT interface is disabled. Rename the modparam
"antenna_diversity" to "bt_ant_diversity" to clarify this.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath.h           |  2 +-
 drivers/net/wireless/ath/ath9k/antenna.c |  2 +-
 drivers/net/wireless/ath/ath9k/debug.c   | 38 +++++++++++++++-----------------
 drivers/net/wireless/ath/ath9k/init.c    | 12 +++++-----
 4 files changed, 26 insertions(+), 28 deletions(-)

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
index 8de314c..354dc66 100644
--- a/drivers/net/wireless/ath/ath9k/antenna.c
+++ b/drivers/net/wireless/ath/ath9k/antenna.c
@@ -887,6 +887,6 @@ void ath_ant_comb_update(struct ath_softc *sc)
 
 	ath9k_hw_antdiv_comb_conf_set(ah, &div_ant_conf);
 
-	if (common->antenna_diversity)
+	if (common->bt_ant_diversity)
 		ath9k_hw_antctrl_shared_chain_lnadiv(ah, true);
 }
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index e744d97..881ca6c 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -270,25 +270,26 @@ static const struct file_operations fops_ani = {
 	.llseek = default_llseek,
 };
 
-static ssize_t read_file_ant_diversity(struct file *file, char __user *user_buf,
-				       size_t count, loff_t *ppos)
+static ssize_t read_file_bt_ant_diversity(struct file *file,
+					  char __user *user_buf,
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
 
@@ -296,26 +297,23 @@ static ssize_t write_file_ant_diversity(struct file *file,
 	if (copy_from_user(buf, user_buf, len))
 		return -EFAULT;
 
-	if (!AR_SREV_9565(sc->sc_ah))
-		goto exit;
-
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
+	ath_dbg(common, CONFIG, "Enable WLAN/BT RX Antenna diversity: %d\n",
+		common->bt_ant_diversity);
 	ath9k_ps_restore(sc);
-exit:
+
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
@@ -1933,8 +1931,8 @@ int ath9k_init_debug(struct ath_hw *ah)
 			   sc->debug.debugfs_phy, &sc->sc_ah->gpio_mask);
 	debugfs_create_u32("gpio_val", S_IRUSR | S_IWUSR,
 			   sc->debug.debugfs_phy, &sc->sc_ah->gpio_val);
-	debugfs_create_file("diversity", S_IRUSR | S_IWUSR,
-			    sc->debug.debugfs_phy, sc, &fops_ant_diversity);
+	debugfs_create_file("bt_ant_diversity", S_IRUSR | S_IWUSR,
+			    sc->debug.debugfs_phy, sc, &fops_bt_ant_diversity);
 	debugfs_create_file("antenna_diversity", S_IRUSR,
 			    sc->debug.debugfs_phy, sc, &fops_antenna_diversity);
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 7ded9d6..5e81b2c 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -53,9 +53,9 @@ static int ath9k_btcoex_enable;
 module_param_named(btcoex_enable, ath9k_btcoex_enable, int, 0444);
 MODULE_PARM_DESC(btcoex_enable, "Enable wifi-BT coexistence");
 
-static int ath9k_enable_diversity;
-module_param_named(enable_diversity, ath9k_enable_diversity, int, 0444);
-MODULE_PARM_DESC(enable_diversity, "Enable Antenna diversity for AR9565");
+static int ath9k_bt_ant_diversity;
+module_param_named(bt_ant_diversity, ath9k_bt_ant_diversity, int, 0444);
+MODULE_PARM_DESC(bt_ant_diversity, "Enable WLAN/BT RX antenna diversity");
 
 bool is_ath9k_unloaded;
 /* We use the hw_value as an index into our private channel structure */
@@ -633,11 +633,11 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	ath9k_init_platform(sc);
 
 	/*
-	 * Enable Antenna diversity only when BTCOEX is disabled
+	 * Enable WLAN/BT RX Antenna diversity only when BTCOEX is enabled
 	 * and the user manually requests the feature.
 	 */
-	if (!common->btcoex_enabled && ath9k_enable_diversity)
-		common->antenna_diversity = 1;
+	if (common->btcoex_enabled && ath9k_bt_ant_diversity)
+		common->bt_ant_diversity = 1;
 
 	spin_lock_init(&common->cc_lock);
 
-- 
1.8.3.4

