Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:47842 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946272AbcBSIjr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2016 03:39:47 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 1/6] staging: wilc1000: removes wilc_dbg()
Date: Fri, 19 Feb 2016 17:37:07 +0900
Message-ID: <1455871032-7625-1-git-send-email-leo.kim@atmel.com> (sfid-20160219_093950_969708_988395BF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes wilc_dbg function because it's not any more.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 4 ----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 2 --
 drivers/staging/wilc1000/wilc_wlan.c          | 2 --
 3 files changed, 8 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 660bf63..b0cd21b 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -224,10 +224,6 @@ static void deinit_irq(struct net_device *dev)
 	}
 }
 
-void wilc_dbg(u8 *buff)
-{
-}
-
 int wilc_lock_timeout(struct wilc *nic, void *vp, u32 timeout)
 {
 	/* FIXME: replace with mutex_lock or wait_for_completion */
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 3077f5d4..786f5fd 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -228,8 +228,6 @@ int wilc1000_wlan_init(struct net_device *dev, struct wilc_vif *vif);
 
 void wilc_frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset);
 void wilc_mac_indicate(struct wilc *wilc, int flag);
-void wilc_dbg(u8 *buff);
-
 int wilc_lock_timeout(struct wilc *wilc, void *, u32 timeout);
 void wilc_netdev_cleanup(struct wilc *wilc);
 int wilc_netdev_init(struct wilc **wilc, struct device *, int io_type, int gpio,
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 0cd3ed8..81a40e8 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -15,8 +15,6 @@ static void wilc_debug(u32 flag, char *fmt, ...)
 		va_start(args, fmt);
 		vsprintf(buf, fmt, args);
 		va_end(args);
-
-		wilc_dbg(buf);
 	}
 }
 
-- 
1.9.1

