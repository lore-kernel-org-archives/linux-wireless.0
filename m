Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33156 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932178AbbJPPcf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 11:32:35 -0400
From: Luis de Bethencourt <luisbg@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org,
	Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [PATCH] staging: wilc1000: Remove boolean comparisons
Date: Fri, 16 Oct 2015 16:32:26 +0100
Message-Id: <1445009546-25856-1-git-send-email-luisbg@osg.samsung.com> (sfid-20151016_173310_352235_8A69C7D8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Boolean tests do not need explicit comparison to true or false.

Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 706912b..16a2a5f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -363,7 +363,7 @@ static void CfgScanResult(enum scan_event enuScanEvent, tstrNetworkInfo *pstrNet
 	struct cfg80211_bss *bss = NULL;
 
 	priv = (struct wilc_priv *)pUserVoid;
-	if (priv->bCfgScanning == true) {
+	if (priv->bCfgScanning) {
 		if (enuScanEvent == SCAN_EVENT_NETWORK_FOUND) {
 			wiphy = priv->dev->ieee80211_ptr->wiphy;
 
@@ -391,7 +391,7 @@ static void CfgScanResult(enum scan_event enuScanEvent, tstrNetworkInfo *pstrNet
 					   "BeaconPeriod: %d\n", channel->center_freq, (((s32)pstrNetworkInfo->s8rssi) * 100),
 					   pstrNetworkInfo->u16CapInfo, pstrNetworkInfo->u16BeaconPeriod);
 
-				if (pstrNetworkInfo->bNewNetwork == true) {
+				if (pstrNetworkInfo->bNewNetwork) {
 					if (priv->u32RcvdChCount < MAX_NUM_SCANNED_NETWORKS) { /* TODO: mostafa: to be replaced by */
 						/*               max_scan_ssids */
 						PRINT_D(CFG80211_DBG, "Network %s found\n", pstrNetworkInfo->au8ssid);
@@ -1947,7 +1947,7 @@ void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, u32 size)
 		if (ieee80211_is_action(buff[FRAME_TYPE_ID])) {
 			PRINT_D(GENERIC_DBG, "Rx Action Frame Type: %x %x\n", buff[ACTION_SUBTYPE_ID], buff[P2P_PUB_ACTION_SUBTYPE]);
 
-			if (priv->bCfgScanning == true && time_after_eq(jiffies, (unsigned long)pstrWFIDrv->u64P2p_MgmtTimeout)) {
+			if (priv->bCfgScanning && time_after_eq(jiffies, (unsigned long)pstrWFIDrv->u64P2p_MgmtTimeout)) {
 				PRINT_D(GENERIC_DBG, "Receiving action frames from wrong channels\n");
 				return;
 			}
@@ -2360,7 +2360,7 @@ static int mgmt_tx_cancel_wait(struct wiphy *wiphy,
 	PRINT_D(GENERIC_DBG, "Tx Cancel wait :%lu\n", jiffies);
 	pstrWFIDrv->u64P2p_MgmtTimeout = jiffies;
 
-	if (priv->bInP2PlistenState == false) {
+	if (!priv->bInP2PlistenState) {
 		cfg80211_remain_on_channel_expired(priv->wdev,
 						   priv->strRemainOnChanParams.u64ListenCookie,
 						   priv->strRemainOnChanParams.pstrListenChan,
-- 
2.5.1

