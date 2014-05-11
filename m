Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:62843 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757987AbaEKIFk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 May 2014 04:05:40 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@venema.h4ckr.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 07/10] ath9k: move recv to ath9k_cmn_debug_recv
Date: Sun, 11 May 2014 10:04:37 +0200
Message-Id: <1399795480-7459-8-git-send-email-linux@rempel-privat.de> (sfid-20140511_100604_004639_0BD84BA0)
In-Reply-To: <1399795480-7459-1-git-send-email-linux@rempel-privat.de>
References: <1399795480-7459-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/common-debug.c | 63 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/common-debug.h |  2 +
 drivers/net/wireless/ath/ath9k/debug.c        | 60 ++-----------------------
 3 files changed, 68 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-debug.c b/drivers/net/wireless/ath/ath9k/common-debug.c
index ef538d2..1d4158a 100644
--- a/drivers/net/wireless/ath/ath9k/common-debug.c
+++ b/drivers/net/wireless/ath/ath9k/common-debug.c
@@ -119,3 +119,66 @@ void ath9k_cmn_debug_stat_rx(struct ath_rx_stats *rxstats,
 #undef RX_PHY_ERR_INC
 }
 EXPORT_SYMBOL(ath9k_cmn_debug_stat_rx);
+
+static ssize_t read_file_recv(struct file *file, char __user *user_buf,
+			      size_t count, loff_t *ppos)
+{
+#define RXS_ERR(s, e)					\
+	do {						\
+		len += scnprintf(buf + len, size - len,	\
+				 "%18s : %10u\n", s,	\
+				 rxstats->e);		\
+	} while (0)
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
+	RXS_ERR("PKTS-ALL", rx_pkts_all);
+	RXS_ERR("BYTES-ALL", rx_bytes_all);
+	RXS_ERR("BEACONS", rx_beacons);
+	RXS_ERR("FRAGS", rx_frags);
+	RXS_ERR("SPECTRAL", rx_spectral);
+
+	RXS_ERR("CRC ERR", crc_err);
+	RXS_ERR("DECRYPT CRC ERR", decrypt_crc_err);
+	RXS_ERR("PHY ERR", phy_err);
+	RXS_ERR("MIC ERR", mic_err);
+	RXS_ERR("PRE-DELIM CRC ERR", pre_delim_crc_err);
+	RXS_ERR("POST-DELIM CRC ERR", post_delim_crc_err);
+	RXS_ERR("DECRYPT BUSY ERR", decrypt_busy_err);
+	RXS_ERR("LENGTH-ERR", rx_len_err);
+	RXS_ERR("OOM-ERR", rx_oom_err);
+	RXS_ERR("RATE-ERR", rx_rate_err);
+	RXS_ERR("TOO-MANY-FRAGS", rx_too_many_frags_err);
+
+	if (len > size)
+		len = size;
+
+	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+
+	return retval;
+
+#undef RXS_ERR
+}
+
+static const struct file_operations fops_recv = {
+	.read = read_file_recv,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+void ath9k_cmn_debug_recv(struct dentry *debugfs_phy,
+			  struct ath_rx_stats *rxstats)
+{
+	debugfs_create_file("recv", S_IRUSR, debugfs_phy, rxstats,
+			    &fops_recv);
+}
+EXPORT_SYMBOL(ath9k_cmn_debug_recv);
diff --git a/drivers/net/wireless/ath/ath9k/common-debug.h b/drivers/net/wireless/ath/ath9k/common-debug.h
index 2fcd307..32b89f6 100644
--- a/drivers/net/wireless/ath/ath9k/common-debug.h
+++ b/drivers/net/wireless/ath/ath9k/common-debug.h
@@ -66,3 +66,5 @@ void ath9k_cmn_debug_base_eeprom(struct dentry *debugfs_phy,
 				 struct ath_hw *ah);
 void ath9k_cmn_debug_stat_rx(struct ath_rx_stats *rxstats,
 			     struct ath_rx_status *rs);
+void ath9k_cmn_debug_recv(struct dentry *debugfs_phy,
+			  struct ath_rx_stats *rxstats);
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index be29e71..b96119f 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -948,66 +948,11 @@ static const struct file_operations fops_reset = {
 	.llseek = default_llseek,
 };
 
-static ssize_t read_file_recv(struct file *file, char __user *user_buf,
-			      size_t count, loff_t *ppos)
-{
-#define RXS_ERR(s, e)					    \
-	do {						    \
-		len += scnprintf(buf + len, size - len,	    \
-				 "%18s : %10u\n", s,	    \
-				 sc->debug.stats.rxstats.e);\
-	} while (0)
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
-	RXS_ERR("PKTS-ALL", rx_pkts_all);
-	RXS_ERR("BYTES-ALL", rx_bytes_all);
-	RXS_ERR("BEACONS", rx_beacons);
-	RXS_ERR("FRAGS", rx_frags);
-	RXS_ERR("SPECTRAL", rx_spectral);
-
-	RXS_ERR("CRC ERR", crc_err);
-	RXS_ERR("DECRYPT CRC ERR", decrypt_crc_err);
-	RXS_ERR("PHY ERR", phy_err);
-	RXS_ERR("MIC ERR", mic_err);
-	RXS_ERR("PRE-DELIM CRC ERR", pre_delim_crc_err);
-	RXS_ERR("POST-DELIM CRC ERR", post_delim_crc_err);
-	RXS_ERR("DECRYPT BUSY ERR", decrypt_busy_err);
-	RXS_ERR("LENGTH-ERR", rx_len_err);
-	RXS_ERR("OOM-ERR", rx_oom_err);
-	RXS_ERR("RATE-ERR", rx_rate_err);
-	RXS_ERR("TOO-MANY-FRAGS", rx_too_many_frags_err);
-
-	if (len > size)
-		len = size;
-
-	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
-	kfree(buf);
-
-	return retval;
-
-#undef RXS_ERR
-}
-
 void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
 {
 	ath9k_cmn_debug_stat_rx(&sc->debug.stats.rxstats, rs);
 }
 
-static const struct file_operations fops_recv = {
-	.read = read_file_recv,
-	.open = simple_open,
-	.owner = THIS_MODULE,
-	.llseek = default_llseek,
-};
-
 static ssize_t read_file_phy_err(struct file *file, char __user *user_buf,
 				 size_t count, loff_t *ppos)
 {
@@ -1444,8 +1389,9 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    &fops_misc);
 	debugfs_create_file("reset", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_reset);
-	debugfs_create_file("recv", S_IRUSR, sc->debug.debugfs_phy, sc,
-			    &fops_recv);
+
+	ath9k_cmn_debug_recv(sc->debug.debugfs_phy, &sc->debug.stats.rxstats);
+
 	debugfs_create_file("phy_err", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_phy_err);
 	debugfs_create_u8("rx_chainmask", S_IRUSR, sc->debug.debugfs_phy,
-- 
1.9.1

