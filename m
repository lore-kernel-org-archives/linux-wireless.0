Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:33009 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757093AbcBWGiS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 01:38:18 -0500
Received: by mail-pf0-f170.google.com with SMTP id q63so106715553pfb.0
        for <linux-wireless@vger.kernel.org>; Mon, 22 Feb 2016 22:38:18 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 3/7] staging: wilc1000: handle_cfg_param: change data type of wid_cnt
Date: Tue, 23 Feb 2016 15:37:59 +0900
Message-Id: <1456209483-20345-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20160223_073822_075064_8FC12881)
In-Reply-To: <1456209483-20345-1-git-send-email-chaehyun.lim@gmail.com>
References: <1456209483-20345-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes data type of wid_cnt from u8 to int.
This variable uses array index of struct wid_list so that it is better
to use int type.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c97df27..382f946 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -473,7 +473,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 	s32 result = 0;
 	struct wid wid_list[32];
 	struct host_if_drv *hif_drv = vif->hif_drv;
-	u8 wid_cnt = 0;
+	int wid_cnt = 0;
 
 	down(&hif_drv->sem_cfg_values);
 
-- 
2.7.1

