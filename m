Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:47460 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751276AbXLRW1l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 17:27:41 -0500
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] rtl8180: add grf5101 support
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
Date: Tue, 18 Dec 2007 17:28:44 -0500
Message-ID: <20071218222844.12170.94607.stgit@tetra.sourmilk.net> (sfid-20071218_222745_834735_FD623138)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrea Merello <andreamrl@tiscali.it>

This adds support for the GCT GRF5101 rf chip to the rtl8180 driver.
There are a bunch of cards known to have this radio. This should enable them.

Signed-off-by: Andrea Merello <andreamrl@tiscali.it>
Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/Makefile          |    2 
 drivers/net/wireless/rtl8180_dev.c     |    4 +
 drivers/net/wireless/rtl8180_grf5101.c |  172 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/rtl8180_grf5101.h |   30 ++++++
 4 files changed, 207 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 5c61a7c..f88da5c 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -49,7 +49,7 @@ obj-$(CONFIG_PCMCIA_WL3501)	+= wl3501_cs.o
 obj-$(CONFIG_USB_ZD1201)	+= zd1201.o
 obj-$(CONFIG_LIBERTAS)		+= libertas/
 
-rtl8180-objs		:= rtl8180_dev.o rtl8180_rtl8225.o rtl8180_sa2400.o rtl8180_max2820.o
+rtl8180-objs		:= rtl8180_dev.o rtl8180_rtl8225.o rtl8180_sa2400.o rtl8180_max2820.o rtl8180_grf5101.o
 rtl8187-objs		:= rtl8187_dev.o rtl8187_rtl8225.o
 
 obj-$(CONFIG_RTL8180)	+= rtl8180.o
diff --git a/drivers/net/wireless/rtl8180_dev.c b/drivers/net/wireless/rtl8180_dev.c
index 49da71c..cb884bd 100644
--- a/drivers/net/wireless/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl8180_dev.c
@@ -26,6 +26,7 @@
 #include "rtl8180_rtl8225.h"
 #include "rtl8180_sa2400.h"
 #include "rtl8180_max2820.h"
+#include "rtl8180_grf5101.h"
 
 MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>");
 MODULE_AUTHOR("Andrea Merello <andreamrl@tiscali.it>");
