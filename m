Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:2892 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbbJMKwr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:52:47 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 20/54] staging: wilc1000: rename pvUserArg of struct scan_attr
Date: Tue, 13 Oct 2015 19:49:45 +0900
Message-ID: <1444733419-17679-20-git-send-email-tony.cho@atmel.com> (sfid-20151013_125250_079179_7C8EB9BF)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pvUserArg of struct scan_attr to arg to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c5cf7d4..6926a9e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -103,7 +103,7 @@ struct scan_attr {
 	u8 *ies;
 	size_t ies_len;
 	wilc_scan_result result;
-	void *pvUserArg;
+	void *arg;
 	struct hidden_network strHiddenNetwork;
 };
 
@@ -841,7 +841,7 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 	PRINT_D(HOSTINF_DBG, "Scanning: In [%d] state\n", hif_drv->enuHostIFstate);
 
 	hif_drv->strWILC_UsrScanReq.pfUserScanResult = pstrHostIFscanAttr->result;
-	hif_drv->strWILC_UsrScanReq.u32UserScanPvoid = pstrHostIFscanAttr->pvUserArg;
+	hif_drv->strWILC_UsrScanReq.u32UserScanPvoid = pstrHostIFscanAttr->arg;
 
 	if ((hif_drv->enuHostIFstate >= HOST_IF_SCANNING) && (hif_drv->enuHostIFstate < HOST_IF_CONNECTED)) {
 		PRINT_D(GENERIC_DBG, "Don't scan we are already in [%d] state\n", hif_drv->enuHostIFstate);
@@ -4060,7 +4060,7 @@ s32 host_int_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
 	msg.body.scan_info.src = u8ScanSource;
 	msg.body.scan_info.type = u8ScanType;
 	msg.body.scan_info.result = ScanResult;
-	msg.body.scan_info.pvUserArg = pvUserArg;
+	msg.body.scan_info.arg = pvUserArg;
 
 	msg.body.scan_info.ch_list_len = u8ChnlListLen;
 	msg.body.scan_info.ch_freq_list = kmalloc(u8ChnlListLen, GFP_KERNEL);
-- 
1.9.1

