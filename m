Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:40105 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752836Ab1GTQyH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 12:54:07 -0400
From: Daniel Drake <dsd@laptop.org>
To: linville@tuxdriver.com
To: dcbw@redhat.com
Cc: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
Subject: [PATCH v2 3/3] libertas: reimplement mesh channel selection
Message-Id: <20110720165403.52B629D401C@zog.reactivated.net> (sfid-20110720_185415_016035_B7D3DC76)
Date: Wed, 20 Jul 2011 17:54:03 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reimplements code allowing for mesh channel selection according
to how NetworkManager expects.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/libertas/dev.h  |    1 +
 drivers/net/wireless/libertas/mesh.c |   76 +++++++++++++++++++++++++++++----
 2 files changed, 67 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index adb3490..86494b0 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -48,6 +48,7 @@ struct lbs_private {
 	uint16_t mesh_tlv;
 	u8 mesh_ssid[IEEE80211_MAX_SSID_LEN + 1];
 	u8 mesh_ssid_len;
+	short mesh_channel;
 #endif
 
 	/* Debugfs */
diff --git a/drivers/net/wireless/libertas/mesh.c b/drivers/net/wireless/libertas/mesh.c
index be72c08..87d1049 100644
--- a/drivers/net/wireless/libertas/mesh.c
+++ b/drivers/net/wireless/libertas/mesh.c
@@ -123,7 +123,7 @@ static int lbs_mesh_config(struct lbs_private *priv, uint16_t action,
 		return -1;
 	}
 	lbs_deb_cmd("mesh config action %d type %x channel %d SSID %s\n",
-		    action, priv->mesh_tlv, chan,
+		    action, priv->mesh_tlv, priv->mesh_channel,
 		    print_ssid(ssid, priv->mesh_ssid, priv->mesh_ssid_len));
 
 	return __lbs_mesh_config_send(priv, &cmd, action, priv->mesh_tlv);
@@ -803,6 +803,62 @@ static void lbs_persist_config_remove(struct net_device *dev)
 
 
 /***************************************************************************
+ * WEXT handlers
+ */
+
+static int mesh_get_name(struct net_device *dev,
+    struct iw_request_info *info, char *name, char *extra)
+{
+	strcpy(name, "IEEE 802.11b/g");
+	return 0;
+}
+
+static int mesh_get_freq(struct net_device *dev,
+    struct iw_request_info *info, struct iw_freq *freq, char *extra)
+{
+	struct lbs_private *priv = dev->ml_priv;
+	freq->e = 0;
+	freq->m = priv->mesh_channel;
+	return 0;
+}
+
+static int mesh_set_freq(struct net_device *dev,
+    struct iw_request_info *info, struct iw_freq *freq, char *extra)
+{
+	struct lbs_private *priv = dev->ml_priv;
+	short channel = 0;
+
+	if (freq->e == 0)
+		channel = freq->m;
+	else {
+		channel = ieee80211_freq_to_dsss_chan(freq->m);
+		if (channel < 0)
+			channel = 1;
+	}
+
+	priv->mesh_channel = channel;
+
+	if (netif_running(dev))
+		lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
+				priv->mesh_channel);
+
+	return 0;
+}
+
+static const iw_handler mesh_iw_handler[] =
+{
+	IW_HANDLER(SIOCGIWNAME, (iw_handler) mesh_get_name),
+	IW_HANDLER(SIOCGIWFREQ, (iw_handler) mesh_get_freq),
+	IW_HANDLER(SIOCSIWFREQ, (iw_handler) mesh_set_freq),
+};
+
+static const struct iw_handler_def mesh_iw_handler_def = {
+	.num_standard	= ARRAY_SIZE(mesh_iw_handler),
+	.standard 	= mesh_iw_handler,
+};
+
+
+/***************************************************************************
  * Initializing and starting, stopping mesh
  */
 
@@ -837,11 +893,9 @@ int lbs_init_mesh(struct lbs_private *priv)
 		   useful */
 
 		priv->mesh_tlv = TLV_TYPE_OLD_MESH_ID;
-		if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
-				    priv->channel)) {
+		if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START, 1)) {
 			priv->mesh_tlv = TLV_TYPE_MESH_ID;
-			if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
-					    priv->channel))
+			if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START, 1))
 				priv->mesh_tlv = 0;
 		}
 	} else
@@ -851,13 +905,12 @@ int lbs_init_mesh(struct lbs_private *priv)
 		 * 0x100+37; Do not invoke command with old TLV.
 		 */
 		priv->mesh_tlv = TLV_TYPE_MESH_ID;
-		if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
-				    priv->channel))
+		if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START, 1))
 			priv->mesh_tlv = 0;
 	}
 
 	/* Stop meshing until interface is brought up */
-	lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_STOP, priv->channel);
+	lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_STOP, 1);
 
 	if (priv->mesh_tlv) {
 		sprintf(priv->mesh_ssid, "mesh");
@@ -904,7 +957,7 @@ static int lbs_mesh_stop(struct net_device *dev)
 	struct lbs_private *priv = dev->ml_priv;
 
 	lbs_deb_enter(LBS_DEB_MESH);
-	lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_STOP, priv->channel);
+	lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_STOP, priv->mesh_channel);
 
 	spin_lock_irq(&priv->driver_lock);
 
@@ -947,7 +1000,8 @@ static int lbs_mesh_dev_open(struct net_device *dev)
 
 	spin_unlock_irq(&priv->driver_lock);
 
-	ret = lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START, priv->channel);
+	ret = lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
+			      priv->mesh_channel);
 
 out:
 	lbs_deb_leave_args(LBS_DEB_NET, "ret %d", ret);
@@ -984,8 +1038,10 @@ static int lbs_add_mesh(struct lbs_private *priv)
 	}
 	mesh_dev->ml_priv = priv;
 	priv->mesh_dev = mesh_dev;
+	priv->mesh_channel = 1;
 
 	mesh_dev->netdev_ops = &mesh_netdev_ops;
+	mesh_dev->wireless_handlers = &mesh_iw_handler_def;
 	mesh_dev->ethtool_ops = &lbs_ethtool_ops;
 	memcpy(mesh_dev->dev_addr, priv->dev->dev_addr, ETH_ALEN);
 
-- 
1.7.6

