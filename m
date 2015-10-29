Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:34483 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758022AbbJ2XSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 19:18:10 -0400
Received: by padda3 with SMTP id da3so5888686pad.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2015 16:18:09 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 06/12] staging: wilc1000: rename pstrDelStationMsg in host_int_del_station
Date: Fri, 30 Oct 2015 08:17:42 +0900
Message-Id: <1446160668-10747-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20151030_001828_582873_7757E128)
In-Reply-To: <1446160668-10747-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446160668-10747-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pstrDelStationMsg to del_sta_info to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: resend because 11/12 patch is changed.

 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8dba9a3..fe4ccdb 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4556,7 +4556,7 @@ int host_int_del_station(struct host_if_drv *hif_drv, const u8 *mac_addr)
 {
 	int result = 0;
 	struct host_if_msg msg;
-	struct del_sta *pstrDelStationMsg = &msg.body.del_sta_info;
+	struct del_sta *del_sta_info = &msg.body.del_sta_info;
 
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
@@ -4571,9 +4571,9 @@ int host_int_del_station(struct host_if_drv *hif_drv, const u8 *mac_addr)
 	msg.drv = hif_drv;
 
 	if (!mac_addr)
-		eth_broadcast_addr(pstrDelStationMsg->mac_addr);
+		eth_broadcast_addr(del_sta_info->mac_addr);
 	else
-		memcpy(pstrDelStationMsg->mac_addr, mac_addr, ETH_ALEN);
+		memcpy(del_sta_info->mac_addr, mac_addr, ETH_ALEN);
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
-- 
2.6.1

