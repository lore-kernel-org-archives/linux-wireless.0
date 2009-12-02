Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:65310 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbZLBOaG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2009 09:30:06 -0500
Received: by mail-bw0-f227.google.com with SMTP id 27so217224bwz.21
        for <linux-wireless@vger.kernel.org>; Wed, 02 Dec 2009 06:30:13 -0800 (PST)
Message-Id: <20091202142938.291148553@gmail.com>
References: <20091202142555.654873300@gmail.com>
Date: Wed, 02 Dec 2009 15:26:00 +0100
From: Holger Schurig <holgerschurig@googlemail.com>
To: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: [PATCH 05/10] libertas: move mesh SSID initialization into mesh.c
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
