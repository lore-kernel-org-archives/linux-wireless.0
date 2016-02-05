Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:36705 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbcBEBfz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 20:35:55 -0500
Received: by mail-pf0-f175.google.com with SMTP id n128so59015860pfn.3
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2016 17:35:55 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 7/8] staging: wilc1000: remove initialization code of counter variable
Date: Fri,  5 Feb 2016 10:35:17 +0900
Message-Id: <1454636118-9943-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20160205_023600_310530_EF22DE3B)
In-Reply-To: <1454636118-9943-1-git-send-email-chaehyun.lim@gmail.com>
References: <1454636118-9943-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need to set to 0 for counter variable before entering next
for-loop statement because counter is initialized again in for-loop
statement, so just remove it.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 4008872..dda81ee 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -468,7 +468,6 @@ int wilc_send_config_pkt(struct wilc *wilc, u8 mode, struct wid *wids,
 				break;
 			}
 		}
-		counter = 0;
 		for (counter = 0; counter < count; counter++) {
 			wids[counter].size = wilc_wlan_cfg_get_val(
 					wids[counter].id,
-- 
2.7.0

