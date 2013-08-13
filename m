Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41180 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757075Ab3HMKdi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 06:33:38 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 2/5] ath9k: simplify debugfs chainmask handling
Date: Tue, 13 Aug 2013 12:33:27 +0200
Message-Id: <1376390010-81819-2-git-send-email-nbd@openwrt.org> (sfid-20130813_123347_207011_F4339761)
In-Reply-To: <1376390010-81819-1-git-send-email-nbd@openwrt.org>
References: <1376390010-81819-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Writing to that file is unnecessary and quirky, the antenna API should
be used instead. Use debugfs_create_u8 to allow reading the values.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/debug.c | 92 ++--------------------------------
 1 file changed, 4 insertions(+), 88 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index e5c8333..c088744 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -88,90 +88,6 @@ static const struct file_operations fops_debug = {
 
 #define DMA_BUF_LEN 1024
 
-static ssize_t read_file_tx_chainmask(struct file *file, char __user *user_buf,
-			     size_t count, loff_t *ppos)
-{
-	struct ath_softc *sc = file->private_data;
-	struct ath_hw *ah = sc->sc_ah;
-	char buf[32];
-	unsigned int len;
-
-	len = sprintf(buf, "0x%08x\n", ah->txchainmask);
-	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
-}
-
-static ssize_t write_file_tx_chainmask(struct file *file, const char __user *user_buf,
-			     size_t count, loff_t *ppos)
-{
-	struct ath_softc *sc = file->private_data;
-	struct ath_hw *ah = sc->sc_ah;
-	unsigned long mask;
-	char buf[32];
-	ssize_t len;
-
-	len = min(count, sizeof(buf) - 1);
-	if (copy_from_user(buf, user_buf, len))
-		return -EFAULT;
-
-	buf[len] = '\0';
-	if (kstrtoul(buf, 0, &mask))
-		return -EINVAL;
-
-	ah->txchainmask = mask;
-	ah->caps.tx_chainmask = mask;
-	return count;
-}
-
-static const struct file_operations fops_tx_chainmask = {
-	.read = read_file_tx_chainmask,
-	.write = write_file_tx_chainmask,
-	.open = simple_open,
-	.owner = THIS_MODULE,
-	.llseek = default_llseek,
-};
-
-
-static ssize_t read_file_rx_chainmask(struct file *file, char __user *user_buf,
-			     size_t count, loff_t *ppos)
-{
-	struct ath_softc *sc = file->private_data;
-	struct ath_hw *ah = sc->sc_ah;
-	char buf[32];
-	unsigned int len;
-
-	len = sprintf(buf, "0x%08x\n", ah->rxchainmask);
-	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
-}
-
-static ssize_t write_file_rx_chainmask(struct file *file, const char __user *user_buf,
-			     size_t count, loff_t *ppos)
-{
-	struct ath_softc *sc = file->private_data;
-	struct ath_hw *ah = sc->sc_ah;
-	unsigned long mask;
-	char buf[32];
-	ssize_t len;
-
-	len = min(count, sizeof(buf) - 1);
-	if (copy_from_user(buf, user_buf, len))
-		return -EFAULT;
-
-	buf[len] = '\0';
-	if (kstrtoul(buf, 0, &mask))
-		return -EINVAL;
-
-	ah->rxchainmask = mask;
-	ah->caps.rx_chainmask = mask;
-	return count;
-}
-
-static const struct file_operations fops_rx_chainmask = {
-	.read = read_file_rx_chainmask,
-	.write = write_file_rx_chainmask,
-	.open = simple_open,
-	.owner = THIS_MODULE,
-	.llseek = default_llseek,
-};
 
 static ssize_t read_file_ani(struct file *file, char __user *user_buf,
 			     size_t count, loff_t *ppos)
@@ -1896,10 +1812,10 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    &fops_reset);
 	debugfs_create_file("recv", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_recv);
-	debugfs_create_file("rx_chainmask", S_IRUSR | S_IWUSR,
-			    sc->debug.debugfs_phy, sc, &fops_rx_chainmask);
-	debugfs_create_file("tx_chainmask", S_IRUSR | S_IWUSR,
-			    sc->debug.debugfs_phy, sc, &fops_tx_chainmask);
+	debugfs_create_u8("rx_chainmask", S_IRUSR, sc->debug.debugfs_phy,
+			  &ah->rxchainmask);
+	debugfs_create_u8("tx_chainmask", S_IRUSR, sc->debug.debugfs_phy,
+			  &ah->txchainmask);
 	debugfs_create_file("ani", S_IRUSR | S_IWUSR,
 			    sc->debug.debugfs_phy, sc, &fops_ani);
 	debugfs_create_bool("paprd", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
-- 
1.8.0.2

