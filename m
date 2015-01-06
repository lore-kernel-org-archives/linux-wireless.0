Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gw01.mail.saunalahti.fi ([195.197.172.115]:35283 "EHLO
	gw01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449AbbAFVzE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 16:55:04 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Eliad Peller <eliad@wizery.com>, linux-wireless@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH] wlcore: fix copy'n'paste error
Date: Tue,  6 Jan 2015 23:46:43 +0200
Message-Id: <1420580803-25562-1-git-send-email-andy.shevchenko@gmail.com> (sfid-20150106_225509_092013_9043F4C5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no assignment of window_size in wl12xx_acx_config_hangover. The
patch fixes the issue.

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/net/wireless/ti/wlcore/acx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
index b924cea..f28fa3b 100644
--- a/drivers/net/wireless/ti/wlcore/acx.c
+++ b/drivers/net/wireless/ti/wlcore/acx.c
@@ -1725,7 +1725,7 @@ int wl12xx_acx_config_hangover(struct wl1271 *wl)
 	acx->decrease_delta = conf->decrease_delta;
 	acx->quiet_time = conf->quiet_time;
 	acx->increase_time = conf->increase_time;
-	acx->window_size = acx->window_size;
+	acx->window_size = conf->window_size;
 
 	ret = wl1271_cmd_configure(wl, ACX_CONFIG_HANGOVER, acx,
 				   sizeof(*acx));
-- 
1.8.3.101.g727a46b

