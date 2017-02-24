Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:34206 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751301AbdBXWFa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 17:05:30 -0500
Date: Fri, 24 Feb 2017 17:05:07 -0500
From: Tahia Khan <tahia.khan@gmail.com>
To: outreachy-kernel@googlegroups.com, aditya.shankar@microchip.com,
        ganesh.krishna@microchip.com, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/3] staging: wilc1000: Rename tstrRSSI members and change
 type of u8Full to bool
Message-ID: <e4e0e4da09635d0cb7ef43223022490b6de739a8.1487947616.git.tahia.khan@gmail.com> (sfid-20170224_230634_169755_CA8DE1AF)
References: <cover.1487947616.git.tahia.khan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1487947616.git.tahia.khan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove Hungarian notation and camel casing from all tstrRSSI members' 
names. Additionally, change type of u8Full to bool since it only takes 
values 1 or 0.

Signed-off-by: Tahia Khan <tahia.khan@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/staging/wilc1000/coreconfigurator.h       |  6 +++---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 14 +++++++-------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 1c77529..9712d89 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -71,9 +71,9 @@ enum connect_status {
 };
 
 struct rssi_history_buffer {
-	u8 u8Full;
-	u8 u8Index;
-	s8 as8RSSI[NUM_RSSI];
+	bool full;
+	u8 index;
+	s8 samples[NUM_RSSI];
 };
 
 struct network_info {
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index f7ce47c..9601ab8 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -205,11 +205,11 @@ static u32 get_rssi_avg(struct network_info *network_info)
 {
 	u8 i;
 	int rssi_v = 0;
-	u8 num_rssi = (network_info->str_rssi.u8Full) ?
-		       NUM_RSSI : (network_info->str_rssi.u8Index);
+	u8 num_rssi = (network_info->str_rssi.full) ?
+		       NUM_RSSI : (network_info->str_rssi.index);
 
 	for (i = 0; i < num_rssi; i++)
-		rssi_v += network_info->str_rssi.as8RSSI[i];
+		rssi_v += network_info->str_rssi.samples[i];
 
 	rssi_v /= num_rssi;
 	return rssi_v;
@@ -346,13 +346,13 @@ static void add_network_to_shadow(struct network_info *pstrNetworkInfo,
 	} else {
 		ap_index = ap_found;
 	}
-	rssi_index = last_scanned_shadow[ap_index].str_rssi.u8Index;
-	last_scanned_shadow[ap_index].str_rssi.as8RSSI[rssi_index++] = pstrNetworkInfo->rssi;
+	rssi_index = last_scanned_shadow[ap_index].str_rssi.index;
+	last_scanned_shadow[ap_index].str_rssi.samples[rssi_index++] = pstrNetworkInfo->rssi;
 	if (rssi_index == NUM_RSSI) {
 		rssi_index = 0;
-		last_scanned_shadow[ap_index].str_rssi.u8Full = 1;
+		last_scanned_shadow[ap_index].str_rssi.full = true;
 	}
-	last_scanned_shadow[ap_index].str_rssi.u8Index = rssi_index;
+	last_scanned_shadow[ap_index].str_rssi.index = rssi_index;
 	last_scanned_shadow[ap_index].rssi = pstrNetworkInfo->rssi;
 	last_scanned_shadow[ap_index].cap_info = pstrNetworkInfo->cap_info;
 	last_scanned_shadow[ap_index].ssid_len = pstrNetworkInfo->ssid_len;
-- 
2.7.4
