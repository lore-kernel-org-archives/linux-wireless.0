Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:46256 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbZBDXGw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 18:06:52 -0500
Received: by mail-ew0-f21.google.com with SMTP id 14so4024043ewy.13
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2009 15:06:51 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH v2 12/16] orinoco: Add hardware function to set multicast mode
Date: Wed,  4 Feb 2009 23:05:54 +0000
Message-Id: <1233788758-9850-13-git-send-email-kilroyd@googlemail.com> (sfid-20090205_000656_673589_CCD5D1D7)
In-Reply-To: <1233788758-9850-12-git-send-email-kilroyd@googlemail.com>
References: <1233788758-9850-1-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-2-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-3-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-4-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-5-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-6-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-7-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-8-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-9-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-10-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-11-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-12-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No functional change.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/main.c |   51 +++++++++++++++++++++-------------
 1 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 1617e10..846113b 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -2347,25 +2347,12 @@ static int __orinoco_program_rids(struct net_device *dev)
 	return 0;
 }
 
-/* FIXME: return int? */
-static void
-__orinoco_set_multicast_list(struct net_device *dev)
+static int __orinoco_hw_set_multicast_list(struct orinoco_private *priv,
+					   struct dev_addr_list *mc_list,
+					   int mc_count, int promisc)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
 	hermes_t *hw = &priv->hw;
 	int err = 0;
-	int promisc, mc_count;
-
-	/* The Hermes doesn't seem to have an allmulti mode, so we go
-	 * into promiscuous mode and let the upper levels deal. */
-	if ((dev->flags & IFF_PROMISC) || (dev->flags & IFF_ALLMULTI) ||
-	     (dev->mc_count > MAX_MULTICAST(priv))) {
-		promisc = 1;
-		mc_count = 0;
-	} else {
-		promisc = 0;
-		mc_count = dev->mc_count;
-	}
 
 	if (promisc != priv->promiscuous) {
 		err = hermes_write_wordrec(hw, USER_BAP,
@@ -2373,7 +2360,7 @@ __orinoco_set_multicast_list(struct net_device *dev)
 					   promisc);
 		if (err) {
 			printk(KERN_ERR "%s: Error %d setting PROMISCUOUSMODE to 1.\n",
-			       dev->name, err);
+			       priv->ndev->name, err);
 		} else
 			priv->promiscuous = promisc;
 	}
@@ -2382,7 +2369,7 @@ __orinoco_set_multicast_list(struct net_device *dev)
 	 * group address if either we want to multicast, or if we were
 	 * multicasting and want to stop */
 	if (!promisc && (mc_count || priv->mc_count)) {
-		struct dev_mc_list *p = dev->mc_list;
+		struct dev_mc_list *p = mc_list;
 		struct hermes_multicast mclist;
 		int i;
 
@@ -2398,7 +2385,7 @@ __orinoco_set_multicast_list(struct net_device *dev)
 
 		if (p)
 			printk(KERN_WARNING "%s: Multicast list is "
-			       "longer than mc_count\n", dev->name);
+			       "longer than mc_count\n", priv->ndev->name);
 
 		err = hermes_write_ltv(hw, USER_BAP,
 				   HERMES_RID_CNFGROUPADDRESSES,
@@ -2406,10 +2393,34 @@ __orinoco_set_multicast_list(struct net_device *dev)
 				   &mclist);
 		if (err)
 			printk(KERN_ERR "%s: Error %d setting multicast list.\n",
-			       dev->name, err);
+			       priv->ndev->name, err);
 		else
 			priv->mc_count = mc_count;
 	}
+	return err;
+}
+
+/* FIXME: return int? */
+static void
+__orinoco_set_multicast_list(struct net_device *dev)
+{
+	struct orinoco_private *priv = netdev_priv(dev);
+	int err = 0;
+	int promisc, mc_count;
+
+	/* The Hermes doesn't seem to have an allmulti mode, so we go
+	 * into promiscuous mode and let the upper levels deal. */
+	if ((dev->flags & IFF_PROMISC) || (dev->flags & IFF_ALLMULTI) ||
+	    (dev->mc_count > MAX_MULTICAST(priv))) {
+		promisc = 1;
+		mc_count = 0;
+	} else {
+		promisc = 0;
+		mc_count = dev->mc_count;
+	}
+
+	err = __orinoco_hw_set_multicast_list(priv, dev->mc_list, mc_count,
+					      promisc);
 }
 
 /* This must be called from user context, without locks held - use
-- 
1.6.0.6

