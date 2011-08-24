Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30463 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab1HXStT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 14:49:19 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <ath9k-devel@lists.ath9k.org>
CC: <linux-wireless@vger.kernel.org>, <rodrigue@qca.qualcomm.com>,
	<senthilb@qca.qualcomm.com>, <rmanohar@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC] ath9k: Add a debug entry for current tx-power
Date: Thu, 25 Aug 2011 00:18:52 +0530
Message-ID: <1314211732-27218-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20110824_204922_844052_08D8868B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

this is the tx-power that seems to be used by the hardware code

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |   43 ++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 9bec3b8..982371f 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -176,6 +176,47 @@ static const struct file_operations fops_rx_chainmask = {
 	.llseek = default_llseek,
 };
 
+static ssize_t read_file_current_txpower(struct file *file,
+					 char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	char buf[32];
+	unsigned int len;
+
+	len = sprintf(buf, "%u\n", sc->curtxpow);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_current_txpower(struct file *file,
+					  const char __user *user_buf,
+					  size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	unsigned long current_tx_power;
+	char buf[32];
+	ssize_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	if (strict_strtoul(buf, 0, &current_tx_power))
+		return -EINVAL;
+
+	sc->curtxpow = current_tx_power;
+	return count;
+}
+
+static const struct file_operations fops_current_txpower = {
+	.read = read_file_current_txpower,
+	.write = write_file_current_txpower,
+	.open = ath9k_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static ssize_t read_file_disable_ani(struct file *file, char __user *user_buf,
 			     size_t count, loff_t *ppos)
 {
@@ -1253,6 +1294,8 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    sc->debug.debugfs_phy, sc, &fops_tx_chainmask);
 	debugfs_create_file("disable_ani", S_IRUSR | S_IWUSR,
 			    sc->debug.debugfs_phy, sc, &fops_disable_ani);
+	debugfs_create_file("current_txpower", S_IRUSR | S_IWUSR,
+			    sc->debug.debugfs_phy, sc, &fops_current_txpower);
 	debugfs_create_file("regidx", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
 			    sc, &fops_regidx);
 	debugfs_create_file("regval", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
-- 
1.7.0.4

