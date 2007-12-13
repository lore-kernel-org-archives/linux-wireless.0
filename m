Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:56008 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762777AbXLMHAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 02:00:11 -0500
Subject: [PATCH 95/48] libertas: pass channel argument directly to lbs_mesh_config()
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i3O-0005um-CC@shinybook.infradead.org> (sfid-20071213_070639_505735_A996C59E)
Date: Thu, 13 Dec 2007 02:00:18 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Thu, 13 Dec 2007 00:32:36 -0500

There is weirdness here; the firmware seems to refuse to change channels
at will.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/assoc.c |   11 ++++++-----
 drivers/net/wireless/libertas/cmd.c   |    6 +++---
 drivers/net/wireless/libertas/cmd.h   |    2 +-
 drivers/net/wireless/libertas/main.c  |    6 +++---
 drivers/net/wireless/libertas/wext.c  |    7 +++----
 5 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index ff976eb..cd8e043 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -205,13 +205,14 @@ static int assoc_helper_channel(struct lbs_private *priv,
 		goto done;
 
 	if (priv->mesh_dev) {
-		/* Disconnect mesh while associating -- otherwise it
-		   won't let us change channels */
-		lbs_mesh_config(priv, 0);
+		/* Change mesh channel first; 21.p21 firmware won't let
+		   you change channel otherwise (even though it'll return
+		   an error to this */
+		lbs_mesh_config(priv, 0, assoc_req->channel);
 	}
 
 	lbs_deb_assoc("ASSOC: channel: %d -> %d\n",
-	       priv->curbssparams.channel, assoc_req->channel);
+		      priv->curbssparams.channel, assoc_req->channel);
 
 	ret = lbs_set_channel(priv, assoc_req->channel);
 	if (ret < 0)
@@ -244,7 +245,7 @@ static int assoc_helper_channel(struct lbs_private *priv,
 
  restore_mesh:
 	if (priv->mesh_dev)
-		lbs_mesh_config(priv, 1);
+		lbs_mesh_config(priv, 1, priv->curbssparams.channel);
 
  done:
 	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index c4299ae..171acc2 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1114,13 +1114,13 @@ int lbs_mesh_access(struct lbs_private *priv, uint16_t cmd_action,
 }
 EXPORT_SYMBOL_GPL(lbs_mesh_access);
 
-int lbs_mesh_config(struct lbs_private *priv, int enable)
+int lbs_mesh_config(struct lbs_private *priv, uint16_t enable, uint16_t chan)
 {
 	struct cmd_ds_mesh_config cmd;
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.action = cpu_to_le16(enable);
-	cmd.channel = cpu_to_le16(priv->curbssparams.channel);
+	cmd.channel = cpu_to_le16(chan);
 	cmd.type = cpu_to_le16(priv->mesh_tlv);
 	
 	if (enable) {
@@ -1128,7 +1128,7 @@ int lbs_mesh_config(struct lbs_private *priv, int enable)
 		memcpy(cmd.data, priv->mesh_ssid, priv->mesh_ssid_len);
 	}
 	lbs_deb_cmd("mesh config enable %d TLV %x channel %d SSID %s\n",
-		    enable, priv->mesh_tlv, priv->curbssparams.channel,
+		    enable, priv->mesh_tlv, chan,
 		    escape_essid(priv->mesh_ssid, priv->mesh_ssid_len));
 	return lbs_cmd_with_response(priv, CMD_MESH_CONFIG, &cmd);
 }
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index 55f2436..a4aaa6b 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -31,7 +31,7 @@ int lbs_set_data_rate(struct lbs_private *priv, u8 rate);
 int lbs_get_channel(struct lbs_private *priv);
 int lbs_set_channel(struct lbs_private *priv, u8 channel);
 
-int lbs_mesh_config(struct lbs_private *priv, int enable);
+int lbs_mesh_config(struct lbs_private *priv, uint16_t enable, uint16_t chan);
 
 int lbs_host_sleep_cfg(struct lbs_private *priv, uint32_t criteria);
 int lbs_suspend(struct lbs_private *priv);
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 2409df8..9232b97 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -344,7 +344,7 @@ static ssize_t lbs_mesh_set(struct device *dev,
 	if (enable == !!priv->mesh_dev)
 		return count;
 
-	ret = lbs_mesh_config(priv, enable);
+	ret = lbs_mesh_config(priv, enable, priv->curbssparams.channel);
 	if (ret)
 		return ret;
 		
@@ -1187,9 +1187,9 @@ int lbs_start_card(struct lbs_private *priv)
 
 	lbs_update_channel(priv);
 	priv->mesh_tlv = 0x100 + 291;
-	if (lbs_mesh_config(priv, 1)) {
+	if (lbs_mesh_config(priv, 1, priv->curbssparams.channel)) {
 		priv->mesh_tlv = 0x100 + 37;
-		if (lbs_mesh_config(priv, 1))
+		if (lbs_mesh_config(priv, 1, priv->curbssparams.channel))
 			priv->mesh_tlv = 0;
 	}
 	if (priv->mesh_tlv) {
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index 262d4cc..b1e2472 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -1000,9 +1000,8 @@ static int lbs_mesh_set_freq(struct net_device *dev,
 		else if (priv->mode == IW_MODE_ADHOC)
 			lbs_stop_adhoc_network(priv);
 	}
-	priv->curbssparams.channel = fwrq->m;
-	lbs_mesh_config(priv, 0);
-	lbs_mesh_config(priv, 1);
+	lbs_mesh_config(priv, 1, fwrq->m);
+	lbs_update_channel(priv);
 	ret = 0;
 
 out:
@@ -2010,7 +2009,7 @@ static int lbs_mesh_set_essid(struct net_device *dev,
 		priv->mesh_ssid_len = dwrq->length;
 	}
 
-	lbs_mesh_config(priv, 1);
+	lbs_mesh_config(priv, 1, priv->curbssparams.channel);
  out:
 	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
 	return ret;
-- 
1.5.3.4

