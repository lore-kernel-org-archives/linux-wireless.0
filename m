Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:39113 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759772Ab1D2RL4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 13:11:56 -0400
Subject: [PATCH 2/2] staging: ath6kl: open/shared auth implementation
To: gregkh@suse.de
From: Kalle Valo <kvalo@adurom.com>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Date: Fri, 29 Apr 2011 20:02:31 +0300
Message-ID: <20110429170231.26819.50966.stgit@x201> (sfid-20110429_191159_152050_2B5AB95C)
In-Reply-To: <20110429165934.26819.76573.stgit@x201>
References: <20110429165934.26819.76573.stgit@x201>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Naveen Singh <nsingh@atheros.com>

If the wpa_supplicant conf file supplies both open and shared
algorithm, and AP is configured as shared then connection never
happens. Since it is a FMAC driver additional logic is added in
driver which first detects this, then tries open algorithm for the
first time and when it fails tries the shared algo.

kvalo: fix style issues

Signed-off-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Kalle Valo <kalle.valo@atheros.com>
---
 drivers/staging/ath6kl/include/common/wmi.h        |    5 +
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |    1 
 drivers/staging/ath6kl/os/linux/cfg80211.c         |   89 ++++++++++++++++----
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |    1 
 4 files changed, 80 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/ath6kl/include/common/wmi.h b/drivers/staging/ath6kl/include/common/wmi.h
index 24636e6..6549839 100644
--- a/drivers/staging/ath6kl/include/common/wmi.h
+++ b/drivers/staging/ath6kl/include/common/wmi.h
@@ -521,6 +521,11 @@ typedef enum {
     LEAP_AUTH           = 0x04,  /* different from IEEE_AUTH_MODE definitions */
 } DOT11_AUTH_MODE;
 
