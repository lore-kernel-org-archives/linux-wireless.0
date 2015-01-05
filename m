Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:57586 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbbAEN0n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2015 08:26:43 -0500
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH] mac80211_hwsim: Add support for TDLS channel switch
Date: Mon,  5 Jan 2015 02:27:14 -0500
Message-Id: <1420442834-6562-1-git-send-email-ilan.peer@intel.com> (sfid-20150105_143403_298116_9EF587E5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Indicate support for TDLS channel switch, and add basic implementation
for the required callbacks.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 46 ++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ef58a88..2011fe8 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2070,6 +2070,46 @@ static void mac80211_hwsim_get_et_stats(struct ieee80211_hw *hw,
 	WARN_ON(i != MAC80211_HWSIM_SSTATS_LEN);
 }
 
+static int mac80211_hwsim_tdls_channel_switch(struct ieee80211_hw *hw,
+					      struct ieee80211_vif *vif,
+					      struct ieee80211_sta *sta,
+					      u8 oper_class,
+					      struct cfg80211_chan_def *chandef,
+					      struct sk_buff *tmpl_skb,
+					      u32 ch_sw_tm_ie)
+{
+	hwsim_check_magic(vif);
+	hwsim_check_sta_magic(sta);
+	wiphy_debug(hw->wiphy,
+		    "TDLS channel switch (%pM) enabled: freq=%d w=%d cfreqs=%d, %d\n",
+		    sta->addr,
+		    chandef->chan->center_freq, chandef->width,
+		    chandef->center_freq1, chandef->center_freq2);
+	return 0;
+}
+
+static void mac80211_hwsim_tdls_cancel_channel_switch(struct ieee80211_hw *hw,
+						      struct ieee80211_vif *vif,
+						      struct ieee80211_sta *sta)
+{
+	hwsim_check_magic(vif);
+	hwsim_check_sta_magic(sta);
+	wiphy_debug(hw->wiphy,
+		    "TDLS channel switch (%pM) disabled\n", sta->addr);
+}
+
+static void
+mac80211_hwsim_tdls_recv_channel_switch(struct ieee80211_hw *hw,
+					struct ieee80211_vif *vif,
+					struct ieee80211_tdls_ch_sw_params *pa)
+{
+	hwsim_check_magic(vif);
+	hwsim_check_sta_magic(pa->sta);
+	wiphy_debug(hw->wiphy,
+		    "TDLS channel recv channel switch from (%pM), status=%u\n",
+		    pa->sta->addr, pa->status);
+}
+
 static const struct ieee80211_ops mac80211_hwsim_ops = {
 	.tx = mac80211_hwsim_tx,
 	.start = mac80211_hwsim_start,
@@ -2096,6 +2136,9 @@ static const struct ieee80211_ops mac80211_hwsim_ops = {
 	.get_et_sset_count = mac80211_hwsim_get_et_sset_count,
 	.get_et_stats = mac80211_hwsim_get_et_stats,
 	.get_et_strings = mac80211_hwsim_get_et_strings,
+	.tdls_channel_switch = mac80211_hwsim_tdls_channel_switch,
+	.tdls_cancel_channel_switch = mac80211_hwsim_tdls_cancel_channel_switch,
+	.tdls_recv_channel_switch = mac80211_hwsim_tdls_recv_channel_switch,
 };
 
 static struct ieee80211_ops mac80211_hwsim_mchan_ops;
@@ -2335,7 +2378,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 			       NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE |
 			       NL80211_FEATURE_STATIC_SMPS |
 			       NL80211_FEATURE_DYNAMIC_SMPS |
-			       NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
+			       NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR |
+			       NL80211_FEATURE_TDLS_CHANNEL_SWITCH;
 
 	/* ask mac80211 to reserve space for magic */
 	hw->vif_data_size = sizeof(struct hwsim_vif_priv);
-- 
1.8.3.2

