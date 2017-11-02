Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:54494 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755759AbdKBO2k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Nov 2017 10:28:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Karun Eagalapati <karun256@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rsi: sdio: fix building without CONFIG_PM
Date: Thu,  2 Nov 2017 15:28:07 +0100
Message-Id: <20171102142827.773188-1-arnd@arndb.de> (sfid-20171102_152901_255794_37FAFE68)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The addition of the WoWLAN support has caused a number of new
build errors when CONFIG_PM is disabled, including:

drivers/net/wireless/rsi/rsi_91x_mac80211.c: In function 'rsi_wow_map_triggers':
drivers/net/wireless/rsi/rsi_91x_mac80211.c:1773:19: error: 'RSI_WOW_ANY' undeclared (first use in this function); did you mean 'RSI_WEP_KEY'?
drivers/net/wireless/rsi/rsi_91x_mac80211.c: In function 'rsi_mac80211_attach':
drivers/net/wireless/rsi/rsi_91x_mac80211.c:1980:7: error: 'struct wiphy' has no member named 'wowlan'

This adds more #ifdef CONFIG_PM guards around the code that otherwise
fails to build and that we know is not used without CONFIG_PM.

Fixes: f3ac4e7394a1 ("rsi: sdio: add WOWLAN support for S3 suspend state")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 4 +++-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 36c63e953f84..ba6405c7d92b 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -1752,6 +1752,7 @@ static int rsi_mac80211_cancel_roc(struct ieee80211_hw *hw)
 	return 0;
 }
 
+#ifdef CONFIG_PM
 static const struct wiphy_wowlan_support rsi_wowlan_support = {
 	.flags = WIPHY_WOWLAN_ANY |
 		 WIPHY_WOWLAN_MAGIC_PKT |
@@ -1824,7 +1825,6 @@ int rsi_config_wowlan(struct rsi_hw *adapter, struct cfg80211_wowlan *wowlan)
 }
 EXPORT_SYMBOL(rsi_config_wowlan);
 
-#ifdef CONFIG_PM
 static int rsi_mac80211_suspend(struct ieee80211_hw *hw,
 				struct cfg80211_wowlan *wowlan)
 {
@@ -1977,7 +1977,9 @@ int rsi_mac80211_attach(struct rsi_common *common)
 	wiphy->features |= NL80211_FEATURE_INACTIVITY_TIMER;
 	wiphy->reg_notifier = rsi_reg_notify;
 
+#ifdef CONFIG_PM
 	wiphy->wowlan = &rsi_wowlan_support;
+#endif
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
 
 	/* Wi-Fi direct parameters */
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index d38a09f15742..46c9d5470dfb 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1597,6 +1597,7 @@ static int rsi_send_beacon(struct rsi_common *common)
 	return 0;
 }
 
+#ifdef CONFIG_PM
 int rsi_send_wowlan_request(struct rsi_common *common, u16 flags,
 			    u16 sleep_status)
 {
@@ -1630,6 +1631,7 @@ int rsi_send_wowlan_request(struct rsi_common *common, u16 flags,
 
 	return rsi_send_internal_mgmt_frame(common, skb);
 }
+#endif
 
 /**
  * rsi_handle_ta_confirm_type() - This function handles the confirm frames.
-- 
2.9.0
