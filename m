Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36628 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbcACIhT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 03:37:19 -0500
Received: by mail-pa0-f44.google.com with SMTP id yy13so89273464pab.3
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2016 00:37:19 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 21/30] staging: wilc1000: use int instead of u32
Date: Sun,  3 Jan 2016 17:35:53 +0900
Message-Id: <1451810162-16993-21-git-send-email-chaehyun.lim@gmail.com> (sfid-20160103_095249_112213_96DDB0C2)
In-Reply-To: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The variable i is used as array index so that it is better to use data
type of int.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a3f120a..c0f30a2 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4306,7 +4306,7 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN])
 	struct del_all_sta *del_all_sta_info = &msg.body.del_all_sta_info;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 	u8 zero_addr[ETH_ALEN] = {0};
-	u32 i;
+	int i;
 	u8 u8AssocNumb = 0;
 
 	if (!hif_drv) {
-- 
2.6.4

