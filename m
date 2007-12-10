Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:32813 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbXLJQwV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 11:52:21 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 39/48] libertas: stop using ieee80211 for radiotap device
Message-Id: <E1J1kpj-0006nG-4x@shinybook.infradead.org> (sfid-20071210_165224_136889_1ADE9D38)
Date: Mon, 10 Dec 2007 10:46:15 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sun, 9 Dec 2007 16:22:21 -0500

There seems to be no point in doing it as an ieee80211 device instead of
a normal netdev, and when we override its ->priv and then call
free_ieee80211() it has a distressing tendency to crash horribly.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/dev.h  |    2 -
 drivers/net/wireless/libertas/main.c |   36 ++++++++++++++-------------------
 2 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index a9c3adc..04cf33d 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -10,7 +10,6 @@
 #include <linux/wireless.h>
 #include <linux/ethtool.h>
 #include <linux/debugfs.h>
-#include <net/ieee80211.h>
 
 #include "defs.h"
 #include "scan.h"
@@ -114,7 +113,6 @@ struct lbs_private {
 	struct net_device_stats stats;
 	struct net_device *mesh_dev; /* Virtual device */
 	struct net_device *rtap_net_dev;
-	struct ieee80211_device *ieee;
 
 	struct iw_statistics wstats;
 	struct lbs_mesh_stats mstats;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 5c8cb00..55dce8d 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1448,7 +1448,7 @@ static int lbs_rtap_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 static struct net_device_stats *lbs_rtap_get_stats(struct net_device *dev)
 {
 	struct lbs_private *priv = dev->priv;
-	return &priv->ieee->stats;
+	return &priv->stats;
 }
 
 
@@ -1457,42 +1457,36 @@ void lbs_remove_rtap(struct lbs_private *priv)
 	if (priv->rtap_net_dev == NULL)
 		return;
 	unregister_netdev(priv->rtap_net_dev);
-	free_ieee80211(priv->rtap_net_dev);
+	free_netdev(priv->rtap_net_dev);
 	priv->rtap_net_dev = NULL;
 }
 
 int lbs_add_rtap(struct lbs_private *priv)
 {
 	int rc = 0;
+	struct net_device *rtap_dev;
 
 	if (priv->rtap_net_dev)
 		return -EPERM;
 
-	priv->rtap_net_dev = alloc_ieee80211(0);
-	if (priv->rtap_net_dev == NULL)
+	rtap_dev = alloc_netdev(0, "rtap%d", ether_setup);
+	if (rtap_dev == NULL)
 		return -ENOMEM;
 
+	rtap_dev->type = ARPHRD_IEEE80211_RADIOTAP;
+	rtap_dev->open = lbs_rtap_open;
+	rtap_dev->stop = lbs_rtap_stop;
+	rtap_dev->get_stats = lbs_rtap_get_stats;
+	rtap_dev->hard_start_xmit = lbs_rtap_hard_start_xmit;
+	rtap_dev->set_multicast_list = lbs_set_multicast_list;
+	rtap_dev->priv = priv;
 
-	priv->ieee = netdev_priv(priv->rtap_net_dev);
-
-	strcpy(priv->rtap_net_dev->name, "rtap%d");
-
-	priv->rtap_net_dev->type = ARPHRD_IEEE80211_RADIOTAP;
-	priv->rtap_net_dev->open = lbs_rtap_open;
-	priv->rtap_net_dev->stop = lbs_rtap_stop;
-	priv->rtap_net_dev->get_stats = lbs_rtap_get_stats;
-	priv->rtap_net_dev->hard_start_xmit = lbs_rtap_hard_start_xmit;
-	priv->rtap_net_dev->set_multicast_list = lbs_set_multicast_list;
-	priv->rtap_net_dev->priv = priv;
-
-	priv->ieee->iw_mode = IW_MODE_MONITOR;
-
-	rc = register_netdev(priv->rtap_net_dev);
+	rc = register_netdev(rtap_dev);
 	if (rc) {
-		free_ieee80211(priv->rtap_net_dev);
-		priv->rtap_net_dev = NULL;
+		free_netdev(rtap_dev);
 		return rc;
 	}
+	priv->rtap_net_dev = rtap_dev;
 
 	return 0;
 }
-- 
1.5.3.4

