Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33675 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbbJ2M3k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 08:29:40 -0400
Received: by padhy1 with SMTP id hy1so34062420pad.0
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2015 05:29:40 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 01/12] staging: wilc1000: fix return type of host_int_del_beacon
Date: Thu, 29 Oct 2015 21:29:17 +0900
Message-Id: <1446121768-4953-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20151029_132943_837928_879A0D44)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_del_beacon from s32 to int.
The result variable gets return value from wilc_mq_send that has return
type of int. It should be changed return type of this function as well
as data type of result variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index dbbe72c..b469962 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4495,9 +4495,9 @@ ERRORHANDLER:
 	return result;
 }
 
-s32 host_int_del_beacon(struct host_if_drv *hif_drv)
+int host_int_del_beacon(struct host_if_drv *hif_drv)
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_msg msg;
 
 	if (!hif_drv) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index b854db5..698a588 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -932,7 +932,7 @@ s32 host_int_add_beacon(struct host_if_drv *hWFIDrv, u32 u32Interval,
  *  @date		10 Julys 2012
  *  @version		1.0 Description
  */
-s32 host_int_del_beacon(struct host_if_drv *hWFIDrv);
+int host_int_del_beacon(struct host_if_drv *hWFIDrv);
 
 /*!
  *  @fn		s32 host_int_add_station(WILC_WFIDrvHandle hWFIDrv,
-- 
2.6.1

