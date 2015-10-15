Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33514 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932956AbbJOCI3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 22:08:29 -0400
Received: by pabrc13 with SMTP id rc13so71294595pab.0
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 19:08:28 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 28/33] staging: wilc1000: fix return type of host_int_del_station
Date: Thu, 15 Oct 2015 11:06:57 +0900
Message-Id: <1444874822-31152-28-git-send-email-chaehyun.lim@gmail.com> (sfid-20151015_041159_045910_4BDA51C1)
In-Reply-To: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_del_station from s32 to int.
s32Error gets return value from wilc_mq_send that has return type of
int. It should be changed return type of this function as well as data
type of s32Error.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 60c9fb9..3666495 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4728,9 +4728,9 @@ s32 host_int_add_station(struct host_if_drv *hif_drv,
 	return s32Error;
 }
 
-s32 host_int_del_station(struct host_if_drv *hif_drv, const u8 *pu8MacAddr)
+int host_int_del_station(struct host_if_drv *hif_drv, const u8 *pu8MacAddr)
 {
-	s32 s32Error = 0;
+	int s32Error = 0;
 	struct host_if_msg msg;
 	struct del_sta *pstrDelStationMsg = &msg.body.del_sta_info;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 2452faa4..d3f01ef 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -1012,7 +1012,7 @@ int host_int_del_allstation(struct host_if_drv *hWFIDrv, u8 pu8MacAddr[][ETH_ALE
  *  @date		15 July 2012
  *  @version		1.0 Description
  */
-s32 host_int_del_station(struct host_if_drv *hWFIDrv, const u8 *pu8MacAddr);
+int host_int_del_station(struct host_if_drv *hWFIDrv, const u8 *pu8MacAddr);
 
 /*!
  *  @fn		s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv,
-- 
2.6.1

