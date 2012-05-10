Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61669 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758666Ab2EJJRQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:17:16 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1110716wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:17:16 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 75/78] wlcore: increase aggregation buffer size by one page
Date: Thu, 10 May 2012 12:14:20 +0300
Message-Id: <1336641263-5761-76-git-send-email-arik@wizery.com> (sfid-20120510_111728_386523_22514A71)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

With 4 pages (16Kb), we can't fit 10 frames in the aggregation buffer
during iperf.  This is the optimal for the firmware.  Thus, increase
the buffer size by one page.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 45c07dc..83c9869 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -89,7 +89,7 @@
 #define WL1271_AP_BSS_INDEX        0
 #define WL1271_AP_DEF_BEACON_EXP   20
 
-#define WL1271_AGGR_BUFFER_SIZE (4 * PAGE_SIZE)
+#define WL1271_AGGR_BUFFER_SIZE (5 * PAGE_SIZE)
 
 enum wl1271_state {
 	WL1271_STATE_OFF,
-- 
1.7.9.5

