Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:53758 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab2KXOWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2012 09:22:16 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so2783318wer.19
        for <linux-wireless@vger.kernel.org>; Sat, 24 Nov 2012 06:22:14 -0800 (PST)
Message-ID: <1353766928.2318.3.camel@user64-MCP7A> (sfid-20121124_152220_735234_DA5E86D0)
Subject: [PATCH 02/10] staging: vt6656: move move all commands to iw_handler.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sat, 24 Nov 2012 14:22:08 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/iwctl.c    |  381 +++++++++++++++++++++++++------------
 drivers/staging/vt6656/iwctl.h    |   77 ++++----
 drivers/staging/vt6656/main_usb.c |  379 ------------------------------------
 3 files changed, 298 insertions(+), 539 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 08557fa..11d2903 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -31,7 +31,7 @@
  */
 
 #include "device.h"
-#include "ioctl.h"
+#include "iwctl.h"
 #include "iocmd.h"
 #include "mac.h"
 #include "card.h"
@@ -40,10 +40,10 @@
 #include "rf.h"
 #include "iowpa.h"
 #include "wpactl.h"
+#include "control.h"
+#include "rndis.h"
 
-#include <net/iw_handler.h>
-
-#define SUPPORTED_WIRELESS_EXT 18
+#define SUPPORTED_WIRELESS_EXT 19
 
 static const long frequency_list[] = {
 	2412, 2417, 2422, 2427, 2432, 2437, 2442, 2447, 2452, 2457, 2462, 2467, 2472, 2484,
@@ -81,9 +81,9 @@ struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
  * Wireless Handler: get protocol name
  */
 int iwctl_giwname(struct net_device *dev, struct iw_request_info *info,
-		char *wrq, char *extra)
+		union iwreq_data *wrqu, char *extra)
 {
-	strcpy(wrq, "802.11-a/b/g");
+	strcpy(wrqu->name, "802.11-a/b/g");
 	return 0;
 }
 
