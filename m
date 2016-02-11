Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36205 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbcBKEqm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Feb 2016 23:46:42 -0500
Received: by mail-pf0-f193.google.com with SMTP id e127so1962333pfe.3
        for <linux-wireless@vger.kernel.org>; Wed, 10 Feb 2016 20:46:42 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 3/4] staging: wilc1000: remove initialization code of counter variable
Date: Thu, 11 Feb 2016 13:46:24 +0900
Message-Id: <1455165985-5509-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20160211_054644_952540_E20A3A06)
In-Reply-To: <1455165985-5509-1-git-send-email-chaehyun.lim@gmail.com>
References: <1455165985-5509-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need to set to 0 for counter variable before entering next
for-loop statement because counter is initialized again in for-loop
statement, so just remove it.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
v2: rebase latest staging-testing

 drivers/staging/wilc1000/wilc_wlan.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index f3140e0..c6bfec3 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1365,7 +1365,6 @@ int wilc_send_config_pkt(struct wilc_vif *vif, u8 mode, struct wid *wids,
 				break;
 			}
 		}
-		counter = 0;
 		for (counter = 0; counter < count; counter++) {
 			wids[counter].size = wilc_wlan_cfg_get_val(
 					wids[counter].id,
-- 
2.7.1

