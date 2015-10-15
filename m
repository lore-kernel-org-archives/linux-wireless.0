Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36642 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964788AbbJOCIk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 22:08:40 -0400
Received: by pabws5 with SMTP id ws5so7362956pab.3
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 19:08:40 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 32/33] staging: wilc1000: fix return type of host_int_scan
Date: Thu, 15 Oct 2015 11:07:01 +0900
Message-Id: <1444874822-31152-32-git-send-email-chaehyun.lim@gmail.com> (sfid-20151015_040846_752748_FFE7EC55)
In-Reply-To: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_scan from s32 to int.
s32Error gets return value from wilc_mq_send that has return type of
int. It should be changed return type of this function as well as data
type of s32Error.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f419ce7..c1125f8 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4012,13 +4012,13 @@ int host_int_get_statistics(struct host_if_drv *hif_drv, struct rf_info *pstrSta
 	return s32Error;
 }
 
-s32 host_int_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
+int host_int_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
 		  u8 u8ScanType, u8 *pu8ChnlFreqList,
 		  u8 u8ChnlListLen, const u8 *pu8IEs,
 		  size_t IEsLen, wilc_scan_result ScanResult,
 		  void *pvUserArg, struct hidden_network *pstrHiddenNetwork)
 {
-	s32 s32Error = 0;
+	int s32Error = 0;
 	struct host_if_msg msg;
 	enum scan_conn_timer enuScanConnTimer;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 42458c9..7b229bb 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -833,7 +833,7 @@ int host_int_get_link_speed(struct host_if_drv *hWFIDrv, s8 *ps8lnkspd);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_scan(struct host_if_drv *hWFIDrv, u8 u8ScanSource,
+int host_int_scan(struct host_if_drv *hWFIDrv, u8 u8ScanSource,
 			  u8 u8ScanType, u8 *pu8ChnlFreqList,
 			  u8 u8ChnlListLen, const u8 *pu8IEs,
 			  size_t IEsLen, wilc_scan_result ScanResult,
-- 
2.6.1

