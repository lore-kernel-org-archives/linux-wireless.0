Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60055 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbbAYRCV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 12:02:21 -0500
Received: by mail-wi0-f178.google.com with SMTP id em10so5677539wid.5
        for <linux-wireless@vger.kernel.org>; Sun, 25 Jan 2015 09:02:20 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org, Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: AC-PHY: prepare place for developing new PHY support
Date: Sun, 25 Jan 2015 18:01:37 +0100
Message-Id: <1422205297-24767-1-git-send-email-zajec5@gmail.com> (sfid-20150125_180230_538081_9BE81F94)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are new (not anymore?) Broadcom 802.11ac wireless cards based on
chipsets like BCM4352 and BCM4360. They use a new PHY type (called
simply AC) that will require new specific code.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
Kalle: as this commit & Kconfig say, this is just a beginning of new PHY type
support.
In the past we used development model this patch follows. Code for new PHY was
added patch by patch.
Adding everything at once would require a huge patchset & development behing the
doors. Also sending small patches allows better review of changes & should
result in a better code quality.
Let me know if there are any problems.
---
 drivers/net/wireless/b43/Kconfig      |  9 ++++
 drivers/net/wireless/b43/Makefile     |  1 +
 drivers/net/wireless/b43/main.c       | 10 ++++
 drivers/net/wireless/b43/phy_ac.c     | 92 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/phy_ac.h     | 38 +++++++++++++++
 drivers/net/wireless/b43/phy_common.c |  9 +++-
 drivers/net/wireless/b43/phy_common.h |  2 +
 7 files changed, 160 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/b43/phy_ac.c
 create mode 100644 drivers/net/wireless/b43/phy_ac.h

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 64a5b67..759fb8d 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -166,6 +166,15 @@ config B43_PHY_LCN
 
 	  Say N, this is BROKEN and crashes driver.
 
+config B43_PHY_AC
+	bool "Support for AC-PHY (802.11ac) devices (BROKEN)"
+	depends on B43 && B43_BCMA && BROKEN
+	---help---
+	  This PHY type can be found in the following chipsets:
+	  PCI: BCM4352, BCM4360
+
+	  Say N, this is BROKEN and crashes driver.
+
 # This config option automatically enables b43 LEDS support,
 # if it's possible.
 config B43_LEDS
diff --git a/drivers/net/wireless/b43/Makefile b/drivers/net/wireless/b43/Makefile
index 9f7965a..c624d4d 100644
--- a/drivers/net/wireless/b43/Makefile
+++ b/drivers/net/wireless/b43/Makefile
@@ -13,6 +13,7 @@ b43-$(CONFIG_B43_PHY_HT)	+= phy_ht.o
 b43-$(CONFIG_B43_PHY_HT)	+= tables_phy_ht.o
 b43-$(CONFIG_B43_PHY_HT)	+= radio_2059.o
 b43-$(CONFIG_B43_PHY_LCN)	+= phy_lcn.o tables_phy_lcn.o
+b43-$(CONFIG_B43_PHY_AC)	+= phy_ac.o
 b43-y				+= sysfs.o
 b43-y				+= xmit.o
 b43-y				+= dma.o
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 753e9b0..edf535e 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4523,6 +4523,12 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 			unsupported = 1;
 		break;
 #endif
+#ifdef CONFIG_B43_PHY_AC
+	case B43_PHYTYPE_AC:
+		if (phy_rev > 1)
+			unsupported = 1;
+		break;
+#endif
 	default:
 		unsupported = 1;
 	}
@@ -4619,6 +4625,10 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 		if (radio_id != 0x2064)
 			unsupported = 1;
 		break;
+	case B43_PHYTYPE_AC:
+		if (radio_id != 0x2069)
+			unsupported = 1;
+		break;
 	default:
 		B43_WARN_ON(1);
 	}
