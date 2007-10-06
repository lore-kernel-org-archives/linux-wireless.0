Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:18176 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654AbXJFMD5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2007 08:03:57 -0400
Received: by ug-out-1314.google.com with SMTP id z38so605539ugc
        for <linux-wireless@vger.kernel.org>; Sat, 06 Oct 2007 05:03:56 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 04/16] rt2x00: Move rt2x00dev flags into enumeration
Date: Sat, 6 Oct 2007 14:13:06 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200710061410.31765.IvDoorn@gmail.com>
In-Reply-To: <200710061410.31765.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710061413.07413.IvDoorn@gmail.com> (sfid-20071006_130404_127048_552EBA38)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By putting the flags into a enumeration we can
make it easier maintable since we don't have to
assign numbers for each flag. This makes it easier
to insert and remove flags.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h |   49 +++++++++++++++++++++++-----------
 1 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index d280d0e..82dfcd9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -441,6 +441,39 @@ struct rt2x00_ops {
 };
 
 /*
+ * rt2x00 device flags
+ */
+enum rt2x00_flags {
+	/*
+	 * Device state flags
+	 */
+	DEVICE_PRESENT,
+	DEVICE_REGISTERED_HW,
+	DEVICE_INITIALIZED,
+	DEVICE_STARTED,
+	DEVICE_STARTED_SUSPEND,
+	DEVICE_ENABLED_RADIO,
+	DEVICE_ENABLED_RADIO_HW,
+
+	/*
+	 * Driver features
+	 */
+	DRIVER_REQUIRE_FIRMWARE,
+	DRIVER_REQUIRE_BEACON_RING,
+
+	/*
+	 * Driver configuration
+	 */
+	CONFIG_SUPPORT_HW_BUTTON,
+	CONFIG_FRAME_TYPE,
+	CONFIG_RF_SEQUENCE,
+	CONFIG_EXTERNAL_LNA_A,
+	CONFIG_EXTERNAL_LNA_BG,
+	CONFIG_DOUBLE_ANTENNA,
+	CONFIG_DISABLE_LINK_TUNING,
+};
+
+/*
  * rt2x00 device structure.
  */
 struct rt2x00_dev {
@@ -493,22 +526,6 @@ struct rt2x00_dev {
 	 * of the device capabilities are stored.
 	 */
 	unsigned long flags;
-#define DEVICE_PRESENT			1
-#define DEVICE_REGISTERED_HW		2
-#define DEVICE_INITIALIZED		3
-#define DEVICE_STARTED			4
-#define DEVICE_ENABLED_RADIO		5
-#define DEVICE_ENABLED_RADIO_HW		6
-#define DRIVER_REQUIRE_FIRMWARE		7
-#define DRIVER_REQUIRE_BEACON_RING	8
-#define CONFIG_SUPPORT_HW_BUTTON	9
-#define CONFIG_FRAME_TYPE		10
-#define CONFIG_RF_SEQUENCE		11
-#define CONFIG_EXTERNAL_LNA_A		12
-#define CONFIG_EXTERNAL_LNA_BG		13
-#define CONFIG_DOUBLE_ANTENNA		14
-#define CONFIG_DISABLE_LINK_TUNING	15
-#define DEVICE_STARTED_SUSPEND		16
 
 	/*
 	 * Chipset identification.
-- 
1.5.3.4

