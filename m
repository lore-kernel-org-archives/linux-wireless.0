Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36028 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161036AbbKFKLx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 05:11:53 -0500
Received: by pacdm15 with SMTP id dm15so94616161pac.3
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2015 02:11:53 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 05/12] staging: wilc1000: rename pu8MacAddr in host_int_del_station
Date: Fri,  6 Nov 2015 19:11:14 +0900
Message-Id: <1446804681-8873-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20151106_111157_477837_3416E154)
In-Reply-To: <1446804681-8873-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446804681-8873-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes pu8MacAddr to mac_addr that is second argument of
this function to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: rebase latest staging-testing.

 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index dd57454..8ec4972 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4563,7 +4563,7 @@ s32 host_int_add_station(struct host_if_drv *hif_drv,
 	return result;
 }
 
-int host_int_del_station(struct host_if_drv *hif_drv, const u8 *pu8MacAddr)
+int host_int_del_station(struct host_if_drv *hif_drv, const u8 *mac_addr)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -4581,10 +4581,10 @@ int host_int_del_station(struct host_if_drv *hif_drv, const u8 *pu8MacAddr)
 	msg.id = HOST_IF_MSG_DEL_STATION;
 	msg.drv = hif_drv;
 
-	if (!pu8MacAddr)
+	if (!mac_addr)
 		eth_broadcast_addr(pstrDelStationMsg->mac_addr);
 	else
-		memcpy(pstrDelStationMsg->mac_addr, pu8MacAddr, ETH_ALEN);
+		memcpy(pstrDelStationMsg->mac_addr, mac_addr, ETH_ALEN);
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 7ff52b4..11c4220 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -382,7 +382,7 @@ s32 host_int_add_station(struct host_if_drv *hWFIDrv,
 			 struct add_sta_param *pstrStaParams);
 s32 host_int_del_allstation(struct host_if_drv *hWFIDrv,
 			    u8 pu8MacAddr[][ETH_ALEN]);
-int host_int_del_station(struct host_if_drv *hif_drv, const u8 *pu8MacAddr);
+int host_int_del_station(struct host_if_drv *hif_drv, const u8 *mac_addr);
 s32 host_int_edit_station(struct host_if_drv *hWFIDrv,
 			  struct add_sta_param *pstrStaParams);
 s32 host_int_set_power_mgmt(struct host_if_drv *hWFIDrv,
-- 
2.6.3

