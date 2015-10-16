Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:52475 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbbJPEkI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 00:40:08 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 18/40] staging: wilc1000: rename variable gapu8RcvdAssocResp
Date: Fri, 16 Oct 2015 13:37:48 +0900
Message-ID: <1444970290-17609-18-git-send-email-tony.cho@atmel.com> (sfid-20151016_064659_162699_7BCFACBB)
In-Reply-To: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
References: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames variable gapu8RcvdAssocResp to rcv_assoc_resp
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8c529d1..5112aee 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -249,7 +249,7 @@ static struct timer_list periodic_rssi;
 
 u8 gau8MulticastMacAddrList[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
 
-static u8 gapu8RcvdAssocResp[MAX_ASSOC_RESP_FRAME_SIZE];
+static u8 rcv_assoc_resp[MAX_ASSOC_RESP_FRAME_SIZE];
 
 bool gbScanWhileConnected;
 
@@ -1567,10 +1567,10 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			memset(&strConnectInfo, 0, sizeof(tstrConnectInfo));
 
 			if (u8MacStatus == MAC_CONNECTED) {
-				memset(gapu8RcvdAssocResp, 0, MAX_ASSOC_RESP_FRAME_SIZE);
+				memset(rcv_assoc_resp, 0, MAX_ASSOC_RESP_FRAME_SIZE);
 
 				host_int_get_assoc_res_info(hif_drv,
-							    gapu8RcvdAssocResp,
+							    rcv_assoc_resp,
 							    MAX_ASSOC_RESP_FRAME_SIZE,
 							    &u32RcvdAssocRespInfoLen);
 
@@ -1579,7 +1579,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 				if (u32RcvdAssocRespInfoLen != 0) {
 
 					PRINT_D(HOSTINF_DBG, "Parsing association response\n");
-					s32Err = ParseAssocRespInfo(gapu8RcvdAssocResp, u32RcvdAssocRespInfoLen,
+					s32Err = ParseAssocRespInfo(rcv_assoc_resp, u32RcvdAssocRespInfoLen,
 								    &pstrConnectRespInfo);
 					if (s32Err) {
 						PRINT_ER("ParseAssocRespInfo() returned error %d\n", s32Err);
-- 
1.9.1

