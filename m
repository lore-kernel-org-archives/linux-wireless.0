Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:36630 "EHLO
	mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbcBEBfq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 20:35:46 -0500
Received: by mail-pf0-f172.google.com with SMTP id n128so59013829pfn.3
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2016 17:35:45 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 4/8] staging: wilc1000: fix return error code of wilc_deinit
Date: Fri,  5 Feb 2016 10:35:14 +0900
Message-Id: <1454636118-9943-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20160205_023549_554931_4F1B5D12)
In-Reply-To: <1454636118-9943-1-git-send-email-chaehyun.lim@gmail.com>
References: <1454636118-9943-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It should be returned error code as -EFAULT instead of 0 when hif_drv is
NULL.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 36eeeb4..6c91071 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3890,7 +3890,7 @@ int wilc_deinit(struct wilc_vif *vif)
 
 	if (!hif_drv)	{
 		PRINT_ER("hif_drv = NULL\n");
-		return 0;
+		return -EFAULT;
 	}
 
 	down(&hif_sema_deinit);
-- 
2.7.0

