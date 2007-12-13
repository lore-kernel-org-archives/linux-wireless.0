Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55999 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762689AbXLMHAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 02:00:09 -0500
Subject: [PATCH 94/48] libertas: cope with both old and new mesh TLV values
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i3N-0005uh-8w@shinybook.infradead.org> (sfid-20071213_070640_481077_FB8920EA)
Date: Thu, 13 Dec 2007 02:00:17 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Wed, 12 Dec 2007 23:29:13 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c  |    6 +++---
 drivers/net/wireless/libertas/dev.h  |    2 ++
 drivers/net/wireless/libertas/main.c |   32 +++++++++++++++++++++++++++++---
 3 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index ddf1527..c4299ae 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1121,14 +1121,14 @@ int lbs_mesh_config(struct lbs_private *priv, int enable)
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.action = cpu_to_le16(enable);
 	cmd.channel = cpu_to_le16(priv->curbssparams.channel);
-	cmd.type = cpu_to_le16(0x100 + 37);
+	cmd.type = cpu_to_le16(priv->mesh_tlv);
 	
 	if (enable) {
 		cmd.length = cpu_to_le16(priv->mesh_ssid_len);
 		memcpy(cmd.data, priv->mesh_ssid, priv->mesh_ssid_len);
 	}
-	lbs_deb_cmd("mesh config channel %d SSID %s\n",
-		    priv->curbssparams.channel,
+	lbs_deb_cmd("mesh config enable %d TLV %x channel %d SSID %s\n",
+		    enable, priv->mesh_tlv, priv->curbssparams.channel,
 		    escape_essid(priv->mesh_ssid, priv->mesh_ssid_len));
 	return lbs_cmd_with_response(priv, CMD_MESH_CONFIG, &cmd);
 }
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 60a6a51..e6f553d 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -206,6 +206,8 @@ struct lbs_private {
 
 	/** current ssid/bssid related parameters*/
 	struct current_bss_params curbssparams;
+
+	uint16_t mesh_tlv;
 	u8 mesh_ssid[IW_ESSID_MAX_SIZE + 1];
 	u8 mesh_ssid_len;
 
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 5e2f329..2409df8 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1171,8 +1171,33 @@ int lbs_start_card(struct lbs_private *priv)
 	}
 	if (device_create_file(&dev->dev, &dev_attr_lbs_rtap))
 		lbs_pr_err("cannot register lbs_rtap attribute\n");
-	if (device_create_file(&dev->dev, &dev_attr_lbs_mesh))
-		lbs_pr_err("cannot register lbs_mesh attribute\n");
+
+	/* Enable mesh, if supported, and work out which TLV it uses.
+	   0x100 + 291 is an unofficial value used in 5.110.20.pXX
+	   0x100 + 37 is the official value used in 5.110.21.pXX
+	   but we check them in that order because 20.pXX doesn't 
+	   give an error -- it just silently fails. */
+
+	/* 5.110.20.pXX firmware will fail the command if the channel
+	   doesn't match the existing channel. But only if the TLV
+	   is correct. If the channel is wrong, _BOTH_ versions will
+	   give an error to 0x100+291, and allow 0x100+37 to succeed.
+	   It's just that 5.110.20.pXX will not have done anything
+	   useful */
+
+	lbs_update_channel(priv);
+	priv->mesh_tlv = 0x100 + 291;
+	if (lbs_mesh_config(priv, 1)) {
+		priv->mesh_tlv = 0x100 + 37;
+		if (lbs_mesh_config(priv, 1))
+			priv->mesh_tlv = 0;
+	}
+	if (priv->mesh_tlv) {
+		lbs_add_mesh(priv);
+
+		if (device_create_file(&dev->dev, &dev_attr_lbs_mesh))
+			lbs_pr_err("cannot register lbs_mesh attribute\n");
+	}
 
 	lbs_debugfs_init_one(priv, dev);
 
@@ -1201,7 +1226,8 @@ int lbs_stop_card(struct lbs_private *priv)
 
 	lbs_debugfs_remove_one(priv);
 	device_remove_file(&dev->dev, &dev_attr_lbs_rtap);
-	device_remove_file(&dev->dev, &dev_attr_lbs_mesh);
+	if (priv->mesh_tlv)
+		device_remove_file(&dev->dev, &dev_attr_lbs_mesh);
 
 	/* Flush pending command nodes */
 	spin_lock_irqsave(&priv->driver_lock, flags);
-- 
1.5.3.4

