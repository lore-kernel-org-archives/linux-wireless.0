Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50159 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753548AbZAWEjP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 23:39:15 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Fri, 23 Jan 2009 05:39:13 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090123043913.270710@gmx.net> (sfid-20090123_053923_228043_9845DB7A)
MIME-Version: 1.0
Subject: [PATCH v2] ath5k: Read and write the TSF via debugfs
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch updates the ath5k specific entry in the debugfs to read and =
reset the TSF value, to allowing write it, too. This makes debugging th=
e IBSS handling of wifi drivers _much_ easier.

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
---
diff -urN compat-wireless-2009-01-19/drivers/net/wireless/ath5k/ath5k.h=
 compat-wireless-2009-01-19.orig/drivers/net/wireless/ath5k/ath5k.h
--- compat-wireless-2009-01-19.orig/drivers/net/wireless/ath5k/ath5k.h	=
2009-01-19 20:07:20.000000000 +0100
+++ compat-wireless-2009-01-19/drivers/net/wireless/ath5k/ath5k.h	2009-=
01-23 01:47:11.000000000 +0100
@@ -1206,6 +1206,7 @@
 /* Beacon control functions */
 extern u32 ath5k_hw_get_tsf32(struct ath5k_hw *ah);
 extern u64 ath5k_hw_get_tsf64(struct ath5k_hw *ah);
+extern void ath5k_hw_set_tsf64(struct ath5k_hw *ah, u64 tsf64);
 extern void ath5k_hw_reset_tsf(struct ath5k_hw *ah);
 extern void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon,=
 u32 interval);
 #if 0
diff -urN compat-wireless-2009-01-19/drivers/net/wireless/ath5k/debug.c=
 compat-wireless-2009-01-19.orig/drivers/net/wireless/ath5k/debug.c
--- compat-wireless-2009-01-19.orig/drivers/net/wireless/ath5k/debug.c	=
2009-01-19 20:07:20.000000000 +0100
+++ compat-wireless-2009-01-19/drivers/net/wireless/ath5k/debug.c	2009-=
01-23 00:34:25.000000000 +0100
@@ -210,15 +210,22 @@
 				 size_t count, loff_t *ppos)
 {
 	struct ath5k_softc *sc =3D file->private_data;
-	char buf[20];
+	char buf[21];
+	unsigned long long tsf;
=20
-	if (copy_from_user(buf, userbuf, min(count, sizeof(buf))))
+	if (copy_from_user(buf, userbuf, min(count, sizeof(buf) - 1)))
 		return -EFAULT;
+	buf[sizeof(buf) - 1] =3D '\0';
=20
 	if (strncmp(buf, "reset", 5) =3D=3D 0) {
 		ath5k_hw_reset_tsf(sc->ah);
 		printk(KERN_INFO "debugfs reset TSF\n");
+	} else {
+		tsf =3D simple_strtoul(buf, NULL, 0);
+		ath5k_hw_set_tsf64(sc->ah, tsf);
+		printk(KERN_INFO "debugfs set TSF to %#018llx\n", tsf);
 	}
+
 	return count;
 }
=20
diff -urN compat-wireless-2009-01-19/drivers/net/wireless/ath5k/pcu.c c=
ompat-wireless-2009-01-19.orig/drivers/net/wireless/ath5k/pcu.c
--- compat-wireless-2009-01-19.orig/drivers/net/wireless/ath5k/pcu.c	20=
09-01-19 20:07:20.000000000 +0100
+++ compat-wireless-2009-01-19/drivers/net/wireless/ath5k/pcu.c	2009-01=
-23 01:04:26.000000000 +0100
@@ -646,6 +646,23 @@
 }
=20
 /**
+ * ath5k_hw_set_tsf64 - Set a new 64bit TSF
+ *
+ * @ah: The &struct ath5k_hw
+ * @tsf64: The new 64bit TSF
+ *
+ * Sets the new TSF
+ */
+void ath5k_hw_set_tsf64(struct ath5k_hw *ah, u64 tsf64)
+{
+	ATH5K_TRACE(ah->ah_sc);
+
+	ath5k_hw_reg_write(ah, 0x00000000, AR5K_TSF_L32);
+	ath5k_hw_reg_write(ah, (tsf64 >> 32) & 0xffffffff, AR5K_TSF_U32);
+	ath5k_hw_reg_write(ah, tsf64 & 0xffffffff, AR5K_TSF_L32);
+}
+
+/**
  * ath5k_hw_reset_tsf - Force a TSF reset
  *
  * @ah: The &struct ath5k_hw

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
