Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:47560 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab0EKPXM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 11:23:12 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, linville@tuxdriver.com
Subject: [PATCH 3/4] ath9k: add debugfs files for reading/writing registers
Date: Tue, 11 May 2010 17:23:02 +0200
Message-Id: <1273591383-76696-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1273591383-76696-2-git-send-email-nbd@openwrt.org>
References: <1273591383-76696-1-git-send-email-nbd@openwrt.org>
 <1273591383-76696-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/debug.c |   89 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/debug.h |    1 +
 2 files changed, 90 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 8d7c046..29898f8 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -795,6 +795,86 @@ static const struct file_operations fops_recv = {
 	.owner = THIS_MODULE
 };
 
+static ssize_t read_file_regidx(struct file *file, char __user *user_buf,
+                                size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	char buf[32];
+	unsigned int len;
+
+	len = snprintf(buf, sizeof(buf), "0x%08x\n", sc->debug.regidx);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_regidx(struct file *file, const char __user *user_buf,
+			     size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	unsigned long regidx;
+	char buf[32];
+	ssize_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EINVAL;
+
+	buf[len] = '\0';
+	if (strict_strtoul(buf, 0, &regidx))
+		return -EINVAL;
+
+	sc->debug.regidx = regidx;
+	return count;
+}
+
+static const struct file_operations fops_regidx = {
+	.read = read_file_regidx,
+	.write = write_file_regidx,
+	.open = ath9k_debugfs_open,
+	.owner = THIS_MODULE
+};
+
+static ssize_t read_file_regval(struct file *file, char __user *user_buf,
+			     size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	struct ath_hw *ah = sc->sc_ah;
+	char buf[32];
+	unsigned int len;
+	u32 regval;
+
+	regval = REG_READ_D(ah, sc->debug.regidx);
+	len = snprintf(buf, sizeof(buf), "0x%08x\n", regval);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_regval(struct file *file, const char __user *user_buf,
+			     size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	struct ath_hw *ah = sc->sc_ah;
+	unsigned long regval;
+	char buf[32];
+	ssize_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EINVAL;
+
+	buf[len] = '\0';
+	if (strict_strtoul(buf, 0, &regval))
+		return -EINVAL;
+
+	REG_WRITE_D(ah, sc->debug.regidx, regval);
+	return count;
+}
+
+static const struct file_operations fops_regval = {
+	.read = read_file_regval,
+	.write = write_file_regval,
+	.open = ath9k_debugfs_open,
+	.owner = THIS_MODULE
+};
+
 int ath9k_init_debug(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -846,6 +926,15 @@ int ath9k_init_debug(struct ath_hw *ah)
 			sc->debug.debugfs_phy, sc, &fops_tx_chainmask))
 		goto err;
 
+	if (!debugfs_create_file("regidx", S_IRUSR | S_IWUSR,
+			sc->debug.debugfs_phy, sc, &fops_regidx))
+		goto err;
+
+	if (!debugfs_create_file("regval", S_IRUSR | S_IWUSR,
+			sc->debug.debugfs_phy, sc, &fops_regval))
+		goto err;
+
+	sc->debug.regidx = 0;
 	return 0;
 err:
 	ath9k_exit_debug(ah);
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 7314360..5147b87 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -153,6 +153,7 @@ struct ath_stats {
 
 struct ath9k_debug {
 	struct dentry *debugfs_phy;
+	u32 regidx;
 	struct ath_stats stats;
 };
 
-- 
1.6.4.2