diff --git a/drivers/net/wireless/b43/phy_ac.c b/drivers/net/wireless/b43/phy_ac.c
new file mode 100644
index 0000000..e75633d
--- /dev/null
+++ b/drivers/net/wireless/b43/phy_ac.c
@@ -0,0 +1,92 @@
+/*
+ * Broadcom B43 wireless driver
+ * IEEE 802.11ac AC-PHY support
+ *
+ * Copyright (c) 2015 Rafał Miłecki <zajec5@gmail.com>
+ *
+ * This program is free software; you can redistribute	it and/or modify it
+ * under  the terms of	the GNU General	 Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include "b43.h"
+#include "phy_ac.h"
+
+/**************************************************
+ * Basic PHY ops
+ **************************************************/
+
+static int b43_phy_ac_op_allocate(struct b43_wldev *dev)
+{
+	struct b43_phy_ac *phy_ac;
+
+	phy_ac = kzalloc(sizeof(*phy_ac), GFP_KERNEL);
+	if (!phy_ac)
+		return -ENOMEM;
+	dev->phy.ac = phy_ac;
+
+	return 0;
+}
+
+static void b43_phy_ac_op_free(struct b43_wldev *dev)
+{
+	struct b43_phy *phy = &dev->phy;
+	struct b43_phy_ac *phy_ac = phy->ac;
+
+	kfree(phy_ac);
+	phy->ac = NULL;
+}
+
+static void b43_phy_ac_op_maskset(struct b43_wldev *dev, u16 reg, u16 mask,
+				  u16 set)
+{
+	b43_write16f(dev, B43_MMIO_PHY_CONTROL, reg);
+	b43_write16(dev, B43_MMIO_PHY_DATA,
+		    (b43_read16(dev, B43_MMIO_PHY_DATA) & mask) | set);
+}
+
+static u16 b43_phy_ac_op_radio_read(struct b43_wldev *dev, u16 reg)
+{
+	b43_write16f(dev, B43_MMIO_RADIO24_CONTROL, reg);
+	return b43_read16(dev, B43_MMIO_RADIO24_DATA);
+}
+
+static void b43_phy_ac_op_radio_write(struct b43_wldev *dev, u16 reg,
+				      u16 value)
+{
+	b43_write16f(dev, B43_MMIO_RADIO24_CONTROL, reg);
+	b43_write16(dev, B43_MMIO_RADIO24_DATA, value);
+}
+
+static unsigned int b43_phy_ac_op_get_default_chan(struct b43_wldev *dev)
+{
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+		return 11;
+	return 36;
+}
+
+static enum b43_txpwr_result
+b43_phy_ac_op_recalc_txpower(struct b43_wldev *dev, bool ignore_tssi)
+{
+	return B43_TXPWR_RES_DONE;
+}
+
+static void b43_phy_ac_op_adjust_txpower(struct b43_wldev *dev)
+{
+}
+
+/**************************************************
+ * PHY ops struct
+ **************************************************/
+
+const struct b43_phy_operations b43_phyops_ac = {
+	.allocate		= b43_phy_ac_op_allocate,
+	.free			= b43_phy_ac_op_free,
+	.phy_maskset		= b43_phy_ac_op_maskset,
+	.radio_read		= b43_phy_ac_op_radio_read,
+	.radio_write		= b43_phy_ac_op_radio_write,
+	.get_default_chan	= b43_phy_ac_op_get_default_chan,
+	.recalc_txpower		= b43_phy_ac_op_recalc_txpower,
+	.adjust_txpower		= b43_phy_ac_op_adjust_txpower,
+};
diff --git a/drivers/net/wireless/b43/phy_ac.h b/drivers/net/wireless/b43/phy_ac.h
new file mode 100644
index 0000000..d1ca79e
--- /dev/null
+++ b/drivers/net/wireless/b43/phy_ac.h
@@ -0,0 +1,38 @@
+#ifndef B43_PHY_AC_H_
+#define B43_PHY_AC_H_
+
+#include "phy_common.h"
+
+#define B43_PHY_AC_BBCFG			0x001
+#define  B43_PHY_AC_BBCFG_RSTCCA		0x4000	/* Reset CCA */
+#define B43_PHY_AC_BANDCTL			0x003	/* Band control */
+#define  B43_PHY_AC_BANDCTL_5GHZ		0x0001
+#define B43_PHY_AC_TABLE_ID			0x00d
+#define B43_PHY_AC_TABLE_OFFSET			0x00e
+#define B43_PHY_AC_TABLE_DATA1			0x00f
+#define B43_PHY_AC_TABLE_DATA2			0x010
+#define B43_PHY_AC_TABLE_DATA3			0x011
+#define B43_PHY_AC_CLASSCTL			0x140	/* Classifier control */
+#define  B43_PHY_AC_CLASSCTL_CCKEN		0x0001	/* CCK enable */
+#define  B43_PHY_AC_CLASSCTL_OFDMEN		0x0002	/* OFDM enable */
+#define  B43_PHY_AC_CLASSCTL_WAITEDEN		0x0004	/* Waited enable */
+#define B43_PHY_AC_BW1A				0x371
+#define B43_PHY_AC_BW2				0x372
+#define B43_PHY_AC_BW3				0x373
+#define B43_PHY_AC_BW4				0x374
+#define B43_PHY_AC_BW5				0x375
+#define B43_PHY_AC_BW6				0x376
+#define B43_PHY_AC_RFCTL_CMD			0x408
+#define B43_PHY_AC_C1_CLIP			0x6d4
+#define  B43_PHY_AC_C1_CLIP_DIS			0x4000
+#define B43_PHY_AC_C2_CLIP			0x8d4
+#define  B43_PHY_AC_C2_CLIP_DIS			0x4000
+#define B43_PHY_AC_C3_CLIP			0xad4
+#define  B43_PHY_AC_C3_CLIP_DIS			0x4000
+
+struct b43_phy_ac {
+};
+
+extern const struct b43_phy_operations b43_phyops_ac;
+
+#endif /* B43_PHY_AC_H_ */
diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index ee27b06..ec2b9c5 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -33,6 +33,7 @@
 #include "phy_lp.h"
 #include "phy_ht.h"
 #include "phy_lcn.h"
+#include "phy_ac.h"
 #include "b43.h"
 #include "main.h"
 
@@ -70,6 +71,11 @@ int b43_phy_allocate(struct b43_wldev *dev)
 		phy->ops = &b43_phyops_lcn;
 #endif
 		break;
+	case B43_PHYTYPE_AC:
+#ifdef CONFIG_B43_PHY_AC
+		phy->ops = &b43_phyops_ac;
+#endif
+		break;
 	}
 	if (B43_WARN_ON(!phy->ops))
 		return -ENODEV;
@@ -572,7 +578,8 @@ void b43_phy_force_clock(struct b43_wldev *dev, bool force)
 	u32 tmp;
 
 	WARN_ON(dev->phy.type != B43_PHYTYPE_N &&
-		dev->phy.type != B43_PHYTYPE_HT);
+		dev->phy.type != B43_PHYTYPE_HT &&
+		dev->phy.type != B43_PHYTYPE_AC);
 
 	switch (dev->dev->bus_type) {
 #ifdef CONFIG_B43_BCMA
diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
index 3912274..78d8652 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -222,6 +222,8 @@ struct b43_phy {
 		struct b43_phy_ht *ht;
 		/* LCN-PHY specific information */
 		struct b43_phy_lcn *lcn;
+		/* AC-PHY specific information */
+		struct b43_phy_ac *ac;
 	};
 
 	/* Band support flags. */
-- 
1.8.4.5