@@ -91,9 +91,10 @@ int iwctl_giwname(struct net_device *dev, struct iw_request_info *info,
  * Wireless Handler: set scan
  */
 int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
-		struct iw_point *wrq, char *extra)
+		union iwreq_data *wrqu, char *extra)
 {
 	PSDevice pDevice = netdev_priv(dev);
+	struct iw_point *wrq = &wrqu->data;
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	struct iw_scan_req *req = (struct iw_scan_req *)extra;
 	BYTE abyScanSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
@@ -102,7 +103,10 @@ int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
 	if (!(pDevice->flags & DEVICE_FLAGS_OPENED))
 		return -EINVAL;
 
-	PRINT_K(" SIOCSIWSCAN \n");
+	PRINT_K(" SIOCSIWSCAN\n");
+
+	if (pMgmt == NULL)
+		return -EFAULT;
 
 	if (pMgmt->eScanState ==  WMAC_IS_SCANNING) {
 		// In scanning..
@@ -161,8 +165,9 @@ int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
  * Wireless Handler : get scan results
  */
 int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
-		struct iw_point *wrq, char *extra)
+		union iwreq_data *wrqu, char *extra)
 {
+	struct iw_point *wrq = &wrqu->data;
 	int ii;
 	int jj;
 	int kk;
@@ -181,6 +186,9 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWSCAN\n");
 
+	if (pMgmt == NULL)
+		return -EFAULT;
+
 	if (pMgmt->eScanState ==  WMAC_IS_SCANNING) {
 		// In scanning..
 		return -EAGAIN;
@@ -308,12 +316,13 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
  * Wireless Handler: set frequence or channel
  */
 int iwctl_siwfreq(struct net_device *dev, struct iw_request_info *info,
-		struct iw_freq *wrq, char *extra)
+		union iwreq_data *wrqu, char *extra)
 {
 	PSDevice pDevice = netdev_priv(dev);
+	struct iw_freq *wrq = &wrqu->freq;
 	int rc = 0;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWFREQ \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWFREQ\n");
 
 	// If setting by frequency, convert to a channel
 	if ((wrq->e == 1) && (wrq->m >= (int)2.412e8) &&
@@ -346,12 +355,17 @@ int iwctl_siwfreq(struct net_device *dev, struct iw_request_info *info,
  * Wireless Handler: get frequence or channel
  */
 int iwctl_giwfreq(struct net_device *dev, struct iw_request_info *info,
-		struct iw_freq *wrq, char *extra)
+		union iwreq_data *wrqu, char *extra)
 {
 	PSDevice pDevice = netdev_priv(dev);
+	struct iw_freq *wrq = &wrqu->freq;
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWFREQ \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWFREQ\n");
+
+	if (pMgmt == NULL)
+		return -EFAULT;
+
 
 #ifdef WEXT_USECHANNELS
 	wrq->m = (int)pMgmt->uCurrChannel;
@@ -372,16 +386,21 @@ int iwctl_giwfreq(struct net_device *dev, struct iw_request_info *info,
  * Wireless Handler: set operation mode
  */
 int iwctl_siwmode(struct net_device *dev, struct iw_request_info *info,
-		__u32 *wmode, char *extra)
+		union iwreq_data *wrqu, char *extra)
 {
 	PSDevice pDevice = netdev_priv(dev);
+	__u32 *wmode = &wrqu->mode;
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	int rc = 0;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWMODE \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWMODE\n");
+
+	if (pMgmt == NULL)
+		return -EFAULT;
 
 	if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP && pDevice->bEnableHostapd) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Can't set operation mode, hostapd is running \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"Can't set operation mode, hostapd is running\n");
 		return rc;
 	}
 
@@ -425,19 +444,72 @@ int iwctl_siwmode(struct net_device *dev, struct iw_request_info *info,
 		rc = -EINVAL;
 	}
 
+	if (pDevice->bCommit) {
+		if (pMgmt->eConfigMode == WMAC_CONFIG_AP) {
+			netif_stop_queue(pDevice->dev);
+			spin_lock_irq(&pDevice->lock);
+			bScheduleCommand((void *) pDevice,
+				WLAN_CMD_RUN_AP, NULL);
+			spin_unlock_irq(&pDevice->lock);
+		} else {
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				"Commit the settings\n");
+
+			spin_lock_irq(&pDevice->lock);
+
+			if (pDevice->bLinkPass &&
+				memcmp(pMgmt->abyCurrSSID,
+					pMgmt->abyDesireSSID,
+					WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN)) {
+				bScheduleCommand((void *) pDevice,
+					WLAN_CMD_DISASSOCIATE, NULL);
+			} else {
+				pDevice->bLinkPass = FALSE;
+				pMgmt->eCurrState = WMAC_STATE_IDLE;
+				memset(pMgmt->abyCurrBSSID, 0, 6);
+			}
+
+			ControlvMaskByte(pDevice,
+				MESSAGE_REQUEST_MACREG,	MAC_REG_PAPEDELAY,
+					LEDSTS_STS, LEDSTS_SLOW);
+
+			netif_stop_queue(pDevice->dev);
+
+			pMgmt->eScanType = WMAC_SCAN_ACTIVE;
+
+			if (!pDevice->bWPASuppWextEnabled)
+				bScheduleCommand((void *) pDevice,
+					 WLAN_CMD_BSSID_SCAN,
+					 pMgmt->abyDesireSSID);
+
+			bScheduleCommand((void *) pDevice,
+				 WLAN_CMD_SSID,
+				 NULL);
+
+			spin_unlock_irq(&pDevice->lock);
+		}
+		pDevice->bCommit = FALSE;
+	}
+
+
 	return rc;
 }
 
 /*
  * Wireless Handler: get operation mode
  */
-void iwctl_giwmode(struct net_device *dev, struct iw_request_info *info,
-		__u32 *wmode, char *extra)
+int iwctl_giwmode(struct net_device *dev, struct iw_request_info *info,
+		union iwreq_data *wrqu, char *extra)
 {
 	PSDevice pDevice = netdev_priv(dev);
+	__u32 *wmode = &wrqu->mode;
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWMODE \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWMODE\n");
+
+	if (pMgmt == NULL)
+		return -EFAULT;
+
 	// If not managed, assume it's ad-hoc
 	switch (pMgmt->eConfigMode) {
 	case WMAC_CONFIG_ESS_STA:
@@ -455,14 +527,17 @@ void iwctl_giwmode(struct net_device *dev, struct iw_request_info *info,
 	default:
 		*wmode = IW_MODE_ADHOC;
 	}
+
+	return 0;
 }
 
 /*
  * Wireless Handler: get capability range
  */
-void iwctl_giwrange(struct net_device *dev, struct iw_request_info *info,
-		struct iw_point *wrq, char *extra)
+int iwctl_giwrange(struct net_device *dev, struct iw_request_info *info,
+		union iwreq_data *wrqu, char *extra)
 {
+	struct iw_point *wrq = &wrqu->data;
 	struct iw_range *range = (struct iw_range *)extra;
 	int i;
 	int k;
@@ -555,20 +630,26 @@ void iwctl_giwrange(struct net_device *dev, struct iw_request_info *info,
 		range->avg_qual.level = 176; // -80 dBm
 		range->avg_qual.noise = 0;
 	}
+
+	return 0;
 }
 
 /*
  * Wireless Handler : set ap mac address
  */
 int iwctl_siwap(struct net_device *dev, struct iw_request_info *info,
-		struct sockaddr *wrq, char *extra)
+		union iwreq_data *wrqu, char *extra)
 {
 	PSDevice pDevice = netdev_priv(dev);
+	struct sockaddr *wrq = &wrqu->ap_addr;
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	int rc = 0;
 	BYTE ZeroBSSID[WLAN_BSSID_LEN] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
 
-	PRINT_K(" SIOCSIWAP \n");
+	PRINT_K(" SIOCSIWAP\n");
+
+	if (pMgmt == NULL)
+		return -EFAULT;
 
 	if (wrq->sa_family != ARPHRD_ETHER) {
 		rc = -EINVAL;
@@ -609,12 +690,16 @@ int iwctl_siwap(struct net_device *dev, struct iw_request_info *info,
  * Wireless Handler: get ap mac address
  */
 int iwctl_giwap(struct net_device *dev, struct iw_request_info *info,
-		struct sockaddr *wrq, char *extra)
+		union iwreq_data *wrqu, char *extra)
 {
 	PSDevice pDevice = netdev_priv(dev);
+	struct sockaddr *wrq = &wrqu->ap_addr;
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWAP \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWAP\n");
+
+	if (pMgmt == NULL)
+		return -EFAULT;
 
 	memcpy(wrq->sa_data, pMgmt->abyCurrBSSID, 6);
 
@@ -632,8 +717,9 @@ int iwctl_giwap(struct net_device *dev, struct iw_request_info *info,
  * Wireless Handler: get ap list
  */
 int iwctl_giwaplist(struct net_device *dev, struct iw_request_info *info,
-		struct iw_point *wrq, u8 *extra)
+		union iwreq_data *wrqu, char *extra)
 {
+	struct iw_point *wrq = &wrqu->data;
 	struct sockaddr *sock;
 	struct iw_quality *qual;
 	PSDevice pDevice = netdev_priv(dev);
@@ -692,12 +778,16 @@ int iwctl_giwaplist(struct net_device *dev, struct iw_request_info *info,
  * Wireless Handler: set essid
  */
 int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
-		struct iw_point *wrq, char *extra)
+		union iwreq_data *wrqu, char *extra)
 {
 	PSDevice pDevice = netdev_priv(dev);
+	struct iw_point	*wrq = &wrqu->essid;
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	PWLAN_IE_SSID pItemSSID;
 
+	if (pMgmt == NULL)
+		return -EFAULT;
+
 	if (!(pDevice->flags & DEVICE_FLAGS_OPENED))
 		return -EINVAL;
 
@@ -794,14 +884,18 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 /*
  * Wireless Handler: get essid
  */
-void iwctl_giwessid(struct net_device *dev, struct iw_request_info *info,
-		struct iw_point *wrq, char *extra)
+int iwctl_giwessid(struct net_device *dev, struct iw_request_info *info,
+		union iwreq_data *wrqu, char *extra)
 {
 	PSDevice pDevice = netdev_priv(dev);
+	struct iw_point	*wrq = &wrqu->essid;
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	PWLAN_IE_SSID pItemSSID;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWESSID \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWESSID\n");
+
+	if (pMgmt == NULL)
+		return -EFAULT;
 
 	// Note: if wrq->u.data.flags != 0, we should get the relevant
 	// SSID from the SSID list...
@@ -813,15 +907,18 @@ void iwctl_giwessid(struct net_device *dev, struct iw_request_info *info,
 
         wrq->length = pItemSSID->len;
 	wrq->flags = 1; // active
+
+	return 0;
 }
 
 /*
  * Wireless Handler: set data rate
  */
 int iwctl_siwrate(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *wrq, char *extra)
+		union iwreq_data *wrqu, char *extra)
 {
 	PSDevice pDevice = netdev_priv(dev);
+	struct iw_param *wrq = &wrqu->bitrate;
 	int rc = 0;
 	u8 brate = 0;
 	int i;
@@ -895,13 +992,18 @@ int iwctl_siwrate(struct net_device *dev, struct iw_request_info *info,
 /*
  * Wireless Handler: get data rate
  */
-void iwctl_giwrate(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *wrq, char *extra)
+int iwctl_giwrate(struct net_device *dev, struct iw_request_info *info,
+		union iwreq_data *wrqu, char *extra)
 {
 	PSDevice pDevice = netdev_priv(dev);
+	struct iw_param *wrq = &wrqu->bitrate;
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRATE \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRATE\n");
+
+	if (pMgmt == NULL)
+		return -EFAULT;
+
 	{
 		BYTE abySupportedRates[13] = {
 			0x02, 0x04, 0x0B, 0x16, 0x0c, 0x12, 0x18, 0x24, 0x30,
@@ -934,14 +1036,18 @@ void iwctl_giwrate(struct net_device *dev, struct iw_request_info *info,
 		if (pDevice->bFixRate == TRUE)
 			wrq->fixed = TRUE;
 	}
+
+	return 0;
 }
 
 /*
  * Wireless Handler: set rts threshold
  */
-int iwctl_siwrts(struct net_device *dev, struct iw_param *wrq)
+int iwctl_siwrts(struct net_device *dev, struct iw_request_info *info,
+		union iwreq_data *wrqu, char *extra)
 {
 	PSDevice pDevice = netdev_priv(dev);
+	struct iw_param *wrq = &wrqu->rts;
 
 	if ((wrq->value < 0 || wrq->value > 2312) && !wrq->disabled)
 		return -EINVAL;
@@ -958,11 +1064,12 @@ int iwctl_siwrts(struct net_device *dev, struct iw_param *wrq)
  * Wireless Handler: get rts
  */
 int iwctl_giwrts(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *wrq, char *extra)
+		union iwreq_data *wrqu, char *extra)
 {
 	PSDevice pDevice = netdev_priv(dev);
+	struct iw_param *wrq = &wrqu->rts;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRTS \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRTS\n");
 	wrq->value = pDevice->wRTSThreshold;
 	wrq->disabled = (wrq->value >= 2312);
 	wrq->fixed = 1;
@@ -973,13 +1080,14 @@ int iwctl_giwrts(struct net_device *dev, struct iw_request_info *info,
  * Wireless Handler: set fragment threshold
  */
 int iwctl_siwfrag(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *wrq, char *extra)
+		union iwreq_data *wrqu, char *extra)
 {
 	PSDevice pDevice = netdev_priv(dev);
+	struct iw_param *wrq = &wrqu->frag;
 	int rc = 0;
 	int fthr = wrq->value;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWFRAG \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWFRAG\n");
 
 	if (wrq->disabled)
 		fthr = 2312;
@@ -996,11 +1104,12 @@ int iwctl_siwfrag(struct net_device *dev, struct iw_request_info *info,
  * Wireless Handler: get fragment threshold
  */
 int iwctl_giwfrag(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *wrq, char *extra)
+		union iwreq_data *wrqu, char *extra)
 {
 	PSDevice pDevice = netdev_priv(dev);
+	struct iw_param *wrq = &wrqu->frag;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWFRAG \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWFRAG\n");
 	wrq->value = pDevice->wFragmentationThreshold;
 	wrq->disabled = (wrq->value >= 2312);
 	wrq->fixed = 1;
@@ -1011,12 +1120,13 @@ int iwctl_giwfrag(struct net_device *dev, struct iw_request_info *info,
  * Wireless Handler: set retry threshold
  */
 int iwctl_siwretry(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *wrq, char *extra)
+		union iwreq_data *wrqu, char *extra)
 {
 	PSDevice pDevice = netdev_priv(dev);
+	struct iw_param *wrq = &wrqu->retry;
 	int rc = 0;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWRETRY \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWRETRY\n");
 
 	if (wrq->disabled) {
 		rc = -EINVAL;
@@ -1043,10 +1153,11 @@ int iwctl_siwretry(struct net_device *dev, struct iw_request_info *info,
  * Wireless Handler: get retry threshold
  */
 int iwctl_giwretry(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *wrq, char *extra)
+		union iwreq_data *wrqu, char *extra)
 {
 	PSDevice pDevice = netdev_priv(dev);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRETRY \n");
+	struct iw_param *wrq = &wrqu->retry;
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRETRY\n");
 	wrq->disabled = 0; // Can't be disabled
 
 	// Note: by default, display the min retry number
@@ -1069,17 +1180,21 @@ int iwctl_giwretry(struct net_device *dev, struct iw_request_info *info,
  * Wireless Handler: set encode mode
  */
 int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
-		struct iw_point *wrq, char *extra)
+		union iwreq_data *wrqu, char *extra)
 {
 	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
-	DWORD dwKeyIndex = (DWORD)(wrq->flags & IW_ENCODE_INDEX);
+	struct iw_point *wrq = &wrqu->encoding;
+	u32 dwKeyIndex = (u32)(wrq->flags & IW_ENCODE_INDEX);
 	int ii;
 	int uu;
 	int rc = 0;
 	int index = (wrq->flags & IW_ENCODE_INDEX);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWENCODE \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWENCODE\n");
+
+	if (pMgmt == NULL)
+		return -EFAULT;
 
 	// Check the size of the key
 	if (wrq->length > WLAN_WEP232_KEYLEN) {
@@ -1163,10 +1278,11 @@ int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
 }
 
 int iwctl_giwencode(struct net_device *dev, struct iw_request_info *info,
-		struct iw_point *wrq, char *extra)
+		union iwreq_data *wrqu, char *extra)
 {
 	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct iw_point *wrq = &wrqu->encoding;
 	char abyKey[WLAN_WEP232_KEYLEN];
 
 	unsigned index = (unsigned)(wrq->flags & IW_ENCODE_INDEX);
@@ -1174,6 +1290,9 @@ int iwctl_giwencode(struct net_device *dev, struct iw_request_info *info,
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWENCODE\n");
 
+	if (pMgmt == NULL)
+		return -EFAULT;
+
 	if (index > WLAN_WEP_NKEYS)
 		return	-EINVAL;
 	if (index < 1) { // get default key
@@ -1221,13 +1340,17 @@ int iwctl_giwencode(struct net_device *dev, struct iw_request_info *info,
  * Wireless Handler: set power mode
  */
 int iwctl_siwpower(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *wrq, char *extra)
+		union iwreq_data *wrqu, char *extra)
 {
 	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct iw_param *wrq = &wrqu->power;
 	int rc = 0;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER\n");
+
+	if (pMgmt == NULL)
+		return -EFAULT;
 
 	if (!(pDevice->flags & DEVICE_FLAGS_OPENED)) {
 		rc = -EINVAL;
@@ -1269,13 +1392,17 @@ int iwctl_siwpower(struct net_device *dev, struct iw_request_info *info,
  * Wireless Handler: get power mode
  */
 int iwctl_giwpower(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *wrq, char *extra)
+		union iwreq_data *wrqu, char *extra)
 {
 	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct iw_param *wrq = &wrqu->power;
 	int mode = pDevice->ePSMode;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWPOWER \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWPOWER\n");
+
+	if (pMgmt == NULL)
+		return -EFAULT;
 
 	if ((wrq->disabled = (mode == WMAC_POWER_CAM)))
 		return 0;
@@ -1295,12 +1422,13 @@ int iwctl_giwpower(struct net_device *dev, struct iw_request_info *info,
  * Wireless Handler: get Sensitivity
  */
 int iwctl_giwsens(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *wrq, char *extra)
+		union iwreq_data *wrqu, char *extra)
 {
 	PSDevice pDevice = netdev_priv(dev);
+	struct iw_param *wrq = &wrqu->sens;
 	long ldBm;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWSENS \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWSENS\n");
 	if (pDevice->bLinkPass == TRUE) {
 		RFvRSSITodBm(pDevice, (BYTE)(pDevice->uCurrRSSI), &ldBm);
 		wrq->value = ldBm;
@@ -1313,15 +1441,19 @@ int iwctl_giwsens(struct net_device *dev, struct iw_request_info *info,
 }
 
 int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *wrq, char *extra)
+		union iwreq_data *wrqu, char *extra)
 {
 	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct iw_param *wrq = &wrqu->param;
 	int ret = 0;
 	static int wpa_version = 0; // must be static to save the last value, einsn liu
 	static int pairwise = 0;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWAUTH \n");
+	if (pMgmt == NULL)
+		return -EFAULT;
+
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWAUTH\n");
 	switch (wrq->flags & IW_AUTH_INDEX) {
 	case IW_AUTH_WPA_VERSION:
 		wpa_version = wrq->value;
@@ -1405,6 +1537,7 @@ int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 		}
 		break;
 	default:
+		PRINT_K("iwctl_siwauth: not supported %x\n", wrq->flags);
 		ret = -EOPNOTSUPP;
 		break;
 	}
@@ -1412,18 +1545,22 @@ int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 }
 
 int iwctl_giwauth(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *wrq, char *extra)
+		union iwreq_data *wrqu, char *extra)
 {
 	return -EOPNOTSUPP;
 }
 
 int iwctl_siwgenie(struct net_device *dev, struct iw_request_info *info,
-		struct iw_point *wrq, char *extra)
+		union iwreq_data *wrqu, char *extra)
 {
 	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct iw_point *wrq = &wrqu->data;
 	int ret = 0;
 
+	if (pMgmt == NULL)
+		return -EFAULT;
+
 	if (wrq->length){
 		if ((wrq->length < 2) || (extra[1] + 2 != wrq->length)) {
 			ret = -EINVAL;
@@ -1449,13 +1586,17 @@ out: // not completely ...not necessary in wpa_supplicant 0.5.8
 }
 
 int iwctl_giwgenie(struct net_device *dev, struct iw_request_info *info,
-		struct iw_point *wrq, char *extra)
+		union iwreq_data *wrqu, char *extra)
 {
 	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct iw_point *wrq = &wrqu->data;
 	int ret = 0;
 	int space = wrq->length;
 
+	if (pMgmt == NULL)
+		return -EFAULT;
+
 	wrq->length = 0;
 	if (pMgmt->wWPAIELen > 0) {
 		wrq->length = pMgmt->wWPAIELen;
@@ -1471,10 +1612,11 @@ int iwctl_giwgenie(struct net_device *dev, struct iw_request_info *info,
 }
 
 int iwctl_siwencodeext(struct net_device *dev, struct iw_request_info *info,
-		struct iw_point *wrq, char *extra)
+		union iwreq_data *wrqu, char *extra)
 {
 	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct iw_point *wrq = &wrqu->encoding;
 	struct iw_encode_ext *ext = (struct iw_encode_ext*)extra;
 	struct viawget_wpa_param *param=NULL;
 // original member
@@ -1492,6 +1634,9 @@ int iwctl_siwencodeext(struct net_device *dev, struct iw_request_info *info,
 
 	PRINT_K("SIOCSIWENCODEEXT......\n");
 
+	if (pMgmt == NULL)
+		return -EFAULT;
+
 	buf = kzalloc(sizeof(struct viawget_wpa_param), GFP_KERNEL);
 	if (buf == NULL)
 		return -ENOMEM;
@@ -1594,19 +1739,24 @@ error:
 }
 
 int iwctl_giwencodeext(struct net_device *dev, struct iw_request_info *info,
-		struct iw_point *wrq, char *extra)
+		union iwreq_data *wrqu, char *extra)
 {
 	return -EOPNOTSUPP;
 }
 
 int iwctl_siwmlme(struct net_device *dev, struct iw_request_info *info,
-		struct iw_point *wrq, char *extra)
+		union iwreq_data *wrqu, char *extra)
 {
 	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	struct iw_mlme *mlme = (struct iw_mlme *)extra;
 	int ret = 0;
 
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWMLME\n");
+
+	if (pMgmt == NULL)
+		return -EFAULT;
+
 	if (memcmp(pMgmt->abyCurrBSSID, mlme->addr.sa_data, ETH_ALEN)) {
 		ret = -EINVAL;
 		return ret;
@@ -1626,79 +1776,66 @@ int iwctl_siwmlme(struct net_device *dev, struct iw_request_info *info,
 	return ret;
 }
 
+static int iwctl_config_commit(struct net_device *dev,
+	struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
+{
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "SIOCSIWCOMMIT\n");
+
+	return 0;
+}
+
 static const iw_handler iwctl_handler[] = {
-	(iw_handler)NULL, // SIOCSIWCOMMIT
-	(iw_handler)NULL, // SIOCGIWNAME
-	(iw_handler)NULL, // SIOCSIWNWID
-	(iw_handler)NULL, // SIOCGIWNWID
-	(iw_handler)NULL, // SIOCSIWFREQ
-	(iw_handler)NULL, // SIOCGIWFREQ
-	(iw_handler)NULL, // SIOCSIWMODE
-	(iw_handler)NULL, // SIOCGIWMODE
-	(iw_handler)NULL, // SIOCSIWSENS
-	(iw_handler)NULL, // SIOCGIWSENS
-	(iw_handler)NULL, // SIOCSIWRANGE
-	(iw_handler)iwctl_giwrange, // SIOCGIWRANGE
-	(iw_handler)NULL, // SIOCSIWPRIV
-	(iw_handler)NULL, // SIOCGIWPRIV
-	(iw_handler)NULL, // SIOCSIWSTATS
-	(iw_handler)NULL, // SIOCGIWSTATS
-	(iw_handler)NULL, // SIOCSIWSPY
-	(iw_handler)NULL, // SIOCGIWSPY
-	(iw_handler)NULL, // -- hole --
-	(iw_handler)NULL, // -- hole --
-	(iw_handler)NULL, // SIOCSIWAP
-	(iw_handler)NULL, // SIOCGIWAP
-	(iw_handler)NULL, // -- hole -- 0x16
-	(iw_handler)NULL, // SIOCGIWAPLIST
-	(iw_handler)iwctl_siwscan, // SIOCSIWSCAN
-	(iw_handler)iwctl_giwscan, // SIOCGIWSCAN
-	(iw_handler)NULL, // SIOCSIWESSID
-	(iw_handler)NULL, // SIOCGIWESSID
-	(iw_handler)NULL, // SIOCSIWNICKN
-	(iw_handler)NULL, // SIOCGIWNICKN
-	(iw_handler)NULL, // -- hole --
-	(iw_handler)NULL, // -- hole --
-	(iw_handler)NULL, // SIOCSIWRATE 0x20
-	(iw_handler)NULL, // SIOCGIWRATE
-	(iw_handler)NULL, // SIOCSIWRTS
-	(iw_handler)NULL, // SIOCGIWRTS
-	(iw_handler)NULL, // SIOCSIWFRAG
-	(iw_handler)NULL, // SIOCGIWFRAG
-	(iw_handler)NULL, // SIOCSIWTXPOW
-	(iw_handler)NULL, // SIOCGIWTXPOW
-	(iw_handler)NULL, // SIOCSIWRETRY
-	(iw_handler)NULL, // SIOCGIWRETRY
-	(iw_handler)NULL, // SIOCSIWENCODE
-	(iw_handler)NULL, // SIOCGIWENCODE
-	(iw_handler)NULL, // SIOCSIWPOWER
-	(iw_handler)NULL, // SIOCGIWPOWER
-	(iw_handler)NULL, // -- hole --
-	(iw_handler)NULL, // -- hole --
-	(iw_handler)NULL, // SIOCSIWGENIE
-	(iw_handler)NULL, // SIOCGIWGENIE
-	(iw_handler)NULL, // SIOCSIWAUTH
-	(iw_handler)NULL, // SIOCGIWAUTH
-	(iw_handler)NULL, // SIOCSIWENCODEEXT
-	(iw_handler)NULL, // SIOCGIWENCODEEXT
-	(iw_handler)NULL, // SIOCSIWPMKSA
-	(iw_handler)NULL, // -- hole --
+	IW_HANDLER(SIOCSIWCOMMIT, iwctl_config_commit),
+	IW_HANDLER(SIOCGIWNAME, iwctl_giwname),
+	IW_HANDLER(SIOCSIWFREQ, iwctl_siwfreq),
+	IW_HANDLER(SIOCGIWFREQ, iwctl_giwfreq),
+	IW_HANDLER(SIOCSIWMODE, iwctl_siwmode),
+	IW_HANDLER(SIOCGIWMODE, iwctl_giwmode),
+	IW_HANDLER(SIOCGIWSENS, iwctl_giwsens),
+	IW_HANDLER(SIOCGIWRANGE, iwctl_giwrange),
+	IW_HANDLER(SIOCSIWAP, iwctl_siwap),
+	IW_HANDLER(SIOCGIWAP, iwctl_giwap),
+	IW_HANDLER(SIOCSIWMLME, iwctl_siwmlme),
+	IW_HANDLER(SIOCGIWAPLIST, iwctl_giwaplist),
+	IW_HANDLER(SIOCSIWSCAN, iwctl_siwscan),
+	IW_HANDLER(SIOCGIWSCAN, iwctl_giwscan),
+	IW_HANDLER(SIOCSIWESSID, iwctl_siwessid),
+	IW_HANDLER(SIOCGIWESSID, iwctl_giwessid),
+	IW_HANDLER(SIOCSIWRATE, iwctl_siwrate),
+	IW_HANDLER(SIOCGIWRATE, iwctl_giwrate),
+	IW_HANDLER(SIOCSIWRTS, iwctl_siwrts),
+	IW_HANDLER(SIOCGIWRTS, iwctl_giwrts),
+	IW_HANDLER(SIOCSIWFRAG, iwctl_siwfrag),
+	IW_HANDLER(SIOCGIWFRAG, iwctl_giwfrag),
+	IW_HANDLER(SIOCSIWRETRY, iwctl_siwretry),
+	IW_HANDLER(SIOCGIWRETRY, iwctl_giwretry),
+	IW_HANDLER(SIOCSIWENCODE, iwctl_siwencode),
+	IW_HANDLER(SIOCGIWENCODE, iwctl_giwencode),
+	IW_HANDLER(SIOCSIWPOWER, iwctl_siwpower),
+	IW_HANDLER(SIOCGIWPOWER, iwctl_giwpower),
+	IW_HANDLER(SIOCSIWGENIE, iwctl_siwgenie),
+	IW_HANDLER(SIOCGIWGENIE, iwctl_giwgenie),
+	IW_HANDLER(SIOCSIWMLME, iwctl_siwmlme),
+	IW_HANDLER(SIOCSIWAUTH, iwctl_siwauth),
+	IW_HANDLER(SIOCGIWAUTH, iwctl_giwauth),
+	IW_HANDLER(SIOCSIWENCODEEXT, iwctl_siwencodeext),
+	IW_HANDLER(SIOCGIWENCODEEXT, iwctl_giwencodeext)
 };
 
 static const iw_handler iwctl_private_handler[] = {
 	NULL, // SIOCIWFIRSTPRIV
 };
 
-struct iw_priv_args iwctl_private_args[] = {
+const struct iw_priv_args iwctl_private_args[] = {
 	{ IOCTL_CMD_SET, IW_PRIV_TYPE_CHAR | 1024, 0, "set" },
 };
 
 const struct iw_handler_def iwctl_handler_def = {
 	.get_wireless_stats	= &iwctl_get_wireless_stats,
-	.num_standard		= sizeof(iwctl_handler) / sizeof(iw_handler),
+	.num_standard		= ARRAY_SIZE(iwctl_handler),
 	.num_private		= 0,
 	.num_private_args	= 0,
-	.standard		= (iw_handler *)iwctl_handler,
+	.standard		= iwctl_handler,
 	.private		= NULL,
 	.private_args		= NULL,
 };
diff --git a/drivers/staging/vt6656/iwctl.h b/drivers/staging/vt6656/iwctl.h
index 9cf48ab..b594a10 100644
--- a/drivers/staging/vt6656/iwctl.h
+++ b/drivers/staging/vt6656/iwctl.h
@@ -42,104 +42,105 @@
 struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev);
 
 int iwctl_siwap(struct net_device *dev, struct iw_request_info *info,
-		struct sockaddr *wrq, char *extra);
+		union iwreq_data *wrqu, char *extra);
 
-void iwctl_giwrange(struct net_device *dev, struct iw_request_info *info,
-		struct iw_point *wrq, char *extra);
+int iwctl_giwrange(struct net_device *dev, struct iw_request_info *info,
+		union iwreq_data *wrqu, char *extra);
 
-void iwctl_giwmode(struct net_device *dev, struct iw_request_info *info,
-		__u32 *wmode, char *extra);
+int iwctl_giwmode(struct net_device *dev, struct iw_request_info *info,
+		union iwreq_data *wrqu, char *extra);
 
 int iwctl_siwmode(struct net_device *dev, struct iw_request_info *info,
-		__u32 *wmode, char *extra);
+		union iwreq_data *wrqu, char *extra);
 
 int iwctl_giwfreq(struct net_device *dev, struct iw_request_info *info,
-		struct iw_freq *wrq, char *extra);
+		union iwreq_data *wrqu, char *extra);
 
 int iwctl_siwfreq(struct net_device *dev, struct iw_request_info *info,
-		struct iw_freq *wrq, char *extra);
+		union iwreq_data *wrqu, char *extra);
 
 int iwctl_giwname(struct net_device *dev, struct iw_request_info *info,
-		char *wrq, char *extra);
+		union iwreq_data *wrqu, char *extra);
 
 int iwctl_giwsens(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *wrq, char *extra);
+		union iwreq_data *wrqu, char *extra);
 
 int iwctl_giwap(struct net_device *dev, struct iw_request_info *info,
-		struct sockaddr *wrq, char *extra);
+		union iwreq_data *wrqu, char *extra);
 
 int iwctl_giwaplist(struct net_device *dev, struct iw_request_info *info,
-		struct iw_point *wrq, char *extra);
+		union iwreq_data *wrqu, char *extra);
 
 int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
-		struct iw_point *wrq, char *extra);
+		union iwreq_data *wrqu, char *extra);
 
-void iwctl_giwessid(struct net_device *dev, struct iw_request_info *info,
-		struct iw_point *wrq, char *extra);
+int iwctl_giwessid(struct net_device *dev, struct iw_request_info *info,
+		union iwreq_data *wrqu, char *extra);
 
 int iwctl_siwrate(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *wrq, char *extra);
+		union iwreq_data *wrqu, char *extra);
 
-void iwctl_giwrate(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *wrq, char *extra);
+int iwctl_giwrate(struct net_device *dev, struct iw_request_info *info,
+		union iwreq_data *wrqu, char *extra);
 
-int iwctl_siwrts(struct net_device *dev, struct iw_param *wrq);
+int iwctl_siwrts(struct net_device *dev, struct iw_request_info *info,
+		union iwreq_data *wrqu, char *extra);
 
 int iwctl_giwrts(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *wrq, char *extra);
+		union iwreq_data *wrqu, char *extra);
 
 int iwctl_siwfrag(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *wrq, char *extra);
+		union iwreq_data *wrqu, char *extra);
 
 int iwctl_giwfrag(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *wrq, char *extra);
+		union iwreq_data *wrqu, char *extra);
 
 int iwctl_siwretry(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *wrq, char *extra);
+		union iwreq_data *wrqu, char *extra);
 
 int iwctl_giwretry(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *wrq, char *extra);
+		union iwreq_data *wrqu, char *extra);
 
 int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
-		struct iw_point *wrq, char *extra);
+		union iwreq_data *wrqu, char *extra);
 
 int iwctl_giwencode(struct net_device *dev, struct iw_request_info *info,
-		struct iw_point *wrq, char *extra);
+		union iwreq_data *wrqu, char *extra);
 
 int iwctl_siwpower(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *wrq, char *extra);
+		union iwreq_data *wrqu, char *extra);
 
 int iwctl_giwpower(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *wrq, char *extra);
