Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out02.mta.xmission.com ([166.70.13.232]:43160 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762838AbZE0Msi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 08:48:38 -0400
From: Jeff Hansen <x@jeffhansen.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jouni.malinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	Jeff Hansen <x@jeffhansen.com>
Date: Wed, 27 May 2009 12:48:29 +0000
Message-Id: <1243428510-14931-3-git-send-email-x@jeffhansen.com>
In-Reply-To: <1243428510-14931-1-git-send-email-x@jeffhansen.com>
References: <1243428510-14931-1-git-send-email-x@jeffhansen.com>
Subject: [PATCH 3/4] ath9k: Add "debug" file to debugfs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the debug file to the ath9k debugfs, which lets you modify
the debug_mask at runtime, without having to reload the ath9k module.

Signed-off-by: Jeff Hansen <x@jeffhansen.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |   38 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/debug.h |    1 +
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 80115ea..a42d631 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -44,6 +44,38 @@ static int ath9k_debugfs_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static ssize_t read_file_debug(struct file *file, char __user *user_buf,
+			     size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	char buf[32];
+	unsigned int len = 0;
+	len += snprintf(buf, sizeof(buf), "0x%08x\n", sc->debug.debug_mask);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_debug(struct file *file, const char __user *user_buf,
+			     size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	unsigned long mask;
+	char buf[32];
+	if (copy_from_user(buf, user_buf, (sizeof(buf) - 1) < count ?
+		(sizeof(buf) - 1) : count))
+		return 0;
+	buf[sizeof(buf)-1] = 0;
+	if (strict_strtoul(buf, 0, &mask) == 0)
+		sc->debug.debug_mask = mask;
+	return count;
+}
+
+static const struct file_operations fops_debug = {
+	.read = read_file_debug,
+	.write = write_file_debug,
+	.open = ath9k_debugfs_open,
+	.owner = THIS_MODULE
+};
+
 static ssize_t read_file_dma(struct file *file, char __user *user_buf,
 			     size_t count, loff_t *ppos)
 {
@@ -461,6 +493,11 @@ int ath9k_init_debug(struct ath_softc *sc)
 	if (!sc->debug.debugfs_phy)
 		goto err;
 
+	sc->debug.debugfs_debug = debugfs_create_file("debug",
+		S_IRUGO | S_IWUSR, sc->debug.debugfs_phy, sc, &fops_debug);
+	if (!sc->debug.debugfs_debug)
+		goto err;
+
 	sc->debug.debugfs_dma = debugfs_create_file("dma", S_IRUGO,
 				       sc->debug.debugfs_phy, sc, &fops_dma);
 	if (!sc->debug.debugfs_dma)
@@ -498,6 +535,7 @@ void ath9k_exit_debug(struct ath_softc *sc)
 	debugfs_remove(sc->debug.debugfs_rcstat);
 	debugfs_remove(sc->debug.debugfs_interrupt);
 	debugfs_remove(sc->debug.debugfs_dma);
+	debugfs_remove(sc->debug.debugfs_debug);
 	debugfs_remove(sc->debug.debugfs_phy);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index cf9146a..edda15b 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -95,6 +95,7 @@ struct ath_stats {
 struct ath9k_debug {
 	int debug_mask;
 	struct dentry *debugfs_phy;
+	struct dentry *debugfs_debug;
 	struct dentry *debugfs_dma;
 	struct dentry *debugfs_interrupt;
 	struct dentry *debugfs_rcstat;
-- 
1.6.0.4

