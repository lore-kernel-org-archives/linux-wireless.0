Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:35484 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758061AbYDQQNh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 12:13:37 -0400
Subject: [PATCH] libertas: Fix ethtool statistics
From: David Woodhouse <dwmw2@infradead.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Content-Type: text/plain
Date: Thu, 17 Apr 2008 17:13:34 +0100
Message-Id: <1208448814.9212.270.camel@pmac.infradead.org> (sfid-20080417_171354_772662_FBAACBD7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We removed CMD_MESH_ACCESS from the big case statements and provided
lbs_mesh_access() instead.... but we missed one user. Fix it.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>

diff --git a/drivers/net/wireless/libertas/ethtool.c b/drivers/net/wireless/libertas/ethtool.c
index 21e6f98..9460300 100644
--- a/drivers/net/wireless/libertas/ethtool.c
+++ b/drivers/net/wireless/libertas/ethtool.c
@@ -106,8 +106,8 @@ done:
         return ret;
 }
 
-static void lbs_ethtool_get_stats(struct net_device * dev,
-				struct ethtool_stats * stats, u64 * data)
+static void lbs_ethtool_get_stats(struct net_device *dev,
+				  struct ethtool_stats *stats, u64 *data)
 {
 	struct lbs_private *priv = dev->priv;
 	struct cmd_ds_mesh_access mesh_access;
@@ -116,9 +116,7 @@ static void lbs_ethtool_get_stats(struct net_device * dev,
 	lbs_deb_enter(LBS_DEB_ETHTOOL);
 
 	/* Get Mesh Statistics */
-	ret = lbs_prepare_and_send_command(priv,
-			CMD_MESH_ACCESS, CMD_ACT_MESH_GET_STATS,
-			CMD_OPTION_WAITFORRSP, 0, &mesh_access);
+	ret = lbs_mesh_access(priv, CMD_ACT_MESH_GET_STATS, &mesh_access);
 
 	if (ret)
 		return;

-- 
dwmw2

