Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:37430 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbZKZJoq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 04:44:46 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH 4/6] libertas: move mesh SSID initialization into mesh.c
Date: Thu, 26 Nov 2009 10:44:40 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200911261044.40184.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Holger Schurig <holgerschurig@gmail.com>


--- linux-wl.orig/drivers/net/wireless/libertas/main.c
+++ linux-wl/drivers/net/wireless/libertas/main.c
@@ -999,10 +999,6 @@ struct lbs_private *lbs_add_card(void *c
 	INIT_WORK(&priv->mcast_work, lbs_set_mcast_worker);
 	INIT_WORK(&priv->sync_channel, lbs_sync_channel_worker);
 
-	priv->mesh_open = 0;
-	sprintf(priv->mesh_ssid, "mesh");
-	priv->mesh_ssid_len = 4;
-
 	priv->wol_criteria = 0xffffffff;
 	priv->wol_gpio = 0xff;
 
--- linux-wl.orig/drivers/net/wireless/libertas/mesh.c
+++ linux-wl/drivers/net/wireless/libertas/mesh.c
@@ -237,6 +237,9 @@ int lbs_init_mesh(struct lbs_private *pr
 
 
 	if (priv->mesh_tlv) {
+		sprintf(priv->mesh_ssid, "mesh");
+		priv->mesh_ssid_len = 4;
+
 		lbs_add_mesh(priv);
 
 		if (device_create_file(&dev->dev, &dev_attr_lbs_mesh))

-- 
http://www.holgerschurig.de