+		union iwreq_data *wrqu, char *extra);
 
 int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
-		struct iw_point *wrq, char *extra);
+		union iwreq_data *wrqu, char *extra);
 
 int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *wrq, char *extra);
+		union iwreq_data *wrqu, char *extra);
 
 int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *wrq, char *extra);
+		union iwreq_data *wrqu, char *extra);
 
 int iwctl_giwauth(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *wrq, char *extra);
+		union iwreq_data *wrqu, char *extra);
 
 int iwctl_siwgenie(struct net_device *dev, struct iw_request_info *info,
-		struct iw_point *wrq, char *extra);
+		union iwreq_data *wrqu, char *extra);
 
 int iwctl_giwgenie(struct net_device *dev, struct iw_request_info *info,
-		struct iw_point *wrq, char *extra);
+		union iwreq_data *wrqu, char *extra);
 
 int iwctl_siwencodeext(struct net_device *dev, struct iw_request_info *info,
-		struct iw_point *wrq, char *extra);
+		union iwreq_data *wrqu, char *extra);
 
 int iwctl_giwencodeext(struct net_device *dev, struct iw_request_info *info,
-		struct iw_point *wrq, char *extra);
+		union iwreq_data *wrqu, char *extra);
 
 int iwctl_siwmlme(struct net_device *dev, struct iw_request_info *info,
-		struct iw_point *wrq, char *extra);
+		union iwreq_data *wrqu, char *extra);
 
 extern const struct iw_handler_def iwctl_handler_def;
