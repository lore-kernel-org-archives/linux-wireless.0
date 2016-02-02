Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:9665 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868AbcBBMHn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 07:07:43 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 21/26] staging: wilc1000: renames u64Tsf of connect_resp_info structure
Date: Tue, 2 Feb 2016 21:02:31 +0900
Message-ID: <1454414556-9822-21-git-send-email-leo.kim@atmel.com> (sfid-20160202_131501_997116_9B770BC4)
In-Reply-To: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
References: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u64Tsf variable to tsf_hi.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       | 2 +-
 drivers/staging/wilc1000/coreconfigurator.h       | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index cbca6a0..d481719 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -320,7 +320,7 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
 		tsf_lo = get_beacon_timestamp_lo(msa);
 		tsf_hi = get_beacon_timestamp_hi(msa);
 
-		network_info->u64Tsf = tsf_lo | ((u64)tsf_hi << 32);
+		network_info->tsf_hi = tsf_lo | ((u64)tsf_hi << 32);
 
 		get_ssid(msa, network_info->ssid, &network_info->ssid_len);
 		get_BSSID(msa, network_info->bssid);
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 18c785b..748199d 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -94,7 +94,7 @@ struct network_info {
 	u16 ies_len;
 	void *join_params;
 	tstrRSSI str_rssi;
-	u64 u64Tsf;
+	u64 tsf_hi;
 };
 
 struct connect_resp_info {
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 15565cf..1f0e4e2 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -251,7 +251,7 @@ static void refresh_scan(void *user_void, u8 all, bool direct_scan)
 								  channel,
 								  CFG80211_BSS_FTYPE_UNKNOWN,
 								  network_info->bssid,
-								  network_info->u64Tsf,
+								  network_info->tsf_hi,
 								  network_info->cap_info,
 								  network_info->beacon_period,
 								  (const u8 *)network_info->ies,
@@ -379,7 +379,7 @@ static void add_network_to_shadow(struct network_info *pstrNetworkInfo,
 	last_scanned_shadow[ap_index].dtim_period = pstrNetworkInfo->dtim_period;
 	last_scanned_shadow[ap_index].ch = pstrNetworkInfo->ch;
 	last_scanned_shadow[ap_index].ies_len = pstrNetworkInfo->ies_len;
-	last_scanned_shadow[ap_index].u64Tsf = pstrNetworkInfo->u64Tsf;
+	last_scanned_shadow[ap_index].tsf_hi = pstrNetworkInfo->tsf_hi;
 	if (ap_found != -1)
 		kfree(last_scanned_shadow[ap_index].ies);
 	last_scanned_shadow[ap_index].ies = kmalloc(pstrNetworkInfo->ies_len,
@@ -449,7 +449,7 @@ static void CfgScanResult(enum scan_event scan_event,
 										  channel,
 										  CFG80211_BSS_FTYPE_UNKNOWN,
 										  network_info->bssid,
-										  network_info->u64Tsf,
+										  network_info->tsf_hi,
 										  network_info->cap_info,
 										  network_info->beacon_period,
 										  (const u8 *)network_info->ies,
-- 
1.9.1

