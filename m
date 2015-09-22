Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35138 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086AbbIVJfT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 05:35:19 -0400
Received: by pacfv12 with SMTP id fv12so4722512pac.2
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2015 02:35:19 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 05/16] staging: wilc1000: make mgmt_tx_cancel_wait static
Date: Tue, 22 Sep 2015 18:34:50 +0900
Message-Id: <1442914501-2315-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20150922_113526_247498_A0C94020)
In-Reply-To: <1442914501-2315-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442914501-2315-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes mgmt_tx_cancel_wait static. This function is used only
at wilc_wfi_cfgoperation.c file.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
v2: rebase latest staging-testing

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index da04e50..0c72c5e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2505,9 +2505,9 @@ int mgmt_tx(struct wiphy *wiphy,
 	return s32Error;
 }
 
-int mgmt_tx_cancel_wait(struct wiphy *wiphy,
-			struct wireless_dev *wdev,
-			u64 cookie)
+static int mgmt_tx_cancel_wait(struct wiphy *wiphy,
+			       struct wireless_dev *wdev,
+			       u64 cookie)
 {
 	struct wilc_priv *priv;
 	tstrWILC_WFIDrv *pstrWFIDrv;
-- 
2.5.1

