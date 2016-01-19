Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33203 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625AbcASK0e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2016 05:26:34 -0500
Received: by mail-pf0-f193.google.com with SMTP id e65so13023446pfe.0
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2016 02:26:33 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 3/3] staging: wilc1000: use int type for counter variable
Date: Tue, 19 Jan 2016 19:26:17 +0900
Message-Id: <1453199177-21085-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20160119_112637_390243_707D712B)
In-Reply-To: <1453199177-21085-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453199177-21085-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

counter is used as for-loop control variable and indicating index of
struct wid array so that it is better to use int type.
There is no need to set to 0 when it is declared at the top of this
function. counter is initialized as 0 in for-loop statement.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 86dfe77..7e8e423 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -591,7 +591,7 @@ s32 wilc_dealloc_assoc_resp_info(tstrConnectRespInfo *pstrConnectRespInfo)
 int wilc_send_config_pkt(struct wilc *wilc, u8 mode, struct wid *wids,
 			 u32 count, u32 drv)
 {
-	s32 counter = 0;
+	int counter;
 	int ret = 0;
 
 	if (mode == GET_CFG) {
-- 
2.6.4

