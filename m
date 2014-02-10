Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:65000 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbaBJLsJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 06:48:09 -0500
Received: by mail-wi0-f172.google.com with SMTP id e4so2705053wiv.5
        for <linux-wireless@vger.kernel.org>; Mon, 10 Feb 2014 03:48:07 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 16/18] wlcore: increase timeout to 5000 msecs
Date: Mon, 10 Feb 2014 13:47:32 +0200
Message-Id: <1392032854-28126-17-git-send-email-eliad@wizery.com> (sfid-20140210_124842_679424_8AA72848)
In-Reply-To: <1392032854-28126-1-git-send-email-eliad@wizery.com>
References: <1392032854-28126-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yaniv Machani <yanivma@ti.com>

dfs configuration command might take longer than
the current timeout. increase it to 5 seconds.

Signed-off-by: Yaniv Machani <yanivma@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/cmd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index 9cb3f44..b084830 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -207,7 +207,7 @@ enum cmd_templ {
 #define WL1271_COMMAND_TIMEOUT     2000
 #define WL1271_CMD_TEMPL_DFLT_SIZE 252
 #define WL1271_CMD_TEMPL_MAX_SIZE  512
-#define WL1271_EVENT_TIMEOUT       1500
+#define WL1271_EVENT_TIMEOUT       5000
 
 struct wl1271_cmd_header {
 	__le16 id;
-- 
1.8.5.2.229.g4448466.dirty

