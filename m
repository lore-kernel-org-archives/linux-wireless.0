Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44179 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758954Ab2EONrF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 09:47:05 -0400
Received: by wibhj8 with SMTP id hj8so2827545wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 06:47:04 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 2/3] wlcore: increase WL1271_EVENT_TIMEOUT
Date: Tue, 15 May 2012 16:46:57 +0300
Message-Id: <1337089618-12450-2-git-send-email-arik@wizery.com> (sfid-20120515_154715_873343_706A2223)
In-Reply-To: <1337089618-12450-1-git-send-email-arik@wizery.com>
References: <1337089618-12450-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

In some cases, the ROC_COMPLETE event might exceed the
current timeout (750 msec). Increase it to 1 sec.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/cmd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index 2aafe3d..85171f2 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -192,7 +192,7 @@ enum cmd_templ {
 #define WL1271_COMMAND_TIMEOUT     2000
 #define WL1271_CMD_TEMPL_DFLT_SIZE 252
 #define WL1271_CMD_TEMPL_MAX_SIZE  512
-#define WL1271_EVENT_TIMEOUT       750
+#define WL1271_EVENT_TIMEOUT       1000
 
 struct wl1271_cmd_header {
 	__le16 id;
-- 
1.7.9.5

