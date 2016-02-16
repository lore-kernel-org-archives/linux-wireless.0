Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:32807 "EHLO
	mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbcBPIkH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2016 03:40:07 -0500
Received: by mail-pf0-f178.google.com with SMTP id q63so101366072pfb.0
        for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2016 00:40:07 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/7] staging: wilc1000: handle_set_mac_address: fix kmalloc return error code
Date: Tue, 16 Feb 2016 17:39:50 +0900
Message-Id: <1455611995-28773-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20160216_094013_337155_DB4DACA9)
In-Reply-To: <1455611995-28773-1-git-send-email-chaehyun.lim@gmail.com>
References: <1455611995-28773-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fix return error code of kmalloc as -ENOMEM instead of
-EFAULT.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 579b90a..4d50b38 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -432,7 +432,7 @@ static s32 handle_set_mac_address(struct wilc_vif *vif,
 	u8 *mac_buf = kmalloc(ETH_ALEN, GFP_KERNEL);
 
 	if (!mac_buf)
-		return -EFAULT;
+		return -ENOMEM;
 
 	memcpy(mac_buf, set_mac_addr->mac_addr, ETH_ALEN);
 
-- 
2.7.1

