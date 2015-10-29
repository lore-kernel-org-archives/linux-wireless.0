Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36433 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbbJ2M3x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 08:29:53 -0400
Received: by pacfv9 with SMTP id fv9so41653753pac.3
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2015 05:29:53 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 05/12] staging: wilc1000: rename pu8MacAddr in host_int_del_station
Date: Thu, 29 Oct 2015 21:29:21 +0900
Message-Id: <1446121768-4953-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20151029_132956_542002_C3529C97)
In-Reply-To: <1446121768-4953-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446121768-4953-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes pu8MacAddr to mac_addr that is second argument of
this function to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index be5e652..8dba9a3 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4552,7 +4552,7 @@ s32 host_int_add_station(struct host_if_drv *hif_drv,
 	return result;
 }
 
-int host_int_del_station(struct host_if_drv *hif_drv, const u8 *pu8MacAddr)
+int host_int_del_station(struct host_if_drv *hif_drv, const u8 *mac_addr)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -4570,10 +4570,10 @@ int host_int_del_station(struct host_if_drv *hif_drv, const u8 *pu8MacAddr)
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
index 083def57..be9283f 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -979,7 +979,7 @@ s32 host_int_del_allstation(struct host_if_drv *hWFIDrv, u8 pu8MacAddr[][ETH_ALE
  *  @date		15 July 2012
  *  @version		1.0 Description
  */
-int host_int_del_station(struct host_if_drv *hif_drv, const u8 *pu8MacAddr);
+int host_int_del_station(struct host_if_drv *hif_drv, const u8 *mac_addr);
 
 /*!
  *  @fn		s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv,
-- 
2.6.1

