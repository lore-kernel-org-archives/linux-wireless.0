Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:55117 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbZBDXGZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 18:06:25 -0500
Received: by fg-out-1718.google.com with SMTP id 16so1379501fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2009 15:06:23 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH v2 05/16] orinoco: Fix interesting checkpatch errors
Date: Wed,  4 Feb 2009 23:05:47 +0000
Message-Id: <1233788758-9850-6-git-send-email-kilroyd@googlemail.com> (sfid-20090205_000628_871596_BF36622F)
In-Reply-To: <1233788758-9850-5-git-send-email-kilroyd@googlemail.com>
References: <1233788758-9850-1-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-2-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-3-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-4-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-5-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ERROR: "foo * bar" should be "foo *bar"
ERROR: do not initialise statics to 0 or NULL
WARNING: printk() should include KERN_ facility level
WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/orinoco.c |   52 +++++++++++++------------------
 1 files changed, 22 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/orinoco/orinoco.c b/drivers/net/wireless/orinoco/orinoco.c
index acfced8..1544eff 100644
--- a/drivers/net/wireless/orinoco/orinoco.c
+++ b/drivers/net/wireless/orinoco/orinoco.c
@@ -110,9 +110,9 @@ MODULE_LICENSE("Dual MPL/GPL");
 /* Level of debugging. Used in the macros in orinoco.h */
 #ifdef ORINOCO_DEBUG
 int orinoco_debug = ORINOCO_DEBUG;
+EXPORT_SYMBOL(orinoco_debug);
 module_param(orinoco_debug, int, 0644);
 MODULE_PARM_DESC(orinoco_debug, "Debug level");
-EXPORT_SYMBOL(orinoco_debug);
 #endif
 
 static int suppress_linkstatus; /* = 0 */
@@ -1650,7 +1650,7 @@ static void orinoco_rx_isr_tasklet(unsigned long data)
 
 static void print_linkstatus(struct net_device *dev, u16 status)
 {
-	char * s;
+	char *s;
 
 	if (suppress_linkstatus)
 		return;
@@ -2309,6 +2309,7 @@ int __orinoco_up(struct net_device *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL(__orinoco_up);
 
 int __orinoco_down(struct net_device *dev)
 {
@@ -2340,6 +2341,7 @@ int __orinoco_down(struct net_device *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL(__orinoco_down);
 
 static int orinoco_allocate_fid(struct net_device *dev)
 {
@@ -2350,16 +2352,12 @@ static int orinoco_allocate_fid(struct net_device *dev)
 	err = hermes_allocate(hw, priv->nicbuf_size, &priv->txfid);
 	if (err == -EIO && priv->nicbuf_size > TX_NICBUF_SIZE_BUG) {
 		/* Try workaround for old Symbol firmware bug */
-		printk(KERN_WARNING "%s: firmware ALLOC bug detected "
-		       "(old Symbol firmware?). Trying to work around... ",
-		       dev->name);
-
 		priv->nicbuf_size = TX_NICBUF_SIZE_BUG;
 		err = hermes_allocate(hw, priv->nicbuf_size, &priv->txfid);
-		if (err)
-			printk("failed!\n");
-		else
-			printk("ok.\n");
+
+		printk(KERN_WARNING "%s: firmware ALLOC bug detected "
+		       "(old Symbol firmware?). Work around %s\n",
+		       dev->name, err ? "failed!" : "ok.");
 	}
 
 	return err;
@@ -2382,6 +2380,7 @@ int orinoco_reinit_firmware(struct net_device *dev)
 
 	return err;
 }
+EXPORT_SYMBOL(orinoco_reinit_firmware);
 
 static int __orinoco_hw_set_bitrate(struct orinoco_private *priv)
 {
@@ -3060,12 +3059,14 @@ irqreturn_t orinoco_interrupt(int irq, void *dev_id)
 	hermes_t *hw = &priv->hw;
 	int count = MAX_IRQLOOPS_PER_IRQ;
 	u16 evstat, events;
-	/* These are used to detect a runaway interrupt situation */
-	/* If we get more than MAX_IRQLOOPS_PER_JIFFY iterations in a jiffy,
-	 * we panic and shut down the hardware */
-	static int last_irq_jiffy = 0; /* jiffies value the last time
-					* we were called */
-	static int loops_this_jiffy = 0;
+	/* These are used to detect a runaway interrupt situation.
+	 *
+	 * If we get more than MAX_IRQLOOPS_PER_JIFFY iterations in a jiffy,
+	 * we panic and shut down the hardware
+	 */
+	/* jiffies value the last time we were called */
+	static int last_irq_jiffy; /* = 0 */
+	static int loops_this_jiffy; /* = 0 */
 	unsigned long flags;
 
 	if (orinoco_lock(priv, &flags) != 0) {
@@ -3127,6 +3128,7 @@ irqreturn_t orinoco_interrupt(int irq, void *dev_id)
 	orinoco_unlock(priv, &flags);
 	return IRQ_HANDLED;
 }
+EXPORT_SYMBOL(orinoco_interrupt);
 
 /********************************************************************/
 /* Power management                                                 */
@@ -3442,11 +3444,8 @@ static int orinoco_init(struct net_device *dev)
 		printk(KERN_DEBUG "%s: IEEE standard IBSS ad-hoc mode supported\n",
 		       dev->name);
 	if (priv->has_wep) {
-		printk(KERN_DEBUG "%s: WEP supported, ", dev->name);
-		if (priv->has_big_wep)
-			printk("104-bit key\n");
-		else
-			printk("40-bit key\n");
+		printk(KERN_DEBUG "%s: WEP supported, %s-bit key\n", dev->name,
+		       priv->has_big_wep ? "104" : "40");
 	}
 	if (priv->has_wpa) {
 		printk(KERN_DEBUG "%s: WPA-PSK supported\n", dev->name);
@@ -3672,6 +3671,7 @@ struct net_device
 
 	return dev;
 }
+EXPORT_SYMBOL(alloc_orinocodev);
 
 void free_orinocodev(struct net_device *dev)
 {
@@ -3701,6 +3701,7 @@ void free_orinocodev(struct net_device *dev)
 	orinoco_bss_data_free(priv);
 	free_netdev(dev);
 }
+EXPORT_SYMBOL(free_orinocodev);
 
 /********************************************************************/
 /* Wireless extensions                                              */
@@ -6143,15 +6144,6 @@ static const struct ethtool_ops orinoco_ethtool_ops = {
 /* Module initialization                                            */
 /********************************************************************/
 
-EXPORT_SYMBOL(alloc_orinocodev);
-EXPORT_SYMBOL(free_orinocodev);
-
-EXPORT_SYMBOL(__orinoco_up);
-EXPORT_SYMBOL(__orinoco_down);
-EXPORT_SYMBOL(orinoco_reinit_firmware);
-
-EXPORT_SYMBOL(orinoco_interrupt);
-
 /* Can't be declared "const" or the whole __initdata section will
  * become const */
 static char version[] __initdata = DRIVER_NAME " " DRIVER_VERSION
-- 
1.6.0.6

