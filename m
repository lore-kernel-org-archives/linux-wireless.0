Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36082 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161036AbbKFKL4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 05:11:56 -0500
Received: by pacdm15 with SMTP id dm15so94617669pac.3
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2015 02:11:56 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 06/12] staging: wilc1000: rename pstrDelStationMsg in host_int_del_station
Date: Fri,  6 Nov 2015 19:11:15 +0900
Message-Id: <1446804681-8873-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20151106_111200_520374_4955BD91)
In-Reply-To: <1446804681-8873-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446804681-8873-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pstrDelStationMsg to del_sta_info to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: rebase latest staging-testing.

 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8ec4972..2b6f620 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4567,7 +4567,7 @@ int host_int_del_station(struct host_if_drv *hif_drv, const u8 *mac_addr)
 {
 	int result = 0;
 	struct host_if_msg msg;
-	struct del_sta *pstrDelStationMsg = &msg.body.del_sta_info;
+	struct del_sta *del_sta_info = &msg.body.del_sta_info;
 
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
@@ -4582,9 +4582,9 @@ int host_int_del_station(struct host_if_drv *hif_drv, const u8 *mac_addr)
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
2.6.3

