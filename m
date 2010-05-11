Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:47562 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab0EKPXM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 11:23:12 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, linville@tuxdriver.com
Subject: [PATCH 2/4] ath9k: add debugfs files for reading/writing the rx and tx chainmask
Date: Tue, 11 May 2010 17:23:01 +0200
Message-Id: <1273591383-76696-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1273591383-76696-1-git-send-email-nbd@openwrt.org>
References: <1273591383-76696-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/debug.c |   92 ++++++++++++++++++++++++++++++++
 1 files changed, 92 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 679257c..8d7c046 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -78,6 +78,90 @@ static const struct file_operations fops_debug = {
 
 #define DMA_BUF_LEN 1024
 
+static ssize_t read_file_tx_chainmask(struct file *file, char __user *user_buf,
+			     size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	char buf[32];
+	unsigned int len;
+
+	len = snprintf(buf, sizeof(buf), "0x%08x\n", common->tx_chainmask);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_tx_chainmask(struct file *file, const char __user *user_buf,
+			     size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	unsigned long mask;
+	char buf[32];
+	ssize_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EINVAL;
+
+	buf[len] = '\0';
+	if (strict_strtoul(buf, 0, &mask))
+		return -EINVAL;
+
+	common->tx_chainmask = mask;
+	sc->sc_ah->caps.tx_chainmask = mask;
+	return count;
+}
+
+static const struct file_operations fops_tx_chainmask = {
+	.read = read_file_tx_chainmask,
+	.write = write_file_tx_chainmask,
+	.open = ath9k_debugfs_open,
+	.owner = THIS_MODULE
+};
+
+
+static ssize_t read_file_rx_chainmask(struct file *file, char __user *user_buf,
+			     size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	char buf[32];
+	unsigned int len;
+
+	len = snprintf(buf, sizeof(buf), "0x%08x\n", common->rx_chainmask);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_rx_chainmask(struct file *file, const char __user *user_buf,
+			     size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	unsigned long mask;
+	char buf[32];
+	ssize_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EINVAL;
+
+	buf[len] = '\0';
+	if (strict_strtoul(buf, 0, &mask))
+		return -EINVAL;
+
+	common->rx_chainmask = mask;
+	sc->sc_ah->caps.rx_chainmask = mask;
+	return count;
+}
+
+static const struct file_operations fops_rx_chainmask = {
+	.read = read_file_rx_chainmask,
+	.write = write_file_rx_chainmask,
+	.open = ath9k_debugfs_open,
+	.owner = THIS_MODULE
+};
+
+
 static ssize_t read_file_dma(struct file *file, char __user *user_buf,
 			     size_t count, loff_t *ppos)
 {
@@ -754,6 +838,14 @@ int ath9k_init_debug(struct ath_hw *ah)
 			sc, &fops_recv))
 		goto err;
 
+	if (!debugfs_create_file("rx_chainmask", S_IRUSR | S_IWUSR,
+			sc->debug.debugfs_phy, sc, &fops_rx_chainmask))
+		goto err;
+
+	if (!debugfs_create_file("tx_chainmask", S_IRUSR | S_IWUSR,
+			sc->debug.debugfs_phy, sc, &fops_tx_chainmask))
+		goto err;
+
 	return 0;
 err:
 	ath9k_exit_debug(ah);
-- 
1.6.4.2

