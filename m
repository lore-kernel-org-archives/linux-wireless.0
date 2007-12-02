Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:53446 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750968AbXLBWLP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2007 17:11:15 -0500
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 6/8] rtl8180: Add support for sa2400 radio
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
Date: Sun, 02 Dec 2007 17:17:51 -0500
Message-ID: <20071202221751.7347.79547.stgit@tetra.sourmilk.net> (sfid-20071202_221133_888781_ECD6009F)
In-Reply-To: <20071202221751.7347.54891.stgit@tetra.sourmilk.net>
References: <20071202221751.7347.54891.stgit@tetra.sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrea Merello <andreamrl@tiscali.it>

This adds support for rtl8180+sa2400.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: Andrea Merello <andreamrl@tiscali.it>
---

 drivers/net/wireless/Makefile         |    2 
 drivers/net/wireless/rtl8180_dev.c    |   11 ++
 drivers/net/wireless/rtl8180_sa2400.c |  193 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/rtl8180_sa2400.h |   38 ++++++
 4 files changed, 243 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 65a5b7f..e295d1e 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -50,7 +50,7 @@ obj-$(CONFIG_PCMCIA_WL3501)	+= wl3501_cs.o
 obj-$(CONFIG_USB_ZD1201)	+= zd1201.o
 obj-$(CONFIG_LIBERTAS)		+= libertas/
 
-rtl8180-objs		:= rtl8180_dev.o rtl8180_rtl8225.o
+rtl8180-objs		:= rtl8180_dev.o rtl8180_rtl8225.o rtl8180_sa2400.o
 rtl8187-objs		:= rtl8187_dev.o rtl8187_rtl8225.o
 
 obj-$(CONFIG_RTL8180)	+= rtl8180.o
diff --git a/drivers/net/wireless/rtl8180_dev.c b/drivers/net/wireless/rtl8180_dev.c
index 7508eee..e1ea198 100644
--- a/drivers/net/wireless/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl8180_dev.c
@@ -24,6 +24,7 @@
 
 #include "rtl8180.h"
 #include "rtl8180_rtl8225.h"
+#include "rtl8180_sa2400.h"
 
 MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>");
 MODULE_AUTHOR("Andrea Merello <andreamrl@tiscali.it>");
@@ -31,7 +32,14 @@ MODULE_DESCRIPTION("RTL8180 / RTL8185 PCI wireless driver");
 MODULE_LICENSE("GPL");
 
 static struct pci_device_id rtl8180_table[] __devinitdata = {
+	/* rtl8185 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8185) },
+
+	/* rtl8180 */
+	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8180) },
+	{ PCI_DEVICE(0x1799, 0x6001) },
+	{ PCI_DEVICE(0x1799, 0x6020) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DLINK, 0x3300) },
 	{ }
 };
 
