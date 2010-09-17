Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:38376 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761Ab0IQQzS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 12:55:18 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 09:55:12 -0700
From: Vipin Mehta <vmehta@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>, <vmehta@atheros.com>,
	<devel@driverdev.osuosl.org>
Subject: [PATCH] staging: ath6kl: Fixing a race condition during initialization
Date: Fri, 17 Sep 2010 09:55:15 -0700
Message-ID: <1284742515-3013-1-git-send-email-vmehta@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit fixes a race condition in the initialization portion of the
driver. The problem was observed while testing with the kernel in the
staging-next tree. The wait on the ready event is signalled prematurely
before setting the arVersion.wlan_ver and arVersion.abi_ver. The code
waiting on this semaphore checks for the validity of these values and
hence may proceed with an un-updated values of these fields. The wakeup
signal is now sent after these values are set.

Signed-off-by: Vipin Mehta <vmehta@atheros.com>
---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index ff7976e..41d8842 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -4174,8 +4174,6 @@ ar6000_ready_event(void *devt, A_UINT8 *datap, A_UINT8 phyCap, A_UINT32 sw_ver,
     AR_SOFTC_T *ar = (AR_SOFTC_T *)devt;
     struct net_device *dev = ar->arNetDev;
 
-    ar->arWmiReady = TRUE;
-    wake_up(&arEvent);
     A_MEMCPY(dev->dev_addr, datap, AR6000_ETH_ADDR_LEN);
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("mac address = %2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x\n",
         dev->dev_addr[0], dev->dev_addr[1],
@@ -4186,6 +4184,10 @@ ar6000_ready_event(void *devt, A_UINT8 *datap, A_UINT8 phyCap, A_UINT32 sw_ver,
     ar->arVersion.wlan_ver = sw_ver;
     ar->arVersion.abi_ver = abi_ver;
 
+    /* Indicate to the waiting thread that the ready event was received */
+    ar->arWmiReady = TRUE;
+    wake_up(&arEvent);
+
 #if WLAN_CONFIG_IGNORE_POWER_SAVE_FAIL_EVENT_DURING_SCAN
     wmi_pmparams_cmd(ar->arWmi, 0, 1, 0, 0, 1, IGNORE_POWER_SAVE_FAIL_EVENT_DURING_SCAN);
 #endif
-- 
1.6.3.3

