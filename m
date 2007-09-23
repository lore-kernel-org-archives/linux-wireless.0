Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:42912
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbXIWO2Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Sep 2007 10:28:25 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ulrich Kunitz <kune@deine-taler.de>, Daniel Drake <dsd@gentoo.org>
Subject: [PATCH] zd1211: Fix crashes with NULL mac addresses (monitor mode)
Date: Sun, 23 Sep 2007 16:26:22 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200709231626.22446.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes NULL pointer dereferences.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

This patch is against zd1211rw-mac80211. I'll now clone
wireless-2.6 to get the upstream version. But I guess
this patch does also apply cleanly to z1211, if the paths
are changed.

Index: wireless-dev/drivers/net/wireless/zd1211rw-mac80211/zd_chip.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/zd1211rw-mac80211/zd_chip.c	2007-09-19 17:15:58.000000000 +0200
+++ wireless-dev/drivers/net/wireless/zd1211rw-mac80211/zd_chip.c	2007-09-23 15:47:43.000000000 +0200
@@ -52,8 +52,15 @@ void zd_chip_clear(struct zd_chip *chip)
 static int scnprint_mac_oui(struct zd_chip *chip, char *buffer, size_t size)
 {
 	u8 *addr = zd_chip_to_mac(chip)->hwaddr;
+	u8 a = 0, b = 0, c = 0;
+
+	if (addr) {
+		a = addr[0];
+		b = addr[1];
+		c = addr[2];
+	}
 	return scnprintf(buffer, size, "%02x-%02x-%02x",
-		         addr[0], addr[1], addr[2]);
+		         a, b, c);
 }
 
 /* Prints an identifier line, which will support debugging. */
@@ -378,15 +385,16 @@ int zd_write_mac_addr(struct zd_chip *ch
 		[1] = { .addr = CR_MAC_ADDR_P2 },
 	};
 
-	reqs[0].value = (mac_addr[3] << 24)
-		      | (mac_addr[2] << 16)
-		      | (mac_addr[1] <<  8)
-		      |  mac_addr[0];
-	reqs[1].value = (mac_addr[5] <<  8)
-		      |  mac_addr[4];
-
-	dev_dbg_f(zd_chip_dev(chip),
-		"mac addr " MAC_FMT "\n", MAC_ARG(mac_addr));
+	if (mac_addr) {
+		reqs[0].value = (mac_addr[3] << 24)
+			      | (mac_addr[2] << 16)
+			      | (mac_addr[1] <<  8)
+			      |  mac_addr[0];
+		reqs[1].value = (mac_addr[5] <<  8)
+			      |  mac_addr[4];
+		dev_dbg_f(zd_chip_dev(chip),
+			  "mac addr " MAC_FMT "\n", MAC_ARG(mac_addr));
+	}
 
 	mutex_lock(&chip->mutex);
 	r = zd_iowrite32a_locked(chip, reqs, ARRAY_SIZE(reqs));
