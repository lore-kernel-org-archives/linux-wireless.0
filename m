Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:38533 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbYCWAf6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Mar 2008 20:35:58 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Don't compile N-PHY code when N-PHY is disabled
Date: Sun, 23 Mar 2008 01:33:58 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200803230133.58314.mb@bu3sch.de> (sfid-20080323_003603_678109_8F869843)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no need to compile the N-PHY support code, when the
N-PHY support is disabled in Kconfig.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please apply to 2.6.26


Index: wireless-testing/drivers/net/wireless/b43/Makefile
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/Makefile	2008-02-15 21:39:56.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/Makefile	2008-03-23 01:21:01.000000000 +0100
@@ -1,11 +1,11 @@
 b43-y				+= main.o
 b43-y				+= tables.o
-b43-y				+= tables_nphy.o
+b43-$(CONFIG_B43_NPHY)		+= tables_nphy.o
 b43-y				+= phy.o
-b43-y				+= nphy.o
+b43-$(CONFIG_B43_NPHY)		+= nphy.o
 b43-y				+= sysfs.o
 b43-y				+= xmit.o
 b43-y				+= lo.o
 b43-y				+= wa.o
 b43-y				+= dma.o
 b43-$(CONFIG_B43_RFKILL)	+= rfkill.o
Index: wireless-testing/drivers/net/wireless/b43/nphy.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/nphy.h	2008-02-15 21:39:56.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/nphy.h	2008-03-23 01:24:54.000000000 +0100
@@ -916,17 +916,57 @@
 #define B2055_C2_GENSPARE2		0xE2 /* Core 2 GEN spare 2 */
 
 
 
 struct b43_wldev;
 
+
+#ifdef CONFIG_B43_NPHY
+/* N-PHY support enabled */
+
 int b43_phy_initn(struct b43_wldev *dev);
 
 void b43_nphy_radio_turn_on(struct b43_wldev *dev);
 void b43_nphy_radio_turn_off(struct b43_wldev *dev);
 
 int b43_nphy_selectchannel(struct b43_wldev *dev, u8 channel);
 
 void b43_nphy_xmitpower(struct b43_wldev *dev);
 void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna);
 
+
+#else /* CONFIG_B43_NPHY */
+/* N-PHY support disabled */
+
+
+static inline
+int b43_phy_initn(struct b43_wldev *dev)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline
+void b43_nphy_radio_turn_on(struct b43_wldev *dev)
+{
+}
+static inline
+void b43_nphy_radio_turn_off(struct b43_wldev *dev)
+{
+}
+
+static inline
+int b43_nphy_selectchannel(struct b43_wldev *dev, u8 channel)
+{
+	return -ENOSYS;
+}
+
+static inline
+void b43_nphy_xmitpower(struct b43_wldev *dev)
+{
+}
+static inline
+void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
+{
+}
+
+#endif /* CONFIG_B43_NPHY */
 #endif /* B43_NPHY_H_ */
