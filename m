Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3517 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbbJMKzX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:55:23 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 44/54] staging: wilc1000: rename au8Sta_DelAllSta of struct del_all_sta
Date: Tue, 13 Oct 2015 19:50:09 +0900
Message-ID: <1444733419-17679-44-git-send-email-tony.cho@atmel.com> (sfid-20151013_125526_953732_474B3563)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames au8Sta_DelAllSta of struct del_all_sta to del_all_sta to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 42081f8..5ee8d54 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -145,7 +145,7 @@ struct set_multicast {
 };
 
 struct del_all_sta {
-	u8 au8Sta_DelAllSta[MAX_NUM_STA][ETH_ALEN];
+	u8 del_all_sta[MAX_NUM_STA][ETH_ALEN];
 	u8 u8Num_AssocSta;
 };
 
@@ -2506,8 +2506,8 @@ static void Handle_DelAllSta(struct host_if_drv *hif_drv,
 	*(pu8CurrByte++) = pstrDelAllStaParam->u8Num_AssocSta;
 
 	for (i = 0; i < MAX_NUM_STA; i++) {
-		if (memcmp(pstrDelAllStaParam->au8Sta_DelAllSta[i], au8Zero_Buff, ETH_ALEN))
-			memcpy(pu8CurrByte, pstrDelAllStaParam->au8Sta_DelAllSta[i], ETH_ALEN);
+		if (memcmp(pstrDelAllStaParam->del_all_sta[i], au8Zero_Buff, ETH_ALEN))
+			memcpy(pu8CurrByte, pstrDelAllStaParam->del_all_sta[i], ETH_ALEN);
 		else
 			continue;
 
@@ -4793,9 +4793,14 @@ s32 host_int_del_allstation(struct host_if_drv *hif_drv,
 
 	for (i = 0; i < MAX_NUM_STA; i++) {
 		if (memcmp(pu8MacAddr[i], au8Zero_Buff, ETH_ALEN)) {
-			memcpy(pstrDelAllStationMsg->au8Sta_DelAllSta[i], pu8MacAddr[i], ETH_ALEN);
-			PRINT_D(CFG80211_DBG, "BSSID = %x%x%x%x%x%x\n", pstrDelAllStationMsg->au8Sta_DelAllSta[i][0], pstrDelAllStationMsg->au8Sta_DelAllSta[i][1], pstrDelAllStationMsg->au8Sta_DelAllSta[i][2], pstrDelAllStationMsg->au8Sta_DelAllSta[i][3], pstrDelAllStationMsg->au8Sta_DelAllSta[i][4],
-				pstrDelAllStationMsg->au8Sta_DelAllSta[i][5]);
+			memcpy(pstrDelAllStationMsg->del_all_sta[i], pu8MacAddr[i], ETH_ALEN);
+			PRINT_D(CFG80211_DBG, "BSSID = %x%x%x%x%x%x\n",
+				pstrDelAllStationMsg->del_all_sta[i][0],
+				pstrDelAllStationMsg->del_all_sta[i][1],
+				pstrDelAllStationMsg->del_all_sta[i][2],
+				pstrDelAllStationMsg->del_all_sta[i][3],
+				pstrDelAllStationMsg->del_all_sta[i][4],
+				pstrDelAllStationMsg->del_all_sta[i][5]);
 			u8AssocNumb++;
 		}
 	}
-- 
1.9.1

