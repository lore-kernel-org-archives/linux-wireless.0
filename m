Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:39001 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755775Ab1CRCpQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 22:45:16 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2011 19:44:53 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, <stable@kernel.org>
Subject: [PATCH] ath6kl: fix device registration ordering
Date: Thu, 17 Mar 2011 19:45:12 -0700
Message-ID: <1300416312-16808-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Defer device registration to cfg80211 until it is ready.
This fixes a race against udev whereby device events
(both udev and RTNL) might be emitted with an unregistered
device specification (wlan%d).

This fixes a race on ath6kl on systems where the device
boots up really quickly to the the point udev and the
respective userspace daemon tries to start mucking with
the device prior to the device being initialized properly.

This fixes this bug:

http://code.google.com/p/chromium-os/issues/detail?id=13159

Without this loading of ath6kl will fail.

Cc: stable@kernel.org
Cc: Naveen Singh <naveen.singh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c |    8 ++++++++
 drivers/staging/ath6kl/os/linux/cfg80211.c   |    9 ---------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 6ca147f..67e89c4 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -1842,11 +1842,19 @@ ar6000_avail_ev(void *context, void *hif_handle)
                     dev->name, (unsigned long)ar->arHifDevice, (unsigned long)dev, device_index,
                     (unsigned long)ar));
 
+#ifdef ATH6K_CONFIG_CFG80211
+	init_status = wiphy_register(wdev->wiphy);
+#endif
+
 avail_ev_failed :
     if (init_status) {
         if (bmienable) { 
             ar6000_sysfs_bmi_deinit(ar);  
         }
+#ifdef ATH6K_CONFIG_CFG80211
+        ar6k_cfg80211_deinit(ar);
+#endif
+
     }
 
     return init_status;
diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
index 1f799c1..17a572a 100644
--- a/drivers/staging/ath6kl/os/linux/cfg80211.c
+++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
@@ -1416,7 +1416,6 @@ cfg80211_ops ar6k_cfg80211_ops = {
 struct wireless_dev *
 ar6k_cfg80211_init(struct device *dev)
 {
-    int ret = 0;
     struct wireless_dev *wdev;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO, ("%s: \n", __func__));
@@ -1451,14 +1450,6 @@ ar6k_cfg80211_init(struct device *dev)
     wdev->wiphy->cipher_suites = cipher_suites;
     wdev->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
 
-    ret = wiphy_register(wdev->wiphy);
-    if(ret < 0) {
-        AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
-                        ("%s: Couldn't register wiphy device\n", __func__));
-        wiphy_free(wdev->wiphy);
-        return ERR_PTR(ret);
-    }
-
     return wdev;
 }
 
-- 
1.7.4.15.g7811d

