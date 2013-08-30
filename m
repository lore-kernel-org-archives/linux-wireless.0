Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:55508 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339Ab3H3QKo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Aug 2013 12:10:44 -0400
From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To: netdev@vger.kernel.org
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 net-next 8/9] net: libertas: inherit addr_assign_type along with dev_addr
Date: Fri, 30 Aug 2013 18:08:51 +0200
Message-Id: <1377878932-26881-9-git-send-email-bjorn@mork.no> (sfid-20130830_181049_940550_68DEAABA)
In-Reply-To: <1377878932-26881-1-git-send-email-bjorn@mork.no>
References: <1377878932-26881-1-git-send-email-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A device inheriting a random or set address should reflect this in
its addr_assign_type.

Acked-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
 drivers/net/wireless/libertas/mesh.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/libertas/mesh.c b/drivers/net/wireless/libertas/mesh.c
index efae07e..6fef746 100644
--- a/drivers/net/wireless/libertas/mesh.c
+++ b/drivers/net/wireless/libertas/mesh.c
@@ -1017,7 +1017,7 @@ static int lbs_add_mesh(struct lbs_private *priv)
 
 	mesh_dev->netdev_ops = &mesh_netdev_ops;
 	mesh_dev->ethtool_ops = &lbs_ethtool_ops;
-	memcpy(mesh_dev->dev_addr, priv->dev->dev_addr, ETH_ALEN);
+	eth_hw_addr_inherit(mesh_dev, priv->dev);
 
 	SET_NETDEV_DEV(priv->mesh_dev, priv->dev->dev.parent);
 
-- 
1.7.10.4

