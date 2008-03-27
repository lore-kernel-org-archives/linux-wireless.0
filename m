Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3787 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbYC1AUO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 20:20:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: ivdoorn@gmail.com, "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: fixup some non-functional merge errors
Date: Thu, 27 Mar 2008 19:54:13 -0400
Message-Id: <1206662053-6237-1-git-send-email-linville@tuxdriver.com> (sfid-20080328_002020_440410_581200C3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These small changes restore the rt2x00 sources to the way Ivo intended.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |    2 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c |    4 ----
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 333484d..30f9f3a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -674,7 +674,7 @@ struct rt2x00_dev {
 	 * This will only be compiled in when required.
 	 */
 #ifdef CONFIG_RT2X00_LIB_RFKILL
-unsigned long rfkill_state;
+	unsigned long rfkill_state;
 #define RFKILL_STATE_ALLOCATED		1
 #define RFKILL_STATE_REGISTERED		2
 	struct rfkill *rfkill;
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index f52e925..d2c0967 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1194,10 +1194,6 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	 */
 	rt2x00debug_deregister(rt2x00dev);
 	rt2x00rfkill_free(rt2x00dev);
-
-	/*
-	 * Free LED.
-	 */
 	rt2x00leds_unregister(rt2x00dev);
 
 	/*
-- 
1.5.3.3

