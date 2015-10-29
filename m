Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33885 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbbJ2MaA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 08:30:00 -0400
Received: by padhk11 with SMTP id hk11so40056839pad.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2015 05:30:00 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 07/12] staging: wilc1000: fix return type of host_int_add_station
Date: Thu, 29 Oct 2015 21:29:23 +0900
Message-Id: <1446121768-4953-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20151029_133004_665214_A23E663C)
In-Reply-To: <1446121768-4953-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446121768-4953-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_add_station from s32 to int.
The result variable gets return value from wilc_mq_send that has return
type of int. It should be changed return type of this function as well
as data type of result variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index fe4ccdb..0f36825 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4516,10 +4516,10 @@ int host_int_del_beacon(struct host_if_drv *hif_drv)
 	return result;
 }
 
-s32 host_int_add_station(struct host_if_drv *hif_drv,
+int host_int_add_station(struct host_if_drv *hif_drv,
 			 struct add_sta_param *pstrStaParams)
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_msg msg;
 	struct add_sta_param *pstrAddStationMsg = &msg.body.add_sta_info;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index be9283f..3fcff7a 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -948,7 +948,7 @@ int host_int_del_beacon(struct host_if_drv *hif_drv);
  *  @date		12 July 2012
  *  @version		1.0 Description
  */
-s32 host_int_add_station(struct host_if_drv *hWFIDrv,
+int host_int_add_station(struct host_if_drv *hWFIDrv,
 			 struct add_sta_param *pstrStaParams);
 
 /*!
-- 
2.6.1

