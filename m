Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:53991 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517Ab1BRVOK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 16:14:10 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 13:13:49 -0800
From: Vipin Mehta <vmehta@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>, <vmehta@atheros.com>,
	<devel@driverdev.osuosl.org>
Subject: [PATCH 07/15] staging: ath6kl: Adding support for txop bursting enable/disable
Date: Fri, 18 Feb 2011 13:13:08 -0800
Message-ID: <1298063596-2096-7-git-send-email-vmehta@atheros.com>
In-Reply-To: <1298063596-2096-1-git-send-email-vmehta@atheros.com>
References: <1298063596-2096-1-git-send-email-vmehta@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding compile time support for enabling/disabling txop bursting.

Signed-off-by: Vipin Mehta <vmehta@atheros.com>
---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |    7 +++++++
 .../staging/ath6kl/os/linux/include/wlan_config.h  |    7 +++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index b69280d..f084a92 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -2528,6 +2528,13 @@ int ar6000_target_config_wlan_params(AR_SOFTC_T *ar)
         status = A_ERROR;
     }
 
+#if WLAN_CONFIG_DISABLE_TX_BURSTING  
+    if ((wmi_set_wmm_txop(ar->arWmi, WMI_TXOP_DISABLED)) != 0) {
+        AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Unable to set txop bursting \n"));
+        status = A_ERROR;
+    }
+#endif 
+
     return status;
 }
 
diff --git a/drivers/staging/ath6kl/os/linux/include/wlan_config.h b/drivers/staging/ath6kl/os/linux/include/wlan_config.h
index f7d0487..2de5cef 100644
--- a/drivers/staging/ath6kl/os/linux/include/wlan_config.h
+++ b/drivers/staging/ath6kl/os/linux/include/wlan_config.h
@@ -103,6 +103,13 @@
 #define WLAN_CONFIG_PM_WOW2                 0
 
 /*
+ * This configuration item enables/disables transmit bursting 
+ * 0 - Enable tx Bursting (default)
+ * 1 - Disable tx bursting 
+ */
+#define WLAN_CONFIG_DISABLE_TX_BURSTING     0
+
+/*
  * Platform specific function to power ON/OFF AR6000 
  * and enable/disable SDIO card detection
  */
-- 
1.6.3.3

