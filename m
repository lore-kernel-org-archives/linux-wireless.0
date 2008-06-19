Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:50259 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650AbYFSXDo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 19:03:44 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Remove "shm" and "ucode_regs" debugfs files
Date: Fri, 20 Jun 2008 01:01:50 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200806200101.50420.mb@bu3sch.de> (sfid-20080620_010347_607570_93CD1E17)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't need these two dump-files anymore, as we can easily do this
in userspace now.
Use b43-fwdump from the b43-tools repository to dump microcode registers.
Use "b43-fwdump -s" to dump SHM (or use -S to do a binary dump)

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please apply this to 2.6.27


Index: wireless-testing/drivers/net/wireless/b43/debugfs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/debugfs.c	2008-06-20 00:50:09.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/debugfs.c	2008-06-20 00:53:33.000000000 +0200
@@ -392,48 +392,12 @@ static int tsf_write_file(struct b43_wld
 		return -EINVAL;
 	b43_tsf_write(dev, tsf);
 
 	return 0;
 }
 
-/* wl->irq_lock is locked */
-static ssize_t ucode_regs_read_file(struct b43_wldev *dev,
-				    char *buf, size_t bufsize)
-{
-	ssize_t count = 0;
-	int i;
-
-	for (i = 0; i < 64; i++) {
-		fappend("r%d = 0x%04x\n", i,
-			b43_shm_read16(dev, B43_SHM_SCRATCH, i));
-	}
-
-	return count;
-}
-
-/* wl->irq_lock is locked */
-static ssize_t shm_read_file(struct b43_wldev *dev,
-			     char *buf, size_t bufsize)
-{
-	ssize_t count = 0;
-	int i;
-	u16 tmp;
-	__le16 *le16buf = (__le16 *)buf;
-
-	for (i = 0; i < 0x1000; i++) {
-		if (bufsize < sizeof(tmp))
-			break;
-		tmp = b43_shm_read16(dev, B43_SHM_SHARED, 2 * i);
-		le16buf[i] = cpu_to_le16(tmp);
-		count += sizeof(tmp);
-		bufsize -= sizeof(tmp);
-	}
-
-	return count;
-}
-
 static ssize_t txstat_read_file(struct b43_wldev *dev,
 				char *buf, size_t bufsize)
 {
 	struct b43_txstatus_log *log = &dev->dfsentry->txstatlog;
 	ssize_t count = 0;
 	unsigned long flags;
@@ -795,14 +759,12 @@ B43_DEBUGFS_FOPS(shm32read, shm32read__r
 B43_DEBUGFS_FOPS(shm32write, NULL, shm32write__write_file, 1);
 B43_DEBUGFS_FOPS(mmio16read, mmio16read__read_file, mmio16read__write_file, 1);
 B43_DEBUGFS_FOPS(mmio16write, NULL, mmio16write__write_file, 1);
 B43_DEBUGFS_FOPS(mmio32read, mmio32read__read_file, mmio32read__write_file, 1);
 B43_DEBUGFS_FOPS(mmio32write, NULL, mmio32write__write_file, 1);
 B43_DEBUGFS_FOPS(tsf, tsf_read_file, tsf_write_file, 1);
-B43_DEBUGFS_FOPS(ucode_regs, ucode_regs_read_file, NULL, 1);
-B43_DEBUGFS_FOPS(shm, shm_read_file, NULL, 1);
 B43_DEBUGFS_FOPS(txstat, txstat_read_file, NULL, 0);
 B43_DEBUGFS_FOPS(txpower_g, txpower_g_read_file, txpower_g_write_file, 0);
 B43_DEBUGFS_FOPS(restart, NULL, restart_write_file, 1);
 B43_DEBUGFS_FOPS(loctls, loctls_read_file, NULL, 0);
 
 
@@ -910,14 +872,12 @@ void b43_debugfs_add_device(struct b43_w
 	ADD_FILE(shm32write, 0200);
 	ADD_FILE(mmio16read, 0600);
 	ADD_FILE(mmio16write, 0200);
 	ADD_FILE(mmio32read, 0600);
 	ADD_FILE(mmio32write, 0200);
 	ADD_FILE(tsf, 0600);
-	ADD_FILE(ucode_regs, 0400);
-	ADD_FILE(shm, 0400);
 	ADD_FILE(txstat, 0400);
 	ADD_FILE(txpower_g, 0600);
 	ADD_FILE(restart, 0200);
 	ADD_FILE(loctls, 0400);
 
 #undef ADD_FILE
@@ -942,14 +902,12 @@ void b43_debugfs_remove_device(struct b4
 	debugfs_remove(e->file_shm32write.dentry);
 	debugfs_remove(e->file_mmio16read.dentry);
 	debugfs_remove(e->file_mmio16write.dentry);
 	debugfs_remove(e->file_mmio32read.dentry);
 	debugfs_remove(e->file_mmio32write.dentry);
 	debugfs_remove(e->file_tsf.dentry);
-	debugfs_remove(e->file_ucode_regs.dentry);
-	debugfs_remove(e->file_shm.dentry);
 	debugfs_remove(e->file_txstat.dentry);
 	debugfs_remove(e->file_txpower_g.dentry);
 	debugfs_remove(e->file_restart.dentry);
 	debugfs_remove(e->file_loctls.dentry);
 
 	debugfs_remove(e->subdir);
Index: wireless-testing/drivers/net/wireless/b43/debugfs.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/debugfs.h	2008-06-20 00:50:08.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/debugfs.h	2008-06-20 00:51:53.000000000 +0200
@@ -42,14 +42,12 @@ struct b43_dfsentry {
 	struct b43_dfs_file file_shm32write;
 	struct b43_dfs_file file_mmio16read;
 	struct b43_dfs_file file_mmio16write;
 	struct b43_dfs_file file_mmio32read;
 	struct b43_dfs_file file_mmio32write;
 	struct b43_dfs_file file_tsf;
-	struct b43_dfs_file file_ucode_regs;
-	struct b43_dfs_file file_shm;
 	struct b43_dfs_file file_txstat;
 	struct b43_dfs_file file_txpower_g;
 	struct b43_dfs_file file_restart;
 	struct b43_dfs_file file_loctls;
 
 	struct b43_txstatus_log txstatlog;
