Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55080 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab0KXUda (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 15:33:30 -0500
Received: by wyb28 with SMTP id 28so131322wyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Nov 2010 12:33:29 -0800 (PST)
From: David Kilroy <kilroyd@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: comes@naic.edu, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH] orinoco: abort scan on interface down
Date: Wed, 24 Nov 2010 20:33:02 +0000
Message-Id: <1290630782-11095-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the problem causing the following trace:

------------[ cut here ]------------
WARNING: at linux-2.6.34/net/wireless/core.c:633 wdev_cleanup_work+0xb7/0xe0 [cfg80211]()
Hardware name: Latitude C840
Pid: 707, comm: cfg80211 Not tainted 2.6.34.7-0.5-desktop #1
Call Trace:
 [<c02065c3>] try_stack_unwind+0x173/0x190
 [<c02051cf>] dump_trace+0x3f/0xe0
 [<c020662b>] show_trace_log_lvl+0x4b/0x60
 [<c0206658>] show_trace+0x18/0x20
 [<c064e0b3>] dump_stack+0x6d/0x72
 [<c02443ae>] warn_slowpath_common+0x6e/0xb0
 [<c0244403>] warn_slowpath_null+0x13/0x20
 [<e2db5497>] wdev_cleanup_work+0xb7/0xe0 [cfg80211]
 [<c025cfa9>] run_workqueue+0x79/0x170
 [<c025d123>] worker_thread+0x83/0xe0
 [<c025fef4>] kthread+0x74/0x80
 [<c0203826>] kernel_thread_helper+0x6/0x10
---[ end trace 3f0348b3b0c6f4ff ]---

Reported by: Giacomo Comes <comes@naic.edu>
Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---

This patch has only been compile tested. Given the trace, I've
guessed that cfg80211 would prefer that orinoco abort the scan on
interface down.

---
 drivers/net/wireless/orinoco/main.c |   12 +++++-------
 drivers/net/wireless/orinoco/scan.c |    8 ++++++++
 drivers/net/wireless/orinoco/scan.h |    1 +
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index e8e2d0f..fa0cf74 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -1392,10 +1392,9 @@ static void orinoco_process_scan_results(struct work_struct *work)
 				orinoco_add_hostscan_results(priv, buf, len);
 
 			kfree(buf);
-		} else if (priv->scan_request) {
+		} else {
 			/* Either abort or complete the scan */
-			cfg80211_scan_done(priv->scan_request, (len < 0));
-			priv->scan_request = NULL;
+			orinoco_scan_done(priv, (len < 0));
 		}
 
 		spin_lock_irqsave(&priv->scan_lock, flags);
@@ -1684,6 +1683,8 @@ static int __orinoco_down(struct orinoco_private *priv)
 		hermes_write_regn(hw, EVACK, 0xffff);
 	}
 
+	orinoco_scan_done(priv, true);
+
 	/* firmware will have to reassociate */
 	netif_carrier_off(dev);
 	priv->last_linkstatus = 0xffff;
@@ -1762,10 +1763,7 @@ void orinoco_reset(struct work_struct *work)
 	orinoco_unlock(priv, &flags);
 
 	/* Scanning support: Notify scan cancellation */
-	if (priv->scan_request) {
-		cfg80211_scan_done(priv->scan_request, 1);
-		priv->scan_request = NULL;
-	}
+	orinoco_scan_done(priv, true);
 
 	if (priv->hard_reset) {
 		err = (*priv->hard_reset)(priv);
diff --git a/drivers/net/wireless/orinoco/scan.c b/drivers/net/wireless/orinoco/scan.c
index 4300d9d..86cb54c 100644
--- a/drivers/net/wireless/orinoco/scan.c
+++ b/drivers/net/wireless/orinoco/scan.c
@@ -229,3 +229,11 @@ void orinoco_add_hostscan_results(struct orinoco_private *priv,
 		priv->scan_request = NULL;
 	}
 }
+
+void orinoco_scan_done(struct orinoco_private *priv, bool abort)
+{
+	if (priv->scan_request) {
+		cfg80211_scan_done(priv->scan_request, abort);
+		priv->scan_request = NULL;
+	}
+}
diff --git a/drivers/net/wireless/orinoco/scan.h b/drivers/net/wireless/orinoco/scan.h
index 2dc4e04..27281fb 100644
--- a/drivers/net/wireless/orinoco/scan.h
+++ b/drivers/net/wireless/orinoco/scan.h
@@ -16,5 +16,6 @@ void orinoco_add_extscan_result(struct orinoco_private *priv,
 void orinoco_add_hostscan_results(struct orinoco_private *dev,
 				  unsigned char *buf,
 				  size_t len);
+void orinoco_scan_done(struct orinoco_private *priv, bool abort);
 
 #endif /* _ORINOCO_SCAN_H_ */
-- 
1.7.2.2

