Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:9577 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213AbcBBMHV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 07:07:21 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 17/26] staging: wilc1000: renames u32Tsf of connect_resp_info structure
Date: Tue, 2 Feb 2016 21:02:27 +0900
Message-ID: <1454414556-9822-17-git-send-email-leo.kim@atmel.com> (sfid-20160202_130725_049662_0BD248DB)
In-Reply-To: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
References: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u32Tsf variable to tsf_lo.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 2 +-
 drivers/staging/wilc1000/coreconfigurator.h | 2 +-
 drivers/staging/wilc1000/host_interface.c   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 6c748aa..3e1e1f5 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -315,7 +315,7 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
 
 		rx_len = wid_len - 1;
 		network_info->cap_info = get_cap_info(msa);
-		network_info->u32Tsf = get_beacon_timestamp_lo(msa);
+		network_info->tsf_lo = get_beacon_timestamp_lo(msa);
 
 		tsf_lo = get_beacon_timestamp_lo(msa);
 		tsf_hi = get_beacon_timestamp_hi(msa);
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 27c35d7..07a2ef0 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -89,7 +89,7 @@ struct network_info {
 	unsigned long time_scan;
 	bool new_network;
 	u8 found;
-	u32 u32Tsf;
+	u32 tsf_lo;
 	u8 *pu8IEs;
 	u16 u16IEsLen;
 	void *pJoinParams;
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ffa175d..ac71453 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4331,7 +4331,7 @@ static void *host_int_ParseJoinBssParam(struct network_info *ptstrNetworkInfo)
 				 (pu8IEs[index + 5] == 0x09) && (pu8IEs[index + 6] == 0x0c)) {
 				u16 u16P2P_count;
 
-				pNewJoinBssParam->tsf = ptstrNetworkInfo->u32Tsf;
+				pNewJoinBssParam->tsf = ptstrNetworkInfo->tsf_lo;
 				pNewJoinBssParam->noa_enabled = 1;
 				pNewJoinBssParam->idx = pu8IEs[index + 9];
 
-- 
1.9.1

