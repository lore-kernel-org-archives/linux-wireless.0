Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:45968 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab1GGMrB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2011 08:47:01 -0400
Received: by fxd18 with SMTP id 18so1059921fxd.11
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jul 2011 05:47:00 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: LCN-PHY add place for new PHY support
Date: Thu,  7 Jul 2011 15:25:27 +0200
Message-Id: <1310045127-9505-1-git-send-email-zajec5@gmail.com> (sfid-20110707_144713_478671_20A50317)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

LCN-PHY was found in 14e4:4727 card. It uses LCN/1 and 0x2064/1 radio.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/Kconfig          |    8 ++++
 drivers/net/wireless/b43/Makefile         |    1 +
 drivers/net/wireless/b43/main.c           |   10 +++++
 drivers/net/wireless/b43/phy_lcn.c        |   52 +++++++++++++++++++++++++++++
 drivers/net/wireless/b43/phy_lcn.h        |   14 ++++++++
 drivers/net/wireless/b43/tables_phy_lcn.c |   34 +++++++++++++++++++
 drivers/net/wireless/b43/tables_phy_lcn.h |    6 +++
 7 files changed, 125 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/b43/phy_lcn.c
 create mode 100644 drivers/net/wireless/b43/phy_lcn.h
 create mode 100644 drivers/net/wireless/b43/tables_phy_lcn.c
 create mode 100644 drivers/net/wireless/b43/tables_phy_lcn.h

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 17f9dab..b2892ea 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -131,6 +131,14 @@ config B43_PHY_HT
 
 	  Say N, this is BROKEN and crashes driver.
 
+config B43_PHY_LCN
+	bool "Support for LCN-PHY devices (BROKEN)"
+	depends on B43 && BROKEN
+	---help---
+	  Support for the LCN-PHY.
+
+	  Say N, this is BROKEN and crashes driver.
+
 # This config option automatically enables b43 LEDS support,
 # if it's possible.
 config B43_LEDS
diff --git a/drivers/net/wireless/b43/Makefile b/drivers/net/wireless/b43/Makefile
index 1b25604..4648bbf 100644
--- a/drivers/net/wireless/b43/Makefile
+++ b/drivers/net/wireless/b43/Makefile
@@ -13,6 +13,7 @@ b43-$(CONFIG_B43_PHY_LP)	+= tables_lpphy.o
 b43-$(CONFIG_B43_PHY_HT)	+= phy_ht.o
 b43-$(CONFIG_B43_PHY_HT)	+= tables_phy_ht.o
 b43-$(CONFIG_B43_PHY_HT)	+= radio_2059.o
+b43-$(CONFIG_B43_PHY_LCN)	+= phy_lcn.o tables_phy_lcn.o
 b43-y				+= sysfs.o
 b43-y				+= xmit.o
 b43-y				+= lo.o
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 05f6728..ef64628 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4205,6 +4205,12 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 			unsupported = 1;
 		break;
 #endif
+#ifdef CONFIG_B43_PHY_LCN
+	case B43_PHYTYPE_LCN:
+		if (phy_rev > 1)
+			unsupported = 1;
+		break;
+#endif
 	default:
 		unsupported = 1;
 	};
@@ -4285,6 +4291,10 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 		if (radio_ver != 0x2059)
 			unsupported = 1;
 		break;
+	case B43_PHYTYPE_LCN:
+		if (radio_ver != 0x2064)
+			unsupported = 1;
+		break;
 	default:
 		B43_WARN_ON(1);
 	}
diff --git a/drivers/net/wireless/b43/phy_lcn.c b/drivers/net/wireless/b43/phy_lcn.c
new file mode 100644
index 0000000..9f7dbbd
--- /dev/null
+++ b/drivers/net/wireless/b43/phy_lcn.c
@@ -0,0 +1,52 @@
+/*
+
+  Broadcom B43 wireless driver
+  IEEE 802.11n LCN-PHY support
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
+#include <linux/slab.h>
+
+#include "b43.h"
+#include "phy_lcn.h"
+#include "tables_phy_lcn.h"
+#include "main.h"
+
+/**************************************************
+ * PHY ops struct.
+ **************************************************/
+
+const struct b43_phy_operations b43_phyops_lcn = {
+	/*
+	.allocate		= b43_phy_lcn_op_allocate,
+	.free			= b43_phy_lcn_op_free,
+	.prepare_structs	= b43_phy_lcn_op_prepare_structs,
+	.init			= b43_phy_lcn_op_init,
+	.phy_read		= b43_phy_lcn_op_read,
+	.phy_write		= b43_phy_lcn_op_write,
+	.phy_maskset		= b43_phy_lcn_op_maskset,
+	.radio_read		= b43_phy_lcn_op_radio_read,
+	.radio_write		= b43_phy_lcn_op_radio_write,
+	.software_rfkill	= b43_phy_lcn_op_software_rfkill,
+	.switch_analog		= b43_phy_lcn_op_switch_analog,
+	.switch_channel		= b43_phy_lcn_op_switch_channel,
+	.get_default_chan	= b43_phy_lcn_op_get_default_chan,
+	.recalc_txpower		= b43_phy_lcn_op_recalc_txpower,
+	.adjust_txpower		= b43_phy_lcn_op_adjust_txpower,
+	*/
+};
diff --git a/drivers/net/wireless/b43/phy_lcn.h b/drivers/net/wireless/b43/phy_lcn.h
new file mode 100644
index 0000000..c046c2a
--- /dev/null
+++ b/drivers/net/wireless/b43/phy_lcn.h
@@ -0,0 +1,14 @@
+#ifndef B43_PHY_LCN_H_
+#define B43_PHY_LCN_H_
+
+#include "phy_common.h"
+
+
+struct b43_phy_lcn {
+};
+
+
+struct b43_phy_operations;
+extern const struct b43_phy_operations b43_phyops_lcn;
+
+#endif /* B43_PHY_LCN_H_ */
\ No newline at end of file
diff --git a/drivers/net/wireless/b43/tables_phy_lcn.c b/drivers/net/wireless/b43/tables_phy_lcn.c
new file mode 100644
index 0000000..40c1d09
--- /dev/null
+++ b/drivers/net/wireless/b43/tables_phy_lcn.c
@@ -0,0 +1,34 @@
+/*
+
+  Broadcom B43 wireless driver
+  IEEE 802.11n LCN-PHY data tables
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
+#include "tables_phy_lcn.h"
+#include "phy_common.h"
+#include "phy_lcn.h"
+
+/**************************************************
+ * Tables ops.
+ **************************************************/
+
+void b43_phy_lcn_tables_init(struct b43_wldev *dev)
+{
+}
diff --git a/drivers/net/wireless/b43/tables_phy_lcn.h b/drivers/net/wireless/b43/tables_phy_lcn.h
new file mode 100644
index 0000000..5e31b15
--- /dev/null
+++ b/drivers/net/wireless/b43/tables_phy_lcn.h
@@ -0,0 +1,6 @@
+#ifndef B43_TABLES_PHY_LCN_H_
+#define B43_TABLES_PHY_LCN_H_
+
+void b43_phy_lcn_tables_init(struct b43_wldev *dev);
+
+#endif /* B43_TABLES_PHY_LCN_H_ */
-- 
1.7.3.4

