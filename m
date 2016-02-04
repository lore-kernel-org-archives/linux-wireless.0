Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:59073 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932961AbcBDJdj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:33:39 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 61/70] staging: wilc1000: renames u32Tsf of connect_resp_info structure
Date: Thu, 4 Feb 2016 18:24:22 +0900
Message-ID: <1454577871-667-22-git-send-email-glen.lee@atmel.com> (sfid-20160204_103357_722679_41B93B9C)
In-Reply-To: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
References: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

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
index c0171f9..fa6ee92 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4330,7 +4330,7 @@ static void *host_int_ParseJoinBssParam(struct network_info *ptstrNetworkInfo)
 				 (pu8IEs[index + 5] == 0x09) && (pu8IEs[index + 6] == 0x0c)) {
 				u16 u16P2P_count;
 
-				pNewJoinBssParam->tsf = ptstrNetworkInfo->u32Tsf;
+				pNewJoinBssParam->tsf = ptstrNetworkInfo->tsf_lo;
 				pNewJoinBssParam->noa_enabled = 1;
 				pNewJoinBssParam->idx = pu8IEs[index + 9];
 
-- 
1.9.1

