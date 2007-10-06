Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:17023 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952AbXJFMDz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2007 08:03:55 -0400
Received: by ug-out-1314.google.com with SMTP id z38so605537ugc
        for <linux-wireless@vger.kernel.org>; Sat, 06 Oct 2007 05:03:55 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 03/16] rt2x00: Store "STARTED" state during suspend
Date: Sat, 6 Oct 2007 14:12:42 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200710061410.31765.IvDoorn@gmail.com>
In-Reply-To: <200710061410.31765.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710061412.43493.IvDoorn@gmail.com> (sfid-20071006_130403_162542_1D24A067)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Store the started state into a new flag DEVICE_STARTED_SUSPEND
and set this when suspending while the device was started.
We can't check for is_interface_present() since only mac80211
knows if there are monitor interfaces present.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |    1 +
 drivers/net/wireless/rt2x00/rt2x00dev.c |    7 ++++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 5d30ca6..d280d0e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -508,6 +508,7 @@ struct rt2x00_dev {
 #define CONFIG_EXTERNAL_LNA_BG		13
 #define CONFIG_DOUBLE_ANTENNA		14
 #define CONFIG_DISABLE_LINK_TUNING	15
+#define DEVICE_STARTED_SUSPEND		16
 
 	/*
 	 * Chipset identification.
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index b6a5c34..f254753 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1088,12 +1088,13 @@ int rt2x00lib_suspend(struct rt2x00_dev *rt2x00dev, pm_message_t state)
 	 */
 	if (!test_bit(DEVICE_STARTED, &rt2x00dev->flags))
 		goto exit;
+	__set_bit(DEVICE_STARTED_SUSPEND, &rt2x00dev->flags);
 
 	/*
 	 * Disable radio and unitialize all items
 	 * that must be recreated on resume.
 	 */
-	rt2x00lib_disable_radio(rt2x00dev);
+	rt2x00mac_stop(rt2x00dev->hw);
 	rt2x00lib_uninitialize(rt2x00dev);
 	rt2x00debug_deregister(rt2x00dev);
 
@@ -1123,9 +1124,9 @@ int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev)
 	rt2x00debug_register(rt2x00dev);
 
 	/*
-	 * Only continue if mac80211 has open interfaces.
+	 * Only continue if mac80211 had open interfaces.
 	 */
-	if (!test_bit(DEVICE_STARTED, &rt2x00dev->flags))
+	if (!__test_and_clear_bit(DEVICE_STARTED_SUSPEND, &rt2x00dev->flags))
 		return 0;
 
 	/*
-- 
1.5.3.4

