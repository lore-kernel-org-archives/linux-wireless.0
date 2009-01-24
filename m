Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58066 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750775AbZAXGKB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 01:10:01 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Sat, 24 Jan 2009 07:09:59 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090124060959.50440@gmx.net> (sfid-20090124_071019_899137_9D6252FA)
MIME-Version: 1.0
Subject: [PATCH] mac80211: Generic TSF debugging
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables low-level driver independent debugging of the TSF an=
d remove the driver specific things of ath5k and ath9k from the debugfs=
=2E

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
---
diff -urN wireless-testing.orig/drivers/net/wireless/ath5k/base.c wirel=
ess-testing/drivers/net/wireless/ath5k/base.c
--- wireless-testing.orig/drivers/net/wireless/ath5k/base.c	2009-01-23 =
22:54:07.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath5k/base.c	2009-01-24 06:58=
:58.000000000 +0100
@@ -239,6 +239,7 @@
 static int ath5k_get_tx_stats(struct ieee80211_hw *hw,
 		struct ieee80211_tx_queue_stats *stats);
 static u64 ath5k_get_tsf(struct ieee80211_hw *hw);
+static void ath5k_set_tsf(struct ieee80211_hw *hw, u64 tsf);
 static void ath5k_reset_tsf(struct ieee80211_hw *hw);
 static int ath5k_beacon_update(struct ath5k_softc *sc,
 		struct sk_buff *skb);
@@ -261,6 +262,7 @@
 	.conf_tx 	=3D NULL,
 	.get_tx_stats 	=3D ath5k_get_tx_stats,
 	.get_tsf 	=3D ath5k_get_tsf,
+	.set_tsf 	=3D ath5k_set_tsf,
 	.reset_tsf 	=3D ath5k_reset_tsf,
 	.bss_info_changed =3D ath5k_bss_info_changed,
 };
@@ -3119,6 +3121,14 @@
 }
=20
 static void
+ath5k_set_tsf(struct ieee80211_hw *hw, u64 tsf)
+{
+	struct ath5k_softc *sc =3D hw->priv;
+
+	ath5k_hw_set_tsf64(sc->ah, tsf);
+}
+
+static void
 ath5k_reset_tsf(struct ieee80211_hw *hw)
 {
 	struct ath5k_softc *sc =3D hw->priv;
diff -urN wireless-testing.orig/drivers/net/wireless/ath5k/debug.c wire=
less-testing/drivers/net/wireless/ath5k/debug.c
--- wireless-testing.orig/drivers/net/wireless/ath5k/debug.c	2009-01-23=
 22:54:07.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath5k/debug.c	2009-01-24 06:5=
8:58.000000000 +0100
@@ -193,50 +193,6 @@
 };
=20
=20
-/* debugfs: TSF */
-
-static ssize_t read_file_tsf(struct file *file, char __user *user_buf,
-				   size_t count, loff_t *ppos)
-{
-	struct ath5k_softc *sc =3D file->private_data;
-	char buf[100];
-	snprintf(buf, sizeof(buf), "0x%016llx\n",
-		 (unsigned long long)ath5k_hw_get_tsf64(sc->ah));
-	return simple_read_from_buffer(user_buf, count, ppos, buf, 19);
-}
-
-static ssize_t write_file_tsf(struct file *file,
-				 const char __user *userbuf,
-				 size_t count, loff_t *ppos)
-{
-	struct ath5k_softc *sc =3D file->private_data;
-	char buf[21];
-	unsigned long long tsf;
-
-	if (copy_from_user(buf, userbuf, min(count, sizeof(buf) - 1)))
-		return -EFAULT;
-	buf[sizeof(buf) - 1] =3D '\0';
-
-	if (strncmp(buf, "reset", 5) =3D=3D 0) {
-		ath5k_hw_reset_tsf(sc->ah);
-		printk(KERN_INFO "debugfs reset TSF\n");
-	} else {
-		tsf =3D simple_strtoul(buf, NULL, 0);
-		ath5k_hw_set_tsf64(sc->ah, tsf);
-		printk(KERN_INFO "debugfs set TSF to %#018llx\n", tsf);
-	}
-
-	return count;
-}
-
-static const struct file_operations fops_tsf =3D {
-	.read =3D read_file_tsf,
-	.write =3D write_file_tsf,
-	.open =3D ath5k_debugfs_open,
-	.owner =3D THIS_MODULE,
-};
-
-
 /* debugfs: beacons */
