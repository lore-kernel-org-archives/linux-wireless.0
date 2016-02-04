Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:58901 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbcBDJct (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:32:49 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 53/70] staging: wilc1000: renames u8SsidLen of connect_resp_info structure
Date: Thu, 4 Feb 2016 18:24:14 +0900
Message-ID: <1454577871-667-14-git-send-email-glen.lee@atmel.com> (sfid-20160204_103259_898319_C453F45C)
In-Reply-To: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
References: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8SsidLen variable to ssid_len.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       | 2 +-
 drivers/staging/wilc1000/coreconfigurator.h       | 2 +-
 drivers/staging/wilc1000/host_interface.c         | 4 ++--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 4dd7c8a..273fad9 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -322,7 +322,7 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
 
 		network_info->u64Tsf = tsf_lo | ((u64)tsf_hi << 32);
 
-		get_ssid(msa, network_info->ssid, &network_info->u8SsidLen);
+		get_ssid(msa, network_info->ssid, &network_info->ssid_len);
 		get_BSSID(msa, network_info->au8bssid);
 
 		network_info->u8channel = get_current_channel_802_11n(msa,
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 781a65f..39f3691 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -80,7 +80,7 @@ struct network_info {
 	s8 rssi;
 	u16 cap_info;
 	u8 ssid[MAX_SSID_LEN];
-	u8 u8SsidLen;
+	u8 ssid_len;
 	u8 au8bssid[6];
 	u16 u16BeaconPeriod;
 	u8 u8DtimPeriod;
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c31f0b5..f9a8a44 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4280,8 +4280,8 @@ static void *host_int_ParseJoinBssParam(struct network_info *ptstrNetworkInfo)
 		pNewJoinBssParam->cap_info = ptstrNetworkInfo->cap_info;
 		memcpy(pNewJoinBssParam->au8bssid, ptstrNetworkInfo->au8bssid, 6);
 		memcpy((u8 *)pNewJoinBssParam->ssid, ptstrNetworkInfo->ssid,
-		       ptstrNetworkInfo->u8SsidLen + 1);
-		pNewJoinBssParam->ssid_len = ptstrNetworkInfo->u8SsidLen;
+		       ptstrNetworkInfo->ssid_len + 1);
+		pNewJoinBssParam->ssid_len = ptstrNetworkInfo->ssid_len;
 		memset(pNewJoinBssParam->rsn_pcip_policy, 0xFF, 3);
 		memset(pNewJoinBssParam->rsn_auth_policy, 0xFF, 3);
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 9aae11e..9819d14 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -368,9 +368,9 @@ static void add_network_to_shadow(struct network_info *pstrNetworkInfo,
 	last_scanned_shadow[ap_index].strRssi.u8Index = rssi_index;
 	last_scanned_shadow[ap_index].rssi = pstrNetworkInfo->rssi;
 	last_scanned_shadow[ap_index].cap_info = pstrNetworkInfo->cap_info;
-	last_scanned_shadow[ap_index].u8SsidLen = pstrNetworkInfo->u8SsidLen;
+	last_scanned_shadow[ap_index].ssid_len = pstrNetworkInfo->ssid_len;
 	memcpy(last_scanned_shadow[ap_index].ssid,
-	       pstrNetworkInfo->ssid, pstrNetworkInfo->u8SsidLen);
+	       pstrNetworkInfo->ssid, pstrNetworkInfo->ssid_len);
 	memcpy(last_scanned_shadow[ap_index].au8bssid,
 	       pstrNetworkInfo->au8bssid, ETH_ALEN);
 	last_scanned_shadow[ap_index].u16BeaconPeriod = pstrNetworkInfo->u16BeaconPeriod;
@@ -738,7 +738,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	PRINT_INFO(CFG80211_DBG, "Required SSID = %s\n , AuthType = %d\n", sme->ssid, sme->auth_type);
 
 	for (i = 0; i < last_scanned_cnt; i++) {
-		if ((sme->ssid_len == last_scanned_shadow[i].u8SsidLen) &&
+		if ((sme->ssid_len == last_scanned_shadow[i].ssid_len) &&
 		    memcmp(last_scanned_shadow[i].ssid,
 			   sme->ssid,
 			   sme->ssid_len) == 0) {
-- 
1.9.1

