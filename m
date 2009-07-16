Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:47921 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743AbZGPJdL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 05:33:11 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 03/10] iwmc3200wifi: set cipher_suites before registering wiphy
Date: Thu, 16 Jul 2009 17:34:08 +0800
Message-Id: <1247736854-6760-4-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1247736854-6760-3-git-send-email-yi.zhu@intel.com>
References: <1247736854-6760-1-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-2-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-3-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need to specify all the cipher suites we supported. Otherwise
cfg80211_validate_key_settings() will fail when we are setting
keys.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/cfg80211.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.c b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
index 54bebba..0aa3895 100644
--- a/drivers/net/wireless/iwmc3200wifi/cfg80211.c
+++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
@@ -558,6 +558,13 @@ static struct cfg80211_ops iwm_cfg80211_ops = {
 	.set_power_mgmt = iwm_cfg80211_set_power_mgmt,
 };
 
+static const u32 cipher_suites[] = {
+	WLAN_CIPHER_SUITE_WEP40,
+	WLAN_CIPHER_SUITE_WEP104,
+	WLAN_CIPHER_SUITE_TKIP,
+	WLAN_CIPHER_SUITE_CCMP,
+};
+
 struct wireless_dev *iwm_wdev_alloc(int sizeof_bus, struct device *dev)
 {
 	int ret = 0;
@@ -600,6 +607,9 @@ struct wireless_dev *iwm_wdev_alloc(int sizeof_bus, struct device *dev)
 	wdev->wiphy->bands[IEEE80211_BAND_5GHZ] = &iwm_band_5ghz;
 	wdev->wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 
+	wdev->wiphy->cipher_suites = cipher_suites;
+	wdev->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
+
 	ret = wiphy_register(wdev->wiphy);
 	if (ret < 0) {
 		dev_err(dev, "Couldn't register wiphy device\n");
-- 
1.6.0.4

