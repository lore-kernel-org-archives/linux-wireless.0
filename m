Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36765 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbbIOFHg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 01:07:36 -0400
Received: by padhk3 with SMTP id hk3so164831364pad.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2015 22:07:36 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 15/18] staging: wilc1000: remove if defined codes of USE_SUPPLICANT_GO_INTENT
Date: Tue, 15 Sep 2015 14:06:25 +0900
Message-Id: <1442293588-15323-15-git-send-email-chaehyun.lim@gmail.com> (sfid-20150915_070746_196020_FCD9C4DD)
In-Reply-To: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes if defined codes of USE_SUPPLICANT_GO_INTENT.
This macro is deleted because it is commented out.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 66 -----------------------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h |  9 ----
 2 files changed, 75 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 2671cdf..c3e0892 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2023,51 +2023,18 @@ void WILC_WFI_CfgParseRxAction(u8 *buf, u32 len)
 	u32 i = 0, j = 0;
 
 	/*BugID_5460*/
-	#ifdef USE_SUPPLICANT_GO_INTENT
-	u8 intent;
-	u8 tie_breaker;
-	bool is_wilc_go = true;
-	#endif
 	u8 op_channel_attr_index = 0;
 	u8 channel_list_attr_index = 0;
 
 	while (index < len) {
 		if (buf[index] == GO_INTENT_ATTR_ID) {
-			#ifdef USE_SUPPLICANT_GO_INTENT
-			/*BugID_5460*/
-			/*Case 1: If we are going to be p2p client, no need to modify channels attributes*/
-			/*In negotiation frames, go intent attr value determines who will be GO*/
-			intent = GET_GO_INTENT(buf[index + 3]);
-			tie_breaker = GET_TIE_BREAKER(buf[index + 3]);
-			if (intent > SUPPLICANT_GO_INTENT
-			    || (intent == SUPPLICANT_GO_INTENT && tie_breaker == 1)) {
-				PRINT_D(GENERIC_DBG, "WILC will be client (intent %d tie breaker %d)\n", intent, tie_breaker);
-				is_wilc_go = false;
-			} else {
-				PRINT_D(GENERIC_DBG, "WILC will be GO (intent %d tie breaker %d)\n", intent, tie_breaker);
-				is_wilc_go = true;
-			}
-
-			#else   /* USE_SUPPLICANT_GO_INTENT */
 			#ifdef FORCE_P2P_CLIENT
 			buf[index + 3] = (buf[index + 3]  & 0x01) | (0x0f << 1);
 			#else
 			buf[index + 3] = (buf[index + 3]  & 0x01) | (0x00 << 1);
 			#endif
-			#endif  /* USE_SUPPLICANT_GO_INTENT */
 		}
 
-		#ifdef USE_SUPPLICANT_GO_INTENT
-		/*Case 2: If group bssid attribute is present, no need to modify channels attributes*/
-		/*In invitation req and rsp, group bssid attr presence determines who will be GO*/
-		if (buf[index] == GROUP_BSSID_ATTR_ID) {
-			PRINT_D(GENERIC_DBG, "Group BSSID: %2x:%2x:%2x\n", buf[index + 3]
-				, buf[index + 4]
-				, buf[index + 5]);
-			is_wilc_go = false;
-		}
-		#endif  /* USE_SUPPLICANT_GO_INTENT */
-
 		if (buf[index] ==  CHANLIST_ATTR_ID)
 			channel_list_attr_index = index;
 		else if (buf[index] ==  OPERCHAN_ATTR_ID)
@@ -2075,11 +2042,7 @@ void WILC_WFI_CfgParseRxAction(u8 *buf, u32 len)
 		index += buf[index + 1] + 3; /* ID,Length byte */
 	}
 
-	#ifdef USE_SUPPLICANT_GO_INTENT
-	if (u8WLANChannel != INVALID_CHANNEL && is_wilc_go)
-	#else
 	if (u8WLANChannel != INVALID_CHANNEL)
