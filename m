Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:9622 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbcBBMHc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 07:07:32 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 19/26] staging: wilc1000: renames pJoinParams of connect_resp_info structure
Date: Tue, 2 Feb 2016 21:02:29 +0900
Message-ID: <1454414556-9822-19-git-send-email-leo.kim@atmel.com> (sfid-20160202_130735_035063_E4ABBAEA)
In-Reply-To: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
References: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pJoinParams variable to join_params.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.h       |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 3dca840..f154e39 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -92,7 +92,7 @@ struct network_info {
 	u32 tsf_lo;
 	u8 *ies;
 	u16 ies_len;
-	void *pJoinParams;
+	void *join_params;
 	tstrRSSI strRssi;
 	u64 u64Tsf;
 };
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index fafe63c..ef4a994 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -199,8 +199,8 @@ static void clear_shadow_scan(void)
 				last_scanned_shadow[last_scanned_cnt].ies = NULL;
 			}
 
-			wilc_free_join_params(last_scanned_shadow[i].pJoinParams);
-			last_scanned_shadow[i].pJoinParams = NULL;
+			wilc_free_join_params(last_scanned_shadow[i].join_params);
+			last_scanned_shadow[i].join_params = NULL;
 		}
 		last_scanned_cnt = 0;
 	}
@@ -295,7 +295,7 @@ static void remove_network_from_shadow(unsigned long arg)
 			kfree(last_scanned_shadow[i].ies);
 			last_scanned_shadow[i].ies = NULL;
 
-			wilc_free_join_params(last_scanned_shadow[i].pJoinParams);
+			wilc_free_join_params(last_scanned_shadow[i].join_params);
 
 			for (j = i; (j < last_scanned_cnt - 1); j++)
 				last_scanned_shadow[j] = last_scanned_shadow[j + 1];
@@ -389,8 +389,8 @@ static void add_network_to_shadow(struct network_info *pstrNetworkInfo,
 	last_scanned_shadow[ap_index].time_scan_cached = jiffies;
 	last_scanned_shadow[ap_index].found = 1;
 	if (ap_found != -1)
-		wilc_free_join_params(last_scanned_shadow[ap_index].pJoinParams);
-	last_scanned_shadow[ap_index].pJoinParams = pJoinParams;
+		wilc_free_join_params(last_scanned_shadow[ap_index].join_params);
+	last_scanned_shadow[ap_index].join_params = pJoinParams;
 }
 
 static void CfgScanResult(enum scan_event scan_event,
@@ -913,7 +913,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 				     CfgConnectResult, (void *)priv,
 				     u8security, tenuAuth_type,
 				     pstrNetworkInfo->ch,
-				     pstrNetworkInfo->pJoinParams);
+				     pstrNetworkInfo->join_params);
 	if (s32Error != 0) {
 		netdev_err(dev, "wilc_set_join_req(): Error\n");
 		s32Error = -ENOENT;
-- 
1.9.1

