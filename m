Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36171 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933013AbbJANoq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 09:44:46 -0400
Received: by pablk4 with SMTP id lk4so74736090pab.3
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2015 06:44:45 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 12/12] staging: wilc1000: rename u8CurrChannel
Date: Thu,  1 Oct 2015 22:43:59 +0900
Message-Id: <1443707039-18433-12-git-send-email-chaehyun.lim@gmail.com> (sfid-20151001_154654_373334_3E3310F0)
In-Reply-To: <1443707039-18433-1-git-send-email-chaehyun.lim@gmail.com>
References: <1443707039-18433-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces u8CurrChannel with curr_channel to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 6db1325..6928c01 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -97,7 +97,7 @@ struct p2p_mgmt_data {
 /*Global variable used to state the current  connected STA channel*/
 u8 u8WLANChannel = INVALID_CHANNEL;
 
-u8 u8CurrChannel;
+u8 curr_channel;
 
 u8 u8P2P_oui[] = {0x50, 0x6f, 0x9A, 0x09};
 u8 u8P2Plocalrandom = 0x01;
@@ -670,7 +670,7 @@ static int set_channel(struct wiphy *wiphy,
 	channelnum = ieee80211_frequency_to_channel(chandef->chan->center_freq);
 	PRINT_D(CFG80211_DBG, "Setting channel %d with frequency %d\n", channelnum, chandef->chan->center_freq);
 
-	u8CurrChannel = channelnum;
+	curr_channel = channelnum;
 	result = host_int_set_mac_chnl_num(priv->hWILCWFIDrv, channelnum);
 
 	if (result != 0)
@@ -996,7 +996,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	PRINT_INFO(CFG80211_DBG, "Group encryption value = %s\n Cipher Group = %s\n WPA version = %s\n",
 		   pcgroup_encrypt_val, pccipher_group, pcwpa_version);
 
-	u8CurrChannel = pstrNetworkInfo->u8channel;
+	curr_channel = pstrNetworkInfo->u8channel;
 
 	if (!pstrWFIDrv->u8P2PConnect) {
 		u8WLANChannel = pstrNetworkInfo->u8channel;
@@ -2093,7 +2093,7 @@ void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, u32 size)
 		PRINT_D(GENERIC_DBG, "Rx Frame Type:%x\n", buff[FRAME_TYPE_ID]);
 
 		/*Upper layer is informed that the frame is received on this freq*/
-		s32Freq = ieee80211_channel_to_frequency(u8CurrChannel, IEEE80211_BAND_2GHZ);
+		s32Freq = ieee80211_channel_to_frequency(curr_channel, IEEE80211_BAND_2GHZ);
 
 		if (ieee80211_is_action(buff[FRAME_TYPE_ID])) {
 			PRINT_D(GENERIC_DBG, "Rx Action Frame Type: %x %x\n", buff[ACTION_SUBTYPE_ID], buff[P2P_PUB_ACTION_SUBTYPE]);
@@ -2273,7 +2273,7 @@ static int remain_on_channel(struct wiphy *wiphy,
 		return s32Error;
 	}
 
-	u8CurrChannel = chan->hw_value;
+	curr_channel = chan->hw_value;
 
 	/*Setting params needed by WILC_WFI_RemainOnChannelExpired()*/
 	priv->strRemainOnChanParams.pstrListenChan = chan;
@@ -2394,7 +2394,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 			PRINT_D(GENERIC_DBG, "Setting channel: %d\n", chan->hw_value);
 			host_int_set_mac_chnl_num(priv->hWILCWFIDrv, chan->hw_value);
 			/*Save the current channel after we tune to it*/
-			u8CurrChannel = chan->hw_value;
+			curr_channel = chan->hw_value;
 		} else if (ieee80211_is_action(mgmt->frame_control))   {
 			PRINT_D(GENERIC_DBG, "ACTION FRAME:%x\n", (u16)mgmt->frame_control);
 
@@ -2409,7 +2409,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 					PRINT_D(GENERIC_DBG, "Setting channel: %d\n", chan->hw_value);
 					host_int_set_mac_chnl_num(priv->hWILCWFIDrv, chan->hw_value);
 					/*Save the current channel after we tune to it*/
-					u8CurrChannel = chan->hw_value;
+					curr_channel = chan->hw_value;
 				}
 				switch (buf[ACTION_SUBTYPE_ID])	{
 				case GAS_INTIAL_REQ:
-- 
2.6.0

