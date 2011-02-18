Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:53996 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374Ab1BRVOP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 16:14:15 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 13:13:54 -0800
From: Vipin Mehta <vmehta@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>, <vmehta@atheros.com>,
	<devel@driverdev.osuosl.org>
Subject: [PATCH 10/15] staging: ath6kl: Add configuration for excessive TX retry threshold
Date: Fri, 18 Feb 2011 13:13:11 -0800
Message-ID: <1298063596-2096-10-git-send-email-vmehta@atheros.com>
In-Reply-To: <1298063596-2096-1-git-send-email-vmehta@atheros.com>
References: <1298063596-2096-1-git-send-email-vmehta@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding host side interface to configure the excessive TX retry threshold.
It is used by the target to determine disconnection triggers. Additionally,
some definitions have been added to header file wmi.h to bridge the gap
for the newly added command.

Signed-off-by: Vipin Mehta <vmehta@atheros.com>
---
 drivers/staging/ath6kl/include/common/wmi.h        |   36 ++++++++++++++------
 drivers/staging/ath6kl/include/wmi_api.h           |    3 ++
 .../staging/ath6kl/os/linux/include/athdrv_linux.h |    1 +
 .../ath6kl/os/linux/include/wmi_filter_linux.h     |    7 ++++
 drivers/staging/ath6kl/os/linux/ioctl.c            |   28 +++++++++++++++
 drivers/staging/ath6kl/wmi/wmi.c                   |   21 +++++++++++
 6 files changed, 85 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/ath6kl/include/common/wmi.h b/drivers/staging/ath6kl/include/common/wmi.h
