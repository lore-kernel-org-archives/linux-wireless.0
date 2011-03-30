Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47084 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276Ab1C3A4o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 20:56:44 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 17:56:19 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 04/34] ath6kl: replace do while loop with function helpers on ar6000_avail_ev()
Date: Tue, 29 Mar 2011 17:56:01 -0700
Message-ID: <1301446591-15236-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
References: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This unwraps the do while loops in favor for function helpers.

Cc: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c |   68 ++++++++++++++++++--------
 1 files changed, 48 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 846eea7..cbf2cb6 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -1586,6 +1586,52 @@ init_netdev(struct net_device *dev, char *name)
     return;
 }
 
+static int __ath6kl_init_netdev(struct net_device *dev)
+{
+	int r;
+
+	rtnl_lock();
+	r = ar6000_init(dev);
+	rtnl_unlock();
+
+	if (r) {
+		AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("ar6000_avail: ar6000_init\n"));
+		return r;
+	}
+
+	return 0;
+}
+
+#ifdef HTC_RAW_INTERFACE
+static int ath6kl_init_netdev_wmi(struct net_device *dev)
+{
+	if (!eppingtest && bypasswmi)
+		return 0;
+
+	return __ath6kl_init_netdev(dev);
+}
+#else
+static int ath6kl_init_netdev_wmi(struct net_device *dev)
+{
+	return __ath6kl_init_netdev(dev);
+}
+#endif
+
+static int ath6kl_init_netdev(struct ar6_softc *ar)
+{
+	int r;
+
+        r = ar6000_sysfs_bmi_get_config(ar, wlaninitmode);
+        if (r) {
+		AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
+				("ar6000_avail: "
+				 "ar6000_sysfs_bmi_get_config failed\n"));
+		return r;
+        }
+
+	return ath6kl_init_netdev_wmi(ar->arNetDev);
+}
+
 /*
  * HTC Event handlers
  */
@@ -1788,26 +1834,8 @@ ar6000_avail_ev(void *context, void *hif_handle)
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO, ("BMI enabled: %d\n", wlaninitmode));
     if ((wlaninitmode == WLAN_INIT_MODE_UDEV) ||
         (wlaninitmode == WLAN_INIT_MODE_DRV)) {
-        do {
-            r = ar6000_sysfs_bmi_get_config(ar, wlaninitmode);
-            if (r) {
-                AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("ar6000_avail: ar6000_sysfs_bmi_get_config failed\n"));
-                break;
-            }
-#ifdef HTC_RAW_INTERFACE
-            if (!eppingtest && bypasswmi) {
-                break; /* Don't call ar6000_init for ART */
-            }
-#endif 
-            rtnl_lock();
-            r = ar6000_init(dev);
-            rtnl_unlock();
-            if (r) {
-                AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("ar6000_avail: ar6000_init\n"));
-            }
-        } while (false);
-
-        if (r)
+	r = ath6kl_init_netdev(ar);
+	if (r)
             goto avail_ev_failed;
     }
 
-- 
1.7.0.4

