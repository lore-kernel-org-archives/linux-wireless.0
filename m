Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33209 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753159AbdHKNpu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Aug 2017 09:45:50 -0400
Received: by mail-pf0-f194.google.com with SMTP id c65so3549651pfl.0
        for <linux-wireless@vger.kernel.org>; Fri, 11 Aug 2017 06:45:50 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 01/11] rsi: advertise ap mode support
Date: Fri, 11 Aug 2017 19:11:19 +0530
Message-Id: <1502458889-9690-2-git-send-email-amitkarwar@gmail.com> (sfid-20170811_154754_359965_C255D19F)
In-Reply-To: <1502458889-9690-1-git-send-email-amitkarwar@gmail.com>
References: <1502458889-9690-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

AP mode support is advertised to cfg80211. Necessary wiphy
parameters are initialized.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 28 +++++++++++++++++++++++++++-
 drivers/net/wireless/rsi/rsi_main.h         | 10 ++++++++++
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 210ad79..2da5493 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -122,6 +122,23 @@ const u16 rsi_mcsrates[8] = {
 	RSI_RATE_MCS4, RSI_RATE_MCS5, RSI_RATE_MCS6, RSI_RATE_MCS7
 };
 
+static const u32 rsi_max_ap_stas[16] = {
+	32,	/* 1 - Wi-Fi alone */
+	0,	/* 2 */
+	0,	/* 3 */
+	0,	/* 4 - BT EDR alone */
+	4,	/* 5 - STA + BT EDR */
+	32,	/* 6 - AP + BT EDR */
+	0,	/* 7 */
+	0,	/* 8 - BT LE alone */
+	4,	/* 9 - STA + BE LE */
+	0,	/* 10 */
+	0,	/* 11 */
+	0,	/* 12 */
+	1,	/* 13 - STA + BT Dual */
+	4,	/* 14 - AP + BT Dual */
+};
+
 /**
  * rsi_is_cipher_wep() -  This function determines if the cipher is WEP or not.
  * @common: Pointer to the driver private structure.
@@ -1348,7 +1365,8 @@ int rsi_mac80211_attach(struct rsi_common *common)
 	SET_IEEE80211_PERM_ADDR(hw, common->mac_addr);
 	ether_addr_copy(hw->wiphy->addr_mask, addr_mask);
 
-	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+				 BIT(NL80211_IFTYPE_AP);
 	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 	wiphy->retry_short = RETRY_SHORT;
 	wiphy->retry_long  = RETRY_LONG;
@@ -1363,6 +1381,14 @@ int rsi_mac80211_attach(struct rsi_common *common)
 	wiphy->bands[NL80211_BAND_5GHZ] =
 		&adapter->sbands[NL80211_BAND_5GHZ];
 
+	/* AP Parameters */
+	wiphy->max_ap_assoc_sta = rsi_max_ap_stas[common->oper_mode - 1];
+	common->max_stations = wiphy->max_ap_assoc_sta;
+	rsi_dbg(ERR_ZONE, "Max Stations Allowed = %d\n", common->max_stations);
+	hw->sta_data_size = sizeof(struct rsi_sta);
+	wiphy->flags = WIPHY_FLAG_REPORTS_OBSS;
+	wiphy->flags |= WIPHY_FLAG_AP_UAPSD;
+	wiphy->features |= NL80211_FEATURE_INACTIVITY_TIMER;
 	wiphy->reg_notifier = rsi_reg_notify;
 
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index d05b5e0..0077888 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -21,6 +21,13 @@
 #include <linux/skbuff.h>
 #include <net/mac80211.h>
 
+struct rsi_sta {
+	struct ieee80211_sta *sta;
+	s16 sta_id;
+	u16 seq_start[IEEE80211_NUM_TIDS];
+	bool start_tx_aggr[IEEE80211_NUM_TIDS];
+};
+
 struct rsi_hw;
 
 #include "rsi_ps.h"
@@ -253,6 +260,9 @@ struct rsi_common {
 
 	u16 beacon_interval;
 	u8 dtim_cnt;
+
+	/* AP mode parameters */
+	int max_stations;
 };
 
 enum host_intf {
-- 
2.7.4
