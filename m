Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:51334 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300Ab1JCKaM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 06:30:12 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: kgiori@qca.qualcomm.com, rodrigue@qca.qualcomm.com,
	nbd@openwrt.org, Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [RFC 1/6] ath9k: add DFS statistics to debugfs
Date: Mon,  3 Oct 2011 12:29:13 +0200
Message-Id: <1317637758-11907-2-git-send-email-zefir.kurtisi@neratec.com> (sfid-20111003_123020_812075_0650122A)
In-Reply-To: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |   51 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/debug.h |   29 ++++++++++++++++++
 2 files changed, 80 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index cdece82..6ad2266 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -89,6 +89,53 @@ static const struct file_operations fops_debug = {
 
 #endif
 
+
+#ifdef CONFIG_ATH9K_DFS
+
+#define DFS_STAT(s, p) \
+	len += snprintf(buf + len, size - len, "%28s : %10u\n", s, \
+			sc->debug.stats.dfs_stats.p);
+
+static ssize_t read_file_dfs(struct file *file, char __user *user_buf,
+			     size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	char *buf;
+	unsigned int len = 0, size = 8000;
+	ssize_t retval = 0;
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	DFS_STAT("DFS pulses detected     ", pulses_detected);
+	DFS_STAT("Datalen discards        ", datalen_discards);
+	DFS_STAT("RSSI discards           ", rssi_discards);
+	DFS_STAT("BW info discards        ", bwinfo_discards);
+	DFS_STAT("Primary channel pulses  ", pri_phy_errors);
+	DFS_STAT("Secondary channel pulses", ext_phy_errors);
+	DFS_STAT("Dual channel pulses     ", dc_phy_errors);
+
+	if (len > size)
+		len = size;
+
+	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+
+	return retval;
+}
+
+
+static const struct file_operations fops_dfs_stats = {
+	.read = read_file_dfs,
+	.open = ath9k_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+#endif /* CONFIG_ATH9K_DFS */
+
+
+
 #define DMA_BUF_LEN 1024
 
 static ssize_t read_file_tx_chainmask(struct file *file, char __user *user_buf,
@@ -1385,6 +1432,10 @@ int ath9k_init_debug(struct ath_hw *ah)
 	debugfs_create_u32("chanbw", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
 			   &sc->chan_bw);
 
+#ifdef CONFIG_ATH9K_DFS
+	debugfs_create_file("dfs_stats", S_IRUSR, sc->debug.debugfs_phy, sc,
+			    &fops_dfs_stats);
+#endif
 	sc->debug.regidx = 0;
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 4a04510..3a3c3b7 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -25,8 +25,10 @@ struct ath_buf;
 
 #ifdef CONFIG_ATH9K_DEBUGFS
 #define TX_STAT_INC(q, c) sc->debug.stats.txstats[q].c++
+#define DFS_STAT_INC(sc, c) (sc->debug.stats.dfs_stats.c++)
 #else
 #define TX_STAT_INC(q, c) do { } while (0)
+#define DFS_STAT_INC(sc, c) do { } while (0)
 #endif
 
 #ifdef CONFIG_ATH9K_DEBUGFS
@@ -171,10 +173,37 @@ struct ath_rx_stats {
 	u8 rs_antenna;
 };
 
+#ifdef CONFIG_ATH9K_DFS
+/**
+ * struct ath_dfs_stats - DFS Statistics
+ *
+ * @pulses_detected: No. of pulses detected so far
+ * @datalen_discards:  No. of pulses discarded due to invalid datalen
+ * @rssi_discards: No. of pulses discarded due to invalid RSSI
+ * @bwinfo_discards: No. of pulses discarded due to invalid BW info
+ * @pri_phy_errors: No. of pulses reported for primary channel
+ * @ext_phy_errors: No. of pulses reported for extension channel
+ * @dc_phy_errors: No. of pulses reported for primary + extension channel
+ */
+struct ath_dfs_stats {
+	u32 pulses_detected;
+	u32 datalen_discards;
+	u32 rssi_discards;
+	u32 bwinfo_discards;
+	u32 pri_phy_errors;
+	u32 ext_phy_errors;
+	u32 dc_phy_errors;
+};
+#endif
+
+
 struct ath_stats {
 	struct ath_interrupt_stats istats;
 	struct ath_tx_stats txstats[ATH9K_NUM_TX_QUEUES];
 	struct ath_rx_stats rxstats;
+#ifdef CONFIG_ATH9K_DFS
+	struct ath_dfs_stats dfs_stats;
+#endif
 };
 
 struct ath9k_debug {
-- 
1.7.4.1

