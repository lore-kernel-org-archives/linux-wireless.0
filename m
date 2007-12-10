Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43171 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbXLJRli (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 12:41:38 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 38/48] libertas: kill lbs_pre_start_xmit(), lib_mesh_pre_start_xmit()
Message-Id: <E1J1kpi-0006nB-3g@shinybook.infradead.org> (sfid-20071210_174141_515830_D70EC910)
Date: Mon, 10 Dec 2007 10:46:14 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sun, 9 Dec 2007 15:04:19 -0500

These wrappers only do two things.

Firstly, they set the frame type, which isn't necessary since
lbs_hard_start_xmit() gets to see which device it belongs to anyway.

Secondly, they return -EOPNOTSUPP if the device is in monitor mode.
Which is a strange thing to do and will provide nasty warnings from
qdisc_restart(). And lbs_hard_start_xmit() seems to have code to cope
with monitor mode anyway.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/main.c |   50 +--------------------------------
 1 files changed, 2 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index d311d57..5c8cb00 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -515,52 +515,6 @@ static int lbs_close(struct net_device *dev)
 		return 0;
 }
 
-/**
- * @brief Mark mesh packets and handover them to lbs_hard_start_xmit
- *
- */
-static int lbs_mesh_pre_start_xmit(struct sk_buff *skb,
-		struct net_device *dev)
-{
-	struct lbs_private *priv = dev->priv;
-	int ret;
-
-	lbs_deb_enter(LBS_DEB_MESH);
-	if (priv->monitormode != LBS_MONITOR_OFF) {
-		netif_stop_queue(dev);
-		return -EOPNOTSUPP;
-	}
-
-	SET_MESH_FRAME(skb);
-
-	ret = lbs_hard_start_xmit(skb, priv->mesh_dev);
-	lbs_deb_leave_args(LBS_DEB_MESH, "ret %d", ret);
-	return ret;
-}
-
-/**
- * @brief Mark non-mesh packets and handover them to lbs_hard_start_xmit
- *
- */
-static int lbs_pre_start_xmit(struct sk_buff *skb, struct net_device *dev)
-{
-	struct lbs_private *priv = dev->priv;
-	int ret;
-
-	lbs_deb_enter(LBS_DEB_TX);
-
-	if (priv->monitormode != LBS_MONITOR_OFF) {
-		netif_stop_queue(dev);
-		return -EOPNOTSUPP;
-	}
-
-	UNSET_MESH_FRAME(skb);
-
-	ret = lbs_hard_start_xmit(skb, dev);
-	lbs_deb_leave_args(LBS_DEB_TX, "ret %d", ret);
-	return ret;
-}
-
 static void lbs_tx_timeout(struct net_device *dev)
 {
 	struct lbs_private *priv = (struct lbs_private *) dev->priv;
@@ -1104,7 +1058,7 @@ struct lbs_private *lbs_add_card(void *card, struct device *dmdev)
 
 	/* Setup the OS Interface to our functions */
 	dev->open = lbs_open;
-	dev->hard_start_xmit = lbs_pre_start_xmit;
+	dev->hard_start_xmit = lbs_hard_start_xmit;
 	dev->stop = lbs_close;
 	dev->set_mac_address = lbs_set_mac_address;
 	dev->tx_timeout = lbs_tx_timeout;
@@ -1276,7 +1230,7 @@ int lbs_add_mesh(struct lbs_private *priv, struct device *dev)
 	priv->mesh_dev = mesh_dev;
 
 	mesh_dev->open = lbs_mesh_open;
-	mesh_dev->hard_start_xmit = lbs_mesh_pre_start_xmit;
+	mesh_dev->hard_start_xmit = lbs_hard_start_xmit;
 	mesh_dev->stop = lbs_mesh_close;
 	mesh_dev->get_stats = lbs_get_stats;
 	mesh_dev->set_mac_address = lbs_set_mac_address;
-- 
1.5.3.4

