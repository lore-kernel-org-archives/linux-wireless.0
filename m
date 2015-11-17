Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:36426 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbbKQUBf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2015 15:01:35 -0500
From: Bogicevic Sasa <brutallesale@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bogicevic Sasa <brutallesale@gmail.com>
Subject: [PATCH] drivers:staging:wilc1000 Fix comparison to NULL messages
Date: Tue, 17 Nov 2015 21:01:28 +0100
Message-Id: <1447790488-17742-1-git-send-email-brutallesale@gmail.com> (sfid-20151117_210205_084209_3F2A842B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes all "Comparison to NULL could be written like..."
messages from checkpatch.pl

Signed-off-by: Bogicevic Sasa <brutallesale@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index fd7240c..a31ac55 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -434,7 +434,7 @@ s32 parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 
 		/* Get DTIM Period */
 		pu8TimElm = get_tim_elm(pu8msa, u16RxLen + FCS_LEN, u8index);
-		if (pu8TimElm != NULL)
+		if (!pu8TimElm)
 			pstrNetworkInfo->u8DtimPeriod = pu8TimElm[3];
 		pu8IEs = &pu8msa[MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN + CAP_INFO_LEN];
 		u16IEsLen = u16RxLen - (MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN + CAP_INFO_LEN);
@@ -468,8 +468,8 @@ s32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo)
 {
 	s32 s32Error = 0;
 
-	if (pstrNetworkInfo != NULL) {
-		if (pstrNetworkInfo->pu8IEs != NULL) {
+	if (!pstrNetworkInfo) {
+		if (!pstrNetworkInfo->pu8IEs) {
 			kfree(pstrNetworkInfo->pu8IEs);
 			pstrNetworkInfo->pu8IEs = NULL;
 		} else {
@@ -553,8 +553,8 @@ s32 DeallocateAssocRespInfo(tstrConnectRespInfo *pstrConnectRespInfo)
 {
 	s32 s32Error = 0;
 
-	if (pstrConnectRespInfo != NULL) {
-		if (pstrConnectRespInfo->pu8RespIEs != NULL) {
+	if (!pstrConnectRespInfo) {
+		if (!pstrConnectRespInfo->pu8RespIEs) {
 			kfree(pstrConnectRespInfo->pu8RespIEs);
 			pstrConnectRespInfo->pu8RespIEs = NULL;
 		} else {
-- 
2.1.4

