Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35299 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbcACIhW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 03:37:22 -0500
Received: by mail-pa0-f48.google.com with SMTP id do7so1066290pab.2
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2016 00:37:22 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 22/30] staging: wilc1000: rename u8AssocNumb in wilc_del_allstation
Date: Sun,  3 Jan 2016 17:35:54 +0900
Message-Id: <1451810162-16993-22-git-send-email-chaehyun.lim@gmail.com> (sfid-20160103_095248_117928_57003F3B)
In-Reply-To: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u8AssocNumb to assoc_sta to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c0f30a2..0ff500d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4307,7 +4307,7 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN])
 	struct host_if_drv *hif_drv = vif->hif_drv;
 	u8 zero_addr[ETH_ALEN] = {0};
 	int i;
-	u8 u8AssocNumb = 0;
+	u8 assoc_sta = 0;
 
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
@@ -4331,15 +4331,15 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN])
 				del_all_sta_info->del_all_sta[i][3],
 				del_all_sta_info->del_all_sta[i][4],
 				del_all_sta_info->del_all_sta[i][5]);
-			u8AssocNumb++;
+			assoc_sta++;
 		}
 	}
-	if (!u8AssocNumb) {
+	if (!assoc_sta) {
 		PRINT_D(CFG80211_DBG, "NO ASSOCIATED STAS\n");
 		return result;
 	}
 
-	del_all_sta_info->assoc_sta = u8AssocNumb;
+	del_all_sta_info->assoc_sta = assoc_sta;
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 
 	if (result)
-- 
2.6.4

