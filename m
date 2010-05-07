Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:43282 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658Ab0EGIjT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 May 2010 04:39:19 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH 4/5] wl1271: Increase timeout for command event waiting
Date: Fri,  7 May 2010 11:39:01 +0300
Message-Id: <1273221542-14283-5-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1273221542-14283-1-git-send-email-luciano.coelho@nokia.com>
References: <1273221542-14283-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>

Incresed the timeout value for command complete event waiting from 100
ms to 750 ms. In some rare cases it can take about 600 ms before
complete event for join command is received. This is most propably
caused by the firmware being busy with scanning related activities.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index 00f78b7..f2820b4 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -129,7 +129,7 @@ enum cmd_templ {
 /* unit ms */
 #define WL1271_COMMAND_TIMEOUT     2000
 #define WL1271_CMD_TEMPL_MAX_SIZE  252
-#define WL1271_EVENT_TIMEOUT       100
+#define WL1271_EVENT_TIMEOUT       750
 
 struct wl1271_cmd_header {
 	__le16 id;
-- 
1.6.3.3

