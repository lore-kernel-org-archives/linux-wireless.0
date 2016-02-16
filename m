Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35897 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbcBPIkK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2016 03:40:10 -0500
Received: by mail-pa0-f54.google.com with SMTP id yy13so99577415pab.3
        for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2016 00:40:10 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 3/7] staging: wilc1000: handle_set_mac_address: use kmemdup
Date: Tue, 16 Feb 2016 17:39:51 +0900
Message-Id: <1455611995-28773-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20160216_094016_960369_9F87099C)
In-Reply-To: <1455611995-28773-1-git-send-email-chaehyun.lim@gmail.com>
References: <1455611995-28773-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces kmalloc followed by memcpy with kmemdup.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4d50b38..65d2393 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -429,13 +429,11 @@ static s32 handle_set_mac_address(struct wilc_vif *vif,
 {
 	s32 result = 0;
 	struct wid wid;
-	u8 *mac_buf = kmalloc(ETH_ALEN, GFP_KERNEL);
 
+	u8 *mac_buf = kmemdup(set_mac_addr->mac_addr, ETH_ALEN, GFP_KERNEL);
 	if (!mac_buf)
 		return -ENOMEM;
 
-	memcpy(mac_buf, set_mac_addr->mac_addr, ETH_ALEN);
-
 	wid.id = (u16)WID_MAC_ADDR;
 	wid.type = WID_STR;
 	wid.val = mac_buf;
-- 
2.7.1

