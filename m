Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:32866 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab1EIJFt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 05:05:49 -0400
Received: by eyx24 with SMTP id 24so1473428eyx.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 02:05:47 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [RFC ONLY 2/5] b43: add bus device abstraction later
Date: Mon,  9 May 2011 11:43:18 +0200
Message-Id: <1304934201-10626-2-git-send-email-zajec5@gmail.com> (sfid-20110509_110554_484709_113E11D9)
In-Reply-To: <1304934201-10626-1-git-send-email-zajec5@gmail.com>
References: <1304934201-10626-1-git-send-email-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is not really used or complete yet.
---
 drivers/net/wireless/b43/Makefile |    1 +
 drivers/net/wireless/b43/b43.h    |    4 +++-
 drivers/net/wireless/b43/bus.c    |   36 ++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/bus.h    |   17 +++++++++++++++++
 drivers/net/wireless/b43/main.c   |   28 ++++++++++++++++------------
 5 files changed, 73 insertions(+), 13 deletions(-)
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
index 1be9420..8c8ae1e 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -11,6 +11,7 @@
 #include "debugfs.h"
 #include "leds.h"
 #include "rfkill.h"
+#include "bus.h"
 #include "lo.h"
 #include "phy_common.h"
 
@@ -705,7 +706,8 @@ enum {
 
 /* Data structure for one wireless device (802.11 core) */
 struct b43_wldev {
-	struct ssb_device *sdev;
+	struct ssb_device *sdev; /* TODO: remove when b43_bus_dev is ready */
+	struct b43_bus_dev *dev;
 	struct b43_wl *wl;
 
 	/* The device initialization status.
diff --git a/drivers/net/wireless/b43/bus.c b/drivers/net/wireless/b43/bus.c
new file mode 100644
index 0000000..f8ccd2c
--- /dev/null
+++ b/drivers/net/wireless/b43/bus.c
@@ -0,0 +1,36 @@
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
+
+/* SSB */
+struct b43_bus_dev *b43_bus_dev_ssb_init(struct ssb_device *sdev)
+{
+	struct b43_bus_dev *dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+
+	dev->bus_type = B43_BUS_SSB;
+	dev->sdev = sdev;
+
+	return dev;
+}
diff --git a/drivers/net/wireless/b43/bus.h b/drivers/net/wireless/b43/bus.h
new file mode 100644
index 0000000..68bc00a
--- /dev/null
+++ b/drivers/net/wireless/b43/bus.h
@@ -0,0 +1,17 @@
+#ifndef B43_BUS_H_
+#define B43_BUS_H_
+
+enum b43_bus_type {
+	B43_BUS_SSB,
+};
+
+struct b43_bus_dev {
+	enum b43_bus_type bus_type;
+	union {
+		struct ssb_device *sdev;
+	};
+};
+
+struct b43_bus_dev *b43_bus_dev_ssb_init(struct ssb_device *sdev);
+
+#endif /* B43_BUS_H_ */
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 4c4298f..dc7ca44 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4816,7 +4816,7 @@ err_powerdown:
 	return err;
 }
 
-static void b43_one_core_detach(struct ssb_device *dev)
+static void b43_one_core_detach(struct b43_bus_dev *dev)
 {
 	struct b43_wldev *wldev;
 	struct b43_wl *wl;
@@ -4824,17 +4824,17 @@ static void b43_one_core_detach(struct ssb_device *dev)
 	/* Do not cancel ieee80211-workqueue based work here.
 	 * See comment in b43_remove(). */
 
-	wldev = ssb_get_drvdata(dev);
+	wldev = ssb_get_drvdata(dev->sdev);
 	wl = wldev->wl;
 	b43_debugfs_remove_device(wldev);
 	b43_wireless_core_detach(wldev);
 	list_del(&wldev->list);
 	wl->nr_devs--;
-	ssb_set_drvdata(dev, NULL);
+	ssb_set_drvdata(dev->sdev, NULL);
 	kfree(wldev);
 }
 
-static int b43_one_core_attach(struct ssb_device *dev, struct b43_wl *wl)
+static int b43_one_core_attach(struct b43_bus_dev *dev, struct b43_wl *wl)
 {
 	struct b43_wldev *wldev;
 	int err = -ENOMEM;
@@ -4844,7 +4844,8 @@ static int b43_one_core_attach(struct ssb_device *dev, struct b43_wl *wl)
 		goto out;
 
 	wldev->use_pio = b43_modparam_pio;
-	wldev->sdev = dev;
+	wldev->dev = dev;
+	wldev->sdev = dev->sdev; /* TODO: Remove when not needed */
 	wldev->wl = wl;
 	b43_set_status(wldev, B43_STAT_UNINIT);
 	wldev->bad_frames_preempt = modparam_bad_frames_preempt;
@@ -4856,7 +4857,7 @@ static int b43_one_core_attach(struct ssb_device *dev, struct b43_wl *wl)
 
 	list_add(&wldev->list, &wl->devlist);
 	wl->nr_devs++;
-	ssb_set_drvdata(dev, wldev);
+	ssb_set_drvdata(dev->sdev, wldev);
 	b43_debugfs_add_device(wldev);
 
       out:
@@ -4959,20 +4960,23 @@ out:
 	return err;
 }
 
-static int b43_ssb_probe(struct ssb_device *dev, const struct ssb_device_id *id)
+static int b43_ssb_probe(struct ssb_device *sdev, const struct ssb_device_id *id)
 {
+	struct b43_bus_dev *dev;
 	struct b43_wl *wl;
 	int err;
 	int first = 0;
 
-	wl = ssb_get_devtypedata(dev);
+	dev = b43_bus_dev_ssb_init(sdev);
+
+	wl = ssb_get_devtypedata(sdev);
 	if (!wl) {
 		/* Probing the first core. Must setup common struct b43_wl */
 		first = 1;
-		err = b43_wireless_init(dev);
+		err = b43_wireless_init(sdev);
 		if (err)
 			goto out;
-		wl = ssb_get_devtypedata(dev);
+		wl = ssb_get_devtypedata(sdev);
 		B43_WARN_ON(!wl);
 	}
 	err = b43_one_core_attach(dev, wl);
@@ -4993,7 +4997,7 @@ static int b43_ssb_probe(struct ssb_device *dev, const struct ssb_device_id *id)
 	b43_one_core_detach(dev);
       err_wireless_exit:
 	if (first)
-		b43_wireless_exit(dev, wl);
+		b43_wireless_exit(sdev, wl);
 	return err;
 }
 
@@ -5016,7 +5020,7 @@ static void b43_ssb_remove(struct ssb_device *dev)
 		ieee80211_unregister_hw(wl->hw);
 	}
 
-	b43_one_core_detach(dev);
+	b43_one_core_detach(wldev->dev);
 
 	if (list_empty(&wl->devlist)) {
 		b43_leds_unregister(wl);
-- 
1.7.3.4

