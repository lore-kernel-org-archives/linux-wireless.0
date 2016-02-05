Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:24827 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbcBEFqs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2016 00:46:48 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH] staging: wilc1000: Fix compilation error when CONFIG_PM disabled
Date: Fri, 5 Feb 2016 14:40:27 +0900
Message-ID: <1454650827-24961-1-git-send-email-glen.lee@atmel.com> (sfid-20160205_064652_371069_CC916D41)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 73584a40d748 ("staging: wilc1000: add ops resuem/suspend/wakeup in
cfg80211") causes following compilation error. This patch fixes this by
using suspend/resume under CONFIG_PM.

drivers/staging/wilc1000/wilc_wfi_cfgoperations.c: In function
'wilc_create_wiphy':
>> drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2833:13: error:
'struct wiphy' has no member named 'wowlan'
     wdev->wiphy->wowlan = &wowlan_support;

Fixes: 73584a40d748 ("staging: wilc1000: add ops resuem/suspend/wakeup in cfg80211")
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_sdio.c              | 4 ++++
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 9 ++++++++-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     | 2 ++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 7c20c8c..26cc9c3 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -162,6 +162,7 @@ static int sdio_reset(struct wilc *wilc)
 	return 0;
 }
 
+#ifdef CONFIG_PM
 static int wilc_sdio_suspend(struct device *dev)
 {
 	struct sdio_func *func = dev_to_sdio_func(dev);
@@ -210,15 +211,18 @@ static const struct dev_pm_ops wilc_sdio_pm_ops = {
 	.suspend = wilc_sdio_suspend,
 	.resume = wilc_sdio_resume,
 };
+#endif
 
 static struct sdio_driver wilc1000_sdio_driver = {
 	.name		= SDIO_MODALIAS,
 	.id_table	= wilc_sdio_ids,
 	.probe		= linux_sdio_probe,
 	.remove		= linux_sdio_remove,
+#ifdef CONFIG_PM
 	.drv = {
 		.pm = &wilc_sdio_pm_ops,
 	}
+#endif
 };
 module_driver(wilc1000_sdio_driver,
 	      sdio_register_driver,
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index a899b37..a4a6bb8 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -74,9 +74,11 @@ static const struct ieee80211_txrx_stypes
 	}
 };
 
+#ifdef CONFIG_PM
 static const struct wiphy_wowlan_support wowlan_support = {
 	.flags = WIPHY_WOWLAN_ANY
 };
+#endif
 
 #define WILC_WFI_DWELL_PASSIVE 100
 #define WILC_WFI_DWELL_ACTIVE  40
@@ -2407,6 +2409,7 @@ static int del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
 static int wilc_suspend(struct wiphy *wiphy, struct cfg80211_wowlan *wow)
 {
 	struct wilc_priv *priv = wiphy_priv(wiphy);
@@ -2436,6 +2439,7 @@ static void wilc_set_wakeup(struct wiphy *wiphy, bool enabled)
 
 	netdev_info(vif->ndev, "cfg set wake up = %d\n", enabled);
 }
+#endif
 
 static int set_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
 			enum nl80211_tx_power_setting type, int mbm)
@@ -2504,10 +2508,11 @@ static struct cfg80211_ops wilc_cfg80211_ops = {
 	.mgmt_frame_register = wilc_mgmt_frame_register,
 	.set_power_mgmt = set_power_mgmt,
 	.set_cqm_rssi_config = set_cqm_rssi_config,
-
+#ifdef CONFIG_PM
 	.suspend = wilc_suspend,
 	.resume = wilc_resume,
 	.set_wakeup = wilc_set_wakeup,
+#endif
 	.set_tx_power = set_tx_power,
 	.get_tx_power = get_tx_power,
 
@@ -2591,7 +2596,9 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net, struct device *de
 	sema_init(&(priv->SemHandleUpdateStats), 1);
 	priv->wdev = wdev;
 	wdev->wiphy->max_scan_ssids = MAX_NUM_PROBED_SSID;
+#ifdef CONFIG_PM
 	wdev->wiphy->wowlan = &wowlan_support;
+#endif
 	wdev->wiphy->max_num_pmkids = WILC_MAX_NUM_PMKIDS;
 	PRINT_INFO(CFG80211_DBG, "Max number of PMKIDs = %d\n", wdev->wiphy->max_num_pmkids);
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 3077f5d4..39b72cd 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -215,7 +215,9 @@ struct wilc {
 	const struct firmware *firmware;
 
 	struct device *dev;
+#ifdef CONFIG_PM
 	bool suspend_event;
+#endif
 
 	struct rf_info dummy_statistics;
 };
-- 
1.9.1

