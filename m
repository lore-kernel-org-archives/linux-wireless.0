Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:34153 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735AbbL3MQs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 07:16:48 -0500
Received: by mail-pf0-f175.google.com with SMTP id e65so88863118pfe.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2015 04:16:48 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 19/20] staging: wilc1000: rename u16ipadd in host_int_get_ipaddress
Date: Wed, 30 Dec 2015 21:15:43 +0900
Message-Id: <1451477744-11975-19-git-send-email-chaehyun.lim@gmail.com> (sfid-20151230_132247_919472_C63DA23F)
In-Reply-To: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u16ipadd to ip_addr to remove u16 prefix.
There is no need to use this prefix to show data type of this argument.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 72115ae..c8b4b32 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -362,7 +362,7 @@ static s32 handle_set_operation_mode(struct wilc_vif *vif,
 	return result;
 }
 
-static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *u16ipadd, u8 idx);
+static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
 
 static s32 handle_set_ip_address(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 {
@@ -4661,7 +4661,7 @@ int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 	return result;
 }
 
-static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *u16ipadd, u8 idx)
+static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -4676,7 +4676,7 @@ static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *u16ipadd, u8 idx)
 
 	msg.id = HOST_IF_MSG_GET_IPADDRESS;
 
-	msg.body.ip_info.ip_addr = u16ipadd;
+	msg.body.ip_info.ip_addr = ip_addr;
 	msg.vif = vif;
 	msg.body.ip_info.idx = idx;
 
-- 
2.6.4

