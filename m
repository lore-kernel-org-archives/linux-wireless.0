Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:34318 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab3G2KiS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jul 2013 06:38:18 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Add a debugfs file for antenna diversity
Date: Mon, 29 Jul 2013 16:04:49 +0530
Message-Id: <1375094089-13501-1-git-send-email-sujith@msujith.org> (sfid-20130729_123839_010881_63B77AE2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/antenna.c | 10 ++++-
 drivers/net/wireless/ath/ath9k/ath9k.h   |  2 +-
 drivers/net/wireless/ath/ath9k/debug.c   | 64 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/debug.h   | 13 +++++++
 4 files changed, 86 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/antenna.c b/drivers/net/wireless/ath/ath9k/antenna.c
index 6560dcb..2785dc3 100644
--- a/drivers/net/wireless/ath/ath9k/antenna.c
+++ b/drivers/net/wireless/ath/ath9k/antenna.c
@@ -600,10 +600,16 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs)
 		antcomb->total_pkt_count++;
 		antcomb->main_total_rssi += main_rssi;
 		antcomb->alt_total_rssi  += alt_rssi;
-		if (main_ant_conf == rx_ant_conf)
+
+		if (main_ant_conf == rx_ant_conf) {
 			antcomb->main_recv_cnt++;
-		else
+			ANT_STAT_INC(ANT_MAIN, recv_cnt);
+			ANT_LNA_INC(ANT_MAIN, rx_ant_conf);
+		} else {
 			antcomb->alt_recv_cnt++;
+			ANT_STAT_INC(ANT_ALT, recv_cnt);
+			ANT_LNA_INC(ANT_ALT, rx_ant_conf);
+		}
 	}
 
 	/* Short scan check */
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 2992fd0..2d7e26d 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -609,7 +609,7 @@ struct ath_ant_comb {
 	int rssi_third;
 	bool alt_good;
 	int quick_scan_cnt;
-	int main_conf;
+	enum ath9k_ant_div_comb_lna_conf main_conf;
 	enum ath9k_ant_div_comb_lna_conf first_quick_scan_conf;
 	enum ath9k_ant_div_comb_lna_conf second_quick_scan_conf;
 	bool first_ratio;
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 5639c5b..56cbe5d 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -321,6 +321,68 @@ static const struct file_operations fops_bt_ant_diversity = {
 	.llseek = default_llseek,
 };
 
+static ssize_t read_file_antenna_diversity(struct file *file,
+					   char __user *user_buf,
+					   size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
+	struct ath_antenna_stats *as_main = &sc->debug.stats.ant_stats[ANT_MAIN];
+	struct ath_antenna_stats *as_alt = &sc->debug.stats.ant_stats[ANT_ALT];
+	unsigned int len = 0, size = 1024;
+	ssize_t retval = 0;
+	char *buf;
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	if (!(pCap->hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB)) {
+		len += snprintf(buf + len, size - len, "%s\n",
+				"Antenna Diversity Combining is disabled");
+		goto exit;
+	}
+
+	len += snprintf(buf + len, size - len, "%30s%15s\n",
+			"MAIN", "ALT");
+	len += snprintf(buf + len, size - len, "%-15s%15d%15d\n",
+			"RECV CNT",
+			as_main->recv_cnt,
+			as_alt->recv_cnt);
+	len += snprintf(buf + len, size - len, "%-15s%15d%15d\n",
+			"LNA1",
+			as_main->lna_config_cnt[ATH_ANT_DIV_COMB_LNA1],
+			as_alt->lna_config_cnt[ATH_ANT_DIV_COMB_LNA1]);
+	len += snprintf(buf + len, size - len, "%-15s%15d%15d\n",
+			"LNA2",
+			as_main->lna_config_cnt[ATH_ANT_DIV_COMB_LNA2],
+			as_alt->lna_config_cnt[ATH_ANT_DIV_COMB_LNA2]);
+	len += snprintf(buf + len, size - len, "%-15s%15d%15d\n",
+			"LNA1 + LNA2",
+			as_main->lna_config_cnt[ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2],
+			as_alt->lna_config_cnt[ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2]);
+	len += snprintf(buf + len, size - len, "%-15s%15d%15d\n",
+			"LNA1 - LNA2",
+			as_main->lna_config_cnt[ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2],
+			as_alt->lna_config_cnt[ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2]);
+exit:
+	if (len > size)
+		len = size;
+
+	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+
+	return retval;
+}
+
+static const struct file_operations fops_antenna_diversity = {
+	.read = read_file_antenna_diversity,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static ssize_t read_file_dma(struct file *file, char __user *user_buf,
 			     size_t count, loff_t *ppos)
 {
@@ -1816,6 +1878,8 @@ int ath9k_init_debug(struct ath_hw *ah)
 			   sc->debug.debugfs_phy, &sc->sc_ah->gpio_val);
 	debugfs_create_file("bt_ant_diversity", S_IRUSR | S_IWUSR,
 			    sc->debug.debugfs_phy, sc, &fops_bt_ant_diversity);
+	debugfs_create_file("antenna_diversity", S_IRUSR,
+			    sc->debug.debugfs_phy, sc, &fops_antenna_diversity);
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 	debugfs_create_file("btcoex", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_btcoex);
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index fc67919..a879e45 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -28,9 +28,13 @@ struct fft_sample_tlv;
 #ifdef CONFIG_ATH9K_DEBUGFS
 #define TX_STAT_INC(q, c) sc->debug.stats.txstats[q].c++
 #define RESET_STAT_INC(sc, type) sc->debug.stats.reset[type]++
+#define ANT_STAT_INC(i, c) sc->debug.stats.ant_stats[i].c++
+#define ANT_LNA_INC(i, c) sc->debug.stats.ant_stats[i].lna_config_cnt[c]++;
 #else
 #define TX_STAT_INC(q, c) do { } while (0)
 #define RESET_STAT_INC(sc, type) do { } while (0)
+#define ANT_STAT_INC(i, c) do { } while (0)
+#define ANT_LNA_INC(i, c) do { } while (0)
 #endif
 
 enum ath_reset_type {
@@ -243,11 +247,20 @@ struct ath_rx_stats {
 	u32 rx_spectral;
 };
 
+#define ANT_MAIN 0
+#define ANT_ALT  1
+
+struct ath_antenna_stats {
+	u32 recv_cnt;
+	u32 lna_config_cnt[4];
+};
+
 struct ath_stats {
 	struct ath_interrupt_stats istats;
 	struct ath_tx_stats txstats[ATH9K_NUM_TX_QUEUES];
 	struct ath_rx_stats rxstats;
 	struct ath_dfs_stats dfs_stats;
+	struct ath_antenna_stats ant_stats[2];
 	u32 reset[__RESET_TYPE_MAX];
 };
 
-- 
1.8.3.4

