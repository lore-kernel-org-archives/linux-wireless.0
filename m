Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35363 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161036AbbKFKMH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 05:12:07 -0500
Received: by pasz6 with SMTP id z6so122962723pas.2
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2015 02:12:07 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 09/12] staging: wilc1000: rename pstrStaParams in host_int_add_station
Date: Fri,  6 Nov 2015 19:11:18 +0900
Message-Id: <1446804681-8873-9-git-send-email-chaehyun.lim@gmail.com> (sfid-20151106_111212_808432_2D8A3E1C)
In-Reply-To: <1446804681-8873-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446804681-8873-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pstrStaParams to sta_param to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: rebase latest staging-testing.

 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index dc5f45a..dcf77ed 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4527,7 +4527,7 @@ int host_int_del_beacon(struct host_if_drv *hif_drv)
 }
 
 int host_int_add_station(struct host_if_drv *hif_drv,
-			 struct add_sta_param *pstrStaParams)
+			 struct add_sta_param *sta_param)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -4545,14 +4545,14 @@ int host_int_add_station(struct host_if_drv *hif_drv,
 	msg.id = HOST_IF_MSG_ADD_STATION;
 	msg.drv = hif_drv;
 
-	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(struct add_sta_param));
+	memcpy(pstrAddStationMsg, sta_param, sizeof(struct add_sta_param));
 	if (pstrAddStationMsg->rates_len > 0) {
 		u8 *rates = kmalloc(pstrAddStationMsg->rates_len, GFP_KERNEL);
 
 		if (!rates)
 			return -ENOMEM;
 
-		memcpy(rates, pstrStaParams->rates,
+		memcpy(rates, sta_param->rates,
 		       pstrAddStationMsg->rates_len);
 		pstrAddStationMsg->rates = rates;
 	}
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 9788e6d..c16a9d9 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -379,7 +379,7 @@ s32 host_int_add_beacon(struct host_if_drv *hWFIDrv, u32 u32Interval,
 			u8 *pu8tail);
 int host_int_del_beacon(struct host_if_drv *hif_drv);
 int host_int_add_station(struct host_if_drv *hif_drv,
-			 struct add_sta_param *pstrStaParams);
+			 struct add_sta_param *sta_param);
 s32 host_int_del_allstation(struct host_if_drv *hWFIDrv,
 			    u8 pu8MacAddr[][ETH_ALEN]);
 int host_int_del_station(struct host_if_drv *hif_drv, const u8 *mac_addr);
-- 
2.6.3