+enum {
+	AUTH_IDLE,
+	AUTH_OPEN_IN_PROGRESS,
+};
+
 typedef enum {
     NONE_AUTH           = 0x01,
     WPA_AUTH            = 0x02,
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 1c7c159..93ebff4 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -1678,6 +1678,7 @@ ar6000_avail_ev(void *context, void *hif_handle)
     wdev->netdev = dev;
     ar->arNetworkType = INFRA_NETWORK;
     ar->smeState = SME_DISCONNECTED;
+    ar->arAutoAuthStage = AUTH_IDLE;
 
     init_netdev(dev, ifname);
 
diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
index f6e3817..efd4ae5 100644
--- a/drivers/staging/ath6kl/os/linux/cfg80211.c
+++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
@@ -172,6 +172,12 @@ ar6k_set_auth_type(struct ar6_softc *ar, enum nl80211_auth_type auth_type)
     case NL80211_AUTHTYPE_NETWORK_EAP:
         ar->arDot11AuthMode = LEAP_AUTH;
         break;
+
+    case NL80211_AUTHTYPE_AUTOMATIC:
+        ar->arDot11AuthMode = OPEN_AUTH;
+        ar->arAutoAuthStage = AUTH_OPEN_IN_PROGRESS;
+        break;
+
     default:
         ar->arDot11AuthMode = OPEN_AUTH;
         AR_DEBUG_PRINTF(ATH_DEBUG_INFO,
@@ -460,6 +466,8 @@ ar6k_cfg80211_connect_event(struct ar6_softc *ar, u16 channel,
     assocReqLen -= assocReqIeOffset;
     assocRespLen -= assocRespIeOffset;
 
+    ar->arAutoAuthStage = AUTH_IDLE;
+
     if((ADHOC_NETWORK & networkType)) {
         if(NL80211_IFTYPE_ADHOC != ar->wdev->iftype) {
             AR_DEBUG_PRINTF(ATH_DEBUG_INFO,
@@ -633,6 +641,8 @@ ar6k_cfg80211_disconnect_event(struct ar6_softc *ar, u8 reason,
                                u8 *assocInfo, u16 protocolReasonStatus)
 {
 
+    u16 status;
+
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO, ("%s: reason=%u\n", __func__, reason));
 
     if (ar->scan_request) {
@@ -663,23 +673,70 @@ ar6k_cfg80211_disconnect_event(struct ar6_softc *ar, u8 reason,
             /* connect cmd failed */
             wmi_disconnect_cmd(ar->arWmi);
         } else if (reason == DISCONNECT_CMD) {
-            /* connection loss due to disconnect cmd or low rssi */
-            ar->arConnectPending = false;   
-            if (ar->smeState == SME_CONNECTING) {
-                cfg80211_connect_result(ar->arNetDev, bssid,
-                                        NULL, 0,
-                                        NULL, 0,
-                                        WLAN_STATUS_UNSPECIFIED_FAILURE,
-                                        GFP_KERNEL);
-            } else {
-                cfg80211_disconnected(ar->arNetDev, reason, NULL, 0, GFP_KERNEL);
-            }
-            ar->smeState = SME_DISCONNECTED;
-        }
+		if (ar->arAutoAuthStage) {
+			/*
+			 * If the current auth algorithm is open try shared
+			 * and make autoAuthStage idle. We do not make it
+			 * leap for now being.
+			 */
+			if (ar->arDot11AuthMode == OPEN_AUTH) {
+				struct ar_key *key = NULL;
+				key = &ar->keys[ar->arDefTxKeyIndex];
+				if (down_interruptible(&ar->arSem)) {
+					AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("%s: busy, couldn't get access\n", __func__));
+					return;
+				}
+
+
+				ar->arDot11AuthMode = SHARED_AUTH;
+				ar->arAutoAuthStage = AUTH_IDLE;
+
+				wmi_addKey_cmd(ar->arWmi, ar->arDefTxKeyIndex,
+						ar->arPairwiseCrypto,
+						GROUP_USAGE | TX_USAGE,
+						key->key_len,
+						NULL,
+						key->key, KEY_OP_INIT_VAL, NULL,
+						NO_SYNC_WMIFLAG);
+
+				status = wmi_connect_cmd(ar->arWmi,
+							 ar->arNetworkType,
+							 ar->arDot11AuthMode,
+							 ar->arAuthMode,
+							 ar->arPairwiseCrypto,
+							 ar->arPairwiseCryptoLen,
+							 ar->arGroupCrypto,
+							 ar->arGroupCryptoLen,
+							 ar->arSsidLen,
+							 ar->arSsid,
+							 ar->arReqBssid,
+							 ar->arChannelHint,
+							 ar->arConnectCtrlFlags);
+				up(&ar->arSem);
+
+			} else if (ar->arDot11AuthMode == SHARED_AUTH) {
+				/* should not reach here */
+			}
+		} else {
+			ar->arConnectPending = false;
+			if (ar->smeState == SME_CONNECTING) {
+				cfg80211_connect_result(ar->arNetDev, bssid,
+							NULL, 0,
+							NULL, 0,
+							WLAN_STATUS_UNSPECIFIED_FAILURE,
+							GFP_KERNEL);
+			} else {
+				cfg80211_disconnected(ar->arNetDev,
+						      reason,
+						      NULL, 0,
+						      GFP_KERNEL);
+			}
+			ar->smeState = SME_DISCONNECTED;
+		}
+	}
     } else {
-        if (reason != DISCONNECT_CMD) {
-            wmi_disconnect_cmd(ar->arWmi);
-        }
+	    if (reason != DISCONNECT_CMD)
+		    wmi_disconnect_cmd(ar->arWmi);
     }
 }
 
diff --git a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
index b466e7f..0c50c7a 100644
--- a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
+++ b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
@@ -653,6 +653,7 @@ struct ar6_softc {
 #ifdef CONFIG_AP_VIRTUAL_ADAPTER_SUPPORT
     void                    *arApDev;
 #endif
+    u8 arAutoAuthStage;
 };
 
 #ifdef CONFIG_AP_VIRTUAL_ADAPTER_SUPPORT

