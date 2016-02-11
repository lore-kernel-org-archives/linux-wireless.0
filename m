Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35731 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbcBKEqj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Feb 2016 23:46:39 -0500
Received: by mail-pf0-f196.google.com with SMTP id w128so1378404pfb.2
        for <linux-wireless@vger.kernel.org>; Wed, 10 Feb 2016 20:46:38 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 2/4] staging: wilc1000: use int type for counter variable
Date: Thu, 11 Feb 2016 13:46:23 +0900
Message-Id: <1455165985-5509-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20160211_054641_676783_16C75002)
In-Reply-To: <1455165985-5509-1-git-send-email-chaehyun.lim@gmail.com>
References: <1455165985-5509-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

counter is used as for-loop control variable and indicating index of
struct wid array so that it is better to use int type.
There is no need to set to 0 when it is declared at the top of this
function. It is initialized as 0 in for-loop statement.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
v2: rebase latest staging-testing

 drivers/staging/wilc1000/wilc_wlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 2bc2970..f3140e0 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1352,7 +1352,7 @@ int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size)
 int wilc_send_config_pkt(struct wilc_vif *vif, u8 mode, struct wid *wids,
 			 u32 count, u32 drv)
 {
-	s32 counter = 0;
+	int counter;
 	int ret = 0;
 
 	if (mode == GET_CFG) {
-- 
2.7.1

