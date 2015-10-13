Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:4773 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbbJMLCr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 07:02:47 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 49/54] staging: wilc1000: rename bIsEnabled of struct power_mgmt_param
Date: Tue, 13 Oct 2015 20:02:07 +0900
Message-ID: <1444734132-17858-4-git-send-email-tony.cho@atmel.com> (sfid-20151013_130249_798200_F5A6634C)
In-Reply-To: <1444734132-17858-1-git-send-email-tony.cho@atmel.com>
References: <1444734132-17858-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames bIsEnabled of struct power_mgmt_param to enabled to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4f7ebdc..0c44fd0 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -154,8 +154,7 @@ struct del_sta {
 };
 
 struct power_mgmt_param {
-
-	bool bIsEnabled;
+	bool enabled;
 	u32 u32Timeout;
 };
 
@@ -2763,7 +2762,7 @@ static void Handle_PowerManagement(struct host_if_drv *hif_drv,
 
 	strWID.id = (u16)WID_POWER_MANAGEMENT;
 
-	if (strPowerMgmtParam->bIsEnabled == true)
+	if (strPowerMgmtParam->enabled == true)
 		s8PowerMode = MIN_FAST_PS;
 	else
 		s8PowerMode = NO_POWERSAVE;
@@ -4881,7 +4880,7 @@ s32 host_int_set_power_mgmt(struct host_if_drv *hif_drv,
 	msg.id = HOST_IF_MSG_POWER_MGMT;
 	msg.drv = hif_drv;
 
-	pstrPowerMgmtParam->bIsEnabled = bIsEnabled;
+	pstrPowerMgmtParam->enabled = bIsEnabled;
 	pstrPowerMgmtParam->u32Timeout = u32Timeout;
 
 
-- 
1.9.1

