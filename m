Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33984 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965336AbbJ2XST (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 19:18:19 -0400
Received: by padhk11 with SMTP id hk11so53972553pad.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2015 16:18:19 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 09/12] staging: wilc1000: rename pstrStaParams in host_int_add_station
Date: Fri, 30 Oct 2015 08:17:45 +0900
Message-Id: <1446160668-10747-9-git-send-email-chaehyun.lim@gmail.com> (sfid-20151030_001834_398032_3E9A5CC7)
In-Reply-To: <1446160668-10747-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446160668-10747-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pstrStaParams to sta_param to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: resend because 11/12 patch is changed.

 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0f36825..57287d4 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4517,7 +4517,7 @@ int host_int_del_beacon(struct host_if_drv *hif_drv)
 }
 
 int host_int_add_station(struct host_if_drv *hif_drv,
-			 struct add_sta_param *pstrStaParams)
+			 struct add_sta_param *sta_param)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -4535,14 +4535,14 @@ int host_int_add_station(struct host_if_drv *hif_drv,
 	msg.id = HOST_IF_MSG_ADD_STATION;
 	msg.drv = hif_drv;
 
-	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(struct add_sta_param));
+	memcpy(pstrAddStationMsg, sta_param, sizeof(struct add_sta_param));
 	if (pstrAddStationMsg->u8NumRates > 0) {
 		u8 *rates = kmalloc(pstrAddStationMsg->u8NumRates, GFP_KERNEL);
 
 		if (!rates)
 			return -ENOMEM;
 
-		memcpy(rates, pstrStaParams->pu8Rates, pstrAddStationMsg->u8NumRates);
+		memcpy(rates, sta_param->pu8Rates, pstrAddStationMsg->u8NumRates);
 		pstrAddStationMsg->pu8Rates = rates;
 	}
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 7c9c4c6..aa92762 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -949,7 +949,7 @@ int host_int_del_beacon(struct host_if_drv *hif_drv);
  *  @version		1.0 Description
  */
 int host_int_add_station(struct host_if_drv *hif_drv,
-			 struct add_sta_param *pstrStaParams);
+			 struct add_sta_param *sta_param);
 
 /*!
  *  @fn		s32 host_int_del_allstation(WILC_WFIDrvHandle hWFIDrv, const u8* pu8MacAddr)
-- 
2.6.1

