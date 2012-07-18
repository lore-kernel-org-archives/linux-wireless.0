Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:51475 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754063Ab2GRMOE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 08:14:04 -0400
Received: by lbbgk8 with SMTP id gk8so2245815lbb.12
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jul 2012 05:14:00 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 14/14] wlcore: increase command completion timeout
Date: Wed, 18 Jul 2012 15:13:33 +0300
Message-Id: <1342613613-917-15-git-send-email-coelho@ti.com> (sfid-20120718_141418_592338_BE8F3A07)
In-Reply-To: <1342613613-917-1-git-send-email-coelho@ti.com>
References: <1342613613-917-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some rare cases, the CMD_ROC completion may take over 1 second.
The timeout had earlier been increased to 1000ms (from 750ms), but it
is still not enoug.  Increase it to 1500ms.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/cmd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index d7d9f80..4ef0b09 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -192,7 +192,7 @@ enum cmd_templ {
 #define WL1271_COMMAND_TIMEOUT     2000
 #define WL1271_CMD_TEMPL_DFLT_SIZE 252
 #define WL1271_CMD_TEMPL_MAX_SIZE  512
-#define WL1271_EVENT_TIMEOUT       1000
+#define WL1271_EVENT_TIMEOUT       1500
 
 struct wl1271_cmd_header {
 	__le16 id;
-- 
1.7.10.4

