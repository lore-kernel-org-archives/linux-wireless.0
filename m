Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59713 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755456AbZAWEoW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 23:44:22 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Fri, 23 Jan 2009 05:44:21 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090123044421.270720@gmx.net> (sfid-20090123_054428_080982_2340614F)
MIME-Version: 1.0
Subject: [PATCH] ath9k: Read and write the TSF via debugfs
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds an ath9k specific entry to read, write and reset the TS=
=46 into the debugfs, like in ath5k. This makes debugging the IBSS hand=
ling of wifi drivers _much_ easier.

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
---
diff -urN compat-wireless-2009-01-19/drivers/net/wireless/ath9k/ath9k.h=
 compat-wireless-2009-01-19.orig/drivers/net/wireless/ath9k/ath9k.h
--- compat-wireless-2009-01-19.orig/drivers/net/wireless/ath9k/ath9k.h	=
2009-01-19 20:07:21.000000000 +0100
+++ compat-wireless-2009-01-19/drivers/net/wireless/ath9k/ath9k.h	2009-=
01-23 01:54:41.000000000 +0100
@@ -916,6 +916,7 @@
 bool ath9k_hw_setbssidmask(struct ath_hal *ah, const u8 *mask);
 void ath9k_hw_write_associd(struct ath_hal *ah, const u8 *bssid, u16 a=
ssocId);
 u64 ath9k_hw_gettsf64(struct ath_hal *ah);
+void ath9k_hw_settsf64(struct ath_hal *ah, u64 tsf64);
 void ath9k_hw_reset_tsf(struct ath_hal *ah);
 bool ath9k_hw_set_tsfadjust(struct ath_hal *ah, u32 setting);
 bool ath9k_hw_setslottime(struct ath_hal *ah, u32 us);
diff -urN compat-wireless-2009-01-19/drivers/net/wireless/ath9k/core.h =
compat-wireless-2009-01-19.orig/drivers/net/wireless/ath9k/core.h
--- compat-wireless-2009-01-19.orig/drivers/net/wireless/ath9k/core.h	2=
009-01-19 20:07:21.000000000 +0100
+++ compat-wireless-2009-01-19/drivers/net/wireless/ath9k/core.h	2009-0=
1-23 02:40:53.000000000 +0100
@@ -141,6 +141,7 @@
 	struct dentry *debugfs_phy;
 	struct dentry *debugfs_dma;
 	struct dentry *debugfs_interrupt;
+	struct dentry *debugfs_tsf;
 	struct ath_stats stats;
 };
=20
diff -urN compat-wireless-2009-01-19/drivers/net/wireless/ath9k/debug.c=
 compat-wireless-2009-01-19.orig/drivers/net/wireless/ath9k/debug.c
--- compat-wireless-2009-01-19.orig/drivers/net/wireless/ath9k/debug.c	=
2009-01-19 20:07:21.000000000 +0100
+++ compat-wireless-2009-01-19/drivers/net/wireless/ath9k/debug.c	2009-=
01-23 02:45:34.000000000 +0100
@@ -222,6 +222,49 @@
 	.owner =3D THIS_MODULE
 };
=20
+
+static ssize_t read_file_tsf(struct file *file, char __user *user_buf,
+			     size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc =3D file->private_data;
+	char buf[100];
+	snprintf(buf, sizeof(buf), "0x%016llx\n",
+		 (unsigned long long)ath9k_hw_gettsf64(sc->sc_ah));
+	return simple_read_from_buffer(user_buf, count, ppos, buf, 19);
+}
+
+static ssize_t write_file_tsf(struct file *file,
+                              const char __user *user_buf,
+                              size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc =3D file->private_data;
+	char buf[21];
+	unsigned long long tsf;
+
+	if (copy_from_user(buf, user_buf, min(count, sizeof(buf) - 1)))
+		return -EFAULT;
+	buf[sizeof(buf) - 1] =3D '\0';
+
+	if (strncmp(buf, "reset", 5) =3D=3D 0) {
+		ath9k_hw_reset_tsf(sc->sc_ah);
+		printk(KERN_INFO "debugfs reset TSF\n");
+	} else {
+		tsf =3D simple_strtoul(buf, NULL, 0);
+		ath9k_hw_settsf64(sc->sc_ah, tsf);
+		printk(KERN_INFO "debugfs set TSF to %#018llx\n", tsf);
+	}
+
+	return count;
+}
+
+static const struct file_operations fops_tsf =3D {
+	.read =3D read_file_tsf,
+	.write =3D write_file_tsf,
+	.open =3D ath9k_debugfs_open,
+	.owner =3D THIS_MODULE
+};
+
+
 int ath9k_init_debug(struct ath_softc *sc)
 {
 	sc->sc_debug.debug_mask =3D ath9k_debug;
@@ -247,6 +290,11 @@
 	if (!sc->sc_debug.debugfs_interrupt)
 		goto err;
=20
+	sc->sc_debug.debugfs_tsf =3D debugfs_create_file("tsf", S_IRUGO,
+				       sc->sc_debug.debugfs_phy, sc, &fops_tsf);
+	if (!sc->sc_debug.debugfs_tsf)
+		goto err;
+
 	return 0;
 err:
 	ath9k_exit_debug(sc);
@@ -255,6 +303,7 @@
=20
 void ath9k_exit_debug(struct ath_softc *sc)
 {
+	debugfs_remove(sc->sc_debug.debugfs_tsf);
 	debugfs_remove(sc->sc_debug.debugfs_interrupt);
 	debugfs_remove(sc->sc_debug.debugfs_dma);
 	debugfs_remove(sc->sc_debug.debugfs_phy);
diff -urN compat-wireless-2009-01-19/drivers/net/wireless/ath9k/hw.c co=
mpat-wireless-2009-01-19.orig/drivers/net/wireless/ath9k/hw.c
--- compat-wireless-2009-01-19.orig/drivers/net/wireless/ath9k/hw.c	200=
9-01-19 20:07:21.000000000 +0100
+++ compat-wireless-2009-01-19/drivers/net/wireless/ath9k/hw.c	2009-01-=
23 02:39:11.000000000 +0100
@@ -3810,6 +3810,13 @@
 	return tsf;
 }
=20
+void ath9k_hw_settsf64(struct ath_hal *ah, u64 tsf64)
+{
+	REG_WRITE(ah, AR_TSF_L32, 0x00000000);
+	REG_WRITE(ah, AR_TSF_U32, (tsf64 >> 32) & 0xffffffff);
+	REG_WRITE(ah, AR_TSF_L32, tsf64 & 0xffffffff);
+}
+
 void ath9k_hw_reset_tsf(struct ath_hal *ah)
 {
 	int count;

--=20
NUR NOCH BIS 31.01.! GMX FreeDSL - Telefonanschluss + DSL=20
f=FCr nur 16,37 EURO/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K11308T4=
569a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
