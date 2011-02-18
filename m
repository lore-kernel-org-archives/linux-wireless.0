Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:53999 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574Ab1BRVOT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 16:14:19 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 13:13:57 -0800
From: Vipin Mehta <vmehta@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>, <vmehta@atheros.com>,
	<devel@driverdev.osuosl.org>
Subject: [PATCH 13/15] staging: ath6kl: Adding state in driver to track the sme state
Date: Fri, 18 Feb 2011 13:13:14 -0800
Message-ID: <1298063596-2096-13-git-send-email-vmehta@atheros.com>
In-Reply-To: <1298063596-2096-1-git-send-email-vmehta@atheros.com>
References: <1298063596-2096-1-git-send-email-vmehta@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding state in driver to track the sme state. The connect/disconnect
events from the driver were messing up the state maintained within the
cfg80211 module.

Signed-off-by: Vipin Mehta <vmehta@atheros.com>
---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |    1 +
 drivers/staging/ath6kl/os/linux/cfg80211.c         |   28 ++++++++++++++-----
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |    7 +++++
 3 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 93592af..5dc5cf0 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -1670,6 +1670,7 @@ ar6000_avail_ev(void *context, void *hif_handle)
     SET_NETDEV_DEV(dev, wiphy_dev(wdev->wiphy));
     wdev->netdev = dev;
     ar->arNetworkType = INFRA_NETWORK;
+    ar->smeState = SME_DISCONNECTED;
 #endif /* ATH6K_CONFIG_CFG80211 */
 
     init_netdev(dev, ifname);
diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
index 0f8f868..8644d19 100644
--- a/drivers/staging/ath6kl/os/linux/cfg80211.c
+++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
@@ -248,6 +248,7 @@ ar6k_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
     int status;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO, ("%s: \n", __func__));
+    ar->smeState = SME_CONNECTING;
 
     if(ar->arWmiReady == false) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("%s: Wmi not ready yet\n", __func__));
@@ -562,6 +563,7 @@ ar6k_cfg80211_connect_event(AR_SOFTC_T *ar, u16 channel,
 
     if (false == ar->arConnected) {
         /* inform connect result to cfg80211 */
+        ar->smeState = SME_DISCONNECTED;
         cfg80211_connect_result(ar->arNetDev, bssid,
                                 assocReqIe, assocReqLen,
                                 assocRespIe, assocRespLen,
@@ -644,18 +646,28 @@ ar6k_cfg80211_disconnect_event(AR_SOFTC_T *ar, u8 reason,
         }
     }
 
-    if(false == ar->arConnected) {
+    if(true == ar->arConnectPending) {
         if(NO_NETWORK_AVAIL == reason) {
             /* connect cmd failed */
-            cfg80211_connect_result(ar->arNetDev, bssid,
-                                    NULL, 0,
-                                    NULL, 0,
-                                    WLAN_STATUS_UNSPECIFIED_FAILURE,
-                                    GFP_KERNEL);
+            wmi_disconnect_cmd(ar->arWmi);
+        } else if (reason == DISCONNECT_CMD) {
+            /* connection loss due to disconnect cmd or low rssi */
+            ar->arConnectPending = false;   
+            if (ar->smeState == SME_CONNECTING) {
+                cfg80211_connect_result(ar->arNetDev, bssid,
+                                        NULL, 0,
+                                        NULL, 0,
+                                        WLAN_STATUS_UNSPECIFIED_FAILURE,
+                                        GFP_KERNEL);
+            } else {
+                cfg80211_disconnected(ar->arNetDev, reason, NULL, 0, GFP_KERNEL);
+            }
+            ar->smeState = SME_DISCONNECTED;
         }
     } else {
-        /* connection loss due to disconnect cmd or low rssi */
-        cfg80211_disconnected(ar->arNetDev, reason, NULL, 0, GFP_KERNEL);
+        if (reason != DISCONNECT_CMD) {
+            wmi_disconnect_cmd(ar->arWmi);
+        }
     }
 }
 
diff --git a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
index 339925a..f3b7344 100644
--- a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
+++ b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
@@ -393,6 +393,12 @@ struct ar_key {
     u8 seq_len;
     u32 cipher;
 };
+
+enum {
+    SME_DISCONNECTED,
+    SME_CONNECTING,
+    SME_CONNECTED
+};
 #endif /* ATH6K_CONFIG_CFG80211 */
 
 
@@ -595,6 +601,7 @@ typedef struct ar6_softc {
     struct wireless_dev *wdev;
     struct cfg80211_scan_request    *scan_request;
     struct ar_key   keys[WMI_MAX_KEY_INDEX + 1];
+    u32 smeState;
 #endif /* ATH6K_CONFIG_CFG80211 */
     u16 arWlanPowerState;
     bool                  arWlanOff;
-- 
1.6.3.3

