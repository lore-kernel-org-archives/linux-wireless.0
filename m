Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:50788 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab3IIJZJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 05:25:09 -0400
Received: by mail-wg0-f53.google.com with SMTP id x12so2636543wgg.8
        for <linux-wireless@vger.kernel.org>; Mon, 09 Sep 2013 02:25:08 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 11/13] wlcore: memset wl->rx_filter_enabled to zero after recovery
Date: Mon,  9 Sep 2013 12:24:42 +0300
Message-Id: <1378718684-14430-11-git-send-email-eliad@wizery.com> (sfid-20130909_114831_328936_4409901B)
In-Reply-To: <1378718684-14430-1-git-send-email-eliad@wizery.com>
References: <1378718684-14430-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nadim Zubidat <nadimz@ti.com>

zero rx_filter_enabled array after recovery to avoid
cases were the driver will keep trying to clear a
filter which is not configured in FW.

Such case will cause consecutive recoveries due to
command execution failures.

Signed-off-by: Nadim Zubidat <nadimz@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 60b2113..acb3502 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1915,6 +1915,7 @@ static void wlcore_op_stop_locked(struct wl1271 *wl)
 	memset(wl->links_map, 0, sizeof(wl->links_map));
 	memset(wl->roc_map, 0, sizeof(wl->roc_map));
 	memset(wl->session_ids, 0, sizeof(wl->session_ids));
+	memset(wl->rx_filter_enabled, 0, sizeof(wl->rx_filter_enabled));
 	wl->active_sta_count = 0;
 	wl->active_link_count = 0;
 
-- 
1.8.3.rc1.35.g9b79519

