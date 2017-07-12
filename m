Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753783AbdGLQr3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Jul 2017 12:47:29 -0400
Message-ID: <1499878022.6577.4.camel@redhat.com> (sfid-20170712_184732_897222_9174C09B)
Subject: [PATCH] ipw2100: don't return positive values to PCI probe on error
From: Dan Williams <dcbw@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Date: Wed, 12 Jul 2017 11:47:02 -0500
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Causes the PCI stack to complain, and then eventually call the
PCI remove function, which ipw2100 is not expecting.  It then
tries to unregister an already-released netdev and other nasty
things, leading to a panic.

Fixes: https://bugzilla.redhat.com/show_bug.cgi?id=1185518

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index f922859..7819959 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -1724,7 +1724,7 @@ static const struct libipw_geo ipw_geos[] = {
 static int ipw2100_up(struct ipw2100_priv *priv, int deferred)
 {
 	unsigned long flags;
-	int rc = 0;
+	int err = 0;
 	u32 lock;
 	u32 ord_len = sizeof(lock);
 
@@ -1757,33 +1757,33 @@ static int ipw2100_up(struct ipw2100_priv *priv, int deferred)
 	if (priv->status & STATUS_POWERED ||
 	    (priv->status & STATUS_RESET_PENDING)) {
 		/* Power cycle the card ... */
-		if (ipw2100_power_cycle_adapter(priv)) {
+		err = ipw2100_power_cycle_adapter(priv);
+		if (err) {
 			printk(KERN_WARNING DRV_NAME
 			       ": %s: Could not cycle adapter.\n",
 			       priv->net_dev->name);
-			rc = 1;
 			goto exit;
 		}
 	} else
 		priv->status |= STATUS_POWERED;
 
 	/* Load the firmware, start the clocks, etc. */
-	if (ipw2100_start_adapter(priv)) {
+	err = ipw2100_start_adapter(priv);
+	if (err) {
 		printk(KERN_ERR DRV_NAME
 		       ": %s: Failed to start the firmware.\n",
 		       priv->net_dev->name);
-		rc = 1;
 		goto exit;
 	}
 
 	ipw2100_initialize_ordinals(priv);
 
 	/* Determine capabilities of this particular HW configuration */
-	if (ipw2100_get_hw_features(priv)) {
+	err = ipw2100_get_hw_features(priv);
+	if (err) {
 		printk(KERN_ERR DRV_NAME
 		       ": %s: Failed to determine HW features.\n",
 		       priv->net_dev->name);
-		rc = 1;
 		goto exit;
 	}
 
@@ -1792,11 +1792,11 @@ static int ipw2100_up(struct ipw2100_priv *priv, int deferred)
 	priv->ieee->freq_band = LIBIPW_24GHZ_BAND;
 
 	lock = LOCK_NONE;
-	if (ipw2100_set_ordinal(priv, IPW_ORD_PERS_DB_LOCK, &lock, &ord_len)) {
+	err = ipw2100_set_ordinal(priv, IPW_ORD_PERS_DB_LOCK, &lock, &ord_len);
+	if (err) {
 		printk(KERN_ERR DRV_NAME
 		       ": %s: Failed to clear ordinal lock.\n",
 		       priv->net_dev->name);
-		rc = 1;
 		goto exit;
 	}
 
@@ -1820,21 +1820,21 @@ static int ipw2100_up(struct ipw2100_priv *priv, int deferred)
 
 	/* Send all of the commands that must be sent prior to
 	 * HOST_COMPLETE */
-	if (ipw2100_adapter_setup(priv)) {
+	err = ipw2100_adapter_setup(priv);
+	if (err) {
 		printk(KERN_ERR DRV_NAME ": %s: Failed to start the card.\n",
 		       priv->net_dev->name);
-		rc = 1;
 		goto exit;
 	}
 
 	if (!deferred) {
 		/* Enable the adapter - sends HOST_COMPLETE */
-		if (ipw2100_enable_adapter(priv)) {
+		err = ipw2100_enable_adapter(priv);
+		if (err) {
 			printk(KERN_ERR DRV_NAME ": "
 			       "%s: failed in call to enable adapter.\n",
 			       priv->net_dev->name);
 			ipw2100_hw_stop_adapter(priv);
-			rc = 1;
 			goto exit;
 		}
 
@@ -1844,7 +1844,7 @@ static int ipw2100_up(struct ipw2100_priv *priv, int deferred)
 	}
 
       exit:
-	return rc;
+	return err;
 }
 
 static void ipw2100_down(struct ipw2100_priv *priv)
-- 
2.9.4
