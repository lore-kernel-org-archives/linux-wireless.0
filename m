Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:32747 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751174AbXLBWLO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2007 17:11:14 -0500
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 7/8] rtl8180: Add support for max2820 radio
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
Date: Sun, 02 Dec 2007 17:17:51 -0500
Message-ID: <20071202221751.7347.90406.stgit@tetra.sourmilk.net> (sfid-20071202_221128_388700_1B9D987D)
In-Reply-To: <20071202221751.7347.54891.stgit@tetra.sourmilk.net>
References: <20071202221751.7347.54891.stgit@tetra.sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrea Merello <andreamrl@tiscali.it>

This adds support for rtl8180+max2820.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: Andrea Merello <andreamrl@tiscali.it>
---

 drivers/net/wireless/Makefile          |    2 
 drivers/net/wireless/rtl8180_dev.c     |    4 +
 drivers/net/wireless/rtl8180_max2820.c |  142 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/rtl8180_max2820.h |   30 +++++++
 4 files changed, 177 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index e295d1e..75f8262 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -50,7 +50,7 @@ obj-$(CONFIG_PCMCIA_WL3501)	+= wl3501_cs.o
 obj-$(CONFIG_USB_ZD1201)	+= zd1201.o
 obj-$(CONFIG_LIBERTAS)		+= libertas/
 
-rtl8180-objs		:= rtl8180_dev.o rtl8180_rtl8225.o rtl8180_sa2400.o
+rtl8180-objs		:= rtl8180_dev.o rtl8180_rtl8225.o rtl8180_sa2400.o rtl8180_max2820.o
 rtl8187-objs		:= rtl8187_dev.o rtl8187_rtl8225.o
 
 obj-$(CONFIG_RTL8180)	+= rtl8180.o
diff --git a/drivers/net/wireless/rtl8180_dev.c b/drivers/net/wireless/rtl8180_dev.c
index e1ea198..db70604 100644
--- a/drivers/net/wireless/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl8180_dev.c
@@ -25,6 +25,7 @@
 #include "rtl8180.h"
 #include "rtl8180_rtl8225.h"
 #include "rtl8180_sa2400.h"
+#include "rtl8180_max2820.h"
 
 MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>");
 MODULE_AUTHOR("Andrea Merello <andreamrl@tiscali.it>");
