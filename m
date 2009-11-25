Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:50504 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758721AbZKYMKz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 07:10:55 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH 4/5] libertas: move mesh-only ethtool operations into mesh.c
Date: Wed, 25 Nov 2009 13:10:49 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200911251310.49125.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Holger Schurig <holgerschurig@gmail.com>

--- linux-wl.orig/drivers/net/wireless/libertas/ethtool.c
+++ linux-wl/drivers/net/wireless/libertas/ethtool.c
@@ -8,17 +8,8 @@
 #include "dev.h"
 #include "wext.h"
 #include "cmd.h"
+#include "mesh.h"
 
-static const char * mesh_stat_strings[]= {
-			"drop_duplicate_bcast",
-			"drop_ttl_zero",
-			"drop_no_fwd_route",
-			"drop_no_buffers",
-			"fwded_unicast_cnt",
-			"fwded_bcast_cnt",
-			"drop_blind_table",
-			"tx_failed_cnt"
-};
 
 static void lbs_ethtool_get_drvinfo(struct net_device *dev,
 					 struct ethtool_drvinfo *info)
@@ -73,73 +64,6 @@
         return ret;
 }
 
-static void lbs_ethtool_get_stats(struct net_device *dev,
-				  struct ethtool_stats *stats, uint64_t *data)
-{
-	struct lbs_private *priv = dev->ml_priv;
-	struct cmd_ds_mesh_access mesh_access;
-	int ret;
-
-	lbs_deb_enter(LBS_DEB_ETHTOOL);
-
-	/* Get Mesh Statistics */
-	ret = lbs_mesh_access(priv, CMD_ACT_MESH_GET_STATS, &mesh_access);
-
-	if (ret) {
-		memset(data, 0, MESH_STATS_NUM*(sizeof(uint64_t)));
-		return;
-	}
-
-	priv->mstats.fwd_drop_rbt = le32_to_cpu(mesh_access.data[0]);
-	priv->mstats.fwd_drop_ttl = le32_to_cpu(mesh_access.data[1]);
-	priv->mstats.fwd_drop_noroute = le32_to_cpu(mesh_access.data[2]);
-	priv->mstats.fwd_drop_nobuf = le32_to_cpu(mesh_access.data[3]);
-	priv->mstats.fwd_unicast_cnt = le32_to_cpu(mesh_access.data[4]);
-	priv->mstats.fwd_bcast_cnt = le32_to_cpu(mesh_access.data[5]);
-	priv->mstats.drop_blind = le32_to_cpu(mesh_access.data[6]);
-	priv->mstats.tx_failed_cnt = le32_to_cpu(mesh_access.data[7]);
-
-	data[0] = priv->mstats.fwd_drop_rbt;
-	data[1] = priv->mstats.fwd_drop_ttl;
-	data[2] = priv->mstats.fwd_drop_noroute;
-	data[3] = priv->mstats.fwd_drop_nobuf;
-	data[4] = priv->mstats.fwd_unicast_cnt;
-	data[5] = priv->mstats.fwd_bcast_cnt;
-	data[6] = priv->mstats.drop_blind;
-	data[7] = priv->mstats.tx_failed_cnt;
-
-	lbs_deb_enter(LBS_DEB_ETHTOOL);
-}
-
-static int lbs_ethtool_get_sset_count(struct net_device *dev, int sset)
-{
-	struct lbs_private *priv = dev->ml_priv;
-
-	if (sset == ETH_SS_STATS && dev == priv->mesh_dev)
-		return MESH_STATS_NUM;
-
-	return -EOPNOTSUPP;
-}
-
-static void lbs_ethtool_get_strings(struct net_device *dev,
-				    uint32_t stringset, uint8_t *s)
-{
-	int i;
-
-	lbs_deb_enter(LBS_DEB_ETHTOOL);
-
-	switch (stringset) {
-        case ETH_SS_STATS:
-		for (i=0; i < MESH_STATS_NUM; i++) {
-			memcpy(s + i * ETH_GSTRING_LEN,
-					mesh_stat_strings[i],
-					ETH_GSTRING_LEN);
-		}
-		break;
-        }
-	lbs_deb_enter(LBS_DEB_ETHTOOL);
-}
-
 static void lbs_ethtool_get_wol(struct net_device *dev,
 				struct ethtool_wolinfo *wol)
 {
@@ -187,9 +111,9 @@
 	.get_drvinfo = lbs_ethtool_get_drvinfo,
 	.get_eeprom =  lbs_ethtool_get_eeprom,
 	.get_eeprom_len = lbs_ethtool_get_eeprom_len,
-	.get_sset_count = lbs_ethtool_get_sset_count,
-	.get_ethtool_stats = lbs_ethtool_get_stats,
-	.get_strings = lbs_ethtool_get_strings,
+	.get_sset_count = lbs_mesh_ethtool_get_sset_count,
+	.get_ethtool_stats = lbs_mesh_ethtool_get_stats,
+	.get_strings = lbs_mesh_ethtool_get_strings,
 	.get_wol = lbs_ethtool_get_wol,
 	.set_wol = lbs_ethtool_set_wol,
 };
