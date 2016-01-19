Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:36863 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625AbcASK0a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2016 05:26:30 -0500
Received: by mail-pa0-f67.google.com with SMTP id a20so28698419pag.3
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2016 02:26:30 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/3] staging: wilc1000: remove redundant initialization for counter variable
Date: Tue, 19 Jan 2016 19:26:16 +0900
Message-Id: <1453199177-21085-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20160119_112633_548839_182AF997)
In-Reply-To: <1453199177-21085-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453199177-21085-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need to set counter variable to 0 because it is initialized
in next for-loop statement. So, just delete it.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index ee9f91f..86dfe77 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -607,7 +607,6 @@ int wilc_send_config_pkt(struct wilc *wilc, u8 mode, struct wid *wids,
 				break;
 			}
 		}
-		counter = 0;
 		for (counter = 0; counter < count; counter++) {
 			wids[counter].size = wilc_wlan_cfg_get_val(
 					wids[counter].id,
-- 
2.6.4

