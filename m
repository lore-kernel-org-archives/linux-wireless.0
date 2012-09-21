Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42396 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab2IUHCk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 03:02:40 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20572.4308.801973.961874@gargle.gargle.HOWL> (sfid-20120921_090244_042213_598B8A65)
Date: Fri, 21 Sep 2012 12:31:40 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] ath9k: Add a debugfs file to adjust antenna diversity
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Location: /<debugfs>/ieee80211/phy#/ath9k/diversity

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |  2 +-
 drivers/net/wireless/ath/ath9k/debug.c      | 52 +++++++++++++++++++++++++++--
 2 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index fc67844..759f5f5 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1360,7 +1360,7 @@ static void ar9003_hw_antctrl_shared_chain_lnadiv(struct ath_hw *ah,
 	if (enable) {
 		REG_SET_BIT(ah, AR_PHY_MC_GAIN_CTRL,
 			    (1 << AR_PHY_ANT_SW_RX_PROT_S));
-		if (IS_CHAN_2GHZ(ah->curchan))
+		if (ah->curchan && IS_CHAN_2GHZ(ah->curchan))
 			REG_SET_BIT(ah, AR_PHY_RESTART,
 				    AR_PHY_RESTART_ENABLE_DIV_M2FLAG);
 		REG_SET_BIT(ah, AR_BTCOEX_WL_LNADIV,
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index e1041a6..e290d57 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -222,6 +222,54 @@ static const struct file_operations fops_disable_ani = {
 	.llseek = default_llseek,
 };
 
+static ssize_t read_file_ant_diversity(struct file *file, char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	char buf[32];
+	unsigned int len;
+
+	len = sprintf(buf, "%d\n", common->antenna_diversity);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_ant_diversity(struct file *file,
+					const char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	unsigned long antenna_diversity;
+	char buf[32];
+	ssize_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	if (strict_strtoul(buf, 0, &antenna_diversity))
+		return -EINVAL;
+
+	common->antenna_diversity = !!antenna_diversity;
+	ath9k_ps_wakeup(sc);
+	ath_ant_comb_update(sc);
+	ath_dbg(common, CONFIG, "Antenna diversity: %d\n",
+		common->antenna_diversity);
+	ath9k_ps_restore(sc);
+
+	return count;
+}
+
+static const struct file_operations fops_ant_diversity = {
+	.read = read_file_ant_diversity,
+	.write = write_file_ant_diversity,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static ssize_t read_file_dma(struct file *file, char __user *user_buf,
 			     size_t count, loff_t *ppos)
 {
@@ -1601,12 +1649,12 @@ int ath9k_init_debug(struct ath_hw *ah)
 	debugfs_create_file("samples", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_samps);
 #endif
-
 	debugfs_create_u32("gpio_mask", S_IRUSR | S_IWUSR,
 			   sc->debug.debugfs_phy, &sc->sc_ah->gpio_mask);
-
 	debugfs_create_u32("gpio_val", S_IRUSR | S_IWUSR,
 			   sc->debug.debugfs_phy, &sc->sc_ah->gpio_val);
+	debugfs_create_file("diversity", S_IRUSR | S_IWUSR,
+			    sc->debug.debugfs_phy, sc, &fops_ant_diversity);
 
 	return 0;
 }
-- 
1.7.12

