Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33688 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbbL3MQp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 07:16:45 -0500
Received: by mail-pa0-f45.google.com with SMTP id cy9so138012266pac.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2015 04:16:45 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 18/20] staging: wilc1000: remove argument hif_drv in host_int_get_ipaddress
Date: Wed, 30 Dec 2015 21:15:42 +0900
Message-Id: <1451477744-11975-18-git-send-email-chaehyun.lim@gmail.com> (sfid-20151230_132248_173647_2E437C72)
In-Reply-To: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes hif_drv argument of host_int_get_ipaddress.
There is no need to pass hif_drv in this function because hif_drv is a
member of vif. It is removed struct host_if_drv and use hif_drv of vif.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a203647..72115ae 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -362,16 +362,13 @@ static s32 handle_set_operation_mode(struct wilc_vif *vif,
 	return result;
 }
 
-static int host_int_get_ipaddress(struct wilc_vif *vif,
-				  struct host_if_drv *hif_drv,
-				  u8 *u16ipadd, u8 idx);
+static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *u16ipadd, u8 idx);
 
 static s32 handle_set_ip_address(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 {
 	s32 result = 0;
 	struct wid wid;
 	char firmware_ip_addr[4] = {0};
-	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (ip_addr[0] < 192)
 		ip_addr[0] = 0;
@@ -389,7 +386,7 @@ static s32 handle_set_ip_address(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
 
-	host_int_get_ipaddress(vif, hif_drv, firmware_ip_addr, idx);
+	host_int_get_ipaddress(vif, firmware_ip_addr, idx);
 
 	if (result) {
 		PRINT_ER("Failed to set IP address\n");
@@ -4664,12 +4661,11 @@ int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 	return result;
 }
 
-static int host_int_get_ipaddress(struct wilc_vif *vif,
-				  struct host_if_drv *hif_drv,
-				  u8 *u16ipadd, u8 idx)
+static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *u16ipadd, u8 idx)
 {
 	int result = 0;
 	struct host_if_msg msg;
+	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
-- 
2.6.4

