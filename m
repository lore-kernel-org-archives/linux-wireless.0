Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46724 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbZE0FsK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 01:48:10 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1M9Bzn-000143-8Q
	for linux-wireless@vger.kernel.org; Wed, 27 May 2009 01:48:11 -0400
Received: from linville-t400.local (linville-t400.local [127.0.0.1])
	by linville-t400.local (8.14.3/8.14.3) with ESMTP id n4R5jBZb007450
	for <linux-wireless@vger.kernel.org>; Wed, 27 May 2009 07:45:11 +0200
Received: (from linville@localhost)
	by linville-t400.local (8.14.3/8.14.3/Submit) id n4R5jB3Y007449
	for linux-wireless@vger.kernel.org; Wed, 27 May 2009 07:45:11 +0200
From: Jeff Hansen <x@jeffhansen.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jouni.malinen@atheros.com>,
	ath9k-devel@lists.ath9k.org, Jeff Hansen <x@jeffhansen.com>
Date: Wed, 27 May 2009 05:05:14 +0000
Message-Id: <1243400715-13561-3-git-send-email-x@jeffhansen.com>
In-Reply-To: <1243400715-13561-1-git-send-email-x@jeffhansen.com>
References: <1243400715-13561-1-git-send-email-x@jeffhansen.com>
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
index d50821c..e2ff4a2 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -45,6 +45,38 @@ static int ath9k_debugfs_open(struct inode *inode, struct file *file)
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
@@ -462,6 +494,11 @@ int ath9k_init_debug(struct ath_softc *sc)
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
@@ -499,6 +536,7 @@ void ath9k_exit_debug(struct ath_softc *sc)
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


