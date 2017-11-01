Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:56926 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752141AbdKAMTp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Nov 2017 08:19:45 -0400
Received: by mail-pg0-f68.google.com with SMTP id m18so1959950pgd.13
        for <linux-wireless@vger.kernel.org>; Wed, 01 Nov 2017 05:19:45 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 2/2] rsi: fix kbuild reported build errors with CONFIG_PM off
Date: Wed,  1 Nov 2017 17:42:45 +0530
Message-Id: <1509538365-31532-2-git-send-email-amitkarwar@gmail.com> (sfid-20171101_131948_535681_2FA561A1)
In-Reply-To: <1509538365-31532-1-git-send-email-amitkarwar@gmail.com>
References: <1509538365-31532-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

Some wowlan related code was outside CONFIG_PM flag which caused these
build errors. They are fixed by moving that code under CONFIG_PM flag.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Fixes: ef71ed0608c ("rsi: sdio: Add WOWLAN support for S5 shutdown state")
Fixes: a24e35fcee0 ("rsi: sdio: Add WOWLAN support for S4 hibernate state")
Fixes: e1ced6422a3 ("rsi: sdio: add WOWLAN support for S3 suspend state")
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 5 ++++-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 2 ++
 drivers/net/wireless/rsi/rsi_common.h       | 2 ++
 drivers/net/wireless/rsi/rsi_mgmt.h         | 2 ++
 4 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 36c63e9..32f5cb4 100644
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
@@ -1977,7 +1977,10 @@ int rsi_mac80211_attach(struct rsi_common *common)
 	wiphy->features |= NL80211_FEATURE_INACTIVITY_TIMER;
 	wiphy->reg_notifier = rsi_reg_notify;
 
+#ifdef CONFIG_PM
 	wiphy->wowlan = &rsi_wowlan_support;
+#endif
+
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
 
 	/* Wi-Fi direct parameters */
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index d38a09f..46c9d54 100644
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
diff --git a/drivers/net/wireless/rsi/rsi_common.h b/drivers/net/wireless/rsi/rsi_common.h
index 70b8b4b..d07dbba 100644
--- a/drivers/net/wireless/rsi/rsi_common.h
+++ b/drivers/net/wireless/rsi/rsi_common.h
@@ -83,7 +83,9 @@ u16 rsi_get_connected_channel(struct ieee80211_vif *vif);
 struct rsi_hw *rsi_91x_init(void);
 void rsi_91x_deinit(struct rsi_hw *adapter);
 int rsi_read_pkt(struct rsi_common *common, s32 rcv_pkt_len);
+#ifdef CONFIG_PM
 int rsi_config_wowlan(struct rsi_hw *adapter, struct cfg80211_wowlan *wowlan);
+#endif
 struct rsi_sta *rsi_find_sta(struct rsi_common *common, u8 *mac_addr);
 struct ieee80211_vif *rsi_get_vif(struct rsi_hw *adapter, u8 *mac);
 void rsi_roc_timeout(struct timer_list *t);
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 76337ce..389094a 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -668,8 +668,10 @@ int rsi_band_check(struct rsi_common *common, struct ieee80211_channel *chan);
 int rsi_send_rx_filter_frame(struct rsi_common *common, u16 rx_filter_word);
 int rsi_send_radio_params_update(struct rsi_common *common);
 int rsi_set_antenna(struct rsi_common *common, u8 antenna);
+#ifdef CONFIG_PM
 int rsi_send_wowlan_request(struct rsi_common *common, u16 flags,
 			    u16 sleep_status);
+#endif
 int rsi_send_ps_request(struct rsi_hw *adapter, bool enable,
 			struct ieee80211_vif *vif);
 #endif
-- 
2.7.4
