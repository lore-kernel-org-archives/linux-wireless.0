Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:59143 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933304AbcBDJdz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:33:55 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 64/70] staging: wilc1000: renames strRssi of connect_resp_info structure
Date: Thu, 4 Feb 2016 18:24:25 +0900
Message-ID: <1454577871-667-25-git-send-email-glen.lee@atmel.com> (sfid-20160204_103401_322428_9E3A3E5C)
In-Reply-To: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
References: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames strRssi variable to str_rssi.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.h       |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 13 +++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index f154e39..18c785b 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -93,7 +93,7 @@ struct network_info {
 	u8 *ies;
 	u16 ies_len;
 	void *join_params;
-	tstrRSSI strRssi;
+	tstrRSSI str_rssi;
 	u64 u64Tsf;
 };
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 6ebf268..6750700 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -210,10 +210,11 @@ static u32 get_rssi_avg(struct network_info *network_info)
 {
 	u8 i;
 	int rssi_v = 0;
-	u8 num_rssi = (network_info->strRssi.u8Full) ? NUM_RSSI : (network_info->strRssi.u8Index);
+	u8 num_rssi = (network_info->str_rssi.u8Full) ?
+		       NUM_RSSI : (network_info->str_rssi.u8Index);
 
 	for (i = 0; i < num_rssi; i++)
-		rssi_v += network_info->strRssi.as8RSSI[i];
+		rssi_v += network_info->str_rssi.as8RSSI[i];
 
 	rssi_v /= num_rssi;
 	return rssi_v;
@@ -360,13 +361,13 @@ static void add_network_to_shadow(struct network_info *pstrNetworkInfo,
 	} else {
 		ap_index = ap_found;
 	}
-	rssi_index = last_scanned_shadow[ap_index].strRssi.u8Index;
-	last_scanned_shadow[ap_index].strRssi.as8RSSI[rssi_index++] = pstrNetworkInfo->rssi;
+	rssi_index = last_scanned_shadow[ap_index].str_rssi.u8Index;
+	last_scanned_shadow[ap_index].str_rssi.as8RSSI[rssi_index++] = pstrNetworkInfo->rssi;
 	if (rssi_index == NUM_RSSI) {
 		rssi_index = 0;
-		last_scanned_shadow[ap_index].strRssi.u8Full = 1;
+		last_scanned_shadow[ap_index].str_rssi.u8Full = 1;
 	}
-	last_scanned_shadow[ap_index].strRssi.u8Index = rssi_index;
+	last_scanned_shadow[ap_index].str_rssi.u8Index = rssi_index;
 	last_scanned_shadow[ap_index].rssi = pstrNetworkInfo->rssi;
 	last_scanned_shadow[ap_index].cap_info = pstrNetworkInfo->cap_info;
 	last_scanned_shadow[ap_index].ssid_len = pstrNetworkInfo->ssid_len;
-- 
1.9.1