index f16ef28..a8b143a 100644
--- a/drivers/staging/ath6kl/include/common/wmi.h
+++ b/drivers/staging/ath6kl/include/common/wmi.h
@@ -422,17 +422,24 @@ typedef enum {
     WMI_AP_SET_11BG_RATESET_CMDID,
     WMI_SET_PMK_CMDID,
     WMI_MCAST_FILTER_CMDID,
-	/* COEX CMDID AR6003*/
-	WMI_SET_BTCOEX_FE_ANT_CMDID,
-	WMI_SET_BTCOEX_COLOCATED_BT_DEV_CMDID,
-	WMI_SET_BTCOEX_SCO_CONFIG_CMDID,
-	WMI_SET_BTCOEX_A2DP_CONFIG_CMDID,
-	WMI_SET_BTCOEX_ACLCOEX_CONFIG_CMDID,
-	WMI_SET_BTCOEX_BTINQUIRY_PAGE_CONFIG_CMDID,
-	WMI_SET_BTCOEX_DEBUG_CMDID,
-	WMI_SET_BTCOEX_BT_OPERATING_STATUS_CMDID,
-	WMI_GET_BTCOEX_STATS_CMDID,
-	WMI_GET_BTCOEX_CONFIG_CMDID,
+    /* COEX CMDID AR6003*/
+    WMI_SET_BTCOEX_FE_ANT_CMDID,
+    WMI_SET_BTCOEX_COLOCATED_BT_DEV_CMDID,
+    WMI_SET_BTCOEX_SCO_CONFIG_CMDID,
+    WMI_SET_BTCOEX_A2DP_CONFIG_CMDID,
+    WMI_SET_BTCOEX_ACLCOEX_CONFIG_CMDID,
+    WMI_SET_BTCOEX_BTINQUIRY_PAGE_CONFIG_CMDID,
+    WMI_SET_BTCOEX_DEBUG_CMDID,
+    WMI_SET_BTCOEX_BT_OPERATING_STATUS_CMDID,
+    WMI_GET_BTCOEX_STATS_CMDID,
+    WMI_GET_BTCOEX_CONFIG_CMDID,
+    WMI_GET_PMK_CMDID,
+    WMI_SET_PASSPHRASE_CMDID,
+    WMI_ENABLE_WAC_CMDID,
+    WMI_WAC_SCAN_REPLY_CMDID,
+    WMI_WAC_CTRL_REQ_CMDID,
+    WMI_SET_DIV_PARAMS_CMDID,
+    WMI_SET_EXCESS_TX_RETRY_THRES_CMDID,
 } WMI_COMMAND_ID;
 
 /*
@@ -550,6 +557,13 @@ typedef PREPACK struct {
 } POSTPACK WMI_SET_PMK_CMD;
 
 /*
+ * WMI_SET_EXCESS_TX_RETRY_THRES_CMDID
+ */
+typedef PREPACK struct {
+    A_UINT32 threshold;
+} POSTPACK WMI_SET_EXCESS_TX_RETRY_THRES_CMD;
+
+/*
  * WMI_ADD_CIPHER_KEY_CMDID
  */
 typedef enum {
diff --git a/drivers/staging/ath6kl/include/wmi_api.h b/drivers/staging/ath6kl/include/wmi_api.h
index e51440a..7ba8505 100644
--- a/drivers/staging/ath6kl/include/wmi_api.h
+++ b/drivers/staging/ath6kl/include/wmi_api.h
@@ -421,6 +421,9 @@ wmi_set_wlan_conn_precedence_cmd(struct wmi_t *wmip, BT_WLAN_CONN_PRECEDENCE pre
 int
 wmi_set_pmk_cmd(struct wmi_t *wmip, u8 *pmk);
 
+int
+wmi_set_excess_tx_retry_thres_cmd(struct wmi_t *wmip, WMI_SET_EXCESS_TX_RETRY_THRES_CMD *cmd);
+
 u16 wmi_ieee2freq (int chan);
 
 u32 wmi_freq2ieee (u16 freq);
diff --git a/drivers/staging/ath6kl/os/linux/include/athdrv_linux.h b/drivers/staging/ath6kl/os/linux/include/athdrv_linux.h
index 383571a..5a6c27e 100644
--- a/drivers/staging/ath6kl/os/linux/include/athdrv_linux.h
+++ b/drivers/staging/ath6kl/os/linux/include/athdrv_linux.h
@@ -997,6 +997,7 @@ typedef enum {
 
 #define AR6000_XIOCTL_WMI_SET_TX_SGI_PARAM              154
 
+#define AR6000_XIOCTL_WMI_SET_EXCESS_TX_RETRY_THRES     161
 
 /* used by AR6000_IOCTL_WMI_GETREV */
 struct ar6000_version {
diff --git a/drivers/staging/ath6kl/os/linux/include/wmi_filter_linux.h b/drivers/staging/ath6kl/os/linux/include/wmi_filter_linux.h
index 0652c69..d172625 100644
--- a/drivers/staging/ath6kl/os/linux/include/wmi_filter_linux.h
+++ b/drivers/staging/ath6kl/os/linux/include/wmi_filter_linux.h
@@ -288,6 +288,13 @@ u8 xioctl_filter[] = {
 (0xFF),                                         /* AR6000_XIOCTL_ADD_AP_INTERFACE                  152  */
 (0xFF),                                         /* AR6000_XIOCTL_REMOVE_AP_INTERFACE               153  */
 (0xFF),                                         /* AR6000_XIOCTL_WMI_SET_TX_SGI_PARAM              154  */
+(INFRA_NETWORK | ADHOC_NETWORK),                /* AR6000_XIOCTL_WMI_SET_WPA_OFFLOAD_STATE         155  */
+(INFRA_NETWORK | ADHOC_NETWORK),                /* AR6000_XIOCTL_WMI_SET_PASSPHRASE                156  */
+(0xFF),
+(0xFF),
+(0xFF),
+(0xFF),
+(INFRA_NETWORK | ADHOC_NETWORK),                /* AR6000_XIOCTL_WMI_SET_EXCESS_TX_RETRY_THRES     161  */
 };
 
 #endif /*_WMI_FILTER_LINUX_H_*/
diff --git a/drivers/staging/ath6kl/os/linux/ioctl.c b/drivers/staging/ath6kl/os/linux/ioctl.c
index 5be8ea3..fe275c7 100644
--- a/drivers/staging/ath6kl/os/linux/ioctl.c
+++ b/drivers/staging/ath6kl/os/linux/ioctl.c
@@ -1329,6 +1329,28 @@ ar6000_xioctl_get_btcoex_stats_cmd(struct net_device * dev, char *userdata, stru
 	return(ret);
 }
 
+static int
+ar6000_xioctl_set_excess_tx_retry_thres_cmd(struct net_device * dev, char * userdata)
+{
+    AR_SOFTC_T     *ar     = (AR_SOFTC_T *)ar6k_priv(dev);
+    WMI_SET_EXCESS_TX_RETRY_THRES_CMD cmd;
+    int ret = 0;
+
+    if (ar->arWmiReady == false) {
+        return -EIO;
+    }
+
+    if (copy_from_user(&cmd, userdata, sizeof(cmd))) {
+        return -EFAULT;
+    }
+
+    if (wmi_set_excess_tx_retry_thres_cmd(ar->arWmi, &cmd) != 0)
+    {
+        ret = -EINVAL;
+    }
+    return(ret);
+}
+
 #ifdef CONFIG_HOST_GPIO_SUPPORT
 struct ar6000_gpio_intr_wait_cmd_s  gpio_intr_results;
 /* gpio_reg_results and gpio_data_available are protected by arSem */
@@ -4660,6 +4682,12 @@ int ar6000_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 #endif
             break;
 
+        case AR6000_XIOCTL_WMI_SET_EXCESS_TX_RETRY_THRES:
+        {
+            ret = ar6000_xioctl_set_excess_tx_retry_thres_cmd(dev, userdata);
+            break;
+        }
+
         default:
             ret = -EOPNOTSUPP;
     }
diff --git a/drivers/staging/ath6kl/wmi/wmi.c b/drivers/staging/ath6kl/wmi/wmi.c
index 242e855..acbf6ed 100644
--- a/drivers/staging/ath6kl/wmi/wmi.c
+++ b/drivers/staging/ath6kl/wmi/wmi.c
@@ -6610,6 +6610,27 @@ wmi_set_pmk_cmd(struct wmi_t *wmip, u8 *pmk)
 }
 
 int
+wmi_set_excess_tx_retry_thres_cmd(struct wmi_t *wmip, WMI_SET_EXCESS_TX_RETRY_THRES_CMD *cmd)
+{
+    void *osbuf;
+    WMI_SET_EXCESS_TX_RETRY_THRES_CMD *p;
+
+    osbuf = A_NETBUF_ALLOC(sizeof(WMI_SET_EXCESS_TX_RETRY_THRES_CMD));
+    if (osbuf == NULL) {
+        return A_NO_MEMORY;
+    }
+
+    A_NETBUF_PUT(osbuf, sizeof(WMI_SET_EXCESS_TX_RETRY_THRES_CMD));
+
+    p = (WMI_SET_EXCESS_TX_RETRY_THRES_CMD *)(A_NETBUF_DATA(osbuf));
+    memset(p, 0, sizeof(*p));
+
+    p->threshold = cmd->threshold;
+
+    return (wmi_cmd_send(wmip, osbuf, WMI_SET_EXCESS_TX_RETRY_THRES_CMDID, NO_SYNC_WMIFLAG));
+}
+
+int
 wmi_SGI_cmd(struct wmi_t *wmip, u32 sgiMask, u8 sgiPERThreshold)
 {
     void *osbuf;
-- 
1.6.3.3

