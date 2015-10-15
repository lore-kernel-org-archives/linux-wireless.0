Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33772 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964788AbbJOCIn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 22:08:43 -0400
Received: by pabrc13 with SMTP id rc13so71300796pab.0
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 19:08:43 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 33/33] staging: wilc1000: fix return type of hif_set_cfg
Date: Thu, 15 Oct 2015 11:07:02 +0900
Message-Id: <1444874822-31152-33-git-send-email-chaehyun.lim@gmail.com> (sfid-20151015_041156_117664_A7F09F1D)
In-Reply-To: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of hif_set_cfg from s32 to int. s32Error
gets return value from wilc_mq_send that has return type of int. It
should be changed return type of this function as well as data type of
s32Error.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c1125f8..7600359 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4068,11 +4068,11 @@ int host_int_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
 
 }
 
-s32 hif_set_cfg(struct host_if_drv *hif_drv,
+int hif_set_cfg(struct host_if_drv *hif_drv,
 		struct cfg_param_val *pstrCfgParamVal)
 {
 
-	s32 s32Error = 0;
+	int s32Error = 0;
 	struct host_if_msg msg;
 
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 7b229bb..ade9d2c 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -850,7 +850,7 @@ int host_int_scan(struct host_if_drv *hWFIDrv, u8 u8ScanSource,
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 hif_set_cfg(struct host_if_drv *hWFIDrv, struct cfg_param_val *pstrCfgParamVal);
+int hif_set_cfg(struct host_if_drv *hWFIDrv, struct cfg_param_val *pstrCfgParamVal);
 
 /**
  *  @brief              gets configuration wids values
-- 
2.6.1

