Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:59719 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757829AbaEKIFV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 May 2014 04:05:21 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@venema.h4ckr.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 09/10] ath9k: move phy_err to ath9k_cmn_debug_phy_err
Date: Sun, 11 May 2014 10:04:39 +0200
Message-Id: <1399795480-7459-10-git-send-email-linux@rempel-privat.de> (sfid-20140511_100539_207461_DF02A251)
In-Reply-To: <1399795480-7459-1-git-send-email-linux@rempel-privat.de>
References: <1399795480-7459-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/common-debug.c | 69 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/common-debug.h |  2 +
 drivers/net/wireless/ath/ath9k/debug.c        | 64 +------------------------
 3 files changed, 72 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-debug.c b/drivers/net/wireless/ath/ath9k/common-debug.c
index 1d4158a..3b289f9 100644
--- a/drivers/net/wireless/ath/ath9k/common-debug.c
+++ b/drivers/net/wireless/ath/ath9k/common-debug.c
@@ -182,3 +182,72 @@ void ath9k_cmn_debug_recv(struct dentry *debugfs_phy,
 			    &fops_recv);
 }
 EXPORT_SYMBOL(ath9k_cmn_debug_recv);
+
+static ssize_t read_file_phy_err(struct file *file, char __user *user_buf,
+				 size_t count, loff_t *ppos)
+{
+#define PHY_ERR(s, p) \
+	len += scnprintf(buf + len, size - len, "%22s : %10u\n", s, \
+			 rxstats->phy_err_stats[p]);
+
+	struct ath_rx_stats *rxstats = file->private_data;
+	char *buf;
+	unsigned int len = 0, size = 1600;
+	ssize_t retval = 0;
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	PHY_ERR("UNDERRUN ERR", ATH9K_PHYERR_UNDERRUN);
+	PHY_ERR("TIMING ERR", ATH9K_PHYERR_TIMING);
+	PHY_ERR("PARITY ERR", ATH9K_PHYERR_PARITY);
+	PHY_ERR("RATE ERR", ATH9K_PHYERR_RATE);
+	PHY_ERR("LENGTH ERR", ATH9K_PHYERR_LENGTH);
+	PHY_ERR("RADAR ERR", ATH9K_PHYERR_RADAR);
+	PHY_ERR("SERVICE ERR", ATH9K_PHYERR_SERVICE);
+	PHY_ERR("TOR ERR", ATH9K_PHYERR_TOR);
+	PHY_ERR("OFDM-TIMING ERR", ATH9K_PHYERR_OFDM_TIMING);
+	PHY_ERR("OFDM-SIGNAL-PARITY ERR", ATH9K_PHYERR_OFDM_SIGNAL_PARITY);
+	PHY_ERR("OFDM-RATE ERR", ATH9K_PHYERR_OFDM_RATE_ILLEGAL);
+	PHY_ERR("OFDM-LENGTH ERR", ATH9K_PHYERR_OFDM_LENGTH_ILLEGAL);
+	PHY_ERR("OFDM-POWER-DROP ERR", ATH9K_PHYERR_OFDM_POWER_DROP);
+	PHY_ERR("OFDM-SERVICE ERR", ATH9K_PHYERR_OFDM_SERVICE);
+	PHY_ERR("OFDM-RESTART ERR", ATH9K_PHYERR_OFDM_RESTART);
+	PHY_ERR("FALSE-RADAR-EXT ERR", ATH9K_PHYERR_FALSE_RADAR_EXT);
+	PHY_ERR("CCK-TIMING ERR", ATH9K_PHYERR_CCK_TIMING);
+	PHY_ERR("CCK-HEADER-CRC ERR", ATH9K_PHYERR_CCK_HEADER_CRC);
+	PHY_ERR("CCK-RATE ERR", ATH9K_PHYERR_CCK_RATE_ILLEGAL);
+	PHY_ERR("CCK-SERVICE ERR", ATH9K_PHYERR_CCK_SERVICE);
+	PHY_ERR("CCK-RESTART ERR", ATH9K_PHYERR_CCK_RESTART);
+	PHY_ERR("CCK-LENGTH ERR", ATH9K_PHYERR_CCK_LENGTH_ILLEGAL);
+	PHY_ERR("CCK-POWER-DROP ERR", ATH9K_PHYERR_CCK_POWER_DROP);
+	PHY_ERR("HT-CRC ERR", ATH9K_PHYERR_HT_CRC_ERROR);
+	PHY_ERR("HT-LENGTH ERR", ATH9K_PHYERR_HT_LENGTH_ILLEGAL);
+	PHY_ERR("HT-RATE ERR", ATH9K_PHYERR_HT_RATE_ILLEGAL);
+
+	if (len > size)
+		len = size;
+
+	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+
+	return retval;
+
+#undef PHY_ERR
+}
+
+static const struct file_operations fops_phy_err = {
+	.read = read_file_phy_err,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+void ath9k_cmn_debug_phy_err(struct dentry *debugfs_phy,
+			     struct ath_rx_stats *rxstats)
+{
+	debugfs_create_file("phy_err", S_IRUSR, debugfs_phy, rxstats,
+			    &fops_phy_err);
+}
+EXPORT_SYMBOL(ath9k_cmn_debug_phy_err);
diff --git a/drivers/net/wireless/ath/ath9k/common-debug.h b/drivers/net/wireless/ath/ath9k/common-debug.h
index 32b89f6..7c97884 100644
--- a/drivers/net/wireless/ath/ath9k/common-debug.h
+++ b/drivers/net/wireless/ath/ath9k/common-debug.h
@@ -68,3 +68,5 @@ void ath9k_cmn_debug_stat_rx(struct ath_rx_stats *rxstats,
 			     struct ath_rx_status *rs);
 void ath9k_cmn_debug_recv(struct dentry *debugfs_phy,
 			  struct ath_rx_stats *rxstats);
+void ath9k_cmn_debug_phy_err(struct dentry *debugfs_phy,
+			     struct ath_rx_stats *rxstats);
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index b96119f..6cc42be 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -953,67 +953,6 @@ void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
 	ath9k_cmn_debug_stat_rx(&sc->debug.stats.rxstats, rs);
 }
 