-	#endif
 	{
 		/*Modify channel list attribute*/
 		if (channel_list_attr_index) {
@@ -2119,29 +2082,8 @@ void WILC_WFI_CfgParseTxAction(u8 *buf, u32 len, bool bOperChan, u8 iftype)
 
 	u8 op_channel_attr_index = 0;
 	u8 channel_list_attr_index = 0;
-	#ifdef USE_SUPPLICANT_GO_INTENT
-	bool is_wilc_go = false;
-
-	/*BugID_5460*/
-	/*Case 1: If we are already p2p client, no need to modify channels attributes*/
-	/*This to handle the case of inviting a p2p peer to join an existing group which we are a member in*/
-	if (iftype == CLIENT_MODE)
-		return;
-	#endif
 
 	while (index < len) {
-		#ifdef USE_SUPPLICANT_GO_INTENT
-		/*Case 2: If group bssid attribute is present, no need to modify channels attributes*/
-		/*In invitation req and rsp, group bssid attr presence determines who will be GO*/
-		/*Note: If we are already p2p client, group bssid attr may also be present (handled in Case 1)*/
-		if (buf[index] == GROUP_BSSID_ATTR_ID) {
-			PRINT_D(GENERIC_DBG, "Group BSSID: %2x:%2x:%2x\n", buf[index + 3]
-				, buf[index + 4]
-				, buf[index + 5]);
-			is_wilc_go = true;
-		}
-
-		#else   /* USE_SUPPLICANT_GO_INTENT */
 		if (buf[index] == GO_INTENT_ATTR_ID) {
 			#ifdef FORCE_P2P_CLIENT
 			buf[index + 3] = (buf[index + 3]  & 0x01) | (0x00 << 1);
@@ -2151,7 +2093,6 @@ void WILC_WFI_CfgParseTxAction(u8 *buf, u32 len, bool bOperChan, u8 iftype)
 
 			break;
 		}
-		#endif
 
 		if (buf[index] ==  CHANLIST_ATTR_ID)
 			channel_list_attr_index = index;
@@ -2160,12 +2101,7 @@ void WILC_WFI_CfgParseTxAction(u8 *buf, u32 len, bool bOperChan, u8 iftype)
 		index += buf[index + 1] + 3; /* ID,Length byte */
 	}
 
-	#ifdef USE_SUPPLICANT_GO_INTENT
-	/*No need to check bOperChan since only transmitted invitation frames are parsed*/
-	if (u8WLANChannel != INVALID_CHANNEL && is_wilc_go)
-	#else
 	if (u8WLANChannel != INVALID_CHANNEL && bOperChan)
-	#endif
 	{
 		/*Modify channel list attribute*/
 		if (channel_list_attr_index) {
@@ -2605,10 +2541,8 @@ int mgmt_tx(struct wiphy *wiphy,
 										/*BugID_5460*/
 										/*If using supplicant go intent, no need at all*/
 										/*to parse transmitted negotiation frames*/
-											#ifndef USE_SUPPLICANT_GO_INTENT
 										else
 											WILC_WFI_CfgParseTxAction(&mgmt_tx->buff[i + 6], len - (i + 6), false, nic->iftype);
-											#endif
 										break;
 									}
 								}
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index aac9e3f..15510f2 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -33,9 +33,6 @@
 #define		GO_INTENT_ATTR_ID			0x04
 #define		CHANLIST_ATTR_ID		0x0b
 #define		OPERCHAN_ATTR_ID                0x11
-#ifdef	USE_SUPPLICANT_GO_INTENT
-#define	GROUP_BSSID_ATTR_ID			0x07
-#endif
 #define		PUB_ACTION_ATTR_ID			0x04
 #define		P2PELEM_ATTR_ID                     0xdd
 
@@ -50,14 +47,8 @@
 #define		GAS_INTIAL_RSP					0x0b
 
 #define		INVALID_CHANNEL					0
-#ifdef	USE_SUPPLICANT_GO_INTENT
-#define		SUPPLICANT_GO_INTENT			6
-#define		GET_GO_INTENT(a)				(((a) >> 1) & 0x0f)
-#define		GET_TIE_BREAKER(a)			(((a)) & 0x01)
-#else
 /* #define FORCE_P2P_CLIENT */
 #endif
-#endif
 
 #define nl80211_SCAN_RESULT_EXPIRE	(3 * HZ)
 #define SCAN_RESULT_EXPIRE				(40 * HZ)
-- 
2.5.1

