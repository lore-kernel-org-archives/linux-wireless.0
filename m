Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:52037 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab3FCDwZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Jun 2013 23:52:25 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 6/7] ath9k: Print ANI statistics in debugfs
Date: Mon,  3 Jun 2013 09:19:28 +0530
Message-Id: <1370231369-16241-6-git-send-email-sujith@msujith.org> (sfid-20130603_055229_201477_0BB16FDE)
In-Reply-To: <1370231369-16241-1-git-send-email-sujith@msujith.org>
References: <1370231369-16241-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ani.h   |  2 -
 drivers/net/wireless/ath/ath9k/debug.c | 81 +++++++++++++++++++++++++++-------
 2 files changed, 64 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.h b/drivers/net/wireless/ath/ath9k/ani.h
index c585e05..78b9fa9 100644
--- a/drivers/net/wireless/ath/ath9k/ani.h
+++ b/drivers/net/wireless/ath/ath9k/ani.h
@@ -111,8 +111,6 @@ struct ar5416AniState {
 };
 
 struct ar5416Stats {
-	u32 ast_ani_niup;
-	u32 ast_ani_nidown;
 	u32 ast_ani_spurup;
 	u32 ast_ani_spurdown;
 	u32 ast_ani_ofdmon;
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 53c0658..2721f52 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -173,25 +173,69 @@ static const struct file_operations fops_rx_chainmask = {
 	.llseek = default_llseek,
 };
 
-static ssize_t read_file_disable_ani(struct file *file, char __user *user_buf,
+static ssize_t read_file_ani(struct file *file, char __user *user_buf,
 			     size_t count, loff_t *ppos)
 {
 	struct ath_softc *sc = file->private_data;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	char buf[32];
-	unsigned int len;
+	struct ath_hw *ah = sc->sc_ah;
+	unsigned int len = 0, size = 1024;
+	ssize_t retval = 0;
+	char *buf;
 
-	len = sprintf(buf, "%d\n", common->disable_ani);
-	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	buf = kzalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	if (common->disable_ani) {
+		len += snprintf(buf + len, size - len, "%s: %s\n",
+				"ANI", "DISABLED");
+		goto exit;
+	}
+
+	len += snprintf(buf + len, size - len, "%15s: %s\n",
+			"ANI", "ENABLED");
+	len += snprintf(buf + len, size - len, "%15s: %u\n",
+			"ANI RESET", ah->stats.ast_ani_reset);
+	len += snprintf(buf + len, size - len, "%15s: %u\n",
+			"SPUR UP", ah->stats.ast_ani_spurup);
+	len += snprintf(buf + len, size - len, "%15s: %u\n",
+			"SPUR DOWN", ah->stats.ast_ani_spurup);
+	len += snprintf(buf + len, size - len, "%15s: %u\n",
+			"OFDM WS-DET ON", ah->stats.ast_ani_ofdmon);
+	len += snprintf(buf + len, size - len, "%15s: %u\n",
+			"OFDM WS-DET OFF", ah->stats.ast_ani_ofdmoff);
+	len += snprintf(buf + len, size - len, "%15s: %u\n",
+			"MRC-CCK ON", ah->stats.ast_ani_ccklow);
+	len += snprintf(buf + len, size - len, "%15s: %u\n",
+			"MRC-CCK OFF", ah->stats.ast_ani_cckhigh);
+	len += snprintf(buf + len, size - len, "%15s: %u\n",
+			"FIR-STEP UP", ah->stats.ast_ani_stepup);
+	len += snprintf(buf + len, size - len, "%15s: %u\n",
+			"FIR-STEP DOWN", ah->stats.ast_ani_stepdown);
+	len += snprintf(buf + len, size - len, "%15s: %u\n",
+			"INV LISTENTIME", ah->stats.ast_ani_lneg_or_lzero);
+	len += snprintf(buf + len, size - len, "%15s: %u\n",
+			"OFDM ERRORS", ah->stats.ast_ani_ofdmerrs);
+	len += snprintf(buf + len, size - len, "%15s: %u\n",
+			"CCK ERRORS", ah->stats.ast_ani_cckerrs);
+exit:
+	if (len > size)
+		len = size;
+
+	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+
+	return retval;
 }
 
-static ssize_t write_file_disable_ani(struct file *file,
-				      const char __user *user_buf,
-				      size_t count, loff_t *ppos)
+static ssize_t write_file_ani(struct file *file,
+			      const char __user *user_buf,
+			      size_t count, loff_t *ppos)
 {
 	struct ath_softc *sc = file->private_data;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	unsigned long disable_ani;
+	unsigned long ani;
 	char buf[32];
 	ssize_t len;
 
@@ -200,12 +244,15 @@ static ssize_t write_file_disable_ani(struct file *file,
 		return -EFAULT;
 
 	buf[len] = '\0';
-	if (strict_strtoul(buf, 0, &disable_ani))
+	if (strict_strtoul(buf, 0, &ani))
+		return -EINVAL;
+
+	if (ani < 0 || ani > 1)
 		return -EINVAL;
 
-	common->disable_ani = !!disable_ani;
+	common->disable_ani = !ani;
 
-	if (disable_ani) {
+	if (common->disable_ani) {
 		clear_bit(SC_OP_ANI_RUN, &sc->sc_flags);
 		ath_stop_ani(sc);
 	} else {
@@ -215,9 +262,9 @@ static ssize_t write_file_disable_ani(struct file *file,
 	return count;
 }
 
-static const struct file_operations fops_disable_ani = {
-	.read = read_file_disable_ani,
-	.write = write_file_disable_ani,
+static const struct file_operations fops_ani = {
+	.read = read_file_ani,
+	.write = write_file_ani,
 	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
@@ -1727,8 +1774,8 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    sc->debug.debugfs_phy, sc, &fops_rx_chainmask);
 	debugfs_create_file("tx_chainmask", S_IRUSR | S_IWUSR,
 			    sc->debug.debugfs_phy, sc, &fops_tx_chainmask);
-	debugfs_create_file("disable_ani", S_IRUSR | S_IWUSR,
-			    sc->debug.debugfs_phy, sc, &fops_disable_ani);
+	debugfs_create_file("ani", S_IRUSR | S_IWUSR,
+			    sc->debug.debugfs_phy, sc, &fops_ani);
 	debugfs_create_bool("paprd", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
 			    &sc->sc_ah->config.enable_paprd);
 	debugfs_create_file("regidx", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
-- 
1.8.3

