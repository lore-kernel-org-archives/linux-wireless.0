Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-04.rdc-kc.rr.com ([24.94.166.116]:37315 "EHLO
	ms-smtp-04.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532AbXIRPjM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2007 11:39:12 -0400
Date: Tue, 18 Sep 2007 10:38:29 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43legacy: Fix sparse warnings (part 2)
Message-ID: <46eff0f5.pWVUYEYGrM5PdY9K%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are additional sparse warnings in b43legacy. None of them result
in program errors, but are fixed for completeness.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 drivers/net/wireless/b43legacy/debugfs.c |   14 +++++++-------
 drivers/net/wireless/b43legacy/pio.c     |    6 +++---
 2 files changed, 10 insertions(+), 10 deletions(-)

Index: wireless-dev/drivers/net/wireless/b43legacy/debugfs.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43legacy/debugfs.c
+++ wireless-dev/drivers/net/wireless/b43legacy/debugfs.c
@@ -39,7 +39,7 @@
 
 
 /* The root directory. */
-struct dentry *rootdir;
+static struct dentry *rootdir;
 
 struct b43legacy_debugfs_fops {
 	ssize_t (*read)(struct b43legacy_wldev *dev, char *buf, size_t bufsize);
@@ -76,7 +76,7 @@ struct b43legacy_dfs_file * fops_to_dfs_
 
 
 /* wl->irq_lock is locked */
-ssize_t tsf_read_file(struct b43legacy_wldev *dev, char *buf, size_t bufsize)
+static ssize_t tsf_read_file(struct b43legacy_wldev *dev, char *buf, size_t bufsize)
 {
 	ssize_t count = 0;
 	u64 tsf;
@@ -90,7 +90,7 @@ ssize_t tsf_read_file(struct b43legacy_w
 }
 
 /* wl->irq_lock is locked */
-int tsf_write_file(struct b43legacy_wldev *dev, const char *buf, size_t count)
+static int tsf_write_file(struct b43legacy_wldev *dev, const char *buf, size_t count)
 {
 	u64 tsf;
 
@@ -102,7 +102,7 @@ int tsf_write_file(struct b43legacy_wlde
 }
 
 /* wl->irq_lock is locked */
-ssize_t ucode_regs_read_file(struct b43legacy_wldev *dev, char *buf, size_t bufsize)
+static ssize_t ucode_regs_read_file(struct b43legacy_wldev *dev, char *buf, size_t bufsize)
 {
 	ssize_t count = 0;
 	int i;
@@ -116,7 +116,7 @@ ssize_t ucode_regs_read_file(struct b43l
 }
 
 /* wl->irq_lock is locked */
-ssize_t shm_read_file(struct b43legacy_wldev *dev, char *buf, size_t bufsize)
+static ssize_t shm_read_file(struct b43legacy_wldev *dev, char *buf, size_t bufsize)
 {
 	ssize_t count = 0;
 	int i;
@@ -135,7 +135,7 @@ ssize_t shm_read_file(struct b43legacy_w
 	return count;
 }
 
-ssize_t txstat_read_file(struct b43legacy_wldev *dev, char *buf, size_t bufsize)
+static ssize_t txstat_read_file(struct b43legacy_wldev *dev, char *buf, size_t bufsize)
 {
 	struct b43legacy_txstatus_log *log = &dev->dfsentry->txstatlog;
 	ssize_t count = 0;
@@ -183,7 +183,7 @@ out_unlock:
 }
 
 /* wl->irq_lock is locked */
-int restart_write_file(struct b43legacy_wldev *dev, const char *buf, size_t count)
+static int restart_write_file(struct b43legacy_wldev *dev, const char *buf, size_t count)
 {
 	int err = 0;
 
Index: wireless-dev/drivers/net/wireless/b43legacy/pio.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43legacy/pio.c
+++ wireless-dev/drivers/net/wireless/b43legacy/pio.c
@@ -66,7 +66,7 @@ static u16 tx_get_next_word(const u8 *tx
 		source = packet;
 		i -= txhdr_size;
 	}
-	ret = le16_to_cpu(*((u16 *)(source + i)));
+	ret = le16_to_cpu(*((__le16 *)(source + i)));
 	*pos += 2;
 
 	return ret;
@@ -539,7 +539,7 @@ static void pio_rx_error(struct b43legac
 
 void b43legacy_pio_rx(struct b43legacy_pioqueue *queue)
 {
-	u16 preamble[21] = { 0 };
+	__le16 preamble[21] = { 0 };
 	struct b43legacy_rxhdr_fw3 *rxhdr;
 	u16 tmp;
 	u16 len;
@@ -609,7 +609,7 @@ data_ready:
 	skb_put(skb, len);
 	for (i = 0; i < len - 1; i += 2) {
 		tmp = b43legacy_pio_read(queue, B43legacy_PIO_RXDATA);
-		*((u16 *)(skb->data + i)) = cpu_to_le16(tmp);
+		*((__le16 *)(skb->data + i)) = cpu_to_le16(tmp);
 	}
 	if (len % 2) {
 		tmp = b43legacy_pio_read(queue, B43legacy_PIO_RXDATA);
