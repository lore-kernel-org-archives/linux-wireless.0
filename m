Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:15329 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932736Ab1JNLFc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 07:05:32 -0400
From: Daniel Drake <dsd@laptop.org>
To: linville@tuxdriver.com
To: dcbw@redhat.com
Cc: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
Subject: [PATCH] libertas: fix changing interface type when interface is down
Message-Id: <20111014110526.74BCC9D401E@zog.reactivated.net> (sfid-20111014_130558_839445_5F5559A6)
Date: Fri, 14 Oct 2011 12:05:26 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The recent changes to only power the device when the interface up
introduced a bug: changing interface type, legal when the interface
is down, performs device I/O.

Fix this functionality by validating and recording the interface
type when the change is requested, but only applying the change
if/when the interface is brought up.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/libertas/cfg.c  |   20 ++++++--------------
 drivers/net/wireless/libertas/decl.h |    2 ++
 drivers/net/wireless/libertas/main.c |   32 ++++++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 610bfce..ff63782 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -1666,28 +1666,20 @@ static int lbs_change_intf(struct wiphy *wiphy, struct net_device *dev,
 	if (dev == priv->mesh_dev)
 		return -EOPNOTSUPP;
 
-	lbs_deb_enter(LBS_DEB_CFG80211);
-
 	switch (type) {
 	case NL80211_IFTYPE_MONITOR:
-		ret = lbs_set_monitor_mode(priv, 1);
-		break;
 	case NL80211_IFTYPE_STATION:
-		if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR)
-			ret = lbs_set_monitor_mode(priv, 0);
-		if (!ret)
-			ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_BSS_TYPE, 1);
-		break;
 	case NL80211_IFTYPE_ADHOC:
-		if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR)
-			ret = lbs_set_monitor_mode(priv, 0);
-		if (!ret)
-			ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_BSS_TYPE, 2);
 		break;
 	default:
-		ret = -ENOTSUPP;
+		return -EOPNOTSUPP;
 	}
 
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	if (priv->iface_running)
+		ret = lbs_set_iface_type(priv, type);
+
 	if (!ret)
 		priv->wdev->iftype = type;
 
diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index 9304e6f..bc951ab 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -9,6 +9,7 @@
 
 #include <linux/netdevice.h>
 #include <linux/firmware.h>
+#include <linux/nl80211.h>
 
 /* Should be terminated by a NULL entry */
 struct lbs_fw_table {
@@ -45,6 +46,7 @@ void lbs_host_to_card_done(struct lbs_private *priv);
 
 int lbs_start_iface(struct lbs_private *priv);
 int lbs_stop_iface(struct lbs_private *priv);
+int lbs_set_iface_type(struct lbs_private *priv, enum nl80211_iftype type);
 
 int lbs_rtap_supported(struct lbs_private *priv);
 
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 6a32623..f78afd7 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -99,6 +99,32 @@ u8 lbs_data_rate_to_fw_index(u32 rate)
 	return 0;
 }
 
+int lbs_set_iface_type(struct lbs_private *priv, enum nl80211_iftype type)
+{
+	int ret = 0;
+
+	switch (type) {
+	case NL80211_IFTYPE_MONITOR:
+		ret = lbs_set_monitor_mode(priv, 1);
+		break;
+	case NL80211_IFTYPE_STATION:
+		if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR)
+			ret = lbs_set_monitor_mode(priv, 0);
+		if (!ret)
+			ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_BSS_TYPE, 1);
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR)
+			ret = lbs_set_monitor_mode(priv, 0);
+		if (!ret)
+			ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_BSS_TYPE, 2);
+		break;
+	default:
+		ret = -ENOTSUPP;
+	}
+	return ret;
+}
+
 int lbs_start_iface(struct lbs_private *priv)
 {
 	struct cmd_ds_802_11_mac_address cmd;
@@ -120,6 +146,12 @@ int lbs_start_iface(struct lbs_private *priv)
 		goto err;
 	}
 
+	ret = lbs_set_iface_type(priv, priv->wdev->iftype);
+	if (ret) {
+		lbs_deb_net("set iface type failed\n");
+		goto err;
+	}
+
 	lbs_update_channel(priv);
 
 	priv->iface_running = true;
-- 
1.7.6.4

