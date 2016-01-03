Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:35168 "EHLO
	mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbcACIhN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 03:37:13 -0500
Received: by mail-pf0-f180.google.com with SMTP id 78so187624532pfw.2
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2016 00:37:13 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 19/30] staging: wilc1000: rename pstrDelAllStationMsg in wilc_del_allstation
Date: Sun,  3 Jan 2016 17:35:51 +0900
Message-Id: <1451810162-16993-19-git-send-email-chaehyun.lim@gmail.com> (sfid-20160103_095250_067017_EA1643F4)
In-Reply-To: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pstrDelAllStationMsg to del_all_sta_info to avoid
camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 37a78a3..7686a52 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4303,7 +4303,7 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN])
 {
 	int result = 0;
 	struct host_if_msg msg;
-	struct del_all_sta *pstrDelAllStationMsg = &msg.body.del_all_sta_info;
+	struct del_all_sta *del_all_sta_info = &msg.body.del_all_sta_info;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 	u8 au8Zero_Buff[ETH_ALEN] = {0};
 	u32 i;
@@ -4323,14 +4323,14 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN])
 
 	for (i = 0; i < MAX_NUM_STA; i++) {
 		if (memcmp(mac_addr[i], au8Zero_Buff, ETH_ALEN)) {
-			memcpy(pstrDelAllStationMsg->del_all_sta[i], mac_addr[i], ETH_ALEN);
+			memcpy(del_all_sta_info->del_all_sta[i], mac_addr[i], ETH_ALEN);
 			PRINT_D(CFG80211_DBG, "BSSID = %x%x%x%x%x%x\n",
-				pstrDelAllStationMsg->del_all_sta[i][0],
-				pstrDelAllStationMsg->del_all_sta[i][1],
-				pstrDelAllStationMsg->del_all_sta[i][2],
-				pstrDelAllStationMsg->del_all_sta[i][3],
-				pstrDelAllStationMsg->del_all_sta[i][4],
-				pstrDelAllStationMsg->del_all_sta[i][5]);
+				del_all_sta_info->del_all_sta[i][0],
+				del_all_sta_info->del_all_sta[i][1],
+				del_all_sta_info->del_all_sta[i][2],
+				del_all_sta_info->del_all_sta[i][3],
+				del_all_sta_info->del_all_sta[i][4],
+				del_all_sta_info->del_all_sta[i][5]);
 			u8AssocNumb++;
 		}
 	}
@@ -4339,7 +4339,7 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN])
 		return result;
 	}
 
-	pstrDelAllStationMsg->assoc_sta = u8AssocNumb;
+	del_all_sta_info->assoc_sta = u8AssocNumb;
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 
 	if (result)
-- 
2.6.4

