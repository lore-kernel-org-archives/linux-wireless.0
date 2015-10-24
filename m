Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f196.google.com ([209.85.212.196]:32838 "EHLO
	mail-wi0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbbJXWcK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Oct 2015 18:32:10 -0400
From: Punit Vara <punitvara@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, Punit Vara <punitvara@gmail.com>
Subject: [PATCH 3/3] Staging: wilc1000: Remove boolean comparision
Date: Sun, 25 Oct 2015 04:01:25 +0530
Message-Id: <1445725885-25995-4-git-send-email-punitvara@gmail.com> (sfid-20151025_003232_863274_0BA82A15)
In-Reply-To: <1445725885-25995-1-git-send-email-punitvara@gmail.com>
References: <1445725885-25995-1-git-send-email-punitvara@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is to the host_interface.c file that fixes up following
warning reported by coccicheck:

WARNING: Comparison to bool

Boolean tests do not need explicit comparison to true or false

Signed-off-by: Punit Vara <punitvara@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 38fead4..09a6c98 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1440,7 +1440,7 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 			}
 		}
 
-		if (bNewNtwrkFound == true) {
+		if (bNewNtwrkFound) {
 			PRINT_D(HOSTINF_DBG, "New network found\n");
 
 			if (hif_drv->strWILC_UsrScanReq.u32RcvdChCount < MAX_NUM_SCANNED_NETWORKS) {
@@ -2714,7 +2714,7 @@ static void Handle_PowerManagement(struct host_if_drv *hif_drv,
 
 	strWID.id = (u16)WID_POWER_MANAGEMENT;
 
-	if (strPowerMgmtParam->enabled == true)
+	if (strPowerMgmtParam->enabled)
 		s8PowerMode = MIN_FAST_PS;
 	else
 		s8PowerMode = NO_POWERSAVE;
-- 
2.5.3

