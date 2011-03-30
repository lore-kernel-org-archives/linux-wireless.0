Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47167 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341Ab1C3A5d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 20:57:33 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 17:57:08 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 23/34] ath6kl: simplify btcoex parameter programming
Date: Tue, 29 Mar 2011 17:56:20 -0700
Message-ID: <1301446591-15236-24-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
References: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make the code more legible by parsing the config options on
the header file. While a it ensure to propagate errors and
bail out if we fail to set btcoex params.

Cc: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |   80 +++++++++++---------
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |   19 +++++
 2 files changed, 62 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 1798889..f08f165 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -2328,16 +2328,52 @@ u8 ar6000_endpoint_id2_ac(void * devt, HTC_ENDPOINT_ID ep )
     return(arEndpoint2Ac(ar, ep ));
 }
 
+#if defined(CONFIG_ATH6KL_ENABLE_COEXISTENCE)
+static int ath6kl_config_btcoex_params(struct ar6_softc *ar)
+{
+	int r;
+	WMI_SET_BTCOEX_COLOCATED_BT_DEV_CMD sbcb_cmd;
+	WMI_SET_BTCOEX_FE_ANT_CMD sbfa_cmd;
+
+	/* Configure the type of BT collocated with WLAN */
+	memset(&sbcb_cmd, 0, sizeof(WMI_SET_BTCOEX_COLOCATED_BT_DEV_CMD));
+	sbcb_cmd.btcoexCoLocatedBTdev = ATH6KL_BT_DEV;
+
+	r = wmi_set_btcoex_colocated_bt_dev_cmd(ar->arWmi, &sbcb_cmd);
+
+	if (r) {
+		AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
+				("Unable to set collocated BT type\n"));
+		return r;
+	}
+
+	/* Configure the type of BT collocated with WLAN */
+	memset(&sbfa_cmd, 0, sizeof(WMI_SET_BTCOEX_FE_ANT_CMD));
+
+	sbfa_cmd.btcoexFeAntType = ATH6KL_BT_ANTENNA;
+
+	r = wmi_set_btcoex_fe_ant_cmd(ar->arWmi, &sbfa_cmd);
+	if (r) {
+		AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
+				("Unable to set fornt end antenna configuration\n"));
+		return r;
+	}
+
+	return 0;
+}
+#else
+static int ath6kl_config_btcoex_params(struct ar6_softc *ar)
+{
+	return 0;
+}
+#endif /* CONFIG_ATH6KL_ENABLE_COEXISTENCE */
+
 /*
  * This function applies WLAN specific configuration defined in wlan_config.h
  */
 int ar6000_target_config_wlan_params(struct ar6_softc *ar)
 {
     int status = 0;
-#if defined(CONFIG_ATH6KL_ENABLE_COEXISTENCE)
-    WMI_SET_BTCOEX_COLOCATED_BT_DEV_CMD sbcb_cmd;
-    WMI_SET_BTCOEX_FE_ANT_CMD sbfa_cmd;
-#endif /* CONFIG_ATH6KL_ENABLE_COEXISTENCE */
 
 #ifdef CONFIG_HOST_TCMD_SUPPORT
     if (ar->arTargetMode != AR6000_WLAN_MODE) {
@@ -2355,39 +2391,9 @@ int ar6000_target_config_wlan_params(struct ar6_softc *ar)
         status = A_ERROR;
     }
 
-#if defined(CONFIG_ATH6KL_ENABLE_COEXISTENCE)
-    /* Configure the type of BT collocated with WLAN */
-    memset(&sbcb_cmd, 0, sizeof(WMI_SET_BTCOEX_COLOCATED_BT_DEV_CMD));
-#ifdef CONFIG_AR600x_BT_QCOM
-    sbcb_cmd.btcoexCoLocatedBTdev = 1;
-#elif defined(CONFIG_AR600x_BT_CSR)
-    sbcb_cmd.btcoexCoLocatedBTdev = 2;
-#elif defined(CONFIG_AR600x_BT_AR3001)
-    sbcb_cmd.btcoexCoLocatedBTdev = 3;
-#else
-#error Unsupported Bluetooth Type
-#endif /* Collocated Bluetooth Type */
-
-    if ((wmi_set_btcoex_colocated_bt_dev_cmd(ar->arWmi, &sbcb_cmd)) != 0) {
-        AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Unable to set collocated BT type\n"));
-        status = A_ERROR;
-    }
-
-    /* Configure the type of BT collocated with WLAN */
-    memset(&sbfa_cmd, 0, sizeof(WMI_SET_BTCOEX_FE_ANT_CMD));
-#ifdef CONFIG_AR600x_DUAL_ANTENNA
-    sbfa_cmd.btcoexFeAntType = 2;
-#elif defined(CONFIG_AR600x_SINGLE_ANTENNA)
-    sbfa_cmd.btcoexFeAntType = 1;
-#else
-#error Unsupported Front-End Antenna Configuration
-#endif /* AR600x Front-End Antenna Configuration */
-
-    if ((wmi_set_btcoex_fe_ant_cmd(ar->arWmi, &sbfa_cmd)) != 0) {
-        AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Unable to set fornt end antenna configuration\n"));
-        status = A_ERROR;
-    }
-#endif /* CONFIG_ATH6KL_ENABLE_COEXISTENCE */
+    status = ath6kl_config_btcoex_params(ar);
+    if (status)
+	return status;
 
 #if WLAN_CONFIG_IGNORE_POWER_SAVE_FAIL_EVENT_DURING_SCAN
     if ((wmi_pmparams_cmd(ar->arWmi, 0, 1, 0, 0, 1, IGNORE_POWER_SAVE_FAIL_EVENT_DURING_SCAN)) != 0) {
diff --git a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
index 764f8f1..e47b078 100644
--- a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
+++ b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
@@ -228,6 +228,25 @@ typedef enum _AR6K_BIN_FILE {
 #define NOHIFSCATTERSUPPORT_DEFAULT    0
 #endif /* ATH6K_CONFIG_HIF_VIRTUAL_SCATTER */
 
+
+#if defined(CONFIG_ATH6KL_ENABLE_COEXISTENCE)
+
+#ifdef CONFIG_AR600x_BT_QCOM
+#define ATH6KL_BT_DEV 1
+#elif defined(CONFIG_AR600x_BT_CSR)
+#define ATH6KL_BT_DEV 2
+#else
+#define ATH6KL_BT_DEV 3
+#endif
+
+#ifdef CONFIG_AR600x_DUAL_ANTENNA
+#define ATH6KL_BT_ANTENNA 2
+#else
+#define ATH6KL_BT_ANTENNA 1
+#endif
+
+#endif /* CONFIG_ATH6KL_ENABLE_COEXISTENCE */
+
 #ifdef AR600x_BT_AR3001
 #define AR3KHCIBAUD_DEFAULT        3000000
 #define HCIUARTSCALE_DEFAULT       1
-- 
1.7.0.4