=20
 static ssize_t read_file_beacon(struct file *file, char __user *user_b=
uf,
@@ -430,9 +386,6 @@
 	sc->debug.debugfs_registers =3D debugfs_create_file("registers", S_IR=
UGO,
 				sc->debug.debugfs_phydir, sc, &fops_registers);
=20
-	sc->debug.debugfs_tsf =3D debugfs_create_file("tsf", S_IWUSR | S_IRUG=
O,
-				sc->debug.debugfs_phydir, sc, &fops_tsf);
-
 	sc->debug.debugfs_beacon =3D debugfs_create_file("beacon", S_IWUSR | =
S_IRUGO,
 				sc->debug.debugfs_phydir, sc, &fops_beacon);
=20
@@ -451,7 +404,6 @@
 {
 	debugfs_remove(sc->debug.debugfs_debug);
 	debugfs_remove(sc->debug.debugfs_registers);
-	debugfs_remove(sc->debug.debugfs_tsf);
 	debugfs_remove(sc->debug.debugfs_beacon);
 	debugfs_remove(sc->debug.debugfs_reset);
 	debugfs_remove(sc->debug.debugfs_phydir);
diff -urN wireless-testing.orig/drivers/net/wireless/ath5k/debug.h wire=
less-testing/drivers/net/wireless/ath5k/debug.h
--- wireless-testing.orig/drivers/net/wireless/ath5k/debug.h	2009-01-23=
 22:54:07.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath5k/debug.h	2009-01-24 06:5=
8:58.000000000 +0100
@@ -72,7 +72,6 @@
 	struct dentry		*debugfs_phydir;
 	struct dentry		*debugfs_debug;
 	struct dentry		*debugfs_registers;
-	struct dentry		*debugfs_tsf;
 	struct dentry		*debugfs_beacon;
 	struct dentry		*debugfs_reset;
 };
diff -urN wireless-testing.orig/drivers/net/wireless/ath9k/core.h wirel=
ess-testing/drivers/net/wireless/ath9k/core.h
--- wireless-testing.orig/drivers/net/wireless/ath9k/core.h	2009-01-23 =
22:54:08.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath9k/core.h	2009-01-24 06:58=
:58.000000000 +0100
@@ -141,7 +141,6 @@
 	struct dentry *debugfs_phy;
 	struct dentry *debugfs_dma;
 	struct dentry *debugfs_interrupt;
-	struct dentry *debugfs_tsf;
 	struct ath_stats stats;
 };
=20
diff -urN wireless-testing.orig/drivers/net/wireless/ath9k/debug.c wire=
less-testing/drivers/net/wireless/ath9k/debug.c
--- wireless-testing.orig/drivers/net/wireless/ath9k/debug.c	2009-01-23=
 22:54:08.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath9k/debug.c	2009-01-24 06:5=
8:58.000000000 +0100
@@ -223,48 +223,6 @@
 };
