Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50548 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab0C3Bfh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 21:35:37 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH] ipw2200: restart adapter only when abort_scan doesn't work
Date: Tue, 30 Mar 2010 09:36:16 +0800
Message-Id: <1269912976-29731-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a scan watchdog is fired, try to send abort scan command
first before restarting the adapter. This avoids reconnection for
some users when scan hang is detected.

This fixed bug https://bugzilla.kernel.org/show_bug.cgi?id=15419

Reported-and-tested-by: Maurizio Avogadro <mavoga@gmail.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/ipw2x00/ipw2200.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index cb3ba13..ce1d062 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -2348,16 +2348,25 @@ static void ipw_bg_adapter_restart(struct work_struct *work)
 	mutex_unlock(&priv->mutex);
 }
 
-#define IPW_SCAN_CHECK_WATCHDOG (5 * HZ)
+static void ipw_abort_scan(struct ipw_priv *priv);
+
+#define IPW_SCAN_CHECK_WATCHDOG	(5 * HZ)
 
 static void ipw_scan_check(void *data)
 {
 	struct ipw_priv *priv = data;
-	if (priv->status & (STATUS_SCANNING | STATUS_SCAN_ABORTING)) {
+
+	if (priv->status & STATUS_SCAN_ABORTING) {
 		IPW_DEBUG_SCAN("Scan completion watchdog resetting "
 			       "adapter after (%dms).\n",
 			       jiffies_to_msecs(IPW_SCAN_CHECK_WATCHDOG));
 		queue_work(priv->workqueue, &priv->adapter_restart);
+	} else if (priv->status & STATUS_SCANNING) {
+		IPW_DEBUG_SCAN("Scan completion watchdog aborting scan "
+			       "after (%dms).\n",
+			       jiffies_to_msecs(IPW_SCAN_CHECK_WATCHDOG));
+		ipw_abort_scan(priv);
+		queue_delayed_work(priv->workqueue, &priv->scan_check, HZ);
 	}
 }
 
-- 
1.6.3.3