@@ -903,6 +904,9 @@ static int __devinit rtl8180_probe(struct pci_dev *pdev,
 		break;
 	case 5:
 		rf_name = "GCT";
+		priv->rf_init = grf5101_rf_init;
+		priv->rf_stop = grf5101_rf_stop;
+		priv->rf_set_chan = grf5101_rf_set_channel;
 		break;
 	case 9:
 		if (rtl8225_is_z2(dev)) {
diff --git a/drivers/net/wireless/rtl8180_grf5101.c b/drivers/net/wireless/rtl8180_grf5101.c
new file mode 100644
index 0000000..11e80ab
--- /dev/null
+++ b/drivers/net/wireless/rtl8180_grf5101.c
@@ -0,0 +1,172 @@
+
+/*
+ * Radio tuning for GCT GRF5101 on RTL8180
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
+#include "rtl8180_grf5101.h"
+
+static const int grf5101_encode[] = {
+	0x0, 0x8, 0x4, 0xC,
+	0x2, 0xA, 0x6, 0xE,
+	0x1, 0x9, 0x5, 0xD,
+	0x3, 0xB, 0x7, 0xF
+};
+
+static void write_grf5101(struct ieee80211_hw *dev, u8 addr, u32 data)
+{
+	struct rtl8180_priv *priv = dev->priv;
+	u32 phy_config;
+
+	phy_config =  grf5101_encode[(data >> 8) & 0xF];
+	phy_config |= grf5101_encode[(data >> 4) & 0xF] << 4;
+	phy_config |= grf5101_encode[data & 0xF] << 8;
+	phy_config |= grf5101_encode[(addr >> 1) & 0xF] << 12;
+	phy_config |= (addr & 1) << 16;
+	phy_config |= grf5101_encode[(data & 0xf000) >> 12] << 24;
+
+	/* MAC will bang bits to the chip */
+	phy_config |= 0x90000000;
+
+	rtl818x_iowrite32(priv,
+		(__le32 __iomem *) &priv->map->RFPinsOutput, phy_config);
+
+	msleep(3);
+}
+
+static void grf5101_write_phy_antenna(struct ieee80211_hw *dev, short chan)
+{
+	struct rtl8180_priv *priv = dev->priv;
+	u8 ant = GRF5101_ANTENNA;
+
+	if (priv->rfparam & RF_PARAM_ANTBDEFAULT)
+		ant |= BB_ANTENNA_B;
+
+	if (chan == 14)
+		ant |= BB_ANTATTEN_CHAN14;
+
+	rtl8180_write_phy(dev, 0x10, ant);
+}
+
+void grf5101_rf_set_channel(struct ieee80211_hw *dev,
+			    struct ieee80211_conf *conf)
+{
+	struct rtl8180_priv *priv = dev->priv;
+	u32 txpw = priv->channels[conf->channel - 1].val & 0xFF;
+	u32 chan = conf->channel - 1;
+
+	/* set TX power */
+	write_grf5101(dev, 0x15, 0x0);
+	write_grf5101(dev, 0x06, txpw);
+	write_grf5101(dev, 0x15, 0x10);
+	write_grf5101(dev, 0x15, 0x0);
+
+	/* set frequency */
+	write_grf5101(dev, 0x07, 0x0);
+	write_grf5101(dev, 0x0B, chan);
+	write_grf5101(dev, 0x07, 0x1000);
+
+	grf5101_write_phy_antenna(dev, chan);
+}
+
+void grf5101_rf_stop(struct ieee80211_hw *dev)
+{
+	struct rtl8180_priv *priv = dev->priv;
+	u32 anaparam;
+
+	anaparam = priv->anaparam;
+	anaparam &= 0x000fffff;
+	anaparam |= 0x3f900000;
+	rtl8180_set_anaparam(priv, anaparam);
+
+	write_grf5101(dev, 0x07, 0x0);
+	write_grf5101(dev, 0x1f, 0x45);
+	write_grf5101(dev, 0x1f, 0x5);
+	write_grf5101(dev, 0x00, 0x8e4);
+}
+
+void grf5101_rf_init(struct ieee80211_hw *dev)
+{
+	struct rtl8180_priv *priv = dev->priv;
+
+	rtl8180_set_anaparam(priv, priv->anaparam);
+
+	write_grf5101(dev, 0x1f, 0x0);
+	write_grf5101(dev, 0x1f, 0x0);
+	write_grf5101(dev, 0x1f, 0x40);
+	write_grf5101(dev, 0x1f, 0x60);
+	write_grf5101(dev, 0x1f, 0x61);
+	write_grf5101(dev, 0x1f, 0x61);
+	write_grf5101(dev, 0x00, 0xae4);
+	write_grf5101(dev, 0x1f, 0x1);
+	write_grf5101(dev, 0x1f, 0x41);
+	write_grf5101(dev, 0x1f, 0x61);
+
+	write_grf5101(dev, 0x01, 0x1a23);
+	write_grf5101(dev, 0x02, 0x4971);
+	write_grf5101(dev, 0x03, 0x41de);
+	write_grf5101(dev, 0x04, 0x2d80);
+	write_grf5101(dev, 0x05, 0x68ff);	/* 0x61ff original value */
+	write_grf5101(dev, 0x06, 0x0);
+	write_grf5101(dev, 0x07, 0x0);
+	write_grf5101(dev, 0x08, 0x7533);
+	write_grf5101(dev, 0x09, 0xc401);
+	write_grf5101(dev, 0x0a, 0x0);
+	write_grf5101(dev, 0x0c, 0x1c7);
+	write_grf5101(dev, 0x0d, 0x29d3);
+	write_grf5101(dev, 0x0e, 0x2e8);
+	write_grf5101(dev, 0x10, 0x192);
+	write_grf5101(dev, 0x11, 0x248);
+	write_grf5101(dev, 0x12, 0x0);
+	write_grf5101(dev, 0x13, 0x20c4);
+	write_grf5101(dev, 0x14, 0xf4fc);
+	write_grf5101(dev, 0x15, 0x0);
+	write_grf5101(dev, 0x16, 0x1500);
+
+	write_grf5101(dev, 0x07, 0x1000);
+
+	/* baseband configuration */
+	rtl8180_write_phy(dev, 0, 0xa8);
+	rtl8180_write_phy(dev, 3, 0x0);
+	rtl8180_write_phy(dev, 4, 0xc0);
+	rtl8180_write_phy(dev, 5, 0x90);
+	rtl8180_write_phy(dev, 6, 0x1e);
+	rtl8180_write_phy(dev, 7, 0x64);
+
+	grf5101_write_phy_antenna(dev, 1);
+
+	rtl8180_write_phy(dev, 0x11, 0x88);
+
+	if (rtl818x_ioread8(priv, &priv->map->CONFIG2) &
+	    RTL818X_CONFIG2_ANTENNA_DIV)
+		rtl8180_write_phy(dev, 0x12, 0xc0); /* enable ant diversity */
+	else
+		rtl8180_write_phy(dev, 0x12, 0x40); /* disable ant diversity */
+
+	rtl8180_write_phy(dev, 0x13, 0x90 | priv->csthreshold);
+
+	rtl8180_write_phy(dev, 0x19, 0x0);
+	rtl8180_write_phy(dev, 0x1a, 0xa0);
+	rtl8180_write_phy(dev, 0x1b, 0x44);
+}
diff --git a/drivers/net/wireless/rtl8180_grf5101.h b/drivers/net/wireless/rtl8180_grf5101.h
new file mode 100644
index 0000000..5b4a171
--- /dev/null
+++ b/drivers/net/wireless/rtl8180_grf5101.h
@@ -0,0 +1,30 @@
+#ifndef RTL8180_GRF5101_H
+#define RTL8180_GRF5101_H
+
+/*
+ * Radio tuning for GCT GRF5101 on RTL8180
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
+#define GRF5101_ANTENNA 0xA3
+
+void grf5101_rf_init(struct ieee80211_hw *);
+void grf5101_rf_stop(struct ieee80211_hw *);
+void grf5101_rf_set_channel(struct ieee80211_hw *, struct ieee80211_conf *);
+
+#endif /* RTL8180_GRF5101_H */


