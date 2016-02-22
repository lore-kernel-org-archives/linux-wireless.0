Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:29985 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbcBVESk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Feb 2016 23:18:40 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH V3 23/24] staging: wilc1000: moves to define values
Date: Mon, 22 Feb 2016 13:12:08 +0900
Message-ID: <1456114329-7036-24-git-send-email-leo.kim@atmel.com> (sfid-20160222_051842_757335_E3B3E3CA)
In-Reply-To: <1456114329-7036-1-git-send-email-leo.kim@atmel.com>
References: <1456114329-7036-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch moves DEBUG, INFO, WRN and ERR values to wilc_debugfs.c file
because this is only used to wilc_debugfs.c file.
And, removes unnecessary WILC_DEBUGFS and else-case variables.

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_common.h | 11 -----------
 drivers/staging/wilc1000/wilc_debugfs.c      |  4 ++++
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
index 2e2109c..51601aa 100644
--- a/drivers/staging/wilc1000/linux_wlan_common.h
+++ b/drivers/staging/wilc1000/linux_wlan_common.h
@@ -1,17 +1,6 @@
 #ifndef LINUX_WLAN_COMMON_H
 #define LINUX_WLAN_COMMON_H
 
-#if defined(WILC_DEBUGFS)
-#define DEBUG           BIT(0)
-#define INFO            BIT(1)
-#define WRN             BIT(2)
-#define ERR             BIT(3)
-#else
-#define DEBUG       1
-#define INFO        0
-#define WRN         0
-#endif
-
 #define LINUX_RX_SIZE	(96 * 1024)
 #define LINUX_TX_SIZE	(64 * 1024)
 
diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index 215e2f0..fcbc95d 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -23,6 +23,10 @@ static struct dentry *wilc_dir;
 /*
  * --------------------------------------------------------------------------------
  */
+#define DEBUG           BIT(0)
+#define INFO            BIT(1)
+#define WRN             BIT(2)
+#define ERR             BIT(3)
 
 #define DBG_LEVEL_ALL	(DEBUG | INFO | WRN | ERR)
 atomic_t WILC_DEBUG_LEVEL = ATOMIC_INIT(ERR);
-- 
1.9.1

