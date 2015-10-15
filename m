Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33871 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932864AbbJOCIR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 22:08:17 -0400
Received: by payp3 with SMTP id p3so23400186pay.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 19:08:17 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 24/33] staging: wilc1000: fix return type of host_int_setup_multicast_filter
Date: Thu, 15 Oct 2015 11:06:53 +0900
Message-Id: <1444874822-31152-24-git-send-email-chaehyun.lim@gmail.com> (sfid-20151015_041248_543876_C75673C1)
In-Reply-To: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_setup_multicast_filter from
s32 to int. s32Error gets return value from wilc_mq_send that has return
type of int. It should be changed return type of this function as well
as data type of s32Error.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 237fad1..9cb6d7f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4879,11 +4879,11 @@ s32 host_int_set_power_mgmt(struct host_if_drv *hif_drv,
 	return s32Error;
 }
 
-s32 host_int_setup_multicast_filter(struct host_if_drv *hif_drv,
+int host_int_setup_multicast_filter(struct host_if_drv *hif_drv,
 				    bool bIsEnabled,
 				    u32 u32count)
 {
-	s32 s32Error = 0;
+	int s32Error = 0;
 	struct host_if_msg msg;
 	struct set_multicast *pstrMulticastFilterParam = &msg.body.multicast_info;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 6167295..6e8f533 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -1058,7 +1058,7 @@ s32 host_int_set_power_mgmt(struct host_if_drv *hWFIDrv, bool bIsEnabled, u32 u3
  *  @date		24 November 2012
  *  @version		1.0 Description
  */
-s32 host_int_setup_multicast_filter(struct host_if_drv *hWFIDrv, bool bIsEnabled, u32 u32count);
+int host_int_setup_multicast_filter(struct host_if_drv *hWFIDrv, bool bIsEnabled, u32 u32count);
 /**
  *  @brief           host_int_setup_ipaddress
  *  @details       set IP address on firmware
-- 
2.6.1

