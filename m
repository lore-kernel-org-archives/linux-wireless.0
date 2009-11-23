Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:40119 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110AbZKWVXJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 16:23:09 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 7/8] wl1271: remove workaround to ignore -EIO from radio and general params
Date: Mon, 23 Nov 2009 23:22:18 +0200
Message-Id: <1259011339-28149-8-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1259011339-28149-1-git-send-email-luciano.coelho@nokia.com>
References: <1259011339-28149-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were ignoring the -EIO return value from wl1271_cmd_radio_params() and
wl1271_cmd_general_params(), because they were always returning an error and
we didn't know why.  Now this has been fixed, so the workaround can be
removed.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_init.c |    7 ++-----
 drivers/net/wireless/wl12xx/wl1271_main.c |    7 ++-----
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index 44896ac..11249b4 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -197,15 +197,12 @@ int wl1271_hw_init(struct wl1271 *wl)
 {
 	int ret;
 
-	/* FIXME: the following parameter setting functions return error
-	 * codes - the reason is so far unknown. The -EIO is therefore
-	 * ignored for the time being. */
 	ret = wl1271_cmd_general_parms(wl);
-	if (ret < 0 && ret != -EIO)
+	if (ret < 0)
 		return ret;
 
 	ret = wl1271_cmd_radio_parms(wl);
-	if (ret < 0 && ret != -EIO)
+	if (ret < 0)
 		return ret;
 
 	/* Template settings */
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index b75557e..64d0526 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -354,15 +354,12 @@ static int wl1271_plt_init(struct wl1271 *wl)
 {
 	int ret;
 
-	/* FIXME: the following parameter setting functions return error
-	 * codes - the reason is so far unknown. The -EIO is therefore
-	 * ignored for the time being. */
 	ret = wl1271_cmd_general_parms(wl);
-	if (ret < 0 && ret != -EIO)
+	if (ret < 0)
 		return ret;
 
 	ret = wl1271_cmd_radio_parms(wl);
-	if (ret < 0 && ret != -EIO)
+	if (ret < 0)
 		return ret;
 
 	ret = wl1271_acx_init_mem_config(wl);
-- 
1.6.3.3

