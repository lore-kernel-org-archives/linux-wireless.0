Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34193 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742AbbL3MQv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 07:16:51 -0500
Received: by mail-pa0-f45.google.com with SMTP id uo6so116326542pac.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2015 04:16:51 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 20/20] staging: wilc1000: move static declaration of host_int_get_ipaddress
Date: Wed, 30 Dec 2015 21:15:44 +0900
Message-Id: <1451477744-11975-20-git-send-email-chaehyun.lim@gmail.com> (sfid-20151230_132247_159341_B15EF4D4)
In-Reply-To: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves static function declaration to front part of
host_interface.c file.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c8b4b32..5a97a9d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -263,6 +263,7 @@ static struct wilc_vif *join_req_vif;
 #define FLUSHED_BYTE_POS 79
 
 static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo);
+static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
 
 /* The u8IfIdx starts from 0 to NUM_CONCURRENT_IFC -1, but 0 index used as
  * special purpose in wilc device, so we add 1 to the index to starts from 1.
@@ -362,8 +363,6 @@ static s32 handle_set_operation_mode(struct wilc_vif *vif,
 	return result;
 }
 
-static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
-
 static s32 handle_set_ip_address(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 {
 	s32 result = 0;
-- 
2.6.4

