Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56344 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab0FWOpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jun 2010 10:45:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: dkiran@marvell.com, Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/3] libertas: fix build error due to undefined symbol
Date: Wed, 23 Jun 2010 10:37:24 -0400
Message-Id: <1277303846-17257-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1277281556.3642.6.camel@jlt3.sipsolutions.net>
References: <1277281556.3642.6.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ERROR: "mesh_handler_def" [drivers/net/wireless/libertas/libertas.ko] undefined!

Caused by a hunk missed by "Libertas: cfg80211 support" when building
with CONFIG_WIRELESS_EXT enabled.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/libertas/mesh.c |    3 ---
 drivers/net/wireless/libertas/mesh.h |    5 -----
 2 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/libertas/mesh.c b/drivers/net/wireless/libertas/mesh.c
index 00b36b0..bc5bc13 100644
--- a/drivers/net/wireless/libertas/mesh.c
+++ b/drivers/net/wireless/libertas/mesh.c
@@ -370,9 +370,6 @@ int lbs_add_mesh(struct lbs_private *priv)
 
 	SET_NETDEV_DEV(priv->mesh_dev, priv->dev->dev.parent);
 
-#ifdef	WIRELESS_EXT
-	mesh_dev->wireless_handlers = &mesh_handler_def;
-#endif
 	mesh_dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
 	/* Register virtual mesh interface */
 	ret = register_netdev(mesh_dev);
diff --git a/drivers/net/wireless/libertas/mesh.h b/drivers/net/wireless/libertas/mesh.h
index e257330..84ea248 100644
--- a/drivers/net/wireless/libertas/mesh.h
+++ b/drivers/net/wireless/libertas/mesh.h
@@ -70,11 +70,6 @@ void lbs_persist_config_init(struct net_device *net);
 void lbs_persist_config_remove(struct net_device *net);
 
 
-/* WEXT handler */
-
-extern struct iw_handler_def mesh_handler_def;
-
-
 /* Ethtool statistics */
 
 struct ethtool_stats;
-- 
1.7.0.1

