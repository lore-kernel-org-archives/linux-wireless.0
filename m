Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34233 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932968AbbJOCIh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 22:08:37 -0400
Received: by payp3 with SMTP id p3so23408625pay.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 19:08:37 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 31/33] staging: wilc1000: fix return type of host_int_add_beacon
Date: Thu, 15 Oct 2015 11:07:00 +0900
Message-Id: <1444874822-31152-31-git-send-email-chaehyun.lim@gmail.com> (sfid-20151015_040851_554520_9B4C2FE2)
In-Reply-To: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444874822-31152-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_add_beacon from s32 to int.
s32Error gets return value from wilc_mq_send that has return type of
int. It should be changed return type of this function as well as data
type of s32Error.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f9e1b98..f419ce7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4611,11 +4611,11 @@ int host_int_frame_register(struct host_if_drv *hif_drv, u16 u16FrameType, bool
 
 }
 
-s32 host_int_add_beacon(struct host_if_drv *hif_drv, u32 u32Interval,
+int host_int_add_beacon(struct host_if_drv *hif_drv, u32 u32Interval,
 			u32 u32DTIMPeriod, u32 u32HeadLen, u8 *pu8Head,
 			u32 u32TailLen, u8 *pu8Tail)
 {
-	s32 s32Error = 0;
+	int s32Error = 0;
 	struct host_if_msg msg;
 	struct beacon_attr *pstrSetBeaconParam = &msg.body.beacon_info;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 5d63a61..42458c9 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -947,7 +947,7 @@ s32 host_int_deinit(struct host_if_drv *hWFIDrv);
  *  @version		1.0 Description
  *
  */
-s32 host_int_add_beacon(struct host_if_drv *hWFIDrv, u32 u32Interval,
+int host_int_add_beacon(struct host_if_drv *hWFIDrv, u32 u32Interval,
 				u32 u32DTIMPeriod,
 				u32 u32HeadLen, u8 *pu8Head,
 				u32 u32TailLen, u8 *pu8tail);
-- 
2.6.1

