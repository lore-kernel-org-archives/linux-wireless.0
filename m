Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:22855 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbXHSSar convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:30:47 -0400
Received: by ug-out-1314.google.com with SMTP id j3so446949ugf
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:30:45 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 12/30] rt2x00: Store firmware in memory
Date: Sun, 19 Aug 2007 20:25:39 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192025.39412.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 6d620c9670f54eb0ce06bd771556e4ac413a2c48 Mon Sep 17 00:00:00 2001
From: Mattias Nissler <mattias.nissler@gmx.de>
Date: Sun, 5 Aug 2007 15:32:38 +0200
Subject: [PATCH 12/30] rt2x00: Store firmware in memory

Because hard disks are likely not yet up when resuming, we cannot load
the firmware image from disk then. Work around this problem by keeping
the firmware image in memory once it is loaded.

Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00.h         |    6 ++++
 drivers/net/wireless/rt2x00dev.c      |    5 ++++
 drivers/net/wireless/rt2x00firmware.c |   43 +++++++++++++++++++++++++-------
 drivers/net/wireless/rt2x00lib.h      |    4 +++
 4 files changed, 48 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00.h b/drivers/net/wireless/rt2x00.h
index cfd5384..de1365f 100644
--- a/drivers/net/wireless/rt2x00.h
+++ b/drivers/net/wireless/rt2x00.h
@@ -30,6 +30,7 @@
 #include <linux/prefetch.h>
 #include <linux/skbuff.h>
 #include <linux/workqueue.h>
+#include <linux/firmware.h>
 
 #include <net/mac80211.h>
 
@@ -601,6 +602,11 @@ struct rt2x00_dev {
 	struct data_ring *rx;
 	struct data_ring *tx;
 	struct data_ring *bcn;
+
+	/*
+	 * Firmware image.
+	 */
+	const struct firmware *fw;
 };
 
 /*
diff --git a/drivers/net/wireless/rt2x00dev.c b/drivers/net/wireless/rt2x00dev.c
index 3671f74..50c604c 100644
--- a/drivers/net/wireless/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00dev.c
@@ -1091,6 +1091,11 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	rt2x00lib_remove_hw(rt2x00dev);
 
 	/*
+	 * Free firmware image.
+	 */
+	rt2x00lib_free_firmware(rt2x00dev);
+
+	/*
 	 * Free ring structures.
 	 */
 	rt2x00lib_free_rings(rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00firmware.c b/drivers/net/wireless/rt2x00firmware.c
index 63834f9..143e793 100644
--- a/drivers/net/wireless/rt2x00firmware.c
+++ b/drivers/net/wireless/rt2x00firmware.c
@@ -29,14 +29,13 @@
 #define DRV_NAME "rt2x00lib"
 
 #include <linux/crc-itu-t.h>
-#include <linux/firmware.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 
 #include "rt2x00.h"
 #include "rt2x00lib.h"
 
-int rt2x00lib_load_firmware(struct rt2x00_dev *rt2x00dev)
+static int rt2x00lib_request_firmware(struct rt2x00_dev *rt2x00dev)
 {
 	struct device *device = wiphy_dev(rt2x00dev->hw->wiphy);
 	const struct firmware *fw;
@@ -85,19 +84,43 @@ int rt2x00lib_load_firmware(struct rt2x00_dev *rt2x00dev)
 		goto exit;
 	}
 
-	/*
-	 * Send firmware to the device.
-	 */
-	retval = rt2x00dev->ops->lib->load_firmware(rt2x00dev,
-						    fw->data, fw->size);
-	if (retval)
-		goto exit;
-
 	INFO(rt2x00dev, "Firmware detected - version: %d.%d.\n",
 	     fw->data[fw->size - 4], fw->data[fw->size - 3]);
 
+	rt2x00dev->fw = fw;
+
+	return 0;
+
 exit:
 	release_firmware(fw);
 
 	return retval;
 }
+
+int rt2x00lib_load_firmware(struct rt2x00_dev *rt2x00dev)
+{
+	int retval;
+
+	if (!rt2x00dev->fw) {
+		retval = rt2x00lib_request_firmware(rt2x00dev);
+		if (retval)
+			return retval;
+	}
+
+	/*
+	 * Send firmware to the device.
+	 */
+	retval = rt2x00dev->ops->lib->load_firmware(rt2x00dev,
+						    rt2x00dev->fw->data,
+						    rt2x00dev->fw->size);
+	return retval;
+}
+
+void rt2x00lib_free_firmware(struct rt2x00_dev *rt2x00dev)
+{
+	if (rt2x00dev->fw) {
+		release_firmware(rt2x00dev->fw);
+		rt2x00dev->fw = NULL;
+	}
+}
+
diff --git a/drivers/net/wireless/rt2x00lib.h b/drivers/net/wireless/rt2x00lib.h
index 1a28292..1560f73 100644
--- a/drivers/net/wireless/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00lib.h
@@ -59,11 +59,15 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev, struct ieee80211_conf *conf)
  */
 #ifdef CONFIG_RT2X00_LIB_FIRMWARE
 int rt2x00lib_load_firmware(struct rt2x00_dev *rt2x00dev);
+void rt2x00lib_free_firmware(struct rt2x00_dev *rt2x00dev);
 #else
 static inline int rt2x00lib_load_firmware(struct rt2x00_dev *rt2x00dev)
 {
 	return 0;
 }
+static inline void rt2x00lib_free_firmware(struct rt2x00_dev *rt2x00dev)
+{
+}
 #endif /* CONFIG_RT2X00_LIB_FIRMWARE */
 
 /*
-- 
1.5.3.rc5

