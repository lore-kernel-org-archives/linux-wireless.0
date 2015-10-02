Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:32768 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbbJBMp2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 08:45:28 -0400
Received: by pacex6 with SMTP id ex6so106326789pac.0
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2015 05:45:27 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 07/10] staging: wilc1000: fix return type of host_int_wait_msg_queue_idle
Date: Fri,  2 Oct 2015 21:44:53 +0900
Message-Id: <1443789896-7082-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20151002_144535_293766_BA608B0A)
In-Reply-To: <1443789896-7082-1-git-send-email-chaehyun.lim@gmail.com>
References: <1443789896-7082-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_wait_msg_queue_idle from s32
to int. s32Error gets return value from wilc_mq_send that has return
type of int. It should be changed return type of
host_int_wait_msg_queue_idle by int as well as data type of s32Error.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d23d2dd..e5b7689 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -5342,9 +5342,9 @@ int host_int_set_mac_chnl_num(tstrWILC_WFIDrv *wfi_drv, u8 channel)
 }
 
 
-s32 host_int_wait_msg_queue_idle(void)
+int host_int_wait_msg_queue_idle(void)
 {
-	s32 s32Error = 0;
+	int s32Error = 0;
 
 	struct host_if_msg msg;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index edcaf5a..bc8acde 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -648,7 +648,7 @@ s32 host_int_set_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress);
  *  @date		19 march 2014
  *  @version		1.0
  */
-s32 host_int_wait_msg_queue_idle(void);
+int host_int_wait_msg_queue_idle(void);
 
 /**
  *  @brief              sets a start scan request
-- 
2.6.0

