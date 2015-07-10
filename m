Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:44293 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbbGJF40 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2015 01:56:26 -0400
From: Johnny Kim <johnny.kim@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>, <chris.park@atmel.com>
CC: <johnny.kim@atmel.com>, <rachel.kim@atmel.com>,
	<tony.cho@atmel.com>, <Nicolas.FERRE@atmel.com>,
	<dean.lee@atmel.com>, <austin.shin@atmel.com>
Subject: [PATCH 1/3] staging: wilc1000: wilc_wlan_cfg_commit(): replace integer with pointer
Date: Fri, 10 Jul 2015 14:55:55 +0900
Message-ID: <1436507759-4546-2-git-send-email-johnny.kim@atmel.com> (sfid-20150710_075629_057325_17F8BEAC)
In-Reply-To: <1436507759-4546-1-git-send-email-johnny.kim@atmel.com>
References: <1436507759-4546-1-git-send-email-johnny.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A argument of wilc_wlan_cfg_commit() is address of structure.
But because the size is restricted to 32bit, it is not correct
for 64bit machine.

So, this changes the interger value to obvious structure pointer.

Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index def72fd..d32e45e 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1862,13 +1862,13 @@ static void wilc_wlan_cleanup(void)
 
 }
 
-static int wilc_wlan_cfg_commit(int type, uint32_t drvHandler)
+static int wilc_wlan_cfg_commit(int type, tstrWILC_WFIDrv *drvHandler)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	wilc_cfg_frame_t *cfg = &p->cfg_frame;
 	int total_len = p->cfg_frame_offset + 4 + DRIVER_HANDLER_SIZE;
 	int seq_no = p->cfg_seq_no % 256;
-	int driver_handler = (u32)drvHandler;
+	uintptr_t driver_handler = (uintptr_t)drvHandler;
 
 
 	/**
@@ -1923,7 +1923,7 @@ static int wilc_wlan_cfg_set(int start, uint32_t wid, uint8_t *buffer, uint32_t
 		p->cfg_frame_in_use = 1;
 
 		/*Edited by Amr - BugID_4720*/
-		if (wilc_wlan_cfg_commit(WILC_CFG_SET, drvHandler))
+		if (wilc_wlan_cfg_commit(WILC_CFG_SET, (tstrWILC_WFIDrv *)drvHandler))
 			ret_size = 0;   /* BugID_5213 */
 
 		if (p->os_func.os_wait(p->cfg_wait, CFG_PKTS_TIMEOUT)) {
@@ -1960,7 +1960,7 @@ static int wilc_wlan_cfg_get(int start, uint32_t wid, int commit, uint32_t drvHa
 		p->cfg_frame_in_use = 1;
 
 		/*Edited by Amr - BugID_4720*/
-		if (wilc_wlan_cfg_commit(WILC_CFG_QUERY, drvHandler))
+		if (wilc_wlan_cfg_commit(WILC_CFG_QUERY, (tstrWILC_WFIDrv *)drvHandler))
 			ret_size = 0;   /* BugID_5213 */
 
 
-- 
1.9.1

