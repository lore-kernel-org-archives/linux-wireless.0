Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57733 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762838AbXLMG75 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:57 -0500
Subject: [PATCH 88/48] libertas: switch lbs_cmd() to take a _pointer_ to the command structure
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i3D-0005uD-I8@shinybook.infradead.org> (sfid-20071213_070021_231121_B67825B2)
Date: Thu, 13 Dec 2007 02:00:07 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Wed, 12 Dec 2007 16:00:42 -0500

This way, it looks more like a normal function.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c    |   17 +++++++++--------
 drivers/net/wireless/libertas/cmd.h    |   10 ++++------
 drivers/net/wireless/libertas/if_usb.c |    2 +-
 3 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 2d7b646..f87cecb 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -56,7 +56,7 @@ int lbs_update_hw_spec(struct lbs_private *priv)
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 	memcpy(cmd.permanentaddr, priv->current_addr, ETH_ALEN);
-	ret = lbs_cmd_with_response(priv, CMD_GET_HW_SPEC, cmd);
+	ret = lbs_cmd_with_response(priv, CMD_GET_HW_SPEC, &cmd);
 	if (ret)
 		goto out;
 
@@ -121,7 +121,7 @@ int lbs_host_sleep_cfg(struct lbs_private *priv, uint32_t criteria,
 	cmd_config.gpio = gpio;
 	cmd_config.gap = gap;
 
-	ret = lbs_cmd_with_response(priv, CMD_802_11_HOST_SLEEP_CFG, cmd_config);
+	ret = lbs_cmd_with_response(priv, CMD_802_11_HOST_SLEEP_CFG, &cmd_config);
 	if (ret) {
 		lbs_pr_info("HOST_SLEEP_CFG failed %d\n", ret);
 		return ret;
@@ -743,7 +743,7 @@ int lbs_get_data_rate(struct lbs_private *priv)
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 	cmd.action = cpu_to_le16(CMD_ACT_GET_TX_RATE);
 
-	ret = lbs_cmd_with_response(priv, CMD_802_11_DATA_RATE, cmd);
+	ret = lbs_cmd_with_response(priv, CMD_802_11_DATA_RATE, &cmd);
 	if (ret)
 		goto out;
 
@@ -790,7 +790,7 @@ int lbs_set_data_rate(struct lbs_private *priv, u8 rate)
 		lbs_deb_cmd("DATA_RATE: setting auto\n");
 	}
 
-	ret = lbs_cmd_with_response(priv, CMD_802_11_DATA_RATE, cmd);
+	ret = lbs_cmd_with_response(priv, CMD_802_11_DATA_RATE, &cmd);
 	if (ret)
 		goto out;
 
@@ -846,7 +846,7 @@ int lbs_get_channel(struct lbs_private *priv)
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 	cmd.action = cpu_to_le16(CMD_OPT_802_11_RF_CHANNEL_GET);
 
-	ret = lbs_cmd_with_response(priv, CMD_802_11_RF_CHANNEL, cmd);
+	ret = lbs_cmd_with_response(priv, CMD_802_11_RF_CHANNEL, &cmd);
 	if (ret)
 		goto out;
 
@@ -878,7 +878,7 @@ int lbs_set_channel(struct lbs_private *priv, u8 channel)
 	cmd.action = cpu_to_le16(CMD_OPT_802_11_RF_CHANNEL_SET);
 	cmd.channel = cpu_to_le16(channel);
 
-	ret = lbs_cmd_with_response(priv, CMD_802_11_RF_CHANNEL, cmd);
+	ret = lbs_cmd_with_response(priv, CMD_802_11_RF_CHANNEL, &cmd);
 	if (ret)
 		goto out;
 
@@ -1105,7 +1105,7 @@ int lbs_mesh_access(struct lbs_private *priv, uint16_t cmd_action,
 
 	cmd->action = cpu_to_le16(cmd_action);
 
-	ret = lbs_cmd_with_response(priv, CMD_MESH_ACCESS, (*cmd));
+	ret = lbs_cmd_with_response(priv, CMD_MESH_ACCESS, cmd);
 
 	lbs_deb_leave(LBS_DEB_CMD);
 	return ret;
@@ -1128,7 +1128,7 @@ int lbs_mesh_config(struct lbs_private *priv, int enable)
 	lbs_deb_cmd("mesh config channel %d SSID %s\n",
 		    priv->curbssparams.channel,
 		    escape_essid(priv->mesh_ssid, priv->mesh_ssid_len));
-	return lbs_cmd_with_response(priv, CMD_MESH_CONFIG, cmd);
+	return lbs_cmd_with_response(priv, CMD_MESH_CONFIG, &cmd);
 }
 
 static int lbs_cmd_bcn_ctrl(struct lbs_private * priv,
@@ -2160,6 +2160,7 @@ int lbs_cmd_copyback(struct lbs_private *priv, unsigned long extra,
 	lbs_deb_leave(LBS_DEB_CMD);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(lbs_cmd_copyback);
 
 /**
  *  @brief Simple way to call firmware functions
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index 8d72c7e..e800295 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -6,13 +6,11 @@
 #include "hostcmd.h"
 #include "dev.h"
 
-#define lbs_cmd(priv, cmdnr, cmd, callback, callback_arg) \
-	__lbs_cmd(priv, cmdnr, &(cmd).hdr, sizeof(cmd),	  \
-			callback, callback_arg)
+#define lbs_cmd(priv, cmdnr, cmd, cb, cb_arg)	\
+	__lbs_cmd(priv, cmdnr, &(cmd)->hdr, sizeof(*(cmd)), cb, cb_arg)
 
-#define lbs_cmd_with_response(priv, cmdnr, cmd) \
-	__lbs_cmd(priv, cmdnr, &(cmd).hdr, sizeof(cmd), \
-		  lbs_cmd_copyback, (unsigned long) &cmd)
+#define lbs_cmd_with_response(priv, cmdnr, cmd)	\
+	lbs_cmd(priv, cmdnr, cmd, lbs_cmd_copyback, (unsigned long) (cmd))
  
 int __lbs_cmd(struct lbs_private *priv, uint16_t command,
 	      struct cmd_header *in_cmd, int in_cmd_size, 
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 3f8b83c..74fec9d 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -109,7 +109,7 @@ static void if_usb_set_boot2_ver(struct lbs_private *priv)
 	b2_cmd.action = 0;
 	b2_cmd.version = priv->boot2_version;
 
-	if (lbs_cmd(priv, CMD_SET_BOOT2_VER, b2_cmd, NULL, 0))
+	if (lbs_cmd(priv, CMD_SET_BOOT2_VER, &b2_cmd, NULL, 0))
 		lbs_deb_usb("Setting boot2 version failed\n");
 }
 
-- 
1.5.3.4

