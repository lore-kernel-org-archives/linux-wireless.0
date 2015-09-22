Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33919 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086AbbIVJfQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 05:35:16 -0400
Received: by padhy16 with SMTP id hy16so4749779pad.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2015 02:35:16 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 04/16] staging: wilc1000: make del_virtual_intf static
Date: Tue, 22 Sep 2015 18:34:49 +0900
Message-Id: <1442914501-2315-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20150922_113522_977243_B3E261A4)
In-Reply-To: <1442914501-2315-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442914501-2315-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes del_virtual_intf static. This function is used only at
wilc_wfi_cfgoperation.c file.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
v2: rebase latest staging-testing

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 40fd3ca..da04e50 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3362,7 +3362,7 @@ struct wireless_dev *add_virtual_intf(struct wiphy *wiphy, const char *name,
  *  @date	01 JUL 2012
  *  @version	1.0
  */
-int del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
+static int del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 {
 	PRINT_D(HOSTAPD_DBG, "Deleting virtual interface\n");
 	return 0;
-- 
2.5.1

