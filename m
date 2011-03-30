Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47175 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351Ab1C3A5i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 20:57:38 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 17:57:14 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 25/34] ath6kl: remove useless plat_setup_power() calls
Date: Tue, 29 Mar 2011 17:56:22 -0700
Message-ID: <1301446591-15236-26-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
References: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These map to do nothing.

Cc: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |    3 ---
 drivers/staging/ath6kl/os/linux/ar6000_pm.c        |    6 ------
 .../staging/ath6kl/os/linux/include/wlan_config.h  |    6 ------
 3 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 5f73182..056acae 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -2017,9 +2017,6 @@ ar6000_destroy(struct net_device *dev, unsigned int unregister)
     if (ar->arWlanPowerState != WLAN_POWER_STATE_CUT_PWR) {
         /* only stop endpoint if we are not stop it in suspend_ev */
         ar6000_stop_endpoint(dev, false, true);
-    } else {
-        /* clear up the platform power state before rmmod */
-        plat_setup_power(1,0);
     }
 
     ar->arWlanState = WLAN_DISABLED;
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_pm.c b/drivers/staging/ath6kl/os/linux/ar6000_pm.c
index be401aa..eeb3807 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_pm.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_pm.c
@@ -304,13 +304,11 @@ int ar6000_power_change_ev(void *context, u32 config)
 
 static int ar6000_pm_probe(struct platform_device *pdev)
 {
-    plat_setup_power(1,1);
     return 0;
 }
 
 static int ar6000_pm_remove(struct platform_device *pdev)
 {
-    plat_setup_power(0,1);
     return 0;
 }
 
@@ -352,8 +350,6 @@ ar6000_setup_cut_power_state(struct ar6_softc *ar,  AR6000_WLAN_STATE state)
                 break;
             }
 
-            plat_setup_power(1,0);
-
             /* Change the state to ON */
             ar->arWlanPowerState = WLAN_POWER_STATE_ON;
 
@@ -385,8 +381,6 @@ ar6000_setup_cut_power_state(struct ar6_softc *ar,  AR6000_WLAN_STATE state)
                                 &config,
                                 sizeof(HIF_DEVICE_POWER_CHANGE_TYPE));
 
-            plat_setup_power(0,0);
-
             ar->arWlanPowerState = WLAN_POWER_STATE_CUT_PWR;
         }
     } while (0);
diff --git a/drivers/staging/ath6kl/os/linux/include/wlan_config.h b/drivers/staging/ath6kl/os/linux/include/wlan_config.h
index 98951bb..c1fe0c6 100644
--- a/drivers/staging/ath6kl/os/linux/include/wlan_config.h
+++ b/drivers/staging/ath6kl/os/linux/include/wlan_config.h
@@ -105,10 +105,4 @@
  */
 #define WLAN_CONFIG_DISABLE_TX_BURSTING     0
 
-/*
- * Platform specific function to power ON/OFF AR6000 
- * and enable/disable SDIO card detection
- */
-#define plat_setup_power(on, detect)
-
 #endif /* _HOST_WLAN_CONFIG_H_ */
-- 
1.7.0.4

