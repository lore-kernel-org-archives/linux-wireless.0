Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:36484 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbcBWGiM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 01:38:12 -0500
Received: by mail-pf0-f170.google.com with SMTP id e127so107000385pfe.3
        for <linux-wireless@vger.kernel.org>; Mon, 22 Feb 2016 22:38:11 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/7] staging: wilc1000: handle_set_mac_address: fix missing blank line after declaration
Date: Tue, 23 Feb 2016 15:37:57 +0900
Message-Id: <1456209483-20345-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20160223_073815_624493_683548E8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 31cc9885e7c7 ("staging: wilc1000: handle_set_mac_address: use kmemdup")
introduces a new checkpatch warning, so this patch fixes it.

WARNING: Missing a blank line after declarations
FILE: drivers/staging/wilc1000/host_interface.c:430:

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0c09df4..e442d81 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -429,8 +429,9 @@ static void handle_set_mac_address(struct wilc_vif *vif,
 {
 	int ret = 0;
 	struct wid wid;
+	u8 *mac_buf;
 
-	u8 *mac_buf = kmemdup(set_mac_addr->mac_addr, ETH_ALEN, GFP_KERNEL);
+	mac_buf = kmemdup(set_mac_addr->mac_addr, ETH_ALEN, GFP_KERNEL);
 	if (!mac_buf)
 		return;
 
-- 
2.7.1

