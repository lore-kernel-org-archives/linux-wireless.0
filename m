Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474AbYG2RxX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 13:53:23 -0400
Subject: [PATCH] libertas: only enable rtap with mesh firmware
From: Dan Williams <dcbw@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Luis Carlos Cobo <luisca@cozybit.com>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	libertas-dev@lists.infradead.org
Content-Type: text/plain
Date: Tue, 29 Jul 2008 13:50:39 -0400
Message-Id: <1217353839.25221.10.camel@localhost.localdomain> (sfid-20080729_195327_363514_356D0522)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since only mesh-enabled firmware has the CMD_802_11_MONITOR_MODE on
which the rtap functionality depends, only expose the rtap functionality
when mesh is also available.

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index abd6d9e..3e29ed7 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -297,9 +297,7 @@ static ssize_t lbs_rtap_set(struct device *dev,
 			lbs_add_rtap(priv);
 		}
 		priv->monitormode = monitor_mode;
-	}
-
-	else {
+	} else {
 		if (!priv->monitormode)
 			return strlen(buf);
 		priv->monitormode = 0;
@@ -1242,8 +1240,6 @@ int lbs_start_card(struct lbs_private *priv)
 		lbs_pr_err("cannot register ethX device\n");
 		goto done;
 	}
-	if (device_create_file(&dev->dev, &dev_attr_lbs_rtap))
-		lbs_pr_err("cannot register lbs_rtap attribute\n");
 
 	lbs_update_channel(priv);
 
@@ -1275,6 +1271,13 @@ int lbs_start_card(struct lbs_private *priv)
 
 			if (device_create_file(&dev->dev, &dev_attr_lbs_mesh))
 				lbs_pr_err("cannot register lbs_mesh attribute\n");
+
+			/* While rtap isn't related to mesh, only mesh-enabled
+			 * firmware implements the rtap functionality via
+			 * CMD_802_11_MONITOR_MODE.
+			 */
+			if (device_create_file(&dev->dev, &dev_attr_lbs_rtap))
+				lbs_pr_err("cannot register lbs_rtap attribute\n");
 		}
 	}
 
@@ -1306,9 +1309,9 @@ void lbs_stop_card(struct lbs_private *priv)
 	netif_carrier_off(priv->dev);
 
 	lbs_debugfs_remove_one(priv);
-	device_remove_file(&dev->dev, &dev_attr_lbs_rtap);
 	if (priv->mesh_tlv) {
 		device_remove_file(&dev->dev, &dev_attr_lbs_mesh);
+		device_remove_file(&dev->dev, &dev_attr_lbs_rtap);
 	}
 
 	/* Flush pending command nodes */

