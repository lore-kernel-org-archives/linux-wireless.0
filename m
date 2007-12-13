Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55868 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762759AbXLMG7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:14 -0500
Subject: [PATCH 53/48] libertas: remove pre_open_check()
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i2U-0005r7-HI@shinybook.infradead.org> (sfid-20071213_065921_771766_73B04FBB)
Date: Thu, 13 Dec 2007 01:59:22 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Mon, 10 Dec 2007 15:25:42 -0500

The firmware is always initialised before we register the netdevices.
It's not possible for pre_open_check() to fail.

One day we might try loading firmware in ->open(), but still it won't be
just a _check_, like this.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/main.c |   32 --------------------------------
 1 files changed, 0 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 2797149..3d9de7a 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -367,34 +367,6 @@ static struct attribute_group lbs_mesh_attr_group = {
 };
 
 /**
- *  @brief Check if the device can be open and wait if necessary.
- *
- *  @param dev     A pointer to net_device structure
- *  @return 	   0
- *
- * For USB adapter, on some systems the device open handler will be
- * called before FW ready. Use the following flag check and wait
- * function to work around the issue.
- *
- */
-static int pre_open_check(struct net_device *dev)
-{
-	struct lbs_private *priv = (struct lbs_private *) dev->priv;
-	int i = 0;
-
-	while (!priv->fw_ready && i < 20) {
-		i++;
-		msleep_interruptible(100);
-	}
-	if (!priv->fw_ready) {
-		lbs_pr_err("firmware not ready\n");
-		return -1;
-	}
-
-	return 0;
-}
-
-/**
  *  @brief This function opens the device
  *
  *  @param dev     A pointer to net_device structure
@@ -433,8 +405,6 @@ static int lbs_mesh_open(struct net_device *dev)
 {
 	struct lbs_private *priv = (struct lbs_private *) dev->priv ;
 
-	if (pre_open_check(dev) == -1)
-		return -1;
 	priv->mesh_open = 1 ;
 	netif_wake_queue(priv->mesh_dev);
 
@@ -457,8 +427,6 @@ static int lbs_open(struct net_device *dev)
 {
 	struct lbs_private *priv = (struct lbs_private *) dev->priv ;
 
-	if(pre_open_check(dev) == -1)
-		return -1;
 	priv->infra_open = 1 ;
 	netif_wake_queue(priv->dev);
 	if (priv->open == 0)
-- 
1.5.3.4

