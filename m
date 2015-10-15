Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36568 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105AbbJOCHm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 22:07:42 -0400
Received: by pabws5 with SMTP id ws5so7337072pab.3
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 19:07:42 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 12/33] staging: wilc1000: fix return type of host_int_disconnect
Date: Thu, 15 Oct 2015 11:06:41 +0900
Message-Id: <1444874822-31152-12-git-send-email-chaehyun.lim@gmail.com> (sfid-20151015_041654_273604_D0FF857E)
In-Reply-To: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_disconnect from s32 to int.
s32Error gets return value from wilc_mq_send that has return type of
int. It should be changed return type of int as well as data type of
s32Error.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f966759..8cc0cfb 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3673,9 +3673,9 @@ int host_int_flush_join_req(struct host_if_drv *hif_drv)
 	return s32Error;
 }
 
-s32 host_int_disconnect(struct host_if_drv *hif_drv, u16 u16ReasonCode)
+int host_int_disconnect(struct host_if_drv *hif_drv, u16 u16ReasonCode)
 {
-	s32 s32Error = 0;
+	int s32Error = 0;
 	struct host_if_msg msg;
 
 	if (!hif_drv) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 2ed5945..4285b1b 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -694,7 +694,7 @@ int host_int_flush_join_req(struct host_if_drv *hWFIDrv);
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_disconnect(struct host_if_drv *hWFIDrv, u16 u16ReasonCode);
+int host_int_disconnect(struct host_if_drv *hWFIDrv, u16 u16ReasonCode);
 
 /**
  *  @brief              disconnects a sta
-- 
2.6.1

