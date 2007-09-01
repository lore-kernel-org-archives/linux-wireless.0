Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:36283 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbXIAEgV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:36:21 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id E64C7618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:36:20 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 22/35] Only retry resubmitting rx_urb once
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:36:20 -0400
Message-ID: <20070901043620.2498.63286.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Other drivers don't even bother resubmitting it with GFP_KERNEL.  If it
fails with GFP_KERNEL, we have a problem, and restarting the task is not
likely to be helpful.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   21 +++++----------------
 drivers/net/wireless/at76_usb.h |    3 ---
 2 files changed, 5 insertions(+), 19 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 233c4c1..4ad3173 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -3407,21 +3407,11 @@ static int at76_submit_rx_urb(struct at76_priv *priv)
 	}
 
 exit:
-	if (ret < 0) {
-		if (ret != -ENODEV) {
-			/* If we can't submit the URB, the adapter becomes
-			 * completely useless, so try again later */
-			if (--priv->nr_submit_rx_tries > 0)
-				schedule_work(&priv->work_submit_rx);
-			else
-				err("%s: giving up to submit rx urb after %d "
-				    "failures - please unload the driver "
-				    "and/or power cycle the device",
-				    priv->netdev->name, NR_SUBMIT_RX_TRIES);
-		}
-	} else
-		/* reset counter to initial value */
-		priv->nr_submit_rx_tries = NR_SUBMIT_RX_TRIES;
+	if (ret < 0 && ret != -ENODEV) {
+		printk(KERN_ERR "%s: cannot submit rx urb - please unload the "
+		       "driver and/or power cycle the device\n",
+		       priv->netdev->name);
+	}
 
 	return ret;
 }
@@ -3449,7 +3439,6 @@ static int at76_open(struct net_device *netdev)
 
 	priv->scan_state = SCAN_IDLE;
 	priv->last_scan = jiffies;
-	priv->nr_submit_rx_tries = NR_SUBMIT_RX_TRIES;	/* init counter */
 
 	ret = at76_submit_rx_urb(priv);
 	if (ret < 0) {
diff --git a/drivers/net/wireless/at76_usb.h b/drivers/net/wireless/at76_usb.h
index 33ba517..6c4ebf2 100644
--- a/drivers/net/wireless/at76_usb.h
+++ b/drivers/net/wireless/at76_usb.h
@@ -430,8 +430,6 @@ struct rx_data_buf {
 };
 
 #define NR_RX_DATA_BUF		8
-/* how often do we try to submit a rx urb until giving up */
-#define NR_SUBMIT_RX_TRIES	8
 
 /* Data for one loaded firmware file */
 struct fwentry {
@@ -477,7 +475,6 @@ struct at76_priv {
 	struct delayed_work dwork_auth;
 	struct delayed_work dwork_assoc;
 
-	int nr_submit_rx_tries;	/* number of tries to submit an rx urb left */
 	struct tasklet_struct rx_tasklet;
 
 	/* the WEP stuff */