@@ -882,6 +890,9 @@ static int __devinit rtl8180_probe(struct pci_dev *pdev,
 		break;
 	case 3:
 		rf_name = "Philips";
+		priv->rf_init = sa2400_rf_init;
+		priv->rf_stop = sa2400_rf_stop;
+		priv->rf_set_chan = sa2400_rf_set_channel;
 		break;
 	case 4:
 		rf_name = "Maxim";
diff --git a/drivers/net/wireless/rtl8180_sa2400.c b/drivers/net/wireless/rtl8180_sa2400.c
new file mode 100644
index 0000000..dea7e5a
--- /dev/null
+++ b/drivers/net/wireless/rtl8180_sa2400.c
@@ -0,0 +1,193 @@
+
+/*
+ * Radio tuning for Philips SA2400 on RTL8180
+ *
+ * Copyright 2007 Andrea Merello <andreamrl@tiscali.it>
+ *
+ * Code from the BSD driver and the rtl8181 project have been
+ * very useful to understand certain things
+ *
+ * I want to thanks the Authors of such projects and the Ndiswrapper
+ * project Authors.
+ *
+ * A special Big Thanks also is for all people who donated me cards,
+ * making possible the creation of the original rtl8180 driver
+ * from which this code is derived!
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/delay.h>
+#include <net/mac80211.h>
+
+#include "rtl8180.h"
+#include "rtl8180_sa2400.h"
+
+static const u32 sa2400_chan[] = {
+	0x00096c, /* ch1 */
+	0x080970,
+	0x100974,
+	0x180978,
+	0x000980,
+	0x080984,
+	0x100988,
+	0x18098c,
+	0x000994,
+	0x080998,
+	0x10099c,
+	0x1809a0,
+	0x0009a8,
+	0x0009b4, /* ch 14 */
+};
+
+static void write_sa2400(struct ieee80211_hw *dev, u8 addr, u32 data)
+{
+	struct rtl8180_priv *priv = dev->priv;
+	u32 phy_config;
+
+	/* MAC will bang bits to the sa2400. sw 3-wire is NOT used */
+	phy_config = 0xb0000000;
+
+	phy_config |= ((u32)(addr & 0xf)) << 24;
+	phy_config |= data & 0xffffff;
+
+	rtl818x_iowrite32(priv,
+		(__le32 __iomem *) &priv->map->RFPinsOutput, phy_config);
+
+	msleep(3);
+}
+
+static void sa2400_write_phy_antenna(struct ieee80211_hw *dev, short chan)
+{
+	struct rtl8180_priv *priv = dev->priv;
+	u8 ant = SA2400_ANTENNA;
+
+	if (priv->rfparam & RF_PARAM_ANTBDEFAULT)
+		ant |= BB_ANTENNA_B;
+
+	if (chan == 14)
+		ant |= BB_ANTATTEN_CHAN14;
+
+	rtl8180_write_phy(dev, 0x10, ant);
+
+}
+
+void sa2400_rf_set_channel(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
+{
+	struct rtl8180_priv *priv = dev->priv;
+	u32 txpw = priv->channels[conf->channel - 1].val & 0xFF;
+	u32 chan = sa2400_chan[conf->channel - 1];
+
+	write_sa2400(dev, 7, txpw);
+
+	sa2400_write_phy_antenna(dev, chan);
+
+	write_sa2400(dev, 0, chan);
+	write_sa2400(dev, 1, 0xbb50);
+	write_sa2400(dev, 2, 0x80);
+	write_sa2400(dev, 3, 0);
+}
+
+void sa2400_rf_stop(struct ieee80211_hw *dev)
+{
+	write_sa2400(dev, 4, 0);
+}
+
+void sa2400_rf_init(struct ieee80211_hw *dev)
+{
+	struct rtl8180_priv *priv = dev->priv;
+	u32 anaparam, txconf;
+	u8 firdac;
+	int analogphy = priv->rfparam & RF_PARAM_ANALOGPHY;
+
+	anaparam = priv->anaparam;
+	anaparam &= ~(1 << ANAPARAM_TXDACOFF_SHIFT);
+	anaparam &= ~ANAPARAM_PWR1_MASK;
+	anaparam &= ~ANAPARAM_PWR0_MASK;
+
+	if (analogphy) {
+		anaparam |= SA2400_ANA_ANAPARAM_PWR1_ON << ANAPARAM_PWR1_SHIFT;
+		firdac = 0;
+	} else {
+		anaparam |= (SA2400_DIG_ANAPARAM_PWR1_ON << ANAPARAM_PWR1_SHIFT);
+		anaparam |= (SA2400_ANAPARAM_PWR0_ON << ANAPARAM_PWR0_SHIFT);
+		firdac = 1 << SA2400_REG4_FIRDAC_SHIFT;
+	}
+
+	rtl8180_set_anaparam(priv, anaparam);
+
+	write_sa2400(dev, 0, sa2400_chan[0]);
+	write_sa2400(dev, 1, 0xbb50);
+	write_sa2400(dev, 2, 0x80);
+	write_sa2400(dev, 3, 0);
+	write_sa2400(dev, 4, 0x19340 | firdac);
+	write_sa2400(dev, 5, 0x1dfb | (SA2400_MAX_SENS - 54) << 15);
+	write_sa2400(dev, 4, 0x19348 | firdac); /* calibrate VCO */
+
+	if (!analogphy)
+		write_sa2400(dev, 4, 0x1938c); /*???*/
+
+	write_sa2400(dev, 4, 0x19340 | firdac);
+
+	write_sa2400(dev, 0, sa2400_chan[0]);
+	write_sa2400(dev, 1, 0xbb50);
+	write_sa2400(dev, 2, 0x80);
+	write_sa2400(dev, 3, 0);
+	write_sa2400(dev, 4, 0x19344 | firdac); /* calibrate filter */
+
+	/* new from rtl8180 embedded driver (rtl8181 project) */
+	write_sa2400(dev, 6, 0x13ff | (1 << 23)); /* MANRX */
+	write_sa2400(dev, 8, 0); /* VCO */
+
+	if (analogphy) {
+		rtl8180_set_anaparam(priv, anaparam |
+				     (1 << ANAPARAM_TXDACOFF_SHIFT));
+
+		txconf = rtl818x_ioread32(priv, &priv->map->TX_CONF);
+		rtl818x_iowrite32(priv, &priv->map->TX_CONF,
+			txconf | RTL818X_TX_CONF_LOOPBACK_CONT);
+
+		write_sa2400(dev, 4, 0x19341); /* calibrates DC */
+
+		/* a 5us sleep is required here,
+		 * we rely on the 3ms delay introduced in write_sa2400 */
+		write_sa2400(dev, 4, 0x19345);
+
+		/* a 20us sleep is required here,
+		 * we rely on the 3ms delay introduced in write_sa2400 */
+
+		rtl818x_iowrite32(priv, &priv->map->TX_CONF, txconf);
+
+		rtl8180_set_anaparam(priv, anaparam);
+	}
+	/* end new code */
+
+	write_sa2400(dev, 4, 0x19341 | firdac); /* RTX MODE */
+
+	/* baseband configuration */
+	rtl8180_write_phy(dev, 0, 0x98);
+	rtl8180_write_phy(dev, 3, 0x38);
+	rtl8180_write_phy(dev, 4, 0xe0);
+	rtl8180_write_phy(dev, 5, 0x90);
+	rtl8180_write_phy(dev, 6, 0x1a);
+	rtl8180_write_phy(dev, 7, 0x64);
+
+	sa2400_write_phy_antenna(dev, 1);
+
+	rtl8180_write_phy(dev, 0x11, 0x80);
+
+	if (rtl818x_ioread8(priv, &priv->map->CONFIG2) &
+	    RTL818X_CONFIG2_ANTENNA_DIV)
+		rtl8180_write_phy(dev, 0x12, 0xc7); /* enable ant diversity */
+	else
+		rtl8180_write_phy(dev, 0x12, 0x47); /* disable ant diversity */
+
+	rtl8180_write_phy(dev, 0x13, 0x90 | priv->csthreshold);
+
+	rtl8180_write_phy(dev, 0x19, 0x0);
+	rtl8180_write_phy(dev, 0x1a, 0xa0);
+}
diff --git a/drivers/net/wireless/rtl8180_sa2400.h b/drivers/net/wireless/rtl8180_sa2400.h
new file mode 100644
index 0000000..018bb92
--- /dev/null
+++ b/drivers/net/wireless/rtl8180_sa2400.h
@@ -0,0 +1,38 @@
+#ifndef RTL8180_SA2400_H
+#define RTL8180_SA2400_H
+
+/*
+ * Radio tuning for Philips SA2400 on RTL8180
+ *
+ * Copyright 2007 Andrea Merello <andreamrl@tiscali.it>
+ *
+ * Code from the BSD driver and the rtl8181 project have been
+ * very useful to understand certain things
+ *
+ * I want to thanks the Authors of such projects and the Ndiswrapper
+ * project Authors.
+ *
+ * A special Big Thanks also is for all people who donated me cards,
+ * making possible the creation of the original rtl8180 driver
+ * from which this code is derived!
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#define SA2400_ANTENNA 0x91
+#define SA2400_DIG_ANAPARAM_PWR1_ON 0x8
+#define SA2400_ANA_ANAPARAM_PWR1_ON 0x28
+#define SA2400_ANAPARAM_PWR0_ON 0x3
+
+/* RX sensitivity in dbm */
+#define SA2400_MAX_SENS 85
+
+#define SA2400_REG4_FIRDAC_SHIFT 7
+
+void sa2400_rf_init(struct ieee80211_hw *);
+void sa2400_rf_stop(struct ieee80211_hw *);
+void sa2400_rf_set_channel(struct ieee80211_hw *, struct ieee80211_conf *);
+
+#endif /* RTL8180_SA2400_H */


