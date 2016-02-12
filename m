Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35149 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbcBLOEv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Feb 2016 09:04:51 -0500
Received: by mail-pf0-f193.google.com with SMTP id w128so3444712pfb.2
        for <linux-wireless@vger.kernel.org>; Fri, 12 Feb 2016 06:04:51 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 01/11] staging: wilc1000: rename au8bssid in struct join_bss_param
Date: Fri, 12 Feb 2016 23:04:37 +0900
Message-Id: <1455285887-29946-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20160212_150457_426463_FB9CFA94)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames au8bssid to bssid to remove au8 prefix in struct
join_bss_param. There is no need to use prefix to show data type of this
variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5570707..ab02159 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -211,7 +211,7 @@ struct join_bss_param {
 	u8 dtim_period;
 	u16 beacon_period;
 	u16 cap_info;
-	u8 au8bssid[6];
+	u8 bssid[6];
 	char ssid[MAX_SSID_LEN];
 	u8 ssid_len;
 	u8 supp_rates[MAX_RATES_SUPPORTED + 1];
@@ -4246,7 +4246,7 @@ static void *host_int_ParseJoinBssParam(struct network_info *ptstrNetworkInfo)
 		pNewJoinBssParam->dtim_period = ptstrNetworkInfo->dtim_period;
 		pNewJoinBssParam->beacon_period = ptstrNetworkInfo->beacon_period;
 		pNewJoinBssParam->cap_info = ptstrNetworkInfo->cap_info;
-		memcpy(pNewJoinBssParam->au8bssid, ptstrNetworkInfo->bssid, 6);
+		memcpy(pNewJoinBssParam->bssid, ptstrNetworkInfo->bssid, 6);
 		memcpy((u8 *)pNewJoinBssParam->ssid, ptstrNetworkInfo->ssid,
 		       ptstrNetworkInfo->ssid_len + 1);
 		pNewJoinBssParam->ssid_len = ptstrNetworkInfo->ssid_len;
-- 
2.7.1

