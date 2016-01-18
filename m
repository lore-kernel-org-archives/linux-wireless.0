Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:59314 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953AbcARJuI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jan 2016 04:50:08 -0500
Received: from dlelxv90.itg.ti.com ([172.17.2.17])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id u0I9o7W6005348
	for <linux-wireless@vger.kernel.org>; Mon, 18 Jan 2016 03:50:07 -0600
Received: from DLEE71.ent.ti.com (dlee71.ent.ti.com [157.170.170.114])
	by dlelxv90.itg.ti.com (8.14.3/8.13.8) with ESMTP id u0I9o7NW021020
	for <linux-wireless@vger.kernel.org>; Mon, 18 Jan 2016 03:50:07 -0600
From: Guy Mishol <guym@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: Guy Mishol <guym@ti.com>
Subject: [PATCH] wlcore: fix return value of wlcore_event_fw_logger
Date: Mon, 18 Jan 2016 11:35:02 +0200
Message-ID: <1453109702-15750-1-git-send-email-guym@ti.com> (sfid-20160118_105011_467108_4664167A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function can return negative values in case of error.
Fixes: 3719c17e1816 ("wlcore/wl18xx: fw logger over sdio")

Signed-off-by: Guy Mishol <guym@ti.com>
---
 drivers/net/wireless/ti/wlcore/event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index c964054..4b59f67 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -38,7 +38,7 @@
 
 int wlcore_event_fw_logger(struct wl1271 *wl)
 {
-	u32 ret;
+	int ret;
 	struct fw_logger_information fw_log;
 	u8  *buffer;
 	u32 internal_fw_addrbase = WL18XX_DATA_RAM_BASE_ADDRESS;
-- 
2.6.4