--- linux-wl.orig/drivers/net/wireless/libertas/mesh.h
+++ linux-wl/drivers/net/wireless/libertas/mesh.h
@@ -53,4 +53,15 @@
 extern struct iw_handler_def mesh_handler_def;
 
 
+/* Ethtool statistics */
+
+struct ethtool_stats;
+
+void lbs_mesh_ethtool_get_stats(struct net_device *dev,
+	struct ethtool_stats *stats, uint64_t *data);
+int lbs_mesh_ethtool_get_sset_count(struct net_device *dev, int sset);
+void lbs_mesh_ethtool_get_strings(struct net_device *dev,
+	uint32_t stringset, uint8_t *s);
+
+
 #endif
--- linux-wl.orig/drivers/net/wireless/libertas/mesh.c
+++ linux-wl/drivers/net/wireless/libertas/mesh.c
@@ -880,3 +880,87 @@
 	sysfs_remove_group(&(dev->dev.kobj), &boot_opts_group);
 	sysfs_remove_group(&(dev->dev.kobj), &mesh_ie_group);
 }
+
+
+
+/***************************************************************************
+ * Ethtool related
+ */
+
+static const char *mesh_stat_strings[] = {
+			"drop_duplicate_bcast",
+			"drop_ttl_zero",
+			"drop_no_fwd_route",
+			"drop_no_buffers",
+			"fwded_unicast_cnt",
+			"fwded_bcast_cnt",
+			"drop_blind_table",
+			"tx_failed_cnt"
+};
+
+void lbs_mesh_ethtool_get_stats(struct net_device *dev,
+	struct ethtool_stats *stats, uint64_t *data)
+{
+	struct lbs_private *priv = dev->ml_priv;
+	struct cmd_ds_mesh_access mesh_access;
+	int ret;
+
+	lbs_deb_enter(LBS_DEB_ETHTOOL);
+
+	/* Get Mesh Statistics */
+	ret = lbs_mesh_access(priv, CMD_ACT_MESH_GET_STATS, &mesh_access);
+
+	if (ret) {
+		memset(data, 0, MESH_STATS_NUM*(sizeof(uint64_t)));
+		return;
+	}
+
+	priv->mstats.fwd_drop_rbt = le32_to_cpu(mesh_access.data[0]);
+	priv->mstats.fwd_drop_ttl = le32_to_cpu(mesh_access.data[1]);
+	priv->mstats.fwd_drop_noroute = le32_to_cpu(mesh_access.data[2]);
+	priv->mstats.fwd_drop_nobuf = le32_to_cpu(mesh_access.data[3]);
+	priv->mstats.fwd_unicast_cnt = le32_to_cpu(mesh_access.data[4]);
+	priv->mstats.fwd_bcast_cnt = le32_to_cpu(mesh_access.data[5]);
+	priv->mstats.drop_blind = le32_to_cpu(mesh_access.data[6]);
+	priv->mstats.tx_failed_cnt = le32_to_cpu(mesh_access.data[7]);
+
+	data[0] = priv->mstats.fwd_drop_rbt;
+	data[1] = priv->mstats.fwd_drop_ttl;
+	data[2] = priv->mstats.fwd_drop_noroute;
+	data[3] = priv->mstats.fwd_drop_nobuf;
+	data[4] = priv->mstats.fwd_unicast_cnt;
+	data[5] = priv->mstats.fwd_bcast_cnt;
+	data[6] = priv->mstats.drop_blind;
+	data[7] = priv->mstats.tx_failed_cnt;
+
+	lbs_deb_enter(LBS_DEB_ETHTOOL);
+}
+
+int lbs_mesh_ethtool_get_sset_count(struct net_device *dev, int sset)
+{
+	struct lbs_private *priv = dev->ml_priv;
+
+	if (sset == ETH_SS_STATS && dev == priv->mesh_dev)
+		return MESH_STATS_NUM;
+
+	return -EOPNOTSUPP;
+}
+
+void lbs_mesh_ethtool_get_strings(struct net_device *dev,
+	uint32_t stringset, uint8_t *s)
+{
+	int i;
+
+	lbs_deb_enter(LBS_DEB_ETHTOOL);
+
+	switch (stringset) {
+	case ETH_SS_STATS:
+		for (i = 0; i < MESH_STATS_NUM; i++) {
+			memcpy(s + i * ETH_GSTRING_LEN,
+					mesh_stat_strings[i],
+					ETH_GSTRING_LEN);
+		}
+		break;
+	}
+	lbs_deb_enter(LBS_DEB_ETHTOOL);
+}

-- 
http://www.holgerschurig.de
