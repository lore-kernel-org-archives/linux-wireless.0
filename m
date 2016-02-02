Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:9493 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542AbcBBMG6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 07:06:58 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 13/26] staging: wilc1000: renames u8channel of connect_resp_info structure
Date: Tue, 2 Feb 2016 21:02:23 +0900
Message-ID: <1454414556-9822-13-git-send-email-leo.kim@atmel.com> (sfid-20160202_130700_669695_DB3D9034)
In-Reply-To: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
References: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u8channel variable to ch.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       |  2 +-
 drivers/staging/wilc1000/coreconfigurator.h       |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 14 +++++++-------
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index ce3bc29..6c748aa 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -325,7 +325,7 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
 		get_ssid(msa, network_info->ssid, &network_info->ssid_len);
 		get_BSSID(msa, network_info->bssid);
 
-		network_info->u8channel = get_current_channel_802_11n(msa,
+		network_info->ch = get_current_channel_802_11n(msa,
 							rx_len + FCS_LEN);
 
 		index = MAC_HDR_LEN + TIME_STAMP_LEN;
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index bbc4b0e..2f030a9 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -84,7 +84,7 @@ struct network_info {
 	u8 bssid[6];
 	u16 beacon_period;
 	u8 dtim_period;
-	u8 u8channel;
+	u8 ch;
 	unsigned long u32TimeRcvdInScanCached;
 	unsigned long u32TimeRcvdInScan;
 	bool bNewNetwork;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index cfd6892..1773587 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -240,7 +240,7 @@ static void refresh_scan(void *user_void, u8 all, bool direct_scan)
 			struct ieee80211_channel *channel;
 
 			if (network_info) {
-				freq = ieee80211_channel_to_frequency((s32)network_info->u8channel, IEEE80211_BAND_2GHZ);
+				freq = ieee80211_channel_to_frequency((s32)network_info->ch, IEEE80211_BAND_2GHZ);
 				channel = ieee80211_get_channel(wiphy, freq);
 
 				rssi = get_rssi_avg(network_info);
@@ -375,7 +375,7 @@ static void add_network_to_shadow(struct network_info *pstrNetworkInfo,
 	       pstrNetworkInfo->bssid, ETH_ALEN);
 	last_scanned_shadow[ap_index].beacon_period = pstrNetworkInfo->beacon_period;
 	last_scanned_shadow[ap_index].dtim_period = pstrNetworkInfo->dtim_period;
-	last_scanned_shadow[ap_index].u8channel = pstrNetworkInfo->u8channel;
+	last_scanned_shadow[ap_index].ch = pstrNetworkInfo->ch;
 	last_scanned_shadow[ap_index].u16IEsLen = pstrNetworkInfo->u16IEsLen;
 	last_scanned_shadow[ap_index].u64Tsf = pstrNetworkInfo->u64Tsf;
 	if (ap_found != -1)
@@ -417,7 +417,7 @@ static void CfgScanResult(enum scan_event scan_event,
 				return;
 
 			if (network_info) {
-				s32Freq = ieee80211_channel_to_frequency((s32)network_info->u8channel, IEEE80211_BAND_2GHZ);
+				s32Freq = ieee80211_channel_to_frequency((s32)network_info->ch, IEEE80211_BAND_2GHZ);
 				channel = ieee80211_get_channel(wiphy, s32Freq);
 
 				if (!channel)
@@ -895,15 +895,15 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 
-	PRINT_INFO(CFG80211_DBG, "Required Channel = %d\n", pstrNetworkInfo->u8channel);
+	PRINT_INFO(CFG80211_DBG, "Required Ch = %d\n", pstrNetworkInfo->ch);
 
 	PRINT_INFO(CFG80211_DBG, "Group encryption value = %s\n Cipher Group = %s\n WPA version = %s\n",
 		   pcgroup_encrypt_val, pccipher_group, pcwpa_version);
 
-	curr_channel = pstrNetworkInfo->u8channel;
+	curr_channel = pstrNetworkInfo->ch;
 
 	if (!pstrWFIDrv->p2p_connect)
-		wlan_channel = pstrNetworkInfo->u8channel;
+		wlan_channel = pstrNetworkInfo->ch;
 
 	wilc_wlan_set_bssid(dev, pstrNetworkInfo->bssid, STATION_MODE);
 
@@ -911,7 +911,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 				     sme->ssid_len, sme->ie, sme->ie_len,
 				     CfgConnectResult, (void *)priv,
 				     u8security, tenuAuth_type,
-				     pstrNetworkInfo->u8channel,
+				     pstrNetworkInfo->ch,
 				     pstrNetworkInfo->pJoinParams);
 	if (s32Error != 0) {
 		netdev_err(dev, "wilc_set_join_req(): Error\n");
-- 
1.9.1

