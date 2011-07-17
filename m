Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:29111 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756064Ab1GQRDn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 13:03:43 -0400
From: Daniel Drake <dsd@laptop.org>
To: linville@tuxdriver.com
To: dcbw@redhat.com
Cc: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
Subject: [PATCH 3/4] libertas: only enable mesh when interface is active
Message-Id: <20110717170339.BA1BB9D401D@zog.reactivated.net> (sfid-20110717_190345_192956_1F84CA16)
Date: Sun, 17 Jul 2011 18:03:39 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, the mesh was running whenever the appropriate hardware
and firmware was present.

Now we only run the mesh when the interface is running.

Also simplifies interface management a little.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/libertas/dev.h  |    2 --
 drivers/net/wireless/libertas/main.c |    2 +-
 drivers/net/wireless/libertas/mesh.c |   23 +++++++++--------------
 drivers/net/wireless/libertas/mesh.h |    7 -------
 drivers/net/wireless/libertas/tx.c   |    2 +-
 5 files changed, 11 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 094e1f2..8a43ec0 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -44,9 +44,7 @@ struct lbs_private {
 	/* Mesh */
 	struct net_device *mesh_dev; /* Virtual device */
 #ifdef CONFIG_LIBERTAS_MESH
-	u32 mesh_connect_status;
 	struct lbs_mesh_stats mstats;
-	int mesh_open;
 	uint16_t mesh_tlv;
 	u8 mesh_ssid[IEEE80211_MAX_SSID_LEN + 1];
 	u8 mesh_ssid_len;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 4b086cd..6723c67 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -512,7 +512,7 @@ static int lbs_thread(void *data)
 				if (priv->connect_status == LBS_CONNECTED)
 					netif_wake_queue(priv->dev);
 				if (priv->mesh_dev &&
-				    lbs_mesh_connected(priv))
+				    netif_running(priv->mesh_dev))
 					netif_wake_queue(priv->mesh_dev);
 			}
 		}
diff --git a/drivers/net/wireless/libertas/mesh.c b/drivers/net/wireless/libertas/mesh.c
index a20419d..be72c08 100644
--- a/drivers/net/wireless/libertas/mesh.c
+++ b/drivers/net/wireless/libertas/mesh.c
@@ -270,17 +270,11 @@ static ssize_t lbs_mesh_set(struct device *dev,
 {
 	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
 	int enable;
-	int ret, action = CMD_ACT_MESH_CONFIG_STOP;
 
 	sscanf(buf, "%x", &enable);
 	enable = !!enable;
 	if (enable == !!priv->mesh_dev)
 		return count;
-	if (enable)
-		action = CMD_ACT_MESH_CONFIG_START;
-	ret = lbs_mesh_config(priv, action, priv->channel);
-	if (ret)
-		return ret;
 
 	if (enable)
 		lbs_add_mesh(priv);
@@ -823,8 +817,6 @@ int lbs_init_mesh(struct lbs_private *priv)
 
 	lbs_deb_enter(LBS_DEB_MESH);
 
-	priv->mesh_connect_status = LBS_DISCONNECTED;
-
 	/* Determine mesh_fw_ver from fwrelease and fwcapinfo */
 	/* 5.0.16p0 9.0.0.p0 is known to NOT support any mesh */
 	/* 5.110.22 have mesh command with 0xa3 command id */
@@ -864,6 +856,8 @@ int lbs_init_mesh(struct lbs_private *priv)
 			priv->mesh_tlv = 0;
 	}
 
+	/* Stop meshing until interface is brought up */
+	lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_STOP, priv->channel);
 
 	if (priv->mesh_tlv) {
 		sprintf(priv->mesh_ssid, "mesh");
@@ -910,10 +904,9 @@ static int lbs_mesh_stop(struct net_device *dev)
 	struct lbs_private *priv = dev->ml_priv;
 
 	lbs_deb_enter(LBS_DEB_MESH);
-	spin_lock_irq(&priv->driver_lock);
+	lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_STOP, priv->channel);
 
-	priv->mesh_open = 0;
-	priv->mesh_connect_status = LBS_DISCONNECTED;
+	spin_lock_irq(&priv->driver_lock);
 
 	netif_stop_queue(dev);
 	netif_carrier_off(dev);
@@ -943,18 +936,20 @@ static int lbs_mesh_dev_open(struct net_device *dev)
 
 	if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR) {
 		ret = -EBUSY;
+		spin_unlock_irq(&priv->driver_lock);
 		goto out;
 	}
 
-	priv->mesh_open = 1;
-	priv->mesh_connect_status = LBS_CONNECTED;
 	netif_carrier_on(dev);
 
 	if (!priv->tx_pending_len)
 		netif_wake_queue(dev);
- out:
 
 	spin_unlock_irq(&priv->driver_lock);
+
+	ret = lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START, priv->channel);
+
+out:
 	lbs_deb_leave_args(LBS_DEB_NET, "ret %d", ret);
 	return ret;
 }
diff --git a/drivers/net/wireless/libertas/mesh.h b/drivers/net/wireless/libertas/mesh.h
index 7d3dd81..5014491 100644
--- a/drivers/net/wireless/libertas/mesh.h
+++ b/drivers/net/wireless/libertas/mesh.h
@@ -63,11 +63,6 @@ void lbs_mesh_ethtool_get_strings(struct net_device *dev,
 	uint32_t stringset, uint8_t *s);
 
 
-/* Accessors */
-
-#define lbs_mesh_open(priv) (priv->mesh_open)
-#define lbs_mesh_connected(priv) (priv->mesh_connect_status == LBS_CONNECTED)
-
 #else
 
 #define lbs_init_mesh(priv)
@@ -77,8 +72,6 @@ void lbs_mesh_ethtool_get_strings(struct net_device *dev,
 #define lbs_mesh_set_dev(priv, dev, rxpd) (dev)
 #define lbs_mesh_set_txpd(priv, dev, txpd)
 #define lbs_mesh_config(priv, enable, chan)
-#define lbs_mesh_open(priv) (0)
-#define lbs_mesh_connected(priv) (0)
 
 #endif
 
diff --git a/drivers/net/wireless/libertas/tx.c b/drivers/net/wireless/libertas/tx.c
index f19495b..a6e8513 100644
--- a/drivers/net/wireless/libertas/tx.c
+++ b/drivers/net/wireless/libertas/tx.c
@@ -199,7 +199,7 @@ void lbs_send_tx_feedback(struct lbs_private *priv, u32 try_count)
 	if (priv->connect_status == LBS_CONNECTED)
 		netif_wake_queue(priv->dev);
 
-	if (priv->mesh_dev && lbs_mesh_connected(priv))
+	if (priv->mesh_dev && netif_running(priv->mesh_dev))
 		netif_wake_queue(priv->mesh_dev);
 }
 EXPORT_SYMBOL_GPL(lbs_send_tx_feedback);
-- 
1.7.6

