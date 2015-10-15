Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:6339 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131AbbJOE2Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 00:28:16 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 25/40] staging: wilc1000: rename variable gu32InactiveTime
Date: Thu, 15 Oct 2015 13:25:06 +0900
Message-ID: <1444883121-31757-25-git-send-email-tony.cho@atmel.com> (sfid-20151015_064658_862785_6EE8C990)
In-Reply-To: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
References: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames variable gu32InactiveTime to inactive_time
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index cf21ee20..6f4158f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -258,7 +258,7 @@ static s8 link_speed;
 static u8 ch_no;
 static u8 set_ip[2][4];
 static u8 get_ip[2][4];
-static u32 gu32InactiveTime;
+static u32 inactive_time;
 static u8 gu8DelBcn;
 static u32 gu32WidConnRstHack;
 
@@ -2287,7 +2287,7 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
 
 	strWID.id = (u16)WID_GET_INACTIVE_TIME;
 	strWID.type = WID_INT;
-	strWID.val = (s8 *)&gu32InactiveTime;
+	strWID.val = (s8 *)&inactive_time;
 	strWID.size = sizeof(u32);
 
 
@@ -2299,8 +2299,7 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
 		return -EFAULT;
 	}
 
-
-	PRINT_D(CFG80211_DBG, "Getting inactive time : %d\n", gu32InactiveTime);
+	PRINT_D(CFG80211_DBG, "Getting inactive time : %d\n", inactive_time);
 
 	up(&hif_drv->hSemInactiveTime);
 
@@ -3885,7 +3884,7 @@ s32 host_int_get_inactive_time(struct host_if_drv *hif_drv,
 
 	down(&hif_drv->hSemInactiveTime);
 
-	*pu32InactiveTime = gu32InactiveTime;
+	*pu32InactiveTime = inactive_time;
 
 	return s32Error;
 }
-- 
1.9.1

