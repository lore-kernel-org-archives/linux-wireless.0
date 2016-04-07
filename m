Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0231.hostedemail.com ([216.40.44.231]:53796 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755272AbcDGLAf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 07:00:35 -0400
Message-ID: <1460026830.6715.80.camel@perches.com> (sfid-20160407_130053_005205_7FC04DFE)
Subject: Re: [PATCH 525/525] Staging: Wilc1000: Fixed coding style
 ether_addr_copy
From: Joe Perches <joe@perches.com>
To: Shyam Saini <mayhs11saini@gmail.com>, johnny.kim@atmel.com
Cc: austin.shin@atmel.com, chris.park@atmel.com, tony.cho@atmel.com,
	gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Date: Thu, 07 Apr 2016 04:00:30 -0700
In-Reply-To: <1460021835-8370-1-git-send-email-mayhs11saini@gmail.com>
References: <1460021835-8370-1-git-send-email-mayhs11saini@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-04-07 at 15:07 +0530, Shyam Saini wrote:
> Fixed following warning detected by checkpatch.pl:
> warning: Prefer ether_addr_copy() over memcpy() if the Ethernet addressesare __aligned(2)

Please don't just do checkpatch cleanups but strive
to make the code more intelligible for humans.

Also, there's a malloc that may fail that writes through
the returned pointer that could be NULL.

The kmalloc/memcpy could be a kmemdup.

It would make the code shorter and clearer to remove
u32 ap_index and use a temporary pointer for all the
last_scanned_shadow[ap_index]. uses instead.

Something like:
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 54 +++++++++++------------
 1 file changed, 25 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 358632b..35696e2 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -339,49 +339,45 @@ static void add_network_to_shadow(struct network_info *pstrNetworkInfo,
 				  void *user_void, void *pJoinParams)
 {
 	int ap_found = is_network_in_shadow(pstrNetworkInfo, user_void);
-	u32 ap_index = 0;
 	u8 rssi_index = 0;
+	struct network_info *ni;
 
 	if (last_scanned_cnt >= MAX_NUM_SCANNED_NETWORKS_SHADOW)
 		return;
 
 	if (ap_found == -1) {
-		ap_index = last_scanned_cnt;
+		ni = &last_scanned_shadow[last_scanned_cnt];
 		last_scanned_cnt++;
 	} else {
-		ap_index = ap_found;
+		ni = &last_scanned_shadow[ap_found];
 	}
-	rssi_index = last_scanned_shadow[ap_index].str_rssi.u8Index;
-	last_scanned_shadow[ap_index].str_rssi.as8RSSI[rssi_index++] = pstrNetworkInfo->rssi;
+	rssi_index = ni->str_rssi.u8Index;
+	ni->str_rssi.as8RSSI[rssi_index++] = pstrNetworkInfo->rssi;
 	if (rssi_index == NUM_RSSI) {
 		rssi_index = 0;
-		last_scanned_shadow[ap_index].str_rssi.u8Full = 1;
+		ni->str_rssi.u8Full = 1;
 	}
-	last_scanned_shadow[ap_index].str_rssi.u8Index = rssi_index;
-	last_scanned_shadow[ap_index].rssi = pstrNetworkInfo->rssi;
-	last_scanned_shadow[ap_index].cap_info = pstrNetworkInfo->cap_info;
-	last_scanned_shadow[ap_index].ssid_len = pstrNetworkInfo->ssid_len;
-	memcpy(last_scanned_shadow[ap_index].ssid,
-	       pstrNetworkInfo->ssid, pstrNetworkInfo->ssid_len);
-	memcpy(last_scanned_shadow[ap_index].bssid,
-	       pstrNetworkInfo->bssid, ETH_ALEN);
-	last_scanned_shadow[ap_index].beacon_period = pstrNetworkInfo->beacon_period;
-	last_scanned_shadow[ap_index].dtim_period = pstrNetworkInfo->dtim_period;
-	last_scanned_shadow[ap_index].ch = pstrNetworkInfo->ch;
-	last_scanned_shadow[ap_index].ies_len = pstrNetworkInfo->ies_len;
-	last_scanned_shadow[ap_index].tsf_hi = pstrNetworkInfo->tsf_hi;
+	ni->str_rssi.u8Index = rssi_index;
+	ni->rssi = pstrNetworkInfo->rssi;
+	ni->cap_info = pstrNetworkInfo->cap_info;
+	ni->ssid_len = pstrNetworkInfo->ssid_len;
+	memcpy(ni->ssid, pstrNetworkInfo->ssid, pstrNetworkInfo->ssid_len);
+	ether_addr_copy(ni->bssid, pstrNetworkInfo->bssid);
+	ni->beacon_period = pstrNetworkInfo->beacon_period;
+	ni->dtim_period = pstrNetworkInfo->dtim_period;
+	ni->ch = pstrNetworkInfo->ch;
+	ni->ies_len = pstrNetworkInfo->ies_len;
+	ni->tsf_hi = pstrNetworkInfo->tsf_hi;
 	if (ap_found != -1)
-		kfree(last_scanned_shadow[ap_index].ies);
-	last_scanned_shadow[ap_index].ies = kmalloc(pstrNetworkInfo->ies_len,
-						    GFP_KERNEL);
-	memcpy(last_scanned_shadow[ap_index].ies,
-	       pstrNetworkInfo->ies, pstrNetworkInfo->ies_len);
-	last_scanned_shadow[ap_index].time_scan = jiffies;
-	last_scanned_shadow[ap_index].time_scan_cached = jiffies;
-	last_scanned_shadow[ap_index].found = 1;
+		kfree(ni->ies);
+	ni->ies = kmemdup(pstrNetworkInfo->ies, pstrNetworkInfo->ies_len,
+			  GFP_KERNEL);
+	ni->time_scan = jiffies;
+	ni->time_scan_cached = jiffies;
+	ni->found = 1;
 	if (ap_found != -1)
-		kfree(last_scanned_shadow[ap_index].join_params);
-	last_scanned_shadow[ap_index].join_params = pJoinParams;
+		kfree(ni->join_params);
+	ni->join_params = pJoinParams;
 }
 
 static void CfgScanResult(enum scan_event scan_event,