@@ -896,6 +897,9 @@ static int __devinit rtl8180_probe(struct pci_dev *pdev,
 		break;
 	case 4:
 		rf_name = "Maxim";
+		priv->rf_init = max2820_rf_init;
+		priv->rf_stop = max2820_rf_stop;
+		priv->rf_set_chan = max2820_rf_set_channel;
 		break;
 	case 5:
 		rf_name = "GCT";
diff --git a/drivers/net/wireless/rtl8180_max2820.c b/drivers/net/wireless/rtl8180_max2820.c
new file mode 100644
index 0000000..c3e125f
--- /dev/null
+++ b/drivers/net/wireless/rtl8180_max2820.c
@@ -0,0 +1,142 @@
+/*
+ * Radio tuning for Maxim max2820 on RTL8180
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
+#include "rtl8180_max2820.h"
+
+u32 max2820_chan[] = {
+	12, /* CH 1 */
+	17,
+	22,
+	27,
+	32,
+	37,
+	42,
+	47,
+	52,
+	57,
+	62,
+	67,
+	72,
+	84, /* CH 14 */
+};
+
+static void write_max2820(struct ieee80211_hw *dev, u8 addr, u32 data)
+{
+	struct rtl8180_priv *priv = dev->priv;
+	u32 phy_config;
+
+	phy_config = 0x90 + (data & 0xf);
+	phy_config <<= 16;
+	phy_config += addr;
+	phy_config <<= 8;
+	phy_config += (data >> 4) & 0xff;
+
+	rtl818x_iowrite32(priv,
+		(__le32 __iomem *) &priv->map->RFPinsOutput, phy_config);
+
+	msleep(1);
+}
+
+static void max2820_write_phy_antenna(struct ieee80211_hw *dev, short chan)
+{
+	struct rtl8180_priv *priv = dev->priv;
+	u8 ant;
+
+	ant = MAXIM_ANTENNA;
+	if (priv->rfparam & RF_PARAM_ANTBDEFAULT)
+		ant |= BB_ANTENNA_B;
+	if (chan == 14)
+		ant |= BB_ANTATTEN_CHAN14;
+
+	rtl8180_write_phy(dev, 0x10, ant);
+}
+
+void max2820_rf_set_channel(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
+{
+	struct rtl8180_priv *priv = dev->priv;
+	unsigned int chan_idx = conf ? conf->channel - 1 : 0;
+	u32 txpw = priv->channels[chan_idx].val & 0xFF;
+	u32 chan = max2820_chan[chan_idx];
+
+	/* While philips SA2400 drive the PA bias from
+	 * sa2400, for MAXIM we do this directly from BB */
+	rtl8180_write_phy(dev, 3, txpw);
+
+	max2820_write_phy_antenna(dev, chan);
+	write_max2820(dev, 3, chan);
+}
+
+void max2820_rf_stop(struct ieee80211_hw *dev)
+{
+	rtl8180_write_phy(dev, 3, 0x8);
+	write_max2820(dev, 1, 0);
+}
+
+
+void max2820_rf_init(struct ieee80211_hw *dev)
+{
+	struct rtl8180_priv *priv = dev->priv;
+
+	/* MAXIM from netbsd driver */
+	write_max2820(dev, 0, 0x007); /* test mode as indicated in datasheet */
+	write_max2820(dev, 1, 0x01e); /* enable register */
+	write_max2820(dev, 2, 0x001); /* synt register */
+
+	max2820_rf_set_channel(dev, NULL);
+
+	write_max2820(dev, 4, 0x313); /* rx register */
+
+	/* PA is driven directly by the BB, we keep the MAXIM bias
+	 * at the highest value in case that setting it to lower
+	 * values may introduce some further attenuation somewhere..
+	 */
+	write_max2820(dev, 5, 0x00f);
+
+	/* baseband configuration */
+	rtl8180_write_phy(dev, 0, 0x88); /* sys1       */
+	rtl8180_write_phy(dev, 3, 0x08); /* txagc      */
+	rtl8180_write_phy(dev, 4, 0xf8); /* lnadet     */
+	rtl8180_write_phy(dev, 5, 0x90); /* ifagcinit  */
+	rtl8180_write_phy(dev, 6, 0x1a); /* ifagclimit */
+	rtl8180_write_phy(dev, 7, 0x64); /* ifagcdet   */
+
+	max2820_write_phy_antenna(dev, 1);
+
+	rtl8180_write_phy(dev, 0x11, 0x88); /* trl */
+
+	if (rtl818x_ioread8(priv, &priv->map->CONFIG2) &
+	    RTL818X_CONFIG2_ANTENNA_DIV)
+		rtl8180_write_phy(dev, 0x12, 0xc7);
+	else
+		rtl8180_write_phy(dev, 0x12, 0x47);
+
+	rtl8180_write_phy(dev, 0x13, 0x9b);
+
+	rtl8180_write_phy(dev, 0x19, 0x0);  /* CHESTLIM */
+	rtl8180_write_phy(dev, 0x1a, 0x9f); /* CHSQLIM  */
+
+	max2820_rf_set_channel(dev, NULL);
+}
diff --git a/drivers/net/wireless/rtl8180_max2820.h b/drivers/net/wireless/rtl8180_max2820.h
new file mode 100644
index 0000000..8e27292
--- /dev/null
+++ b/drivers/net/wireless/rtl8180_max2820.h
@@ -0,0 +1,30 @@
+#ifndef RTL8180_MAX2820_H
+#define RTL8180_MAX2820_H
+
+/*
+ * Radio tuning for Maxim max2820 on RTL8180
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
+#define MAXIM_ANTENNA 0xb3
+
+void max2820_rf_init(struct ieee80211_hw *);
+void max2820_rf_stop(struct ieee80211_hw *);
+void max2820_rf_set_channel(struct ieee80211_hw *, struct ieee80211_conf *);
+
+#endif /* RTL8180_MAX2820_H */


