Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47154 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbYESPcH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 11:32:07 -0400
Subject: [PATCH] libertas: Fix ethtool statistics
From: David Woodhouse <dwmw2@infradead.org>
To: linville@tuxdriver.com
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Sebastian Siewior <liber+tas@ml.breakpoint.cc>
Content-Type: text/plain
Date: Mon, 19 May 2008 16:32:02 +0100
Message-Id: <1211211122.21380.167.camel@pmac.infradead.org> (sfid-20080519_173211_895707_E91E7BC4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix various problems:
 - We converted MESH_ACCESS to a direct command but missed this caller.
 - We were trying to access mesh stats even on meshless firmware.
 - We should really zero the buffer if something goes wrong.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>

diff --git a/drivers/net/wireless/libertas/ethtool.c b/drivers/net/wireless/libertas/ethtool.c
index dcfdb40..688d60d 100644
--- a/drivers/net/wireless/libertas/ethtool.c
+++ b/drivers/net/wireless/libertas/ethtool.c
@@ -73,8 +73,8 @@ out:
         return ret;
 }
 
-static void lbs_ethtool_get_stats(struct net_device * dev,
-				struct ethtool_stats * stats, u64 * data)
+static void lbs_ethtool_get_stats(struct net_device *dev,
+				  struct ethtool_stats *stats, uint64_t *data)
 {
 	struct lbs_private *priv = dev->priv;
 	struct cmd_ds_mesh_access mesh_access;
@@ -83,12 +83,12 @@ static void lbs_ethtool_get_stats(struct net_device * dev,
 	lbs_deb_enter(LBS_DEB_ETHTOOL);
 
 	/* Get Mesh Statistics */
-	ret = lbs_prepare_and_send_command(priv,
-			CMD_MESH_ACCESS, CMD_ACT_MESH_GET_STATS,
-			CMD_OPTION_WAITFORRSP, 0, &mesh_access);
+	ret = lbs_mesh_access(priv, CMD_ACT_MESH_GET_STATS, &mesh_access);
 
-	if (ret)
+	if (ret) {
+		memset(data, 0, MESH_STATS_NUM*(sizeof(uint64_t)));
 		return;
+	}
 
 	priv->mstats.fwd_drop_rbt = le32_to_cpu(mesh_access.data[0]);
 	priv->mstats.fwd_drop_ttl = le32_to_cpu(mesh_access.data[1]);
@@ -111,19 +111,18 @@ static void lbs_ethtool_get_stats(struct net_device * dev,
 	lbs_deb_enter(LBS_DEB_ETHTOOL);
 }
 
-static int lbs_ethtool_get_sset_count(struct net_device * dev, int sset)
+static int lbs_ethtool_get_sset_count(struct net_device *dev, int sset)
 {
-	switch (sset) {
-	case ETH_SS_STATS:
+	struct lbs_private *priv = dev->priv;
+
+	if (sset == ETH_SS_STATS && dev == priv->mesh_dev)
 		return MESH_STATS_NUM;
-	default:
-		return -EOPNOTSUPP;
-	}
+
+	return -EOPNOTSUPP;
 }
 
 static void lbs_ethtool_get_strings(struct net_device *dev,
-					  u32 stringset,
-					  u8 * s)
+				    uint32_t stringset, uint8_t *s)
 {
 	int i;
 

-- 
dwmw2