-extern const struct iw_priv_args iwctl_private_args;
+extern const struct iw_priv_args iwctl_priv_args;
 
 #endif /* __IWCTL_H__ */
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 9a81839..0c1f379 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1558,7 +1558,6 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 	PSDevice pDevice = (PSDevice)netdev_priv(dev);
 	PSMgmtObject pMgmt = &pDevice->sMgmtObj;
 	PSCmdRequest pReq;
-	u8 *buffer;
 	struct iwreq *wrq = (struct iwreq *) rq;
 	int rc = 0;
 
@@ -1569,343 +1568,6 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 
     switch(cmd) {
 
-	case SIOCGIWNAME:
-		rc = iwctl_giwname(dev, NULL, (char *)&(wrq->u.name), NULL);
-		break;
-
-	case SIOCSIWNWID:
-	case SIOCGIWNWID:     //0x8b03  support
-		rc = -EOPNOTSUPP;
-		break;
-
-		// Set frequency/channel
-	case SIOCSIWFREQ:
-	    rc = iwctl_siwfreq(dev, NULL, &(wrq->u.freq), NULL);
-		break;
-
-		// Get frequency/channel
-	case SIOCGIWFREQ:
-		rc = iwctl_giwfreq(dev, NULL, &(wrq->u.freq), NULL);
-		break;
-
-		// Set desired network name (ESSID)
-	case SIOCSIWESSID:
-
-		{
-			char essid[IW_ESSID_MAX_SIZE+1];
-			if (wrq->u.essid.length > IW_ESSID_MAX_SIZE) {
-				rc = -E2BIG;
-				break;
-			}
-			if (copy_from_user(essid, wrq->u.essid.pointer,
-					   wrq->u.essid.length)) {
-				rc = -EFAULT;
-				break;
-			}
-			rc = iwctl_siwessid(dev, NULL,
-					    &(wrq->u.essid), essid);
-		}
-		break;
-
-
-		// Get current network name (ESSID)
-	case SIOCGIWESSID:
-
-		{
-			char essid[IW_ESSID_MAX_SIZE+1];
-			if (wrq->u.essid.pointer) {
-				iwctl_giwessid(dev, NULL,
-					    &(wrq->u.essid), essid);
-				if (copy_to_user(wrq->u.essid.pointer,
-						         essid,
-						         wrq->u.essid.length) )
-					rc = -EFAULT;
-			}
-		}
-		break;
-
-	case SIOCSIWAP:
-
-		rc = iwctl_siwap(dev, NULL, &(wrq->u.ap_addr), NULL);
-		break;
-
-
-		// Get current Access Point (BSSID)
-	case SIOCGIWAP:
-		rc = iwctl_giwap(dev, NULL, &(wrq->u.ap_addr), NULL);
-		break;
-
-
-		// Set desired station name
-	case SIOCSIWNICKN:
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWNICKN \n");
-        rc = -EOPNOTSUPP;
-		break;
-
-		// Get current station name
-	case SIOCGIWNICKN:
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWNICKN \n");
-        rc = -EOPNOTSUPP;
-		break;
-
-		// Set the desired bit-rate
-	case SIOCSIWRATE:
-		rc = iwctl_siwrate(dev, NULL, &(wrq->u.bitrate), NULL);
-		break;
-
-	// Get the current bit-rate
-	case SIOCGIWRATE:
-		iwctl_giwrate(dev, NULL, &(wrq->u.bitrate), NULL);
-		break;
-
-	// Set the desired RTS threshold
-	case SIOCSIWRTS:
-
-		rc = iwctl_siwrts(dev, &(wrq->u.rts));
-		break;
-
-	// Get the current RTS threshold
-	case SIOCGIWRTS:
-
-		rc = iwctl_giwrts(dev, NULL, &(wrq->u.rts), NULL);
-		break;
-
-		// Set the desired fragmentation threshold
-	case SIOCSIWFRAG:
-
-		rc = iwctl_siwfrag(dev, NULL, &(wrq->u.frag), NULL);
-	    break;
-
-	// Get the current fragmentation threshold
-	case SIOCGIWFRAG:
-
-		rc = iwctl_giwfrag(dev, NULL, &(wrq->u.frag), NULL);
-		break;
-
-		// Set mode of operation
-	case SIOCSIWMODE:
-    	rc = iwctl_siwmode(dev, NULL, &(wrq->u.mode), NULL);
-		break;
-
-		// Get mode of operation
-	case SIOCGIWMODE:
-		iwctl_giwmode(dev, NULL, &(wrq->u.mode), NULL);
-		break;
-
-		// Set WEP keys and mode
-	case SIOCSIWENCODE:
-		{
-            char abyKey[WLAN_WEP232_KEYLEN];
-
-			if (wrq->u.encoding.pointer) {
-
-
-				if (wrq->u.encoding.length > WLAN_WEP232_KEYLEN) {
-					rc = -E2BIG;
-					break;
-				}
-				memset(abyKey, 0, WLAN_WEP232_KEYLEN);
-				if (copy_from_user(abyKey,
-				                  wrq->u.encoding.pointer,
-				                  wrq->u.encoding.length)) {
-					rc = -EFAULT;
-					break;
-				}
-			} else if (wrq->u.encoding.length != 0) {
-				rc = -EINVAL;
-				break;
-			}
-			rc = iwctl_siwencode(dev, NULL, &(wrq->u.encoding), abyKey);
-		}
-		break;
-
-		// Get the WEP keys and mode
-	case SIOCGIWENCODE:
-
-		if (!capable(CAP_NET_ADMIN)) {
-			rc = -EPERM;
-			break;
-		}
-		{
-		    char abyKey[WLAN_WEP232_KEYLEN];
-
-		    rc = iwctl_giwencode(dev, NULL, &(wrq->u.encoding), abyKey);
-		    if (rc != 0) break;
-			if (wrq->u.encoding.pointer) {
-				if (copy_to_user(wrq->u.encoding.pointer,
-						        abyKey,
-						        wrq->u.encoding.length))
-					rc = -EFAULT;
-			}
-		}
-		break;
-
-		// Get the current Tx-Power
-	case SIOCGIWTXPOW:
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWTXPOW \n");
-        rc = -EOPNOTSUPP;
-		break;
-
-	case SIOCSIWTXPOW:
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWTXPOW \n");
-        rc = -EOPNOTSUPP;
-		break;
-
-	case SIOCSIWRETRY:
-
-		rc = iwctl_siwretry(dev, NULL, &(wrq->u.retry), NULL);
-		break;
-
-	case SIOCGIWRETRY:
-
-		rc = iwctl_giwretry(dev, NULL, &(wrq->u.retry), NULL);
-		break;
-
-		// Get range of parameters
-	case SIOCGIWRANGE:
-
-		{
-			struct iw_range range;
-
-			iwctl_giwrange(dev, NULL, &(wrq->u.data), (char *) &range);
-			if (copy_to_user(wrq->u.data.pointer, &range, sizeof(struct iw_range)))
-				rc = -EFAULT;
-		}
-
-		break;
-
-	case SIOCGIWPOWER:
-
-		rc = iwctl_giwpower(dev, NULL, &(wrq->u.power), NULL);
-		break;
-
-
-	case SIOCSIWPOWER:
-
-		rc = iwctl_siwpower(dev, NULL, &(wrq->u.power), NULL);
-		break;
-
-
-	case SIOCGIWSENS:
-
-	    rc = iwctl_giwsens(dev, NULL, &(wrq->u.sens), NULL);
-		break;
-
-	case SIOCSIWSENS:
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWSENS \n");
-		rc = -EOPNOTSUPP;
-		break;
-
-	case SIOCGIWAPLIST:
-		if (wrq->u.data.pointer) {
-			buffer = kzalloc((sizeof(struct sockaddr) +
-				sizeof(struct iw_quality)) * IW_MAX_AP,
-					GFP_KERNEL);
-			if (buffer == NULL) {
-				rc = -ENOMEM;
-				break;
-			}
-
-			rc = iwctl_giwaplist(dev, NULL, &(wrq->u.data), buffer);
-			if (rc < 0) {
-				kfree(buffer);
-				break;
-			}
-
-			if (copy_to_user(wrq->u.data.pointer, buffer,
-				wrq->u.data.length * (sizeof(struct sockaddr)
-					+ sizeof(struct iw_quality))))
-				rc = -EFAULT;
-
-			kfree(buffer);
-		}
-		break;
-
-
-#ifdef WIRELESS_SPY
-		// Set the spy list
-	case SIOCSIWSPY:
-
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWSPY \n");
-		rc = -EOPNOTSUPP;
-		break;
-
-		// Get the spy list
-	case SIOCGIWSPY:
-
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWSPY \n");
-		rc = -EOPNOTSUPP;
-		break;
-
-#endif // WIRELESS_SPY
-
-	case SIOCGIWPRIV:
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWPRIV \n");
-		rc = -EOPNOTSUPP;
-/*
-		if(wrq->u.data.pointer) {
-			wrq->u.data.length = sizeof(iwctl_private_args) / sizeof( iwctl_private_args[0]);
-
-			if(copy_to_user(wrq->u.data.pointer,
-					(u_char *) iwctl_private_args,
-					sizeof(iwctl_private_args)))
-				rc = -EFAULT;
-		}
-*/
-		break;
-
-	case SIOCSIWAUTH:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWAUTH\n");
-		rc = iwctl_siwauth(dev, NULL, &(wrq->u.param), NULL);
-		break;
-
-	case SIOCGIWAUTH:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWAUTH \n");
-		rc = iwctl_giwauth(dev, NULL, &(wrq->u.param), NULL);
-		break;
-
-	case SIOCSIWGENIE:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWGENIE \n");
-		rc = iwctl_siwgenie(dev, NULL, &(wrq->u.data), wrq->u.data.pointer);
-		break;
-
-	case SIOCGIWGENIE:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWGENIE \n");
-		rc = iwctl_giwgenie(dev, NULL, &(wrq->u.data), wrq->u.data.pointer);
-		break;
-
-	case SIOCSIWENCODEEXT:
-		{
-			char extra[sizeof(struct iw_encode_ext)+MAX_KEY_LEN+1];
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWENCODEEXT \n");
-			if(wrq->u.encoding.pointer){
-				memset(extra, 0, sizeof(struct iw_encode_ext)+MAX_KEY_LEN+1);
-				if(wrq->u.encoding.length > (sizeof(struct iw_encode_ext)+ MAX_KEY_LEN)){
-					rc = -E2BIG;
-					break;
-				}
-				if(copy_from_user(extra, wrq->u.encoding.pointer,wrq->u.encoding.length)){
-					rc = -EFAULT;
-					break;
-				}
-			}else if(wrq->u.encoding.length != 0){
-				rc = -EINVAL;
-				break;
-			}
-			rc = iwctl_siwencodeext(dev, NULL, &(wrq->u.encoding), extra);
-		}
-		break;
-
-	case SIOCGIWENCODEEXT:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWENCODEEXT \n");
-		rc = iwctl_giwencodeext(dev, NULL, &(wrq->u.encoding), NULL);
-		break;
-
-	case SIOCSIWMLME:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWMLME \n");
-		rc = iwctl_siwmlme(dev, NULL, &(wrq->u.data), wrq->u.data.pointer);
-		break;
-
 
     case IOCTL_CMD_TEST:
 
@@ -1968,50 +1630,9 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 
 	case SIOCETHTOOL:
         return ethtool_ioctl(dev, (void *) rq->ifr_data);
-	// All other calls are currently unsupported
-
-	default:
-		rc = -EOPNOTSUPP;
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Ioctl command not supported..%x\n", cmd);
-
 
     }
 
