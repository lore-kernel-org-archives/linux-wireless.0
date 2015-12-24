Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:34913 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933192AbbLXHx3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 02:53:29 -0500
Received: by mail-pf0-f179.google.com with SMTP id 78so62820359pfw.2
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2015 23:53:28 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 14/21] staging: wilc1000: use kmemdup instead of kmalloc and memcpy
Date: Thu, 24 Dec 2015 16:52:32 +0900
Message-Id: <1450943559-20937-14-git-send-email-chaehyun.lim@gmail.com> (sfid-20151224_085342_126799_1950B85D)
In-Reply-To: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes kmalloc/memcpy to kmemdup.
It is also added error checking to return -ENOMEM if kmemdup is failed.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 79f3d9f..6518942 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3398,20 +3398,23 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 	msg.vif = vif;
 
 	if (bssid) {
-		msg.body.con_info.bssid = kmalloc(6, GFP_KERNEL);
-		memcpy(msg.body.con_info.bssid, bssid, 6);
+		msg.body.con_info.bssid = kmemdup(bssid, 6, GFP_KERNEL);
+		if (!msg.body.con_info.bssid)
+			return -ENOMEM;
 	}
 
 	if (ssid) {
 		msg.body.con_info.ssid_len = ssid_len;
-		msg.body.con_info.ssid = kmalloc(ssid_len, GFP_KERNEL);
-		memcpy(msg.body.con_info.ssid, ssid, ssid_len);
+		msg.body.con_info.ssid = kmemdup(ssid, ssid_len, GFP_KERNEL);
+		if (!msg.body.con_info.ssid)
+			return -ENOMEM;
 	}
 
 	if (ies) {
 		msg.body.con_info.ies_len = ies_len;
-		msg.body.con_info.ies = kmalloc(ies_len, GFP_KERNEL);
-		memcpy(msg.body.con_info.ies, ies, ies_len);
+		msg.body.con_info.ies = kmemdup(ies, ies_len, GFP_KERNEL);
+		if (!msg.body.con_info.ies)
+			return -ENOMEM;
 	}
 	if (hif_drv->hif_state < HOST_IF_CONNECTING)
 		hif_drv->hif_state = HOST_IF_CONNECTING;
-- 
2.6.4

