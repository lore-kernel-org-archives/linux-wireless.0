Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36460 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbbJOCHg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 22:07:36 -0400
Received: by pabws5 with SMTP id ws5so7334498pab.3
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 19:07:36 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 10/33] staging: wilc1000: fix return type of host_int_set_join_req
Date: Thu, 15 Oct 2015 11:06:39 +0900
Message-Id: <1444874822-31152-10-git-send-email-chaehyun.lim@gmail.com> (sfid-20151015_040740_439294_CC0FFE6B)
In-Reply-To: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_set_join_req from s32 to int.
s32Error gets return value from wilc_mq_send that has return type of
int. It should be changed return type by int as well as data type of
s32Error.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6246a12..c19c474 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3575,14 +3575,14 @@ s32 host_int_get_start_scan_req(struct host_if_drv *hif_drv, u8 *pu8ScanSource)
 	return 0;
 }
 
-s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
+int host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 			  const u8 *pu8ssid, size_t ssidLen,
 			  const u8 *pu8IEs, size_t IEsLen,
 			  wilc_connect_result pfConnectResult, void *pvUserArg,
 			  u8 u8security, enum AUTHTYPE tenuAuth_type,
 			  u8 u8channel, void *pJoinParams)
 {
-	s32 s32Error = 0;
+	int s32Error = 0;
 	struct host_if_msg msg;
 	enum scan_conn_timer enuScanConnTimer;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index d2ddc4b..c173503 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -660,7 +660,7 @@ s32 host_int_get_start_scan_req(struct host_if_drv *hWFIDrv, u8 *pu8ScanSource);
  *  @version		1.0
  */
 
-s32 host_int_set_join_req(struct host_if_drv *hWFIDrv, u8 *pu8bssid,
+int host_int_set_join_req(struct host_if_drv *hWFIDrv, u8 *pu8bssid,
 				  const u8 *pu8ssid, size_t ssidLen,
 				  const u8 *pu8IEs, size_t IEsLen,
 				  wilc_connect_result pfConnectResult, void *pvUserArg,
-- 
2.6.1

