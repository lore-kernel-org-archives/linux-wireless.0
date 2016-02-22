Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:20377 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbcBVKSd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2016 05:18:33 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH V4 10/24] staging: wilc1000: removes unused HOSTAPD_DBG tag
Date: Mon, 22 Feb 2016 19:14:17 +0900
Message-ID: <1456136071-10502-11-git-send-email-leo.kim@atmel.com> (sfid-20160222_111915_270238_18DAC855)
In-Reply-To: <1456136071-10502-1-git-send-email-leo.kim@atmel.com>
References: <1456136071-10502-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch removes unused HOSTAPD_DBG tag.

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_common.h | 4 +---
 drivers/staging/wilc1000/wilc_debugfs.c      | 5 ++---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
index 0d9a71f..1f7d806 100644
--- a/drivers/staging/wilc1000/linux_wlan_common.h
+++ b/drivers/staging/wilc1000/linux_wlan_common.h
@@ -2,13 +2,11 @@
 #define LINUX_WLAN_COMMON_H
 
 enum debug_region {
-	Hostapd_debug = 0,
-	CFG80211_debug,
+	CFG80211_debug = 0,
 	Init_debug,
 	COMP = 0xFFFFFFFF,
 };
 
-#define HOSTAPD_DBG             (1 << Hostapd_debug)
 #define CFG80211_DBG            (1 << CFG80211_debug)
 #define INIT_DBG                (1 << Init_debug)
 
diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index a27b077..fafe7cc 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -24,10 +24,9 @@ static struct dentry *wilc_dir;
  * --------------------------------------------------------------------------------
  */
 
-#define DBG_REGION_ALL	(HOSTAPD_DBG | CFG80211_DBG | INIT_DBG)
+#define DBG_REGION_ALL	(CFG80211_DBG | INIT_DBG)
 #define DBG_LEVEL_ALL	(DEBUG | INFO | WRN | ERR)
-atomic_t WILC_REGION = ATOMIC_INIT(INIT_DBG | CFG80211_DBG |
-				   HOSTAPD_DBG);
+atomic_t WILC_REGION = ATOMIC_INIT(INIT_DBG | CFG80211_DBG);
 EXPORT_SYMBOL_GPL(WILC_REGION);
 atomic_t WILC_DEBUG_LEVEL = ATOMIC_INIT(ERR);
 EXPORT_SYMBOL_GPL(WILC_DEBUG_LEVEL);
-- 
1.9.1

