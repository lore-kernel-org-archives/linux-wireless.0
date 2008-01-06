Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:30801 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069AbYAFWmr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jan 2008 17:42:47 -0500
Received: by ug-out-1314.google.com with SMTP id z38so3071365ugc.16
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jan 2008 14:42:45 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 05/12] rt2x00: Move start() and stop() handlers into rt2x00lib.c
Date: Sun, 6 Jan 2008 23:40:07 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200801062337.35904.IvDoorn@gmail.com>
In-Reply-To: <200801062337.35904.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801062340.07161.IvDoorn@gmail.com> (sfid-20080106_224251_297949_701E0906)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

suspend & resume was broken since it called rt2x00mac_start()
and rt2x00mac_stop() which would fail to execute because the
DEVICE_PRESENT flag was not set.

Move the start and stop handlers into rt2x00lib.c which are called
from rt2x00mac_start() and rt2x00mac_stop() after they have checked
the DEVICE_PRESENT flag, while suspend and resume handlers can
directly call those functions.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |   66 ++++++++++++++++++++++++++++--
 drivers/net/wireless/rt2x00/rt2x00lib.h |    4 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c |   42 +------------------
 3 files changed, 66 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 9b2bd91..cea2bd9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1046,7 +1046,7 @@ static void rt2x00lib_free_ring_entries(struct rt2x00_dev *rt2x00dev)
 	}
 }
 
-void rt2x00lib_uninitialize(struct rt2x00_dev *rt2x00dev)
+static void rt2x00lib_uninitialize(struct rt2x00_dev *rt2x00dev)
 {
 	if (!__test_and_clear_bit(DEVICE_INITIALIZED, &rt2x00dev->flags))
 		return;
@@ -1067,7 +1067,7 @@ void rt2x00lib_uninitialize(struct rt2x00_dev *rt2x00dev)
 	rt2x00lib_free_ring_entries(rt2x00dev);
 }
 
-int rt2x00lib_initialize(struct rt2x00_dev *rt2x00dev)
+static int rt2x00lib_initialize(struct rt2x00_dev *rt2x00dev)
 {
 	int status;
 
@@ -1110,6 +1110,58 @@ exit:
 	return status;
 }
 
+int rt2x00lib_start(struct rt2x00_dev *rt2x00dev)
+{
+	int retval;
+
+	if (test_bit(DEVICE_STARTED, &rt2x00dev->flags))
+		return 0;
+
+	/*
+	 * If this is the first interface which is added,
+	 * we should load the firmware now.
+	 */
+	if (test_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags)) {
+		retval = rt2x00lib_load_firmware(rt2x00dev);
+		if (retval)
+			return retval;
+	}
+
+	/*
+	 * Initialize the device.
+	 */
+	retval = rt2x00lib_initialize(rt2x00dev);
+	if (retval)
+		return retval;
+
+	/*
+	 * Enable radio.
+	 */
+	retval = rt2x00lib_enable_radio(rt2x00dev);
+	if (retval) {
+		rt2x00lib_uninitialize(rt2x00dev);
+		return retval;
+	}
+
+	__set_bit(DEVICE_STARTED, &rt2x00dev->flags);
+
+	return 0;
+}
+
+void rt2x00lib_stop(struct rt2x00_dev *rt2x00dev)
+{
+	if (!test_bit(DEVICE_STARTED, &rt2x00dev->flags))
+		return;
+
+	/*
+	 * Perhaps we can add something smarter here,
+	 * but for now just disabling the radio should do.
+	 */
+	rt2x00lib_disable_radio(rt2x00dev);
+
+	__clear_bit(DEVICE_STARTED, &rt2x00dev->flags);
+}
+
 /*
  * driver allocation handlers.
  */
@@ -1295,7 +1347,7 @@ int rt2x00lib_suspend(struct rt2x00_dev *rt2x00dev, pm_message_t state)
 	 * Disable radio and unitialize all items
 	 * that must be recreated on resume.
 	 */
-	rt2x00mac_stop(rt2x00dev->hw);
+	rt2x00lib_stop(rt2x00dev);
 	rt2x00lib_uninitialize(rt2x00dev);
 	rt2x00debug_deregister(rt2x00dev);
 
@@ -1317,7 +1369,6 @@ int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev)
 	int retval;
 
 	NOTICE(rt2x00dev, "Waking up.\n");
-	__set_bit(DEVICE_PRESENT, &rt2x00dev->flags);
 
 	/*
 	 * Open the debugfs entry.
@@ -1333,7 +1384,7 @@ int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Reinitialize device and all active interfaces.
 	 */
-	retval = rt2x00mac_start(rt2x00dev->hw);
+	retval = rt2x00lib_start(rt2x00dev);
 	if (retval)
 		goto exit;
 
@@ -1349,6 +1400,11 @@ int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev)
 	rt2x00lib_config_type(rt2x00dev, intf->type);
 
 	/*
+	 * We are ready again to receive requests from mac80211.
+	 */
+	__set_bit(DEVICE_PRESENT, &rt2x00dev->flags);
+
+	/*
 	 * It is possible that during that mac80211 has attempted
 	 * to send frames while we were suspending or resuming.
 	 * In that case we have disabled the TX queue and should
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 108488d..1adbd28 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -44,8 +44,8 @@ void rt2x00lib_reset_link_tuner(struct rt2x00_dev *rt2x00dev);
 /*
  * Initialization handlers.
  */
-int rt2x00lib_initialize(struct rt2x00_dev *rt2x00dev);
-void rt2x00lib_uninitialize(struct rt2x00_dev *rt2x00dev);
+int rt2x00lib_start(struct rt2x00_dev *rt2x00dev);
+void rt2x00lib_stop(struct rt2x00_dev *rt2x00dev);
 
 /*
  * Configuration handlers.
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 978cffb..1d67bcd 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -139,41 +139,11 @@ EXPORT_SYMBOL_GPL(rt2x00mac_tx);
 int rt2x00mac_start(struct ieee80211_hw *hw)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	int status;
 
-	if (!test_bit(DEVICE_PRESENT, &rt2x00dev->flags) ||
-	    test_bit(DEVICE_STARTED, &rt2x00dev->flags))
+	if (!test_bit(DEVICE_PRESENT, &rt2x00dev->flags))
 		return 0;
 
-	/*
-	 * If this is the first interface which is added,
-	 * we should load the firmware now.
-	 */
-	if (test_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags)) {
-		status = rt2x00lib_load_firmware(rt2x00dev);
-		if (status)
-			return status;
-	}
-
-	/*
-	 * Initialize the device.
-	 */
-	status = rt2x00lib_initialize(rt2x00dev);
-	if (status)
-		return status;
-
-	/*
-	 * Enable radio.
-	 */
-	status = rt2x00lib_enable_radio(rt2x00dev);
-	if (status) {
-		rt2x00lib_uninitialize(rt2x00dev);
-		return status;
-	}
-
-	__set_bit(DEVICE_STARTED, &rt2x00dev->flags);
-
-	return 0;
+	return rt2x00lib_start(rt2x00dev);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_start);
 
@@ -184,13 +154,7 @@ void rt2x00mac_stop(struct ieee80211_hw *hw)
 	if (!test_bit(DEVICE_PRESENT, &rt2x00dev->flags))
 		return;
 
-	/*
-	 * Perhaps we can add something smarter here,
-	 * but for now just disabling the radio should do.
-	 */
-	rt2x00lib_disable_radio(rt2x00dev);
-
-	__clear_bit(DEVICE_STARTED, &rt2x00dev->flags);
+	rt2x00lib_stop(rt2x00dev);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_stop);
 
-- 
1.5.3.7

