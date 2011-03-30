Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47205 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125Ab1C3A54 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 20:57:56 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 17:57:32 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 33/34] ath6kl: remove ar6000_prepare_target() crap
Date: Tue, 29 Mar 2011 17:56:30 -0700
Message-ID: <1301446591-15236-34-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
References: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was empty code, WTF^pi.

Cc: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/include/common_drv.h  |    4 ---
 drivers/staging/ath6kl/miscdrv/common_drv.c  |   34 --------------------------
 drivers/staging/ath6kl/os/linux/ar6000_drv.c |    8 ------
 3 files changed, 0 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/ath6kl/include/common_drv.h b/drivers/staging/ath6kl/include/common_drv.h
index b606334..34db299 100644
--- a/drivers/staging/ath6kl/include/common_drv.h
+++ b/drivers/staging/ath6kl/include/common_drv.h
@@ -81,10 +81,6 @@ int ar6000_set_htc_params(struct hif_device *hifDevice,
                                u32 MboxIsrYieldValue,
                                u8 HtcControlBuffers);
 
-int ar6000_prepare_target(struct hif_device *hifDevice,
-                               u32 TargetType,
-                               u32 TargetVersion);
-
 int ar6000_set_hci_bridge_flags(struct hif_device *hifDevice,
                                      u32 TargetType,
                                      u32 Flags);
diff --git a/drivers/staging/ath6kl/miscdrv/common_drv.c b/drivers/staging/ath6kl/miscdrv/common_drv.c
index a23a524..2be2ea4 100644
--- a/drivers/staging/ath6kl/miscdrv/common_drv.c
+++ b/drivers/staging/ath6kl/miscdrv/common_drv.c
@@ -683,40 +683,6 @@ int ar6000_set_htc_params(struct hif_device *hifDevice,
     return status;
 }
 
-
-static int prepare_ar6002(struct hif_device *hifDevice, u32 TargetVersion)
-{
-    int status = 0;
-
-    /* placeholder */
-
-    return status;
-}
-
-static int prepare_ar6003(struct hif_device *hifDevice, u32 TargetVersion)
-{
-    int status = 0;
-
-    /* placeholder */
-
-    return status;
-}
-
-/* this function assumes the caller has already initialized the BMI APIs */
-int ar6000_prepare_target(struct hif_device *hifDevice,
-                               u32 TargetType,
-                               u32 TargetVersion)
-{
-    if (TargetType == TARGET_TYPE_AR6002) {
-            /* do any preparations for AR6002 devices */
-        return prepare_ar6002(hifDevice,TargetVersion);
-    } else if (TargetType == TARGET_TYPE_AR6003) {
-        return prepare_ar6003(hifDevice,TargetVersion);
-    }
-
-    return 0;
-}
-
 #if defined(CONFIG_AR6002_REV1_FORCE_HOST)
 /*
  * Call this function just before the call to BMIInit
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index e3c1f58..666d5e6 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -1698,14 +1698,6 @@ ar6000_avail_ev(void *context, void *hif_handle)
 
         ar->arVersion.target_ver = targ_info.target_ver;
         ar->arTargetType = targ_info.target_type;
-
-        /* do any target-specific preparation that can be done through BMI */
-        r = ar6000_prepare_target(ar->arHifDevice,
-                                  targ_info.target_type,
-                                  targ_info.target_ver);
-        if (r)
-            goto avail_ev_failed;
-
     }
 
     r = ar6000_configure_target(ar);
-- 
1.7.0.4

