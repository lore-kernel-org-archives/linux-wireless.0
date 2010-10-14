Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54882 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab0JNReE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 13:34:04 -0400
Received: by mail-ew0-f46.google.com with SMTP id 20so3690881ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 10:34:03 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/4] b43: N-PHY: put 2056-radio's specific code in separated file
Date: Thu, 14 Oct 2010 19:33:37 +0200
Message-Id: <1287077617-11319-4-git-send-email-zajec5@gmail.com>
In-Reply-To: <1287077617-11319-1-git-send-email-zajec5@gmail.com>
References: <1287077617-11319-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/Makefile      |    1 +
 drivers/net/wireless/b43/phy_n.c       |    1 +
 drivers/net/wireless/b43/radio_2056.c  |   45 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/radio_2056.h  |   42 +++++++++++++++++++++++++++++
 drivers/net/wireless/b43/tables_nphy.c |   18 ------------
 drivers/net/wireless/b43/tables_nphy.h |   11 --------
 6 files changed, 89 insertions(+), 29 deletions(-)
 create mode 100644 drivers/net/wireless/b43/radio_2056.c
 create mode 100644 drivers/net/wireless/b43/radio_2056.h

diff --git a/drivers/net/wireless/b43/Makefile b/drivers/net/wireless/b43/Makefile
index 0398c7c..69d4af0 100644
--- a/drivers/net/wireless/b43/Makefile
+++ b/drivers/net/wireless/b43/Makefile
@@ -2,6 +2,7 @@ b43-y				+= main.o
 b43-y				+= tables.o
 b43-$(CONFIG_B43_NPHY)		+= tables_nphy.o
 b43-$(CONFIG_B43_NPHY)		+= radio_2055.o
+b43-$(CONFIG_B43_NPHY)		+= radio_2056.o
 b43-y				+= phy_common.o
 b43-y				+= phy_g.o
 b43-y				+= phy_a.o
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 45fa2bb..dfec549 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -30,6 +30,7 @@
 #include "phy_n.h"
 #include "tables_nphy.h"
 #include "radio_2055.h"
+#include "radio_2056.h"
 #include "main.h"
 
 struct nphy_txgains {
diff --git a/drivers/net/wireless/b43/radio_2056.c b/drivers/net/wireless/b43/radio_2056.c
new file mode 100644
index 0000000..46d2f61
--- /dev/null
+++ b/drivers/net/wireless/b43/radio_2056.c
@@ -0,0 +1,45 @@
+/*
+
+  Broadcom B43 wireless driver
+  IEEE 802.11n PHY and radio device data tables
+
+  Copyright (c) 2008 Michael Buesch <mb@bu3sch.de>
+
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of the GNU General Public License as published by
+  the Free Software Foundation; either version 2 of the License, or
+  (at your option) any later version.
+
+  This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+  GNU General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with this program; see the file COPYING.  If not, write to
+  the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
+  Boston, MA 02110-1301, USA.
+
+*/
+
+#include "b43.h"
+#include "radio_2056.h"
+#include "phy_common.h"
+
+static const struct b43_nphy_channeltab_entry_rev3 b43_nphy_channeltab_rev3[] = {
+};
+
+const struct b43_nphy_channeltab_entry_rev3 *
+b43_nphy_get_chantabent_rev3(struct b43_wldev *dev, u16 freq)
+{
+	const struct b43_nphy_channeltab_entry_rev3 *e;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(b43_nphy_channeltab_rev3); i++) {
+		e = &(b43_nphy_channeltab_rev3[i]);
+		if (e->freq == freq)
+			return e;
+	}
+
+	return NULL;
+}
diff --git a/drivers/net/wireless/b43/radio_2056.h b/drivers/net/wireless/b43/radio_2056.h
new file mode 100644
index 0000000..fda6daf
--- /dev/null
+++ b/drivers/net/wireless/b43/radio_2056.h
@@ -0,0 +1,42 @@
+/*
+
+  Broadcom B43 wireless driver
+
+  Copyright (c) 2010 Rafał Miłecki <zajec5@gmail.com>
+
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of the GNU General Public License as published by
+  the Free Software Foundation; either version 2 of the License, or
+  (at your option) any later version.
+
+  This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+  GNU General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with this program; see the file COPYING.  If not, write to
+  the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
+  Boston, MA 02110-1301, USA.
+
+*/
+
+#ifndef B43_RADIO_2056_H_
+#define B43_RADIO_2056_H_
+
+#include <linux/types.h>
+
+#include "tables_nphy.h"
+
+struct b43_nphy_channeltab_entry_rev3 {
+	/* The channel number */
+	u8 channel;
+	/* The channel frequency in MHz */
+	u16 freq;
+	/* Radio register values on channelswitch */
+	/* TODO */
+	/* PHY register values on channelswitch */
+	struct b43_phy_n_sfo_cfg phy_regs;
+};
+
+#endif /* B43_RADIO_2056_H_ */
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index cff7bd3..d7f5622 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -27,24 +27,6 @@
 #include "phy_common.h"
 #include "phy_n.h"
 
-static const struct b43_nphy_channeltab_entry_rev3 b43_nphy_channeltab_rev3[] = {
-};
-
-const struct b43_nphy_channeltab_entry_rev3 *
-b43_nphy_get_chantabent_rev3(struct b43_wldev *dev, u16 freq)
-{
-	const struct b43_nphy_channeltab_entry_rev3 *e;
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(b43_nphy_channeltab_rev3); i++) {
-		e = &(b43_nphy_channeltab_rev3[i]);
-		if (e->freq == freq)
-			return e;
-	}
-
-	return NULL;
-}
-
 static const u8 b43_ntab_adjustpower0[] = {
 	0x00, 0x00, 0x00, 0x00, 0x01, 0x01, 0x01, 0x01,
 	0x02, 0x02, 0x02, 0x02, 0x03, 0x03, 0x03, 0x03,
diff --git a/drivers/net/wireless/b43/tables_nphy.h b/drivers/net/wireless/b43/tables_nphy.h
index cb06d39..4ec593b 100644
--- a/drivers/net/wireless/b43/tables_nphy.h
+++ b/drivers/net/wireless/b43/tables_nphy.h
@@ -12,17 +12,6 @@ struct b43_phy_n_sfo_cfg {
 	u16 phy_bw6;
 };
 
-struct b43_nphy_channeltab_entry_rev3 {
-	/* The channel number */
-	u8 channel;
-	/* The channel frequency in MHz */
-	u16 freq;
-	/* Radio register values on channelswitch */
-	/* TODO */
-	/* PHY register values on channelswitch */
-	struct b43_phy_n_sfo_cfg phy_regs;
-};
-
 struct b43_wldev;
 
 struct nphy_txiqcal_ladder {
-- 
1.7.1

