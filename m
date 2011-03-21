Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:37744 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752935Ab1CUQAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 12:00:08 -0400
Received: by eyg5 with SMTP id 5so1350121eyg.38
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 09:00:03 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] wl12xx: fix SG BT load value to reflect its new meaning
Date: Mon, 21 Mar 2011 17:59:16 +0200
Message-Id: <1300723156-20978-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Soft Gemini BT load ratio value has changed its meaning with FW
version 6.1.0.0.310.  It now means the passive scan compensation
percentage during A2DP EDR.  Instead of 50, we need to use 200.

Fix the SG configuration accordingly.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 59e0f79..916ebd1 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -54,7 +54,7 @@ static struct conf_drv_settings default_conf = {
 			[CONF_SG_BT_PER_THRESHOLD]                  = 7500,
 			[CONF_SG_HV3_MAX_OVERRIDE]                  = 0,
 			[CONF_SG_BT_NFS_SAMPLE_INTERVAL]            = 400,
-			[CONF_SG_BT_LOAD_RATIO]                     = 50,
+			[CONF_SG_BT_LOAD_RATIO]                     = 200,
 			[CONF_SG_AUTO_PS_MODE]                      = 1,
 			[CONF_SG_AUTO_SCAN_PROBE_REQ]               = 170,
 			[CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_HV3]   = 50,
-- 
1.7.1

