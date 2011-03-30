Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47164 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755201Ab1C3A5b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 20:57:31 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 17:57:06 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 22/34] ath6kl: use CONFIG_ATH6KL_ENABLE_COEXISTENCE
Date: Tue, 29 Mar 2011 17:56:19 -0700
Message-ID: <1301446591-15236-23-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
References: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When CONFIG_ATH6KL_ENABLE_COEXISTENCE gets enabled we define
another flag called ENABLE_COEXISTENCE, just use
CONFIG_ATH6KL_ENABLE_COEXISTENCE since that is already defined
by the generated autoconf header file from the kernel.

Cc: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/Makefile              |    4 ----
 drivers/staging/ath6kl/os/linux/ar6000_drv.c |    8 ++++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/ath6kl/Makefile b/drivers/staging/ath6kl/Makefile
index b0f711e..1d3f239 100644
--- a/drivers/staging/ath6kl/Makefile
+++ b/drivers/staging/ath6kl/Makefile
@@ -29,10 +29,6 @@ ccflags-y += -I$(obj)/os
 ccflags-y += -I$(obj)/bmi/include
 ccflags-y += -I$(obj)/include/common/AR6002/hw4.0
 
-ifeq ($(CONFIG_ATH6KL_ENABLE_COEXISTENCE),y)
-ccflags-y += -DENABLE_COEXISTENCE
-endif
-
 ifeq ($(CONFIG_AR600x_DUAL_ANTENNA),y)
 ccflags-y += -DAR600x_DUAL_ANTENNA
 endif
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 8f9e4b2..1798889 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -2334,10 +2334,10 @@ u8 ar6000_endpoint_id2_ac(void * devt, HTC_ENDPOINT_ID ep )
 int ar6000_target_config_wlan_params(struct ar6_softc *ar)
 {
     int status = 0;
-#if defined(ENABLE_COEXISTENCE)
+#if defined(CONFIG_ATH6KL_ENABLE_COEXISTENCE)
     WMI_SET_BTCOEX_COLOCATED_BT_DEV_CMD sbcb_cmd;
     WMI_SET_BTCOEX_FE_ANT_CMD sbfa_cmd;
-#endif /* ENABLE_COEXISTENCE */
+#endif /* CONFIG_ATH6KL_ENABLE_COEXISTENCE */
 
 #ifdef CONFIG_HOST_TCMD_SUPPORT
     if (ar->arTargetMode != AR6000_WLAN_MODE) {
@@ -2355,7 +2355,7 @@ int ar6000_target_config_wlan_params(struct ar6_softc *ar)
         status = A_ERROR;
     }
 
-#if defined(ENABLE_COEXISTENCE)
+#if defined(CONFIG_ATH6KL_ENABLE_COEXISTENCE)
     /* Configure the type of BT collocated with WLAN */
     memset(&sbcb_cmd, 0, sizeof(WMI_SET_BTCOEX_COLOCATED_BT_DEV_CMD));
 #ifdef CONFIG_AR600x_BT_QCOM
@@ -2387,7 +2387,7 @@ int ar6000_target_config_wlan_params(struct ar6_softc *ar)
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Unable to set fornt end antenna configuration\n"));
         status = A_ERROR;
     }
-#endif /* ENABLE_COEXISTENCE */
+#endif /* CONFIG_ATH6KL_ENABLE_COEXISTENCE */
 
 #if WLAN_CONFIG_IGNORE_POWER_SAVE_FAIL_EVENT_DURING_SCAN
     if ((wmi_pmparams_cmd(ar->arWmi, 0, 1, 0, 0, 1, IGNORE_POWER_SAVE_FAIL_EVENT_DURING_SCAN)) != 0) {
-- 
1.7.0.4

