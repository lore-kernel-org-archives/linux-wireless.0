Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33823 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab1FSJjG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 05:39:06 -0400
Received: by eyx24 with SMTP id 24so247938eyx.19
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jun 2011 02:39:04 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/3] b43: HT-PHY: define standard structs for channel switching
Date: Sun, 19 Jun 2011 12:17:19 +0200
Message-Id: <1308478641-6207-1-git-send-email-zajec5@gmail.com> (sfid-20110619_113922_615711_80087778)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/Makefile     |    1 +
 drivers/net/wireless/b43/phy_ht.c     |    1 +
 drivers/net/wireless/b43/phy_ht.h     |    6 ++++++
 drivers/net/wireless/b43/radio_2059.c |   30 ++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/radio_2059.h |   21 +++++++++++++++++++++
 5 files changed, 59 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/b43/radio_2059.c
 create mode 100644 drivers/net/wireless/b43/radio_2059.h

diff --git a/drivers/net/wireless/b43/Makefile b/drivers/net/wireless/b43/Makefile
index 58d614a..900dc9c 100644
--- a/drivers/net/wireless/b43/Makefile
+++ b/drivers/net/wireless/b43/Makefile
@@ -11,6 +11,7 @@ b43-$(CONFIG_B43_PHY_N)		+= phy_n.o
 b43-$(CONFIG_B43_PHY_LP)	+= phy_lp.o
 b43-$(CONFIG_B43_PHY_LP)	+= tables_lpphy.o
 b43-$(CONFIG_B43_PHY_HT)	+= phy_ht.o
+b43-$(CONFIG_B43_PHY_HT)	+= radio_2059.o
 b43-y				+= sysfs.o
 b43-y				+= xmit.o
 b43-y				+= lo.o
diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 008c1a9..763dbb0 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -24,6 +24,7 @@
 
 #include "b43.h"
 #include "phy_ht.h"
+#include "radio_2059.h"
 #include "main.h"
 
 /**************************************************
diff --git a/drivers/net/wireless/b43/phy_ht.h b/drivers/net/wireless/b43/phy_ht.h
index e16d4bb..afa448d 100644
--- a/drivers/net/wireless/b43/phy_ht.h
+++ b/drivers/net/wireless/b43/phy_ht.h
@@ -18,6 +18,12 @@
 #define B43_PHY_HT_AFE_CTL6			B43_PHY_EXTG(0x119)
 
 
+/* Values for PHY registers used on channel switching */
+struct b43_phy_ht_channeltab_e_phy {
+	/* TODO */
+};
+
+
 struct b43_phy_ht {
 };
 
diff --git a/drivers/net/wireless/b43/radio_2059.c b/drivers/net/wireless/b43/radio_2059.c
new file mode 100644
index 0000000..55d7da7
--- /dev/null
+++ b/drivers/net/wireless/b43/radio_2059.c
@@ -0,0 +1,30 @@
+/*
+
+  Broadcom B43 wireless driver
+  IEEE 802.11n 2059 radio device data tables
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
+#include "radio_2059.h"
+
+const struct b43_phy_ht_channeltab_e_radio2059
+*b43_phy_ht_get_channeltab_e_r2059(struct b43_wldev *dev, u16 freq)
+{
+	return NULL;
+}
diff --git a/drivers/net/wireless/b43/radio_2059.h b/drivers/net/wireless/b43/radio_2059.h
new file mode 100644
index 0000000..69eb46e
--- /dev/null
+++ b/drivers/net/wireless/b43/radio_2059.h
@@ -0,0 +1,21 @@
+#ifndef B43_RADIO_2059_H_
+#define B43_RADIO_2059_H_
+
+#include <linux/types.h>
+
+#include "phy_ht.h"
+
+/* Values for various registers uploaded on channel switching */
+struct b43_phy_ht_channeltab_e_radio2059 {
+	/* The channel frequency in MHz */
+	u16 freq;
+	/* Values for radio registers */
+	/* TODO */
+	/* Values for PHY registers */
+	struct b43_phy_ht_channeltab_e_phy phy_regs;
+};
+
+const struct b43_phy_ht_channeltab_e_radio2059
+*b43_phy_ht_get_channeltab_e_r2059(struct b43_wldev *dev, u16 freq);
+
+#endif /* B43_RADIO_2059_H_ */
-- 
1.7.3.4

