Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:36013 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754345AbdBVROo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Feb 2017 12:14:44 -0500
Date: Wed, 22 Feb 2017 12:14:41 -0500
From: Tahia Khan <tahia.khan@gmail.com>
To: outreachy-kernel@googlegroups.com, aditya.shankar@microchip.com,
        ganesh.krishna@microchip.com, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: wilc1000: renames struct tstrRSSI and its
 members u8Index, u8Full
Message-ID: <20170222171403.GA20626@coolbox> (sfid-20170222_181450_177693_68BA4491)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes multiple camel case checks on struct tstrRSSI from checkpatch.pl:

Avoid CamelCase: <tstrRSSI>
Avoid CamelCase: <u8Full>
Avoid CamelCase: <u8Index>

Signed-off-by: Tahia Khan <tahia.khan@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.h       |  8 ++++----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 10 +++++-----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index cff1698..5b65c4f 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -70,9 +70,9 @@ enum connect_status {
 	CONNECT_STS_FORCE_16_BIT = 0xFFFF
 };
 
-struct tstrRSSI {
-	u8 u8Full;
-	u8 u8Index;
+struct tstr_RSSI {
+	u8 full;
+	u8 index;
 	s8 as8RSSI[NUM_RSSI];
 };
 
@@ -93,7 +93,7 @@ struct network_info {
 	u8 *ies;
 	u16 ies_len;
 	void *join_params;
-	struct tstrRSSI str_rssi;
+	struct tstr_RSSI str_rssi;
 	u64 tsf_hi;
 };
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index f7ce47c..56f133e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -205,8 +205,8 @@ static u32 get_rssi_avg(struct network_info *network_info)
 {
 	u8 i;
 	int rssi_v = 0;
-	u8 num_rssi = (network_info->str_rssi.u8Full) ?
-		       NUM_RSSI : (network_info->str_rssi.u8Index);
+	u8 num_rssi = (network_info->str_rssi.full) ?
+		       NUM_RSSI : (network_info->str_rssi.index);
 
 	for (i = 0; i < num_rssi; i++)
 		rssi_v += network_info->str_rssi.as8RSSI[i];
@@ -346,13 +346,13 @@ static void add_network_to_shadow(struct network_info *pstrNetworkInfo,
 	} else {
 		ap_index = ap_found;
 	}
-	rssi_index = last_scanned_shadow[ap_index].str_rssi.u8Index;
+	rssi_index = last_scanned_shadow[ap_index].str_rssi.index;
 	last_scanned_shadow[ap_index].str_rssi.as8RSSI[rssi_index++] = pstrNetworkInfo->rssi;
 	if (rssi_index == NUM_RSSI) {
 		rssi_index = 0;
-		last_scanned_shadow[ap_index].str_rssi.u8Full = 1;
+		last_scanned_shadow[ap_index].str_rssi.full = 1;
 	}
-	last_scanned_shadow[ap_index].str_rssi.u8Index = rssi_index;
+	last_scanned_shadow[ap_index].str_rssi.index = rssi_index;
 	last_scanned_shadow[ap_index].rssi = pstrNetworkInfo->rssi;
 	last_scanned_shadow[ap_index].cap_info = pstrNetworkInfo->cap_info;
 	last_scanned_shadow[ap_index].ssid_len = pstrNetworkInfo->ssid_len;
-- 
2.7.4
