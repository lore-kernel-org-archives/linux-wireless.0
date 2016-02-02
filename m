Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:9846 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243AbcBBMIR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 07:08:17 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH 24/26] staging: wilc1000: remove unused debug tag
Date: Tue, 2 Feb 2016 21:02:34 +0900
Message-ID: <1454414556-9822-24-git-send-email-leo.kim@atmel.com> (sfid-20160202_130820_916307_F9E9CDFF)
In-Reply-To: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
References: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch remove unused debug tag INT_DBG, LOCK_DBG, BUS_DBG,
MEM_DBG and FIRM_DBG

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_common.h | 15 ---------------
 drivers/staging/wilc1000/wilc_debugfs.c      |  5 +++--
 2 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
index 63d0ec5..758633e 100644
--- a/drivers/staging/wilc1000/linux_wlan_common.h
+++ b/drivers/staging/wilc1000/linux_wlan_common.h
@@ -5,29 +5,14 @@ enum debug_region {
 	Generic_debug = 0,
 	Hostapd_debug,
 	CFG80211_debug,
-	Interrupt_debug,
-	Lock_debug,
-	Tcp_enhance,
-	Spin_debug,
-
 	Init_debug,
-	Bus_debug,
-	Mem_debug,
-	Firmware_debug,
 	COMP = 0xFFFFFFFF,
 };
 
 #define GENERIC_DBG             (1 << Generic_debug)
 #define HOSTAPD_DBG             (1 << Hostapd_debug)
 #define CFG80211_DBG            (1 << CFG80211_debug)
-#define INT_DBG                 (1 << Interrupt_debug)
-#define LOCK_DBG                (1 << Lock_debug)
-#define TCP_ENH                 (1 << Tcp_enhance)
-#define SPIN_DEBUG              (1 << Spin_debug)
 #define INIT_DBG                (1 << Init_debug)
-#define BUS_DBG                 (1 << Bus_debug)
-#define MEM_DBG                 (1 << Mem_debug)
-#define FIRM_DBG                (1 << Firmware_debug)
 
 #if defined (WILC_DEBUGFS)
 extern atomic_t WILC_REGION;
diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index 63b66b2..13330c9 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -24,9 +24,10 @@ static struct dentry *wilc_dir;
  * --------------------------------------------------------------------------------
  */
 
-#define DBG_REGION_ALL	(GENERIC_DBG | HOSTAPD_DBG | CFG80211_DBG | INT_DBG | LOCK_DBG | INIT_DBG | BUS_DBG | MEM_DBG)
+#define DBG_REGION_ALL	(GENERIC_DBG | HOSTAPD_DBG | CFG80211_DBG | INIT_DBG)
 #define DBG_LEVEL_ALL	(DEBUG | INFO | WRN | ERR)
-atomic_t WILC_REGION = ATOMIC_INIT(INIT_DBG | GENERIC_DBG | CFG80211_DBG | FIRM_DBG | HOSTAPD_DBG);
+atomic_t WILC_REGION = ATOMIC_INIT(INIT_DBG | GENERIC_DBG | CFG80211_DBG |
+				   HOSTAPD_DBG);
 EXPORT_SYMBOL_GPL(WILC_REGION);
 atomic_t WILC_DEBUG_LEVEL = ATOMIC_INIT(ERR);
 EXPORT_SYMBOL_GPL(WILC_DEBUG_LEVEL);
-- 
1.9.1

