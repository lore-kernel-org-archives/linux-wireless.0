Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:9557 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207AbcBBMHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 07:07:15 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 16/26] staging: wilc1000: renames u8Found of connect_resp_info structure
Date: Tue, 2 Feb 2016 21:02:26 +0900
Message-ID: <1454414556-9822-16-git-send-email-leo.kim@atmel.com> (sfid-20160202_130719_434229_0D281ED1)
In-Reply-To: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
References: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u8Found variable to found.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.h       | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index fd3b5d4..27c35d7 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -88,7 +88,7 @@ struct network_info {
 	unsigned long time_scan_cached;
 	unsigned long time_scan;
 	bool new_network;
-	u8 u8Found;
+	u8 found;
 	u32 u32Tsf;
 	u8 *pu8IEs;
 	u16 u16IEsLen;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index b5c19ed..c09cc9d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -235,7 +235,7 @@ static void refresh_scan(void *user_void, u8 all, bool direct_scan)
 
 		network_info = &last_scanned_shadow[i];
 
-		if (!network_info->u8Found || all) {
+		if (!network_info->found || all) {
 			s32 freq;
 			struct ieee80211_channel *channel;
 
@@ -269,7 +269,7 @@ static void reset_shadow_found(void)
 	int i;
 
 	for (i = 0; i < last_scanned_cnt; i++)
-		last_scanned_shadow[i].u8Found = 0;
+		last_scanned_shadow[i].found = 0;
 }
 
 static void update_scan_time(void)
@@ -387,7 +387,7 @@ static void add_network_to_shadow(struct network_info *pstrNetworkInfo,
 	       pstrNetworkInfo->pu8IEs, pstrNetworkInfo->u16IEsLen);
 	last_scanned_shadow[ap_index].time_scan = jiffies;
 	last_scanned_shadow[ap_index].time_scan_cached = jiffies;
-	last_scanned_shadow[ap_index].u8Found = 1;
+	last_scanned_shadow[ap_index].found = 1;
 	if (ap_found != -1)
 		wilc_free_join_params(last_scanned_shadow[ap_index].pJoinParams);
 	last_scanned_shadow[ap_index].pJoinParams = pJoinParams;
-- 
1.9.1