=20
=20
-static ssize_t read_file_tsf(struct file *file, char __user *user_buf,
-			     size_t count, loff_t *ppos)
-{
-	struct ath_softc *sc =3D file->private_data;
-	char buf[100];
-	snprintf(buf, sizeof(buf), "0x%016llx\n",
-		 (unsigned long long)ath9k_hw_gettsf64(sc->sc_ah));
-	return simple_read_from_buffer(user_buf, count, ppos, buf, 19);
-}
-
-static ssize_t write_file_tsf(struct file *file,
-                              const char __user *user_buf,
-                              size_t count, loff_t *ppos)
-{
-	struct ath_softc *sc =3D file->private_data;
-	char buf[21];
-	unsigned long long tsf;
-
-	if (copy_from_user(buf, user_buf, min(count, sizeof(buf) - 1)))
-		return -EFAULT;
-	buf[sizeof(buf) - 1] =3D '\0';
-
-	if (strncmp(buf, "reset", 5) =3D=3D 0) {
-		ath9k_hw_reset_tsf(sc->sc_ah);
-		printk(KERN_INFO "debugfs reset TSF\n");
-	} else {
-		tsf =3D simple_strtoul(buf, NULL, 0);
-		ath9k_hw_settsf64(sc->sc_ah, tsf);
-		printk(KERN_INFO "debugfs set TSF to %#018llx\n", tsf);
-	}
-
-	return count;
-}
-
-static const struct file_operations fops_tsf =3D {
-	.read =3D read_file_tsf,
-	.write =3D write_file_tsf,
-	.open =3D ath9k_debugfs_open,
-	.owner =3D THIS_MODULE
-};
-
-
 int ath9k_init_debug(struct ath_softc *sc)
 {
 	sc->sc_debug.debug_mask =3D ath9k_debug;
@@ -290,11 +248,6 @@
 	if (!sc->sc_debug.debugfs_interrupt)
 		goto err;
=20
-	sc->sc_debug.debugfs_tsf =3D debugfs_create_file("tsf", S_IRUGO,
-				       sc->sc_debug.debugfs_phy, sc, &fops_tsf);
-	if (!sc->sc_debug.debugfs_tsf)
-		goto err;
-
 	return 0;
 err:
 	ath9k_exit_debug(sc);
@@ -303,7 +256,6 @@
=20
 void ath9k_exit_debug(struct ath_softc *sc)
 {
-	debugfs_remove(sc->sc_debug.debugfs_tsf);
 	debugfs_remove(sc->sc_debug.debugfs_interrupt);
 	debugfs_remove(sc->sc_debug.debugfs_dma);
 	debugfs_remove(sc->sc_debug.debugfs_phy);
diff -urN wireless-testing.orig/drivers/net/wireless/ath9k/main.c wirel=
ess-testing/drivers/net/wireless/ath9k/main.c
--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2009-01-23 =
22:54:08.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2009-01-24 06:58=
:58.000000000 +0100
@@ -2451,6 +2451,14 @@
 	return tsf;
 }
=20
+static void ath9k_set_tsf(struct ieee80211_hw *hw, u64 tsf)
+{
+	struct ath_softc *sc =3D hw->priv;
+	struct ath_hal *ah =3D sc->sc_ah;
+
+	ath9k_hw_settsf64(ah, tsf);
+}
+
 static void ath9k_reset_tsf(struct ieee80211_hw *hw)
 {
 	struct ath_softc *sc =3D hw->priv;
@@ -2514,6 +2522,7 @@
 	.bss_info_changed   =3D ath9k_bss_info_changed,
 	.set_key            =3D ath9k_set_key,
 	.get_tsf 	    =3D ath9k_get_tsf,
+	.set_tsf 	    =3D ath9k_set_tsf,
 	.reset_tsf 	    =3D ath9k_reset_tsf,
 	.ampdu_action       =3D ath9k_ampdu_action,
 };
diff -urN wireless-testing.orig/include/net/mac80211.h wireless-testing=
/include/net/mac80211.h
--- wireless-testing.orig/include/net/mac80211.h	2009-01-23 22:54:05.00=
0000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-01-24 06:58:58.0000000=
00 +0100
@@ -1360,7 +1360,11 @@
  *	hw->ampdu_queues items.
  *
  * @get_tsf: Get the current TSF timer value from firmware/hardware. C=
urrently,
- *	this is only used for IBSS mode debugging and, as such, is not a
+ *	this is only used for IBSS mode BSSID merging and debugging. Is not=
 a
+ *	required function. Must be atomic.
+ *
+ * @set_tsf: Set the TSF timer to the specified value in the firmware/=
hardware.
+ *      Currently, this is only used for IBSS mode debugging. Is not a
  *	required function. Must be atomic.
  *
  * @reset_tsf: Reset the TSF timer and allow firmware/hardware to sync=
hronize
@@ -1422,6 +1426,7 @@
 	int (*get_tx_stats)(struct ieee80211_hw *hw,
 			    struct ieee80211_tx_queue_stats *stats);
 	u64 (*get_tsf)(struct ieee80211_hw *hw);
+	void (*set_tsf)(struct ieee80211_hw *hw, u64 tsf);
 	void (*reset_tsf)(struct ieee80211_hw *hw);
 	int (*tx_last_beacon)(struct ieee80211_hw *hw);
 	int (*ampdu_action)(struct ieee80211_hw *hw,
diff -urN wireless-testing.orig/net/mac80211/debugfs.c wireless-testing=
/net/mac80211/debugfs.c
--- wireless-testing.orig/net/mac80211/debugfs.c	2009-01-23 22:54:06.00=
0000000 +0100
+++ wireless-testing/net/mac80211/debugfs.c	2009-01-24 06:58:58.0000000=
00 +0100
@@ -57,12 +57,61 @@
 		      local->hw.conf.long_frame_max_tx_count);
 DEBUGFS_READONLY_FILE(total_ps_buffered, 20, "%d",
 		      local->total_ps_buffered);
-DEBUGFS_READONLY_FILE(wep_iv, 20, "%#06x",
+DEBUGFS_READONLY_FILE(wep_iv, 20, "%#08x",
 		      local->wep_iv & 0xffffff);
 DEBUGFS_READONLY_FILE(rate_ctrl_alg, 100, "%s",
 		      local->rate_ctrl ? local->rate_ctrl->ops->name : "<unset>");
-DEBUGFS_READONLY_FILE(tsf, 20, "%#018llx",
-                      (unsigned long long) (local->ops->get_tsf ? loca=
l->ops->get_tsf(local_to_hw(local)) : 0));
+
+static ssize_t tsf_read(struct file *file, char __user *user_buf,
+			     size_t count, loff_t *ppos)
+{
+	struct ieee80211_local *local =3D file->private_data;
+	u64 tsf =3D 0;
+	char buf[100];
+
+	if (local->ops->get_tsf)
+		tsf =3D local->ops->get_tsf(local_to_hw(local));
+
+	snprintf(buf, sizeof(buf), "0x%016llx\n", (unsigned long long) tsf);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, 19);
+}
+
+static ssize_t tsf_write(struct file *file,
+                         const char __user *user_buf,
+                         size_t count, loff_t *ppos)
+{
+	struct ieee80211_local *local =3D file->private_data;
+	unsigned long long tsf;
+	char buf[100];
+	size_t len;
+
+	len =3D min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+	buf[len] =3D '\0';
+
+	if (strncmp(buf, "reset", 5) =3D=3D 0) {
+		if (local->ops->reset_tsf) {
+			local->ops->reset_tsf(local_to_hw(local));
+			printk(KERN_INFO "%s: debugfs reset TSF\n", wiphy_name(local->hw.wi=
phy));
+		}
+	} else {
+		tsf =3D simple_strtoul(buf, NULL, 0);
+		if (local->ops->set_tsf) {
+			local->ops->set_tsf(local_to_hw(local), tsf);
+			printk(KERN_INFO "%s: debugfs set TSF to %#018llx\n", wiphy_name(lo=
cal->hw.wiphy), tsf);
+		}
+	}
+
+	return count;
+}
+
+static const struct file_operations tsf_ops =3D {
+	.read =3D tsf_read,
+	.write =3D tsf_write,
+	.open =3D mac80211_open_file_generic
+};
=20
 /* statistics stuff */
=20

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
