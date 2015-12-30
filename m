Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33670 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbbL3MQm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 07:16:42 -0500
Received: by mail-pa0-f48.google.com with SMTP id cy9so138011760pac.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2015 04:16:41 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 17/20] staging: wilc1000: fix return type of host_int_get_ipaddress
Date: Wed, 30 Dec 2015 21:15:41 +0900
Message-Id: <1451477744-11975-17-git-send-email-chaehyun.lim@gmail.com> (sfid-20151230_132247_448434_E821B6CC)
In-Reply-To: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_get_ipaddress from s32 to
int. The result variable gets return value from wilc_mq_send that has
data type of int. It should be changed return type of this function as
well as data type of result variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 90fdbdd..a203647 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -362,7 +362,7 @@ static s32 handle_set_operation_mode(struct wilc_vif *vif,
 	return result;
 }
 
-static s32 host_int_get_ipaddress(struct wilc_vif *vif,
+static int host_int_get_ipaddress(struct wilc_vif *vif,
 				  struct host_if_drv *hif_drv,
 				  u8 *u16ipadd, u8 idx);
 
@@ -4664,11 +4664,11 @@ int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 	return result;
 }
 
-static s32 host_int_get_ipaddress(struct wilc_vif *vif,
+static int host_int_get_ipaddress(struct wilc_vif *vif,
 				  struct host_if_drv *hif_drv,
 				  u8 *u16ipadd, u8 idx)
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_msg msg;
 
 	if (!hif_drv) {
-- 
2.6.4

