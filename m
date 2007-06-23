Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40754 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751234AbXFWErv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2007 00:47:51 -0400
Date: Fri, 22 Jun 2007 21:46:50 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Yi Zhu <yi.zhu@intel.com>
Cc: James Ketrenos <jketreno@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] ipw2100: RF kill switch timer power save
Message-ID: <20070622214650.690293f4@oldman>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Similar patch to ipw2200. Round the timer used for RF kill
switch off to 1 second boundary to save power.
Build tested only, don't have this hardware.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>

--- la/drivers/net/wireless/ipw2100.c	2007-06-22 21:22:18.000000000 -0700
+++ lb/drivers/net/wireless/ipw2100.c	2007-06-22 21:24:25.000000000 -0700
@@ -1768,7 +1768,8 @@ static int ipw2100_up(struct ipw2100_pri
 
 		if (priv->stop_rf_kill) {
 			priv->stop_rf_kill = 0;
-			queue_delayed_work(priv->workqueue, &priv->rf_kill, HZ);
+			queue_delayed_work(priv->workqueue, &priv->rf_kill,
+					   round_jiffies(HZ));
 		}
 
 		deferred = 1;
@@ -2098,7 +2099,7 @@ static void isr_indicate_rf_kill(struct 
 	/* Make sure the RF Kill check timer is running */
 	priv->stop_rf_kill = 0;
 	cancel_delayed_work(&priv->rf_kill);
-	queue_delayed_work(priv->workqueue, &priv->rf_kill, HZ);
+	queue_delayed_work(priv->workqueue, &priv->rf_kill, round_jiffies(HZ));
 }
 
 static void isr_scan_complete(struct ipw2100_priv *priv, u32 status)
@@ -4233,7 +4234,8 @@ static int ipw_radio_kill_sw(struct ipw2
 			/* Make sure the RF_KILL check timer is running */
 			priv->stop_rf_kill = 0;
 			cancel_delayed_work(&priv->rf_kill);
-			queue_delayed_work(priv->workqueue, &priv->rf_kill, HZ);
+			queue_delayed_work(priv->workqueue, &priv->rf_kill,
+					   round_jiffies(HZ));
 		} else
 			schedule_reset(priv);
 	}
@@ -5969,7 +5971,8 @@ static void ipw2100_rf_kill(struct work_
 	if (rf_kill_active(priv)) {
 		IPW_DEBUG_RF_KILL("RF Kill active, rescheduling GPIO check\n");
 		if (!priv->stop_rf_kill)
-			queue_delayed_work(priv->workqueue, &priv->rf_kill, HZ);
+			queue_delayed_work(priv->workqueue, &priv->rf_kill,
+					   round_jiffies(HZ));
 		goto exit_unlock;
 	}
 
