Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:31647 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbcBVEoX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Feb 2016 23:44:23 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 06/10] staging: wilc1000: wilc_wlan_cfg_init: changes unused argument
Date: Mon, 22 Feb 2016 13:41:15 +0900
Message-ID: <1456116079-7161-6-git-send-email-leo.kim@atmel.com> (sfid-20160222_054426_240815_5720697E)
In-Reply-To: <1456116079-7161-1-git-send-email-leo.kim@atmel.com>
References: <1456116079-7161-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes the argument of the wilc_wlan_cfg_init function,
wilc_debug to void type because wilc_debug function is not used any more.
In addition, finally removes wilc_debug and related variables.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c     | 17 +----------------
 drivers/staging/wilc1000/wilc_wlan_cfg.c |  2 +-
 drivers/staging/wilc1000/wilc_wlan_cfg.h |  2 +-
 3 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 34018a1..d50ddc6 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -3,21 +3,6 @@
 #include "wilc_wfi_netdevice.h"
 #include "wilc_wlan_cfg.h"
 
-static u32 dbgflag = N_INIT | N_ERR | N_INTR | N_TXQ | N_RXQ;
-
-/* FIXME: replace with dev_debug() */
-static void wilc_debug(u32 flag, char *fmt, ...)
-{
-	char buf[256];
-	va_list args;
-
-	if (flag & dbgflag) {
-		va_start(args, fmt);
-		vsprintf(buf, fmt, args);
-		va_end(args);
-	}
-}
-
 static CHIP_PS_STATE_T chip_ps_state = CHIP_WAKEDUP;
 
 static inline void acquire_bus(struct wilc *wilc, BUS_ACQUIRE_T acquire)
@@ -1448,7 +1433,7 @@ int wilc_wlan_init(struct net_device *dev)
 		goto _fail_;
 	}
 
-	if (!wilc_wlan_cfg_init(wilc_debug)) {
+	if (!wilc_wlan_cfg_init()) {
 		ret = -ENOBUFS;
 		goto _fail_;
 	}
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index deff886..b992243 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -531,7 +531,7 @@ int wilc_wlan_cfg_indicate_rx(struct wilc *wilc, u8 *frame, int size,
 	return ret;
 }
 
-int wilc_wlan_cfg_init(wilc_debug_func func)
+int wilc_wlan_cfg_init(void)
 {
 	memset((void *)&g_mac, 0, sizeof(struct wilc_mac_cfg));
 	return 1;
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.h b/drivers/staging/wilc1000/wilc_wlan_cfg.h
index 9b74cc3..b8641a2 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.h
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.h
@@ -36,6 +36,6 @@ int wilc_wlan_cfg_get_wid(u8 *frame, u32 offset, u16 id);
 int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size);
 int wilc_wlan_cfg_indicate_rx(struct wilc *wilc, u8 *frame, int size,
 			      struct wilc_cfg_rsp *rsp);
-int wilc_wlan_cfg_init(wilc_debug_func func);
+int wilc_wlan_cfg_init(void);
 
 #endif
-- 
1.9.1

