Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50863 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751231AbXFWEei (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2007 00:34:38 -0400
Date: Fri, 22 Jun 2007 21:34:06 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Yi Zhu <yi.zhu@intel.com>
Cc: James Ketrenos <jketreno@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] ipw2200: rf kill switch polling power saving
Message-ID: <20070622213406.68a538ef@oldman>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make the ipw2200 driver polling of rf kill switch occur on second boundaries to reduce
power. Making all the wakeup's in the system occur together reduces power, and keeps
CPU in idle longer.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>

--- a/drivers/net/wireless/ipw2200.c	2007-06-22 09:11:41.000000000 -0700
+++ b/drivers/net/wireless/ipw2200.c	2007-06-22 09:16:24.000000000 -0700
@@ -1751,7 +1751,7 @@ static int ipw_radio_kill_sw(struct ipw_
 			/* Make sure the RF_KILL check timer is running */
 			cancel_delayed_work(&priv->rf_kill);
 			queue_delayed_work(priv->workqueue, &priv->rf_kill,
-					   2 * HZ);
+					   round_jiffies(2 * HZ));
 		} else
 			queue_work(priv->workqueue, &priv->up);
 	}
@@ -4690,7 +4690,8 @@ static void ipw_rx_notification(struct i
 			else if (priv->config & CFG_BACKGROUND_SCAN
 				 && priv->status & STATUS_ASSOCIATED)
 				queue_delayed_work(priv->workqueue,
-						   &priv->request_scan, HZ);
+						   &priv->request_scan,
+						   round_jiffies(HZ));
 
 			/* Send an empty event to user space.
 			 * We don't send the received data on the event because
