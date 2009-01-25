Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40710 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751812AbZAYOGC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 09:06:02 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Sun, 25 Jan 2009 15:06:00 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090125140600.136270@gmx.net> (sfid-20090125_150624_896319_493FFCEE)
MIME-Version: 1.0
Subject: [PATCH] b43: Accessing the TSF via mac80211
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows the mac80211 high level code to access the TSF. This is e.g=
=2E needed for BSSID merges in the IBSS mode.

The second version adds locking and removes the now unnecessary debugfs=
 entries.

Thanks to Michael Buesch! :)

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
---
diff -urN wireless-testing.orig/drivers/net/wireless/b43/debugfs.c wire=
less-testing/drivers/net/wireless/b43/debugfs.c
--- wireless-testing.orig/drivers/net/wireless/b43/debugfs.c	2009-01-25=
 06:12:13.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/debugfs.c	2009-01-25 14:3=
8:30.000000000 +0100
@@ -367,34 +367,6 @@
 	return 0;
 }
=20
-/* wl->irq_lock is locked */
-static ssize_t tsf_read_file(struct b43_wldev *dev,
-			     char *buf, size_t bufsize)
-{
-	ssize_t count =3D 0;
-	u64 tsf;
-
-	b43_tsf_read(dev, &tsf);
-	fappend("0x%08x%08x\n",
-		(unsigned int)((tsf & 0xFFFFFFFF00000000ULL) >> 32),
-		(unsigned int)(tsf & 0xFFFFFFFFULL));
-
-	return count;
-}
-
-/* wl->irq_lock is locked */
-static int tsf_write_file(struct b43_wldev *dev,
-			  const char *buf, size_t count)
-{
-	u64 tsf;
-
-	if (sscanf(buf, "%llu", (unsigned long long *)(&tsf)) !=3D 1)
-		return -EINVAL;
-	b43_tsf_write(dev, tsf);
-
-	return 0;
-}
-
 static ssize_t txstat_read_file(struct b43_wldev *dev,
 				char *buf, size_t bufsize)
 {
@@ -691,7 +663,6 @@
 B43_DEBUGFS_FOPS(mmio16write, NULL, mmio16write__write_file, 1);
 B43_DEBUGFS_FOPS(mmio32read, mmio32read__read_file, mmio32read__write_=
file, 1);
 B43_DEBUGFS_FOPS(mmio32write, NULL, mmio32write__write_file, 1);
-B43_DEBUGFS_FOPS(tsf, tsf_read_file, tsf_write_file, 1);
 B43_DEBUGFS_FOPS(txstat, txstat_read_file, NULL, 0);
 B43_DEBUGFS_FOPS(restart, NULL, restart_write_file, 1);
 B43_DEBUGFS_FOPS(loctls, loctls_read_file, NULL, 0);
@@ -805,7 +776,6 @@
 	ADD_FILE(mmio16write, 0200);
 	ADD_FILE(mmio32read, 0600);
 	ADD_FILE(mmio32write, 0200);
-	ADD_FILE(tsf, 0600);
 	ADD_FILE(txstat, 0400);
 	ADD_FILE(restart, 0200);
 	ADD_FILE(loctls, 0400);
@@ -834,7 +804,6 @@
 	debugfs_remove(e->file_mmio16write.dentry);
 	debugfs_remove(e->file_mmio32read.dentry);
 	debugfs_remove(e->file_mmio32write.dentry);
-	debugfs_remove(e->file_tsf.dentry);
 	debugfs_remove(e->file_txstat.dentry);
 	debugfs_remove(e->file_restart.dentry);
 	debugfs_remove(e->file_loctls.dentry);
diff -urN wireless-testing.orig/drivers/net/wireless/b43/debugfs.h wire=
less-testing/drivers/net/wireless/b43/debugfs.h
--- wireless-testing.orig/drivers/net/wireless/b43/debugfs.h	2009-01-25=
 06:12:13.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/debugfs.h	2009-01-25 14:3=
9:33.000000000 +0100
@@ -46,7 +46,6 @@
 	struct b43_dfs_file file_mmio16write;
 	struct b43_dfs_file file_mmio32read;
 	struct b43_dfs_file file_mmio32write;
-	struct b43_dfs_file file_tsf;
 	struct b43_dfs_file file_txstat;
 	struct b43_dfs_file file_txpower_g;
 	struct b43_dfs_file file_restart;
diff -urN wireless-testing.orig/drivers/net/wireless/b43/main.c wireles=
s-testing/drivers/net/wireless/b43/main.c
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-01-25 06=
:12:13.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-01-25 14:35:5=
1.000000000 +0100
@@ -3177,6 +3177,45 @@
 	return 0;
 }
=20
+static u64 b43_op_get_tsf(struct ieee80211_hw *hw)
+{
+	struct b43_wl *wl =3D hw_to_b43_wl(hw);
+	unsigned long flags;
+	struct b43_wldev *dev;
+	u64 tsf;
+
+	mutex_lock(&wl->mutex);
+	spin_lock_irqsave(&wl->irq_lock, flags);
+	dev =3D wl->current_dev;
+
+	if(dev && (b43_status(dev) >=3D B43_STAT_INITIALIZED))
+		b43_tsf_read(dev, &tsf);
+	else
+		tsf =3D 0;
+
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
+	mutex_unlock(&wl->mutex);
+
+	return tsf;
+}
+
+static void b43_op_set_tsf(struct ieee80211_hw *hw, u64 tsf)
+{
+	struct b43_wl *wl =3D hw_to_b43_wl(hw);
+	unsigned long flags;
+	struct b43_wldev *dev;
+
+	mutex_lock(&wl->mutex);
+	spin_lock_irqsave(&wl->irq_lock, flags);
+	dev =3D wl->current_dev;
+
+	if(dev && (b43_status(dev) >=3D B43_STAT_INITIALIZED))
+		b43_tsf_write(dev, tsf);
+
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
+	mutex_unlock(&wl->mutex);
+}
+
 static void b43_put_phy_into_reset(struct b43_wldev *dev)
 {
 	struct ssb_device *sdev =3D dev->dev;
@@ -4296,6 +4335,8 @@
 	.set_key		=3D b43_op_set_key,
 	.get_stats		=3D b43_op_get_stats,
 	.get_tx_stats		=3D b43_op_get_tx_stats,
+	.get_tsf		=3D b43_op_get_tsf,
+	.set_tsf		=3D b43_op_set_tsf,
 	.start			=3D b43_op_start,
 	.stop			=3D b43_op_stop,
 	.set_tim		=3D b43_op_beacon_set_tim,

--=20
NUR NOCH BIS 31.01.! GMX FreeDSL - Telefonanschluss + DSL=20
f=FCr nur 16,37 EURO/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K11308T4=
569a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
