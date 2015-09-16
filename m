Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:26830 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbbIPJgN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 05:36:13 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 1/6] staging: wilc1000: remove a macro WILC_NULLCHECK
Date: Wed, 16 Sep 2015 18:35:59 +0900
Message-ID: <1442396164-18728-2-git-send-email-tony.cho@atmel.com> (sfid-20150916_113620_000924_31B476AC)
In-Reply-To: <1442396164-18728-1-git-send-email-tony.cho@atmel.com>
References: <1442396164-18728-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch replaces WILC_NULLCHECK with the plain statements and then removes
the macro WILC_NULLCHECK in wilc_errorsupport.h which is not used anymore.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         |  7 +++++--
 drivers/staging/wilc1000/wilc_errorsupport.h      |  6 ------
 drivers/staging/wilc1000/wilc_msgqueue.c          |  9 +++++++--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 24 ++++++++++++++---------
 4 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 563063c..827758d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -7289,7 +7289,8 @@ s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSta
 	if (pstrAddStationMsg->u8NumRates > 0) {
 		u8 *rates = kmalloc(pstrAddStationMsg->u8NumRates, GFP_KERNEL);
 
-		WILC_NULLCHECK(s32Error, rates);
+		if (!rates)
+			return -ENOMEM;
 
 		memcpy(rates, pstrStaParams->pu8Rates, pstrAddStationMsg->u8NumRates);
 		pstrAddStationMsg->pu8Rates = rates;
@@ -7444,7 +7445,9 @@ s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSt
 	if (pstrAddStationMsg->u8NumRates > 0) {
 		u8 *rates = kmalloc(pstrAddStationMsg->u8NumRates, GFP_KERNEL);
 
-		WILC_NULLCHECK(s32Error, rates);
+		if (!rates)
+			return -ENOMEM;
+
 		memcpy(rates, pstrStaParams->pu8Rates, pstrAddStationMsg->u8NumRates);
 		pstrAddStationMsg->pu8Rates = rates;
 	}
diff --git a/drivers/staging/wilc1000/wilc_errorsupport.h b/drivers/staging/wilc1000/wilc_errorsupport.h
index 8eb8150..42495d9 100644
--- a/drivers/staging/wilc1000/wilc_errorsupport.h
+++ b/drivers/staging/wilc1000/wilc_errorsupport.h
@@ -51,12 +51,6 @@
 		goto ERRORHANDLER; \
 } while (0)
 
-#define  WILC_NULLCHECK(__status__, __ptr__)	do { \
-		if (__ptr__ == NULL) { \
-			WILC_ERRORREPORT(__status__, WILC_NULL_PTR); \
-		} \
-} while (0)
-
 #define WILC_CATCH(__status__) \
 ERRORHANDLER: \
 	if (__status__ < WILC_SUCCESS) \
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 41244ce..ac23736 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -1,6 +1,7 @@
 
 #include "wilc_msgqueue.h"
 #include <linux/spinlock.h>
+#include <linux/errno.h>
 
 /*!
  *  @author		syounan
@@ -69,11 +70,15 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 
 	/* construct a new message */
 	pstrMessage = kmalloc(sizeof(Message), GFP_ATOMIC);
-	WILC_NULLCHECK(s32RetStatus, pstrMessage);
+	if (!pstrMessage)
+		return -ENOMEM;
 	pstrMessage->u32Length = u32SendBufferSize;
 	pstrMessage->pstrNext = NULL;
 	pstrMessage->pvBuffer = kmalloc(u32SendBufferSize, GFP_ATOMIC);
-	WILC_NULLCHECK(s32RetStatus, pstrMessage->pvBuffer);
+	if (!pstrMessage->pvBuffer) {
+		s32RetStatus = -ENOMEM;
+		goto ERRORHANDLER;
+	}
 	memcpy(pstrMessage->pvBuffer, pvSendBuffer, u32SendBufferSize);
 
 	/* add it to the message queue */
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 4151aae..32fd543 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -15,7 +15,7 @@
 #ifdef WILC_SDIO
 #include "linux_wlan_sdio.h"    /* tony : for set_wiphy_dev() */
 #endif
-
+#include <linux/errno.h>
 
 #define IS_MANAGMEMENT				0x100
 #define IS_MANAGMEMENT_CALLBACK			0x080
@@ -381,7 +381,10 @@ static void CfgScanResult(tenuScanEvent enuScanEvent, tstrNetworkInfo *pstrNetwo
 	if (priv->bCfgScanning == true) {
 		if (enuScanEvent == SCAN_EVENT_NETWORK_FOUND) {
 			wiphy = priv->dev->ieee80211_ptr->wiphy;
-			WILC_NULLCHECK(s32Error, wiphy);
+
+			if (!wiphy)
+				return;
+
 			if (wiphy->signal_type == CFG80211_SIGNAL_TYPE_UNSPEC
 			    &&
 			    ((((s32)pstrNetworkInfo->s8rssi) * 100) < 0
@@ -395,7 +398,8 @@ static void CfgScanResult(tenuScanEvent enuScanEvent, tstrNetworkInfo *pstrNetwo
 				s32Freq = ieee80211_channel_to_frequency((s32)pstrNetworkInfo->u8channel, IEEE80211_BAND_2GHZ);
 				channel = ieee80211_get_channel(wiphy, s32Freq);
 
-				WILC_NULLCHECK(s32Error, channel);
+				if (!channel)
+					return;
 
 				PRINT_INFO(CFG80211_DBG, "Network Info:: CHANNEL Frequency: %d, RSSI: %d, CapabilityInfo: %d,"
 					   "BeaconPeriod: %d\n", channel->center_freq, (((s32)pstrNetworkInfo->s8rssi) * 100),
@@ -3217,8 +3221,8 @@ static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	struct wilc_priv *priv;
 	u8 NullBssid[ETH_ALEN] = {0};
 
-
-	WILC_NULLCHECK(s32Error, wiphy);
+	if (!wiphy)
+		return -EFAULT;
 
 	priv = wiphy_priv(wiphy);
 
@@ -3254,8 +3258,8 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 	tstrWILC_AddStaParam strStaParams = { {0} };
 	perInterface_wlan_t *nic;
 
-
-	WILC_NULLCHECK(s32Error, wiphy);
+	if (!wiphy)
+		return -EFAULT;
 
 	priv = wiphy_priv(wiphy);
 	nic = netdev_priv(dev);
@@ -3325,7 +3329,8 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
 	struct wilc_priv *priv;
 	perInterface_wlan_t *nic;
 
-	WILC_NULLCHECK(s32Error, wiphy);
+	if (!wiphy)
+		return -EFAULT;
 
 	priv = wiphy_priv(wiphy);
 	nic = netdev_priv(dev);
@@ -3371,7 +3376,8 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 
 	PRINT_D(HOSTAPD_DBG, "Change station paramters\n");
 
-	WILC_NULLCHECK(s32Error, wiphy);
+	if (!wiphy)
+		return -EFAULT;
 
 	priv = wiphy_priv(wiphy);
 	nic = netdev_priv(dev);
-- 
1.9.1

