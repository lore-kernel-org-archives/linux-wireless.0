Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:29828 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbcBVEQ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Feb 2016 23:16:59 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH V3 14/24] staging: wilc1000: removes unused CFG80211_DBG tag
Date: Mon, 22 Feb 2016 13:11:59 +0900
Message-ID: <1456114329-7036-15-git-send-email-leo.kim@atmel.com> (sfid-20160222_052950_064856_A70C88F3)
In-Reply-To: <1456114329-7036-1-git-send-email-leo.kim@atmel.com>
References: <1456114329-7036-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch removes unused CFG80211_DBG tag.

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_common.h | 4 +---
 drivers/staging/wilc1000/wilc_debugfs.c      | 6 +++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
index 1f7d806..e408631 100644
--- a/drivers/staging/wilc1000/linux_wlan_common.h
+++ b/drivers/staging/wilc1000/linux_wlan_common.h
@@ -2,12 +2,10 @@
 #define LINUX_WLAN_COMMON_H
 
 enum debug_region {
-	CFG80211_debug = 0,
-	Init_debug,
+	Init_debug = 0,
 	COMP = 0xFFFFFFFF,
 };
 
-#define CFG80211_DBG            (1 << CFG80211_debug)
 #define INIT_DBG                (1 << Init_debug)
 
 #if defined(WILC_DEBUGFS)
diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index fafe7cc..266d96b 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -24,9 +24,9 @@ static struct dentry *wilc_dir;
  * --------------------------------------------------------------------------------
  */
 
-#define DBG_REGION_ALL	(CFG80211_DBG | INIT_DBG)
+#define DBG_REGION_ALL	(INIT_DBG)
 #define DBG_LEVEL_ALL	(DEBUG | INFO | WRN | ERR)
-atomic_t WILC_REGION = ATOMIC_INIT(INIT_DBG | CFG80211_DBG);
+atomic_t WILC_REGION = ATOMIC_INIT(INIT_DBG);
 EXPORT_SYMBOL_GPL(WILC_REGION);
 atomic_t WILC_DEBUG_LEVEL = ATOMIC_INIT(ERR);
 EXPORT_SYMBOL_GPL(WILC_DEBUG_LEVEL);
@@ -134,7 +134,7 @@ struct wilc_debugfs_info_t {
 
 static struct wilc_debugfs_info_t debugfs_info[] = {
 	{ "wilc_debug_level",	0666,	(DEBUG | ERR), FOPS(NULL, wilc_debug_level_read, wilc_debug_level_write, NULL), },
-	{ "wilc_debug_region",	0666,	(INIT_DBG | CFG80211_DBG), FOPS(NULL, wilc_debug_region_read, wilc_debug_region_write, NULL), },
+	{ "wilc_debug_region",	0666,	(INIT_DBG), FOPS(NULL, wilc_debug_region_read, wilc_debug_region_write, NULL), },
 };
 
 static int __init wilc_debugfs_init(void)
-- 
1.9.1

