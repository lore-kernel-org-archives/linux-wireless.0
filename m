Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:20824 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbbKRGJv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 01:09:51 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 15/16] staging: wilc1000: wilc_dbg: remove wilc
Date: Wed, 18 Nov 2015 15:11:36 +0900
Message-ID: <1447827097-9436-16-git-send-email-glen.lee@atmel.com> (sfid-20151118_071409_116105_F617410B)
In-Reply-To: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
References: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch remove parameter struct wilc since it is not used and also wilc_dev
will be removed.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 2 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 2 +-
 drivers/staging/wilc1000/wilc_wlan.c          | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 1457e75..cd471ab 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -245,7 +245,7 @@ static void deinit_irq(struct net_device *dev)
 	}
 }
 
-void wilc_dbg(struct wilc *wilc, u8 *buff)
+void wilc_dbg(u8 *buff)
 {
 	PRINT_D(INIT_DBG, "%d\n", *buff);
 }
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 6ec6d6a..4c8de8b 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -210,7 +210,7 @@ extern struct net_device *WILC_WFI_devs[];
 void wilc_frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset);
 void wilc_mac_indicate(struct wilc *wilc, int flag);
 void wilc_rx_complete(struct wilc *wilc);
-void wilc_dbg(struct wilc *, u8 *buff);
+void wilc_dbg(u8 *buff);
 
 int wilc_lock_timeout(struct wilc *wilc, void *, u32 timeout);
 void wilc_netdev_cleanup(struct wilc *wilc);
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index a271851..a73e99f 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -51,7 +51,7 @@ static void wilc_debug(u32 flag, char *fmt, ...)
 		vsprintf(buf, fmt, args);
 		va_end(args);
 
-		wilc_dbg(wilc_dev, buf);
+		wilc_dbg(buf);
 	}
 }
 
-- 
1.9.1

