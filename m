Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:41514 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbbJ1G5t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 02:57:49 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 02/80] staging: wilc1000: fixes braces {} are not necessary for single statement blocks
Date: Wed, 28 Oct 2015 15:59:22 +0900
Message-ID: <1446015640-29398-2-git-send-email-glen.lee@atmel.com> (sfid-20151028_075751_860198_8A2A94ED)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the warnings reported by checkpatch.pl
for braces {} are not necessary for single statement blocks

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 34 +++++++++++++++----------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index acc6552b..47064fe 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3339,13 +3339,13 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 	msg.body.key_info.attr.wpa.key = kmalloc(u8KeyLen, GFP_KERNEL);
 	memcpy(msg.body.key_info.attr.wpa.key, pu8RxGtk, u8GtkKeylen);
 
-	if (pu8RxMic) {
-		memcpy(msg.body.key_info.attr.wpa.key + 16, pu8RxMic, RX_MIC_KEY_LEN);
-	}
+	if (pu8RxMic)
+		memcpy(msg.body.key_info.attr.wpa.key + 16, pu8RxMic,
+		       RX_MIC_KEY_LEN);
 
-	if (pu8TxMic) {
-		memcpy(msg.body.key_info.attr.wpa.key + 24, pu8TxMic, TX_MIC_KEY_LEN);
-	}
+	if (pu8TxMic)
+		memcpy(msg.body.key_info.attr.wpa.key + 24, pu8TxMic,
+		       TX_MIC_KEY_LEN);
 
 	msg.body.key_info.attr.wpa.index = u8KeyIdx;
 	msg.body.key_info.attr.wpa.key_len = u8KeyLen;
@@ -4255,13 +4255,11 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 	terminated_handle = hif_drv;
 	PRINT_D(HOSTINF_DBG, "De-initializing host interface for client %d\n", clients_count);
 
-	if (del_timer_sync(&hif_drv->hScanTimer)) {
+	if (del_timer_sync(&hif_drv->hScanTimer))
 		PRINT_D(HOSTINF_DBG, ">> Scan timer is active\n");
-	}
 
-	if (del_timer_sync(&hif_drv->hConnectTimer)) {
+	if (del_timer_sync(&hif_drv->hConnectTimer))
 		PRINT_D(HOSTINF_DBG, ">> Connect timer is active\n");
-	}
 
 	if (del_timer_sync(&periodic_rssi))
 		PRINT_D(HOSTINF_DBG, ">> Connect timer is active\n");
@@ -4841,9 +4839,9 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 				pNewJoinBssParam->supp_rates[0] = suppRatesNo;
 				index += 2;
 
-				for (i = 0; i < suppRatesNo; i++) {
+				for (i = 0; i < suppRatesNo; i++)
 					pNewJoinBssParam->supp_rates[i + 1] = pu8IEs[index + i];
-				}
+
 				index += suppRatesNo;
 				continue;
 			} else if (pu8IEs[index] == EXT_SUPP_RATES_IE) {
@@ -4853,9 +4851,9 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 				else
 					pNewJoinBssParam->supp_rates[0] += extSuppRatesNo;
 				index += 2;
-				for (i = 0; i < (pNewJoinBssParam->supp_rates[0] - suppRatesNo); i++) {
+				for (i = 0; i < (pNewJoinBssParam->supp_rates[0] - suppRatesNo); i++)
 					pNewJoinBssParam->supp_rates[suppRatesNo + i + 1] = pu8IEs[index + i];
-				}
+
 				index += extSuppRatesNo;
 				continue;
 			} else if (pu8IEs[index] == HT_CAPABILITY_IE) {
@@ -4930,9 +4928,9 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 				pcipherCount = (pu8IEs[rsnIndex] > 3) ? 3 : pu8IEs[rsnIndex];
 				rsnIndex += 2;
 
-				for (i = pcipherTotalCount, j = 0; i < pcipherCount + pcipherTotalCount && i < 3; i++, j++) {
+				for (i = pcipherTotalCount, j = 0; i < pcipherCount + pcipherTotalCount && i < 3; i++, j++)
 					pNewJoinBssParam->rsn_pcip_policy[i] = pu8IEs[rsnIndex + ((j + 1) * 4) - 1];
-				}
+
 				pcipherTotalCount += pcipherCount;
 				rsnIndex += jumpOffset;
 
@@ -4941,9 +4939,9 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 				authCount = (pu8IEs[rsnIndex] > 3) ? 3 : pu8IEs[rsnIndex];
 				rsnIndex += 2;
 
-				for (i = authTotalCount, j = 0; i < authTotalCount + authCount; i++, j++) {
+				for (i = authTotalCount, j = 0; i < authTotalCount + authCount; i++, j++)
 					pNewJoinBssParam->rsn_auth_policy[i] = pu8IEs[rsnIndex + ((j + 1) * 4) - 1];
-				}
+
 				authTotalCount += authCount;
 				rsnIndex += jumpOffset;
 
-- 
1.9.1

