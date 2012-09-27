Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:41134 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760Ab2I0Kiq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:46 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Eliad Peller <eliad@wizery.com>
Subject: [PATCH 30/31] wlcore: decrease elp timeout
Date: Thu, 27 Sep 2012 13:38:08 +0300
Message-Id: <1348742289-6587-31-git-send-email-luca@coelho.fi> (sfid-20120927_123901_256729_7C39F249)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

The current elp timeout (the same as the dynamic
ps timeout - 1500ms) is too high. Usually,
wl1271_ps_elp_sleep() get called right after tx/rx,
which is fine, but some command might get sent
even when there is no traffic (e.g. ht changes
triggered by beacon frames), and leaving the
device awake for 1500ms in this case is redundant.

Use a timeout of 30ms.
The fw won't enter elp anyway before the dynamic-ps
timeout was expired as well (and it entered ps
successfully).

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wlcore/ps.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/ps.c b/drivers/net/wireless/ti/wlcore/ps.c
index e904d68..4d1414a 100644
--- a/drivers/net/wireless/ti/wlcore/ps.c
+++ b/drivers/net/wireless/ti/wlcore/ps.c
@@ -28,7 +28,7 @@
 
 #define WL1271_WAKEUP_TIMEOUT 500
 
-#define ELP_ENTRY_DELAY  5
+#define ELP_ENTRY_DELAY  30
 
 void wl1271_elp_work(struct work_struct *work)
 {
@@ -98,11 +98,7 @@ void wl1271_ps_elp_sleep(struct wl1271 *wl)
 			return;
 	}
 
-	if (wl->conf.conn.forced_ps)
-		timeout = ELP_ENTRY_DELAY;
-	else
-		timeout = wl->conf.conn.dynamic_ps_timeout;
-
+	timeout = ELP_ENTRY_DELAY;
 	ieee80211_queue_delayed_work(wl->hw, &wl->elp_work,
 				     msecs_to_jiffies(timeout));
 }
-- 
1.7.10.4

