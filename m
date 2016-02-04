Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:58981 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932974AbcBDJdK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:33:10 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 56/70] staging: wilc1000: renames u8DtimPeriod of connect_resp_info structure
Date: Thu, 4 Feb 2016 18:24:17 +0900
Message-ID: <1454577871-667-17-git-send-email-glen.lee@atmel.com> (sfid-20160204_103317_794370_4E9ED71C)
In-Reply-To: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
References: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8DtimPeriod variable to dtim_period.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       | 2 +-
 drivers/staging/wilc1000/coreconfigurator.h       | 2 +-
 drivers/staging/wilc1000/host_interface.c         | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index b4f7ec3..ce3bc29 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -336,7 +336,7 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
 
 		tim_elm = get_tim_elm(msa, rx_len + FCS_LEN, index);
 		if (tim_elm)
-			network_info->u8DtimPeriod = tim_elm[3];
+			network_info->dtim_period = tim_elm[3];
 		ies = &msa[MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN + CAP_INFO_LEN];
 		ies_len = rx_len - (MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN + CAP_INFO_LEN);
 
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 2fbffe8..bbc4b0e 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -83,7 +83,7 @@ struct network_info {
 	u8 ssid_len;
 	u8 bssid[6];
 	u16 beacon_period;
-	u8 u8DtimPeriod;
+	u8 dtim_period;
 	u8 u8channel;
 	unsigned long u32TimeRcvdInScanCached;
 	unsigned long u32TimeRcvdInScan;
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0ba248b..df33197 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4275,7 +4275,7 @@ static void *host_int_ParseJoinBssParam(struct network_info *ptstrNetworkInfo)
 
 	pNewJoinBssParam = kzalloc(sizeof(struct join_bss_param), GFP_KERNEL);
 	if (pNewJoinBssParam) {
-		pNewJoinBssParam->dtim_period = ptstrNetworkInfo->u8DtimPeriod;
+		pNewJoinBssParam->dtim_period = ptstrNetworkInfo->dtim_period;
 		pNewJoinBssParam->beacon_period = ptstrNetworkInfo->beacon_period;
 		pNewJoinBssParam->cap_info = ptstrNetworkInfo->cap_info;
 		memcpy(pNewJoinBssParam->au8bssid, ptstrNetworkInfo->bssid, 6);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 9424776..16b2798 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -374,7 +374,7 @@ static void add_network_to_shadow(struct network_info *pstrNetworkInfo,
 	memcpy(last_scanned_shadow[ap_index].bssid,
 	       pstrNetworkInfo->bssid, ETH_ALEN);
 	last_scanned_shadow[ap_index].beacon_period = pstrNetworkInfo->beacon_period;
-	last_scanned_shadow[ap_index].u8DtimPeriod = pstrNetworkInfo->u8DtimPeriod;
+	last_scanned_shadow[ap_index].dtim_period = pstrNetworkInfo->dtim_period;
 	last_scanned_shadow[ap_index].u8channel = pstrNetworkInfo->u8channel;
 	last_scanned_shadow[ap_index].u16IEsLen = pstrNetworkInfo->u16IEsLen;
 	last_scanned_shadow[ap_index].u64Tsf = pstrNetworkInfo->u64Tsf;
-- 
1.9.1

