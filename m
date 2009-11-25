Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65388 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbZKYQaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 11:30:12 -0500
Received: from [192.168.0.100] (unknown [78.42.107.241])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by stinky.trash.net (Postfix) with ESMTPSA id C6E97B2C51
	for <linux-wireless@vger.kernel.org>; Wed, 25 Nov 2009 17:18:51 +0100 (MET)
Message-ID: <4B0D58EA.8060304@trash.net>
Date: Wed, 25 Nov 2009 17:18:50 +0100
From: Patrick McHardy <kaber@trash.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: RFC: mac80211: add ethtool support
Content-Type: multipart/mixed;
 boundary="------------090309020302040308070608"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090309020302040308070608
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

If people find this useful, I'll go through the other wireless drivers
and add the drvname field.


--------------090309020302040308070608
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

commit 7ac460f6b6deb95955f008eb94a7a81ee4d9d2d9
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed Nov 25 17:16:56 2009 +0100

    mac80211: add ethtool support
    
    Add ethtool support and add a drvname field to struct ieee80211_ops, which is
    used for ethtool driver information. This is useful with multiple different
    wireless cards to find out which device is using which driver.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a4c086f..94f8a2c 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -256,6 +256,7 @@ static void ath5k_sw_scan_start(struct ieee80211_hw *hw);
 static void ath5k_sw_scan_complete(struct ieee80211_hw *hw);
 
 static const struct ieee80211_ops ath5k_hw_ops = {
+	.drvname	= "ath5k",
 	.tx 		= ath5k_tx,
 	.start 		= ath5k_start,
 	.stop 		= ath5k_stop,
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 0db9b79..a0df4ee 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3855,6 +3855,7 @@ static struct attribute_group iwl3945_attribute_group = {
 };
 
 static struct ieee80211_ops iwl3945_hw_ops = {
+	.drvname = "iwl3945",
 	.tx = iwl3945_mac_tx,
 	.start = iwl3945_mac_start,
 	.stop = iwl3945_mac_stop,
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3754ea4..971db98 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1530,6 +1530,7 @@ struct ieee80211_ops {
 #ifdef CONFIG_NL80211_TESTMODE
 	int (*testmode_cmd)(struct ieee80211_hw *hw, void *data, int len);
 #endif
+	const char *drvname;
 };
 
 /**
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 1bf12a2..7c1ceee 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -664,10 +664,27 @@ static const struct net_device_ops ieee80211_monitorif_ops = {
 	.ndo_set_mac_address 	= eth_mac_addr,
 };
 
+static void ieee80211_get_drvinfo(struct net_device *dev,
+				  struct ethtool_drvinfo *drvinfo)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+
+	if (local->ops->drvname != NULL)
+		snprintf(drvinfo->driver, sizeof(drvinfo->driver),
+			 local->ops->drvname);
+}
+
+static const struct ethtool_ops ieee80211_ethtool_ops = {
+	.get_link		= ethtool_op_get_link,
+	.get_drvinfo		= ieee80211_get_drvinfo,
+};
+
 static void ieee80211_if_setup(struct net_device *dev)
 {
 	ether_setup(dev);
 	dev->netdev_ops = &ieee80211_dataif_ops;
+	dev->ethtool_ops = &ieee80211_ethtool_ops;
 	dev->destructor = free_netdev;
 }
 

--------------090309020302040308070608--
