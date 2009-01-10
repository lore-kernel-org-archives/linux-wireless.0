Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:1304 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286AbZAJAzJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 19:55:09 -0500
Received: by wf-out-1314.google.com with SMTP id 27so10135976wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 16:55:08 -0800 (PST)
Message-ID: <4967f1eb.14098e0a.2b44.ffffd9a6@mx.google.com> (sfid-20090110_015516_268551_B9F19DC0)
Date: Fri, 09 Jan 2009 16:55:07 -0800 (PST)
To: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
From: Andrey Yurovsky <andrey@cozybit.com>
Subject: [RFC] libertas: revert switch from priv to ml_priv
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch reverts a part of commit 29726d85d7b98558a8bc8e69b859bf12e1347f9f
which changed some instances of priv to ml_priv and seems to have resulted in 
corruption of libertas' priv data which in turn causes a kernel oops when, for
example, priv data is accessed and derefferenced in WEXT callbacks.

I would appreciate some feedback about this, especially from folks who can
explain what this portion of the patch was trying to accomplish.  In the mean
time this makes libertas usable again without reverting the other parts of the
patch that dealt with using the netdev macros.  Thanks,

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 69f7479..5fefe38 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -496,7 +496,7 @@ static int lbs_dev_open(struct net_device *dev)
  */
 static int lbs_mesh_stop(struct net_device *dev)
 {
-	struct lbs_private *priv = dev->ml_priv;
+	struct lbs_private *priv = netdev_priv(dev);
 
 	lbs_deb_enter(LBS_DEB_MESH);
 	spin_lock_irq(&priv->driver_lock);
@@ -1440,7 +1440,7 @@ static int lbs_add_mesh(struct lbs_private *priv)
 		ret = -ENOMEM;
 		goto done;
 	}
-	mesh_dev->ml_priv = priv;
+	mesh_dev->priv = priv;
 	priv->mesh_dev = mesh_dev;
 
 	mesh_dev->open = lbs_dev_open;
@@ -1653,7 +1653,7 @@ static int lbs_rtap_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 static struct net_device_stats *lbs_rtap_get_stats(struct net_device *dev)
 {
-	struct lbs_private *priv = dev->ml_priv;
+	struct lbs_private *priv = netdev_priv(dev);
 	lbs_deb_enter(LBS_DEB_NET);
 	return &priv->stats;
 }
@@ -1694,7 +1694,7 @@ static int lbs_add_rtap(struct lbs_private *priv)
 	rtap_dev->stop = lbs_rtap_stop;
 	rtap_dev->get_stats = lbs_rtap_get_stats;
 	rtap_dev->hard_start_xmit = lbs_rtap_hard_start_xmit;
-	rtap_dev->ml_priv = priv;
+	rtap_dev->priv = priv;
 	SET_NETDEV_DEV(rtap_dev, priv->dev->dev.parent);
 
 	ret = register_netdev(rtap_dev);


