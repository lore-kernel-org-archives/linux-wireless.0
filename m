Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36616 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbcACIhQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 03:37:16 -0500
Received: by mail-pa0-f51.google.com with SMTP id yy13so89273139pab.3
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2016 00:37:16 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 20/30] staging: wilc1000: rename au8Zero_Buff in wilc_del_allstation
Date: Sun,  3 Jan 2016 17:35:52 +0900
Message-Id: <1451810162-16993-20-git-send-email-chaehyun.lim@gmail.com> (sfid-20160103_095249_842885_59E71F93)
In-Reply-To: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames au8Zero_Buff to zero_addr to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 7686a52..a3f120a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4305,7 +4305,7 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN])
 	struct host_if_msg msg;
 	struct del_all_sta *del_all_sta_info = &msg.body.del_all_sta_info;
 	struct host_if_drv *hif_drv = vif->hif_drv;
-	u8 au8Zero_Buff[ETH_ALEN] = {0};
+	u8 zero_addr[ETH_ALEN] = {0};
 	u32 i;
 	u8 u8AssocNumb = 0;
 
@@ -4322,7 +4322,7 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN])
 	msg.vif = vif;
 
 	for (i = 0; i < MAX_NUM_STA; i++) {
-		if (memcmp(mac_addr[i], au8Zero_Buff, ETH_ALEN)) {
+		if (memcmp(mac_addr[i], zero_addr, ETH_ALEN)) {
 			memcpy(del_all_sta_info->del_all_sta[i], mac_addr[i], ETH_ALEN);
 			PRINT_D(CFG80211_DBG, "BSSID = %x%x%x%x%x%x\n",
 				del_all_sta_info->del_all_sta[i][0],
-- 
2.6.4