-static ssize_t read_file_phy_err(struct file *file, char __user *user_buf,
-				 size_t count, loff_t *ppos)
-{
-#define PHY_ERR(s, p) \
-	len += scnprintf(buf + len, size - len, "%22s : %10u\n", s, \
-			 sc->debug.stats.rxstats.phy_err_stats[p]);
-
-	struct ath_softc *sc = file->private_data;
-	char *buf;
-	unsigned int len = 0, size = 1600;
-	ssize_t retval = 0;
-
-	buf = kzalloc(size, GFP_KERNEL);
-	if (buf == NULL)
-		return -ENOMEM;
-
-	PHY_ERR("UNDERRUN ERR", ATH9K_PHYERR_UNDERRUN);
-	PHY_ERR("TIMING ERR", ATH9K_PHYERR_TIMING);
-	PHY_ERR("PARITY ERR", ATH9K_PHYERR_PARITY);
-	PHY_ERR("RATE ERR", ATH9K_PHYERR_RATE);
-	PHY_ERR("LENGTH ERR", ATH9K_PHYERR_LENGTH);
-	PHY_ERR("RADAR ERR", ATH9K_PHYERR_RADAR);
-	PHY_ERR("SERVICE ERR", ATH9K_PHYERR_SERVICE);
-	PHY_ERR("TOR ERR", ATH9K_PHYERR_TOR);
-	PHY_ERR("OFDM-TIMING ERR", ATH9K_PHYERR_OFDM_TIMING);
-	PHY_ERR("OFDM-SIGNAL-PARITY ERR", ATH9K_PHYERR_OFDM_SIGNAL_PARITY);
-	PHY_ERR("OFDM-RATE ERR", ATH9K_PHYERR_OFDM_RATE_ILLEGAL);
-	PHY_ERR("OFDM-LENGTH ERR", ATH9K_PHYERR_OFDM_LENGTH_ILLEGAL);
-	PHY_ERR("OFDM-POWER-DROP ERR", ATH9K_PHYERR_OFDM_POWER_DROP);
-	PHY_ERR("OFDM-SERVICE ERR", ATH9K_PHYERR_OFDM_SERVICE);
-	PHY_ERR("OFDM-RESTART ERR", ATH9K_PHYERR_OFDM_RESTART);
-	PHY_ERR("FALSE-RADAR-EXT ERR", ATH9K_PHYERR_FALSE_RADAR_EXT);
-	PHY_ERR("CCK-TIMING ERR", ATH9K_PHYERR_CCK_TIMING);
-	PHY_ERR("CCK-HEADER-CRC ERR", ATH9K_PHYERR_CCK_HEADER_CRC);
-	PHY_ERR("CCK-RATE ERR", ATH9K_PHYERR_CCK_RATE_ILLEGAL);
-	PHY_ERR("CCK-SERVICE ERR", ATH9K_PHYERR_CCK_SERVICE);
-	PHY_ERR("CCK-RESTART ERR", ATH9K_PHYERR_CCK_RESTART);
-	PHY_ERR("CCK-LENGTH ERR", ATH9K_PHYERR_CCK_LENGTH_ILLEGAL);
-	PHY_ERR("CCK-POWER-DROP ERR", ATH9K_PHYERR_CCK_POWER_DROP);
-	PHY_ERR("HT-CRC ERR", ATH9K_PHYERR_HT_CRC_ERROR);
-	PHY_ERR("HT-LENGTH ERR", ATH9K_PHYERR_HT_LENGTH_ILLEGAL);
-	PHY_ERR("HT-RATE ERR", ATH9K_PHYERR_HT_RATE_ILLEGAL);
-
-	if (len > size)
-		len = size;
-
-	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
-	kfree(buf);
-
-	return retval;
-
-#undef PHY_ERR
-}
-
-static const struct file_operations fops_phy_err = {
-	.read = read_file_phy_err,
-	.open = simple_open,
-	.owner = THIS_MODULE,
-	.llseek = default_llseek,
-};
-
 static ssize_t read_file_regidx(struct file *file, char __user *user_buf,
                                 size_t count, loff_t *ppos)
 {
@@ -1391,9 +1330,8 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    &fops_reset);
 
 	ath9k_cmn_debug_recv(sc->debug.debugfs_phy, &sc->debug.stats.rxstats);
+	ath9k_cmn_debug_phy_err(sc->debug.debugfs_phy, &sc->debug.stats.rxstats);
 
-	debugfs_create_file("phy_err", S_IRUSR, sc->debug.debugfs_phy, sc,
-			    &fops_phy_err);
 	debugfs_create_u8("rx_chainmask", S_IRUSR, sc->debug.debugfs_phy,
 			  &ah->rxchainmask);
 	debugfs_create_u8("tx_chainmask", S_IRUSR, sc->debug.debugfs_phy,
-- 
1.9.1