-    if (pDevice->bCommit) {
-       if (pMgmt->eConfigMode == WMAC_CONFIG_AP) {
-           netif_stop_queue(pDevice->dev);
-           spin_lock_irq(&pDevice->lock);
-	bScheduleCommand((void *) pDevice, WLAN_CMD_RUN_AP, NULL);
-           spin_unlock_irq(&pDevice->lock);
-       }
-       else {
-           DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Commit the settings\n");
-           spin_lock_irq(&pDevice->lock);
-//2007-1121-01<Modify>by EinsnLiu
-	    if (pDevice->bLinkPass &&
-		  memcmp(pMgmt->abyCurrSSID,pMgmt->abyDesireSSID,WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN)) {
-		bScheduleCommand((void *) pDevice, WLAN_CMD_DISASSOCIATE, NULL);
-	     } else {
-           pDevice->bLinkPass = FALSE;
-	   pMgmt->eCurrState = WMAC_STATE_IDLE;
-	   memset(pMgmt->abyCurrBSSID, 0, 6);
-		 }
-           ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_SLOW);
-//End Modify
-           netif_stop_queue(pDevice->dev);
-           pMgmt->eScanType = WMAC_SCAN_ACTIVE;
-	   if (!pDevice->bWPASuppWextEnabled)
-		bScheduleCommand((void *) pDevice,
-				 WLAN_CMD_BSSID_SCAN,
-				 pMgmt->abyDesireSSID);
-		bScheduleCommand((void *) pDevice,
-				 WLAN_CMD_SSID,
-				 NULL);
-           spin_unlock_irq(&pDevice->lock);
-      }
-      pDevice->bCommit = FALSE;
-    }
-
 
     return rc;
 }
-- 
1.7.10.4



