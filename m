Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:52393 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932750AbcALHgR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2016 02:36:17 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 06/26] staging: wilc1000: add ops resuem/suspend/wakeup in cfg80211
Date: Tue, 12 Jan 2016 16:39:35 +0900
Message-ID: <1452584395-24910-7-git-send-email-glen.lee@atmel.com> (sfid-20160112_083620_213718_62B41823)
In-Reply-To: <1452584395-24910-1-git-send-email-glen.lee@atmel.com>
References: <1452584395-24910-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds ops resume, suspend and set_wakeup in cfg80211. Together with
previous patches, driver will support suspend/resume functionality.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 39 +++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 53fb2d4..b9c3564 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -74,6 +74,10 @@ static const struct ieee80211_txrx_stypes
 	}
 };
 
+static const struct wiphy_wowlan_support wowlan_support = {
+	.flags = WIPHY_WOWLAN_ANY
+};
+
 #define WILC_WFI_DWELL_PASSIVE 100
 #define WILC_WFI_DWELL_ACTIVE  40
 
@@ -2673,6 +2677,36 @@ static int del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 	return 0;
 }
 
+static int wilc_suspend(struct wiphy *wiphy, struct cfg80211_wowlan *wow)
+{
+	struct wilc_priv *priv = wiphy_priv(wiphy);
+	struct wilc_vif *vif = netdev_priv(priv->dev);
+
+	if(!wow && wilc_wlan_get_num_conn_ifcs(vif->wilc))
+		vif->wilc->suspend_event = true;
+	else
+		vif->wilc->suspend_event = false;
+
+	return 0;
+}
+
+static int wilc_resume(struct wiphy *wiphy)
+{
+	struct wilc_priv *priv = wiphy_priv(wiphy);
+	struct wilc_vif *vif = netdev_priv(priv->dev);
+
+	netdev_info(vif->ndev, "cfg resume\n");
+	return 0;
+}
+
+static void wilc_set_wakeup(struct wiphy *wiphy, bool enabled)
+{
+	struct wilc_priv *priv = wiphy_priv(wiphy);
+	struct wilc_vif *vif = netdev_priv(priv->dev);
+
+	netdev_info(vif->ndev, "cfg set wake up = %d\n", enabled);
+}
+
 static struct cfg80211_ops wilc_cfg80211_ops = {
 	.set_monitor_channel = set_channel,
 	.scan = scan,
@@ -2708,6 +2742,10 @@ static struct cfg80211_ops wilc_cfg80211_ops = {
 	.set_power_mgmt = set_power_mgmt,
 	.set_cqm_rssi_config = set_cqm_rssi_config,
 
+	.suspend = wilc_suspend,
+	.resume = wilc_resume,
+	.set_wakeup = wilc_set_wakeup,
+
 };
 
 int WILC_WFI_update_stats(struct wiphy *wiphy, u32 pktlen, u8 changed)
@@ -2792,6 +2830,7 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net, struct device *de
 	sema_init(&(priv->SemHandleUpdateStats), 1);
 	priv->wdev = wdev;
 	wdev->wiphy->max_scan_ssids = MAX_NUM_PROBED_SSID;
+	wdev->wiphy->wowlan = &wowlan_support;
 	wdev->wiphy->max_num_pmkids = WILC_MAX_NUM_PMKIDS;
 	PRINT_INFO(CFG80211_DBG, "Max number of PMKIDs = %d\n", wdev->wiphy->max_num_pmkids);
 
-- 
1.9.1

