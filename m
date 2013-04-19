Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:58649 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968316Ab3DSMtQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 08:49:16 -0400
Received: by mail-wi0-f176.google.com with SMTP id hj19so757766wib.9
        for <linux-wireless@vger.kernel.org>; Fri, 19 Apr 2013 05:49:15 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH] mac80211_hwsim: handle IEEE80211_HW_SUPPORTS_RC_TABLE
Date: Fri, 19 Apr 2013 14:44:52 +0200
Message-Id: <1366375492-10979-1-git-send-email-karl.beldan@gmail.com> (sfid-20130419_144921_550151_0DC5BA43)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index b5117f5..fd30beb7 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -53,6 +53,10 @@ static bool paged_rx = false;
 module_param(paged_rx, bool, 0644);
 MODULE_PARM_DESC(paged_rx, "Use paged SKBs for RX instead of linear ones");
 
+static bool rctbl = false;
+module_param(rctbl, bool, 0444);
+MODULE_PARM_DESC(rctbl, "Handle rate control table");
+
 /**
  * enum hwsim_regtest - the type of regulatory tests we offer
  *
@@ -887,8 +891,12 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
 	if (control->sta)
 		hwsim_check_sta_magic(control->sta);
 
-	txi->rate_driver_data[0] = channel;
+	if (rctbl)
+		ieee80211_get_tx_rates(txi->control.vif, control->sta, skb,
+				       txi->control.rates,
+				       ARRAY_SIZE(txi->control.rates));
 
+	txi->rate_driver_data[0] = channel;
 	mac80211_hwsim_monitor_rx(hw, skb, channel);
 
 	/* wmediumd mode check */
@@ -990,6 +998,13 @@ static void mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
 {
 	u32 _pid = ACCESS_ONCE(wmediumd_portid);
 
+	if (rctbl) {
+		struct ieee80211_tx_info *txi = IEEE80211_SKB_CB(skb);
+		ieee80211_get_tx_rates(txi->control.vif, NULL, skb,
+				       txi->control.rates,
+				       ARRAY_SIZE(txi->control.rates));
+	}
+
 	mac80211_hwsim_monitor_rx(hw, skb, chan);
 
 	if (_pid)
@@ -1020,6 +1035,11 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 	if (skb == NULL)
 		return;
 	info = IEEE80211_SKB_CB(skb);
+	if (rctbl)
+		ieee80211_get_tx_rates(vif, NULL, skb,
+				       info->control.rates,
+				       ARRAY_SIZE(info->control.rates));
+
 	txrate = ieee80211_get_tx_rate(hw, info);
 
 	mgmt = (struct ieee80211_mgmt *) skb->data;
@@ -2277,6 +2297,8 @@ static int __init init_mac80211_hwsim(void)
 			    IEEE80211_HW_AMPDU_AGGREGATION |
 			    IEEE80211_HW_WANT_MONITOR_VIF |
 			    IEEE80211_HW_QUEUE_CONTROL;
+		if (rctbl)
+			hw->flags |= IEEE80211_HW_SUPPORTS_RC_TABLE;
 
 		hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
 				    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
-- 
1.8.2

