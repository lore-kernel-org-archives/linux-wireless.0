Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:9612 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144AbcBBMH0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 07:07:26 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 18/26] staging: wilc1000: renames struct connect_resp_info variables
Date: Tue, 2 Feb 2016 21:02:28 +0900
Message-ID: <1454414556-9822-18-git-send-email-leo.kim@atmel.com> (sfid-20160202_130730_191079_81E72E7E)
In-Reply-To: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
References: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames to avoid camelcase changes follow are:
 - pu8IEs to ies
 - u16IEsLen to ies_len

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       |  7 +++---
 drivers/staging/wilc1000/coreconfigurator.h       |  4 +--
 drivers/staging/wilc1000/host_interface.c         |  6 ++---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 30 +++++++++++------------
 4 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 3e1e1f5..cbca6a0 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -341,12 +341,11 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
 		ies_len = rx_len - (MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN + CAP_INFO_LEN);
 
 		if (ies_len > 0) {
-			network_info->pu8IEs = kmemdup(ies, ies_len,
-						       GFP_KERNEL);
-			if (!network_info->pu8IEs)
+			network_info->ies = kmemdup(ies, ies_len, GFP_KERNEL);
+			if (!network_info->ies)
 				return -ENOMEM;
 		}
-		network_info->u16IEsLen = ies_len;
+		network_info->ies_len = ies_len;
 	}
 
 	*ret_network_info = network_info;
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 07a2ef0..3dca840 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -90,8 +90,8 @@ struct network_info {
 	bool new_network;
 	u8 found;
 	u32 tsf_lo;
-	u8 *pu8IEs;
-	u16 u16IEsLen;
+	u8 *ies;
+	u16 ies_len;
 	void *pJoinParams;
 	tstrRSSI strRssi;
 	u64 u64Tsf;
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ac71453..017a357 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1414,7 +1414,7 @@ done:
 	pstrRcvdNetworkInfo->buffer = NULL;
 
 	if (pstrNetworkInfo) {
-		kfree(pstrNetworkInfo->pu8IEs);
+		kfree(pstrNetworkInfo->ies);
 		kfree(pstrNetworkInfo);
 	}
 
@@ -4271,8 +4271,8 @@ static void *host_int_ParseJoinBssParam(struct network_info *ptstrNetworkInfo)
 	u8 authTotalCount = 0;
 	u8 i, j;
 
-	pu8IEs = ptstrNetworkInfo->pu8IEs;
-	u16IEsLen = ptstrNetworkInfo->u16IEsLen;
+	pu8IEs = ptstrNetworkInfo->ies;
+	u16IEsLen = ptstrNetworkInfo->ies_len;
 
 	pNewJoinBssParam = kzalloc(sizeof(struct join_bss_param), GFP_KERNEL);
 	if (pNewJoinBssParam) {
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index c09cc9d..fafe63c 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -194,9 +194,9 @@ static void clear_shadow_scan(void)
 		del_timer_sync(&hAgingTimer);
 
 		for (i = 0; i < last_scanned_cnt; i++) {
-			if (last_scanned_shadow[last_scanned_cnt].pu8IEs) {
-				kfree(last_scanned_shadow[i].pu8IEs);
-				last_scanned_shadow[last_scanned_cnt].pu8IEs = NULL;
+			if (last_scanned_shadow[last_scanned_cnt].ies) {
+				kfree(last_scanned_shadow[i].ies);
+				last_scanned_shadow[last_scanned_cnt].ies = NULL;
 			}
 
 			wilc_free_join_params(last_scanned_shadow[i].pJoinParams);
@@ -253,8 +253,8 @@ static void refresh_scan(void *user_void, u8 all, bool direct_scan)
 								  network_info->u64Tsf,
 								  network_info->cap_info,
 								  network_info->beacon_period,
-								  (const u8 *)network_info->pu8IEs,
-								  (size_t)network_info->u16IEsLen,
+								  (const u8 *)network_info->ies,
+								  (size_t)network_info->ies_len,
 								  (s32)rssi * 100,
 								  GFP_KERNEL);
 					cfg80211_put_bss(wiphy, bss);
@@ -292,8 +292,8 @@ static void remove_network_from_shadow(unsigned long arg)
 			PRINT_D(CFG80211_DBG, "Network expired ScanShadow:%s\n",
 				last_scanned_shadow[i].ssid);
 
-			kfree(last_scanned_shadow[i].pu8IEs);
-			last_scanned_shadow[i].pu8IEs = NULL;
+			kfree(last_scanned_shadow[i].ies);
+			last_scanned_shadow[i].ies = NULL;
 
 			wilc_free_join_params(last_scanned_shadow[i].pJoinParams);
 
@@ -377,14 +377,14 @@ static void add_network_to_shadow(struct network_info *pstrNetworkInfo,
 	last_scanned_shadow[ap_index].beacon_period = pstrNetworkInfo->beacon_period;
 	last_scanned_shadow[ap_index].dtim_period = pstrNetworkInfo->dtim_period;
 	last_scanned_shadow[ap_index].ch = pstrNetworkInfo->ch;
-	last_scanned_shadow[ap_index].u16IEsLen = pstrNetworkInfo->u16IEsLen;
+	last_scanned_shadow[ap_index].ies_len = pstrNetworkInfo->ies_len;
 	last_scanned_shadow[ap_index].u64Tsf = pstrNetworkInfo->u64Tsf;
 	if (ap_found != -1)
-		kfree(last_scanned_shadow[ap_index].pu8IEs);
-	last_scanned_shadow[ap_index].pu8IEs =
-		kmalloc(pstrNetworkInfo->u16IEsLen, GFP_KERNEL);
-	memcpy(last_scanned_shadow[ap_index].pu8IEs,
-	       pstrNetworkInfo->pu8IEs, pstrNetworkInfo->u16IEsLen);
+		kfree(last_scanned_shadow[ap_index].ies);
+	last_scanned_shadow[ap_index].ies = kmalloc(pstrNetworkInfo->ies_len,
+						    GFP_KERNEL);
+	memcpy(last_scanned_shadow[ap_index].ies,
+	       pstrNetworkInfo->ies, pstrNetworkInfo->ies_len);
 	last_scanned_shadow[ap_index].time_scan = jiffies;
 	last_scanned_shadow[ap_index].time_scan_cached = jiffies;
 	last_scanned_shadow[ap_index].found = 1;
@@ -451,8 +451,8 @@ static void CfgScanResult(enum scan_event scan_event,
 										  network_info->u64Tsf,
 										  network_info->cap_info,
 										  network_info->beacon_period,
-										  (const u8 *)network_info->pu8IEs,
-										  (size_t)network_info->u16IEsLen,
+										  (const u8 *)network_info->ies,
+										  (size_t)network_info->ies_len,
 										  (s32)network_info->rssi * 100,
 										  GFP_KERNEL);
 							cfg80211_put_bss(wiphy, bss);
-- 
1.9.1

