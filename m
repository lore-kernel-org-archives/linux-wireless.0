Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:37313 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759346AbZKZJoT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 04:44:19 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH 3/6] libertas: decouple mesh and rtap
Date: Thu, 26 Nov 2009 10:44:13 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200911261044.13371.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While it's might be technically true that only MESH-enabled firmwares
are also RTAP-enabled, I like to have this decoupled. 

Signed-off-by: Holger Schurig <holgerschurig@gmail.com>


--- linux-wl.orig/drivers/net/wireless/libertas/main.c
+++ linux-wl/drivers/net/wireless/libertas/main.c
@@ -1075,6 +1075,17 @@ void lbs_remove_card(struct lbs_private 
 EXPORT_SYMBOL_GPL(lbs_remove_card);
 
 
+static int lbs_rtap_supported(struct lbs_private *priv)
+{
+	if (MRVL_FW_MAJOR_REV(priv->fwrelease) == MRVL_FW_V5)
+		return 1;
+
+	/* newer firmware use a capability mask */
+	return ((MRVL_FW_MAJOR_REV(priv->fwrelease) >= MRVL_FW_V10) &&
+		(priv->fwcapinfo & MESH_CAPINFO_ENABLE_MASK));
+}
+
+
 int lbs_start_card(struct lbs_private *priv)
 {
 	struct net_device *dev = priv->dev;
@@ -1094,12 +1105,14 @@ int lbs_start_card(struct lbs_private *p
 
 	lbs_update_channel(priv);
 
+	lbs_init_mesh(priv);
+
 	/*
 	 * While rtap isn't related to mesh, only mesh-enabled
 	 * firmware implements the rtap functionality via
 	 * CMD_802_11_MONITOR_MODE.
 	 */
-	if (lbs_init_mesh(priv)) {
+	if (lbs_rtap_supported(priv)) {
 		if (device_create_file(&dev->dev, &dev_attr_lbs_rtap))
 			lbs_pr_err("cannot register lbs_rtap attribute\n");
 	}
@@ -1133,7 +1146,9 @@ void lbs_stop_card(struct lbs_private *p
 	netif_carrier_off(dev);
 
 	lbs_debugfs_remove_one(priv);
-	if (lbs_deinit_mesh(priv))
+	lbs_deinit_mesh(priv);
+
+	if (lbs_rtap_supported(priv))
 		device_remove_file(&dev->dev, &dev_attr_lbs_rtap);
 
 	/* Delete the timeout of the currently processing command */

-- 
http://www.holgerschurig.de
