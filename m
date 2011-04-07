Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41690 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab1DGWJd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 18:09:33 -0400
Received: by ewy4 with SMTP id 4so934047ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2011 15:09:32 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [RFC][PATCH] b43: add bus abstraction layer
Date: Fri,  8 Apr 2011 00:46:50 +0200
Message-Id: <1302216410-1885-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/Makefile |    1 +
 drivers/net/wireless/b43/b43.h    |   11 ++++--
 drivers/net/wireless/b43/bus.c    |   59 +++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/bus.h    |   13 ++++++++
 drivers/net/wireless/b43/main.c   |    1 +
 5 files changed, 81 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/wireless/b43/bus.c
 create mode 100644 drivers/net/wireless/b43/bus.h

diff --git a/drivers/net/wireless/b43/Makefile b/drivers/net/wireless/b43/Makefile
index cef334a..95f7c00 100644
--- a/drivers/net/wireless/b43/Makefile
+++ b/drivers/net/wireless/b43/Makefile
@@ -1,4 +1,5 @@
 b43-y				+= main.o
+b43-y				+= bus.o
 b43-y				+= tables.o
 b43-$(CONFIG_B43_PHY_N)		+= tables_nphy.o
 b43-$(CONFIG_B43_PHY_N)		+= radio_2055.o
diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index bd4cb75..d137c64 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -12,6 +12,7 @@
 #include "leds.h"
 #include "rfkill.h"
 #include "lo.h"
+#include "bus.h"
 #include "phy_common.h"
 
 
@@ -774,6 +775,8 @@ struct b43_wldev {
 
 /* Data structure for the WLAN parts (802.11 cores) of the b43 chip. */
 struct b43_wl {
+	/* Bus abstraction */
+	const struct b43_bus_ops *bus_ops;
 	/* Pointer to the active wireless device on this chip */
 	struct b43_wldev *current_dev;
 	/* Pointer to the ieee80211 hardware data structure */
@@ -879,22 +882,22 @@ static inline enum ieee80211_band b43_current_band(struct b43_wl *wl)
 
 static inline u16 b43_read16(struct b43_wldev *dev, u16 offset)
 {
-	return ssb_read16(dev->dev, offset);
+	return dev->wl->bus_ops->read16(dev, offset);
 }
 
 static inline void b43_write16(struct b43_wldev *dev, u16 offset, u16 value)
 {
-	ssb_write16(dev->dev, offset, value);
+	dev->wl->bus_ops->write16(dev, offset, value);
 }
 
 static inline u32 b43_read32(struct b43_wldev *dev, u16 offset)
 {
-	return ssb_read32(dev->dev, offset);
+	return dev->wl->bus_ops->read32(dev, offset);
 }
 
 static inline void b43_write32(struct b43_wldev *dev, u16 offset, u32 value)
 {
-	ssb_write32(dev->dev, offset, value);
+	dev->wl->bus_ops->write32(dev, offset, value);
 }
 
 static inline bool b43_using_pio_transfers(struct b43_wldev *dev)
diff --git a/drivers/net/wireless/b43/bus.c b/drivers/net/wireless/b43/bus.c
new file mode 100644
index 0000000..fbad27d
--- /dev/null
+++ b/drivers/net/wireless/b43/bus.c
@@ -0,0 +1,59 @@
+/*
+
+  Broadcom B43 wireless driver
+  Bus abstraction layer
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
+#include "bus.h"
+
+/* SSB */
+
+static inline u16 b43_bus_ssb_read16(struct b43_wldev *dev, u16 offset)
+{
+	return ssb_read16(dev->dev, offset);
+}
+
+static inline u32 b43_bus_ssb_read32(struct b43_wldev *dev, u16 offset)
+{
+	return ssb_read32(dev->dev, offset);
+}
+
+static inline void b43_bus_ssb_write16(struct b43_wldev *dev, u16 offset, u16 value)
+{
+	ssb_write16(dev->dev, offset, value);
+}
+
+static inline void b43_bus_ssb_write32(struct b43_wldev *dev, u16 offset, u32 value)
+{
+	ssb_write32(dev->dev, offset, value);
+}
+
+static const struct b43_bus_ops b43_bus_ssb_ops = {
+	.read16		= b43_bus_ssb_read16,
+	.read32		= b43_bus_ssb_read32,
+	.write16	= b43_bus_ssb_write16,
+	.write32	= b43_bus_ssb_write32,
+
+};
+
+void b43_bus_ssb_init(struct b43_wl *wl)
+{
+	wl->bus_ops = &b43_bus_ssb_ops;
+}
diff --git a/drivers/net/wireless/b43/bus.h b/drivers/net/wireless/b43/bus.h
new file mode 100644
index 0000000..d1c55c4
--- /dev/null
+++ b/drivers/net/wireless/b43/bus.h
@@ -0,0 +1,13 @@
+#ifndef B43_BUS_H_
+#define B43_BUS_H_
+
+struct b43_bus_ops {
+	u16 (*read16)(struct b43_wldev *dev, u16 offset);
+	u32 (*read32)(struct b43_wldev *dev, u16 offset);
+	void (*write16)(struct b43_wldev *dev, u16 offset, u16 value);
+	void (*write32)(struct b43_wldev *dev, u16 offset, u32 value);
+};
+
+void b43_bus_ssb_init(struct b43_wl *wl);
+
+#endif /* B43_BUS_H_ */
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 57eb5b6..906dfe6 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4985,6 +4985,7 @@ static int b43_wireless_init(struct ssb_device *dev)
 
 	/* Initialize struct b43_wl */
 	wl->hw = hw;
+	b43_bus_ssb_init(wl);
 	mutex_init(&wl->mutex);
 	spin_lock_init(&wl->hardirq_lock);
 	INIT_LIST_HEAD(&wl->devlist);
-- 
1.7.3.4

